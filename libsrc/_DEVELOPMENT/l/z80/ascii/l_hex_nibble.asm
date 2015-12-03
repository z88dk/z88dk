
SECTION code_clib
SECTION code_l

PUBLIC l_hex_nibble
PUBLIC l_hex_nibble_hi, l_hex_nibble_lo

l_hex_nibble_hi:

    ; translate top nibble of byte into a uppercase ascii hex digit
    ;
    ; enter : a = number
    ;
    ; exit  : a = hex character representing top nibble of number
    ;
    ; uses  : af

    rra
    rra
    rra
    rra

l_hex_nibble:
l_hex_nibble_lo:

    ; translate bottom nibble of byte into a uppercase ascii hex digit
    ;
    ; enter : a = number
    ;
    ; exit  : a = hex character representing bottom nibble of number
    ;
    ; uses  : af
    
    or $f0
    daa
    add a,$a0
    adc a,$40
    ret
