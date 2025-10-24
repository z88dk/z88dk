;
; A configurable CRT for bare-metal targets
;
;

    MODULE hector_crt0 

;-------
; Include zcc_opt.def to find out information about us
;-------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

    EXTERN    _main           ;main() is always external to crt0 code
    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)
    EXTERN	  asm_im1_handler
    EXTERN	  asm_nmi_handler


IFNDEF      CRT_ORG_CODE
    IFDEF __HECTORHR
        defc    CRT_ORG_CODE = 0x6000
    ELSE
        defc    CRT_ORG_CODE = 0x5000
    ENDIF
ENDIF


; Default, don't change the stack pointer
IFDEF __HECTORHR
    defc    TAR__register_sp = 0xc000
    defc    __CPU_CLOCK = 5000000
    defc    CONSOLE_COLUMNS = 30
    defc    CONSOLE_ROWS = 28
    defc    HECTOR_GRAPHICS_W = 240
    defc    HECTOR_GRAPHICS_H = 226
ELSE
    defc    TAR__register_sp = 0x5fc0
    defc    __CPU_CLOCK = 2000000
    ; 64 column fonts
    defc    CONSOLE_COLUMNS = 28
    defc    CONSOLE_ROWS = 9
    defc    HECTOR_GRAPHICS_W = 112
    defc    HECTOR_GRAPHICS_H = 77
ENDIF
    ; Default, 2 functions can be registered for atexit()
    defc    TAR__clib_exit_stack_size = 2
    ; Default, return to caller
    defc    TAR__crt_on_exit = 0x10002

    PUBLIC  HECTOR_GRAPHICS_W
    PUBLIC  HECTOR_GRAPHICS_H

    INCLUDE "crt/classic/crt_rules.inc"



    org    	CRT_ORG_CODE


start:
    INCLUDE "crt/classic/crt_init_sp.inc"
    ; Setup BSS memory and perform other initialisation
    call    crt0_init
    ; Make room for the atexit() stack
    INCLUDE "crt/classic/crt_init_atexit.inc"

    ; Setup heap if required
    INCLUDE "crt/classic/crt_init_heap.inc"

    ; Setup the desired interrupt mode
    INCLUDE "crt/classic/crt_init_interrupt_mode.inc"
    ; Turn on interrupts if desired
    INCLUDE "crt/classic/crt_init_eidi.inc"

IF __HECTORHR
    ; Force VRAM to be paged in
    ld      (0x800),a
ENDIF

    ; Entry to the user code
    call    _main
    ; Exit code is in hl
__Exit:
    ; crt0_exit any resources
    call    crt0_exit

    ; Set the interrupt mode on exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"

    ; How does the program end?
    INCLUDE "crt/classic/crt_terminate.inc"

l_dcal:
    jp      (hl)

    INCLUDE "crt/classic/crt_runtime_selection.inc"

    INCLUDE	"crt/classic/crt_section.inc"
