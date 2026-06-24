FROM n8nio/n8n:latest

USER root

RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n

USER node

EXPOSE 5678

# Render injects $PORT; pass it to n8n via N8N_PORT
CMD ["sh", "-c", "N8N_PORT=${PORT:-5678} n8n start"]
