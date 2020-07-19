FROM python:3.6-alpine3.4

# INSTALL DEPS
RUN apk update && apk upgrade
RUN apk add bash git
RUN pip install --trusted-host pypi.python.org safety bandit

# AUTHZ AND REPO STRUCTURE
RUN addgroup pythonscan
RUN adduser -G pythonscan -g "pythonscan user"  -s /bin/bash -D pythonscan
COPY run.sh /home/pythonscan/
COPY gitleaks-linux-amd64 /home/pythonscan/
RUN chmod +x /home/pythonscan/run.sh
RUN chmod +x /home/pythonscan/gitleaks-linux-amd64
RUN ln -s /home/pythonscan/run.sh /usr/local/bin

USER pythonscan
WORKDIR /home/pythonscan/

ENTRYPOINT ["./run.sh"]