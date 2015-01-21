;       Stub for the Philips P2000 family
;
;       Stefano Bodrato - 7/4/2014
;
;       $Id: p2000_crt0.asm,v 1.4 2015-01-21 07:05:00 stefano Exp $
;


                MODULE  p2000_crt0

;--------
; Include zcc_opt.def to find out some info
;--------
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)

        PUBLIC    _std_seed        ;Integer rand() seed

        PUBLIC    _vfprintf       ;jp to the printf() core

        PUBLIC    exitsp          ;atexit() variables
        PUBLIC    exitcount

       	PUBLIC	heaplast	;Near malloc heap variables
        PUBLIC	heapblocks

        PUBLIC    __sgoioblk      ;stdio info block

        PUBLIC    base_graphics   ;Graphical variables
        PUBLIC	coords		;Current xy position

        PUBLIC	snd_tick	;Sound variable
        PUBLIC	bit_irqstatus	; current irq status when DI is necessary

; Now, getting to the real stuff now!

        IF      !myzorg
                defc    myzorg  = $6547
        ENDIF


        org     myzorg

basic_block:

	defw line_20
	defw 10
	defb $8E	; REM
	defm " Z88DK - Small C+ P2000 "
	defb 0
line_20:
	defw basic_end
	defw 20
	defb $A3	; DEF
	defb $B5	; USR
	defb $CA	; '='
	defm "&H6580"
	defb ':'
	defb 'A'
	defb $CA	; '='
	defb $B5	; USR
	defm "(0)"
	defb 0

basic_end:

; BASIC is abt 50 bytes long

	defs $6580 - myzorg - (basic_end - basic_block)


start:
        ld      (start1+1),sp	;Save entry stack
        ld      hl,-64
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
	ld	hl,__sgoioblk+2
	ld	(hl),19	;stdin
	ld	hl,__sgoioblk+6
	ld	(hl),21	;stdout
	ld	hl,__sgoioblk+10
	ld	(hl),21	;stderr
ENDIF
ENDIF

        call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	EXTERN	closeall
	call	closeall
ENDIF
ENDIF

start1:
        ld      sp,0
        ret



l_dcal:	jp	(hl)		;Used for function pointer calls


;-----------
; Define the stdin/out/err area. For the z88 we have two models - the
; classic (kludgey) one and "ANSI" model
;-----------
__sgoioblk:
IF DEFINED_ANSIstdio
	INCLUDE	"stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF



;---------------------------------
; Select which printf core we want
;---------------------------------
_vfprintf:
IF DEFINED_floatstdio
	EXTERN	vfprintf_fp
	jp	vfprintf_fp
ELSE
	IF DEFINED_complexstdio
		EXTERN	vfprintf_comp
		jp	vfprintf_comp
	ELSE
		IF DEFINED_ministdio
			EXTERN	vfprintf_mini
			jp	vfprintf_mini
		ENDIF
	ENDIF
ENDIF

;-----------
; Now some variables
;-----------
coords:         defw    0       ; Current graphics xy coordinates
base_graphics:  defw    $5000   ; Address of the Graphics map

_std_seed:       defw    0       ; Seed for integer rand() routines

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

IF DEFINED_NEED1bitsound
snd_tick:       defb	0	; Sound variable
bit_irqstatus:	defw	0
ENDIF

;		defm  "Small C+ P2000"
;		defb	0

;-----------------------
; Floating point support
;-----------------------
IF NEED_floatpack
        INCLUDE         "float.asm"
fp_seed:       defb    $80,$80,0,0,0,0	;FP seed (unused ATM)
extra:         defs    6		;FP register
fa:            defs    6		;FP Accumulator
fasign:        defb    0		;FP register

ENDIF

