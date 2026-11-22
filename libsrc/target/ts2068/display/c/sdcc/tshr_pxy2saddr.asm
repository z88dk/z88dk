; void *tshr_pxy2saddr(uint x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_pxy2saddr

EXTERN asm_tshr_pxy2saddr

_tshr_pxy2saddr:

   pop af
   pop hl
   pop bc

   push bc
   push hl
   push af

   jp asm_tshr_pxy2saddr
