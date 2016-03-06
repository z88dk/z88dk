;
;      Bit unpacking
;
;      Stefano, 2012
;
; unsigned long extract_bits(unsigned char *resp, unsigned int start, unsigned int size)
;

SECTION code_clib
PUBLIC extract_bits_callee
PUBLIC _extract_bits_callee
PUBLIC ASMDISP_EXTRACT_BITS_CALLEE
EXTERN  extract_bits_sub

.extract_bits_callee
._extract_bits_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl

.asmentry
	jp	extract_bits_sub

DEFC ASMDISP_EXTRACT_BITS_CALLEE = # asmentry - extract_bits_callee
