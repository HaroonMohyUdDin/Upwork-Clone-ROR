class ContractsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contract, only: [:show, :update, :complete, :cancel]
  before_action :authorize_contract_participant!, only: [:show]
  before_action :authorize_contract_client!, only: [:update, :complete, :cancel]

  def index
    @contracts = Contract.where(
      "client_id = ? OR freelancer_id = ?", current_user.id, current_user.id
    ).includes(:freelancer, :client, :job).order(created_at: :desc)
  end

  def show
  end

  def update
    if @contract.update(contract_params)
      redirect_to contract_path(@contract), notice: "Contract updated successfully"
    else
      redirect_to contract_path(@contract), alert: "Unable to update contract"
    end
  end

  def complete
    if @contract.update(status: :completed)
      redirect_to contract_path(@contract), notice: "Contract marked as completed"
    else
      redirect_to contract_path(@contract), alert: "Unable to complete contract"
    end
  end

  def cancel
    if @contract.update(status: :cancelled)
      redirect_to contract_path(@contract), notice: "Contract cancelled"
    else
      redirect_to contract_path(@contract), alert: "Unable to cancel contract"
    end
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def authorize_contract_participant!
    is_participant = [@contract.client_id, @contract.freelancer_id].include?(current_user.id)
    redirect_to contracts_path, alert: "Not authorized" unless is_participant
  end

  def authorize_contract_client!
    redirect_to contract_path(@contract), alert: "Only the client can update this contract" unless @contract.client_id == current_user.id
  end

  def contract_params
    params.require(:contract).permit(:status, :end_date)
  end
end