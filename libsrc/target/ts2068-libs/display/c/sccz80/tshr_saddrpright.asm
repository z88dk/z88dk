; void *tshr_saddrpright(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_saddrpright

EXTERN asm_tshr_saddrpright

tshr_saddrpright:

   pop af
   pop hl
   pop de

   push de
   push hl
   push af

   jp asm_tshr_saddrpright

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_saddrpright
defc _tshr_saddrpright = tshr_saddrpright
ENDIF

