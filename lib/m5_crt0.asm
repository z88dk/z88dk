;       CRT0 for the SORD M5
;
;       Stefano Bodrato Maj. 2000
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: m5_crt0.asm,v 1.11 2010-07-13 06:16:53 stefano Exp $
;


        MODULE  m5_crt0


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

        XDEF    _std_seed

; vprintf is internal to this file so we only ever include one of the set
; of routines

        XDEF	_vfprintf

;Exit variables

        XDEF    exitsp
        XDEF    exitcount

       	XDEF	heaplast	;Near malloc heap variables
        XDEF	heapblocks

;For stdin, stdout, stder

        XDEF    __sgoioblk

; Graphics stuff
        XDEF	pixelbyte	; Temp store for non-buffered mode
        XDEF    base_graphics   ; Graphical variables
        XDEF    coords          ; Current xy position

; MSX platform specific stuff
;
        XDEF    msxbios

		XDEF	RG0SAV		;keeping track of VDP register values
		XDEF	RG1SAV
		XDEF	RG2SAV
		XDEF	RG3SAV
		XDEF	RG4SAV
		XDEF	RG5SAV
		XDEF	RG6SAV
		XDEF	RG7SAV

; Now, getting to the real stuff now!

IF      !myzorg
		defc    myzorg  = $7300
ENDIF

        org     myzorg

start:
        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

        exx
        push	hl


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

        call    _main
        
cleanup:
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

	pop	bc
	exx
	pop	hl
	exx

start1:
	ld      sp,0
	ret


l_dcal:
	jp      (hl)

; Now, define some values for stdin, stdout, stderr

__sgoioblk:
IF DEFINED_ANSIstdio
	INCLUDE	"stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


; Now, which of the vfprintf routines do we need?


_vfprintf:
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

_std_seed:       defw    0

;Atexit routine

exitsp:
                defw    0
exitcount:
                defb    0

; Heap stuff

heaplast:	defw	0
heapblocks:	defw	0

; Graphics stuff

base_graphics:  defw    0	; Location of current screen buffer
coords:         defw    0       ; Current graphics xy coordinates
pixelbyte:	defb	0

RG0SAV:		defb	0	;keeping track of VDP register values
RG1SAV:		defb	0
RG2SAV:		defb	0
RG3SAV:		defb	0
RG4SAV:		defb	0
RG5SAV:		defb	0
RG6SAV:		defb	0
RG7SAV:		defb	0


; ---------------
; MSX specific stuff
; ---------------

; Safe BIOS call
msxbios:
	push	ix
	ret


    defm  "Small C+ SORD M5"
    defb	0

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
        INCLUDE         "float.asm"

;seed for random number generator - not used yet..
fp_seed:        defb    $80,$80,0,0,0,0
;Floating point registers...
extra:          defs    6
fa:             defs    6
fasign:         defb    0

ENDIF

