;; place help text in divmmc memory

SECTION rodata_dot

PUBLIC _ls_help
PUBLIC _ls_version

_ls_help:

   BINARY "ls-help.txt.zx7"

_ls_version:

   BINARY "ls-version.txt"
   defb 0
