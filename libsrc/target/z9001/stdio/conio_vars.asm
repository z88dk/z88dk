;
; Shared variables between the VT100 and VT52 engines


    MODULE  conio_vars
    SECTION data_clib

    PUBLIC  __z9001_attr
    PUBLIC  __z9001_mode

.__z9001_mode   defb    0
.__z9001_attr   defb $70	; White on Black
