class AssignCheckWorker
  include Sidekiq::Worker
  sidekiq_options queue: :assign, unique: :all, manual: true

  def self.lock
    "#{self.name.underscore}:lock"
  end

  # Implement method to handle lock removing manually
  def self.unlock!
    Sidekiq.redis { |conn| conn.del(self.lock) }
  end

  def perform
    Job.assigning.each do |id|
      unless Redis.current.get "job:#{id}:assigned_user_id"
        Job.assigning.delete id
        Job.waiting << id
      end
    end

    sleep 5

    self.class.unlock!
    self.class.perform_async unless Job.assigning.empty?
  end
end
