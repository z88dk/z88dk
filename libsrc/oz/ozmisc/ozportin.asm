;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;	char ozportin(char port)
;
; ------
; $Id: ozportin.asm,v 1.1 2003-10-22 09:56:34 stefano Exp $
;

	XLIB	ozportin
	
	
ozportin:
        ld      hl,2
        add     hl,sp
        ld      c,(hl)
        in      l,(c)
        ld      h,0
        ret