;
;      Tape load routine
;
;      Stefano, 2022
;
;      int __CALLEE__ tape_load_block_callee(void *addr, size_t len, unsigned char type)
;

PUBLIC tape_load_block_callee
PUBLIC _tape_load_block_callee
PUBLIC asm_tape_load_block


.tape_load_block_callee
._tape_load_block_callee

   pop af
   pop de
   pop bc
   pop hl
   push af
   ld a,e		; on the MZ the "type" works differently
   
.asm_tape_load_block

;--------------------
;   in   BC=byte size
;        HL=adr.
;        A=type
;   exit CF=0:ok.
;        CF=1:break
;--------------------

	push ix
	ld	de,loadblock_ret
	push de
	ld ix,(0x2B)	; LOAD2
	inc ix		; skip type assignment to A
	inc ix
	jp (ix)
.loadblock_ret
	pop ix

	ld  hl,0
	ret nc
	
	dec hl		;error, break condition occured during write
	ret

