class ContractsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contract, only: [:show, :complete, :cancel]

  def index
    @active_contracts = Contract.where(client_id: current_user.id, status: :active)
      .includes(:freelancer, :job)
      .order(created_at: :desc)
    @completed_contracts = Contract.where(client_id: current_user.id, status: :completed)
      .includes(:freelancer, :job)
      .order(created_at: :desc)
      .limit(5)
        @contracts = Contract.where(freelancer_id: current_user.id).or(Contract.where(client_id: current_user.id))
    .includes(:freelancer, :job, :client)
    .order(created_at: :desc) || []
  end

  def show
    authorize_contract_user!
  end

  # Mark contract as complete (CLIENT ONLY)
  def complete
    authorize_contract_client!
    
    if @contract.update(status: :completed)
      redirect_to @contract, notice: 'Contract marked as complete! You can now review the freelancer.'
    else
      redirect_to @contract, alert: 'Error completing contract'
    end
  end

  # Cancel contract (CLIENT ONLY)
  def cancel
    authorize_contract_client!
    
    if @contract.update(status: :cancelled)
      redirect_to contracts_path, notice: 'Contract cancelled'
    else
      redirect_to @contract, alert: 'Error cancelling contract'
    end
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def authorize_contract_user!
    redirect_to root_path unless @contract.freelancer == current_user || @contract.client == current_user
  end

  def authorize_contract_client!
    redirect_to root_path, alert: 'Not authorized' unless @contract.client == current_user
  end
end