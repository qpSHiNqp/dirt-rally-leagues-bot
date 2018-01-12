class LeaguesController < ApplicationController
  before_action :set_league, only: [:show]
  def index
    @leagues = League.all
  end

  def show
  end

  private
  def set_league
    @league = League.find_by!(team_id: params[:id])
  end
end
