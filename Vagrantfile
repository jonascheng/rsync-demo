$package = <<SCRIPT
apt-get update
apt-get install -y inotify-tools incron
#end script
SCRIPT

$rsync_monitor = <<SCRIPT
mkdir -p /home/vagrant/shared
chown -R vagrant.vagrant /home/vagrant/shared
cp /vagrant/incronrsync.sh /usr/local/bin/incronrsync.sh
cp /vagrant/incronrsync.conf /etc/incron.d/incronrsync.conf
#end script
SCRIPT

$sshvm = <<SCRIPT
#check for private key for vm-vm communication
[ -f /vagrant/id_rsa ] || {
  ssh-keygen -t rsa -f /vagrant/id_rsa -q -N ''
}
#deploy key
[ -f /root/.ssh/id_rsa ] || {
    mkdir -p /root/.ssh
    cp /vagrant/id_rsa /root/.ssh/id_rsa
    chmod 0600 /root/.ssh/id_rsa
}
#allow ssh passwordless
grep 'vagrant@server' /root/.ssh/authorized_keys &>/dev/null || {
  cat /vagrant/id_rsa.pub >> /root/.ssh/authorized_keys
  chmod 0600 /root/.ssh/authorized_keys
}
#exclude node* from host checking
cat > /root/.ssh/config <<EOF
Host server*
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
Host 10.1.0.*
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
EOF
#populate /etc/hosts
grep 10.1.0.10 /etc/hosts &>/dev/null || {
    echo 10.1.0.10 server1 | tee -a /etc/hosts &>/dev/null
}
grep 10.1.0.20 /etc/hosts &>/dev/null || {
    echo 10.1.0.20 server2 | tee -a /etc/hosts &>/dev/null
}
grep 10.1.0.30 /etc/hosts &>/dev/null || {
    echo 10.1.0.30 server3 | tee -a /etc/hosts &>/dev/null
}
#end script
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "boxomatic/debian-10"
  config.vm.box_version = "20210723.0.1"
  config.vm.provision "shell", privileged: true, inline: $sshvm
  config.vm.provision "shell", privileged: true, inline: $package
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
