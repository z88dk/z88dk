;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_reset_font();
;
;
;	$Id: exos_reset_font.asm,v 1.4 2016-06-19 20:17:32 dom Exp $
;

        SECTION code_clib
	PUBLIC	exos_reset_font
	PUBLIC	_exos_reset_font

	INCLUDE "enterprise.def"

exos_reset_font:
_exos_reset_font:

		; __FASTCALL_
		ld	a,l			; channel
		ld	b,FN_FONT	; special fn code

        rst   30h
        defb  11	; call special device dependent exos functions

		ld	h,0
		ld	l,a


	ret
