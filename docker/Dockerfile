FROM ubuntu:jammy

COPY hello-world /usr/local/bin/hello-world

RUN apt update && apt install -y rustc

RUN chmod +x /usr/local/bin/hello-world

EXPOSE 8080

ENTRYPOINT [ "hello-world" ]
