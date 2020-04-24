# frozen_string_literal: true

title 'maven archives profile'

control 'maven archive' do
  impact 1.0
  title 'should be installed'

  describe file('/etc/default/maven.sh') do
    it { should exist }
  end
  describe file('/usr/local/apache-maven-*/bin/mvn') do
    it { should exist }
  end
  describe file('/usr/local/bin/mvn') do
    it { should exist }
  end
end
