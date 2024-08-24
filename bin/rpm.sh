for i in `rpm -qa --qf "%{NAME}\n" | grep gconf`; do yum -y update $i; done
