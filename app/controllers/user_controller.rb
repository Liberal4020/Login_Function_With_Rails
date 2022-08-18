class UserController < ApplicationController

    def new_user
        user = User.new({name: params["name"],password: params["password"]})
        if user.save
          render json: { user_id: user.id }, :status => :created
        else
          render json: { status: 'ERROR' }, :status => :internal_server_error
        end
    end

    def login_user
      begin
        user = User.find_by(name: params["name"])&.authenticate(params["password"])
      rescue =>exception
        render json: { status: 'LOGIN_ERROR' }, :status => :unauthorized
        return
      end
      
      begin
        payload = {
          iss: "example_app", # JWTの発行者
          sub: user.id, # JWTの主体
          exp: (DateTime.current + 7.days).to_i # JWTの有効期限
        }
        rsa_private = ENV["JWT_SECRET"]
        token = JWT.encode(payload, rsa_private, "HS256")
        Redis.current.set(user.id, token)
        render json: { token:token }, :status => :created
      rescue =>exception
        render json: { status: 'ERROR' }, :status => :internal_server_error
      end

    end

    def logout_user
      token = (request.headers["Authorization"].split)[1]
      rsa_private = ENV["JWT_SECRET"]
      decoded = JWT.decode(token, rsa_private, { algorithm: 'HS256' })
      user_id = decoded[0]["sub"]
      Redis.current.del(user_id)
      render json: { status: 'LOGOUT' }, :status => :ok
    end

end
