; CRT0 stub for allram Sam Coupe

    defc    CRT_ORG_CODE  = 0x0000
    defc    TAR__register_sp = 0x0000       ;Not used
    defc    TAR__clib_exit_stack_size = 4
    defc    TAR__fputc_cons_generic = 1
    defc    TAR__crt_on_exit = $10001   ;loop forever
    defc    TAR__crt_enable_eidi = $02  ;enable interrupts on entry
    defc    CLIB_SAM_IS_BASIC = 0
IF !DEFINED_CRT_MAX_HEAP_ADDRESS
    defc    CRT_MAX_HEAP_ADDRESS = 65535
ENDIF

    PUBLIC  THIS_FUNCTION_ONLY_WORKS_WITH_RAM_SUBTYPES
    defc    THIS_FUNCTION_ONLY_WORKS_WITH_RAM_SUBTYPES = 1

    PUBLIC  THIS_FUNCTION_ONLY_WORKS_WITH_ALLRAM_SUBTYPE
    defc    THIS_FUNCTION_ONLY_WORKS_WITH_ALLRAM_SUBTYPE = 1

    PUBLIC  __sam_graphics_pagein
    PUBLIC  __sam_graphics_pageout

    ; The screen is paged into the higher paging window
    defc    SCREEN_BASE = 0x8000

    EXTERN  nmi_vectors

    ; In allram we need to have a stack in low memory, make it so
    IFNDEF CRT_STACK_SIZE
        defc    CRT_STACK_SIZE = 1024
    ENDIF

    defc    TAR__crt_enable_rst = $8080
    IFNDEF CRT_ENABLE_NMI
        defc        TAR__crt_enable_nmi = 1
        defc        _z80_nmi = nmi_handler
    ENDIF
    defc _z80_rst_38h = int_handler  

    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

CRT_START:
    jr      initialise

    INCLUDE "crt/classic/crt_z80_rsts.inc"

; This code has to run relatively, it's located at $8000
initialise:
    di
    in      a,(LMPR)
    and     31
    ld      (sysvarpage + 0x8000),a
    ; Page this page into low memory
    in      a,(HMPR)
    and     31
    or      @00100000	;Turn off ROM
    out     (LMPR),a
    jp      setup_in_low_memory
setup_in_low_memory:
    ; We're now in low memory, lets page in high memory now
    and     31
    inc     a
    inc     a
    ld      (highpage),a
    out     (HMPR),a
    ;; And fall into program
program:
    ; Make room for the atexit() stack
    ld      sp,stacktop
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"

    INCLUDE "target/sam/classic/sam_switchmode.inc"

IF !CRT_DISABLE_INT_TICK
    EXTERN   tick_count_isr
    EXTERN   asm_im1_install_isr
    ld       de,tick_count_isr
    call     asm_im1_install_isr
    PUBLIC   _FRAMES
    EXTERN   tick_count
    defc     _FRAMES = tick_count
ENDIF
IF CLIB_FARHEAP_BANKS
    call    setup_far_heap
ENDIF
    INCLUDE "crt/classic/crt_init_eidi.inc"
    ei
    ; Entry to the user code
    call    _main
__Exit:
    call    crt0_exit
    INCLUDE "crt/classic/crt_exit_eidi.inc"
    INCLUDE "crt/classic/crt_terminate.inc"

l_dcal:
    jp      (hl)

; The high page we actually need
highpage:   
        defb    0

; Page where system variables are stored
sysvarpage:
        defb    0


IF CLIB_FARHEAP_BANKS
    PUBLIC  __sam_bank_mappings
    EXTERN  sbrk_far

setup_far_heap:
    in      a,(HMPR)
    push    af
    and     @11100000
    ld      b,a
    ld      a,(sysvarpage)
    and     31
    or      b
    out     (HMPR),A
    ; Sysvars are now paged in to 0x8000

    ld      ix,__sam_bank_mappings
    ld      hl, $5100 + $8000
again:
    ld      a,(hl)
    and     a
    jr      nz,next
    inc     hl
    ld      a,(hl)
    dec     hl
    and     a
    jr      nz,next
    ; So we two free pages availale now
    ld      (ix+0),l
    inc     ix
    inc     hl
next:
    inc     hl
    ld      a,l
    cp      $20
    jr      c,again
    pop     af
    out     (HMPR),a


    push    ix
    pop     hl
    ld      de,__sam_bank_mappings
    and     a
    sbc     hl,de

    ld      a,l         ;Number of 32k pages we saw
    push    af          ;Save for later
    ld      de,1        ;First far address 0x010000
    ld      hl,0
    srl     a
    and     a
    jr      z,sbrk_residual

    ; Now loop, adding 64k heap chunks
    ld      b,a
sbrk_loop:
    push    bc
    push    de
    push    hl
    ld      bc,$ffff
    push    bc
    call    sbrk_far
    pop     bc
    pop     hl
    pop     de
    inc     e
    pop     bc      ;Loop count
    djnz    sbrk_loop

sbrk_residual:
    pop     af
    and     1
    ret     z
    ; We have a 32k page still
    push    de
    push    hl
    ld      bc,$7fff
    push    bc
    call    sbrk_far
    pop     bc
    pop     hl
    pop     de
    ret




; We page in 32k blocks, so using internal memory we only need 16 blocks
__sam_bank_mappings:
        defs    16

ENDIF

; Interrupt handler

    EXTERN  line_vectors
    EXTERN  im1_vectors
    EXTERN  asm_interrupt_handler
int_handler:
    push    af
    push    hl
    in      a,(STATUS)
    ld      l,a
    in      a,(HMPR)
    push    af
    ld      a,(highpage)
    out     (HMPR),a

    ld      a,l
    ld      hl,im1_vectors
    bit     3,a             ;Frame interrupt
    jr      z,dispatch
    ld      hl,line_vectors
    bit     0,a             ;Line interrupt
dispatch:
    call    z, asm_interrupt_handler
    pop     af
    out     (HMPR),a
    pop     hl
    pop     af
    ei
    ret

nmi_handler:
    push    af
    push    hl
    in      a,(HMPR)
    push    af
    ld      a,(highpage)
    out     (HMPR),a
    ld      hl,nmi_vectors
    call    asm_interrupt_handler
    pop     af
    out     (HMPR),a
    pop     hl
    pop     af
    retn





; Page in graphics into the HMPR
; Push the old HMPR value under
;
; Uses: af',bc
__sam_graphics_pagein:
    pop     bc          ;Return add
    ex      af,af
    in      a,(HMPR)
    push    af
    push    bc
    and     @11100000
    ld      c,a
    in      a,(VMPR)
    and     @00011111
    or      c
    out     (HMPR),a
    ex      af,af
    ret

; Uses: af',bc
__sam_graphics_pageout:
    pop     bc
    ex      af,af
    pop     af
    out     (HMPR),a
    ex      af,af
    push    bc
    ret


stack:

    defs    CRT_STACK_SIZE
stacktop:

    INCLUDE "crt/classic/crt_runtime_selection.inc"

    ; The paging on the sam is awkward to say the least. So, a decision
    ; has been made that this model will require the bottom 32k to remain
    ; paged in.
    ;
    ; As a result, we need to ensure that compiler support routines,
    ; screen routines are in low memory and can't be
    ; paged out
    SECTION code_l
    SECTION code_l_sdcc
    SECTION code_l_sccz80
    SECTION code_graphics
    SECTION code_driver
    SECTION data_graphics
    SECTION data_driver
    SECTION bss_graphics
    SECTION bss_driver
    SECTION rodata_driver
    SECTION rodata_font_4x4
    SECTION rodata_font_8x8

    INCLUDE "crt/classic/crt_section.inc"
