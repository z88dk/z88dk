; void *tshr_saddrpleft(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddrpleft

EXTERN asm_tshr_saddrpleft

tshr_saddrpleft:

   pop af
   pop hl
   pop de

   push de
   push hl
   push af

   jp asm_tshr_saddrpleft

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_saddrpleft
defc _tshr_saddrpleft = tshr_saddrpleft
ENDIF

