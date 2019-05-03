class UploadController < ApplicationController

  IMAGE_EXT = [".gif", ".jpeg", ".jpg", ".png"]
  IMAGE_UPLOAD_PASH = "public/uploads/files"

  def upload_image
    puts '----image------'
    puts params
    puts '---------------'
    
    if params[:file]
      #画像のフォルダ作成
      FileUtils::mkdir_p(Rails.root.join(IMAGE_UPLOAD_PASH))
      #拡張子チェック
      ext = File.extname(params[:file].original_filename)
      ext = image_validation(ext)
      #保存するファイル名を作成
      file_name = "#{SecureRandom.urlsafe_base64}#{ext}"
      path = Rails.root.join(IMAGE_UPLOAD_PASH, file_name)
      #送られたデータから画像ファイルを作成
      File.open(path, "wb") {|f| f.write(params[:file].read)}
      #JSON形式で保存した画像のURLをユーザに返却
      view_file = Rails.root.join("/download_file/", file_name).to_s
      render :json => {:link => view_file}.to_json
    else
      render :text => {:link => nil}.to_json
    end
  end

  def image_validation(ext)
      raise "許可されていない拡張子" unless IMAGE_EXT.include?(ext)
  end

  def delete_image
    if params[:src]
      params[:src].each do |f|
        path = Rails.root.join(IMAGE_UPLOAD_PASH, f)
        File.delete(path)
      end
    end
  end

  def access_file
      if File.exists?(Rails.root.join(IMAGE_UPLOAD_PASH, params[:name]))
        send_data File.read(Rails.root.join(IMAGE_UPLOAD_PASH, params[:name])), :disposition => "attachment"
      else
        render :nothing => true
      end
  end
end
