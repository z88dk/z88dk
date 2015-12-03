
; uint zx_bitmask2px_fastcall(uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_bitmask2px_fastcall

EXTERN asm_zx_bitmask2px

defc _zx_bitmask2px_fastcall = asm_zx_bitmask2px
