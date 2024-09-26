    SECTION code_clib
    PUBLIC  _im1_init
    PUBLIC  im1_init

    EXTERN  asm_interrupt_handler
    EXTERN  im1_vectors
    EXTERN  l_pop_ei
    EXTERN  l_push_di
    extern  tick_count_isr

    defc    Z80_OPCODE_JP=$c3
    defc    EXISTING_INT_SIZE=3
    defc    IO_IRQMASK=$ee
    defc    IO_IRQSTAT=$ef
    defc    IO_BANK0=$f0

im1_init:
_im1_init:
    ; Ensure BANK0 is R/W
    in      a, (IO_BANK0)
    and     $7f
    out     (IO_BANK0), a

    ; Save info at address $38
    ld      hl, $38
    ld      de, existing_int
    ld      bc, EXISTING_INT_SIZE
    ldir

    ; Write code to jump to our handler
    ld      hl, asm_im1_handler
    ld      a, Z80_OPCODE_JP
    ld      ($38), a
    ld      ($39), hl

    ; Unmask and clear VBLANK IRQ
    ld      a, $01
    out     (IO_IRQMASK), a
    out     (IO_IRQSTAT), a

    ei
    ret

asm_im1_handler:
    push    af
    push    hl

    ; Clear VBLANK IRQ status
    ld      a, $01
    out     (IO_IRQSTAT), a

    ; Update the ticks counter
    call    tick_count_isr

    ; Handle user routines
    ld      hl, im1_vectors
    call    asm_interrupt_handler

    pop     hl
    pop     af
    ei
    ret


    SECTION bss_driver

existing_int:
    defs    EXISTING_INT_SIZE
