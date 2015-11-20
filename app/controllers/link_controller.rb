class LinkController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def vote_up
      if !current_user
        flash[:alert] = "MAAF Anda harus Login terlebih dahulu"
        redirect_to request.referer and return
      end
      v = Vote.new
      v.user_id = current_user.id
      v.link_id = params[:link_id]
      if v.save
        Votedown.where(:link_id => v.link_id, :user_id => current_user.id).destroy_all if Votedown.exists?(:link_id => v.link_id, :user_id => current_user.id)
        flash[:alert] = "Berhasil vote up"
        redirect_to request.referer and return
      else
        flash[:alert] = "MAAF Anda cuma bisa vote up sekali untuk 1 berita" 
        redirect_to request.referer and return
      end
  end

  def vote_down
      if !current_user
        flash[:alert] = "MAAF Anda harus Login terlebih dahulu"
        redirect_to request.referer and return
      end
      v = Votedown.new
      v.user_id = current_user.id
      v.link_id = params[:link_id]
      if v.save
        Vote.where(:link_id => v.link_id, :user_id => current_user.id).destroy_all if Votedown.exists?(:link_id => v.link_id, :user_id => current_user.id)
        flash[:alert] = "Berhasil vote up"
        redirect_to request.referer and return
      else
        flash[:alert] = "MAAF Anda cuma bisa vote up sekali untuk 1 berita" 
        redirect_to request.referer and return
      end
  end
end
