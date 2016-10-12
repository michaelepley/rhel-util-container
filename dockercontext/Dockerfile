FROM registry.access.redhat.com/rhel7/rhel

MAINTAINER mepley@redhat.com

LABEL vendor="Red Hat"
LABEL version="1.0"
LABEL description="RHEL"

ARG redhatsubscriptionuser
ARG redhatsubscriptionuserpassword
ARG redhatsubscriptionuserpoolid
 
RUN useradd -u 59309 -m -r -g 0 -G users -c user user \
	&& subscription-manager register --username $redhatsubscriptionuser --password $redhatsubscriptionuserpassword \
	&& subscription-manager attach --pool $redhatsubscriptionuserpoolid \
	&& subscription-manager repos --disable="*" \
	&& subscription-manager repos --enable=rhel-7-server-extras-rpms \
	&& subscription-manager repos --enable=rhel-7-server-optional-rpms \
	&& subscription-manager repos --enable=rhel-7-server-rh-common-rpms \
	&& subscription-manager repos --enable=rhel-7-server-rpms \
	&& subscription-manager repos --enable=rhel-7-server-supplementary-rpms \
	&& subscription-manager repos --enable=rhel-server-rhscl-7-rpms \
	&& yum install -y sudo \
	&& yum clean all \
	&& sed -i '\|Same thing without a password| a %users        ALL=(ALL)       NOPASSWD: ALL' /etc/sudoers

EXPOSE 22

WORKDIR /home/user

USER 59309