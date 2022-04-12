class Api::PostsController < ApplicationController
	def status
		json_response({success: true })
  end

  def index
		post_data = PostService.new(params).execute

		unless post_data[:error].present?
			json_response(post_data)
		else
			json_response(post_data, :bad_request)
		end
  end
end
