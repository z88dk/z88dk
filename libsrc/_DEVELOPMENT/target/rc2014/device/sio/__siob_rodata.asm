
    INCLUDE "config_private.inc"
        
    SECTION rodata_driver

    PUBLIC _siob_init_rodata

    _siob_init_rodata:
        defb    __siob_init_rodata_end-__siob_init_rodata_begin
        defb    __IO_SIOB_CONTROL_REGISTER
    __siob_init_rodata_begin:    
        defb    __IO_SIO_WR0_CHANNEL_RESET|__IO_SIO_WR0_R0
        defb    __IO_SIO_WR0_R4
        defb    __IO_SIO_WR4_CLK_DIV_64|__IO_SIO_WR4_STOP_1|__IO_SIO_WR4_PARITY_NONE
        defb    __IO_SIO_WR0_R3
        defb    __IO_SIO_WR3_RX_8BIT|__IO_SIO_WR3_RX_ENABLE
        defb    __IO_SIO_WR0_R5
        defb    __IO_SIO_WR5_TX_DTR|__IO_SIO_WR5_TX_8BIT|__IO_SIO_WR5_TX_ENABLE|__IO_SIO_WR5_TX_RTS
        defb    __IO_SIO_WR0_EXT_INT_RESET|__IO_SIO_WR0_R1
       ;defb    __IO_SIO_WR1_RX_INT_FIRST|__IO_SIO_WR1_TX_INT_ENABLE
        defb    __IO_SIO_WR1_RX_INT_FIRST
    __siob_init_rodata_end:
        defb    $00                 ; NULL terminator

