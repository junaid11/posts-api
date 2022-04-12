class PostService
  require 'rest-client'

  def initialize(params)
    if params.present?
      @search_params = params
      @tags = params["tags"]	
      @sortBy = params["sortBy"]
      @direction = params["direction"]
      @post_data = []
    end
  end
  
  def execute
    validation_response = check_validations()
    return  validation_response if validation_response[:error].present?

    @tags.split(",").each do |tag| 
      @post_data << get_api_data(tag)
    end
    {
      posts: apply_data_filters()
    }
  end

  private

    def get_api_data tag
      uri = HATCHWAYS_API + tag 
      response = Rails.cache.fetch("#{cache_key_for(tag)}", expires_in: 12.hours) do
        JSON.parse(RestClient.get(uri))
      end
      return response["posts"] if response.present?
    end

    def check_validations
      error_des = TAGS_REQUIRED unless @tags.present?
      if @sortBy.present?
        error_des = SORTBY_INVALID unless SORT_BY_PARAMS.include?(@sortBy)
      end
      if @direction.present?
        error_des = DIRECTION_INVALID unless DIRECTION_PARAMS.include?(@direction)
      end
      {
        error: error_des
      }
    end

    def apply_data_filters 
      data = @post_data.flatten.uniq 
      descending = -1 if @direction == DESC_CONSTANT
      data.sort_by!{ |m| m[@sortBy] * (descending || 1) }
    end

    def cache_key_for tag
      "tag:#{tag}:#{Date.today}"
    end
end
