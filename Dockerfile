FROM hshar/webapp

RUN rm -f /var/run/apache2/apache2.pid

COPY index.html /var/www/html/
COPY images/ /var/www/html/images/
