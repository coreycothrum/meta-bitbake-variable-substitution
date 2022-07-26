SUMMARY          = "Bitbake Variable Substitution Example"
DESCRIPTION      = "Bitbake Variable Substitution Example"
HOMEPAGE         = "https://github.com/coreycothrum/meta-bitbake-variable-substitution"
LICENSE          = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI          = "file://bb-var-sub-example.sh"
FILES:${PN}      = "${bindir}/bb-var-sub-example.sh"

inherit bitbake-variable-substitution

do_install() {
  install -d                                      ${D}${bindir}
  install -m 744 ${WORKDIR}/bb-var-sub-example.sh ${D}${bindir}
}
