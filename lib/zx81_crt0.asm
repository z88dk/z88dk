;       CRT0 for the ZX81
;
;       Stefano Bodrato Apr. 2000
;
;       If an error occurs eg break we just drop back to BASIC
;
; - - - - - - -
;
;       $Id: zx81_crt0.asm,v 1.6 2002-04-17 21:48:48 dom Exp $
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

        XDEF    int_seed        ;Integer rand() seed

        XDEF    _vfprintf       ;jp to the printf() core

        XDEF    exitsp          ;atexit() variables
        XDEF    exitcount

        XDEF    __sgoioblk      ;stdio info block

        XDEF    base_graphics   ;Graphical variables
        XDEF    coords          ;Current xy position

        XDEF    save81		;Save ZX81 critical registers
        XDEF    restore81	;Restore ZX81 critical registers

	XDEF	saved_hl	;Temporary store used by compiler
	XDEF	saved_de	;for hl and de


.start
	ld	(start1+1),sp	;Save entry stack
        ld      hl,-64		;Create an atexit() stack
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

	call	save81

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
        
.cleanup
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
ENDIF
ENDIF
	pop	bc
	call	restore81
.start1	ld	sp,0		;Restore stack to entry value
        ret

.l_dcal	jp	(hl)		;Used for function pointer calls
        jp      (hl)


.iysave 	defw	0
.ixsave 	defw	0
.a1save 	defb	0
.hl1save	defw	0

.restore81
	ld	iy,(iysave)
	ld	ix,(ixsave)
	ex	af,af
	ld	a,(a1save)
	ex	af,af
	exx
        ld	hl,(hl1save)
        exx
	ret
	
.save81
	ld	(iysave),iy
	ld	(ixsave),ix
	ex	af,af
	ld	(a1save),a
	ex	af,af
	exx
        ld	(hl1save),hl
        exx
	ret

;-----------
; Define the stdin/out/err area. For the z88 we have two models - the
; classic (kludgey) one and "ANSI" model
;-----------
.__sgoioblk
IF DEFINED_ANSIstdio
	INCLUDE	"#stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


;---------------------------------
; Select which printf core we want
;---------------------------------
._vfprintf
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
; Now some variables
;-----------
.coords         defw    0       ; Current graphics xy coordinates
.base_graphics  defw    0       ; Address of the Graphics map

.int_seed       defw    0       ; Seed for integer rand() routines

.exitsp         defw    0       ; Address of where the atexit() stack is
.exitcount      defb    0       ; How many routines on the atexit() stack


.heaplast       defw    0       ; Address of last block on heap
.heapblocks     defw    0       ; Number of blocks
.saved_hl	defw	0	; Temp store for hl
.saved_de	defw	0	; Temp store for de

         	defm  "Small C+ ZX81"&0	;Unnecessary file signature

;-----------------------
; Floating point support
;-----------------------
IF NEED_floatpack
        INCLUDE         "#float.asm"
.fp_seed        defb    $80,$80,0,0,0,0 ;FP seed (unused ATM)
.extra          defs    6               ;FP register
.fa             defs    6               ;FP Accumulator
.fasign         defb    0               ;FP register
ENDIF

