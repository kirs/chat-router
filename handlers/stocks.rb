module Handlers
  class Stocks
    extend Handler::DSL
    command :stock_info, 'stock *symbol',
      help: "Returns stock price information about the provided stock symbol."

    def stock_info(symbol)
      # make request to NASDAQ for symbol
    end
  end
end
