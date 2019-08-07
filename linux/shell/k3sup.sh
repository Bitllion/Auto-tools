#!/bin/bash
#This Auto_upgrade_k3s
# If u first use this scpirt just input:
# wget -P /opt/k3sup/ https://git.io/fjQVd && chmod +x /opt/k3sup/k3sup.sh && bash /opt/k3sup/k3sup.sh 
function detection_shell(){
a= find ~/.bashrc | xargs grep -ri "k3sup"
if 	[ -z $a ]
	then
		echo "安装k3s中......" 
		echo "alias k3sup='bash /opt/k3sup/k3sup.sh'" >> ~/.bashrc
		source ~/.bashrc
	else exit
fi
}

function download(){
	echo "更新中...,请耐心等待"
	wget -P /opt/k3sup/ https://k3s-images.oss-cn-qingdao.aliyuncs.com/k3s
	wget -P /opt/k3sup/ https://k3s-images.oss-cn-qingdao.aliyuncs.com/k3s-airgap-images-amd64.tar
}

function configer(){
	systemctl stop k3s
	mv /opt/k3sup/k3s /usr/local/bin/k3s
	chmod +x /usr/local/bin/k3s
	mkdir -p /var/lib/rancher/k3s/agent/images/
    mv /opt/k3sup/k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/
	curl -sfL https://get.k3s.io | sh -
	#change from containerd to docker 
	sed -i 's/server/& --docker --no-deploy traefik/' /etc/systemd/system/multi-user.target.wants/k3s.service	
	systemctl daemon-reload
   	systemctl restart k3s
	mv new.log old.log
}

function upgrade(){
	download
	configer
}

function judge_version(){

wget -P /opt/k3sup https://k3s-images.oss-cn-qingdao.aliyuncs.com/new.log 

if [ "$(cat /opt/k3sup/new.log)" == "$(cat /opt/k3sup/old.log)" ]
then 
	echo "已经是最新的了啊！不需要更新了呢~"
	exit
else 
	upgrade
	echo "更新完毕,K3S版本：$(echo $(k3s --version))"
fi
}

detection_shell
judge_version
