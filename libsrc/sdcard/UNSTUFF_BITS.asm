; unsigned long UNSTUFF_BITS(unsigned char *resp, unsigned int start, unsigned int size)
; CALLER linkage for function pointers

PUBLIC UNSTUFF_BITS
PUBLIC _UNSTUFF_BITS

EXTERN UNSTUFF_BITS_callee
EXTERN ASMDISP_UNSTUFF_BITS_CALLEE

.UNSTUFF_BITS
._UNSTUFF_BITS

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af

   jp UNSTUFF_BITS_callee + ASMDISP_UNSTUFF_BITS_CALLEE
