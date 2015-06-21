module FileHelper
    
        def upload_helper()
           "<a class=\"small button\" data-dropdown=\"dropUpload\" aria-controls=\"dropUpload\" aria-expanded=\"false\"><strong><i class=\"fi-upload\"></i> Upload</strong></a>
                <div id=\"dropUpload\" data-dropdown-content class=\"medium f-dropdown content\" aria-hidden=\"true\" tabindex=\"-1\">
                #{ render "file/upload"}
                </div>".html_safe
        end
        
        def view_versions_helper(file)
                       
            "<a href=\"#\" data-reveal-id=\"viewVersions#{file.id}\"><i class=\"fi-page-multiple\"></i> Versions</a>

            <div id=\"viewVersions#{file.id}\" class=\"reveal-modal\" data-reveal aria-labelledby=\"Versions\" aria-hidden=\"true\" role=\"dialog\">
              #{render 'file/versions', :versions =>  @client.versions_of_file(file), :file_name => file.name}
              <a class=\"close-reveal-modal\" aria-label=\"Close\">&#215;</a>
            </div>".html_safe 
        end
    
end
