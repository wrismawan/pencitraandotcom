class Api::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy]

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
          sender = current_user.username
          image_url = current_user.avatar
          c = Comment.new
          c.content = cookies[:comment]
          c.sender = sender 
          c.image_url = image_url
          c.link_id = cookies[:link_id]
          if c.save
              flash[:alert] = "Anda berhasil melakukan comment di salah satu link berita" 
              redirect_to "/#{cookies[:tokoh]}" and return
          end
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
end
