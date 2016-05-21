module Handlers
  class CircleCI
    extend Handler::DSL

    command :add_repo, 'circle add :repo',
      help: 'Enable CircleCI for a repository'

    command :add_repo, 'circleci add :repo',
      help: false

    def add_repo(repo:)
      reply("Enabling CircleCI for #{repo}")
      http.post("#{circle_host}/#{repo}/enable")
      http.post("#{circle_host}/#{repo}/follow")
    rescue => error
      reply("Command failed #{error.message}")
      raise
    end

    def circle_host
      "http://mycircle.com"
    end
  end
end
