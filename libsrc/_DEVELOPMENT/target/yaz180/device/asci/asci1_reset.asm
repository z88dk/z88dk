
    SECTION code_driver

    PUBLIC _asci1_reset

    EXTERN _asci1_flush_Rx, _asci1_flush_Tx

    _asci1_reset:

        ; interrupts should be disabled
        
        call _asci1_flush_Rx
        call _asci1_flush_Tx

        ret

    EXTERN _asci1_need
    defc NEED = _asci1_need
