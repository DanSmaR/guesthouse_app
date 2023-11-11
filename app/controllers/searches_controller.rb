class SearchesController < ApplicationController
  def index
  #
  end

  def guesthouses_by_city
    @query = params[:city]
    return redirect_back(fallback_location: root_path,
                         alert: 'Selecione uma cidade para busca') if @query.blank?
    @guesthouses = Guesthouse.search_by_city(@query)
    render :results
  end

  def guesthouses_general
    @query = params[:query]
    return redirect_back(fallback_location: root_path,
    alert: 'Termo para pesquisa está vazio') if @query.blank?
    @guesthouses = Guesthouse.search_general(@query)
    render :results
  end

  def guesthouses_advanced
    @query = params[:query_advanced]
    @options = params[:options]
    @guesthouses = Guesthouse.search_advanced(@query, @options)
    render :results
  end
end