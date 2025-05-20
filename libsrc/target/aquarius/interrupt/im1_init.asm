        SECTION code_clib
        PUBLIC  _im1_init
        PUBLIC  im1_init

        EXTERN  asm_interrupt_handler
        EXTERN  im1_vectors
        extern  tick_count_isr

        defc    Z80_OPCODE_JP=$c3
        defc    EXISTING_INT_SIZE=3

	    #include "target/aquarius/def/plus.inc"
	    #include "target/aquarius/def/sbasic.inc"

im1_init:
_im1_init:
        di

        ; Write code to jump to our handler
        ld      a, Z80_OPCODE_JP
        ld      (INTJMP), a
        ld      hl, asm_im1_handler
        ld      (INTJMP+1), hl

        ; Unmask and clear VBLANK IRQ
        ld      a, IRQ_VBLANK
        out     (IO_IRQMASK), a
        out     (IO_IRQSTAT), a

	    im	1

        ei
        ret

asm_im1_handler:
        push    af
        push    hl

        ; Clear VBLANK IRQ status
        ld      a, IRQ_VBLANK
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

        SECTION code_crt_init
        ; Save info at address INTJMP
        ld      hl, INTJMP
        ld      de, existing_int
        ld      bc, EXISTING_INT_SIZE
        ldir


        SECTION code_crt_exit
        di
	; Back to IM0 for return to basic
	im	0
        ; Mask the VBLANK IRQ
        in      a, (IO_IRQMASK)
        and     ~IRQ_VBLANK
        out     (IO_IRQMASK), a
        ; Restore the original IM1 vector
        ld      hl, existing_int
        ld      de, INTJMP
        ld      bc, EXISTING_INT_SIZE
        ldir

        SECTION bss_driver
existing_int:
        defs    EXISTING_INT_SIZE
