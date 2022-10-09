class Video < ApplicationRecord
  mount_uploader :thumbnail, VideothumbnailUploader
  validates :title, presence: true
end
