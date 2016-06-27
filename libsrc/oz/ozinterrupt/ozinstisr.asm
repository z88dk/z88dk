;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	interrupt routines
;
;
; ------
; $Id: ozinstisr.asm,v 1.5 2016-06-27 21:25:36 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozinstisr
	PUBLIC	_ozinstisr
	
ozinstisr:
_ozinstisr:
        ld      a,(0)
        cp      0F3h	;di
        jr      nz,error

;; install an interrupt table ;;
        ld     hl,0fe00h
        ld     de,0fe01h
        ld     bc,256
        ld     a,0ffh
        ld     (hl),a
        ldir

        di
        ld      hl,0fff4h
        ld      (hl),0F3h	;di
        inc     hl
        ld      (hl),0C3h	;jp
        inc     hl

        pop     bc  ;; return address
        pop     de  ;; isr argument
        push    de
        push    bc

        ld      (hl),e
        inc     hl
        ld      (hl),d
        ld      a,18h	;jr
        ld      (0ffffh),a

        ld      a,0feh
        ld      i,a
        im      2
        ei
        ld      hl,0
        ret
error:
        ld hl,-1
        ret


