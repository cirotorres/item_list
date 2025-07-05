class Payment < ApplicationRecord
  validates :mp_payment_id, presence: true, uniqueness: true
end
