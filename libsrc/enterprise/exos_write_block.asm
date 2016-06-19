;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_write_block(unsigned char channel, unsigned int byte_count, unsigned char *address);
;
;
;	$Id: exos_write_block.asm,v 1.3 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
	PUBLIC	exos_write_block
	PUBLIC	_exos_write_block

exos_write_block:
_exos_write_block:
	
	pop	af
	pop de
	pop bc
	pop hl
	push hl
	push bc
	push de
	push af

	ld	a,l
	rst   30h
	defb  8
	ld	h,0
	ld	l,a

	ret
