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
	PUBLIC 	ASMDISP_EXOS_WRITE_BLOCK_CALLEE

exos_write_block_callee:
_exos_write_block_callee:
	
	pop	af
	pop de
	pop bc
	pop hl
	push af

.asmentry

	ld	a,l
	rst   30h
	defb  8
	ld	h,0
	ld	l,a

	ret

DEFC ASMDISP_EXOS_WRITE_BLOCK_CALLEE = asmentry - _exos_write_block_callee
