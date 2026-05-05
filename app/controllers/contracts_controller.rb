class ContractsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contract, only: [:show, :update]

  def show
    unless [@contract.freelancer_id, @contract.client_id].include?(current_user.id)
      redirect_to root_path, alert: 'Not authorized to view this contract' and return
    end
  end

  def index
    # Show contracts where user is either freelancer or client
    @contracts = Contract.where('freelancer_id = ? OR client_id = ?', current_user.id, current_user.id)
                          .includes(:job)
                          .order(created_at: :desc)
  end

  def update
    # Allow client to update contract (e.g., mark completed or cancelled)
    unless current_user.id == @contract.client_id
      redirect_to @contract, alert: 'Only the client can update the contract' and return
    end

    if @contract.update(contract_params)
      redirect_to @contract, notice: 'Contract updated'
    else
      redirect_to @contract, alert: 'Unable to update contract'
    end
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def contract_params
    params.require(:contract).permit(:status, :end_date)
  end
end
