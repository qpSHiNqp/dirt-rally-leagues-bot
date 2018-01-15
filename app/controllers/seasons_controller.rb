class SeasonsController < ApplicationController
  before_action :set_season, only: [:show]
  # GET /seasons/1
  def show
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_season
      @season = Season.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def season_params
      params.fetch(:season, {})
    end
end
