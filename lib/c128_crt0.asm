;       Commodore 128 (Z80 mode) CRT0 stub
;
;       Stefano Bodrato - 22/08/2001
;
;	$Id: c128_crt0.asm,v 1.23 2016-06-02 22:24:57 dom Exp $
;


                MODULE  c128_crt0

;--------
; Include zcc_opt.def to find out some info
;--------
        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

; Only the ANSI terminal is available
	defc NEED_ansiterminal = 1

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


; Now, getting to the real stuff now!

IF      !myzorg
        defc    myzorg  = $3000
ENDIF
        org     myzorg


start:

	di
	
	;ld	bc,$d030
	;ld	a,1
	;out	(c),a	; high speed clock
	
	;ld	bc,$d018
	;ld	a,$45
	;out	(c),a	; 40 columns text at $2000
	
	ld	bc,$d018
	;ld	a,$17	; Standard display address ($400)..
	ld	a,$87	; Display addres at $2000...
	out	(c),a	; ...and alternate (upper+lower) char set

	ld	a,11		;dark grey
	ld	bc,$d020
	out	(c),a	;border
	inc	c
	out	(c),a	;& background

        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
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

	call	crt0_init_bss
        call    _main

	; Loop border color and wait for the RUNSTOP key
;brdloop:	ld	bc,$d020  ;border colour
;		in	a,(c)
;		inc	a
;		out	(c),a
;		ld	bc,$dc01  ;key in
;		in	a,(c)
;		??? inc bc ?
;		in	b,(c)
;		cp	b
;		jr	z,brdloop ;no key pressed
		
cleanup:
;
;       Deallocate memory which has been allocated here!
;

IF !DEFINED_nostreams
	EXTERN	closeall
	call	closeall
ENDIF

	;ld	bc,$d030
	;xor	a
	;out	(c),a	; back to slow speed clock

start1:
        ld      sp,0
        jp	$FFE0

l_dcal:
        jp      (hl)


IF NEED_floatpack
        INCLUDE         "float.asm"
ENDIF

	defm  "Small C+ C128"
	defb  0

        INCLUDE "crt0_runtime_selection.asm"

	defc	coords_space = 4
	INCLUDE "crt0_section.asm"

	SECTION	code_crt_init
	ld	hl,$2000
	ld	(base_graphics),hl

	PUBLIC	_vdcDispMem
	defc	_vdcDispMem = base_graphics
