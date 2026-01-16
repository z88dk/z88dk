; void *tshr_cxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_cxy2saddr

EXTERN asm_zx_cxy2saddr

_tshr_cxy2saddr:

   pop af
   pop hl

   push hl
   push af

   jp asm_zx_cxy2saddr
