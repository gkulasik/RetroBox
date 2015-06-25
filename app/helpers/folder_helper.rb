module FolderHelper
        def create_folder_helper()
           "<a class=\"small button\" data-dropdown=\"dropCreateFolder\" aria-controls=\"dropCreateFolder\" aria-expanded=\"false\"><strong><i class=\"fi-folder-add\"></i> Create Folder</strong></a>
                <div id=\"dropCreateFolder\" data-dropdown-content class=\"medium f-dropdown content\" aria-hidden=\"true\" tabindex=\"-1\">
                #{ render "folder/create"}
                </div>".html_safe
        end
        
        def add_collaboration_helper(folder_id)
            
            "#{render 'folder/add_collaborators', :folder_id => folder_id}".html_safe
            
            
            
            
            
        #   "<a data-dropdown=\"dropAddCollaboration#{folder_id}\" aria-controls=\"dropAddCollaboration#{folder_id}\" aria-expanded=\"false\" data-options=\"align:left\"><i class=\"fi-torsos-all\"></i> Add Collaborator</a>
        #     <div id=\"dropAddCollaboration#{folder_id}\" data-dropdown-content class=\"large f-dropdown\" aria-hidden=\"true\" tabindex=\"-1\">
        #       #{render 'folder/add_collaborators', :folder_id => folder_id}
        #     </div>".html_safe
        end
        
        def view_collaborators_helper(folder_id)
            
            "<a href=\"#\" data-reveal-id=\"viewCollaborators#{folder_id}\"><i class=\"fi-torsos-all\"></i> View Collaborators</a>

            <div id=\"viewCollaborators#{folder_id}\" class=\"reveal-modal\" data-reveal aria-labelledby=\"Collaborators\" aria-hidden=\"true\" role=\"dialog\">
              #{render 'folder/collaborations', :collaborators =>  @client.folder_collaborations(@client.folder_from_id(folder_id)), :folder_id => folder_id, :folder_name => @client.folder_from_id(folder_id).name}
              <a class=\"close-reveal-modal\" aria-label=\"Close\">&#215;</a>
            </div>".html_safe
            
        end
        
        def collaboration_helper(folder)
            folder_id = folder.id
                        "<a href=\"#\" data-reveal-id=\"viewCollaborators#{folder.id}\"><i class=\"fi-torsos-all\"></i> Collaboration</a>

            <div id=\"viewCollaborators#{folder.id}\" class=\"reveal-modal\" data-reveal aria-labelledby=\"Collaborators\" aria-hidden=\"true\" role=\"dialog\">
            
                    <ul class=\"tabs\" data-tab>
                      <li class=\"tab-title active\"><a href=\"#add\">Add</a></li>
                      <li class=\"tab-title\"><a href=\"#view\">View</a></li>
                    </ul>
                    <div class=\"tabs-content\">
                      <div class=\"content active\" id=\"add\">
                        #{add_collaboration_helper(folder.id).html_safe}
                      </div>
                      <div class=\"content\" id=\"view\">
                        #{render 'folder/collaborations', :collaborators =>  @client.folder_collaborations(folder), :folder_id => folder.id, :folder_name => folder.name}
                      </div>
                    </div>
              
              
              <a class=\"close-reveal-modal\" aria-label=\"Close\">&#215;</a>
            </div>".html_safe
        end
        
end
