;       Enterprise 64/128 C stub
;
;       Stefano Bodrato - 2011
;
;	$Id: enterprise_crt0.asm,v 1.2 2011-02-27 12:01:43 stefano Exp $
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

		XDEF	__fcb		; file control block

; Enterprise 64/128 specific stuff
		XDEF	warmreset
		XDEF	setEXOSVariables
		

IF      !myzorg
		defc    myzorg  = 100h
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

; Inspired by the DizzyLord loader by ORKSOFT
        di
        ld    a, 004h
        out   (0bfh), a
        ld    sp, 03F00h
        ld    a, 0ffh
        out   (0b2h), a

        ld    c, 060h
        rst   30h
        defb  0

        ld    hl, __VideoVariables
        call  setEXOSVariables
        halt
        halt

        ld    a, 66h
        ld    de, __videoDeviceName
        rst   30h
        defb  1

        ld    a, 69h
        ld    de, __keyboardDeviceName
        rst   30h
        defb  1

;        ld    a, 66h
;        ld    b, 4                      ; @@FONT
;        rst   30h
;        defb  11

        ld    a, 66h
        ld    bc, 00101h                ; @@DISP, from first line
        ld    de, 01901h                ; to line 25, at screen line 1
        rst   30h
        defb  11						; set 40x35 characters window

        ld    de, __scrinitBegin
        ld    bc, __scrinitEnd - __scrinitBegin

		ld      a,66h	; output channel (video)
		rst     30h		; EXOS
		defb    8		; write block


;        ld      hl,0
;        add     hl,sp
;        ld      (start1+1),hl
        ld      (start1+1),sp
;        ld      hl,-64
;        add     hl,sp
;        ld      sp,hl
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
;jr cleanup
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
;        ld      sp,0
warmreset:
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


setEXOSVariables:
_l1:    ld    b, 1
        ld    c, (hl)
        inc   c
        dec   c
        ret   z
        inc   hl
        ld    d, (hl)
        inc   hl
        rst   30h
        defb  16
        jr    _l1
daveReset:
        push  bc
        xor   a
        ld    bc, 010afh
_l2:    out   (c), a
        dec   c
        djnz  _l2
        pop   bc
        ret 

__videoDeviceName:
        defb  6
        defm  "VIDEO:"

__keyboardDeviceName:
        defb  9
        defm  "KEYBOARD:"

__videoVariables:
       defb  22, 0                      ; MODE_VID
        defb  23, 2                     ; COLR_VID
        defb  24, 40                    ; X_SIZ_VID
        defb  25, 25                    ; Y_SIZ_VID
        ;defb  27, 0                    ; BORD_VID
        defb  0

__scrinitBegin:
        ; SET COLOR 7, 2
;        defb  01bh, 'c', 007h, 002h
        ; set character
;        defb  01bh, 'K', 080h
;        defb  001h, 003h, 006h, 00ch, 018h, 030h, 060h, 0c0h, 080h
        ; SET INK 5
;        defb  01bh, 'I', 005h
        ; set cursor position to 5,6
;        defb  01bh, '=', 025h, 026h
        defm  "Dizzy Lord\r\n"
__scrinitEnd:
