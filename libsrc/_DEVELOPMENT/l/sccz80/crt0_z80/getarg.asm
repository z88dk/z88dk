;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       This routine is needed by printf & scanf etc
;       Added   10/10/98 djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC getarg

EXTERN l_sxt

defc getarg = l_sxt
