module ContentHelper
    
    def getParentId(client)
         parent_id = client.folder_from_id(params[:folder_id]).parent.id
         if parent_id != '0'
             parent_id
         else
             nil
         end
    end
    
    def backLinkHelper(client)
        if params.has_key?("folder_id")
            parent_id = getParentId(client)
            if !parent_id.nil?
                 return link_to('Back', content_index_path(folder_id: parent_id))
            else
                 return link_to('Back', content_index_path)
            end
        end
    end
end
