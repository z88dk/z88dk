


    defc    TAR__clib_exit_stack_size = 0
    defc    TAR__register_sp = -1
    defc    TAR__fputc_cons_generic = 1

    defc    CRT_ORG_CODE = 0x8995

    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

    ; BASIC header for the vz
basicstart:   
    defb 0xFF, 0xFF                           ; pointer to next basic line in memory
    defb 0xE2, 0x07                           ; 2018
    defb 0x41, 0xF0, 0x0C                     ; A=&H   
    defw start                                ; address
    defb 0x3A                                 ; :
    defb 0xB6, 0x20, 0x41                     ; CALL A
    defb 0x3A                                 ; :
    defb 0x81                                 ; END
    defb 0x00                                 ; basic line terminator    
   
start:
    ld      (__restore_sp_onexit+1),sp
    INCLUDE "crt/classic/crt_init_sp.inc"
    INCLUDE "crt/classic/crt_init_atexit.inc"
    call    crt0_init_bss
    ld      (exitsp),sp

    INCLUDE "crt/classic/crt_init_heap.inc"
    INCLUDE "crt/classic/crt_init_eidi.inc"

    call    _main
cleanup:
    push    hl
    call    crt0_exit

    pop     bc
    INCLUDE "crt/classic/crt_exit_eidi.inc"
__restore_sp_onexit:
    ld      sp,0
    ret

l_dcal:
    jp      (hl)

