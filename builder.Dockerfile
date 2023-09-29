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
    mkdir -p ${INSTALL_DIR}/bin \
    ${INSTALL_DIR}/lib

# normal dependencies
#COPY --from=jeylabs/poppler/compiler:latest /lib64/libz.so.1 ${INSTALL_DIR}/lib/
#COPY --from=jeylabs/poppler/compiler:latest /lib64/libm.so.6 ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest /lib64/libjbig.so.2.0 ${INSTALL_DIR}/lib/
#COPY --from=jeylabs/poppler/compiler:latest /lib64/libharfbuzz.so.0 ${INSTALL_DIR}/lib/
#COPY --from=jeylabs/poppler/compiler:latest /lib64/libgraphite2.so.3.0.1 ${INSTALL_DIR}/lib/
#COPY --from=jeylabs/poppler/compiler:latest /lib64/libexpat.so.1 ${INSTALL_DIR}/lib/
#COPY --from=jeylabs/poppler/compiler:latest /lib64/libnss3.so ${INSTALL_DIR}/lib/
#COPY --from=jeylabs/poppler/compiler:latest /lib64/libcurl4.so.* ${INSTALL_DIR}/lib/
#COPY --from=jeylabs/poppler/compiler:latest /lib64/libc.so.6 ${INSTALL_DIR}/lib/

# built from source
#COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/share/ /tmp/share
#COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/etc/ ${INSTALL_DIR}/etc/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/bin/pdftotext ${INSTALL_DIR}/bin/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/bin/pdfinfo   ${INSTALL_DIR}/bin/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/bin/pdftoppm   ${INSTALL_DIR}/bin/
#COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/var/ ${INSTALL_DIR}/var/
#COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/ ${INSTALL_DIR}/lib/
#COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib64/ ${INSTALL_DIR}/lib/
#COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/libbrotlicommon.so.1 ${INSTALL_DIR}/lib/
#COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/libbrotlidec.so.1 ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/liblcms2.so.2 ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/libtiff.so.6 ${INSTALL_DIR}/lib/
#COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/libpng.so ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/libpng16.so.16 ${INSTALL_DIR}/lib/
#COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib64/libglib-2.0.so.0 ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/libjpeg.so.62 ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/libopenjp2.so.7 ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/libfreetype.so.6 ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/libfontconfig.so.1 ${INSTALL_DIR}/lib/
COPY --from=jeylabs/poppler/compiler:latest ${SOURCE_DIR}/lib/libpoppler.so.131 ${INSTALL_DIR}/lib/

#RUN set -xe; \
#    cp -R /tmp/share/fontconfig ${INSTALL_DIR}/share/fontconfig

# Test file

RUN set -xe; \
    mkdir -p /tmp/test

WORKDIR /tmp/test

RUN set -xe; \
    curl -Ls https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf --output sample.pdf

RUN set -xe; \
    /opt/bin/pdftotext -v

RUN set -xe; \
    /opt/bin/pdfinfo sample.pdf

RUN set -xe; \
    /opt/bin/pdftotext sample.pdf -

RUN set -xe; \
    /opt/bin/pdftoppm -v

RUN set -xe; \
    /opt/bin/pdftoppm -png sample.pdf sample

RUN set -xe; \
    test -f /tmp/test/sample-1.png

RUN rm -f /opt/bin/pdftoppm

RUN rm -f /opt/bin/pdfinfo

