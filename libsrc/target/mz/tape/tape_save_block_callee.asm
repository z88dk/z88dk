;
;      Tape save routine
;
;      Stefano, 2022
;
;      int __CALLEE__ tape_save_block_callee(void *addr, size_t len, unsigned char type)
;

PUBLIC tape_save_block_callee
PUBLIC _tape_save_block_callee
PUBLIC asm_tape_save_block


.tape_save_block_callee
._tape_save_block_callee

   pop af
   pop de
   pop bc
   pop hl
   push af
   ld a,e		; on the MZ the "type" works differently

.asm_tape_save_block

;--------------------
;   in   BC=byte size
;        HL=adr.
;        A=type
;   exit CF=0:ok.
;        CF=1:break
;--------------------

	push ix
	ld	de,saveblock_ret
	push de
	ld ix,(0x25)	; SAVE2
	inc ix		; skip type assignment to A
	inc ix
	jp (ix)
.saveblock_ret
	pop ix

	ld  hl,0
	ret nc
	
	dec hl		;error, break condition occured during write
	ret

