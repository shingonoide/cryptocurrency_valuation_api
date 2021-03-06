class AssetsController < ApplicationController
  def index
    render json: Asset.where(user: current_user), status: 200
  end

  def create
    unless currency
      render json: { message: "#{params['symbol']} does not exist" }, status: :bad_request
      return
    end
    if asset
      render json: { message: "Asset for #{params['symbol']} already exists" }, status: :bad_request
      return
    end

    new_asset = Asset.new(currency: currency, user: current_user)
    if new_asset.save
      render json: new_asset, status: :created
    else
      render json: new_asset.errors, status: :unprocessable_entity
    end
  end

  def update
    unless currency
      render json: { message: "#{params['symbol']} does not exist" }, status: :bad_request
      return
    end
    unless asset
      render json: { message: "Asset for #{params['symbol']} does not exist" }, status: :bad_request
      return
    end

    if asset.update_attribute(:amount, params[:amount])
      render json: asset, status: :ok
    else
      render json: asset.errors, status: :unprocessable_entity
    end
  end

  def destroy
    unless currency
      render json: { message: "#{params['symbol']} does not exist" }, status: :bad_request
      return
    end
    unless asset
      render json: { message: "Asset for #{params['symbol']} does not exist" }, status: :bad_request
      return
    end

    asset.destroy
    head :no_content
  end

  private

  def currency
    @currency ||= Currency.find_by(symbol: params['symbol'])
  end

  def asset
    @asset ||= Asset.find_by(currency: currency, user: current_user)
  end
end
