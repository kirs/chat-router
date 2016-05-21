module Handlers
  class NewRelic
    extend Handler::DSL

    command :render, "newrelic [format=default]",
      help: "Show Shopify newrelic graphs"

    command :render, "newrelic :app [format=default]",
      help: "Show app NewRelic graphs"

    def render(app: 'shopify', format:)
      # make request to heroku and render chart
    end
  end
end
