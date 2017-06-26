require 'image_processor'

class PurgeOldRunsJob < ApplicationJob
  def perform(suite_id)
    Suite.find(suite_id).runs.order(id: :desc).offset(5).destroy_all
  end
end
