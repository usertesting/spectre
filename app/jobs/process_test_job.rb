require 'image_processor'

class ProcessTestJob < ApplicationJob
  def perform(test_id)
    test = Test.find(test_id)
    tempfile = test.screenshot.tempfile

    begin
      ImageProcessor.crop(tempfile.path, test.crop_area) if test.crop_area
      ScreenshotComparison.new(test, tempfile)
    ensure
      tempfile.close
      tempfile.unlink
    end
  end
end
