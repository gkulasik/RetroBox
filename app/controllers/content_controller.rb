class ContentController < ApplicationController
  def index
    @user_name ||= @client.current_user.name 
    
    if !params.has_key?("folder_id")
      @folder =  @client.folder_from_id("0")
      @folders = @client.root_folder_items()
    else
      @folder_id = params[:folder_id]
      @folder = @client.folder_from_id(@folder_id)
      @folders = @client.folder_items(@folder)
    end
    
  end
  

  
   
end
