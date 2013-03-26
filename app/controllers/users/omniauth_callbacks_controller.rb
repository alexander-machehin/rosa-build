# -*- encoding : utf-8 -*-
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    oauthorize 'Facebook'
  end

  def google_oauth2
    oauthorize 'google_oauth2'
  end

  def github
    oauthorize 'GitHub'
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
  
  private

  def oauthorize(kind)
    provider = kind.downcase
    @user = find_for_ouath(env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => action_name.classify
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end   
  end
 
  def find_for_ouath(auth, resource=nil)
    provider, uid   = auth['provider'], auth['uid']
    authentication  = Authentication.find_or_initialize_by_provider_and_uid(provider, uid)
    if authentication.new_record?
      if user_signed_in? # Register new user from session
        authentication.user = current_user
      else
        case provider
        when 'facebook'
          name  = auth['extra']['raw_info']['name']
          email = auth['info']['email']
        when 'google_oauth2'
          name =  auth['info']['name']
          email = auth['info']['email']
        when 'github'
          name =  auth['info']['nickname']
          email = auth['info']['email'] || "#{name}@github.com"
        else
          raise 'Provider #{provider} not handled'
        end
          user = User.create!(
            :uname    => "#{provider.gsub(/_oauth2/,'')}_#{uid}",
            :name     => name,
            :email    => email,
            :password => Devise.friendly_token[0,20]
          )
          user.confirmed_at = Time.zone.now
          user.save
          authentication.user = user
      end
      authentication.save!
    end
    return authentication.user
  end
 
end