;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_read_character(unsigned char ch_number);
;
;
;	$Id: exos_read_character.asm,v 1.4 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
	PUBLIC	exos_read_character
	PUBLIC	_exos_read_character

exos_read_character:
_exos_read_character:

	ld	a,l
	rst   30h
	defb  5
	ld	h,0
	ld	l,b

	ret
