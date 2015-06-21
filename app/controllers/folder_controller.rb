class FolderController < ApplicationController
  def create
    if params.has_key?("folder_name")
      if params[:folder_id].empty?
        folder = @client.folder_from_id('0')
      else
        folder = @client.folder_from_id(params[:folder_id])
      end
      @client.create_folder(params[:folder_name], folder)
      flash[:success] = "Folder #{params[:folder_name]} created!"
      if !params[:folder_id].empty?
        redirect_to content_index_path(folder_id: folder.id)
      else
        redirect_to content_index_path
      end
    end
  end
  
  def add_collaboration
    if params.has_key?("folder_id") && !params[:folder_id].empty? && params.has_key?("user_email")
      user = params[:user_email]
      folder = @client.folder_from_id(params[:folder_id])
      @client.add_collaboration(folder, {login: user}, "viewer uploader")
      flash[:success] = "Collaborator #{user} added to #{folder.name}"
      redirect_to content_index_path(folder_id: folder.id)
    end
  end
  
  
  def collaborations
    if params.has_key?("folder_id")
      @folder = @client.folder_from_id(params[:folder_id])
      @collaborations = @client.folder_collaborations(@folder)
    end
  end
  
  def edit_collaboration
    if params.has_key?("collaboration_id") && params.has_key?("folder_id")
      c = @client.collaboration(params[:collaboration_id])
      @client.edit_collaboration(c, role: :co_owner)
      flash[:success] = "Collaborator #{c.accessible_by.name} updated to co-owner"
      redirect_to :back
    end
  end
  
  def remove_collaboration
     if params.has_key?("collaboration_id") && params.has_key?("folder_id")
      c = @client.collaboration(params[:collaboration_id])
      @client.remove_collaboration(c)
      flash[:success] = "Collaborator #{c.accessible_by.name} removed"
      redirect_to :back
     end
  end
  
  def delete
    parent_id = @client.folder_from_id(params[:folder_id]).parent.id
    @client.delete_folder(@client.folder_from_id(params[:folder_id]), recursive: true)
      if parent_id != '0'
        redirect_to content_index_path(folder_id: parent_id)
      else
        redirect_to content_index_path
      end
  end
end
