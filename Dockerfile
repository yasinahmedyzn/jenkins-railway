# Use the official Jenkins LTS image as base
FROM jenkins/jenkins:lts

# Switch to root to install dependencies and fix permissions
USER root

# Install useful tools (optional)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Create Jenkins home and fix permissions
RUN mkdir -p /var/jenkins_home && chown -R 1000:1000 /var/jenkins_home

# Switch back to Jenkins user
USER jenkins

# Disable the setup wizard (optional but speeds up boot)
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Railway sets a dynamic $PORT — make Jenkins bind to it
ARG PORT=8080
ENV PORT=${PORT}

# Expose the port Jenkins will listen on
EXPOSE ${PORT}

# Start Jenkins bound to Railway's dynamic port
CMD ["bash", "-c", "java -jar /usr/share/jenkins/jenkins.war --httpPort=$PORT"]
