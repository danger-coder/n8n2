FROM n8nio/n8n:latest

USER root
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

COPY wait-for-db.sh /wait-for-db.sh
RUN chmod +x /wait-for-db.sh

USER node

EXPOSE 10000

ENTRYPOINT ["/wait-for-db.sh"]
