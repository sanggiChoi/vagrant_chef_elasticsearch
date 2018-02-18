
yum_package "yum-fastestmirror" do
  action :install
end

execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

execute "chagne-timezone" do
  user "root"
  command "cp -p /usr/share/zoneinfo/Asia/Seoul /etc/localtime"
  action :run
end

=begin
execute "yum-remove-java-7" do
  user "root"
  command "yum remove java-1.7.0-openjdk.x86_64 -y"
  action :run
end

execute "yum-install-java-8" do
  user "root"
  command "yum install java-1.8.0-openjdk-devel.x86_64 -y"
  action :run
end
=end

yum_package 'java-1.7.0-openjdk.x86_64' do
  action :remove
end

yum_package 'java-1.8.0-openjdk-devel.x86_64' do
  action :install
end

rpm_package "yum-downloads-elasticsearch-5.6.7" do
  source "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.7.rpm"
  action :install
end

=begin
execute "sysconfig_elasticsearch" do
  user "root"
  command "sed -i 's/#MAX_LOCKED_MEMORY=unlimited/MAX_LOCKED_MEMORY=unlimited/g' /etc/sysconfig/elasticsearch"
  action :run
end
=end

ruby_block "sysconfig_elasticsearch" do
  block do
    file = Chef::Util::FileEdit.new("/etc/sysconfig/elasticsearch")
    file.insert_line_after_match("#MAX_LOCKED_MEMORY=unlimited", "MAX_LOCKED_MEMORY=unlimited")
    file.write_file
  end
end

ruby_block "security_limit" do
  block do
    file = Chef::Util::FileEdit.new("/etc/security/limits.conf")
    file.insert_line_if_no_match("elasticsearch hard memlock unlimited", "elasticsearch hard memlock unlimited")
    file.insert_line_if_no_match("elasticsearch soft memlock unlimited", "elasticsearch soft memlock unlimited")
    file.write_file
  end
end
