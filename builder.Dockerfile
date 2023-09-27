FROM amazonlinux:2

ENV SOURCE_DIR="/opt"
ENV INSTALL_DIR="/opt"

ENV PATH="/opt/bin:${PATH}" \
    LD_LIBRARY_PATH="${INSTALL_DIR}/lib64:${INSTALL_DIR}/lib"

# Needed for test file, not sure why the compiler file did not get it in.
RUN set -xe; \
    yum -y install libicu60

# Install zip

RUN set -xe; \
    LD_LIBRARY_PATH= yum -y install zip

# Copy All Binaries / Libaries

RUN set -xe; \
    mkdir -p ${INSTALL_DIR}/etc \
    ${INSTALL_DIR}/bin \
    ${INSTALL_DIR}/var \
    ${INSTALL_DIR}/share \
    ${INSTALL_DIR}/lib

# normal dependencies
COPY --from=jeylabs/poppler/compiler:latest /lib64/libuuid.so.* ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest /lib64/libicu60.so.* ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest /lib64/libz.so.* ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest /lib64/libm.so.* ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest /lib64/libjbig.so.* ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest /lib64/libharfbuzz.so.* ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest /lib64/libgraphite2.so.* ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest /lib64/libbrotlidec.so.* ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest /lib64/libbrotlicommon.so.* ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest /lib64/libexpat.so.* ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest /lib64/libnss3.so.* ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest /lib64/libcurl4.so.* ${INSTALL_DIR}/lib/

# built from source
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/share/ /tmp/share
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/etc/ ${INSTALL_DIR}/etc/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/bin/ ${INSTALL_DIR}/bin/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/var/ ${INSTALL_DIR}/var/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/ ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib64/ ${INSTALL_DIR}/lib/

RUN set -xe; \
    cp -R /tmp/share/fontconfig ${INSTALL_DIR}/share/fontconfig

# Test file

RUN set -xe; \
    mkdir -p /tmp/test

WORKDIR /tmp/test

RUN set -xe; \
    curl -Ls https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf --output sample.pdf

RUN set -xe; \
    /opt/bin/pdftoppm -v

RUN set -xe; \
    /opt/bin/pdftoppm -png sample.pdf sample

RUN set -xe; \
    test -f /tmp/test/sample-1.png
