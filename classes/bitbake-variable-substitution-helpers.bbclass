def bitbake_variables_search_and_sub_all_FILES_PN(d):
  delim      = d.getVar("BITBAKE_VAR_SUB_DELIM")
  deploy_dir = d.getVar("D")
  pn         = d.getVar("PN")
  files      = d.getVar("FILES:" + pn)

  if not deploy_dir:
    bb.warn("no deploy_dir, skipping")
    return "true"

  if files:
    for file in files.split():
      bitbake_variables_search_and_sub(os.path.join(deploy_dir, file), delim, d)

  return "true"

def bitbake_variables_search_and_sub_all_SRC_URI(d):
  delim    = d.getVar("BITBAKE_VAR_SUB_DELIM")
  work_dir = d.getVar("WORKDIR")
  files    = d.getVar("SRC_URI")

  if files:
    for file in files.split():
      fname = file.split('://')[-1]
      bitbake_variables_search_and_sub(os.path.join(work_dir, fname), delim, d)

  return "true"

def bitbake_variables_search_and_sub(paths, delim, d):
  if   not        d           : bb.fatal("bitbake variables (d) not provided")
  elif not        paths       : bb.fatal("no valid argument provided")
  elif isinstance(paths, list): pass
  elif isinstance(paths, str ): paths = [paths]
  else                        : bb.fatal("path(s) must be a string or list of strings")

  if len((d.getVar("BB_HASH_CODEPARSER_VALS") or "").strip()) != 0:
      bb.fatal("BB_HASH_CODEPARSER_VALS is incompatible with this layer. unset this variable to continue.")

  import filecmp
  import os
  import re
  import shutil
  import subprocess

  is_text = lambda filename: "text" in str(subprocess.check_output(["file", "-b", filename]))
  pattern = delim + r"(?P<vname>[^@]+?)" + delim
  regex   = re.compile(pattern)
  rc      = "true"

  for path in (list(paths) or []):
    for root, dirs, fnames in ([(os.path.dirname(path),[],[path])] if os.path.isfile(path) else os.walk(path)):
      for file in (os.path.join(root, fname) for fname in fnames):
        if not os.path.isfile(file): continue
        if     os.path.islink(file): continue
        if not        is_text(file): continue

        try:
          with open(file, 'r') as fp:
            obuf = []
            for line in fp:
              for match in regex.findall(line):
                new_val = d.getVar(match)
                if new_val is None:
                    if d.getVar("BITBAKE_VAR_SUB_MISSING_VAR_FATAL", "1") == "1":
                        bb.fatal('{file}: bitbake variable {var} is None'.format(file=file, var=match))
                    else:
                        bb.warn('{file}: bitbake variable {var} is None, expanding to empty string'.format(file=file, var=match))
                        new_val = ''
                line = line.replace(delim + match + delim, new_val)

              obuf.append(line)

          with open(file, 'w+') as fp:
            for line in obuf:
              fp.write(line)

        except Exception as e:
          continue
          rc = "false"
          raise e

  return rc
