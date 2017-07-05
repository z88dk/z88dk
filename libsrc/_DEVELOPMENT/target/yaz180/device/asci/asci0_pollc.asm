
    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC _asci0_pollc

    EXTERN asci0RxCount
    
    _asci0_pollc:
    
        ; exit     : l = number of characters in Rx buffer
        ;            carry reset if Rx buffer is empty
        ;
        ; modifies : af, hl

        ld a, (asci0RxCount)        ; load the Rx bytes in buffer
        ld l, a	                    ; load result
        
        or a                        ; check whether there are non-zero count
        ret z                       ; return if zero count
        
        scf                         ; set carry to indicate char received
        ret

    EXTERN _asci0_need
    defc NEED = _asci0_need
