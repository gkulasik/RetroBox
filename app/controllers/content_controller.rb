class ContentController < ApplicationController
  def index
    if !params.has_key?("folder_id")
      @folders = @client.root_folder_items()
    else
      @folders = @client.folder_items(@client.folder_from_id(params[:folder_id]))
    end
  end
  

  
   
end
