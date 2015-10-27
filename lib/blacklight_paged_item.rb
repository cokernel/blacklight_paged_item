require "blacklight_paged_item/engine"

module BlacklightPagedItem
  require "blacklight_paged_item/controller_override"
  require "blacklight_paged_item/view_helper_override"
  def self.inject!
    CatalogController.send(:include, BlacklightPagedItem::ControllerOverride)
    CatalogController.send(:helper, BlacklightPagedItem::ViewHelperOverride)
  end
end
