require 'spec_helper'
include Stoplight::Providers

describe JenkinsFolders do
  use_vcr_cassette 'jenkins_folders', :record => :new_episodes

  it 'should inherit from from Stoplight::MultiProjectStandard' do
    JenkinsFolders.superclass.should == MultiProjectStandard
  end

  describe '#provider' do
    it 'should return the correct provider name' do
      provider = JenkinsFolders.new('url' => 'http://ci.jenkins-ci.org')
      provider.provider.should == 'jenkins_folders'
    end
  end
end
