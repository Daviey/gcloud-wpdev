FROM php:7.2-cli-alpine

RUN apk add --update \
    bash \
    wget \
    python

RUN docker-php-ext-install bcmath mysqli


# Download and install gcloud package
ENV GCLOUD_VERSION=256.0.0
ENV GCLOUD_FILENAME=google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz
ENV GCLOUD_URL=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_FILENAME}
ENV GCLOUD_SHA256SUM=7237fc06ca1c0a1263bb107638e72f69539056ff7455983827cf2908dd09ed2d

ENV CLOUDSDK_CORE_DISABLE_PROMPTS=1 \
    CLOUDSDK_PYTHON_SITEPACKAGES=1

RUN wget -q ${GCLOUD_URL} \
  && echo "${GCLOUD_SHA256SUM}  ${GCLOUD_FILENAME}" | sha256sum -c

RUN mkdir /opt/gcloud \
  && tar -xzf /${GCLOUD_FILENAME} --strip 1 -C /opt/gcloud \
  && /opt/gcloud/install.sh \
  && rm -f /${GCLOUD_FILENAME}

# Adding the package path to local
ENV PATH $PATH:/opt/gcloud/bin

# Add additional gcloud components
RUN /opt/gcloud/bin/gcloud components install -q \
    app-engine-php \
    cloud-datastore-emulator

RUN wget -q https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy \
    && chmod +x cloud_sql_proxy

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
