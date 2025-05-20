; CRT0 stub for high RAM

    defc    CLIB_SAM_IS_BASIC = 0
    defc    CRT_ORG_CODE  = 0x8000
    defc    TAR__register_sp = 0xfd00
    defc    TAR__clib_exit_stack_size = 4
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__crt_enable_eidi = $02      ;enable interrupts on
    defc    TAR__crt_on_exit = $10001       ;loop forever

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
IF __crt_on_exit = 0x10002
    ld      (restoresp+1),sp
    in      a,(LMPR)
    ld      (__entry_lmpr+1),a
ENDIF
    ; Make room for the atexit() stack
    INCLUDE "crt/classic/crt_init_sp.inc"
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"


    ; Setup heap between end program and sp
    INCLUDE "crt/classic/crt_init_heap.inc"

    INCLUDE "target/sam/classic/sam_switchmode.inc"

    ; Now, page the screen into 0000-0x7fff
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
    INCLUDE "crt/classic/crt_init_eidi.inc"
    ; Entry to the user code
    call    _main
__Exit:
    call    crt0_exit
IF CLIB_EXIT_SCREEN_MODE != -1
    ld      a,CLIB_EXIT_SCREEN_MODE
    call    asm_sam_set_screenmode
ENDIF
IF __crt_on_exit = 0x10002
    di
    ; Page us into high memory
__entry_lmpr:
    ld      a,0
    out     (LMPR),a
    im      1
restoresp:
    ld      sp,0
    ei
    ret
ELSE
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"
ENDIF



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

    INCLUDE "crt/classic/crt_runtime_selection.inc"

    INCLUDE "crt/classic/crt_section.inc"

