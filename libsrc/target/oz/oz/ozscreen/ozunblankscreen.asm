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
; $Id: ozunblankscreen.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozunblankscreen
	PUBLIC	_ozunblankscreen
	
	PUBLIC	s_blanked
	
	EXTERN	ozsetlcdstate

	EXTERN	s_ozlcdstatus



; ozslow:
ozunblankscreen:
_ozunblankscreen:
        ld      hl,s_blanked
        ld      a,(hl)
        or      a
        ret     z
        inc     a
        ld      (hl),a
        ld      a,5
        out     (24h),a
        ld      a,1
        out     (20h),a
        ld      hl,(s_ozlcdstatus)
        ld      a,l
        and     0bfh
        or      80h
        ld      l,a
        push    hl
        call    ozsetlcdstate
        pop     hl
        ret


	SECTION bss_clib
s_blanked:
        defb    0
