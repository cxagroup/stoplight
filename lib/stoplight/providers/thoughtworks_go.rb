#
# Stoplight Provider for ThoughtWorks Go CI (https://www.gocd.org/)
#
require 'xmlsimple'
module Stoplight::Providers
  class ThoughtworksGo < MultiProjectStandard
    def provider
      'thoughtworks_go'
    end

    def builds_path
      'go/cctray.xml'
    end

    def projects
      if @response.nil? || @response.parsed_response.nil? || @response.parsed_response['Projects'].nil?
        @projects ||= []
      else
        data = XmlSimple.xml_in @response.parsed_response
        @projects ||= [ data['Project'] ].flatten.collect do |project|
          Stoplight::Project.new({
            :name => project['name'],
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
