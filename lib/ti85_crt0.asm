;	Stub for the TI 85 calculator
;
;	Stefano Bodrato - Dec 2000
;
;	$Id: ti85_crt0.asm,v 1.13 2001-09-20 15:54:03 stefano Exp $
;
;-----------------------------------------------------
; Some general XDEFs and XREFs needed by the assembler
;-----------------------------------------------------

	MODULE  Ti85_crt0

	XREF	_main		; No matter what set up we have, main is
				;  always, always external to this file.

	XDEF	cleanup		; used by exit()
	XDEF	l_dcal		; used by calculated calls = "call (hl)"

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

	INCLUDE "#Ti85.def"	; ROM / RAM adresses on Ti85
	INCLUDE	"zcc_opt.def"	; Receive all compiler-defines

;-------------------
;1 - Rigel (default)
;-------------------
	org	$9296		; Origin to Rigel programs
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"	; Get namestring from zcc_opt.def
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

IF (!DEFINED_nostreams) ~ (DEFINED_ANSIstdio) ; ~ = AND
 IF DEFINED_floatstdio | DEFINED_complexstdio | DEFINED_ministdio
  IF !NONANSI
	;Reset the ANSI cursor
	XREF	ansi_ROW
	XREF	ansi_COLUMN
	xor	a
	ld	(ansi_ROW),a
	ld	(ansi_COLUMN),a
 	; Set up the std* stuff so we can be called again
	;ld	hl,__sgoioblk+2
	;ld	(hl),19	;stdin
	;ld	hl,__sgoioblk+6
	;ld	(hl),21	;stdout
	;ld	hl,__sgoioblk+10
	;ld	(hl),21	;stderr
  ENDIF
 ENDIF
ENDIF

IF DEFINED_GRAYlib
	INCLUDE	"#gray85.asm"
	;im	2
ENDIF

	call	tidi
	call	_main
.cleanup
IF DEFINED_GRAYlib
        ld	a,$3c
        out	(0),a    ;Set screen back to normal
ENDIF
.start1
	ld	sp,0
	ld	iy,_IY_TABLE	; Restore flag-pointer
	im	1
	ei
.cpygraph
	ret

;----------------------------------------
; End of startup part, routines following
;----------------------------------------
.l_dcal
	jp	(hl)

.tiei
	exx
	ld	hl,(hl1save)
	ld	bc,(bc1save)
	ld	de,(de1save)
	exx
	ld	iy,(iysave)
IF DEFINED_GRAYlib
	im	1
ELSE
	ei
ENDIF
	ret

.tidi
IF DEFINED_GRAYlib
	im	2
ELSE
	di
ENDIF
	exx
	ld	(hl1save),hl
	ld	(bc1save),bc
	ld	(de1save),de
	exx
	ld	(iysave),iy
	ret

.hl1save defw	0
.de1save defw	0
.bc1save defw	0
.iysave  defw	0

	
; Now, define some values for stdin, stdout, stderr
IF (!DEFINED_nostreams) ~ (DEFINED_ANSIstdio) ; ~ = AND
.__sgoioblk
	INCLUDE	"#stdio_fp.asm"
ENDIF


; Now, which of the vfprintf routines do we need?
IF (!DEFINED_nostreams) ~ (DEFINED_ANSIstdio) ; ~ = AND
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

;Seed for integer rand() routines
.int_seed	defw	0

;Atexit routine
.exitsp		defw	0
.exitcount	defb	0

; Heap stuff
.heaplast	defw	0
.heapblocks	defw	0

; mem stuff
.base_graphics	defw	VIDEO_MEM
.coords		defw	0

IF NEED_floatpack
	INCLUDE	"#float.asm"
;seed for random number generator - not used yet..
.fp_seed	defb	$80,$80,0,0,0,0
;Floating point registers...
.extra		defs	6
.fa		defs	6
.fasign		defb	0
ENDIF
