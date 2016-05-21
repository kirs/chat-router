require 'bundler/setup'
require 'active_support/core_ext/object/blank'

require_relative 'token'
module Handler
  Route = Struct.new(:handler, :method, :tokens, :options)
  module DSL
    extend self
    def extended(base)
      Router.register(base)
    end

    def prefix(prefix, **options)
      @prefix = prefix
    end

    def command(method, pattern, options)
      @routes ||= []
      @routes << Route.new(self, method, tokenize(pattern), options)
    end

    def tokenize(pattern)
      if @prefix
        pattern = "#{@prefix} #{pattern}"
      end

      pattern.split(/\s+/).map { |t| TokenBuilder.build(t) }
    end

    def routes
      @routes
    end
  end
end

PreparedCommand = Struct.new(:route, :params) do
  def run
    route.handler.public_send(route.method, **params)
  end
end

module Dispatcher
  extend self

  # router returns matched and prepared command, which can be executed with `run` method
  def call(query)
    Router.handlers.each do |handler|
      handler.routes.each do |route|
        params = assert(route, query)
        return PreparedCommand.new(route, params) unless params.nil?
      end
    end
    nil
  end

  def assert(route, command)
    params = {}
    scanner = StringScanner.new(command)
    index_end = route.tokens.size
    route.tokens.each_with_index do |token, index|
      scanner.skip(/\s+/)
      if scanner.eos?
        index_end = index
        break
      end
      scanner.scan(token.regexp)
      name = scanner[1]
      value = scanner[2]
      return if value.blank? # couldn't parse command
      name = name.presence || token.name
      params[name.to_sym] = value if name.present?
    end
    return if route.tokens.drop(index_end).any? { |token| !token.is_a?(NamedToken) }
    scanner.skip(/\s*/)
    return unless scanner.eos?
    params
  end
end

class Router
  class << self
    def handlers
      @handlers
    end

    def register(handler)
      @handlers ||= []
      @handlers << handler
    end

    def find(query)
      Dispatcher.(query)
    end
  end
end

Dir['./handlers/*.rb'].each do |file|
  require file
end
