;	Stub for the TI 86 calculator
;
;	Stefano Bodrato - Dec 2000
;
;	$Id: ti86_crt0.asm,v 1.9 2001-06-06 14:01:55 stefano Exp $
;
; startup =
;   n - Primary shell(s); compatible shell(s)
;       (Primary shell merely means it's the smallest implementation
;        for that shell, that uses full capabilities of the shell)
;
;   1 - LASM (default)
;   2 - ASE, Rascal, emanon, etc.
;   3 - zap2000
;   4 - emanon
;   5 - Embedded LargeLd - !!!EXPERIMENTAL!!!
;  10 - asm() executable
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

;-----------------------------
;2 - ASE, Rascal, emanon, etc.
;-----------------------------
IF (startup=2)
	DEFINE NOT_DEFAULT_SHELL
	org	$D748		;TI 86 standard asm() entry point.
	nop			;identifier of table
	jp	start
	defw	$0000		;version number of table
	defw	description	;pointer to the description
.description
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0		; Termination zero
.enddesc
ENDIF

;-----------
;3 - zap2000
;-----------
IF (startup=3)
	DEFINE NOT_DEFAULT_SHELL
	org	$D748
	nop
	jp	start
	defw 	description
	defw	icon
.description
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0		; Termination zero
.enddesc
.icon
	DEFINE NEED_icon
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_icon
 IF !DEFINED_NEED_icon
	defb	@00000000	; 8x8 icon
	defb	@00110010	; C with a small '+'
	defb	@01000111
	defb	@01000010
	defb	@01000000
	defb	@00110000
	defb	@00000000
	defb	@00000000
 ENDIF
.endicon
ENDIF

;----------
;4 - emanon
;----------
IF (startup=4)
	DEFINE NOT_DEFAULT_SHELL
	org	$D748		;TI 86 standard asm() entry point.
	nop			;identifier of table
	jp	start
	defw	$0001		;version number of table
	defw	description	;pointer to description
	defw	icon		;pointer to icon
.description
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0		; Termination zero
.enddesc
.icon
	DEFINE NEED_icon
	INCLUDE	"zcc_opt.def"	; Get icon from zcc_opt.def
	UNDEFINE NEED_icon
  IF !DEFINED_NEED_icon
	defb	@00000000	; 7x7 icon
	defb	@00110010
	defb	@01000111
	defb	@01000010
	defb	@01000000
	defb	@00110000
	defb	@00000000
  ENDIF
.endicon
ENDIF

;----------------------
; 10 - asm() executable
;----------------------
IF (startup=10)
	DEFINE NOT_DEFAULT_SHELL
        org     $D748
ENDIF

;--------------------------------------------------
; 5 - Embedded LargeLd - !!!EXPERIMENTAL!!!
; - The calculator needs to be reset (memory clean)
; - This has to be the first program in memory
;--------------------------------------------------
IF (startup=5)
	DEFINE NOT_DEFAULT_SHELL
        org     $8000+14
       	ld	a,$42	; (RAM_PAGE_1)
	out	(6),a
	jp	start
ENDIF

;------------------
;1 - LASM (default)
;------------------
IF !NOT_DEFAULT_SHELL
	org	$801F	; "Large asm block". To be loaded with "LASM"
	; You need LASM 0.8 Beta by Patrick Wong for this (www.ticalc.org)
	; - First wipe TI86 RAM (InstLASM is simply a memory cleaner)
	; - Load LargeLd
	; - Load you compiled and converted .86p code
	; - run asm(LargeLd
	; It will run you program. Loading order is important.
	
	org	$801F	; "Large asm block". To be loaded with "LASM"
	ret
	nop		;Identifies the table
	jp	start
ENDIF


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
	; Reset the ANSI cursor
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
	INCLUDE	"#graylib86.asm"
ENDIF

	call	$4A95	; Close menus

	call	tidi
	call	_main
	call	tiei

IF DEFINED_GRAYlib
       	ld	a,$3C	; Make sure video mem is active
	out	(0),a
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
.base_graphics	defw	$FC00	;TI86
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

