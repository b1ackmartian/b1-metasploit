FROM kalilinux/kali-rolling

# Update and install minimal packages for Metasploit and PostgreSQL
RUN apt update && apt -y full-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt -y install \
    kali-linux-headless

CMD ["bash"]