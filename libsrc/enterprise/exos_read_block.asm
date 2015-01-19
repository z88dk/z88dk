;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_read_block(unsigned char channel, unsigned int byte_count, unsigned char *address);
;
;
;	$Id: exos_read_block.asm,v 1.2 2015-01-19 01:32:42 pauloscustodio Exp $
;

	PUBLIC	exos_read_block

exos_read_block:
	
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
	defb  6
	ld	h,0
	ld	l,a

	ret
