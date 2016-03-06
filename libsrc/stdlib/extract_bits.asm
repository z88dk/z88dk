; unsigned long UNSTUFF_BITS(unsigned char *resp, unsigned int start, unsigned int size)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC extract_bits
PUBLIC _extract_bits

EXTERN extract_bits_callee
EXTERN ASMDISP_extract_bits_callee

.extract_bits
._extract_bits

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af

   jp extract_bits_callee + ASMDISP_extract_bits_callee
