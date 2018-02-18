
# master
template "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  variables({
    :master => 'false',
    :data => 'true',
    :path_data => '/var/lib/elasticsearch',
    :path_logs => '/var/log/elasticsearch',
    :http_enabled => 'false'
  })
end

# master
template "/etc/elasticsearch/jvm.yml" do
  source "jvm.yml.erb"
  variables({
    :xms => '4',
    :xmx => '4'
  })
end
