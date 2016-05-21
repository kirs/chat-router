require_relative 'router'
require 'minitest/autorun'

class TestMeme < MiniTest::Test
  def test_handlers_registered
    assert_equal Dir['handlers/*.rb'].size, Router.handlers.size
  end

  def test_handlers_tokenized
    assert_equal 13, Handlers::Heroku.routes.size
    assert_equal 2, Handlers::NewRelic.routes.size

    nr_tokens = Handlers::NewRelic.routes.first.tokens
    assert_equal 2, nr_tokens.size
    assert_equal nr_tokens[0], StaticToken.new("newrelic")
    assert_equal nr_tokens[1], NamedToken.new("format", "default")
  end

  def test_routing
    command = Router.find("newrelic")
    assert_equal Handlers::NewRelic.routes[0], command.route
    assert_equal({}, command.params)

    command = Router.find("3500 bytes")
    assert_equal Handlers::Bytes.routes[0], command.route
    assert_equal({ amount: "3500" }, command.params)

    command = Router.find("something that does not exist")
    assert_nil command

    command = Router.find("heroku info myapp")
    assert_equal Handlers::Heroku.routes[0], command.route
    assert_equal({ app: "myapp" }, command.params)

    command = Router.find("status everything is kinda down")
    assert_equal Handlers::StatusPage.routes[0], command.route
    assert_equal({ status: "kinda down" }, command.params)

    command = Router.find("status api is kinda down")
    assert_equal Handlers::StatusPage.routes[1], command.route
    assert_equal({ component: "api", status: "kinda down" }, command.params)
  end
end
