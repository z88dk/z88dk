;       Startup fo SAM Coupe
;
;       Stefano 26/3/2001
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: sam_crt0.asm,v 1.20 2016-06-21 20:49:06 dom Exp $
;


    PUBLIC    THIS_FUNCTION_ONLY_WORKS_WITH_BASIC_SUBTYPE
    defc    THIS_FUNCTION_ONLY_WORKS_WITH_BASIC_SUBTYPE = 1

    defc    CLIB_SAM_IS_BASIC = 1

    UNDEFINE CONSOLE_ROWS
    defc    CONSOLE_ROWS = 22

IF !DEFINED_CRT_MAX_HEAP_ADDRESS
    defc CRT_MAX_HEAP_ADDRESS = 65535
ENDIF

    ; Point palette store to the system variables
    PUBLIC  SAM_PALETTE_VALUES
    defc    SAM_PALETTE_VALUES = 0x55D8
    defc    TAR__no_ansifont = 1
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1
    defc    SCREEN_BASE = 16384
    defc    CRT_ORG_CODE = 32768
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

start:
    ld      (__restore_sp_onexit+1),sp   ;Save entry stack
    INCLUDE "crt/classic/crt_init_sp.inc"
    INCLUDE "crt/classic/crt_init_atexit.inc"
    call    crt0_init_bss
    ld      (exitsp),sp

    INCLUDE "crt/classic/crt_init_heap.asm"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    ; Special SAM stuff goes here

    ; Set screen to mode 0
    ld a,0
    call $15A ; JMODE

    ; set stream to channel 's' (upper screen)
    ld a,2
    call $112 ; JSETSTRM
  
    EXTERN __zx_mode0_console_w
    ld      a,32
    ld      (__zx_mode0_console_w),a

;   End of SAM stuff




    call    _main
cleanup:
    push    hl
    call    crt0_exit


    pop     bc

;       Special SAM stuff goes here

;       End of SAM stuff



__restore_sp_onexit:
    ld      sp,0
    ret

l_dcal:
    jp      (hl)



    INCLUDE "crt/classic/crt_runtime_selection.inc"

    INCLUDE    "crt/classic/crt_section.inc"

    SECTION    code_crt_init
    ld    hl,16384
    ld    (base_graphics),hl

