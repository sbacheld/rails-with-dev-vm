class TestController < ApplicationController
  def index
    tests = TestTable.all
    render json: tests
  end
end
