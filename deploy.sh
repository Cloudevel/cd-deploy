#! /bin/bash
sudo apt update
sudo apt dist-upgrade -y
sudo apt install apache2 curl mariadb-server php-zip zip php-curl php-mysql tree mc vim libapache2-mod-php python3-setuptools unzip wget w3m build-essential -y
sudo apt autoremove -y
sudo apt clean

wget https://bootstrap.pypa.io/get-pip.py
sudo -H python3 get-pip.py
rm get-pip.py
sudo -H pip install notebook bash-kernel
python3 -m bash_kernel.install
jupyter notebook --generate-config
cp jupyter_notebook_config.* $HOME/.jupyter/

sudo mkdir /opt/oi
sudo chown -R oi:oi /opt/oi

echo -e "#! /bin/bash\njupyter notebook --no-browser" > $HOME/jupyter.sh
chmod +x $HOME/jupyter.sh
echo -e "[Unit]\nDescription=Jupyter Notebook\n\n[Service]\nType=simple\nPIDFile=/run/jupyter.pid\nExecStart=/home/oi/jupyter.sh\nUser=oi\nGroup=oi\nWorkingDirectory=/opt/oi/\nRestart=always\nRestartSec=10\n\n[Install]\nWantedBy=multi-user.target" > jupyter.service
sudo mv jupyter.service /lib/systemd/system/
sudo systemctl enable jupyter.service

sudo mysql -u root -proot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '0p3n5t4ck';"
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php
sudo mv adminer-4.8.1.php /var/www/html/adminer.php
