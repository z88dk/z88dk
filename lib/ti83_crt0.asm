;	Stub for the TI 83 calculator
;
;	Stefano Bodrato	- Dec 2000
;	Henk Poley	- Apr 2001 Fixed and add some things
;
;	$Id: ti83_crt0.asm,v 1.21 2009-06-10 17:26:05 stefano Exp $
;
; startup =
;   n - Primary shell(s); compatible shell(s)
;       (Primary shell merely means it's the smallest implementation
;        for that shell, that uses full capabilities of the shell)
;
;   1 - Ion; Ti-Explorer (default)
;   2 - Venus;
;   3 - ZES;
;   4 - Anova; SOS
;   5 - Ti-Explorer, AShell; SOS, Anova (same as 6)
;   6 - AShell, Ti-Explorer; SOS, Anova (same as 5)
;   7 - SOS; Anova
;   8 - Venus Explorer; Venus
;   9 - Ion, Ti-Explorer; ZASMLOAD, plain TIOS
;  10 - Plain TIOS, ZASMLOAD
;
;-----------------------------------------------------
; Some general XDEFs and XREFs needed by the assembler
;-----------------------------------------------------

	MODULE  Ti83_crt0

	XREF	_main		; No matter what set up we have, main is
				;  always, always external to this file.

	XDEF	cleanup		; used by exit()
	XDEF	l_dcal		; used by calculated calls = "call (hl)"

	XDEF	_vfprintf	; vprintf is internal to this file so we
				;  only ever include one of the set of
				;  routines

	XDEF	exitsp		; Exit variables
	XDEF	exitcount	;

       	XDEF	heaplast	;Near malloc heap variables
	XDEF	heapblocks

	XDEF	__sgoioblk	; For stdin, stdout, stder

	XDEF	base_graphics	; Graphics stuff
	XDEF	coords		;

	XDEF	cpygraph	; TI calc specific stuff
	XDEF	tidi		;
	XDEF	tiei		;

;-------------------------
; Begin of (shell) headers
;-------------------------
	LSTOFF			; Don't list these (huge) files
	INCLUDE "#Ti83.def"	; ROM / RAM adresses on Ti83
	INCLUDE	"zcc_opt.def"	; Receive all compiler-defines
	LSTON			; List again

;----------------------------------
; 2-Venus and 8-Venus Explorer (VE)
;----------------------------------
IF (startup=2) | (startup=8)
	DEFINE Venus
	DEFINE NOT_DEFAULT_SHELL	; else we would use Ion
	org	$932C
	defm	"ç9_[?"		; send(9prgm0 (where 0 is theta)
  IF (startup=2)			; 2-Venus
	defb	$0,$1,$1	; No description nor icon
  ELSE				; 8-Venus Explorer
 	DEFINE V_Explorer
	defb	$1
	defb	enddesc-description+1	; lengthOfDescription+1
description:
	DEFINE NEED_name	; The next time we'll include zcc_opt.def
				;  it will have the programs namestring.
				; Usage in C file:
				; #pragma string name xxxx
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
    IF !DEFINED_NEED_name
  	; If no namestring provided, display full compiler ident
	defm	"Z88DK Small C+ Program"
    ENDIF
enddesc:
	defb	endicon-icon+1	; heightOfIcon+1
icon:
	DEFINE NEED_icon
	INCLUDE	"zcc_opt.def"	; Get icon from zcc_opt.def
	UNDEFINE NEED_icon
    IF !DEFINED_NEED_icon
	defb	@00000000	; Icon (max. heightOfIcon = 7 bytes)
	defb	@00110010	; C with a small '+'
	defb	@01000111
	defb	@01000010
	defb	@01000000
	defb	@00110000
	defb	@00000000
    ENDIF
endicon:
externals:
  ENDIF
  IF DEFINED_GRAYlib
	defb	$1		; numberOfExternals+1 (maximum = 11d)
  ELSE
 	; No graylib, so we use FastCopy
 	defc	vnFastCopy = $FE6F
	defb	$2		; numberOfExternals+1 (maximum = 11d)
	defb	$5		; We use the FastCopy-lib
	defm	"~FCPY"		;
	defb	$ff		;
  ENDIF
ENDIF

;------
; 3-ZES
;------
IF (startup=3)
	DEFINE ZES
	DEFINE NOT_DEFAULT_SHELL
	org	$931E
	defm	"ç9_ZES"	; Send(9prgmZES
	defb	$3F,$D5,$3F	; :Return
ENDIF

;--------
; 4-Anova
;--------
IF (startup=4)
	DEFINE Anova
	DEFINE NOT_DEFAULT_SHELL
	org	Entry
	xor	a		; One byte instruction, meaningless
	jr	start		; Relative jump
	defw	0		; pointer to libs, 0 if no libs used
	defw	description	; pointer to a description
	defw	icon		; pointer to an 8x5 icon
description:
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0
icon:
	DEFINE NEED_icon
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_icon
 IF !DEFINED_NEED_icon
	defb	@00110010	; icon (5 bytes, Anova icon)
	defb	@01000111	; C with a small '+'
	defb	@01000010
	defb	@01000000	; Bigger icons don't give problems
	defb	@00110000	; They are only truncated to 5 bytes
 ENDIF
ENDIF

;-------------------------------
; 5,6 - Ti-Explorer, AShell, SOS
;-------------------------------
IF (startup=5) | (startup=6)
	DEFINE Ti_Explorer
	DEFINE NOT_DEFAULT_SHELL
	org	Entry
	nop			; makes it compatible with AShell
	jr	start
	defw	0		; pointer to libs, 0 if no libs used
	defw	description	; pointer to a description
	defw	icon		; pointer to an 8x8 icon.description
description:
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0
icon:
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
	defb	@00000000	; Bigger icons don't give problems
	defb	@00000000	; They are only truncated to 8 bytes
 ENDIF
ENDIF

;---------
; 7 -  SOS
;---------
IF (startup=7)
	DEFINE SOS
	DEFINE NOT_DEFAULT_SHELL
	org	Entry
	ccf			; Makes program invisible to AShell
	jr	start
	defw	0		; pointer to libs, 0 if no libs used
	defw	description	; pointer to a description
description:
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0
ENDIF

;---------------------------
; 9-Ion, ZASMLOAD compatible
;---------------------------
IF (startup=9)
	DEFINE ZASMLOAD
	DEFINE NOT_DEFAULT_SHELL
	org	Entry
	xor	a		; We don't use the Ionlibs
	jr	nc,start 	; Ion identifier
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0
ENDIF

;----------------------------------------------------------
; 10-No shell, send(9 or ZASMLOAD version (NOT recommended)
;----------------------------------------------------------
;
; for send(9 version, create .83p file with bin2var2.exe
; for ZASMLOAD version, create .83p file with bin2var.exe
IF (startup=10)
	DEFINE ZASMLOAD
	DEFINE NOT_DEFAULT_SHELL
	org	Entry
ENDIF

;----------------
; 1-Ion (default)
;----------------
IF !NOT_DEFAULT_SHELL
	DEFINE Ion
	org	Entry
 IF DEFINED_GRAYlib
	xor	a		; We don't use the Ionlibs (doesn't matter)
 ELSE
	ret			; We use the Ionlibs (doesn't matter)
 ENDIF
	jr	nc,start 	; Ion identifier
description:
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0
ENDIF


;-------------------------------------
; End of header, begin of startup part
;-------------------------------------
start:
IF ZASMLOAD
	call	_runindicoff	; stop anoing run-indicator
ENDIF
	ld	hl,0		; Store current StackPointer
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

	LIB	fputc_cons
	ld	hl,12
	push	hl
	call	fputc_cons
	pop	hl

IF ZASMLOAD
 IF NONANSI
	call	_CLRTXTSHD	; Clear textbuffer
	call	_homeup		; Set cursor to (0,0)
 ENDIF
	call	_clrScrnFull	; Clear plotSScreen and LCD
ENDIF

IF DEFINED_GRAYlib
	INCLUDE	"#gray83.asm"
ELSE
	INCLUDE "#intwrap83.asm"
ENDIF

	im	2
	call	_main
cleanup:			; exit() jumps to this point
start1:	ld	sp,0		; writeback
	ld	iy,_IY_TABLE	; Restore flag-pointer
IF !(Ion | SOS | Ti_Explorer | V_Explorer | Anova)
 IF NONANSI
	call	_CLRTXTSHD	; Clear textbuffer
	call	_homeup		; Set cursor to (0,0)
 ENDIF
	call	_clrScrnFull	; Clear plotSScreen and LCD
	res	oninterrupt,(iy+onflags) ; Reset [On]-flag (stops "ERR:Break")
ENDIF
	im	1
tiei:	ei
IF DEFINED_GRAYlib
cpygraph:
ENDIF
tidi:	ret

;----------------------------------------
; End of startup part, routines following
;----------------------------------------
defc l_dcal = $52E8		; jp (hl)


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
        LIB     vfprintf_fp
        jp      vfprintf_fp
ELSE
        IF DEFINED_complexstdio
                LIB     vfprintf_comp
                jp      vfprintf_comp
        ELSE
                IF DEFINED_ministdio
                        LIB     vfprintf_mini
                        jp      vfprintf_mini
                ENDIF
        ENDIF
ENDIF


;Seed for integer rand() routines
IF !DEFINED_HAVESEED
                XDEF    _std_seed        ;Integer rand() seed
_std_seed:      defw    0       ; Seed for integer rand() routines
ENDIF

;Atexit routine
exitsp:		defw	0
exitcount:	defb	0

; Heap stuff
heaplast:	defw	0
heapblocks:	defw	0

; mem stuff
base_graphics:	defw	plotSScreen
coords:		defw	0

IF !DEFINED_GRAYlib
 IF Ion
 	DEFINE Do_Not_Include_FastCopy
	defc cpygraph = $9157+80+15	; ionFastCopy call
 ENDIF

 IF Venus
 	DEFINE Do_Not_Include_FastCopy
	defc cpygraph = vnFastCopy
 ENDIF
 
 IF !Do_Not_Include_FastCopy
cpygraph:
;(ion)FastCopy from Joe Wingbermuehle
	di
	ld	a,$80				; 7
	out	($10),a				; 11
	ld	hl,plotSScreen-12-(-(12*64)+1)		; 10
	ld	a,$20				; 7
	ld	c,a				; 4
	inc	hl				; 6 waste
	dec	hl				; 6 waste
fastCopyAgain:
	ld	b,64				; 7
	inc	c				; 4
	ld	de,-(12*64)+1			; 10
	out	($10),a				; 11
	add	hl,de				; 11
	ld	de,10				; 10
fastCopyLoop:
	add	hl,de				; 11
	inc	hl				; 6 waste
	inc	hl				; 6 waste
	inc	de				; 6
	ld	a,(hl)				; 7
	out	($11),a				; 11
	dec	de				; 6
	djnz	fastCopyLoop			; 13/8
	ld	a,c				; 4
	cp	$2B+1				; 7
	jr	nz,fastCopyAgain		; 10/1
	ret					; 10
 ENDIF
ENDIF

IF NEED_floatpack
	INCLUDE		"#float.asm"
;seed for random number generator - not used yet..
fp_seed:	defb	$80,$80,0,0,0,0
Floating point registers...
extra:		defs	6
fa:		defs	6
fasign:		defb	0
ENDIF
