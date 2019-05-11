class UploadController < ApplicationController
  IMAGE_EXT = [".gif", ".jpeg", ".jpg", ".png"]

  def upload_image
    if params[:file]
      #拡張子チェック
      ext = File.extname(params[:file].original_filename)
      image_validation(ext)
      #保存するファイル名を作成
      file_name = "#{SecureRandom.urlsafe_base64}#{ext}"
      #DBにパラメータデータを登録
      blob = ActiveStorage::Blob.create_after_upload!(
        io: params[:file],
        filename: file_name,
        content_type: params[:file].content_type
      )
      render :json => {:link => url_for(blob)}.to_json
    end
  end

  def image_validation(ext)
      raise "許可されていない拡張子" unless IMAGE_EXT.include?(ext)
  end
end
