;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	display blanking control functions
;	LCDStatus is 0c024h in the OS;
;
;
; ------
; $Id: ozblankscreen.asm,v 1.1 2003-10-21 17:15:21 stefano Exp $
;

	XLIB	ozblankscreen
	
	LIB	ozunblankscreen
	LIB	ozsetlcdstate
	
	XREF	s_blanked
	
	XREF	s_ozlcdstatus
	XREF	s_init_unblank


ozblankscreen:
        ld      hl,ozunblankscreen	; was ozslow
        ld      (s_init_unblank+1),hl

        ld      a,1
        ld      (s_blanked),a
        ld      hl,(s_ozlcdstatus)
        ld      a,l
        or      40h
        and     7fh
        ld      l,a
        push    hl
        call    ozsetlcdstate
        pop     hl
        ret
