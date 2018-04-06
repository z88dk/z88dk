
    INCLUDE "config_private.inc"

    SECTION interrupt_vectors

    EXTERN      __siob_interrupt_tx_empty
    EXTERN      __siob_interrupt_ext_status
    EXTERN      __siob_interrupt_rx_char
    EXTERN      __siob_interrupt_rx_error
    EXTERN      __sioa_interrupt_tx_empty
    EXTERN      __sioa_interrupt_ext_status
    EXTERN      __sioa_interrupt_rx_char
    EXTERN      __sioa_interrupt_rx_error

    defw        __siob_interrupt_tx_empty
    defw        __siob_interrupt_ext_status
    defw        __siob_interrupt_rx_char
    defw        __siob_interrupt_rx_error
    defw        __sioa_interrupt_tx_empty
    defw        __sioa_interrupt_ext_status
    defw        __sioa_interrupt_rx_char
    defw        __sioa_interrupt_rx_error

