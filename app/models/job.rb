class Job < ActiveRecord::Base
  include Redis::Objects
  set :waiting,   global: true
  set :assigning, global: true
  value :assigned_user_id, expiration: 30

  scope :incomplete, -> {where(finished_at: nil)}

  after_save    :set_job_queue
  after_destroy :clear_job_queue

  def set_job_queue
    if self.finished_at
      self.waiting.delete self.id
    else
      self.waiting << self.id
    end
    self.assigning.delete self.id
  end

  def clear_job_queue
    self.waiting.delete self.id
    self.assigning.delete self.id
  end

  def self.get user_id
    id = self.waiting.pop
    if id
      self.assigning << id
      job = self.find id
      job.assigned_user_id = user_id
      AssignCheckWorker.perform_async
      job
    end
  end

  def permit_user? user_id
    p user_id
    p self.assigned_user_id.value
    self.assigned_user_id.value == user_id.to_s
  end

end
