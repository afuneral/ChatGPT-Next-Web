FROM  cr.yealinkops.com/runtime/node:16.14.0.0

ARG DOCKER_PACKAGE_PATH
ENV DOCKER_PACKAGE_PATH "${DOCKER_PACKAGE_PATH}"

ENV SERVICE_NAME=chatgpt-next-web
ENV SERVICE_HOME=/opt/${SERVICE_NAME}
ENV SERVICE_EXEC_START="npm run start -p ${SERVICE_PORT}"
ENV PATH=${SERVICE_HOME}/bin:$PATH

RUN groupadd ${SERVICE_NAME} && useradd -g ${SERVICE_NAME} ${SERVICE_NAME}

COPY --chown=chatgpt-next-web:chatgpt-next-web docker-entrypoint.sh /docker-entrypoint.sh
COPY --chown=chatgpt-next-web:chatgpt-next-web ${DOCKER_PACKAGE_PATH} ${SERVICE_HOME}

RUN chmod +x /docker-entrypoint.sh \
    && ln -s /docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

WORKDIR ${SERVICE_HOME}/
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["chatgpt-next-web"]
