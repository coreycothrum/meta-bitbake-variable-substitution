# meta-bitbake-variable-substitution
Expands bitbake variables in externel source/scripts.

## Overview
* delimited bitbake variables in external source/scripts will be replaced with the expanded value of that bitbake variable
  * Example: ``@@sbindir@@`` will be replaced with ``/usr/sbin``
* delimiter defaults to ``@@``. This can be overriden with the variable ``BITBAKE_VAR_SUB_DELIM``
* files in ``FILES_${PN}`` are expanded automatically, during ``do_install_append()``
* files in ``SRC_URI``     are expanded automatically, during ``do_compile_prepend()``
* any file can be processed with an explict function call
* see [Using Layer](#Using-Layer) for more info

## Dependencies
This layer depends on:

    URI: git://git.openembedded.org/bitbake

    URI: git://git.openembedded.org/openembedded-core
    layers: meta
    branch: master

## Installation
### Add Layer to Build
In order to use this layer, the build system must be aware of it.

Assuming this layer exists at the top-level of the yocto build tree; add the location of this layer to ``bblayers.conf``, along with any additional layers needed:

    BBLAYERS ?= "                                       \
      /path/to/yocto/meta                               \
      /path/to/yocto/meta-poky                          \
      /path/to/yocto/meta-yocto-bsp                     \
      /path/to/yocto/meta-bitbake-variable-substitution \
      "

Alternatively, run bitbake-layers to add:

    $ bitbake-layers add-layer /path/to/yocto/meta-bitbake-variable-substitution

### Configure Layer
This layer should be configured with the following definitions
in ``local.conf`` or ``custom_machine.conf``:

    ##optional, if different delim needed
    #BITBAKE_VAR_SUB_DELIM = "@@"

## Using Layer
To automatically process files, add ``inherit bitbake-variable-substitution`` to recipe.

Alternatively, a more measured approach may be preferred, especially if `FILES_${PN}` or `SRC_URI` is trashy/bloated. To explicitly/manually select files to process:

    # inherit helpers class in recipe
    inherit bitbake-variable-substitution-helpers

    # call function where appropriate
    ${@bitbake_variables_search_and_sub("${PATH_OR_FILE_TO_PROCESS}", r"${BITBAKE_VAR_SUB_DELIM}", d)}

## Contributing
Please submit any patches against this layer via pull request.

Commits must be signed off.

Use [conventional commits](https://www.conventionalcommits.org/).
