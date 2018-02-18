# -*- mode: ruby -*-
# vi: set ft=ruby :

aws_config = (JSON.parse(File.read("aws_elasticsearch.json")))

Vagrant.configure("2") do |config|
  config.vm.box = "aws-dummy"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  aws_config['instances'].each do |instance|
    instance_key   = instance[0]
    instance_value = instance[1]

    config.vm.define instance_key do |config2|
	     ec2_tags = instance_value['tags']

       config2.vm.provision "chef_solo" do |chef|
         chef.add_recipe "elastic::default"
         #chef.log_level = :debug
         if ec2_tags['Name'].include?('elastic-5.6-master')
           chef.add_recipe "elastic::master"
         elsif ec2_tags['Name'].include?('elastic-5.6-client')
           chef.add_recipe "elastic::client"
         elsif ec2_tags['Name'].include?('elastic-5.6-data')
           chef.add_recipe "elastic::data"
         end
       end

       config2.vm.provider :aws do |ec2, override|
         #ec2.access_key_id      = ENV['AWS_ACCEESS_KEY_ID']
         #ec2.secret_access_key  = ENV['AWS_SECRET_ACCESS_KEY']
         ec2.access_key_id      = aws_config['access_key']
         ec2.secret_access_key  = aws_config['secret_key']
         ec2.region             = aws_config['region']
         ec2.availability_zone  = aws_config['region'] + aws_config['availability_zone']
         ec2.keypair_name       = aws_config['keypair_name']
         #ec2.subnet_id = aws_config['subnet_id']
         ec2.security_groups    = aws_config['security_groups']
         ec2.ami                = instance_value['ami_id']
         ec2.instance_type      = instance_value['instance_type']
         ec2.tags = {
           'Name' => ec2_tags['Name'],
			     'Role' => ec2_tags['Role']
		     }

         override.nfs.functional        = false
		     override.ssh.username          = aws_config['ssh_username']
         override.ssh.private_key_path  = aws_config['ssh_private_key_path']

       end
     end
   end
end
