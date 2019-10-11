        SECTION code_driver

        GLOBAL  MODE_TABLE
        GLOBAL  tmode
        GLOBAL  tmode_out
        GLOBAL  gmode
        GLOBAL  tmode_inout
MODE_TABLE:
        jp      tmode_out
        nop
        jp      gmode
        defb    0
        jp      tmode           ;MODE 2 = text
        nop
        jp      tmode_inout     ;MODE 3 = text/input
        nop
