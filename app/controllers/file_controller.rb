class FileController < ApplicationController
  
  
  def upload
      if params.has_key?('file_to_upload')
        uploadHelper(params[:file_to_upload], params[:folder_id], params[:file_to_upload].path)
        if !params[:folder_id].empty?
          redirect_to content_index_path(folder_id: params[:folder_id] )
        else
          redirect_to content_index_path
        end
      end
  end
  
  def delete
    file = @client.file_from_id(params[:file_id])
      @client.delete_file()
      flash[:success] = "File #{file.name} deleted"
      if params.has_key?("folder_id")
        redirect_to content_index_path(folder_id: params[:folder_id])
      else
        redirect_to content_index_path
      end
  end
  
  def versions
    if params.has_key?("file_id")
      file = @client.file_from_id(params[:file_id])
      @file_name = file.name
      @versions = @client.versions_of_file(file)
    else
      flash[:alert] = "Missing file id"
      redirect_to 
    end
  end
  
  private
  
    def uploadHelper(file, folder_id, url)
      if params.has_key?("folder_id") && !params[:folder_id].blank?
       folder = @client.folder_from_id(folder_id) 
      else
       folder = @client.folder_from_id('0')
      end
      
      @items = @client.search(file.original_filename, type: "file")
      
      exists = false
      matching_file = nil
      #puts
      @items.each do |f|
        if f.name == file.original_filename && f.parent.id == folder.id
          exists = true
          matching_file = f
        end
      end
    
      if exists
          @client.upload_new_version_of_file(file.tempfile.path(), matching_file)
          flash[:success] = "File #{file.original_filename} updated."
      else
          @client.upload_file(file.tempfile.path(), folder, name: file.original_filename)
          flash[:success] = "File #{file.original_filename} uploaded."
      end
    end
end
