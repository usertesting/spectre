require 'image_processor'

class TestsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @test = Test.new
  end

  def update
    @test = Test.find(params[:id])
    if params[:test][:baseline] == 'true'
      @test.pass = true
      @test.save
      redirect_to project_suite_run_url(@test.run.suite.project, @test.run.suite, @test.run)
    end
  end

  def create
    @test = Test.create!(test_params)
    ProcessTestJob.perform_async(@test.id)
    render json: @test.to_json
  end

  private

  def test_params
    params.require(:test).permit(:name, :browser, :size, :screenshot, :run_id, :source_url, :fuzz_level, :highlight_colour, :crop_area)
  end
end
