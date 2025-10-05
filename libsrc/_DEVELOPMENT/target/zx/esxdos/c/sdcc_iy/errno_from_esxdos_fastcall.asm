; uchar errno_from_esxdos(uchar code)

SECTION code_clib
SECTION code_esxdos

PUBLIC _errno_from_esxdos_fastcall

EXTERN asm_errno_from_esxdos

defc _errno_from_esxdos_fastcall = asm_errno_from_esxdos
