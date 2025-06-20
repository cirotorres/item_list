require "solid_cable/record"

SolidCable::Record.connects_to database: { writing: :primary }
