FROM ubuntu:jammy

WORKDIR /$HOME

COPY hello-world $HOME/hello-world

RUN chmod +x $HOME/hello-world

EXPOSE 8080

CMD [ "$HOME/hello-world" ]
