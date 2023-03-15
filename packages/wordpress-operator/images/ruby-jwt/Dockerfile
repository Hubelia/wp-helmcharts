# Copy the wordpress-operator binary into a thin image
# The image is pinned to the nonroot tag
FROM docker.io/library/ruby
RUN apt-get update -y && apt-get install apt-utils && apt-get install python3-pip default-mysql-client -y && pip3 install git-filter-repo && apt-get dist-upgrade -y && gem install jwt && apt-get install -y zip jq && apt-get remove -y apt-utils python3-pip && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/www && chown -R www-data:www-data /var/www
