;	Stub for the TI 86 calculator
;
;	Stefano Bodrato - Dec 2000
;
;	$Id: ti86_crt0.asm,v 1.34 2016-07-11 05:58:34 stefano Exp $
;
; startup =
;   n - Primary shell(s); compatible shell(s)
;       (Primary shell merely means it's the smallest implementation
;        for that shell, that uses full capabilities of the shell)
;
;   1 - LASM (default)
;   2 - ASE, Rascal, emanon, etc.
;   3 - zap2000
;   4 - emanon
;   5 - Embedded LargeLd - !!!EXPERIMENTAL!!!
;  10 - asm() executable
;
;-----------------------------------------------------
; Some general PUBLICs and EXTERNs needed by the assembler
;-----------------------------------------------------

	MODULE  Ti86_crt0

	EXTERN	_main		; No matter what set up we have, main is
				;  always, always external to this file.

	PUBLIC	cleanup		; used by exit()
	PUBLIC	l_dcal		; used by calculated calls = "call (hl)"

	PUBLIC	cpygraph	; TI calc specific stuff
	PUBLIC	tidi		;
	PUBLIC	tiei		;

;-------------------------
; Begin of (shell) headers
;-------------------------

	INCLUDE "Ti86.def"	; ROM / RAM adresses on Ti86
        defc    crt0 = 1
	INCLUDE	"zcc_opt.def"	; Receive all compiler-defines

	defc	CONSOLE_ROWS = 8
	defc    CONSOLE_COLUMNS = 21
        defc    TAR__clib_exit_stack_size = 3
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 6000000
        INCLUDE "crt/classic/crt_rules.inc"

;-----------------------------
;2 - ASE, Rascal, emanon, etc.
;-----------------------------
IF (startup=2)
	DEFINE ASE
	DEFINE NOT_DEFAULT_SHELL
	org	_asm_exec_ram-2	;TI 86 standard asm() entry point.
       	defb	$8e, $28
	nop			;identifier of table
	jp	start
	defw	$0000		;version number of table
	defw	description	;pointer to the description
description:
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0		; Termination zero
ENDIF

;-----------
;3 - zap2000
;-----------
IF (startup=3)
	DEFINE ZAP2000
	DEFINE NOT_DEFAULT_SHELL
	org	_asm_exec_ram-2
       	defb	$8e, $28
	nop
	jp	start
	defw 	description
	defw	icon
description:
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0		; Termination zero
icon:
	DEFINE NEED_icon
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_icon
 IF !DEFINED_NEED_icon
	defb	@00000000	; 8x8 icon
	defb	@00110010	; C with a small '+'
	defb	@01000111
	defb	@01000010
	defb	@01000000
	defb	@00110000
	defb	@00000000
	defb	@00000000
 ENDIF
ENDIF

;----------
;4 - emanon
;----------
IF (startup=4)
	DEFINE EMANON
	DEFINE NOT_DEFAULT_SHELL
	org	_asm_exec_ram-2	;TI 86 standard asm() entry point.
       	defb	$8e, $28
	nop			;identifier of table
	jp	start
	defw	$0001		;version number of table
	defw	description	;pointer to description
	defw	icon		;pointer to icon
description:
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
	defb	$0		; Termination zero
icon:
	DEFINE NEED_icon
	INCLUDE	"zcc_opt.def"	; Get icon from zcc_opt.def
	UNDEFINE NEED_icon
 IF !DEFINED_NEED_icon
	defb	@00000000	; 7x7 icon
	defb	@00110010
	defb	@01000111
	defb	@01000010
	defb	@01000000
	defb	@00110000
	defb	@00000000
 ENDIF
ENDIF

;----------------------
; 10 - asm() executable
;----------------------
IF (startup=10)
	DEFINE STDASM
	DEFINE NOT_DEFAULT_SHELL
        org     _asm_exec_ram - 2
       	defb	$8e, $28
ENDIF

;--------------------------------------------------
; 5 - Embedded LargeLd - !!!EXPERIMENTAL!!!
; - The calculator needs to be reset (memory clean)
; - This has to be the first program in memory
;--------------------------------------------------
IF (startup=5)
	DEFINE NOT_DEFAULT_SHELL
        org     $8000+14
       	ld	a,$42	; (RAM_PAGE_1)
	out	(6),a
	jp	start
ENDIF

;------------------
;1 - LASM (default)
;------------------
IF !NOT_DEFAULT_SHELL
	DEFINE LASM
	org	$801D	; "Large asm block". To be loaded with "LASM"
	; You need LASM 0.8 Beta by Patrick Wong for this (www.ticalc.org)
	; - First wipe TI86 RAM (InstLASM is simply a memory cleaner)
	; - Load LargeLd
	; - Load your compiled and converted .86p code
	; - run asm(LargeLd
	; It will run your program. Loading order is important.
	
	defb	$8e, $28
	;org	$801F	; Start from here if you want to use PRGM86
	ret
	nop		;Identifies the table
	jp	start
	defw	1	;Version # of Table. Release 0 has no icon (Title only)

	defw	description	;Absolute pointer to program description
	defw	icon		;foo pointer to icon

description:
	DEFINE NEED_name
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_name
 IF !DEFINED_NEED_name
	defm	"Z88DK Small C+ Program"
 ENDIF
icon:
	defb	$0		; Termination zero
ENDIF


;-------------------------------------
; End of header, begin of startup part
;-------------------------------------
start:
IF STDASM | LASM		; asm( executable
	call	_runindicoff	; stop anoing run-indicator
ENDIF

	ld	hl,0
	add	hl,sp
	ld	(__restore_sp_onexit+1),hl
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
        call    crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF


;  IF NONANSI
	call	_homeup		; Set text cursor at (0,0)
	ld	a,8		; Set _winBtm back to 8, so we
	ld	(_winBtm),a	;  can print on the last line
;  ELSE

	EXTERN	fputc_cons
	ld	hl,12
	push	hl
	call	fputc_cons
	pop	hl

IF DEFINED_GRAYlib
	INCLUDE	"target/ti86/classic/gray86.asm"
ENDIF

	;im	2
	call	tidi
	call	_flushallmenus
	call	_main
cleanup:			; exit() jumps to this point
__restore_sp_onexit:
	ld	sp,0
IF DEFINED_GRAYlib
       	ld	a,$3C		; Make sure video mem is active
	out	(0),a
ENDIF

tiei:
	ld	IY,_Flags
	exx
	ld	hl,(hl1save)
	ld	bc,(bc1save)
	ld	de,(de1save)
	exx
IF DEFINED_GRAYlib
	im	1
ELSE
	ei
ENDIF
	ret

tidi:
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
	ret



cpygraph:
	ret

;----------------------------------------
; End of startup part, routines following
;----------------------------------------
l_dcal:
	jp	(hl)

		defc ansipixels = 128
		IF !DEFINED_ansicolumns
			 defc DEFINED_ansicolumns = 1
			 defc ansicolumns = 32
		ENDIF

        INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE "crt/classic/crt_section.asm"

	SECTION bss_crt
hl1save: defw	0
de1save: defw	0
bc1save: defw	0
        SECTION code_crt_init
        ld      hl,$FC00
        ld      (base_graphics),hl


