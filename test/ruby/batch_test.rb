require_relative '../test_helper'

class Ruby::BatchTest < Minitest::Test
  def test_batches
    batch = Ruby::Batch.new(7, 0.1)
    x = 0
    100.times do
      object = (x += 1)
      batch.batch(object) do |ints|
        puts "Ints: #{ints}"
      end
    end
    batch.wait
  end
end
