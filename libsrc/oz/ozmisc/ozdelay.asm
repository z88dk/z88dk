;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	void ozdelay(unsigned d)
;
; ------
; $Id: ozdelay.asm,v 1.1 2003-10-22 13:55:49 stefano Exp $
;

	XLIB	ozdelay
	

ozdelay:
        ;ld       hl,2
        ;add      hl,sp
        ;call     $gint
        pop	bc
        pop	hl
        push	hl
        push	bc
delaylp:
        dec     hl
        ld      a,h
        or      l
        jr      nz,delaylp
        ret
