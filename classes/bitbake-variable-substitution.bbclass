inherit bitbake-variable-substitution-helpers

do_compile_prepend() {
  ${@bitbake_variables_search_and_sub_all_SRC_URI(d)}
}

do_install_append() {
  ${@bitbake_variables_search_and_sub_all_FILES_PN(d)}
}
