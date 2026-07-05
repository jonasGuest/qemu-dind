#!/bin/bash

curl "https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/cloud/nocloud_alpine-3.20.0-x86_64-bios-cloudinit-r0.qcow2" -o alpine-docker.qcow2

qemu-img resize alpine-docker.qcow2 10G

guestfish -a alpine-docker.qcow2 --rw <<EOF
run
e2fsck-f /dev/sda
resize2fs /dev/sda
exit
EOF

virt-customize -a alpine-docker.qcow2 \
   --run-command "apk del cloud-init" \
   --install openssh,docker \
   --run-command "rc-update add sshd default" \
   --run-command "rc-update add docker default" \
   --run-command "sed -i '/^[# \t]*PermitRootLogin/d' /etc/ssh/sshd_config" \
   --run-command "echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config" \
   --run-command "sed -i '/^[# \t]*AllowTcpForwarding/d' /etc/ssh/sshd_config" \
   --run-command "echo 'AllowTcpForwarding yes' >> /etc/ssh/sshd_config" \
   --run-command "echo 'DOCKER_OPTS=\"-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock\"' >> /etc/conf.d/docker" \
   --run-command "echo 'net.ipv4.ip_local_port_range = 30000 30020' >> /etc/sysctl.conf" \
   --root-password password:alpine
