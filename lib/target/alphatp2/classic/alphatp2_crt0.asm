
    MODULE alphap2_crt0 

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

IFNDEF      CRT_ORG_CODE
    defc    CRT_ORG_CODE = 0x4100
ENDIF

    defc    CONSOLE_COLUMNS = 80
    defc    CONSOLE_ROWS = 24

    ; Default, don't change the stack pointer
    defc    TAR__register_sp = 0xff00
    ; Default, 32 functions can be registered for atexit()
    defc    TAR__clib_exit_stack_size = 32
    ; Default, exit to caller
    defc    TAR__crt_on_exit = 0x10002

    defc    __CPU_CLOCK = 4000000
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


    SECTION bootstrap

    org     $4010

    EXTERN  __DATA_END_tail

    ld      l,0         ;Drive 0, side 0
    ld      de,0x3000   ;Sector 3, track 0
    ld      a,$84       ;Position floppy
    call    0x0814      ;Execute command
;    jp      c,0
    ld      bc,CRT_ORG_CODE
    ld	    d, +((__DATA_END_tail - CRT_ORG_CODE ) / 256) + 1       ;Number of sectors
    ld      e,0
    ld      a,$82        ;Load sectors
    call    0x814
;    jp      c,0
    jp      CRT_ORG_CODE
