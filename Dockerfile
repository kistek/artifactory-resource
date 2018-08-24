FROM concourse/buildroot:curl

COPY assets/ /opt/resource/
COPY test/ /opt/resource-tests/
COPY tools/ /opt/tools/

RUN rm /usr/bin/jq && \
    mv /opt/tools/jq /usr/bin/jq

# Run tests
# RUN /opt/resource-tests/test-check.sh
# RUN /opt/resource-tests/test-in.sh
# RUN /opt/resource-tests/test-out.sh
