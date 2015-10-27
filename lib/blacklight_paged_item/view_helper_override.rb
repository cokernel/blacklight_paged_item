# Meant to be applied on top of Blacklight helpers, to over-ride
# Will add rendering of limit itself in sidebar, and of constraings
# display. 
module BlacklightPagedItem::ViewHelperOverride
  def render_document_heading(*args)
    options = args.extract_options!
    document = args.first
    tag = options.fetch(:tag, :h4)
    document = document || @document

    content_tag(tag, self.document_heading(document), itemprop: "name")
  end

  def document_heading(document)
    pieces = [presenter(document).document_heading]
    number_field = blacklight_config.show.page_number_field
    count_field = blacklight_config.show.page_count_field
    if document.has_key? number_field
      pieces << ["(#{document[number_field]} of #{document[count_field]})"]
    end
    pieces.join(' ')
  end

  def document_show_link_field document=nil
    fields = Array(blacklight_config.view_config(document_index_view_type).title_field)

    field = fields.first if document.nil?
    field ||= fields.find {|f| document.has? f}
    field &&= field.try(:to_sym)
    field ||= document.id

    pieces = [document[field]]
    number_field = blacklight_config.show.page_number_field
    count_field = blacklight_config.show.page_count_field
    if document.has_key? number_field
      pieces << ["(#{document[number_field]} of #{document[count_field]})"]
    end
    pieces.join(' ')
  end
end
