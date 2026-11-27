    SECTION data_clib

    PUBLIC  __pc8001_mode
    PUBLIC  __pc8001_attr

; 0 = 80 column, 1 = 40 column
__pc8001_mode:
    defb    0
; Attribute used for ordinary text (reverse/underline/blink bits)
__pc8001_attr:
    defb    0
