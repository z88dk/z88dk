;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;	char ozportin(char port)
;
; ------
; $Id: ozportin.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozportin
	PUBLIC	_ozportin
	
	
ozportin:
_ozportin:
        ld      hl,2
        add     hl,sp
        ld      c,(hl)
        in      l,(c)
        ld      h,0
        ret
