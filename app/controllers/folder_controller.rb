class FolderController < ApplicationController
  def create
    begin
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
    rescue StandardError
      flash[:alert] = "Folder already exists."
      redirect_to :back
    end
  end
  
  def edit
    if(params[:folder_name].empty? && params[:move_to].empty?)
      flash[:alert] = "Error: Must fill in at least one field before submitting."
      redirect_to root_path
    end
    fn = params[:folder_name]
    mt = params[:move_to]
    begin
      @client.update_folder(@client.folder_from_id(params[:folder_id]), 
      name: fn.empty? ? nil : fn, 
      parent: mt.empty? ? nil : move_to_determiner(mt))
    rescue StandardError
      flash[:alert] = "Error: Folder not found, check spelling."
    end
    flash[:success] = "Folder updated."
    if mt.empty?
      redirect_to content_index_path(folder_id: params[:folder_id])
    else
      redirect_to content_index_path(folder_id: move_to_determiner(mt).id)
    end
  end
  
  
  
  def delete
    folder = @client.folder_from_id(params[:folder_id])
    parent_id = folder.parent.id
    @client.delete_folder(folder, recursive: true)
    flash[:success] = "Folder #{folder.name} deleted."
      if parent_id != '0'
        redirect_to content_index_path(folder_id: parent_id)
      else
        redirect_to content_index_path
      end
  end
  
  def add_collaboration
    begin
      if params.has_key?("folder_id") && !params[:folder_id].empty? && params.has_key?("user_email")
        user = params[:user_email]
        folder = @client.folder_from_id(params[:folder_id])
        @client.add_collaboration(folder, {login: user}, "viewer uploader")
        flash[:success] = "Collaborator #{user} added to #{folder.name}"
        redirect_to content_index_path(folder_id: folder.id)
      end
    rescue StandardError
      flash[:alert] = "Collaborator already added."
      redirect_to :back
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
  
  
  private 
  
  def move_to_determiner(path)
    @client.folder_from_path(path)
  end
end
