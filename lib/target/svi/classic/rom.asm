;
;	ROM Startup for SVI
;


	defc	CRT_ORG_BSS = 0x8000
	defc	CRT_ORG_CODE = 0x0000

        EXTERN  im1_vectors
        EXTERN  asm_interrupt_handler

        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = 0xffff

        INCLUDE "crt/classic/crt_rules.inc"

	org	  CRT_ORG_CODE

if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif
	di			;Signature is di, ld sp
	ld	sp,0xffff
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
	INCLUDE "crt/classic/tms9118/interrupt.asm"
	ei
	reti

	defs	$0066 - ASMPC
if (ASMPC<>$0066)
        defs    CODE_ALIGNMENT_ERROR
endif
nmi:
	; Should jump to pause
	retn

; Restart routines, nothing sorted yet
restart10:
restart08:
restart18:
restart20:
restart28:
restart30:
	ret

int_VBL:
        ld      hl,im1_vectors
        call    asm_interrupt_handler
        pop     hl
        pop     af
        ei
        reti

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
	call	crt0_exit
	di
	halt
	jp	cleanup



l_dcal: jp      (hl)            ;Used for function pointer calls

        defc    __crt_org_bss = CRT_ORG_BSS
        IF DEFINED_CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF

