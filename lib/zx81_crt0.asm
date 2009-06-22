;       CRT0 for the ZX81
;
;       Stefano Bodrato Apr. 2000
;
;       If an error occurs (eg. out if screen) we just drop back to BASIC
;
;       ZX81 will be thrown in FAST mode by default.
;       The "startup=2" parameter forces the SLOW mode.
;	Values for "startup" from 3 to 6 activate the HRG modes
;
; - - - - - - -
;
;       $Id: zx81_crt0.asm,v 1.24 2009-06-22 21:20:05 dom Exp $
;
; - - - - - - -


        MODULE  zx81_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

        INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

        XREF    _main           ;main() is always external to crt0 code

        XDEF    cleanup         ;jp'd to by exit()
        XDEF    l_dcal          ;jp(hl)

        XDEF    _vfprintf       ;jp to the printf() core

        XDEF    exitsp          ;atexit() variables
        XDEF    exitcount

        XDEF    __sgoioblk      ;stdio info block

        XDEF    heaplast        ;Near malloc heap variables
        XDEF    heapblocks

        XDEF    hr_rows		;Current number of text rows in graphics mode
        XDEF    _hr_rows	 ;as above for C declarations
        XDEF    text_rows	 ;as above for VT ANSI mode
        XDEF    base_graphics   ;Graphical variables
        XDEF    _base_graphics   ;as above for C declarations
        XDEF    coords          ;Current xy position

        XDEF    save81          ;Save ZX81 critical registers
        XDEF    restore81       ;Restore ZX81 critical registers

        XDEF    frames          ;Frame counter for time()

        org     16514


; Hide the mess in the REM line from BASIC program listing

;       jr      start
;       defb    118,255         ; block further listing

; As above, but more elegant

        ld      a,(hl)          ; hide the first 6 bytes of REM line
        jp      start           ; invisible
_base_graphics:                 ; Address of the Graphics map..
base_graphics:			; it is POKEable at address 16518/16519
IF DEFINED_hrgpage
		defw	hrgpage
ELSE
		defw    0
ENDIF
        defb    'Z'-27          ; Change this with your own signature
        defb    '8'-20
        defb    '8'-20
        defb    'D'-27
        defb    'K'-27
        defb    0
        defb    'C'+101
        defb    149     ; '+'
        defb    118,255         ; block further listing

start:

        call    save81

IF (!DEFINED_startup | (startup=1))
        ; FAST mode, safest way to use the special registers
        call    $F23    ; FAST mode
        ;call   $2E7    ;setfast
ENDIF

IF (startup>=2)
        call    hrg_on
 IF ((startup=3)|(startup=5))
        ld	a,1
        ld      (hrgbrkflag),a
        call    hrg_on
 ENDIF
ENDIF

	; this must be after 'hrg_on', sometimes
	; the stack will be moved to make room
	; for high-resolution graphics.
	
        ld      (start1+1),sp   ;Save entry stack
        ;ld      hl,-64          ;Create an atexit() stack
        ld      hl,0            ;Create an atexit() stack
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

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
        LIB     closeall
        call    closeall
ENDIF
ENDIF

        call    restore81

IF (startup>=2)
 IF ((startup=3)|(startup=5))
        xor	a
        ld      (hrgbrkflag),a
 ELSE
        call    hrg_off		; this is valid for mode 2, too !
 ENDIF
ELSE
 IF (!DEFINED_startup | (startup=1))
        call    $F2B            ; SLOW mode
        ;call   $207    ;slowfast
 ENDIF
ENDIF

        pop     bc		; return code (for BASIC)
start1: ld      sp,0            ;Restore stack to entry value
        ret

l_dcal: jp      (hl)            ;Used for function pointer calls
        jp      (hl)


restore81:
IF (!DEFINED_startup | (startup=1))
        ex      af,af
        ld      a,(a1save)
        ex      af,af
ENDIF
        exx
        ld	hl,(hl1save)
        ;ld	bc,(bc1save)
        ;ld	de,(de1save)
        exx
        ld      ix,16384	; IT WILL BECOME IY  !!
        ret
        
save81:
IF (!DEFINED_startup | (startup=1))
        ex      af,af
        ld      (a1save),a
        ex      af,af
ENDIF
        exx
        ld	(hl1save),hl
        ;ld	(bc1save),bc
        ;ld	(de1save),de
        exx
        ret

IF (!DEFINED_startup | (startup=1))
a1save: 	defb    0
ENDIF
hl1save:	defw	0
;bc1save:	defw	0
de1save:	defw	0

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
        LIB     vfprintf_fp
        jp      vfprintf_fp
ELSE
        IF DEFINED_complexstdio
                LIB     vfprintf_comp
                jp      vfprintf_comp
        ELSE
                IF DEFINED_ministdio
                        LIB     vfprintf_mini
                        jp      vfprintf_mini
                ENDIF
        ENDIF
ENDIF


;---------------------------------------
; Modified IRQ handler
;---------------------------------------

IF (startup=2)
        INCLUDE "zx81_altint.def"
ENDIF

;---------------------------------------
; High Resolution Graphics (Wilf Rigter WRX mode)
; Code my Matthias Swatosch
;---------------------------------------

IF (startup>=3)
        INCLUDE "zx81_hrg.def"
ENDIF

;-----------
; Now some variables
;-----------
IF (startup>=3)
text_rows:
hr_rows:
_hr_rows:
 IF (startup>=5)
		defw	8	; Current number of text rows in graphics mode
 ELSE
		defw	24	; Current number of text rows in graphics mode
 ENDIF
ENDIF

coords:         defw    0       ; Current graphics xy coordinates

IF !DEFINED_HAVESEED
		XDEF    _std_seed        ;Integer rand() seed
_std_seed:      defw    0       ; Seed for integer rand() routines
ENDIF

exitsp:         defw    0       ; Address of where the atexit() stack is
exitcount:      defb    0       ; How many routines on the atexit() stack


heaplast:       defw    0       ; Address of last block on heap
heapblocks:     defw    0       ; Number of blocks
frames:         defw    0       ; counter handled with new interrupt
		defb	0	; third byte for "frames"

                defm  "Small C+ ZX81"   ;Unnecessary file signature
                defb    0

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

