Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty64'
  # config.vm.box_check_update = false

  config.vm.network :private_network, ip: "192.168.50.4"

  config.vm.provider 'virtualbox' do |v|
    v.name   = 'isaac10ui_demo'
    v.memory =  512
    v.cpus   =  1
  end

  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provision 'shell', path: 'config/vagrant/bootstrap_server.bash',
                               privileged: true
end
