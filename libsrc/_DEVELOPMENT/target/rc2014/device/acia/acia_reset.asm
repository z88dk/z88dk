
    SECTION code_driver

    PUBLIC _acia_reset

    EXTERN _acia_flush_Rx, _acia_flush_Tx

    _acia_reset:

        ; interrupts should be disabled
        
        call _acia_flush_Rx
        call _acia_flush_Tx

        ret

    EXTERN _acia_need
    defc NEED = _acia_need
