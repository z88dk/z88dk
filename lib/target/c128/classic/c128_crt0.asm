;       Commodore 128 (Z80 mode) CRT0 stub
;
;       Stefano Bodrato - 22/08/2001
;
;	$Id: c128_crt0.asm,v 1.28 2016/07/15 21:03:25 dom Exp $
;


                MODULE  c128_crt0

;--------
; Include zcc_opt.def to find out some info
;--------
        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

; Only the ANSI terminal is available
;	defc NEED_ansiterminal = 1  <-- specified elsewhere

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)

        defc    CONSOLE_COLUMNS = 40
        defc    CONSOLE_ROWS = 25

        IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = $5000	
        ENDIF

	defc	TAR__no_ansifont = 1
	defc	TAR__clib_exit_stack_size = 32
	defc	TAR__register_sp = -1
	defc __CPU_CLOCK = 2000000
	INCLUDE	"crt/classic/crt_rules.inc"
        org     CRT_ORG_CODE


start:

	; Write anything to the proper preconfiguration register to switch to BANK 0
	defb $8D	; STA ..
	defw $FF01
;ENDIF

	; Prepare the "springboard" for the z80
	defb $A9	; LDA ..
	defb 195	; ..opcode for JP (z80)
	defb $8D	; STA ..
	defw 65518
	
	defb $A9	; LDA ..
	defb z80start&$FF
	defb $8D	; STA ..
	defw 65519
	
	defb $A9	; LDA ..
	defb z80start/256
	defb $8D	; STA ..
	defw 65520
	
	; Prepare the "springboard" for the 6502
	defb $A9	; LDA ..
	defb 88		; ..opcode for CLI
	defb $8D	; STA ..
	defw 4352
	
	defb $A9	; LDA ..
	defb 96		; ..opcode for RTS
	defb $8D	; STA ..
	defw 4353
	
	defb $4C	; JMP
	defw 65488

z80start:
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
	out	(c),a	; ...and alternate (upper+lowercase) char set

;	ld	a,15		;light grey
	xor	a	; black
	ld	bc,$d020
	out	(c),a	;border
	inc	c
	out	(c),a	;& background

	ld hl,$FBFF
	ld sp,$FBFF
;        ld      hl,0
;        add     hl,sp
    ld      (__restore_sp_onexit+1),hl
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call	crt0_init_bss
    ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF

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
    call    crt0_exit


	;ld	bc,$d030
	;xor	a
	;out	(c),a	; back to slow speed clock

__restore_sp_onexit:
        ld  sp,0
        jp  $FFE0

l_dcal:
        jp  (hl)




	
; If we were given an address for the BSS then use it
IF DEFINED_CRT_ORG_BSS
	defc	__crt_org_bss = CRT_ORG_BSS
ENDIF


	INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE "crt/classic/crt_section.asm"

	SECTION	code_crt_init
	ld	hl,$2000
	ld	(base_graphics),hl

	PUBLIC	_vdcDispMem
	defc	_vdcDispMem = base_graphics
