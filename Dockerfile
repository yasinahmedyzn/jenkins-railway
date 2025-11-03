# ✅ Use the official Jenkins LTS image as base
FROM jenkins/jenkins:lts

# ------------------------------------------------------------
# STEP 1: Switch to root to install dependencies and set up
# ------------------------------------------------------------
USER root

# Install useful tools (optional)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# STEP 2: Copy your OLD Jenkins data (jobs, plugins, users)
# ------------------------------------------------------------
# Make sure you have a folder named 'jenkins_home_local' beside this Dockerfile
# It should contain your old Jenkins data (jobs/, users/, config.xml, secrets/, etc.)
COPY --chown=1000:1000 jenkins_home_local /var/jenkins_home

# ------------------------------------------------------------
# STEP 3: Switch back to Jenkins user
# ------------------------------------------------------------
USER jenkins

# Disable setup wizard — Jenkins will boot directly into your old config
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# ------------------------------------------------------------
# STEP 4: Railway port configuration
# ------------------------------------------------------------
# Railway assigns a random dynamic port
ARG PORT=8080
ENV PORT=${PORT}
EXPOSE ${PORT}

# ------------------------------------------------------------
# STEP 5: Start Jenkins using the dynamic port
# ------------------------------------------------------------
CMD ["bash", "-c", "java -jar /usr/share/jenkins/jenkins.war --httpPort=$PORT --httpListenAddress=0.0.0.0 --prefix=/ --enable-future-java --argumentsRealm.passwd.admin=admin --argumentsRealm.roles.admin=admin --webroot=%C/jenkins/war"]
