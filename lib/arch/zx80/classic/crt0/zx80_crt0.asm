;       CRT0 for the ZX80
;
;       Stefano Bodrato Dec. 2012
;
;       If an error occurs (eg. out if screen) we just drop back to BASIC
;
;       ZX80 works in FAST mode only, thus the screen is visible only
;		during a PAUSE or waiting for a keypress.
;
;
; - - - - - - -
;
;       $Id: zx80_crt0.asm,v 1.15 2016-07-15 21:03:25 dom Exp $
;
; - - - - - - -


        MODULE  zx80_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        PUBLIC    save81          ;Save ZX81 critical registers
        PUBLIC    restore81       ;Restore ZX81 critical registers
        PUBLIC    zx_fast
        PUBLIC    zx_slow

        ;; PUBLIC    frames         ;Frame counter for time()
        PUBLIC    _FRAMES
        defc    _FRAMES = 16414	; Timer

        EXTERN    filltxt        ; used by custom CLS

        IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = 16525
        ENDIF


        org     CRT_ORG_CODE

start:
	ld	l,0
	call	filltxt
	LD      (IY+$12),24    ; set DF-SZ to 24 lines.

	;call	zx80_cls

	;call	1863	; CLS
	;call $6e0   ;; N/L-LINE (PRPOS)
	;ld	a,0
	;call $720
	;call	1474	; CL-EOD  - clear to end of display

	; (zx81) this would be after 'hrg_on', sometimes
	; the stack will be moved to make room
	; for high-resolution graphics.
	
        ld      (start1+1),sp   ;Save entry stack
        ;ld      hl,-64          ;Create an atexit() stack
        ld      hl,0            ;Create an atexit() stack
        add     hl,sp
        ld      sp,hl
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF


        call    _main   ;Call user program
        
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl		; keep return code

IF !DEFINED_nostreams
        EXTERN     closeall
        call    closeall
ENDIF
    ;    ld      iy,16384	; no ix/iy swap here
	;LD      (IY+$12),2    ; set DF-SZ to 24 lines.
	;call	1863

        pop     hl		; return code (for BASIC)
start1: ld      sp,0            ;Restore stack to entry value
		;jp $283
        ;ret				; oddly EightyOne gets unstable without this 'ret' !!
        ;jp		restore81

restore81:
;        ex      af,af
;        ld      a,(a1save)
;        ex      af,af
        ld      iy,16384	; no ix/iy swap here
save81:
zx_fast:
zx_slow:
        ret

l_dcal: jp      (hl)            ;Used for function pointer calls




;                defm  "Small C+ ZX80"   ;Unnecessary file signature
;                defb    0

;zx80_cls:
;	LD      HL,($400A)      ; fetch E-LINE
;	INC     HL              ; address the next location.
;	LD      (HL),$76        ; insert a newline.
;	INC     HL              ; address the next location.
;	LD      ($400C),HL      ; set D-FILE to start of dynamic display file.
;	LD      (IY+$12),$02    ; set DF-SZ to 2 lines.

;zx80_cls2:
;	call	$6e0   ;; N/L-LINE (PRPOS)
;	ld	a,0
;	call	$720
;	ld	a,($4025)	; S_POSN_Y
;	dec	a
;	jr	nz,zx80_cls2
;	jp	$747	; CLS


        INCLUDE "crt0_runtime_selection.asm"
	INCLUDE	"crt0_section.asm"


