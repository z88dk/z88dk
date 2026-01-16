
    PUBLIC __printf_pickup_far
    EXTERN  l_ret

    ; Playing fast and loose with the linker behaviour
    ;
    ; This routine is needed to handle far strings, however given that code
    ; is intermingled with the regular string printing code, we don't want to
    ; include it for:
    ;
    ; a) Targets that don't have far support
    ; b) If we never actually use the %S format specifier
    ;
    ; As such, when we create the library we're relying on the glob in the .lst
    ; files returning the files in alpha order, and the export in tis file
    ; being found before the one in __printf_handle_far_s
    ;
    ; This horrible magic, means that we've only added 7 bytes to the z80 library
    ; in the case where far isn't needed.
    defc __printf_pickup_far = l_ret
    