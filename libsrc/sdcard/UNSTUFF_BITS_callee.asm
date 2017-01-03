;
;      Bit unpacking code for SD/MMC card
;
;      Stefano, 2012
;
; unsigned long UNSTUFF_BITS(unsigned char *resp, unsigned int start, unsigned int size)
;

PUBLIC UNSTUFF_BITS_callee
PUBLIC _UNSTUFF_BITS_callee
PUBLIC ASMDISP_UNSTUFF_BITS_CALLEE
EXTERN  extract_bits_sub

.UNSTUFF_BITS_callee
._UNSTUFF_BITS_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl

.asmentry
	push hl
	ld hl,128	; bit count start on the rightmost bit of the 16 bytes block
	and a
	sbc hl,de	; 'reverse' the bit position
	sbc hl,bc	; also the bit size
	ex de,hl
	pop hl
	jp extract_bits_sub


DEFC ASMDISP_UNSTUFF_BITS_CALLEE = # asmentry - UNSTUFF_BITS_callee
