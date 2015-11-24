require 'ruby/batch/version'
require 'concurrent'

module Ruby
  class Batch
    # @return [Concurrent::ScheduledTask]
    attr_accessor :scheduled_task

    attr_accessor :objects, :delay, :max_objects

    def initialize(max_objects, delay)
      @max_objects = max_objects
      @delay = delay
      @objects = []
      @scheduled_task = nil
    end

    def batch(object)
      objects << object
      if scheduled_task.nil? || scheduled_task.complete?
        @scheduled_task = Concurrent::ScheduledTask.execute(delay) do
          task_objects = objects
          @objects = []
          yield task_objects
        end
      end
      if objects.length >= max_objects
        @scheduled_task.process_task
      end
    end

    def wait
      scheduled_task.wait unless scheduled_task.nil?
    end
  end
end
