# frozen_string_literal: true
module BlacklightPagedItem
  class Engine < ::Rails::Engine
    isolate_namespace BlacklightPagedItem

    Blacklight::Configuration.default_values[:show].parent_field = 'parent_id_s'
    Blacklight::Configuration.default_values[:show].partials.push(:pagination)

    config.to_prepare do
      BlacklightPagedItem.inject!
    end
  end
end
