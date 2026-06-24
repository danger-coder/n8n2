FROM n8nio/n8n:latest

USER root

RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n

USER node

# Render injects $PORT at runtime; n8n reads N8N_PORT
ENV N8N_PORT=5678

EXPOSE 5678

ENTRYPOINT ["n8n", "start"]
