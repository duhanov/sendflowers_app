class CkeditorAttachmentFile < CkeditorAsset

  # === List of columns ===
  #   id                : integer
  #   data_file_name    : string
  #   data_content_type : string
  #   data_file_size    : integer
  #   assetable_id      : integer
  #   assetable_type    : string
  #   type              : string
  #   locale            : integer
  #   user_id           : integer
  #   created_at        : datetime
  #   updated_at        : datetime
  # =======================

  has_attached_file :data,
                    :url => "/system/ckeditor/attachments/:id/:filename",
                    :path => ":rails_root/public/system/ckeditor/attachments/:id/:filename"

  validates_attachment_size :data, :less_than=>10.megabytes
end
