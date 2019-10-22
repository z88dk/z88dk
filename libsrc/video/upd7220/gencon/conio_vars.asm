;
; Shared variables between the VT100 and VT52 engines


    MODULE      conio_vars
    SECTION     data_clib

    PUBLIC      __upd7220_attr

; PPPFIIII
; paper, flash, ink
.__upd7220_attr       defb $6
