;
;      Tape load routine
;
;      Stefano, 2022
;
;      int __CALLEE__ mztape_load_header_callee(void *addr, size_t len)
;

PUBLIC mztape_load_header_callee
PUBLIC _mztape_load_header_callee
PUBLIC asm_mztape_load_header


.mztape_load_header_callee
._mztape_load_header_callee

   pop af
   pop bc
   pop hl
   push af
   
.asm_mztape_load_header

;--------------------
;   in   BC=byte size
;        HL=adr.
;   exit CF=0:ok.
;        CF=1:break
;--------------------

	push ix
	call 0x27	; LOAD header block
	pop ix

	ld  hl,0
	ret nc
	
	dec hl		;error, break condition occured during write
	ret

