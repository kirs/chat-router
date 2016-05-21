module Handlers
  class StatusPage
    extend Handler::DSL

    PUBLIC_STATUSES = %w(admin front)

    command :update_everything, 'status everything is *status',
      help: "Update status.example.com"

    command :update_one, 'status :component is *status',
      help: "Update status.example.com (everything #{PUBLIC_STATUSES.join(' | ')}). Major outage? Use the UI"

  end
end
