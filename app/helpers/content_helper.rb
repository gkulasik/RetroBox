module ContentHelper

    def listing_helper(client, item)
        output = ""
        case item.type
            when "file"
              output =  "<i class=\"fi-page\"></i> &nbsp;"+ link_to(item.name, client.download_url(item))
            when "folder"
              output = "<i class=\"fi-folder\"></i> &nbsp;"+ link_to(item.name, content_index_path(folder_id: item.id))
            else
                ""
        end
        return output.html_safe
    end
    
    
    def menu_helper(client, folder_id)
        
        options = []
        options << upload_helper()
        options << create_folder_helper()
        options << edit_folder_helper() unless folder_id.nil?

        output = content_tag :ul, class: "button-group" do 
                    options.each do |o|
                        concat(content_tag(:li, o))
                        end
                 end
        return output.html_safe
    end
    

    
    def breadcrumbs_helper(client, folder)
        ancestors = []
        next_folder = folder
        while(!next_folder.parent.nil? && next_folder.parent.id != "0")
            ancestors << next_folder.parent
            next_folder = client.folder_from_id(next_folder.parent.id)
        end
        puts "breadcrumbs"
        puts ancestors
        output = content_tag :ul, class: "breadcrumbs" do
                    concat(content_tag(:li, link_to("<i class=\"fi-home\"></i>  ALL FILES".html_safe, root_path())))
                        ancestors.reverse.each do |a|
                            concat(content_tag(:li, link_to(a.name, content_index_path(folder_id: a.id))))
                        end
                        concat(content_tag(:li, folder.name, class: "current" )) if folder.id != "0"
                 end
          return output.html_safe
    end
    
    def options_helper(client, item, folder_id)
        options = []
        case item.type
            when "file"
                options << link_to("<i class=\"fi-download\"></i> Download".html_safe, client.download_url(item))
                options << link_to("<i class=\"fi-trash\"> </i> Delete".html_safe, file_delete_path(file_id: item.id, folder_id: folder_id))
                options << view_versions_helper(item) if  !client.versions_of_file(item).empty?
            when "folder"
                options << link_to("<i class=\"fi-trash\"></i> Delete".html_safe, folder_delete_path(folder_id: item.id))
                options << collaboration_helper(item)
            else
                nil
        end
        output = "<button data-dropdown=\"drop#{item.id}\" aria-controls=\"drop#{item.id}\" aria-expanded=\"false\" class=\"tiny button dropdown\">Options</button><br />"
        output += content_tag :ul, id: "drop#{item.id}", "data-dropdown-content": '', class: "f-dropdown", "aria-hidden": true do
                    options.each do |o|
                        concat(content_tag(:li, o))
                    end
                  end
        return output.html_safe
    end
end
