# -----------------------------
# 1️⃣ Base Image
# -----------------------------
FROM jenkins/jenkins:lts

# -----------------------------
# 2️⃣ Switch to root to install dependencies and fix permissions
# -----------------------------
USER root

# Install optional tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Create Jenkins home folder and fix ownership
RUN mkdir -p /var/jenkins_home && chown -R 1000:1000 /var/jenkins_home

# -----------------------------
# 3️⃣ Copy your old Jenkins home
# -----------------------------
# Make sure 'jenkins_home_local' exists beside Dockerfile
COPY --chown=1000:1000 jenkins_home_local /var/jenkins_home

# -----------------------------
# 4️⃣ Switch back to Jenkins user
# -----------------------------
USER jenkins

# -----------------------------
# 5️⃣ Memory optimization and setup wizard skip
# -----------------------------
ENV JAVA_OPTS="-Xmx384m -Djenkins.install.runSetupWizard=false"

# -----------------------------
# 6️⃣ Railway dynamic port binding
# -----------------------------
ARG PORT=8080
ENV PORT=${PORT}
EXPOSE ${PORT}

# -----------------------------
# 7️⃣ Start Jenkins listening on all interfaces and Railway port
# -----------------------------
CMD ["bash", "-c", "java -jar /usr/share/jenkins/jenkins.war --httpPort=$PORT --httpListenAddress=0.0.0.0 --prefix=/"]
