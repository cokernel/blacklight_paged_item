module BlacklightPagedItem
  module ControllerOverride
    extend ActiveSupport::Concern
    included do
      before_filter :generate_pagination, only: [:show]
    end

  private

    def get_solr_response_for_pagination(field, values, extra_solr_params = {})
      q = if Array(values).empty?
        "NOT *:*"
      else
        "#{field}:(#{ Array(values).map { |x| solr_param_quote(x)}.join(" OR ")})"
      end

      solr_params = {
        :defType => "lucene",
        :q => q,
        :fl => "*",
        :facet => 'false',
        :spellcheck => 'false'
      }.merge(extra_solr_params)

      stripped_solr_params = self.solr_search_params().merge(solr_params).dup
      if stripped_solr_params.has_key? :fq
        stripped_solr_params[:fq].reject! { |x| x =~ /compound_object/ }
      end

      solr_response = find(stripped_solr_params)
      [solr_response, solr_response.documents]
    end

    def generate_pagination
      max_per_page = 1500
      response, @document = get_solr_response_for_doc_id
      unless @document.has_key?('unpaged_display')
        @pagination = {}
        parent_id = @document['parent_id_s']
        base = @document['id'].sub(/^(.*)_\d+$/, "\\1")
        page = @document['id'].sub(/^.*_(\d+)$/, "\\1").to_i
        extra = {:per_page => max_per_page}
        @pagination_response, @pagination_documents = get_solr_response_for_pagination("parent_id_s", parent_id, extra)
        count = @pagination_response['response']['numFound']
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
end
