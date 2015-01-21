;       Kludgey startup for nc100
;
;       djm 17/4/2000
;
; 	I've never used one of these brutes so I dunno if it's
;	correct at all, this is all taken from the file nciospec.doc
;	on nvg.unit.no, I assume that the PCMCIA RAM card is an
;	actual fact addressable RAM and we can overwrite variables
;	etc NB. Values of static variables are not reinitialised on
;	future entry.
;
;       $Id: nc100_crt0.asm,v 1.11 2015-01-21 07:05:00 stefano Exp $
;



	MODULE  nc100_crt0

;--------
; Include zcc_opt.def to find out some info
;--------
	INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

		EXTERN    _main		;main() is always external to crt0 code

		PUBLIC    cleanup		;jp'd to by exit()
		PUBLIC    l_dcal		;jp(hl)

		PUBLIC    _std_seed	;Integer rand() seed

		PUBLIC	_vfprintf	;jp to the printf() core

		PUBLIC    exitsp		;atexit() variables
		PUBLIC    exitcount

		PUBLIC	heaplast	;Near malloc heap variables
		PUBLIC	heapblocks

		PUBLIC    __sgoioblk	;stdio info block

		PUBLIC	base_graphics	;Graphical variables
		PUBLIC	coords


IF (startup=2)

		org     $8C00
		jp	start

ELSE

		org     $C000
		jp	start

IF DEFINED_USING_amalloc
EXTERN ASMTAIL
PUBLIC _heap
; We have 509 bytes we can use here..
_heap:
		defw 0
		defw 0
_mblock:
		defs	505		; Few bytes for malloc() stuff
ELSE
		defs	509		; Waste 509 bytes of space
ENDIF

;--------
; Card header
;--------
	defm	"NC100PRG"	
	defb	0,0,0,0,0,0,0,0
	jp	start			;c210
	defm	"z88dk NC100"
	defb	0,0

ENDIF


start:				;Entry point at $c2220
        ld      (start1+1),sp   ;Save entry stack
        ld      hl,-64		;Create the atexit stack
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		ld hl,_heap
		; compact way to do "mallinit()"
		xor	a
		ld	(hl),a
		inc hl
		ld	(hl),a
		inc hl
		ld	(hl),a
		inc hl
		ld	(hl),a
		
		ld hl,_mblock
		push hl	; data block
		ld hl,505
		push hl	; area size
		EXTERN sbrk_callee
		call	sbrk_callee
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
	push	hl
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	EXTERN	closeall	;Close all opened files
	call	closeall
ENDIF
ENDIF
	pop	bc
start1:
	ld	sp,0
	ret

l_dcal:	jp	(hl)

; Now, define some values for stdin, stdout, stderr

__sgoioblk:
IF DEFINED_ANSIstdio
	INCLUDE	"stdio_fp.asm"
ENDIF


;-------
; Now, which of the vfprintf routines do we need?
;-------
_vfprintf:
IF DEFINFED_floatstdio
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


;-------
; Some variables
;-------

_std_seed:       defw    0	;Integer rand() seed

;Atexit routine

exitsp:		defw	0	;atexit() stack address
exitcount:	defb	0	;Number of atexit() routines
heaplast:	defw	0	;heap variables
heapblocks:	defw	0


base_graphics:  defw	0	;Graphics variables
coords:         defw	0

		defm	"Small C+ nc100"
		defb	0

;-------
; Floating point
;-------
IF NEED_floatpack
        INCLUDE         "float.asm"

fp_seed:        defb    $80,$80,0,0,0,0	;FP seed (unused ATM)
extra:          defs    6		;FP spare register
fa:             defs    6		;FP accumulator
fasign:         defb    0		;FP variable

ENDIF
