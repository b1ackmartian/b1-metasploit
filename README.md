# Metasploit Lab

This project sets up a Kali-based container (with Metasploit and PostgreSQL) and two vulnerable web apps (DVWA and Juice Shop) for hands-on security testing.

## Building the Docker Image

- Clone or download this repository.
- From the project root (where build.sh is located), run:

```sh
./scripts/build.sh --image <image:tag>
```

> If you skip the --image option, it defaults to metasploit:lab.

## Starting the Lab

1. Run:

```sh
./scripts/start_lab.sh --image <image:tag>
```

> If you skip the --image option, it defaults to metasploit:lab.


2. This will:

- Launch DVWA on host port 8080 (container port 80).
- Launch Juice Shop on host port 3000 (container port 3000).
- Spin up an interactive Kali shell with Metasploit ready to go.

3. When you exit the Kali container, the script automatically stops the DVWA and Juice Shop containers.

That’s it! You should now be able to access the DVWA and Juice Shop sites in your browser and use the Kali container to run Metasploit or other tools.
