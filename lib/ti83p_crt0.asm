;	Stub for the TI 83+ calculator
;
;	Stefano Bodrato - Dec 2000
;			Feb 2000 - Speeded up the cpygraph
;
;	$Id: ti83p_crt0.asm,v 1.9 2001-06-06 14:01:55 stefano Exp $
;
; startup =
;   n - Primary shell, compatible shells
;       (Primary shell merely means it's the smallest implementation
;        for that shell, that uses full capabilities of the shell)
;
;   1 - Ion (default)
;   2 - MirageOS without quit key
;   3 - MirageOS with quit key - *dangerous*
;   4 - TSE Kernel
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
;2 - MirageOS without quit key
;-----------------------------
IF (startup=2)
	DEFINE NOT_DEFAULT_SHELL	;Else we would use Ion
	;org	$9D93			;Origin
	;defb	$BB,$6D			;Compiled AsmPrgm token
	org	$9D95	;We use Bin2var
	ret				;So TIOS wont run the program
	defb	1			;Identifier as MirageOS program
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

;----------------------------------------
;3 - MirageOS with quit key - *dangerous*
;----------------------------------------
IF (startup=3)
	DEFINE NOT_DEFAULT_SHELL	;Else we would use Ion
	;org	$9D93			;Origin
	;defb	$BB,$6D			;Compiled AsmPrgm token
	org	$9D95	;We use Bin2var
	ret				;So TIOS wont run the program
	defb	3			;Identifier (with quit key)
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
	LIB	exit
	DEFW	exit			; quit adress
	;bit 3 = task interrupt
	DEFINE MIRINT = MIRINT + 8
	; No need to call the interrupt-setup, only if another
	;  utility (other than tasker) is used.
	; So no need to increment UseMirageInt
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
;4 - TSE Kernel
;--------------
IF (startup = 4)
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
	;org	$9D93		; Origin
	;defb	$BB,$6D		; Compiled AsmPrgm token
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
IF !DEFINED_GRAYlib
 IF DEFINED_GimmeSpeed
	ld	a,1		; switch to 15MHz (extra fast)
	rst	28		; bcall(SetExSpeed)
	defw	$50BF
 ENDIF
ENDIF
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
	INCLUDE	"#graylib83p.asm"
ENDIF

IF (startup=2) | (startup=3)	; MirageOS
 IF DEFINED_Timer
 ;bit 0 = Set timer on
        DEFINE MIRINT = MIRINT + 1
 	DEFINE UseMirageInt = UseMirageInt + 1
 ENDIF
 
 IF DEFINED_NoGetkey2ndOnCrash
 ;bit 1 = Disable [2nd]+[On] in _getkey
	DEFINE MIRINT = MIRINT + 2
 	DEFINE UseMirageInt = UseMirageInt + 1
 ENDIF

 IF DEFINED_APD_On
 ;bit 2 = APD after about 3 minutes (6MHz calc!)
 	DEFINE MIRINT = MIRINT + 4
  	DEFINE UseMirageInt = UseMirageInt + 1
 ENDIF

 IF DEFINED_FastArrowKeys
 ;bit 4 = keydelay interrupt
 	DEFINE MIRINT = MIRINT + 16
  	DEFINE UseMirageInt = UseMirageInt + 1
 ENDIF

 IF UseMirageInt
	ld	a,MIRINT	; Enable custom interrupt
	call	$4191		; call setupint
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

IF !DEFINED_GRAYlib
 IF DEFINED_GimmeSpeed
	xor	a		; switch to 6MHz (normal speed)
	rst	28		; bcall(SetExSpeed)
	defw	$50BF
 ENDIF
ENDIF

.start1
	ld	sp,0		; restore SP
IF (startup=4)			; TSE Kernel
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
.base_graphics	defw	$9340	; Ti83+
.coords		defw	0

.cpygraph
IF DEFINED_GRAYlib
		ret
ELSE
 IF DEFINED_GimmeSpeed
	call	$50		; bjump(GrBufCpy)
	defw	$486A		; FastCopy is far too fast at 15MHz...
 ELSE
  IF !NOT_DEFAULT_SHELL
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
.extra		defs	6
.fa		defs	6
.fasign		defb	0
ENDIF


