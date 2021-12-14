class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
  class LoginRequired < StandardError; end
	class Forbidden < StandardError; end
	class InternalServerError < StandardError; end
	class NotFound < StandardError; end

	if Rails.env.production? || ENV["RESCUE_EXCEPTIONS"]
		rescue_from StandardError, with: :rescue_internal_server_error
		rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
		rescue_from ActionController::ParameterMissing, with: :rescue_bad_request
	end

	rescue_from LoginRequired, with: :rescue_login_required
	rescue_from Forbidden, with: :rescue_forbidden
	rescue_from InternalServerError, with: :rescue_internal_server_error
	rescue_from NotFound, with: :rescue_not_found

	private def login_required
		raise LoginRequired unless current_user
	end

	private def rescue_bad_request(exception)
		render "errors/bad_request", status: 400, layout: "error",
			formats: [:html]
	end

	private def rescue_login_required(exception)
		render "errors/login_required", status:403, layout: "error",
			formats: [:html]
	end

	private def rescue_forbidden(exception)
		render "errors/forbidden", status: 403, layout: "error",
			formats: [:html]
	end

	private def rescue_not_found(exception)
		render "errors/not_found", status: 404, layout: "error",
			formats: [:html]
	end

	private def rescue_internal_server_error(exception)
		render "errors/internal_server_error", status: 500, layout: "error",
			formats: [:html]
	end
end
