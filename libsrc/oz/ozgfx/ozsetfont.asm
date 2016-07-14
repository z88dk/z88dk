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
; $Id: ozsetfont.asm,v 1.4 2016-07-14 17:44:17 pauloscustodio Exp $
;

        SECTION code_clib
	PUBLIC	ozsetfont
	PUBLIC	_ozsetfont
	;PUBLIC	ozfont
	PUBLIC	ozfontniceheight
	
	EXTERN	ScrCharSet

ozsetfont:
_ozsetfont:
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

	SECTION bss_clib
ozfontniceheight:
        defb    0
