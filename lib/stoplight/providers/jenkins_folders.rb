#
# Stoplight Provider with Folders support for Jenkins CI (http://jenkinsci.org)
#
# @see http://jenkins-enterprise.cloudbees.com/docs/user-guide-bundle/folder.html
#
# Jenkis inherits from the MultProjectStandard
#

module Stoplight::Providers
  class JenkinsFolders < MultiProjectStandard
    def provider
      'jenkins_folders'
    end

    def projects
      if @response.nil? || @response.parsed_response.nil? || @response.parsed_response['Projects'].nil?
        @projects ||= []
      else
        # Jenkins doesn't return an array when there's only one job...
        @projects ||= [ @response.parsed_response['Projects']['Project'] ].flatten.collect do |project|
          # TODO Allow sub-folders
          job_folder_name = project['webUrl'].scan(/\/job\/(.*)\/job\//).flatten.first
          Stoplight::Project.new({
           :name => "#{job_folder_name}/#{project['name']}",
           :build_url => project['webUrl'],
           :last_build_id => project['lastBuildLabel'],
           :last_build_time => project['lastBuildTime'],
           :last_build_status => status_to_int(project['lastBuildStatus']),
           :current_status => activity_to_int(project['activity'])
          })
        end
      end
    end
  end
end
