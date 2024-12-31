FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Update and install minimal packages for Metasploit and PostgreSQL
RUN apt update && apt install -y \
    kali-linux-headless \
    && apt clean

# Copy in the entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]