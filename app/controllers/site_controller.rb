class SiteController < ApplicationController
  http_basic_authenticate_with name: "jokowi", password: "secret", except: :index
  skip_before_filter :verify_authenticity_token

  def index
        url = params[:url]
        @url = url
        @get = true

        if params[:tokoh]
            @tokoh = params[:tokoh]
        else
            @tokoh = "Jokowi"
        end
        @links = Link.where(:verified => true).where(:tokoh => @tokoh).sort_by { |i| i.vote_count }.reverse

        if request.get?
            cookies[:tokoh] = @tokoh
        end

        return unless url

        link = Link.new(:url => url)
        if !Link.exists?(:url => url) 
            @host = URI.parse(url).host
            flash[:alert] = "submit link sudah SUKSES, admin akan mereview link tersebut terlebih dulu." 
            begin
                # get the url content
                response = HTTParty.get(url)
                # /get the url content
                
                
                # nokogiri in action
                doc = Nokogiri::HTML(response)

                #----- description ----
                @description = ""
                if @description == ""
                    doc.xpath("//meta[@property='og:description']/@content").each do |attr|
                        @description = ""
                        @description = attr.value
                    end
                end
                if @description == ""
                    doc.xpath("//meta[@name='description']/@content").each do |attr|
                        @description = ""
                        @description = attr.value
                    end
                end
                if @description == ""
                    doc.xpath("//p").each do |attr|
                        @description = attr.text
                        break
                    end
                end
                if @description == ""
                    redirect_to request.referer, :alert => "Link yang anda submit tidak bisa kami save karena bukan merupakan halaman berita yang memenuhi standard" and return
                end
                #----- /description --------
                #----- images --------
                @images = []
                doc.xpath("//meta[@property='og:image']/@content").each do |attr|
                    if attr.value.downcase.include? ".jp" or  attr.value.downcase.include? ".png"
                        @images = []
                        @images << attr.value 
                    end
                end
                doc.xpath("//img/@src").each do |attr|
                    @images << attr.value if attr.value.downcase.include? ".jp" or  attr.value.downcase.include? ".png"
                end
                @image = @images.first
                #----- /images --------
                #
                #----- title --------
                @title = doc.at_css("title").text
                #----- /title --------
                # /nokogiri in action
                #
                
                # rescue
                link.title = @title
                link.image_url = @image
                link.description = @description
                link.host = @host
                link.tokoh = cookies[:tokoh]

                #temporary only

                link.save
                redirect_to request.referer and return
            rescue Exception => ex
               m = "#{ex.class}, #{ex.message}"
               redirect_to request.referer, :alert => "link yang anda submit tidak valid, karena #{m}" and return
            end
            # end rescue
        else
            flash[:alert] = "GAGAL SUBMIT, link sudah pernah disubmit" 
            redirect_to request.referer and return
        end
  end

  def list
    @users = User.all
    @links = Link.where(:deleted => false).order("created_at DESC")
    if request.GET["tokoh"]
        tokoh = request.GET["tokoh"]
        cookies[:tokoh] = tokoh
        @users = []
        @links = Link.where(:deleted => false).where(:tokoh => tokoh).order("created_at DESC")
    end
  end

  def verify
    id = params[:id]
    l = Link.find(id)
    if params[:verify] == "true"
        l.verified = true
    else
        l.verified = false
    end
    l.save
    redirect_to request.referer and return
  end

  def delete
    id = params[:id]
    l = Link.find(id)
    l.deleted = true
    l.save
    redirect_to request.referer and return
  end

  def admin_submit
        url = params[:url]
        @url = url
        @get = true

        if params[:tokoh]
            @tokoh = params[:tokoh]
        else
            @tokoh = "Jokowi"
        end
        @links = Link.where(:verified => true).where(:tokoh => @tokoh).sort_by { |i| i.vote_count }.reverse

        if request.get?
            cookies[:tokoh] = @tokoh
        end

        return unless url

        link = Link.new(:url => url)
        if !Link.exists?(:url => url) 
            @host = URI.parse(url).host
            flash[:alert] = "submit link sudah SUKSES, admin akan mereview link tersebut terlebih dulu. Tapi berhubung anda adalah Admin maka otomatis terverified" 
            begin
                # get the url content
                response = HTTParty.get(url)
                # /get the url content
                
                
                # nokogiri in action
                doc = Nokogiri::HTML(response)

                #----- description ----
                @description = ""
                if @description == ""
                    doc.xpath("//meta[@property='og:description']/@content").each do |attr|
                        @description = ""
                        @description = attr.value
                    end
                end
                if @description == ""
                    doc.xpath("//meta[@name='description']/@content").each do |attr|
                        @description = ""
                        @description = attr.value
                    end
                end
                if @description == ""
                    doc.xpath("//p").each do |attr|
                        @description = attr.text
                        break
                    end
                end
                if @description == ""
                    redirect_to request.referer, :alert => "Link yang anda submit tidak bisa kami save karena bukan merupakan halaman berita yang memenuhi standard" and return
                end
                #----- /description --------
                #----- images --------
                @images = []
                doc.xpath("//meta[@property='og:image']/@content").each do |attr|
                    if attr.value.downcase.include? ".jp" or  attr.value.downcase.include? ".png"
                        @images = []
                        @images << attr.value 
                    end
                end
                doc.xpath("//img/@src").each do |attr|
                    @images << attr.value if attr.value.downcase.include? ".jp" or  attr.value.downcase.include? ".png"
                end
                @image = @images.first
                #----- /images --------
                #
                #----- title --------
                @title = doc.at_css("title").text
                #----- /title --------
                # /nokogiri in action
                #
                
                # rescue
                link.title = @title
                link.image_url = @image
                link.description = @description
                link.host = @host
                link.tokoh = cookies[:tokoh]
                link.verified = 1

                #temporary only

                link.save
                redirect_to request.referer and return
            rescue Exception => ex
               m = "#{ex.class}, #{ex.message}"
               redirect_to request.referer, :alert => "link yang anda submit tidak valid, karena #{m}" and return
            end
            # end rescue
        else
            flash[:alert] = "GAGAL SUBMIT, link sudah pernah disubmit" 
            redirect_to request.referer and return
        end
  end

  def test

  end

end
