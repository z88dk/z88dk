; void *tshr_cxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_cxy2saddr

EXTERN asm_zx_cxy2saddr

tshr_cxy2saddr:

   pop af
   pop hl

   push hl
   push af

   jp asm_zx_cxy2saddr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_cxy2saddr
defc _tshr_cxy2saddr = tshr_cxy2saddr
ENDIF

