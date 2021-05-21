; CRT0 stub for high RAM

    defc    CLIB_SAM_IS_BASIC = 0
    defc    CRT_ORG_CODE  = 0x8000
    defc    TAR__register_sp = 0xfd00
    defc    TAR__clib_exit_stack_size = 4
    defc    TAR__fputc_cons_generic = 1

    ; Where the screen is located
    defc    SCREEN_BASE = 0x0000

    PUBLIC  THIS_FUNCTION_ONLY_WORKS_WITH_RAM_SUBTYPES
    defc    THIS_FUNCTION_ONLY_WORKS_WITH_RAM_SUBTYPES = 1

    PUBLIC  __sam_graphics_pagein
    PUBLIC  __sam_graphics_pageout

    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

program:
    di
    ; Make room for the atexit() stack
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp


    ; Setup heap between end program and sp
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF

    ; Now, page the screen into 0000-0x7fff
    INCLUDE "target/sam/classic/sam_switchmode.inc"

    in      a,(VMPR)
    ld      b,a
    or      @01100000
    out     (VMPR),a
    ld      a,b
    and     @00011111
    or      @00100000	;Page video memory in low, turn off ROM
    out     (LMPR),a

    ; We are in high RAM, we have to setup an interrupt handler
    ; (we don't have access to NMI here)
    ld      hl,$fe00
    ld      de,$fe01
    ld      bc,257	
    ld      (hl),$fd
    ldir
    ld      a,195
    ld      ($fdfd),a
    ld      hl,int_handler
    ld      ($fdfe),hl
    ld      a,0xfe
    ld      i,a

IF !CRT_DISABLE_INT_TICK
    EXTERN   tick_count_isr
    EXTERN   asm_im1_install_isr
    ld       de,tick_count_isr
    call     asm_im1_install_isr
    PUBLIC   _FRAMES
    EXTERN   tick_count
    defc     _FRAMES = tick_count
ENDIF
    im      2
    ei

    ; Entry to the user code
    call    _main
cleanup:
    call    crt0_exit
endloop:
    jr      endloop

; Paging routines for graphics
__sam_graphics_pagein:
__sam_graphics_pageout:
    ret

; Interrupt handler

    EXTERN  line_vectors
    EXTERN  im1_vectors
    EXTERN  asm_interrupt_handler
int_handler:
    push    af
    push    hl
    in      a,(STATUS)
    ld      hl,im1_vectors
    bit     3,a             ;Frame interrupt
    jr      z,dispatch
    ld      hl,line_vectors
    bit     0,a             ;Line interrupt
dispatch:
    call    z, asm_interrupt_handler
    pop     hl
    pop     af
    ei
    ret

l_dcal:
    jp      (hl)

    INCLUDE "crt/classic/crt_runtime_selection.asm"

    INCLUDE "crt/classic/crt_section.asm"

