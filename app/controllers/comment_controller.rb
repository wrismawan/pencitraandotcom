class CommentController < ApplicationController
  http_basic_authenticate_with name: "jokowi", password: "secret", only: :delete
  skip_before_filter :verify_authenticity_token
  def postcomment
      comment = params[:comment]
      link_id = params[:link_id]
      if !current_user
          cookies[:comment] = comment
          cookies[:link_id] = link_id
          flash[:alert] = 'Silakan register terlebih dahulu agar komentar Anda tersubmit'
          redirect_to "/users/sign_up" and return
      end
      sender = current_user.username
      image_url = current_user.avatar
      c = Comment.new
      c.content = comment
      c.sender = sender
      c.image_url = image_url
      c.link_id = link_id.to_i
      if c.save
          flash[:alert] = "Anda berhasil melakukan comment di salah satu link berita" 
          redirect_to request.referer and return
      end
      redirect_to request.referer and return
  end

  def set_username
      username = params[:username]
      cookies[:pencitraan_name] = username
      flash[:alert] = "Anda berhasil men-set username dengan nama "+cookies[:pencitraan_name]
      redirect_to request.referer and return
  end

  def set_image
      image = params[:image_url]
      cookies[:image] = image
      flash[:alert] = "Anda berhasil men-set username dan IMAGE"
      redirect_to request.referer and return
  end

  def delete
      id = params[:id] 
      Comment.find(id).destroy
      redirect_to request.referer and return
  end
end
