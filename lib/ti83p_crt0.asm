;	Stub for the TI 83+ calculator
;
;	Stefano Bodrato - Dec 2000
;			Feb 2000 - Speeded up the cpygraph
;
;	$Id: ti83p_crt0.asm,v 1.8 2001-05-18 13:39:29 stefano Exp $
;
; startup =
;   n - Primary shell, compatible shells
;	(Primary shell merely means it's the smallest implementation
;	for that shell, that uses full capablilities of the shell)
;
;   1 - Ion (default)
;   2 - MirageOS
;   3 - TSE Kernel
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
	
;------------
;2 - MirageOS
;------------
IF (startup=2)
	DEFINE NOT_DEFAULT_SHELL	;Else we would use Ion
	;org	$9D93			;Origin
	;defb	$BB,$6D			;Compiled AsmPrgm token
	org	$9D95	;We use Bin2var
	ret				;So TIOS wont run the program
	defb	1			;Identifier as MirageOS program
	;defb	3			;Identifier (with quit key)
.icon
	DEFINE NEED_mirage_icon
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_mirage_icon
 IF !DEFINED_NEED_mirage_icon
	defb	@01111000,@00000000	;15x15 button
	defb	@10000100,@00000000	;NEEDS TO BE THIS SIZE!!!
	defb	@10000011,@11111100
	defb	@10000000,@00000010	;Picture of a map with "C+" on it
	defb	@10011111,@00000010
	defb	@10111111,@00000010
	defb	@10110000,@00110010
	defb	@10110000,@01111010
	defb	@10110000,@01111010
	defb	@10110000,@00110010
	defb	@10111111,@00000010
	defb	@10011111,@00000010
	defb	@10000000,@00000010
	defb	@10000000,@00000010
	defb	@01111111,@11111100
 ENDIF
.endicon
	;XREF	exit
	;DEFW	exit			; quit adress
.description
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"		; Get namestring from zcc_opt.def
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0			; Termination zero
.enddesc
ENDIF

;--------------
;3 - TSE Kernel
;--------------
IF (startup = 3)
	DEFINE NOT_DEFAULT_SHELL
	;org	$9D92		; Program origin
	;defb	$BB,$6D		; Program variable header
	org	$9D94	;We use Bin2var
	ret			; RET for TI-OS
	defm	"TSE"&1&" "	; TSE Header
.description
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"	; Get namestring from zcc_opt.def
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0		; Termination zero
.enddesc
 IF !DEFINED_StackNeeded
	defw	400		; External Data Required for virtual stack.
				; I've set this to 400 (the normal size of
				;  the Ti83+ stack)
				; You can use #pragma to set a userdefined
				;  value:
				; #pragma output StackNeeded = nnn;
 ELSE
	defw	DEFINED_StackNeeded
 ENDIF
ENDIF

;-----------------
;1 - Ion (default)
;-----------------
IF !NOT_DEFAULT_SHELL
	;org	$9D93			;Origin
	;defb	$BB,$6D			;Compiled AsmPrgm token
	org	$9D95	;We use Bin2var
	jr	nc,start
.description
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"	; Get namestring from zcc_opt.def
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0		; Termination zero
.enddesc
ENDIF


;-------------------------------------
; End of header, begin of startup part
;-------------------------------------
.start

	ld	hl,0
	add	hl,sp
	ld	(start1+1),hl
	ld	hl,-64
	add	hl,sp
	ld	sp,hl
	ld	(exitsp),sp

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
 IF (startup=2)			; MirageOS
	; Quick hack to make things work (I hope)
	ld	hl,IntProcStart	; Load interrupt start addres
	ld	($966F),hl	; Store at custintaddr
	ld	a,32		; Enable custom interrupt (bit 5)
	call	$4191		; call setupint
 ELSE
	INCLUDE	"#graylib83p.asm"
 ENDIF
ENDIF

	call	tidi
	call	_main
	call	tiei

; Deallocate memory which has been allocated here!	
.cleanup
IF !DEFINED_nostreams
 IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
 ENDIF
ENDIF

.start1
	ld	sp,0		; restore SP
IF (startup=3)			; TSE Kernel
	call	$9872+20	; call _tseForceYield
				; Task-switch back to shell (can return...)
	jp	start		; begin again if needed...
ELSE
	ret
ENDIF


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
.base_graphics	defw	$9340	;TI83+
.coords		defw	0

.cpygraph
IF DEFINED_GRAYlib
		ret
ELSE
 IF !DEFINED_startup | (startup=1) | !NOT_DEFAULT_SHELL
		jp	$966E+80+15	; Ion FastCopy call
 ENDIF
 IF (startup=2)
		jp	$4092		; MirageOS FastCopy call
 ENDIF
 IF (startup=3)
		jp	$8A3A+18	; TSE FastCopy call
 ENDIF
ENDIF

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
.extra	 	defs	6
.fa		defs	6
.fasign		defb	0

ENDIF


