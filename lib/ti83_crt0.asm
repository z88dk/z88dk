;       Stub for the TI 83 calculator
;
;       Stefano Bodrato	- Dec 2000
;                         Feb 2001 Added multiple shell support
;	Henk Poley	- Apr 2001 Fixed and add some things
;
;       $Id: ti83_crt0.asm,v 1.9 2001-05-11 07:58:59 stefano Exp $
;
; Startup =
;  Nothing - Ion
;   1 - Ion
;   2 - Venus
;   3 - ZES
;   4 - ANOVA
;   5 - Ti-Explorer
;   6 - Ashell
;   7 - SOS
;   8 - Venus Explorer
;   9 - 
;  10 - Plain TIOS executable
;
	MODULE  z88_crt0

; No matter what set up we have, main is always, always external to
; this file
	XREF    _main

; Some variables which are needed for both app and basic startup
	XDEF    cleanup
	XDEF    l_dcal

; Integer rnd seed
	XDEF    int_seed

; vprintf is internal to this file so we only ever include one of the set
; of routines
	XDEF	_vfprintf

; Exit variables
	XDEF    exitsp
	XDEF    exitcount

; For stdin, stdout, stder
	XDEF    __sgoioblk

; Graphics stuff
	XDEF	base_graphics
	XDEF	coords

; TI calc specific stuff
	XDEF	cpygraph
	XDEF	tidi
	XDEF	tiei

; Now, getting to the real stuff now!
	INCLUDE "zcc_opt.def"	; Receive all compiler-defines
	DEFINE NEED_name	; The next time we'll include zcc_opt.def
				;  it will have the programs namestring
				; #pragma string name xxxx

; 1-Ion (default)
IF !DEFINED_startup | (startup=1)
	org	$9327
	ret
	jr	nc,start 	; Ion identifier
	INCLUDE	"zcc_opt.def"	; Get namestring from zcc_opt.def
	UNDEFINE NEED_name
 IF DEFINED_NEED_name
	; If namestring is provided, add small compiler ident
	defm	" - Small C+"&0
 ELSE
	; If no namestring provided, display full compiler ident
	defm	"Z88DK Small C+ Program"&0
 ENDIF
ENDIF

; 2-Venus
IF (startup=2)
	org	$932C
	defm	"ç9_[?"		; send(9prgm0 (where 0 is theta)
	defb	$0,$1,$1
 IF DEFINED_GRAYlib
	; No externals, the graylib has it's own copyroutine.
	; Maybe we can use the graylib of Venus in the future.
	defb	$1		; numberOfExternals+1 (maximum = 11d)
 ELSE
 	; No graylib, so we use FastCopy
	defb	$2		; numberOfExternals+1 (maximum = 11d)
	defb	$5		; We use the FastCopy-lib
	defm	"~FCPY"		;
	defb	$ff		;
 ENDIF
ENDIF

; 8-Venus Explorer
IF (startup=8)
     	org	$932C
	defm	"ç9_[?"
	defb	$1
	defb	enddesc-description+1	; lengthOfDescription+1
.description
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF DEFINED_NEED_name
	defm	" - Small C+"
 ELSE
	defm	"Z88DK Small C+ Program"
 ENDIF
.enddesc
	defb	endicon-icon+1	; heightOfIcon+1
.icon
	DEFINE NEED_icon
	INCLUDE	"zcc_opt.def"	; Get icon from zcc_opt.def
	UNDEFINE NEED_icon
 IF !DEFINED_NEED_icon
	defb	@00000000	; Icon (max. heightOfIcon = 7 bytes)
	defb	@00110010	; C with a small '+'
	defb	@01000111
	defb	@01000010	; Don't know if too large sprite
	defb	@01000000	;  will brake anythink
	defb	@00110000
	defb	@00000000
 ENDIF
.endicon
 IF DEFINED_GRAYlib
	defb	$1
 ELSE
	defb	$2
	defb	$5
	defm	"~FCPY"
	defb	$ff
 ENDIF
ENDIF

; 3-ZES
IF (startup=3)
	org	$931E
	defm	"ç9_ZES"	; Send(9prgmZES                                                                         
	defb	$3F,$D5,$3F	; :Return
ENDIF

; 4-ANOVA
IF (startup=4)
	org	$9327
	xor	a		; One byte instruction, meaningless
	jr	start		; Relative jump
	defw	0		; pointer to libs, 0000 if no libs used
	defw	description	; pointer to a description
	defw	icon		; pointer to an 8x5 icon
.description
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF DEFINED_NEED_name
	defm	" - Small C+"&0
 ELSE
	defm	"Z88DK Small C+ Program"&0
 ENDIF
.icon
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

; 5,6,7 - Ti-Explorer, Ashell, SOS
IF (startup=5) | (startup=6) | (startup=7)
	org	$9327
	nop
	jr start
	defw 0
	defw description
	defw icon
.description
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF DEFINED_NEED_name
	defm	" - Small C+"&0
 ELSE
	defm	"Z88DK Small C+ Program"&0
 ENDIF
.icon
	DEFINE NEED_icon
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_icon
 IF !DEFINED_NEED_icon
	defb	@00000000
	defb	@00110010
	defb	@01000111
	defb	@01000010
	defb	@01000000
	defb	@00110000
	defb	@00000000
	defb	@00000000
	;defb	255		; ??Not needed??
 ENDIF
ENDIF

; 10-No shell, send(9 or ZASMLOAD version
; (NOT recommended)
;
; for send(9 version, create .83p file with bin2var2.exe
; for ZASMLOAD version, create .83p file with bin2var.exe
IF (startup=10)
	org	$9327
ENDIF

.start
        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
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

IF DEFINED_GRAYlib
	INCLUDE	"#graylib83.asm"
ENDIF

	call	tidi
        call    _main
	call	tiei
	
.cleanup
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
ENDIF
ENDIF

.start1
	ld      sp,0
IF DEFINED_GRAYlib
.cpygraph			; little opt :)
ENDIF
	ret
;----------------------------------------------------
; End of header and startup part,  routines following
;----------------------------------------------------

.l_dcal
	jp      (hl)

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
.iysave defw	0


; Now, define some values for stdin, stdout, stderr

.__sgoioblk
IF DEFINED_ANSIstdio
	INCLUDE	"#stdio_fp.asm"
ELSE
        defw    -11,-12,-10
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
.base_graphics	defw	$8E29	;TI83
.coords		defw	0

IF !DEFINED_GRAYlib
.cpygraph
		;jp	$4B9C	; TIOS graphcopy (slow)

; 1-ION SHELL (default)
IF !DEFINED_startup | (startup=1)
	jp	$9157+80+15	; ION FastCopy call
ELSE

; 2-Venus or 8-Venus Explorer
IF (startup=2) | (startup = 8)
	jp	$FE6F		; vnFastCopy routine
ELSE
; Most other shells don't provide a fastcopy code,
; so here it is !
	ld	a,$80		; 7
	out	($10),a		; 11
	ld	hl,$8E29-12-(-(12*64)+1)	; 10
	ld	a,$20		; 7
	ld	c,a		; 4		; 43
  .fastCopyAgain
	ld	b,64		; 7
	inc	c		; 4
	ld	de,-(12*64)+1	; 10
	out	($10),a		; 11
	add	hl,de		; 11
	ld	de,11		; 10
  .fastCopyLoop
	add	hl,de		; 11
	inc	hl		; 6
	ret	c		; 5	; do nothing instruction (was nop (4 clocks))
	ld	a,(hl)		; 7
	out	($11),a		; 11
	djnz	fastCopyLoop	; 13/8	; 3392
	ld	a,c		; 4
	cp	$2B+1		; 7
	jr	nz,fastCopyAgain; 12/7	; 52	; 41773 (used to be 41136)
	ret			; 11	; 18
	; 41773 clocks total
	; 37 bytes total
ENDIF
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
	INCLUDE		"#float.asm"
;seed for random number generator - not used yet..
.fp_seed	defb	$80,$80,0,0,0,0
;Floating point registers...
.extra		defs	6
.fa		defs	6
.fasign		defb	0
ENDIF
