module SessionsHelper

	def sign_in (user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end

	def signed_in? 
		!current_user.nil?		
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def current_user= (user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def current_user?(user)
		user == current_user
	end

	def signed_in_user 
        save_path
        redirect_to signin_path, notice: "Please sign in" unless signed_in?
    end
    
	def save_path	
		session[:return_to] = request.fullpath
	end

	def redirect_before_or (default)		
		path = session[:return_to]
		session.delete(:return_to)	
		redirect_to(path || default)		
	end


end
