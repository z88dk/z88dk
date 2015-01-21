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
;       $Id: zx80_crt0.asm,v 1.6 2015-01-21 07:05:01 stefano Exp $
;
; - - - - - - -


        MODULE  zx80_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

        INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)

        PUBLIC    _vfprintf       ;jp to the printf() core

        PUBLIC    exitsp          ;atexit() variables
        PUBLIC    exitcount

        PUBLIC    __sgoioblk      ;stdio info block

        PUBLIC    heaplast        ;Near malloc heap variables
        PUBLIC    heapblocks

        PUBLIC    coords          ;Current xy position

;;        PUBLIC    snd_tick        ;Sound variable

        PUBLIC    save81          ;Save ZX81 critical registers
        PUBLIC    restore81       ;Restore ZX81 critical registers
        PUBLIC    zx_fast
        PUBLIC    zx_slow

        ;; PUBLIC    frames         ;Frame counter for time()
        PUBLIC    _FRAMES
        defc    _FRAMES = 16414	; Timer

        EXTERN    filltxt        ; used by custom CLS

        IF      !myzorg
                defc    myzorg  = 16525
        ENDIF


        org     myzorg

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
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
        ld      hl,__sgoioblk+2
        ld      (hl),19 ;stdin
        ld      hl,__sgoioblk+6
        ld      (hl),21 ;stdout
        ld      hl,__sgoioblk+10
        ld      (hl),21 ;stderr
ENDIF
ENDIF

        call    _main   ;Call user program
        
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl		; keep return code

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
        EXTERN     closeall
        call    closeall
ENDIF
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

;-----------
; Define the stdin/out/err area. For the z88 we have two models - the
; classic (kludgey) one and "ANSI" model
;-----------
__sgoioblk:
IF DEFINED_ANSIstdio
        INCLUDE "stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


;---------------------------------
; Select which printf core we want
;---------------------------------
_vfprintf:
IF DEFINED_floatstdio
        EXTERN     vfprintf_fp
        jp      vfprintf_fp
ELSE
        IF DEFINED_complexstdio
                EXTERN     vfprintf_comp
                jp      vfprintf_comp
        ELSE
                IF DEFINED_ministdio
                        EXTERN     vfprintf_mini
                        jp      vfprintf_mini
                ENDIF
        ENDIF
ENDIF


;-----------
; Now some variable
;-----------

coords:         defw    0       ; Current graphics xy coordinates

IF !DEFINED_HAVESEED
		PUBLIC    _std_seed        ;Integer rand() seed
_std_seed:      defw    0       ; Seed for integer rand() routines
ENDIF

exitsp:         defw    0       ; Address of where the atexit() stack is
exitcount:      defb    0       ; How many routines on the atexit() stack


heaplast:       defw    0       ; Address of last block on heap
heapblocks:     defw    0       ; Number of blocks
IF DEFINED_USING_amalloc
EXTERN ASMTAIL
PUBLIC _heap
; The heap pointer will be wiped at startup,
; but first its value (based on ASMTAIL)
; will be kept for sbrk() to setup the malloc area
_heap:
                defw ASMTAIL	; Location of the last program byte
                defw 0
ENDIF

;;snd_tick:       defb    0       ; Flag for sound .. D3=out (n),a ..  DB=in a,(m)

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

;-----------------------
; Floating point support
;-----------------------
IF NEED_floatpack
        INCLUDE         "float.asm"
fp_seed:        defb    $80,$80,0,0,0,0 ;FP seed (unused ATM)
extra:          defs    6               ;FP register
fa:             defs    6               ;FP Accumulator
fasign:         defb    0               ;FP register
ENDIF

