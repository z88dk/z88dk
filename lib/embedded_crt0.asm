;       Startup Code for Embedded Targets
;
;	Daniel Wallner March 2002
;
;	$Id: embedded_crt0.asm,v 1.4 2009-06-10 17:26:04 stefano Exp $
;
; (DM) Could this do with a cleanup to ensure rstXX functions are
; available?

	DEFC	ROM_Start  = $0000
	DEFC	RAM_Start  = $8000
	DEFC	RAM_Length = $100
	DEFC	Stack_Top  = $ffff

	MODULE  embedded_crt0

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

        XDEF    _std_seed        ;Integer rand() seed

        XDEF    exitsp          ;Pointer to atexit() stack
        XDEF    exitcount       ;Number of atexit() functions registered

        XDEF    __sgoioblk      ;std* control block

        XDEF    heaplast        ;Near malloc heap variables
        XDEF    heapblocks      ;

        XDEF    _vfprintf       ;jp to printf() core routine


	org    ROM_Start

	jp	start
start:
; Make room for the atexit() stack
	ld	hl,Stack_Top-64
	ld	sp,hl
; Clear static memory
	ld	hl,RAM_Start
	ld	de,RAM_Start+1
	ld	bc,RAM_Length-1
	ld	(hl),0
	ldir
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

	ld      hl,$8080
	ld      (fp_seed),hl
	xor     a
	ld      (exitcount),a

; Entry to the user code
	call    _main

cleanup:
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

endloop:
	jr	endloop
l_dcal:
	jp      (hl)

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

; Static variables kept in safe workspace

DEFVARS RAM_Start
{
__sgoioblk      ds.b    40      ;stdio control block
_std_seed        ds.w    1       ;Integer seed
exitsp          ds.w    1       ;atexit() stack
exitcount       ds.b    1       ;Number of atexit() routines
fp_seed         ds.w    3       ;Floating point seed (not used ATM)
extra           ds.w    3       ;Floating point spare register
fa              ds.w    3       ;Floating point accumulator
fasign          ds.b    1       ;Floating point variable
heapblocks      ds.w    1       ;Number of free blocks
heaplast        ds.w    1       ;Pointer to linked blocks
}


;--------
; Now, include the math routines if needed..
;--------
IF NEED_floatpack
        INCLUDE "#float.asm"
ENDIF
