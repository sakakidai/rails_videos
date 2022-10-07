class Video < ApplicationRecord
  mount_uploader :thumbnail, VideothumbnailUploader
end
