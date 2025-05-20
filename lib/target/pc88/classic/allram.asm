;	CRT0 stub for 64k Mode PC88


    defc    CONSOLE_COLUMNS = 80
    defc    CONSOLE_ROWS = 25
    defc    CRT_ORG_CODE  = 0x0000
    defc    TAR__register_sp = 0xc000
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__crt_enable_eidi = $02
    defc    TAR__crt_on_exit = $10001

    ; No interrupts registered
    defc    TAR__crt_enable_rst = $0000
IFNDEF CRT_ENABLE_NMI
    defc    TAR__crt_enable_nmi = 1
    EXTERN  asm_nmi_handler
    defc    _z80_nmi = asm_nmi_handler
ENDIF

    EXTERN	asm_im1_handler

    INCLUDE	"crt/classic/crt_rules.inc"


    org     CRT_ORG_CODE

    jp      program

    INCLUDE	"crt/classic/crt_z80_rsts.inc"

program:
    di
    ; Make room for the atexit() stack
    INCLUDE	"crt/classic/crt_init_sp.inc"

    call    crt0_init
    INCLUDE	"crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"

    ld  hl,asm_im1_handler
    ld  ($f302),hl		;vsync interrupt
    ld  a,2			;Enable vsync interrupt only
    out ($e4),a
    out ($e6),a
    INCLUDE "crt/classic/crt_init_eidi.inc"

; Entry to the user code
    call    _main

__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"

l_dcal:
    jp      (hl)

; Make im1 init a noop in allram mode
im1_init:
_im1_init:
; Calling the bios should be noop too since it's not paged in
pc88bios:	
    ret

    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE "crt/classic/crt_section.inc"

    ; Include the IPL bootstrap code
    INCLUDE "target/pc88/classic/bootstrap.asm"

