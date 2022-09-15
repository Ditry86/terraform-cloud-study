FROM elasticsearch:7.17.6
USER root
RUN mkdir -p -m 775 /var/lib/{data,logs}
RUN chown -R 1000:1000 /var/lib/{data,logs}
RUN mkdir ${ES_HOME}/snapshots
ADD elasticsearch.yml /usr/share/elasticsearch/config/
RUN chown 1000:1000 config/elasticsearch.yml 
USER elasticsearch