;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION seg_code_sccz80

PUBLIC l_sxt

EXTERN l_gchar_sxt

defc l_sxt = l_gchar_sxt
