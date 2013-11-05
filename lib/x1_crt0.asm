;	CRT0 for the Sharp X1
;
;	Karl Von Dyson (for X1s.org)
;
;    $Id: x1_crt0.asm,v 1.1 2013-11-05 16:02:43 stefano Exp $
;

	MODULE x1_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        XREF    _main
        XREF    _x1_printf

        XDEF    cleanup 
        XDEF    l_dcal
        XDEF    _std_seed
        XDEF    _vfprintf

        XDEF    exitsp
        XDEF    exitcount

        XDEF    heaplast
        XDEF    heapblocks
        XDEF    __sgoioblk

; X1 stdio support variables
    XDEF    _x1_cursor_coords
	XDEF    _x1_keyboard_io

; X1 stdio support entry functions
	XDEF	_wait_sub_cpu

;--------
; Non-zero origins are currently causing nothing but problems.
;--------

        IF      !myzorg
                defc    myzorg  = 0
        ENDIF


        org     myzorg


;--------
; Execution starts here
;--------
start:
        ld      sp,$FDFF
        ld      (exitsp),sp
        
IF (!DEFINED_startup | (startup=1))
		im 1
		ei
ENDIF

IF (startup=2)
        ;call    _x1_init_interrupts
        
	di
	ld	hl,$FE00
	push hl
	LIB im2_Init
	call im2_Init
	pop hl
	
	LIB im2_EmptyISR
	ld hl,im2_EmptyISR
	ld b,128
isr_table_fill:
	ld ($FE00),hl
	inc hl
	inc hl
	djnz isr_table_fill
	ld	hl,_im2_kbd_isr
	ld ($FE52),hl
	
	im 2
	ei
	call _wait_sub_cpu
	ld bc, $1900
	ld a, $E4
	out (c), a
	call _wait_sub_cpu
	ld bc, $1900
	ld a, $52
	out (c), a

ENDIF

;IF !DEFINED_x1_no_clrscr
;	LIB _x1_cls
;	call _x1_cls
;ENDIF

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
        ld      hl,__sgoioblk+2
        ld      (hl),19 ;stdin
        ld      hl,__sgoioblk+6
        ld      (hl),21 ;stdout
        ld      hl,__sgoioblk+10
        ld      (hl),21 ;stderr
ENDIF
ENDIF


; INIT math identify platform
IF NEED_floatpack
        LIB     init_floatpack
        call    init_floatpack
ENDIF

        call    _main

cleanup:

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
        LIB     closeall
        call    closeall
ENDIF
ENDIF

	push    hl				; return code
        ld      sp,$FFFF
cleanup_exit:
        ret


IF (!DEFINED_startup | (startup=1))

        defs    56-cleanup_exit-1

if (ASMPC<>$0038)
        defs    CODE_ALIGNMENT_ERROR
endif

ENDIF

; -------------------------------------------
; Don't move the following block !
; It must be aligned when startup=1 !!

_im2_kbd_isr:
	push af
	push bc
	;push de
	push hl
	
	ld bc, $1A01
.iiki1	in a, (c)
	and $20
	jr nz, iiki1
	ld bc, $1900
	in a, (c)
	ld hl, _x1_keyboard_io+1
	ld (hl), a
	dec hl
	ld bc, $1A01
.iiki2	in a, (c)
	and $20
	jr nz, iiki2
	ld bc, $1900
	in a, (c)
	ld (hl), a

	pop hl
	;pop de
	pop bc
	pop af
	ei
	reti

; -------------------------------------------


l_dcal:
        jp      (hl)

; Now, define some values for stdin, stdout, stderr
__sgoioblk:
IF DEFINED_ANSIstdio
        INCLUDE "stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF

; Now, which of the vfprintf routines do we need?
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
		XDEF    _std_seed        ; Integer rand() seed
_std_seed:      defw    0                ; Seed for integer rand() routines
ENDIF

exitsp:    defw    0
exitcount: defb    0

; Heap stuff
heaplast:  defw    0
heapblocks:defw    0


; X1 stdio support variables
_x1_cursor_coords:
        defw    0
_x1_keyboard_io:
        defw    0


_wait_sub_cpu:
	ld bc, $1A01
.ii_w1	in a, (c)
	bit 6, a
	jp nz, ii_w1
	ret






IF NEED_floatpack
        INCLUDE         "float.asm"
;seed for random number generator - not used yet..
fp_seed:        defb    $80,$80,0,0,0,0
;Floating point registers...
extra:          defs    6
fa:             defs    6
fasign:         defb    0
ENDIF

