FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
	apache2 \
	openjdk-8-jdk-headless \
	apache2-dev \
	build-essential \
	wget

COPY ./tomcat.sh /
RUN chmod +x /tomcat.sh && \
	/tomcat.sh && \
	rm /tomcat.sh

COPY ./apache2.sh /
RUN chmod +x /apache2.sh && \
	/apache2.sh && \
	rm /apache2.sh

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD [ "/entrypoint.sh" ]
