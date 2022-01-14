$package = <<SCRIPT
apt-get update
apt-get install -y inotify-tools incron
#end script
SCRIPT

$rsync_daemon = <<SCRIPT
cp /vagrant/rsyncd.* /etc
chmod 600 /etc/rsyncd.secrets
cp /vagrant/secret /etc
chmod 600 /etc/secret
systemctl enable rsync
systemctl start rsync
#end script
SCRIPT

$rsync_monitor = <<SCRIPT
mkdir -p /home/vagrant/shared
chown -R vagrant.vagrant /home/vagrant/shared
cp /vagrant/incronrsync.sh /usr/local/bin/incronrsync.sh
cp /vagrant/incronrsync.conf /etc/incron.d/incronrsync.conf
#end script
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "boxomatic/debian-10"
  config.vm.box_version = "20210723.0.1"
  config.vm.provision "shell", privileged: true, inline: $package
  config.vm.provision "shell", privileged: true, inline: $rsync_daemon
  config.vm.provision "shell", privileged: true, inline: $rsync_monitor

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end

  config.vm.define "server1" do |node|
    node.vm.hostname = "server1"
    node.vm.network "private_network", ip: "10.1.0.10", hostname: true
  end

  config.vm.define "server2" do |node|
    node.vm.hostname = "server2"
    node.vm.network "private_network", ip: "10.1.0.20", hostname: true
  end

 config.vm.define "server3" do |node|
   node.vm.hostname = "server3"
   node.vm.network "private_network", ip: "10.1.0.30", hostname: true
 end

end
