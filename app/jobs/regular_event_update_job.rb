class RegularEventUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    RegularEvents::Daily1UpdateJob.perform_now
    RegularEvents::Daily2UpdateJob.perform_now
    RegularEvents::Weekly1UpdateJob.perform_now
    RegularEvents::Weekly2UpdateJob.perform_now
    RegularEvents::MonthlyUpdateJob.perform_now
  end
end
