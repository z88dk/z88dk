;
;	Startup for Casio PV-1000
;
;	The font is located from address 00000H - 01BFFH
;	- 32 bytes per character - 224 characters max
;	We need some space for startup etc, so initial characters
;	aren't available


	module	pv1000_crt0 


;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code
	EXTERN	im1_vectors
	EXTERN	nmi_vectors
	EXTERN	asm_interrupt_handler

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)

	; 2 columns on left and 2 column on right are lost
	defc	CONSOLE_COLUMNS = 28
	defc	CONSOLE_ROWS = 24

	; 256 bytes at bb00
	; 1024 bytes at bc00 - shared with RAM character generator
	defc	CRT_ORG_BSS = 0xbb00	
	defc	CRT_ORG_CODE = 0x0000

        defc    TAR__fputc_cons_generic = 1
        defc    TAR__no_ansifont = 1
        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = 0xbfff
	defc	CRT_KEY_DEL = 127
	defc	__CPU_CLOCK = 3579000
        INCLUDE "crt/classic/crt_rules.inc"

	org	  CRT_ORG_CODE

if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif

	jp	program

	defs	$0008-ASMPC
if (ASMPC<>$0008)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart08

	defs	$0010-ASMPC
if (ASMPC<>$0010)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart10

	defs	$0018-ASMPC
if (ASMPC<>$0018)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart18

	defs	$0020-ASMPC
if (ASMPC<>$0020)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart20

    defs	$0028-ASMPC
if (ASMPC<>$0028)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart28

	defs	$0030-ASMPC
if (ASMPC<>$0030)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	restart30

	defs	$0038-ASMPC
if (ASMPC<>$0038)
        defs    CODE_ALIGNMENT_ERROR
endif
; IM1 interrupt routine
	push	af
	push	hl
	in	a,($bf)
	ld	hl,im1_vectors
	call	asm_interrupt_handler
	pop	hl
	pop	af
	ei
	reti


	defs	$0066 - ASMPC
if (ASMPC<>$0066)
        defs    CODE_ALIGNMENT_ERROR
endif
nmi:
	push	af
	push	hl
	ld	hl,nmi_vectors
	call	asm_interrupt_handler
	pop	hl
	pop	af
	retn

; Restart routines, nothing sorted yet
restart10:
restart08:
restart18:
restart20:
restart28:
restart30:
	ret

program:
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	(exitsp),sp
	im	1
    	ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
	call	_main
cleanup:
	di
	halt
	jp	cleanup


l_dcal: jp      (hl)            ;Used for function pointer calls

; Font location - this is far to generous - we should add in extra
; symbols
	defs	10 * 32-ASMPC
if (ASMPC<>(10 * 32))
        defs    CODE_ALIGNMENT_ERROR
endif

	; Lores graphics
	INCLUDE	"target/pv1000/classic/lores.asm"

	; Character map - TODO, redefining it
IF PV1000_CUSTOM_TILESET
	INCLUDE	"tileset.asm"
ELSE
	INCLUDE	"target/pv1000/classic/font.asm"
ENDIF




	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	defc	__crt_org_bss = CRT_ORG_BSS
        IF DEFINED_CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF
	INCLUDE	"crt/classic/crt_section.asm"
