;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

    IFNDEF CRT_ORG_CODE
        defc CRT_ORG_CODE  = 40000
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
    INCLUDE "crt/classic/crt_init_atexit.inc"
    call    crt0_init_bss
    ld      (exitsp),sp

    ld      ix,$CC	; Hide function key strings
    call    msxbios
    call    _main
    ld      ix,$d2	; TOTEXT - force text mode on exit
    call    msxbios

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"


cleanup:
    call    crt0_exit
__restore_sp_onexit:
    ld      sp,0
    ret

l_dcal:
    jp      (hl)

    INCLUDE "crt/classic/crt_runtime_selection.inc"
    INCLUDE "crt/classic/crt_section.inc"

