module Handlers
  class Heroku
    extend Handler::DSL
    prefix :heroku

    command :app_info, 'info :app',
      help: 'Display all info for app'

    command :domain_list, 'domain :app',
      help: 'Display information about existing domains'

    command :domain_create, 'domain create :app :host',
      help: 'Create a new domain'

    command :domain_delete, 'domain delete :app :host',
      help: 'Delete an existing domain'

    command :addon_list, 'addon list :app',
      help: 'List add-ons'

    command :addon_create, 'addon create :app :addon',
      help: 'Install new add-on'

    command :addon_delete, 'addon delete :app :addon',
      help: 'Delete add-on'

    command :find_addon, 'find :addon',
      help: 'Find add-on associated with app'

    command :cache_clear, 'cache clear',
      help: 'Flush heroku find list'

    command :ssl_info, 'ssl :app',
      help: 'list existing SSL endpoints'

    command :ssl_create, 'ssl create :app',
      help: 'create new SSL endpoints'

    command :ssl_delete, 'ssl delete :app :ssl_id',
      help: 'delete new SSL endpoints'

    command :invite, 'invite :email',
      help: 'invite a person to Heroku org'
  end
end
