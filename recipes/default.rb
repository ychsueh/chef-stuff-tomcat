
package 'java-1.7.0-openjdk-devel'

group 'tomcat'

user 'tomcat' do
  manage_home false
  shell '/sbin/nologin'
  group 'tomcat'
  home '/opt/tomcat'
end

remote_file 'apache-tomcat-8.5.20.tar.gz' do
  source 'http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.20/bin/apache-tomcat-8.5.20.tar.gz'
end

# execute 'sudo mkdir /opt/tomcat'

directory '/opt/tomcat' do
  only_if { ::File.exist?('/opt/tomcat') }
  group 'tomcat'
end

# could use directory construct better here
execute 'sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'

directory '/opt/tomcat/conf' do
  mode '0070'
end

execute 'chgrp -R tomcat /opt/tomcat'
execute 'sudo chgrp -R tomcat /opt/tomcat/conf'
execute 'sudo chmod -R g+r /opt/tomcat/conf'
execute 'sudo chmod g+x /opt/tomcat/conf/*'
execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ opt/tomcat/temp/ /opt/tomcat/logs/'

#Install the Systemd Unit File

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

#execute 'sudo systemctl daemon-reload'

service 'tomcat' do
  action [:start, :enable]
end
