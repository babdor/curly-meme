FROM ubuntu:jammy

COPY hello-world /hello-world

RUN chmod +x /hello-world

EXPOSE 8080

ENTRYPOINT [ "/hello-world", "-l", "-c" ]
