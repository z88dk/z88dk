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
;       $Id: nc100_crt0.asm,v 1.8 2009-06-22 21:20:05 dom Exp $
;



	MODULE  nc100_crt0

;--------
; Include zcc_opt.def to find out some info
;--------
	INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

	XREF    _main		;main() is always external to crt0 code

        XDEF    cleanup		;jp'd to by exit()
        XDEF    l_dcal		;jp(hl)

        XDEF    _std_seed	;Integer rand() seed

	XDEF	_vfprintf	;jp to the printf() core

        XDEF    exitsp		;atexit() variables
        XDEF    exitcount

       	XDEF	heaplast	;Near malloc heap variables
	XDEF	heapblocks

        XDEF    __sgoioblk	;stdio info block

	XDEF	base_graphics	;Graphical variables
	XDEF	coords

        org     $C000

	jp	start
	defs	509		;Waste 509 bytes of space

;--------
; Card header
;--------
	defm	"NC100PRG"	
	defb	0,0,0,0,0,0,0,0
	jp	start			;c210
	defm	"z88dk NC100"
	defb	0,0

start:				;Entry point at $c2220
	ld	(start+1),sp	;Save entry sp
        ld      hl,-64		;Create the atexit stack
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp
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
	LIB	closeall	;Close all opened files
	call	closeall
ENDIF
ENDIF
	exx			;???? Hangover from ZX code?
	ld	hl,10072
	exx
	pop	bc
start1:	ld	sp,0
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


;-------
; Some variables
;-------

_std_seed:       defw    0	;Integer rand() seed

;Atexit routine

exitsp:		defw	0	;atexit() stack address
exitcount:	defb	0	;Number of atexit() routines
heaplast:	defw	0	;heap variables
heapblocks:	defw	0

base_graphics:	defw	0	;Graphics variables
coords:		defw	0

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
