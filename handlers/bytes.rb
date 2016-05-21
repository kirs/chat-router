module Handlers
  class Bytes
    extend Handler::DSL

    command :bytes_for_human, ':amount bytes',
      amount: Integer,
      help: 'Gives you a human representation of an amount of bytes'

    def bytes_for_human(amount:)
      reply(ActiveSupport::NumberHelper.number_to_human_size(amount))
    end
  end
end
