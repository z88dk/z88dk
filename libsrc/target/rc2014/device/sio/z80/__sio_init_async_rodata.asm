
INCLUDE "config_private.inc"

SECTION rodata_driver

EXTERN  __crt_org_vector_table

PUBLIC  __sio_init_async_rodata

.__sio_init_async_rodata

    defb    __siob_init_async_rodata_end-__siob_init_async_rodata_begin
    defb    __IO_SIOB_CONTROL_REGISTER
.__siob_init_async_rodata_begin
    defb    __IO_SIO_WR0_CHANNEL_RESET
    defb    __IO_SIO_WR0_R2
    defb    __crt_org_vector_table&$F0
    defb    __IO_SIO_WR0_R4|__IO_SIO_WR0_EXT_INT_RESET
    defb    __IO_SIO_WR4_CLK_DIV_64|__IO_SIO_WR4_STOP_2|__IO_SIO_WR4_PARITY_NONE
    defb    __IO_SIO_WR0_R3
    defb    __IO_SIO_WR3_RX_8BIT|__IO_SIO_WR3_RX_ENABLE
    defb    __IO_SIO_WR0_R5
    defb    __IO_SIO_WR5_TX_DTR|__IO_SIO_WR5_TX_8BIT|__IO_SIO_WR5_TX_ENABLE|__IO_SIO_WR5_RTS
    defb    __IO_SIO_WR0_R1|__IO_SIO_WR0_EXT_INT_RESET
    defb    __IO_SIO_WR1_RX_INT_ALL|__IO_SIO_WR1_B_STATUS_VECTOR|__IO_SIO_WR1_TX_INT_ENABLE
.__siob_init_async_rodata_end

    defb    __sioa_init_async_rodata_end-__sioa_init_async_rodata_begin
    defb    __IO_SIOA_CONTROL_REGISTER
.__sioa_init_async_rodata_begin
    defb    __IO_SIO_WR0_CHANNEL_RESET
    defb    __IO_SIO_WR0_R4|__IO_SIO_WR0_EXT_INT_RESET
    defb    __IO_SIO_WR4_CLK_DIV_64|__IO_SIO_WR4_STOP_2|__IO_SIO_WR4_PARITY_NONE
    defb    __IO_SIO_WR0_R3
    defb    __IO_SIO_WR3_RX_8BIT|__IO_SIO_WR3_RX_ENABLE
    defb    __IO_SIO_WR0_R5
    defb    __IO_SIO_WR5_TX_DTR|__IO_SIO_WR5_TX_8BIT|__IO_SIO_WR5_TX_ENABLE|__IO_SIO_WR5_RTS
    defb    __IO_SIO_WR0_R1|__IO_SIO_WR0_EXT_INT_RESET
    defb    __IO_SIO_WR1_RX_INT_ALL|__IO_SIO_WR1_TX_INT_ENABLE
.__sioa_init_async_rodata_end

    defb    $00                 ; NULL terminator

EXTERN _sio_need
defc NEED = _sio_need
