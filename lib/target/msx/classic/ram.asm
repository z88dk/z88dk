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
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    ld      ix,$CC	; Hide function key strings
    call    msxbios
    call    _main
    ld      ix,$d2	; TOTEXT - force text mode on exit
    call    msxbios
cleanup:
    call    crt0_exit
__restore_sp_onexit:
    ld      sp,0
    ret

l_dcal:
    jp      (hl)

    INCLUDE "crt/classic/crt_runtime_selection.asm"
    INCLUDE "crt/classic/crt_section.asm"

