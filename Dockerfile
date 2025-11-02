FROM jenkins/jenkins:lts

USER root
RUN apt-get update && apt-get install -y git curl vim && rm -rf /var/lib/apt/lists/*

# Copy jenkins_home and set ownership to UID 1000 (jenkins user)
COPY --chown=1000:1000 jenkins_home /var/jenkins_home

USER jenkins
EXPOSE 8080
