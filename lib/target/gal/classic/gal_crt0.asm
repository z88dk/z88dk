;       Galaksija  Program boot
;
;       Stefano Bodrato 2008
;
;       $Id: gal_crt0.asm,v 1.14 2016-06-21 20:49:06 dom Exp $
;



	MODULE  gal_crt0
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

IF      !DEFINED_CRT_ORG_CODE
	defc	CRT_ORG_CODE = 0x2c3a
ENDIF

    defc    CONSOLE_COLUMNS = 32
IF !DEFINED_CONSOLE_ROWS
    defc    CONSOLE_ROWS = 16
ENDIF

    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    defc __CPU_CLOCK = 3072000
    INCLUDE	"crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

start:
    ld      (__restore_sp_onexit+1),sp   ;Save entry stack
    INCLUDE	"crt/classic/crt_init_sp.asm"
    INCLUDE	"crt/classic/crt_init_atexit.asm"
    call	crt0_init_bss
    ld      (exitsp),sp

IF DEFINED_USING_amalloc
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    call    _main           ;Call user program

cleanup:
    call    crt0_exit


cleanup_exit:
	halt
	im	1
__restore_sp_onexit:ld      sp,0            ;Restore stack to entry value
vpeek_noop:
	scf
noop:
        ret

l_dcal: jp      (hl)            ;Used for function pointer calls




        INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE "crt/classic/crt_section.asm"


	SECTION	code_crt_init
	ld	hl,$2800
	ld	(base_graphics),hl


IF CLIB_DISABLE_MODE1 = 1
        PUBLIC  vpeek_MODE1
        PUBLIC  printc_MODE1
        PUBLIC  plot_MODE1
        PUBLIC  res_MODE1
        PUBLIC  xor_MODE1
        PUBLIC  pointxy_MODE1
        PUBLIC  pixeladdress_MODE1
	PUBLIC  scrollup_MODE1
        defc    vpeek_MODE1 = vpeek_noop
        defc    printc_MODE1 = noop
        defc    plot_MODE1 = noop
        defc    res_MODE1 = noop
        defc    xor_MODE1 = noop
        defc    pointxy_MODE1 = noop
        defc    pixeladdress_MODE1 = noop
        defc    scrollup_MODE1 = noop
	PUBLIC	__CLIB_DISABLE_MODE1
	defc	__CLIB_DISABLE_MODE1 = 1
ELSE
	PUBLIC	__CLIB_DISABLE_MODE1
	defc	__CLIB_DISABLE_MODE1 = 0
ENDIF
