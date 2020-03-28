;	CRT0 stub for 64k Mode Multi8
;
;


	defc    CRT_ORG_CODE  = 0x0000
        defc    TAR__register_sp = 0xffff
        defc    TAR__clib_exit_stack_size = 0
	defc	VRAM_IN = 0x37;
	defc	VRAM_OUT = 0x2f
	INCLUDE	"crt/classic/crt_rules.inc"

	EXTERN	asm_im1_handler
	EXTERN	asm_nmi_handler

        org     CRT_ORG_CODE

if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif
	di
        jp      program

        defs    $0008-ASMPC
if (ASMPC<>$0008)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart08

        defs    $0010-ASMPC
if (ASMPC<>$0010)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart10

        defs    $0018-ASMPC
if (ASMPC<>$0018)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart18

        defs    $0020-ASMPC
if (ASMPC<>$0020)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart20

    defs        $0028-ASMPC
if (ASMPC<>$0028)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart28
        defs    $0030-ASMPC
if (ASMPC<>$0030)
        defs    CODE_ALIGNMENT_ERROR
endif
        jp      restart30

        defs    $0038-ASMPC
if (ASMPC<>$0038)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	asm_im1_handler

        defs    $0066 - ASMPC
if (ASMPC<>$0066)
        defs    CODE_ALIGNMENT_ERROR
endif
	jp	asm_nmi_handler

restart10:
restart08:
restart18:
restart20:
restart28:
restart30:
        ret

program:
; Make room for the atexit() stack
	INCLUDE	"crt/classic/crt_init_sp.asm"
	INCLUDE	"crt/classic/crt_init_atexit.asm"

	call	crt0_init_bss
	ld      (exitsp),sp

	ld	a,(SYSVAR_PORT29_COPY)
	ld	(__port29_copy),a

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF


	im	1
	ei

; Entry to the user code
	call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
    call    crt0_exit


endloop:
	jr	endloop

