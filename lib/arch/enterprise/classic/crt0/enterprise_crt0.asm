;
;       Enterprise 64/128 C stub
;
;       Stefano Bodrato - 2011
;
;
;	$Id: enterprise_crt0.asm,v 1.24 2016-07-15 21:03:25 dom Exp $
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

	        defc    crt0 = 1
                INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main

        PUBLIC    cleanup
        PUBLIC    l_dcal


        PUBLIC    exitsp
        PUBLIC    exitcount

       	PUBLIC	heaplast	; Near malloc heap variables
        PUBLIC	heapblocks

        PUBLIC    __sgoioblk

; Enterprise 64/128 specific stuff
		PUBLIC    warmreset
		PUBLIC    set_exos_multi_variables
		PUBLIC    _DEV_VIDEO
		PUBLIC    _DEV_KEYBOARD
		PUBLIC    _DEV_NET
		PUBLIC    _DEV_EDITOR
		PUBLIC    _DEV_SERIAL
		PUBLIC    _DEV_TAPE
		PUBLIC    _DEV_PRINTER
		PUBLIC    _DEV_SOUND

		PUBLIC    _esccmd
		PUBLIC    _esccmd_cmd
		PUBLIC    _esccmd_x
		PUBLIC    _esccmd_y
		PUBLIC    _esccmd_p1
		PUBLIC    _esccmd_p2
		PUBLIC    _esccmd_p3
		PUBLIC    _esccmd_p4
		PUBLIC    _esccmd_p5
		PUBLIC    _esccmd_p6
		PUBLIC    _esccmd_p7
		PUBLIC    _esccmd_p8
		PUBLIC    _esccmd_p9
		PUBLIC    _esccmd_env
		PUBLIC    _esccmd_p
		PUBLIC    _esccmd_vl
		PUBLIC    _esccmd_vr
		PUBLIC    _esccmd_sty
		PUBLIC    _esccmd_ch
		PUBLIC    _esccmd_d
		PUBLIC    _esccmd_f
		PUBLIC    _esccmd_en
		PUBLIC    _esccmd_ep
		PUBLIC    _esccmd_er
		PUBLIC    _esccmd_phase
		PUBLIC    _esccmd_cp
		PUBLIC    _esccmd_cl
		PUBLIC    _esccmd_cr
		PUBLIC    _esccmd_pd


IF      !DEFINED_CRT_ORG_CODE
		defc    CRT_ORG_CODE  = 100h
ENDIF
		org     CRT_ORG_CODE


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

	call	crt0_init_bss

        ld      hl,0
        add     hl,sp
        ld      (start1+1),sp
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

        call    _main
	
cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
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


__VideoVariables:
        defb  22, 0                     ; MODE_VID	- hw text mode
        defb  23, 0                     ; COLR_VID	- mono
        defb  24, 40                    ; X_SIZ_VID
        defb  25, 25                    ; Y_SIZ_VID
        defb  0

         defm  "Small C+ Enterprise"
end:	 defb	0


        INCLUDE "crt0_runtime_selection.asm"

	INCLUDE	"crt0_section.asm"


