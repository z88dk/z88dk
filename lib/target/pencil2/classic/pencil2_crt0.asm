;
;	Startup for the Pencil II
;
;	2k of memory 

	module	pencil_crt0 


;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)
	PUBLIC	  msxbios
	EXTERN	  msx_set_mode
	EXTERN    asm_im1_handler
	EXTERN    nmi_vectors
        EXTERN    asm_interrupt_handler
	EXTERN    __vdp_enable_status
	EXTERN    VDP_STATUS

	defc	CONSOLE_COLUMNS = 32
	defc	CONSOLE_ROWS = 24

	defc	CRT_ORG_BSS = 0x7000	
	defc	CRT_ORG_CODE = 0x8000

        defc    TAR__fputc_cons_generic = 1
        defc    TAR__no_ansifont = 1
        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = 0x7800
	defc	CRT_KEY_DEL = 127
	defc	__CPU_CLOCK = 3579545
        INCLUDE "crt/classic/crt_rules.inc"

	org	  CRT_ORG_CODE
	defm	"COPYRIGHT SOUNDIC"
	jp	program		;Where to start execution from
	jp	nmi_int		;8013
	jp	restart08	;8017
	jp	restart10	;801a
	jp	restart18	;801d
	jp	restart20	;8020
	jp	restart28	;8023
	jp	restart30 	;8026
	jp	asm_im1_handler	;Maskable interrupt

	defs	$8034 - $802c
	defm "Z88DK!** **!2019"


; Restart routines, nothing sorted yet
restart08:
restart10:
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
	ld	hl,2
	call	msx_set_mode
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
	rst	0		;Restart when main finishes



nmi_int:
	push	af
	push	hl
	ld	a,(__vdp_enable_status)
	rlca
	jr	c,no_vbl
	in	a,(VDP_STATUS)
no_vbl:
	ld	hl,nmi_vectors
	call	asm_interrupt_handler
	pop	hl
	pop	af
	retn


; Safe BIOS call
msxbios:
        push    ix
        ret


l_dcal: jp      (hl)            ;Used for function pointer calls

	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	defc	__crt_org_bss = CRT_ORG_BSS
        IF DEFINED_CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF
	INCLUDE	"crt/classic/crt_section.asm"

