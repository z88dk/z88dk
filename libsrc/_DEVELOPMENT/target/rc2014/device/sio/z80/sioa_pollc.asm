
    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC _sioa_pollc

    EXTERN sioaRxCount
    
    _sioa_pollc:
    
        ; exit     : l = number of characters in Rx buffer
        ;            carry reset if Rx buffer is empty
        ;
        ; modifies : af, hl

        ld a,(sioaRxCount)          ; load the Rx bytes in buffer
        ld l,a                      ; load result

        or a                        ; check whether there are non-zero count
        ret Z                       ; return if zero count

        scf                         ; set carry to indicate char received
        ret

    EXTERN _sio_need
    defc NEED = _sio_need

