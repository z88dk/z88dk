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
; $Id: ozblankscreen.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;

	PUBLIC	ozblankscreen
	
	EXTERN	ozunblankscreen
	EXTERN	ozsetlcdstate
	
	EXTERN	s_blanked
	
	EXTERN	s_ozlcdstatus
	EXTERN	s_init_unblank


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
