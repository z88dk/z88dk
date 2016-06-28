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
; $Id: ozblankscreen.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozblankscreen
	PUBLIC	_ozblankscreen
	
	EXTERN	ozunblankscreen
	EXTERN	ozsetlcdstate
	
	EXTERN	s_blanked
	
	EXTERN	s_ozlcdstatus
	EXTERN	s_init_unblank


ozblankscreen:
_ozblankscreen:
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
