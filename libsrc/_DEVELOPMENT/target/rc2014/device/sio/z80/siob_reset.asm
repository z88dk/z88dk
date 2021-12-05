
    SECTION code_driver

    PUBLIC _siob_reset

    EXTERN _siob_flush_Rx, _siob_flush_Tx

    _siob_reset:

        ; interrupts should be disabled

        call _siob_flush_Rx
        call _siob_flush_Tx

        ret

    EXTERN _sio_need
    defc NEED = _sio_need

