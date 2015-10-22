#!/usr/bin/env bash
cd /
mkdir /vagrant
chown vagrant:vagrant /vagrant

# Add source statement for environment variables to .bashrc
#
echo 'source /vagrant/config/vagrant/env.bash' >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

echo '192.168.50.4 localhost' >> /etc/hosts
echo '192.168.50.1 isaac10_instance' >> /etc/hosts
echo '192.168.50.1 test.isaac10_instance.dev' >> /etc/hosts


# Do not build documentation for gems (both system and vagrant user)
#
echo 'gem: --no-document' > $HOME/.gemrc
echo 'gem: --no-document' > /home/vagrant/.gemrc
chown vagrant:vagrant /home/vagrant/.gemrc

# Install ruby, libs & servers
# 
add-apt-repository -y ppa:brightbox/ruby-ng
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
curl -sL https://www.archlinux.org/packages/extra/x86_64/unison/download | tar Jx

apt-get install -y postgresql
apt-get install -y build-essential git autoconf bison libpq-dev libreadline6-dev libssl-dev libyaml-dev zlib1g-dev unzip
apt-get install -y ruby2.2 ruby2.2-dev
apt-get install -y nodejs
gem install bundler tmuxinator


# Add PostgreSQL user
#
sudo -u postgres bash -c 'createuser -d isaac10'
sed -i 's/local.*all.*all.*peer/local all all trust/' /etc/postgresql/9.3/main/pg_hba.conf
/etc/init.d/postgresql restart
