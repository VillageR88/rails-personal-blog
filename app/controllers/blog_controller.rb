class BlogController < ApplicationController
  def index
    @articles = JSON.parse(File.read(Rails.root.join('db', 'data.json')))
  end
end
