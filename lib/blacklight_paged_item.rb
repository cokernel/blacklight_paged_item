require "blacklight_paged_item/engine"

module BlacklightPagedItem
  require "blacklight_paged_item/controller_override"
  def self.inject!
    CatalogController.send(:include, BlacklightPagedItem::ControllerOverride)
  end
end
