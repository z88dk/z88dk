;       Startup Code for Embedded Targets
;

	DEFC	ROM_Start  = $0000
	DEFC	RAM_Start  = $8000
	DEFC	RAM_Length = $100
	DEFC	Stack_Top  = $ffff

	MODULE  z88_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

	INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this file

	XREF	_main

	org    ROM_Start

	jp	start
.start
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

.endloop
	jr	endloop
.l_dcal
	jp      (hl)

;For stdin, stdout, stder

	XDEF    __sgoioblk

; vprintf is internal to this file so we only ever include one of the set
; of routines

	XDEF	_vfprintf

; Now, which of the vfprintf routines do we need?

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

; Static variables kept in safe workspace

DEFVARS RAM_Start
{
__sgoioblk
	ds.b	40	;4 bytes * 10 handles
; Are these next two actually used?
l_erraddr
	ds.w    1
l_errlevel
	ds.w    1
int_seed
	ds.w    1
exitsp
	ds.w    1
exitcount
	ds.b    1
fp_seed
	ds.w    3       ;not used ATM
extra
	ds.w    3
fa
	ds.w    3
fasign
	ds.b    1
heapblocks
	ds.w	1
heaplast
	ds.w	1
}

;
; Now, include the math routines if needed..
;

IF NEED_floatpack
        INCLUDE "#float.asm"
ENDIF
