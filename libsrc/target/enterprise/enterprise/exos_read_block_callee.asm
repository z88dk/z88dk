;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_read_block_callee(unsigned char channel, unsigned int byte_count, unsigned char *address);
;
;
;	$Id: exos_read_block_callee.asm $
;

	SECTION code_clib
	PUBLIC	exos_read_block_callee
	PUBLIC	_exos_read_block_callee
	PUBLIC 	asm_exos_read_block

exos_read_block_callee:
_exos_read_block_callee:
	
	pop	af
	pop de
	pop bc
	pop hl
	push af

.asm_exos_read_block

	ld	a,l
	rst   30h
	defb  6
	ld	h,0
	ld	l,a

	ret
