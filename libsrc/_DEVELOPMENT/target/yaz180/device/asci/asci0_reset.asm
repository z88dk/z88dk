
    SECTION code_driver

    PUBLIC _asci0_reset

    EXTERN _asci0_flush_Rx, _asci0_flush_Tx

    _asci0_reset:

        ; interrupts should be disabled
        
        call _asci0_flush_Rx
        call _asci0_flush_Tx

        ret

    EXTERN _asci0_need
    defc NEED = _asci0_need
