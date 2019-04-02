# docker-centos

Start container - privileged mode:

`docker run -it --privileged -e "container=docker" -v /sys/fs/cgroup:/sys/fs/cgroup:ro   blgo/centos-systemd:base`

Start container -without privileged mode (experimental):

`docker run -it  --tmpfs /tmp --tmpfs /run  -e "container=docker" -v /sys/fs/cgroup:/sys/fs/cgroup:ro   blgo/centos-systemd:base`

Interact with the container:

`docker exec -it container_name`

Containers based on this image run using the following command on the `base` Dockerfile
CMD ["/usr/sbin/init"]

If this is overwritten, systemd won't work

## MySQL8 default password

`docker run -it --privileged --restart always -e "container=docker" -p 3306:3306 -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /mysql:/var/lib/mysql blgo/centos-systemd:mysql8`

Then, get your temp password, which you will need for reseting the root password and adding new users.

`grep -oP 'temporary password(.*): \K(\S+)' /var/log/mysqld.log`
