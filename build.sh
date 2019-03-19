#!/bin/bash -e

echo "edit me !!!!" ; exit 1
myrepo=docker.high-con.de

function makeit() {
    base=$1
    name=$2
    echo "FROM $base" > Dockerfile
    #echo "RUN sed -i -e 's/v[[:digit:]]\.[[:digit:]]/edge/g' /etc/apk/repositories" >> Dockerfile
    echo "RUN apk upgrade --update-cache --available" >> Dockerfile
    echo "RUN apk add alpine-sdk bash emacs-nox mc openssh-client perl linux-headers" >> Dockerfile
    echo "RUN sed 's/^# Host \*/Host \*/' -i /etc/ssh/ssh_config" >> Dockerfile
    echo "RUN sed 's/^#   StrictHostKeyChecking ask/  StrictHostKeyChecking no/' -i /etc/ssh/ssh_config" >> Dockerfile    
    if [ -f gitconfig ] ; then
	echo "COPY gitconfig /root/.gitconfig" >> Dockerfile
    fi
    echo "COPY bashrc /root/.bashrc" >> Dockerfile
    echo "COPY git-prompt /root/.git-prompt" >> Dockerfile
    echo "RUN mkdir /root/.ssh && chmod 700 /root/.ssh" >> Dockerfile
    if [ -f id_rsa.pub ] ; then
	echo "COPY id_rsa.pub /root/.ssh/" >> Dockerfile
    fi
    if [ -f id_rsa ] ; then
	echo "COPY id_rsa /root/.ssh/" >> Dockerfile
	echo "RUN chmod 600 /root/.ssh/id_rsa" >> Dockerfile
    fi
    echo "ENV USER=root" >> Dockerfile
    echo "WORKDIR ~/" >> Dockerfile
    echo "CMD [\"/bin/bash\"]" >> Dockerfile
    docker build -t $name .
    rm -f Dockerfile    
}


makeit ${myrepo}/alpine-mini-amd64:3.9.2 alpine-devel-amd64:3.9.2



