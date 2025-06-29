class FilesController < ApplicationController
  def download
    # VULNERABLE: Path Traversal - 意図的な脆弱性（実験目的）
    filename = params[:filename]
    
    if filename.present?
      # パス検証なしでファイルを送信
      filepath = Rails.root.join('public', 'uploads', filename)
      
      if File.exist?(filepath)
        send_file filepath, disposition: 'attachment'
      else
        redirect_to root_path, alert: "File not found"
      end
    else
      redirect_to root_path, alert: "No filename specified"
    end
  end
end
