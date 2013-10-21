;
;       Startup for Sorcerer Exidy
;
;       $Id: sorcerer_crt0.asm,v 1.3 2013-10-21 14:23:44 stefano Exp $
;
; 	There are a couple of #pragma commands which affect
;	this file:
;
;	#pragma no-streams - No stdio disc files
;	#pragma no-fileio  - No fileio at all
;
;	These can cut down the size of the resultant executable

	MODULE  sorcerer_crt0

;-------------------------------------------------
; Include zcc_opt.def to find out some information
;-------------------------------------------------

	INCLUDE "zcc_opt.def"

;-----------------------
; Some scope definitions
;-----------------------

	XREF    _main		;main() is always external to crt0

	XDEF    cleanup		;jp'd to by exit()
	XDEF    l_dcal		;jp(hl)

	XDEF	_vfprintf	;jp to printf core routine

	XDEF    exitsp		;atexit() variables
	XDEF    exitcount

	XDEF    heaplast        ;Near malloc heap variables
	XDEF    heapblocks      ;

	XDEF    __sgoioblk	;std* control block

;-----------------------
; Target specific labels
;-----------------------

	XDEF	snd_tick	; for sound code, if any
	XDEF	bit_irqstatus	; current irq status when DI is necessary
	XDEF	pixelbyte	; VDP gfx driver, byte temp storage
	XDEF	coords


;--------
; Set an origin for the application (-zorg=) default to 100h
;--------

        IF      !myzorg
                defc    myzorg  = 100h
        ENDIF

        org     myzorg

;----------------------
; Execution starts here
;----------------------
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

        call    _main		;Call user code

cleanup:
	push	hl		;Save return value
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall	;Close any opened files
	call	closeall
ENDIF
ENDIF
	pop	bc		;Get exit() value into bc
start1:	ld      sp,0		;Pick up entry sp
        jp	$e003		; Monitor warm start

l_dcal:	jp	(hl)		;Used for call by function ptr

;------------------------
; The stdio control block
;------------------------
__sgoioblk:
IF DEFINED_ANSIstdio
	INCLUDE	"stdio_fp.asm"
ELSE
        defw    -11,-12,-10	;Dummy values
ENDIF


;----------------------------------------
; Work out which vfprintf routine we need
;----------------------------------------
_vfprintf:
IF DEFINED_floatstdio
	LIB	vfprintf_fp
	jp	vfprintf_fp
ELSE
	IF DEFINED_complexstdio
		LIB	vfprintf_comp
		jp	vfprintf_comp
	ELSE
		IF DEFINED_ministdio
			LIB	vfprintf_mini
			jp	vfprintf_mini
		ENDIF
	ENDIF
ENDIF


;-----------------------
; Some startup variables
;-----------------------

defltdsk:       defb    0	;Default disc
exitsp:		defw	0	;Address of atexit() stack
exitcount:	defb	0	;Number of atexit() routinens
heaplast:	defw	0	;Pointer to last free heap block
heapblocks:	defw	0	;Number of heap blocks available

IF DEFINED_USING_amalloc
XREF ASMTAIL
XDEF _heap
; The heap pointer will be wiped at startup,
; but first its value (based on ASMTAIL)
; will be kept for sbrk() to setup the malloc area
_heap:
                defw ASMTAIL	; Location of the last program byte
                defw 0
ENDIF

IF !DEFINED_HAVESEED
		XDEF    _std_seed        ;Integer rand() seed
_std_seed:       defw    0      ; Seed for integer rand() routines
ENDIF

IF DEFINED_NEED1bitsound
snd_tick:       defb	0	; Sound variable
bit_irqstatus:	defw	0
ENDIF

;-----------------------------------------------------
; Unneccessary file signature + target specific stuff
;-----------------------------------------------------
         	defm  	"Small C+ CP/M"
end:		defb	0		; null file name
pixelbyte:	defb	0		; temp byte storage for VDP driver
coords:		defw    0       ; Current graphics xy coordinates

;----------------------------------------------
; Floating point support routines and variables
;----------------------------------------------
IF NEED_floatpack
        INCLUDE         "float.asm"

fp_seed:        defb    $80,$80,0,0,0,0	; FP seed (unused ATM)
extra:          defs    6		; FP spare register
fa:             defs    6		; FP accumulator
fasign:         defb    0		; FP variable

ENDIF
