FROM ubuntu:22.04

ARG CHANGE_USER=0

COPY gitconfig /home/sidecar/.gitconfig

RUN set -ex; \
	apt-get update ; \
	echo 'tzdata tzdata/Areas select America' | debconf-set-selections ; \
	echo 'tzdata tzdata/Zones/America select Vancouver' | debconf-set-selections ; \
	DEBIAN_FRONTEND="noninteractive" apt-get install -y \
		software-properties-common \
		build-essential \
		ca-certificates \
		tzdata \
		sed \
		curl \
		neovim \
		rsync \
		php \
		php-xml \
		php-mysqli \
		php-bcmath \
		php-curl \
		php-exif \
		php-gd \
		php-zip \
		composer \
		mariadb-client \
		inetutils-ping \
	; \
	add-apt-repository ppa:git-core/ppa ; \
	apt-get update ; \
	DEBIAN_FRONTEND="noninteractive" apt-get install -y git ; \
	rm -rf /var/lib/apt/lists/* ; \
	useradd -u 12358 -g 0 -m -s /bin/bash sidecar ; \
	# Replace dash shell with bash shell for sh use.
	#ln -f -s /usr/bin/bash /usr/bin/sh ; \
	# Fix up dpkg to run in a baby-root environment. (Needed for some apt packages).
	mv /usr/bin/dpkg /usr/bin/ddpkg ; \
	echo '#!/bin/bash\n/usr/bin/ddpkg --force-not-root "$@"\n' > /usr/bin/dpkg ; \
	chmod +x /usr/bin/dpkg ; \
	# Install WP-CLI
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar ; \
	chmod +x wp-cli.phar ; \
	mv wp-cli.phar /usr/local/bin/wp ; \
	\
	# Make a nice git-enabled shell prompt.
	#echo "source /usr/local/bin/git-prompt.sh\nexport PS1='\n\[\e[1;32m\]\u\[\e[0;39m\]@\[\e[1;36m\]\h\[\e[0;39m\]:\[\e[1;33m\]\w\[\e[0;39m\]\[\e[1;35m\]\$(__git_ps1 \" (%s)\")\[\e[0;39m\] \[\e[0;39m\]\n$ '\n" >> /home/sidecar/.bashrc ; \
	#curl -O https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh ; \
	#chmod +x git-prompt.sh ; \
	#mv git-prompt.sh /usr/local/bin/git-prompt.sh ; \
	\
	# Replace the garbage dash interactive shell with bash when an interactive shell is opened, cleaning up the garbage shell when bash is done.
	echo '/bin/bash --login && exit\n' >> /home/sidecar/.shinit ; \
	# Make a shell prompt that is kinder to maintenance folk, more informative than "$".
	echo "export PS1='\n\[\e[1;32m\]\u\[\e[0;39m\]@\[\e[1;36m\]\h\[\e[0;39m\]:\[\e[1;33m\]\w\[\e[0;39m\]\[\e[1;35m\]\[\e[0;39m\] \[\e[0;39m\]\n$ '\n" >> /home/sidecar/.bashrc ; \
	# Make ls more helpful.
	echo 'alias ls="ls --color "\n' >> /home/sidecar/.bashrc ; \
	# Upon a login shell, load all of the interactive options.
	echo ". /etc/bash.bashrc\n. /home/sidecar/.bashrc\n" >> /home/sidecar/.bash_profile ; \
	\
	# You cannot be root inside an openshift container, but we don't need to be if everything is owned
	# by the sidecar user; the sidecar user is baby-root then.
	find / \( \
		-path /proc -o \
		-path /dev -o \
		-path /sys \
	\) -prune -o \( \
		-xtype l -exec rm {} \; -o \
		-exec chmod g=u {} \; -a \
		-exec chgrp 0 {} \; -a \
		-exec chown $CHANGE_USER {} \; \
	\)

ENV ENV="\$HOME/.shinit"

COPY ./docker-entrypoint.sh /

VOLUME /var/www/html

ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR /home/sidecar

CMD ["sleep", "infinity"]

SHELL ["/bin/bash", "-c"]
