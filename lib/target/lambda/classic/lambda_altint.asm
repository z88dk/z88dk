;       CRT0 for the LAMBDA 8300 - SLOW MODE
;
;
; ----------------------------------------------------------------------------------------
;       Modified display handler to preserve IY
;	Note: a swap between IX and IY happens "on the fly" during assembly !
; ----------------------------------------------------------------------------------------
;
;       Stefano Bodrato August 2015
;
; - - - - - - -
;
;       $Id: lambda_altint.def $
;
; - - - - - - -


;--------------------------------------------------------------
;--------------------------------------------------------------

PUBLIC	altint_on
PUBLIC	altint_off
PUBLIC	zx_fast
PUBLIC	zx_slow

;----------------------------------------------------------------
;
; Enter in FAST mode 
;
;----------------------------------------------------------------
zx_fast:
	call restore81
IF (startup=102)
	jp	$D5E		; FAST !
ENDIF
IF (startup=202)
	jp	$36C		; FAST !  (Monochrome ROM)
ENDIF
IF (startup=302)
	jp	$E06		; FAST !  (CAC-3 and NF300)
ENDIF

;--------------------------------------------------------------
;========
; Not HRG really, but switches the new interrupt handler with no sighs
;========

zx_slow:
altint_on:
		call    restore81

IF (startup=102)
		call    $12A5	; SLOW
ENDIF
IF (startup=202)
		call    $281	; SLOW  (Monochrome ROM)
ENDIF
IF (startup=302)
		call    $13BE	; SLOW  (CAC-3 and NF300)
ENDIF

        ld      hl,L0281
HRG_Sync:
        push    hl
		ld      a,(16443)	; test CDFLAG
		and     128			; is in FAST mode ?
		jr      z,nosync
        ld      hl,$4034        ; FRAMES counter
        ld      a,(hl)          ; get old FRAMES
HRG_Sync1:
        cp      (hl)            ; compare to new FRAMES
        jr      z,HRG_Sync1     ; exit after a change is detected
nosync:
        pop	iy              ; switch to new display handler
        ret

;--------------------------------------------------------------

altint_off:
		call	altint_on     ; restore registers and make sure we are in SLOW mode
IF (startup=102)
        ld      hl,$1323      ; on the ZX81 this was $0281
ENDIF
IF (startup=202)
        ld      hl,$300       ; Lambda monochrome ROM
ENDIF
IF (startup=302)
        ld      hl,$143C      ; CAC-3 and NF300
ENDIF
        jr      HRG_Sync


;--------------------------------------------------------------
;--------------------------------------------------------------

        INCLUDE "target/lambda/classic/lambda_altint_core.asm"

