# frozen_string_literal: true
module BlacklightPagedItem
  module ControllerOverride
    extend ActiveSupport::Concern
    included do
      before_filter :generate_pagination, only: [:show]
    end

    private

    def generate_pagination
      _, document = fetch params[:id]
      return if document.key? 'unpaged_display'
      return unless document['id'] =~ /_/
      @pagination = {}
      base = document['parent_id_s']
      page = document['id'].sub(/^.*_(\d+)$/, '\\1').to_i

      q = "parent_id_s:#{base}"

      pagination_params = {
        qt: 'document',
        q: q,
        wt: 'ruby',
      }

      response, _ = search_results(params) do |search_builder|
        pagination_params
      end
      count = response['response']['numFound'].to_i
      if page > 1
        @pagination[:first] = "#{base}_1"
        @pagination[:previous] = "#{base}_#{page - 1}"
      end
      @pagination[:current] = {
        url: document['id'].to_s,
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
