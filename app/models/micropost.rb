class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.max_length_micropost_content}
  validate :picture_size

  private

  def picture_size
    return unless picture.size > Settings.image_file_max_size.megabytes
    errors.add :picture, t("less_than_5mb")
  end
end
