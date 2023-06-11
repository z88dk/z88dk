
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

EXTERN _acia_reset, aciaControl

PUBLIC _acia_init

._acia_init
    ; initialise the ACIA

    ld a,__IO_ACIA_CR_RESET     ; Master Reset the ACIA
    out (__IO_ACIA_CONTROL_REGISTER),a

    ld a,__IO_ACIA_CR_REI|__IO_ACIA_CR_TDI_RTS0|__IO_ACIA_CR_8N2|__IO_ACIA_CR_CLK_DIV_64
                                ; load the default ACIA configuration
                                ; 8n2 at 115200 baud
                                ; receive interrupt enabled
                                ; transmit interrupt disabled
    ld (aciaControl),a          ; write the ACIA control byte echo
    out (__IO_ACIA_CONTROL_REGISTER),a  ; output to the ACIA control

    jp _acia_reset            ; reset empties the Tx & Rx buffers

