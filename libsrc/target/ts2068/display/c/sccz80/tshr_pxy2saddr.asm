; void *tshr_pxy2saddr(uint x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_pxy2saddr

EXTERN asm_tshr_pxy2saddr

tshr_pxy2saddr:

   pop af
   pop hl
   pop bc

   push bc
   push hl
   push af

   jp asm_tshr_pxy2saddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_pxy2saddr
defc _tshr_pxy2saddr = tshr_pxy2saddr
ENDIF

