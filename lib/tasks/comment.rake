namespace :comment do
      task :reset_image => :environment do
          comments = Comment.all
          avatar = Hash.new
          comments.each do |c|
              if avatar[c.sender]
                    rand = avatar[c.sender]
                    c.image_url = "/img/#{rand.to_s}.png"
                    c.save
              else
                    rand = rand(6) + 1
                    avatar[c.sender] = rand
                    c.image_url = "/img/#{rand.to_s}.png"
                    c.save
              end
          end
      end

      task :tokoh => :environment do
          Link.all.each do |link|
            if link.tokoh == nil
                link.tokoh = "Jokowi"
                link.save
            end
          end
      end
end
