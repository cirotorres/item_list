# app/services/mercado_pago_service.rb

class MercadoPagoService
  def initialize
    @client = $mp_client
  end

  def get_payment(payment_id)
    return unless @client

    @client.payment.get(payment_id)[:response]
  rescue => e
    Rails.logger.error("Erro ao buscar pagamento: #{e.message}")
    nil
  end
end
