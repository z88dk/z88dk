;       Stub for the TI 86 calculator
;
;       Stefano Bodrato - Dec 2000
;
;       $Id: ti86_crt0.asm,v 1.7 2001-05-11 07:58:59 stefano Exp $
;


                MODULE  z88_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

                INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this file

                XREF    _main

;
; Some variables which are needed for both app and basic startup
;

        XDEF    cleanup
        XDEF    l_dcal

; Integer rnd seed

        XDEF    int_seed

; vprintf is internal to this file so we only ever include one of the set
; of routines

	XDEF	_vfprintf

;Exit variables

        XDEF    exitsp
        XDEF    exitcount

;For stdin, stdout, stder

        XDEF    __sgoioblk

; Graphics stuff
	XDEF	base_graphics
	XDEF	coords

; TI calc specific stuff
	XDEF	cpygraph
	XDEF	tidi
	XDEF	tiei

; Now, getting to the real stuff now!


	; -startup=1 flag:
	; You need LASM 0.8 Beta by Patrick Wong for this (www.ticalc.org)
	; - First wipe TI86 RAM (InstLASM is simply a memory cleaner)
	; - Load LargeLd
	; - Load your compiled and converted .86p code
	; - run asm(LargeLd
	; It will run your program. Loading order is important.

IF !DEFINED_startup | (startup=1)
	org	$801F	; "Large asm block". To be loaded with "LASM"
	ret
	nop		;Identifies the table
	jp	start
ENDIF


	; TI 86 (Embedded LargeLd - EXPERIMENTAL)
	; - The calculator needs to be reset (memory clean)
	; - This has to be the first program in memory

IF (startup=2)
        org     $8000+14
       	ld	a,$42	; (RAM_PAGE_1)
	out	(6),a
	jp	start
ENDIF


	; TI 86 standard asm() entry point.

IF (startup=3)
        org     $D748
ENDIF


	; zap2000 format
IF (startup=4)
 	nop
 	jp	start
 	defw	title
 	defw	Icon
ENDIF


	; other shells

IF (startup=5)
	nop		;Identifies the table
	jp	start
	defw	1	;Version # of Table. Release 0 has no icon (Title only)
	defw	title	;Absolute pointer to program description
	defw	icon	;pointer to icon
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
	INCLUDE	"#graylib86.asm"
ENDIF

	call	$4A95	; Close menus
	
	call	tidi
        call    _main
        call	tiei
        
IF DEFINED_GRAYlib
       	ld	a,$3C				;make sure video mem is active
	out	(0),a
ENDIF
        
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

.cpygraph
        ret

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

.int_seed       defw    0

;Atexit routine

.exitsp
                defw    0
.exitcount
                defb    0

; Heap stuff

.heaplast	defw	0
.heapblocks	defw	0

; mem stuff

.base_graphics
		defw	$FC00	;TI86
.coords		defw	0


.title
	; If no namestring provided, display full compiler ident
	defm	"Z88DK Small C+ Program"&0
 
.icon
	defb	@00000000	; Icon (max. heightOfIcon = 7 bytes)
	defb	@00110010	; C with a small '+'
	defb	@01000111
	defb	@01000010
	defb	@01000000
	defb	@00110000
	defb	@00000000


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
        INCLUDE         "#float.asm"

;seed for random number generator - not used yet..
.fp_seed        defb    $80,$80,0,0,0,0
;Floating point registers...
.extra          defs    6
.fa             defs    6
.fasign         defb    0

ENDIF

