;	Stub for the TI 85 calculator
;
;	Stefano Bodrato - Dec 2000
;
;	$Id: ti85_crt0.asm,v 1.10 2001-06-06 14:01:55 stefano Exp $
;
;-----------------------------------------------------
; Some general XDEFs and XREFs needed by the assembler
;-----------------------------------------------------

	MODULE  z88_crt0

; No matter what set up we have, main is always, always external to
; this file
	XREF	_main

; Some variables which are always needed
	XDEF	cleanup
	XDEF	l_dcal

; Integer rnd seed
	XDEF	int_seed

; vprintf is internal to this file so we only ever include one of the set
; of routines
	XDEF	_vfprintf

; Exit variables
	XDEF	exitsp
	XDEF	exitcount

; For stdin, stdout, stder
	XDEF	__sgoioblk

; Graphics stuff
	XDEF	base_graphics
	XDEF	coords

; TI calc specific stuff
	XDEF	cpygraph
	XDEF	tidi
	XDEF	tiei

;-------------------------
; Begin of (shell) headers
;-------------------------

	INCLUDE	"zcc_opt.def"	; Receive all compiler-defines
;-------------------
;1 - Rigel (default)
;-------------------
	org	$9296		; Origin to Rigel programs
.description
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"	; Get namestring from zcc_opt.def
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0		; Termination zero
.enddesc


;-------------------------------------
; End of header, begin of startup part
;-------------------------------------
.start
	ld	hl,0
	add	hl,sp
	ld	(start1+1),hl
IF DEFINED_atexit		; Less stack use
	ld	hl,-64
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
	INCLUDE	"#graylib85.asm"
ENDIF

	call	tidi
	call	_main
	call	tiei

IF DEFINED_GRAYlib
        ld a,$3c
        out (0),a    ;Set screen back to normal
ENDIF

; Deallocate memory which has been allocated here!	
.cleanup
IF !DEFINED_nostreams
 IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
 ENDIF
ENDIF

.start1
	ld	sp,0
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
.__sgoioblk
IF DEFINED_ANSIstdio
	INCLUDE	"#stdio_fp.asm"
ELSE
	defw	-11,-12,-10
ENDIF


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

;Seed for integer rand() routines
.int_seed	defw	0

;Atexit routine
.exitsp		defw	0
.exitcount	defb	0

; Heap stuff
.heaplast	defw	0
.heapblocks	defw	0

; mem stuff
.base_graphics	defw	$FC00	;TI85 (8641 ?)
.coords		defw	0

;All the float stuff is kept in a different file...for ease of altering!
;It will eventually be integrated into the library
;
;Here we have a minor (minor!) problem, we've no idea if we need the
;float package if this is separated from main (we had this problem before
;but it wasn't critical..so, now we will have to read in a file from
;the directory (this will be produced by zcc) which tells us if we need
;the floatpackage, and if so what it is..kludgey, but it might just work!
;
;Brainwave time! The zcc_opt file could actually be written by the
;compiler as it goes through the modules, appending as necessary - this
;way we only include the package if we *really* need it!

IF NEED_floatpack
	INCLUDE	"#float.asm"
;seed for random number generator - not used yet..
.fp_seed	defb	$80,$80,0,0,0,0
;Floating point registers...
.extra		defs	6
.fa		defs	6
.fasign		defb	0

ENDIF
