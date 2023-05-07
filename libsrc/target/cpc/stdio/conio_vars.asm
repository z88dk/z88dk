


        SECTION data_clib
        PUBLIC __cpc_mode
        PUBLIC __cpc_ink0
        PUBLIC __cpc_paper0
        PUBLIC __cpc_ink1
        PUBLIC __cpc_paper1

.__cpc_mode     defb    1
; Mode 0 equivalents of ink/paper
.__cpc_ink0     defb    @10001000
.__cpc_paper0   defb    @00000000
; And equivalents for mode 1
.__cpc_ink1     defb    @10001000
.__cpc_paper1   defb    @00000000

