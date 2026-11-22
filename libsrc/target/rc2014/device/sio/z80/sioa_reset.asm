
    SECTION code_driver

    PUBLIC _sioa_reset

    EXTERN _sioa_flush_Rx, _sioa_flush_Tx

    _sioa_reset:

        ; interrupts should be disabled

        call _sioa_flush_Rx
        call _sioa_flush_Tx

        ret

    EXTERN _sio_need
    defc NEED = _sio_need

