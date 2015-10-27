module BlacklightPagedItem
  module ControllerOverride
    extend ActiveSupport::Concern
    included do
      before_filter :generate_pagination, only: [:show]
    end

  private

    def generate_pagination
      response, @document = get_solr_response_for_doc_id
      return if @document.has_key? 'unpaged_display'
      return unless @document['id'] =~ /_/
      @pagination = {}
      parent_id = @document['parent_id_s']
      base = @document['id'].sub(/^(.*)_\d+$/, "\\1")
      page = @document['id'].sub(/^.*_(\d+)$/, "\\1").to_i
      count = @document[blacklight_config.show.page_count_field]
      if page > 1
        @pagination[:first] = "#{base}_1"
        @pagination[:previous] = "#{base}_#{page - 1}"
      end
      @pagination[:current] = {
        url: "#{@document['id']}",
        label: "#{page} of #{count}",
        position: page,
      }
      @pagination[:count] = count
      if page < count
        @pagination[:next] = "#{base}_#{page + 1}"
        @pagination[:last] = "#{base}_#{count}"
      end
      @pagination
    end
  end
end
