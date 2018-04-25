
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC _acia_init

    EXTERN _acia_reset, aciaControl
    EXTERN asm_z80_push_di, asm_z80_pop_ei_jp

    _acia_init:
    
        call asm_z80_push_di        ; di

        ; initialise the ACIA

        ld a, __IO_ACIA_CR_RESET            ; Master Reset the ACIA
        out (__IO_ACIA_CONTROL_REGISTER),a

        ld a, __IO_ACIA_CR_REI|__IO_ACIA_CR_TDI_RTS0|__IO_ACIA_CR_8N1|__IO_ACIA_CR_CLK_DIV_64
                                    ; load the default ACIA configuration
                                    ; 8n1 at 115200 baud
                                    ; receive interrupt enabled
                                    ; transmit interrupt disabled
        ld (aciaControl), a         ; write the ACIA control byte echo
        out (__IO_ACIA_CONTROL_REGISTER), a    ; output to the ACIA control

        call _acia_reset            ; reset empties the Tx & Rx buffers

        im 1                        ; interrupt mode 1

        jp asm_z80_pop_ei_jp        ; ei
