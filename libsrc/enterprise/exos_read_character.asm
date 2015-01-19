;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_read_character(unsigned char ch_number);
;
;
;	$Id: exos_read_character.asm,v 1.3 2015-01-19 01:32:42 pauloscustodio Exp $
;

	PUBLIC	exos_read_character

exos_read_character:

	ld	a,l
	rst   30h
	defb  5
	ld	h,0
	ld	l,b

	ret
