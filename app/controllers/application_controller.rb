class ApplicationController < ActionController::Base
    protect_from_forgery
    skip_before_action :verify_authenticity_token
    before_action :authorize, except: [:login_user,:new_user]
    def authorize
        token = (request.headers["Authorization"].split)[1]
        rsa_private = ENV["JWT_SECRET"]
        decoded = JWT.decode(token, rsa_private, { algorithm: 'HS256' })
        user_id = decoded[0]["sub"]
        exp = decoded[0]["exp"]
        current_token = Redis.current.get(user_id)

        if !current_token||token!=current_token
            render json: { status: 'VALIDATION_FAILED' }, :status => :unauthorized
        elsif exp<(DateTime.current).to_i
            Redis.current.del(user_id)
            render json: { status: 'PLEASE_LOGIN_AGAIN' }, :status => :bad_request
        end 
    end
end
