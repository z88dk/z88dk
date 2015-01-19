;
;	Enterprise 64/128 specific routines
;	by Stefano Bodrato, 2011
;
;	exos_display_page(unsigned char channel, unsigned char first_row, unsigned char rows, unsigned char first_row_position);
;
;
;	$Id: exos_display_page.asm,v 1.3 2015-01-19 01:32:42 pauloscustodio Exp $
;

	PUBLIC	exos_display_page

	INCLUDE "enterprise.def"


exos_display_page:
	
		ld	ix,0
		add	ix,sp
		ld	e,(ix+2)
		ld	d,(ix+4)
		ld	c,(ix+6)
		ld	a,(ix+8)

		ld	b,FN_DISP	; special fn code

        rst   30h
        defb  11	; call special device dependent exos functions

		ld	h,0
		ld	l,a

		ret
