;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_write_block(unsigned char channel, unsigned int byte_count, unsigned char *address);
;
;
;	$Id: exos_write_block_callee.asm $
;

	SECTION code_clib
	PUBLIC	exos_write_block_callee
	PUBLIC	_exos_write_block_callee
	PUBLIC 	asm_exos_write_block

exos_write_block_callee:
_exos_write_block_callee:
	
	pop	af
	pop de
	pop bc
	pop hl
	push af

.asm_exos_write_block

	ld	a,l
	rst   30h
	defb  8
	ld	h,0
	ld	l,a

	ret

