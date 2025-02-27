class BlogController < ApplicationController
  def index
    @articles = load_articles
  end

  def show
    @article = load_articles.find { |article| article['slug'] == params[:slug] }
    
    if @article.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  private

  def load_articles
    JSON.parse(File.read(Rails.root.join('db', 'data.json')))
  end
end
