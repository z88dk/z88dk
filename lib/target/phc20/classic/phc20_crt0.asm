;       Startup for Sanyo PHC-20 - non functinoal 
;



    MODULE  phc20_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

    EXTERN    _main           ; main() is always external to crt0 code

    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)


    defc    CRT_ORG_CODE  = $4000	 ; RAM TODO

    defc    CONSOLE_COLUMNS = 32
    defc    CONSOLE_ROWS = 16

    defc    GRAPHICS_CHAR_SET = 64 + 32
    defc    GRAPHICS_CHAR_UNSET = 32
    PUBLIC  GRAPHICS_CHAR_SET
    PUBLIC  GRAPHICS_CHAR_UNSET


    defc    TAR__fputc_cons_generic = 1
    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 0

    defc    TAR__register_sp = -1           ;Must be below interrupt table
    defc    TAR__crt_enable_eidi = 0        ;Do nothing
    defc	__CPU_CLOCK = 4000000
    INCLUDE	"crt/classic/crt_rules.inc"


    org     CRT_ORG_CODE

    di
    INCLUDE	"crt/classic/crt_init_sp.inc"
    call	crt0_init
    INCLUDE	"crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"


    call    _main
__Exit:
    call    crt0_exit

    ; We've probably broken all the basic variables, just restart if we get here
    rst 0
    
noop:
    ret

l_dcal:
    jp      (hl)


    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE	"crt/classic/crt_section.inc"



    INCLUDE  "crt/classic/mc6847/mc6847_mode_disable.inc"
