;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;	void ozportout(char port, char value)
;
; ------
; $Id: ozportout.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozportout
	PUBLIC	_ozportout
	

ozportout:
_ozportout:
        push    ix
        ld      ix,4
        add     ix,sp
        ld      c,(ix+0)
        ld      a,(ix+2)
        out     (c),a
        pop     ix
        ret
