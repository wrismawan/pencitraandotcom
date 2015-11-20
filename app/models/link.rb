class Link < ActiveRecord::Base
  attr_accessible :url
  validates :url, :uniqueness => true
  has_many :comments
  has_many :votes
  has_many :votedowns

  def last_comment
    if self.comments.last
        self.comments.last.id
    else
        0
    end
  end

  def vote_count
    vote = self.votes.count
    vote_down = self.votedowns.count
    vote - vote_down
  end
end
