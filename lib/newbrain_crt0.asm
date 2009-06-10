;
;       Grundy NewBrain startup code
;
;
;       $Id: newbrain_crt0.asm,v 1.6 2009-06-10 17:26:04 stefano Exp $
;

                MODULE  newbrain_crt0
;--------
; Include zcc_opt.def to find out some info
;--------
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        XREF    _main           ;main() is always external to crt0 code

        XDEF    cleanup         ;jp'd to by exit()
        XDEF    l_dcal          ;jp(hl)

        XDEF    _std_seed        ;Integer rand() seed

        XDEF    _vfprintf       ;jp to the printf() core

        XDEF    exitsp          ;atexit() variables
        XDEF    exitcount

       	XDEF	heaplast	;Near malloc heap variables
	XDEF	heapblocks

        XDEF    __sgoioblk      ;stdio info block

        XDEF    base_graphics   ;Graphical variables
	XDEF	coords		;Current xy position

	XDEF	snd_tick	;Sound variable

	XDEF	nbclockptr	;ptr to clock counter location
IF (startup=2)
	XDEF	oldintaddr	;made available to chain an interrupt handler
ENDIF


        IF      !myzorg
                defc    myzorg  = 10000
        ENDIF
                org     myzorg


start:
        ld      (start1+1),sp	;Save entry stack
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp
        
IF (startup=2)
	ld	hl,(57)
	ld	(oldintaddr),hl
	ld	hl,nbckcount
	ld	(57),hl
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

        call    _main		;Call user program

cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
ENDIF
ENDIF

IF (startup=2)
	ld	hl,(oldintaddr)
	ld	(57),hl
ENDIF

cleanup_exit:

start1: ld      sp,0            ;Restore stack to entry value
        ret

l_dcal:	jp	(hl)		;Used for function pointer calls


;-----------
; Define the stdin/out/err area. For the z88 we have two models - the
; classic (kludgey) one and "ANSI" model
;-----------
__sgoioblk:
IF DEFINED_ANSIstdio
	INCLUDE	"#stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF



;---------------------------------
; Select which printf core we want
;---------------------------------
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


;-----------
; Grundy NewBrain clock handler.
; an interrupt handler could chain the "oldintaddr" value.
;-----------

IF (startup=2)

nbclockptr:	defw	$52	; ROM routine

; Useless custom clock counter (we have the ROM one).
;
;.nbclockptr	defw	nbclock
;
nbckcount:
;		push	af
;		push	hl
;		ld	hl,(nbclock)
;		inc	hl
;		ld	(nbclock),hl
;		ld	a,h
;		or	l
;		jr	nz,nomsb
;		ld	hl,(nbclock_m)
;		inc	hl
;		ld	(nbclock_m),hl
;nomsb:		pop	hl
;		pop	af

		defb	195	; JP
oldintaddr:	defw	0

nbclock:	defw	0	; NewBrain Clock
nbclock_m:	defw	0

ELSE

nbclockptr:	defb	$52	; paged system clock counter

ENDIF


;-----------
; Now some variables
;-----------

coords:         defw    0       ; Current graphics xy coordinates
base_graphics:  defw    0       ; Address of the Graphics map

_std_seed:       defw    0       ; Seed for integer rand() routines

exitsp:         defw    0       ; Address of where the atexit() stack is
exitcount:      defb    0       ; How many routines on the atexit() stack


heaplast:       defw    0       ; Address of last block on heap
heapblocks:     defw    0       ; Number of blocks

IF DEFINED_NEED1bitsound
snd_tick:	defb	0	; Sound variable
ENDIF

		defm	"Small C+ NewBrain"	;Unnecessary file signature
		defb	0

;-----------------------
; Floating point support
;-----------------------
IF NEED_floatpack
        INCLUDE         "#float.asm"
fp_seed:        defb    $80,$80,0,0,0,0	;FP seed (unused ATM)
extra:          defs    6		;FP register
fa:             defs    6		;FP Accumulator
fasign:         defb    0		;FP register

ENDIF

