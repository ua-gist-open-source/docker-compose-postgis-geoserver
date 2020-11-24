FROM mdillon/postgis

RUN apt-get update && apt-get upgrade -y && apt-get install -y unzip curl && apt-get autoremove -y

ENV STATE
ENV DATABASE
ENV USER=postgres
ENV HOST=postgis
ENV PORT=5432

COPY ./populate.sh /populate.sh

RUN chmod 755 /populate.sh

CMD ["/populate.sh"]