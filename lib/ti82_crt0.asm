;	Stub for the TI 82 calculator
;
;	Stefano Bodrato - Dec 2000
;
;	$Id: ti82_crt0.asm,v 1.11 2001-07-16 13:27:49 dom Exp $
;
;-----------------------------------------------------
; Some general XDEFs and XREFs needed by the assembler
;-----------------------------------------------------

	MODULE  Ti82_crt0

	XREF	_main		; No matter what set up we have, main is
				;  always, always external to this file.

	XDEF	cleanup		; used by exit()
	XDEF	l_dcal		; used by calculated calls  = "call (hl)"

	XDEF	int_seed	; Integer rnd seed

	XDEF	_vfprintf	; vprintf is internal to this file so we
				;  only ever include one of the set of
				;  routines

	XDEF	exitsp		; Exit variables
	XDEF	exitcount	;

	XDEF	__sgoioblk	; For stdin, stdout, stder

	XDEF	base_graphics	; Graphics stuff
	XDEF	coords		;

	XDEF	cpygraph	; TI calc specific stuff
	XDEF	tidi		;
	XDEF	tiei		;

;-------------------------
; Begin of (shell) headers
;-------------------------

	INCLUDE "#Ti82.def"	; ROM / RAM adresses on Ti82
	INCLUDE	"zcc_opt.def"	; Receive all compiler-defines

;-------------------
;1 - CrASH (default)
;-------------------
	org	START_ADDR
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
ENDIF
	defb	$0		; Termination zero

;-------------------------------------
; End of header, begin of startup part
;-------------------------------------
.start
	ld	hl,0
	add	hl,sp
	ld	(start1+1),hl
IF !DEFINED_atexit		; Less stack use
	ld	hl,-6		; 3 pointers (more likely value)
	add	hl,sp
	ld	sp,hl
	ld	(exitsp),sp
ELSE
	ld	hl,-64		; 32 pointers (ANSI standard)
	add	hl,sp
	ld	sp,hl
	ld	(exitsp),sp
ENDIF

IF !DEFINED_nostreams
 IF DEFINED_ANSIstdio
  IF DEFINED_floatstdio | DEFINED_complexstdio | DEFINED_ministdio
	;Reset the ANSI cursor
	XREF	ansi_ROW
	XREF	ansi_COLUMN
	xor	a
	ld	(ansi_ROW),a
	ld	(ansi_COLUMN),a
 	; Set up the std* stuff so we can be called again
	ld	hl,__sgoioblk+2
	ld	(hl),19	;stdin
	ld	hl,__sgoioblk+6
	ld	(hl),21	;stdout
	ld	hl,__sgoioblk+10
	ld	(hl),21	;stderr
  ENDIF
 ENDIF
ENDIF

IF DEFINED_GRAYlib
	INCLUDE	"#gray82.asm"
ELSE
	INCLUDE "#intwrap82.asm"
ENDIF

	im	2
	call	_main
.cleanup
	ld	iy,_IY_TABLE
	im	1
.start1
	ld	sp,0		; writeback
IF DEFINED_GRAYlib
.cpygraph			; little opt :)
ENDIF
	ret


;----------------------------------------
; End of startup part, routines following
;----------------------------------------
.l_dcal
	jp	(hl)

.tiei	ei
.tidi	ret

; Now, define some values for stdin, stdout, stderr
IF DEFINED_floatstdio | DEFINED_complexstdio | DEFINED_ministdio
 IF !DEFINED_nostreams
  IF DEFINED_ANSIstdio
.__sgoioblk
	INCLUDE	"#stdio_fp.asm"
  ENDIF
 ENDIF
ENDIF


; Now, which of the vfprintf routines do we need?
IF !DEFINED_nostreams
 IF DEFINED_ANSIstdio
  IF DEFINED_floatstdio
._vfprintf
	LIB vfprintf_fp
	jp  vfprintf_fp
  ELSE
   IF DEFINED_complexstdio
._vfprintf
	LIB vfprintf_comp
	jp  vfprintf_comp
   ELSE
    IF DEFINED_ministdio
._vfprintf
	LIB vfprintf_mini
	jp  vfprintf_mini
    ENDIF
   ENDIF
  ENDIF
 ENDIF
ENDIF

;Seed for integer rand() routines
.int_seed	defw	0

;Atexit routine
.exitsp		defw	0
.exitcount	defb	0

;Heap stuff (already needed?)
.heaplast	defw	0
.heapblocks	defw	0

;mem stuff
.base_graphics	defw	GRAPH_MEM
.coords		defw	0
	
IF !DEFINED_GRAYlib
.cpygraph	jp	CR_GRBCopy	; CrASH FastCopy
ENDIF

IF NEED_floatpack
	INCLUDE	"#float.asm"
;seed for random number generator - not used yet..
.fp_seed	defb	$80,$80,0,0,0,0
;Floating point registers...
.extra		defs	6
.fa		defs	6
.fasign		defb	0
ENDIF
