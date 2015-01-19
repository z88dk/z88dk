;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;	void ozportout(char port, char value)
;
; ------
; $Id: ozportout.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;

	PUBLIC	ozportout
	

ozportout:
        push    ix
        ld      ix,4
        add     ix,sp
        ld      c,(ix+0)
        ld      a,(ix+2)
        out     (c),a
        pop     ix
        ret
