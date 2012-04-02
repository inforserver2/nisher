#encoding: UTF-8
class NewsController < ApplicationController
  def create
    @news=News.new
    @news.email=params[:new_email]
    if @news.save
      flash[:success] = "O email #{@news.email} foi cadastrado em nosso banco de dados."
    else
      flash[:notice] = "Erros: #{@news.errors.full_messages.to_sentence}"
    end
    redirect_to :back
  end
end
