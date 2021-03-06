#! /bin/bash

sudo apt update 
sudo apt dist-upgrade -y
sudo apt install apache2 mariadb-server curl php-zip zip php-curl php-mysql tree mc vim libapache2-mod-php python3-setuptools unzip wget w3m build-essential openjdk-11-jdk-headless ant testng maven  -y 
sudo apt purge cloud-init -y 
sudo apt autoremove -y
sudo apt clean

wget https://services.gradle.org/distributions/gradle-6.6.1-bin.zip
sudo unzip gradle-6.6.1-bin.zip
rm gradle*.zip
sudo mv gradle-6.6.1 /opt/gradle
export PATH=$PATH:/opt/gradle/gradle/bin
echo "export PATH=$PATH:/opt/gradle/bin" >> $HOME/.bashrc

wget https://bootstrap.pypa.io/get-pip.py
sudo -H python3 get-pip.py
rm get-pip.py
sudo -H pip install notebook bash-kernel
python3 -m bash_kernel.install
mkdir ijava
cd ijava
wget https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip
unzip ijava-1.3.0.zip
sudo -H python3 install.py
cd ..
rm -rf ijava
jupyter notebook --generate-config
cp jupyter_notebook_config.* $HOME/.jupyter/

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install 12
npm install -g yarn

npm install -g ijavascript
ijsinstall

mkdir $HOME/ide
cp package.json $HOME/ide/package.json
cd $HOME/ide/
yarn
yarn theia build
yarn theia download:plugins
echo "export THEIA_DEFAULT_PLUGINS=local-dir:$HOME/ide/plugins" >> $HOME/.bashrc
export THEIA_DEFAULT_PLUGINS=local-dir:$HOME/ide/plugins

sudo mkdir /opt/oi
sudo chown -R oi:oi /opt/oi

echo -e "#! /bin/bash\nsource $HOME/.nvm/nvm.sh\ncd $HOME/ide\nyarn theia start /opt/oi --hostname=0.0.0.0" > $HOME/theia.sh
chmod +x $HOME/theia.sh
echo -e "[Unit]\nDescription=Theia IDE\n\n[Service]\nType=simple\nPIDFile=/run/theia.pid\nEnvironment=THEIA_DEFAULT_PLUGINS=local-dir:/home/oi/ide/plugins\nExecStart=/home/oi/theia.sh\nUser=oi\nGroup=oi\nWorkingDirectory=/home/oi/ide/\nRestart=always\nRestartSec=10\n\n[Install]\nWantedBy=multi-user.target" > $HOME/theia.service
sudo mv $HOME/theia.service /lib/systemd/system/
sudo systemctl enable theia.service

echo -e "#! /bin/bash\nsource $HOME/.nvm/nvm.sh\njupyter notebook --no-browser" > $HOME/jupyter.sh
chmod +x $HOME/jupyter.sh
echo -e "[Unit]\nDescription=Jupyter Notebook\n\n[Service]\nType=simple\nPIDFile=/run/jupyter.pid\nExecStart=/home/oi/jupyter.sh\nUser=oi\nGroup=oi\nWorkingDirectory=/opt/oi/\nRestart=always\nRestartSec=10\n\n[Install]\nWantedBy=multi-user.target" > jupyter.service
sudo mv jupyter.service /lib/systemd/system/
sudo systemctl enable jupyter.service

wget https://github.com/vrana/adminer/releases/download/v4.7.7/adminer-4.7.7.php
sudo mv adminer-4.7.7.php /var/www/html/adminer.php
