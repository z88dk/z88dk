;; place help text in divmmc memory

SECTION rodata_dot

PUBLIC _find_help
PUBLIC _find_version

_find_help:

   BINARY "find-help.txt.zx7"

_find_version:

   BINARY "find-version.txt"
   defb 0
