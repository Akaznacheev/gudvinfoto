class DeleteBooks
  include Delayed::RecurringJob
  run_every 1.day
  run_at '00:00'
  timezone 'Moscow'
  queue 'slow-jobs'
  def perform
    # write something which work
  end
end
