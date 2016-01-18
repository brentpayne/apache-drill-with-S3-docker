FROM java:7
MAINTAINER brentpayne

# install dev tools 
RUN apt-get install -y wget tar
# get drill 
RUN wget http://www.interior-dsgn.com/apache/drill/drill-1.4.0/apache-drill-1.4.0.tar.gz
# create Drill folder 
RUN mkdir -p /opt/drill
# extract Drill 
RUN tar -xvzf apache-drill-1.4.0.tar.gz -C /opt/drill

EXPOSE 8047
EXPOSE 31010

# add boot script
ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh && chmod 700 /etc/bootstrap.sh

# add custom drill configuartions
ADD drill-override.conf /opt/drill/apache-drill-1.4.0/conf/drill-override.conf
ADD core-site.xml /opt/drill/apache-drill-1.4.0/conf/core-site.xml

# add custom drill storage
RUN mkdir -p /drill-storage/sys.storage_plugins
ADD cp.sys.drill /drill-storage/sys.storage_plugins/cp.sys.drill
ADD dfs.sys.drill /drill-storage/sys.storage_plugins/dfs.sys.drill
ADD s3.sys.drill /drill-storage/sys.storage_plugins/s.sys.drill

CMD bash /etc/bootstrap.sh
