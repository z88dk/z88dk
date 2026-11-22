
    MODULE astrocde_crt0 

;-------
; Include zcc_opt.def to find out information about us
;-------
    INCLUDE "target/astrocde/def/HVGLIB.H"

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

IF DEFINED_CRT_ORG_BSS
    defc    __crt_org_bss = CRT_ORG_BSS
ENDIF

IFNDEF      CRT_ORG_CODE
    defc    CRT_ORG_CODE = 0x2000
ENDIF


    ; Default, don't change the stack pointer
    defc    TAR__register_sp = -1
    ; Default, 32 functions can be registered for atexit()
    defc    TAR__clib_exit_stack_size = 0
    ; Default, halt loop
    defc    TAR__crt_on_exit = 0x10001

    defc    __CPU_CLOCK = 18700000
    INCLUDE "crt/classic/crt_rules.inc"


    org    	CRT_ORG_CODE

    defb	'U'
    defw	MENUST
    defw        program_name
    defw        start		;entry point

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

program_name:
    defm   "z88dk"
    defb   0

    INCLUDE "crt/classic/crt_runtime_selection.inc"

    ; If we were given a model then use it
IF DEFINED_CRT_MODEL
    defc __crt_model = CRT_MODEL
ELIF DEFINED_CRT_ORG_BSS
    ;; If BSS is defined, then assume we're ROM model
    defc __crt_model = 1
ENDIF
    INCLUDE	"crt/classic/crt_section.inc"
