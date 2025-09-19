FROM ollama/ollama:latest AS builder

# Start Ollama server in background and wait for it to become ready
# Replace with your desired model(s)
RUN nohup ollama serve > /tmp/ollama.log 2>&1 & \
    sleep 10 && \
    ollama pull gemma3:270m

RUN nohup ollama serve > /tmp/ollama.log 2>&1 & \
    sleep 10 && \
    ollama pull gemma3n:e4b

RUN nohup ollama serve > /tmp/ollama.log 2>&1 & \
    sleep 10 && \
    ollama pull embeddinggemma:300m


# Final image
FROM ollama/ollama:latest

# Copy preloaded model cache
COPY --from=builder /root/.ollama /root/.ollama

# Expose Ollama port
EXPOSE 11434

# Run the Ollama server normally
CMD ["serve"]