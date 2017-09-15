; int ffs(int i)

SECTION code_clib
SECTION code_string

MODULE _ffs_sdcc
GLOBAL _ffs
GLOBAL ffs

defc _ffs = ffs

