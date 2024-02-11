# Use a more specific base image
FROM apache/airflow:latest-python3.11

# Set the Airflow home directory
ENV AIRFLOW_HOME=/opt/airflow
USER root
# Install vim and other essential packages (if still needed)
# Note: Base image may already include necessary packages
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
USER airflow
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Google Cloud SDK (consider using a package manager)
# If available, use apt-get or pip to install for better maintenance:
# RUN apt-get install -y google-cloud-sdk
# If package not available, use the following:
USER root
ARG CLOUD_SDK_VERSION=463.0.0  # Update to the latest version
ENV GCLOUD_HOME=/google-cloud-sdk
ENV PATH="${GCLOUD_HOME}/bin/:${PATH}"
RUN DOWNLOAD_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz" \
    && TMP_DIR="$(mktemp -d)" \
    && curl -fL "${DOWNLOAD_URL}" --output "${TMP_DIR}/google-cloud-sdk.tar.gz" \
    && mkdir -p "${GCLOUD_HOME}" \
    && tar xzf "${TMP_DIR}/google-cloud-sdk.tar.gz" -C "${GCLOUD_HOME}" --strip-components=1 \
    && "${GCLOUD_HOME}/install.sh" \
       --bash-completion=false \
       --path-update=false \
       --usage-reporting=false \
       --quiet \
    && rm -rf "${TMP_DIR}" \
    && gcloud --version

# Set the working directory
WORKDIR $AIRFLOW_HOME

# Copy scripts and set permissions
COPY scripts scripts
RUN chmod +x scripts

# Switch back to the airflow user
USER $AIRFLOW_UID