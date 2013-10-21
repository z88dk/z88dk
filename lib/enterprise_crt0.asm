;
;       Enterprise 64/128 C stub
;
;       Stefano Bodrato - 2011
;
;
;	$Id: enterprise_crt0.asm,v 1.13 2013-10-21 14:23:44 stefano Exp $
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
        XDEF	bit_irqstatus	; current irq status when DI is necessary

        XDEF	_vfprintf

        XDEF    exitsp
        XDEF    exitcount

       	XDEF	heaplast	; Near malloc heap variables
        XDEF	heapblocks

        XDEF    __sgoioblk

; Enterprise 64/128 specific stuff
		XDEF    warmreset
		XDEF    set_exos_multi_variables
		XDEF    _DEV_VIDEO
		XDEF    _DEV_KEYBOARD
		XDEF    _DEV_NET
		XDEF    _DEV_EDITOR
		XDEF    _DEV_SERIAL
		XDEF    _DEV_TAPE
		XDEF    _DEV_PRINTER
		XDEF    _DEV_SOUND

		XDEF    _esccmd
		XDEF    _esccmd_cmd
		XDEF    _esccmd_x
		XDEF    _esccmd_y
		XDEF    _esccmd_p1
		XDEF    _esccmd_p2
		XDEF    _esccmd_p3
		XDEF    _esccmd_p4
		XDEF    _esccmd_p5
		XDEF    _esccmd_p6
		XDEF    _esccmd_p7
		XDEF    _esccmd_p8
		XDEF    _esccmd_p9
		XDEF    _esccmd_env
		XDEF    _esccmd_p
		XDEF    _esccmd_vl
		XDEF    _esccmd_vr
		XDEF    _esccmd_sty
		XDEF    _esccmd_ch
		XDEF    _esccmd_d
		XDEF    _esccmd_f
		XDEF    _esccmd_en
		XDEF    _esccmd_ep
		XDEF    _esccmd_er
		XDEF    _esccmd_phase
		XDEF    _esccmd_cp
		XDEF    _esccmd_cl
		XDEF    _esccmd_cr
		XDEF    _esccmd_pd


IF      !myzorg
		defc    myzorg  = 100h
ENDIF
		org     myzorg


;----------------------
; Execution starts here
;----------------------
start:
IF (startup=2)
IF !DEFINED_noprotectmsdos
	; This protection takes little less than 50 bytes
	defb	$eb,$04		;MS DOS protection... JMPS to MS-DOS message if Intel
	ex	de,hl
	jp	begin		;First decent instruction for Z80, if survived up to here !
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
        ;di
        ld    a, 004h
        out   (0bfh), a
        ld    sp, 07F00h
        ld    a, 0ffh
        out   (0b2h), a

        ld    c, 060h
        rst   30h
        defb  0

        ld    hl, __VideoVariables
        call  set_exos_multi_variables
        call  daveReset
        halt
        halt

        ld    a, 66h
        ld    de, _DEV_VIDEO
        rst   30h
        defb  1

        ld    a, 69h
        ld    de, _DEV_KEYBOARD
        rst   30h
        defb  1

;        ld    a, 66h
;        ld    b, 4                      ; @@FONT
;        rst   30h
;        defb  11

        ld    a, 66h
        ld    bc, $0101                ; @@DISP, from first line
        ld    de, $1901                ; to line 25, at screen line 1
        rst   30h
        defb  11						; set 40x25 characters window


        ld      hl,0
        add     hl,sp
;        ld      (start1+1),hl
        ld      (start1+1),sp
;        ld      hl,-64
;        add     hl,sp
;        ld      sp,hl
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

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

IF (!DEFINED_startup | (startup=1))
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
ENDIF

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


; ---------------
; Misc Variables
; ---------------

IF DEFINED_NEED1bitsound
snd_tick:       defb	0	; Sound variable
bit_irqstatus:	defw	0
ENDIF

;Seed for integer rand() routines
IF !DEFINED_HAVESEED
		XDEF    _std_seed        ;Integer rand() seed
_std_seed:       defw    0       ; Seed for integer rand() routines
ENDIF

;Atexit routine

exitsp:
                defw    0
exitcount:
                defb    0

; Heap stuff

heaplast:	defw	0
heapblocks:	defw	0

IF DEFINED_USING_amalloc
XREF ASMTAIL
XDEF _heap
; The heap pointer will be wiped at startup,
; but first its value (based on ASMTAIL)
; will be kept for sbrk() to setup the malloc area
_heap:
                defw ASMTAIL	; Location of the last program byte
                defw 0
ENDIF

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


set_exos_multi_variables:
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
        ret


daveReset:
        push  bc
        xor   a
        ld    bc, 010afh
_l2:    out   (c), a
        dec   c
        djnz  _l2
        pop   bc
        ret 


_DEV_VIDEO:
        defb  6
        defm  "VIDEO:"

_DEV_KEYBOARD:
        defb  9
        defm  "KEYBOARD:"

_DEV_EDITOR:
        defb  4
        defm  "EDITOR:"

_DEV_NET:
        defb  4
        defm  "NET:"

_DEV_SERIAL:
        defb  7
        defm  "SERIAL:"

_DEV_TAPE:
        defb  5
        defm  "TAPE:"

_DEV_PRINTER:
        defb  8
        defm  "PRINTER:"

_DEV_SOUND:
        defb  6
        defm  "SOUND:"

_esccmd:
        defb  27
_esccmd_cmd:
        defb  0
_esccmd_x:
_esccmd_p1:
_esccmd_env:
_esccmd_en:
        defb  0
_esccmd_p2:
_esccmd_p:
_esccmd_ep:
        defb  0
_esccmd_y:
_esccmd_p3:
_esccmd_er:
        defb  0
_esccmd_phase:
_esccmd_p4:
_esccmd_vl:
_esccmd_cp:
        defb  0
_esccmd_p5:
_esccmd_vr:
        defb  0
_esccmd_p6:
_esccmd_sty:
_esccmd_cl:
        defb  0
_esccmd_p7:
_esccmd_ch:
        defb  0
_esccmd_p8:
_esccmd_d:
_esccmd_cr:
        defb  0
_esccmd_p9:
_esccmd_pd:
        defb  0
_esccmd_f:
        defb  0


__videoVariables:
        defb  22, 0                     ; MODE_VID	- hw text mode
        defb  23, 0                     ; COLR_VID	- mono
        defb  24, 40                    ; X_SIZ_VID
        defb  25, 25                    ; Y_SIZ_VID
        defb  0
