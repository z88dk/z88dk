;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	gfx functions
;
;	void ozsetfont(int font)
;
;
; ------
; $Id: ozsetfont.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozsetfont
	;XDEF	ozfont
	PUBLIC	ozfontniceheight
	
	EXTERN	ScrCharSet

ozsetfont:
;ozfont:
        ld      hl,2
        add     hl,sp
        ld      a,(hl)
        ld      (ScrCharSet),a
        and     1
        ld      a,13
        jr      z,large
        ld      a,10
large:
        ld      (ozfontniceheight),a
        ret

ozfontniceheight:
        defb    10
