; void *tshr_pxy2saddr(uint x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_pxy2saddr_callee

EXTERN asm_tshr_pxy2saddr

_tshr_pxy2saddr_callee:

   pop af
   pop hl
   dec sp
   pop bc
   push af

   ld c,b
   jp asm_tshr_pxy2saddr
