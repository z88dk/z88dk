
; int ffs_fastcall(int i)

SECTION code_clib
SECTION code_string

PUBLIC _ffs_fastcall

EXTERN asm_ffs

defc _ffs_fastcall = asm_ffs
