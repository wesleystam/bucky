class TransactionsController < ApplicationController
  protect_from_forgery with: :null_session
  before_filter :require_signed_params

  def callback_success
    if Buckaroo::PaymentResponse.new(params).successful_payment?
      #Your code here
      redirect_to root_path
    end
  end

  #handle transaction rejection, error, and cancel callbacks.
  #
  # ie.
  # transaction = Transaction.find(params[:id])
  # transaction.update_attributes(rejected_at: DateTime.now)
  #
  def callback_reject
    #your code here
  end
  alias_method :callback_error, :callback_reject
  alias_method :callback_cancel, :callback_reject

  private

  def require_signed_params
    unless Buckaroo::Signature.valid?(params)
      render status: 422, nothing: true
    end
  end

end
