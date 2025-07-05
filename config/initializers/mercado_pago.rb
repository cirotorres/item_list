require "mercadopago"

$mp_client = Mercadopago::SDK.new(ENV["MERCADO_PAGO_ACCESS_TOKEN"])
