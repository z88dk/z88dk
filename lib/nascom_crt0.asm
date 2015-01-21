;       CRT0 for the NASCOM1/2
;
;       Stefano Bodrato May 2003
;
;
; - - - - - - -
;
;       $Id: nascom_crt0.asm,v 1.10 2015-01-21 07:05:00 stefano Exp $
;
; - - - - - - -


	MODULE  nascom_crt0

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

	PUBLIC    _std_seed        ;Integer rand() seed

	PUBLIC    _vfprintf       ;jp to the printf() core

	PUBLIC    exitsp          ;atexit() variables
	PUBLIC    exitcount

	PUBLIC    __sgoioblk      ;stdio info block

	PUBLIC	heaplast	;Near malloc heap variables
	PUBLIC	heapblocks

	PUBLIC    base_graphics   ;Graphical variables (useless with NASCOM)
	PUBLIC    coords          ;Current xy position

	PUBLIC    montest         ;NASCOM: check the monitor type


	org	0C80h
	;org	0E000h
	
; NASSYS1..NASSYS3
;  IF (startup=1) | (startup=2) | (startup=3)
;
;
;  ENDIF

start:

	ld	(start1+1),sp	;Save entry stack

	; search for the top of writeble memory and set the stack pointer
	ld	hl,0ffffh
	ld	a,55
stackloop:
	ld	(hl),a
	cp	(hl)
	dec	hl
	jr	nz,stackloop

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

	call    _main	;Call user program

cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	EXTERN	closeall
	call	closeall
ENDIF
ENDIF

	pop	bc
start1:	ld	sp,0		;Restore stack to entry value
	rst	18h
	defb	5bh
	;ret

l_dcal:	jp	(hl)		;Used for function pointer calls
        jp      (hl)


;------------------------------------
; Check which monitor we have in ROM
;------------------------------------

montest: ld	a,(1)	; "T" monitor or NAS-SYS?
         cp	33h	; 31 00 10     / 31 33 0C
         ret


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
base_graphics:  defw    0       ; Address of the Graphics map

_std_seed:      defw    0       ; Seed for integer rand() routines

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

                defm  "Small C+ NASCOM"	;Unnecessary file signature
                defb	0

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

