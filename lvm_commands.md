apt-get install lvm2

/etc/init.d/lvm start

*#not needed, utility for graphically configuring Logical Volumes*
*apt-get install system-config-lvm*


```
pvcreate /dev/sdb 
vgcreate dockervg /dev/sdb
lvcreate --name datalv1 -l 100%FREE dockervg
mkfs.ext4 /dev/dockervg/datalv1
mkdir /var/lib/docker
mount /dev/dockervg/datalv1 /var/lib/docker
echo "/dev/dockervg/datalv1 /var/lib/docker ext4 defaults 0 0" >> /etc/fstab
```

```
To extend an existing lvm partition:
pvcreate /dev/xvdi
vgextend artifactoryRepo /dev/xvdi
lvextend -l +100%FREE /dev/artifactoryRepo/lv1
resize2fs /dev/artifactoryRepo/lv1
```
