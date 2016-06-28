;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	display backlight control functions
;
;
;	void ozsetlight(char light)
;
;
;
; ------
; $Id: ozsetlight.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozsetlight
	PUBLIC	_ozsetlight
	
	EXTERN	ozbacklight
	EXTERN	ozbacklight_save
	EXTERN	s_ozlcdstatus
	
	EXTERN	ozsetlcdstate


ozsetlight:
_ozsetlight:
        pop     hl
        pop     bc
        push    bc
        push    hl
        ld      a,c
        or      a
        ld      hl,ozbacklight
        jr      nz,LightOn
        ld      a,(hl)
        and     0ffh - 040h
        ld      (hl),a

        ld      hl,(s_ozlcdstatus)
        ld      a,h
        and     0feh
        jr      DoSet

        ld      hl,ozbacklight_save
        ld      a,(hl)
        and     0ffh - 08h
        ld      (hl),a
LightOn:
        ld      a,040h
        or      (hl)
        ld      (hl),a
        ld      hl,ozbacklight_save
        ld      a,08h
        or      (hl)
        ld      (hl),a
        ld      hl,(s_ozlcdstatus)
        ld      a,h
        or      01
DoSet:
        ld      h,a
        push    hl
        call    ozsetlcdstate
        pop     hl
        ret

