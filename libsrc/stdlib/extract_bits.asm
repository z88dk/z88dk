; unsigned long UNSTUFF_BITS(unsigned char *resp, unsigned int start, unsigned int size)
; CALLER linkage for function pointers

XLIB extract_bits

LIB extract_bits_callee
XREF ASMDISP_extract_bits_callee

.extract_bits

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af

   jp extract_bits_callee + ASMDISP_extract_bits_callee
