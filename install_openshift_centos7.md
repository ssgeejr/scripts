#Installing OpenShift Origin on CentOS-7

from: https://linoxide.com/linux-how-to/setup-openshift-origin-centos-7/
```
vi /etc/selinux/config
```

check/update settings to reflect  
SELINUXTYPE=targeted  

bring the system into full compliance  
```
yum update -y
```

Add the insecure registry by editing the file /etc/docker/daemon.json with following content  
```
{
    "insecure-registries" : [ "192.168.0.0/16" ]
}
```

update and restart the service  
```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Find the latest release  
```
https://github.com/openshift/origin/releases
```

download it 
```
wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz -O /openshift/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-server-v3.11.0-0cbc58b-linux-64bit.tar.gz -O /openshift/openshift-origin-server-v3.11.0-0cbc58b-linux-64bit.tar.gz

```

extract, and implement binaries  
```
cd /openshift
tar -zxf openshift-origin-server-*.tar.gz

mv openshift-server* openshift-server

cd openshift-server

mv k* o* /usr/local/sbin/

```










Yum upgrade stuck resolution ... 

2
down vote
This is the way I did fix one CentOS 7 server with 471 dupes.

First I had to install yum utils:

yum install yum-utils
Have tried yum-complete-transaction and other stuff without luck, I gave up the transaction with:

yum-complete-transaction --cleanup-only
Then I got a sorted list of duplicated packages so I could identify older versions to remove filtering even and odd lines later:

package-cleanup --dupes | sort -u > dupes.out
Then I got a uninstall list from this sorted file this way:

cat dupes.out | grep -v 'Loaded plugins:' | sort -u | awk 'NR % 2 == 1' > uninstall.in
Then I removed from rpm database the old versions:

for f in `cat uninstall.in`; do rpm -e --nodeps -f --justdb $f; done
Finally I could continue on regular system upgrade:

yum upgrade

















































































































































































































































































































































































































