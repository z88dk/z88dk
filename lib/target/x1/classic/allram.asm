;	CRT0 for the Sharp X1 - all RAM mode
;
;	Karl Von Dyson (for X1s.org)
;
;

        EXTERN asm_im1_handler
        EXTERN asm_nmi_handler
        EXTERN im1_install_isr

if (ASMPC<>$0000)
    defs    CODE_ALIGNMENT_ERROR
endif
    di
    jp      program

    defs    $0008-ASMPC
if (ASMPC<>$0008)
    defs    CODE_ALIGNMENT_ERROR
endif
    jp      restart08

    defs    $0010-ASMPC
if (ASMPC<>$0010)
    defs    CODE_ALIGNMENT_ERROR
endif
    jp      restart10

    defs    $0018-ASMPC
if (ASMPC<>$0018)
    defs    CODE_ALIGNMENT_ERROR
endif
    jp      restart18

    defs    $0020-ASMPC
if (ASMPC<>$0020)
    defs    CODE_ALIGNMENT_ERROR
endif
    jp      restart20

defs        $0028-ASMPC
if (ASMPC<>$0028)
    defs    CODE_ALIGNMENT_ERROR
endif
    jp      restart28
    defs    $0030-ASMPC
    defs    $0038-ASMPC
if (ASMPC<>$0038)
    defs    CODE_ALIGNMENT_ERROR
endif
    jp      asm_im1_handler

    defs    $0066 - ASMPC
if (ASMPC<>$0066)
    defs    CODE_ALIGNMENT_ERROR
endif
    jp      asm_nmi_handler

restart10:
restart08:
restart18:
restart20:
restart28:
restart30:
    ret


program:
; Make room for the atexit() stack
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"

    call    crt0_init_bss
    ld      (exitsp),sp
IF DEFINED_USING_amalloc
    ld      hl,0
    add     hl,sp
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
    ; Install the keyboard interrupt handler
    ld      hl,asm_x1_keyboard_handler
    push    hl
    call    im1_install_isr
    pop     bc
    im      1
    ei
  
    call    _wait_sub_cpu
    ld      bc, $1900
    ld      a, $E4	; Interrupt vector set
    out     (c), a
    call    _wait_sub_cpu
    ld      bc,$1900
    ld      a, $52	; 
    out     (c), a
    call    _main

cleanup:
    call    crt0_exit

end:
    jr	end
    rst	0

cleanup_exit:
    ret