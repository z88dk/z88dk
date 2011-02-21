;       Enterprise 64/128 C stub
;
;       Stefano Bodrato - 2011
;
;	$Id: enterprise_crt0.asm,v 1.1 2011-02-21 21:01:57 stefano Exp $
;

; 	There are a couple of #pragma commands which affect
;	this file:
;
;	#pragma no-streams      - No stdio disc files
;	#pragma no-fileio       - No fileio at all
;	#pragma no-protectmsdos - strip the MS-DOS protection header
;
;	These can cut down the size of the resultant executable

                MODULE  enterprise_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

                INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

	XREF    _main

        XDEF    cleanup
        XDEF    l_dcal

        XDEF    _std_seed

	XDEF	snd_tick	; Sound variable

	XDEF	_vfprintf

        XDEF    exitsp
        XDEF    exitcount

       	XDEF	heaplast	; Near malloc heap variables
	XDEF	heapblocks

        XDEF    __sgoioblk

; Graphics stuff
	XDEF	pixelbyte	; Temp store for non-buffered mode
        XDEF    base_graphics   ; Graphical variables
        XDEF    coords          ; Current xy position


; Now, getting to the real stuff now!

		XDEF	__fcb		; file control block

IF      !myzorg
		defc    myzorg  = $100
ENDIF
		org     myzorg


;----------------------
; Execution starts here
;----------------------
start:

IF (!DEFINED_startup | (startup=1))
IF !DEFINED_noprotectmsdos
	; This protection takes little less than 50 bytes
	defb	$eb,$04		;MS DOS protection... JMPS to MS-DOS message if Intel
	ex	de,hl
	jp	begin		;First decent instruction for Z80, it survived up to here !
	defb	$b4,$09		;DOS protection... MOV AH,9 (Err msg for MS-DOS)
	defb	$ba
	defw	dosmessage	;DOS protection... MOV DX,OFFSET dosmessage
	defb	$cd,$21		;DOS protection... INT 21h.
	defb	$cd,$20		;DOS protection... INT 20h.

dosmessage:
	defm	"This program is for the Enterprise computer."
	defb	13,10,'$'

begin:
ENDIF
ENDIF

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

        call    _main
	
cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
ENDIF
ENDIF

start1:
        ld      sp,0
; _warmreset:
        ld      sp, 0100h
        ld      a, 0ffh
        out     (0b2h), a
        ld      c, 60h
        rst		30h
        defb	0
        ld      de, _basiccmd
        rst		30h
        defb	26
        ld      a, 01h
        out     (0b3h), a
        ld      a, 6
        jp      0c00dh

_basiccmd:
        defb    5
        defm    "BASIC"


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


; ---------------
; Misc Variables
; ---------------
defltdsk:       defb    0	; Default disc
base_graphics:  defw    0	; Location of current screen buffer
coords:         defw    0       ; Current graphics xy coordinates
pixelbyte:      defb	0


IF DEFINED_NEED1bitsound
snd_tick:	defb	0	; Sound variable
ENDIF

;Seed for integer rand() routines
IF !DEFINED_HAVESEED
		XDEF    _std_seed        ;Integer rand() seed
_std_seed:       defw    0       ; Seed for integer rand() routines
ENDIF

IF !DEFINED_nofileio
__fcb:		defs	420,0	;file control block (10 files) (MAXFILE)
ENDIF

;Atexit routine

exitsp:
                defw    0
exitcount:
                defb    0

; Heap stuff

heaplast:	defw	0
heapblocks:	defw	0


; mem stuff

         defm  "Small C+ Enterprise"
end:	 defb	0

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

