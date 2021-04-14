DESCRIPTION = "Any distribution needs an hello world program"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://hello.c \
           "

do_compile () {
    ${CC} ${WORKDIR}/hello.c -o ${WORKDIR}/hello
}

do_install () {
    install -d ${D}${bindir}

    install -m 0755 -t ${D}${bindir} ${WORKDIR}/hello
}

