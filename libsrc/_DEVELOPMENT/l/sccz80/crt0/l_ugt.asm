;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION seg_code_sccz80

PUBLIC l_ugt

EXTERN l_ltu_hl_de

defc l_ugt = l_ltu_hl_de
