;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

    IFNDEF CRT_ORG_CODE
        defc CRT_ORG_CODE  = 40000
    ENDIF

    ; BDOS entry point is in high memory for bload
    defc    __bdos = $F37D

    ; In bload mode, we can't give DOS an address in 0x4000 -> -0x7fff
    ; to make things "just work", use the read cache always
    IFNDEF CPM_READ_CACHE_ALWAYS
        defc    CPM_READ_CACHE_ALWAYS = 1
    ENDIF
    
    defc    TAR__clib_exit_stack_size = 32
    defc    TAR__register_sp = -1

    INCLUDE "crt/classic/crt_rules.inc"

    org CRT_ORG_CODE

;----------------------
; Execution starts here
;----------------------
start:
    ld      (__restore_sp_onexit+1),sp
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"


    INCLUDE "crt/classic/tms99x8/tms99x8_mode_init.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    ld      ix,$CC	; Hide function key strings
    call    msxbios
    call    _main
    ld      ix,$d2	; TOTEXT - force text mode on exit
    call    msxbios

__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_exit.inc"
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0
    ret

l_dcal:
    jp      (hl)

    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE "crt/classic/crt_section.inc"

IF CLIB_MSXDOS = 1
    INCLUDE "crt/classic/crt_cpm_fcntl.inc"
ENDIF

