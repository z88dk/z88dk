;
;  CRT for agon/MOS
;

    MODULE agon_crt0 


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"


    EXTERN    _main           ;main() is always external to crt0 code
    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)
    EXTERN	  asm_im1_handler
    EXTERN	  asm_nmi_handler
    EXTERN    asm_agon_setmode

    defc      CONSOLE_COLUMNS = 64
    defc      CONSOLE_ROWS = 48


IFNDEF      CRT_ORG_CODE
    defc    CRT_ORG_CODE = 0x0000
ENDIF

IFNDEF CLIB_DEFAULT_SCREEN_MODE
    defc    CLIB_DEFAULT_SCREEN_MODE = 1
ENDIF


    ; Default, don't change the stack pointer
    defc    TAR__register_sp = -1
    defc    TAR__clib_exit_stack_size = 32
    ; Default, halt loop
    defc    TAR__crt_on_exit = 0x10001

    defc    __CPU_CLOCK = 4000000
    INCLUDE "crt/classic/crt_rules.inc"



    org    	CRT_ORG_CODE


IF CRT_ORG_CODE = 0x0000
    jp      start
    defs    $0008-ASMPC
    defb	$49		;LIS prefix
    rst     $08

    defs    $0010-ASMPC
    defb	$49		;LIS prefix
    rst     $10

    defs    $0018-ASMPC
    defb	$49		;LIS prefix
    rst     $18

    defs    $0038-ASMPC
    ei
    reti

    defs    64 - ASMPC
if (ASMPC<>64)
    defs    CODE_ALIGNMENT_ERROR
ENDIF
    ; Header for MOS
    defm    "MOS"
    defb    0     ;Version
    defb    0     ;ADL mode
ENDIF



start:
    defb    0x5b    ;LIL
    push    ix
    defb    0x5b    ;LIL
    push    iy
    INCLUDE "crt/classic/crt_start_eidi.inc"
    INCLUDE "crt/classic/crt_init_sp.asm"
    ; Make room for the atexit() stack
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp

    defb    0x5b	;LIL
    ld      a,(iy+8)
    ld      (__agon_mbase),a

    ld      a,CLIB_DEFAULT_SCREEN_MODE
    call    asm_agon_setmode

    ; Entry to the user code
    call    _main
    ; Exit code is in hl
cleanup:
    call    crt0_exit
    defb    0x5b    ;LIL
    pop     iy
    defb    0x5b    ;LIL
    pop     ix
    defb    $5b
    ld      hl,0
    defb    0
    defb    $49     ;LIS
    ret


l_dcal:
    jp      (hl)


    PUBLIC  __agon_hl24
    PUBLIC  __agon_de24

__agon_hl24:
    defb    $5b     ;lil
    push    hl
    defb    $5b
    ld      hl,2    
    defb    0
    defb    $5b
    add     hl,sp
    ld      a,(__agon_mbase)
    defb    $5b
    ld      (hl),a
    defb    $5b
    pop     hl
    ret

__agon_de24:
    defb    $5b     ;lil
    push    de
    defb    $5b
    ld      hl,2    
    defb    0
    defb    $5b
    add     hl,sp
    ld      a,(__agon_mbase)
    defb    $5b
    ld      (hl),a
    defb    $5b
    pop     de
    ret



    INCLUDE "crt/classic/crt_runtime_selection.asm"


    ; If we were given a model then use it
IF DEFINED_CRT_MODEL
    defc __crt_model = CRT_MODEL
ENDIF
    INCLUDE	"crt/classic/crt_section.asm"

    SECTION bss_crt
PUBLIC __agon_mbase
__agon_mbase: defb 0
