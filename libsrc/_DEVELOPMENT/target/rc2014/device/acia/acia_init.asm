
    SECTION code_driver

    PUBLIC _acia_init

    EXTERN _acia_reset, aciaControl

    EXTERN ACIA_RESET, ACIA_CTRL_ADDR
    EXTERN ACIA_REI, ACIA_TDI_RTS0, ACIA_8N1, ACIA_CLK_DIV_64

    _acia_init:
    
        di

        ; initialise the ACIA

        ld a, ACIA_RESET            ; Master Reset the ACIA
        out (ACIA_CTRL_ADDR),a
		
        nop
        nop

        ld a, ACIA_REI|ACIA_TDI_RTS0|ACIA_8N1|ACIA_CLK_DIV_64
                                    ; load the default ACIA configuration
                                    ; 8n1 at 115200 baud
                                    ; receive interrupt enabled
                                    ; transmit interrupt disabled
                                    
        ld (aciaControl), a         ; write the ACIA control byte echo
        out (ACIA_CTRL_ADDR),a      ; output to the ACIA control byte
        call _acia_reset            ; reset empties the Tx & Rx buffers

        im 1                        ; interrupt mode 1

        ei
        ret
