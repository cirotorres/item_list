# app/controllers/payments_controller.rb

class PaymentsController < ApplicationController
  skip_before_action :authorize_request, only: [ :webhook, :check ] # para permitir POST do Mercado Pago

  def create
    unless defined?($mp_client) && $mp_client
      return render json: { error: "Mercado Pago não está configurado" }, status: :internal_server_error
    end

    preference_data = {
      items: [
        {
          title: params[:title],
          unit_price: params[:price].to_f,
          quantity: params[:quantity].to_i
        }
      ],
      back_urls: {
        # LocalTunnel para o front (5173)
        success: "https://light-cars-mate.loca.lt/pagamento/status",
        failure: "https://light-cars-mate.loca.lt/pagamento/status",
        pending: "https://light-cars-mate.loca.lt/pagamento/status"
      },
      auto_return: "approved"
      # notification_url: "https://three-humans-kick.loca.lt/payments/webhook"
    }

    preference = $mp_client.preference.create(preference_data)

    if preference[:response]["init_point"].present?
      render json: { init_point: preference[:response]["init_point"] }
    else
      Rails.logger.error("Erro ao criar preferência: #{preference.inspect}")
      render json: { error: "Erro ao criar preferência" }, status: :internal_server_error
    end
  end


  def check
    payment = Payment.find_by(mp_payment_id: params[:payment_id])

    if payment
      render json: { status: payment.status }
    else
      render json: { status: "unknown" }
    end
  end

  def webhook
    Rails.logger.info("Webhook recebido: #{params.inspect}")
    puts ("Webhook recebido: #{params.inspect}")

    topic = params[:type] || params[:topic]
    payment_id = params[:data][:id] rescue nil

    return head :bad_request unless topic == "payment" && payment_id.present?

    mercado_pago_service = MercadoPagoService.new
    payment_data = mercado_pago_service.get_payment(payment_id)

    Rails.logger.info("Dados do pagamento recebidos: #{payment_data.inspect}")
    puts ("Dados do pagamento recebidos: #{payment_data.inspect}")

    if payment_data
      payment = Payment.find_or_initialize_by(mp_payment_id: payment_id)
      payment.status = payment_data["status"]
      payment.status_detail = payment_data["status_detail"]
      payment.save!
    end

    head :ok
  end
end
