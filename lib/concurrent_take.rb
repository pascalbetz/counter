class ProductConsumer
  attr_reader :product_class, :product_id, :amount, :name
  def initialize(product_class, product_id, amount, name)
    @product_class = product_class
    @product_id = product_id
    @amount = amount
    @name = name
  end

  def run
    amount.times do
      begin
        product.take!
      rescue ActiveRecord::StaleObjectError
        retry # retry if stale
      rescue ActiveRecord::RecordInvalid
        # ignore, a validation failed
      rescue ActiveRecord::StatementInvalid
        # ignore, a db check failed
      end

    end
  end

  private
  def product
    product_class.find(product_id)
  end
end

class Taker
  attr_reader :klasses, :thread_count, :take_per_thread, :available

  def initialize
    Thread.abort_on_exception = true
    ActiveRecord::Base.logger.level = 1

    @klasses = [SimpleProduct, OptimisticProduct, PessimisticProduct, DbCheckProduct, ArDecrementProduct]
    @thread_count = 10
    @take_per_thread = 200
    @available = 1000
  end


  def run
    Benchmark.bm do |x|
      klasses.each do |klass|
        x.report(klass.name) do
          puts "Create #{klass} with #{available}, start #{thread_count} thread(s) and have each thread take #{take_per_thread}"
          product = klass.create!(available: available)

          threads = thread_count.times.map do |index|
            consumer = ProductConsumer.new(klass, product.id, take_per_thread, "Consumer #{index}")
            Thread.new { consumer.run }
          end

          threads.each(&:join)

          available_after_take = product.reload.available
          take_expected = [thread_count * take_per_thread, available].min
          available_expected = available - take_expected

          puts "Done #{klass}. Available: #{available}, Took: #{take_expected}, expected: #{available_expected}, actually: #{available_after_take}, difference: #{available_after_take - available_expected}"
          product.reload.destroy
        end
      end
    end
    nil
  end
end
