# meta-bitbake-variable-substitution
Automatically expand bitbake variables inside source/scripts.

## Overview
* delimited bitbake variables in source/scripts will be replaced with the expanded value of that bitbake variable
  * Example: ``@@sbindir@@`` will be replaced with ``/usr/sbin``
* files in ``FILES_${PN}`` are expanded automatically, during ``do_install:append()``
* files in ``SRC_URI``     are expanded automatically, during ``do_patch:append()``
* any file can be processed with an explict function call inside bitbake recipe

## Configuration
| Variable                              | Default | Description                                                                                      |
| ---                                   | ---     | ---                                                                                              |
| ``BITBAKE_VAR_SUB_DELIM``             | ``@@``  | strings sandwiched between this delim will be replaced w/ value of bitbake variable of same name | 
| ``BITBAKE_VAR_SUB_MISSING_VAR_FATAL`` | ``1``   | missing bitbake variables will cause a fatal error                                               |

## Usage
### Automatic Expansion
To automatically process files, add ``inherit bitbake-variable-substitution`` to recipe.

### Explicit Expansion
Alternatively, a more measured approach may be preferred. Especially useful if `FILES_${PN}` or `SRC_URI` is trashy/bloated.

To explicitly/manually select files to process:

    # inherit helpers class in recipe
    inherit bitbake-variable-substitution-helpers

    # call function where appropriate
    ${@bitbake_variables_search_and_sub("${PATH_OR_FILE_TO_PROCESS}", r"${BITBAKE_VAR_SUB_DELIM}", d)}

## Release Schedule and Roadmap
This layer will remain compatible with the latest [YOCTO LTS](https://wiki.yoctoproject.org/wiki/Releases).
