#!/bin/bash -eux

# Enable EPEL REPO
#yum -y --enablerepo=extras install epel-release
yum install -y epel-release
yum -y update

yum groupinstall -y "Development tools"
yum install -y elfutils-libelf-devel \
  iperf \ 
  cmake3 

cd
mkdir build
cd build
curl -OL https://ftp.gnu.org/gnu/bison/bison-3.0.tar.xz
tar -xf bison-3.0.tar.xz
cd bison-3.0
./configure
make
make install
yum remove -y bison

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
curl -LO https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum localinstall -y https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install -y kernel-ml kernel-ml-devel

cd ~/build
yum install -y yum-utils </dev/null
yumdownloader --enablerepo=elrepo-kernel kernel-ml-headers </dev/null
rpm2cpio kernel-ml-headers*.rpm | cpio -idmv
grub2-set-default 0
shutdown -P now
