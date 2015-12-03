;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_cm_bc

EXTERN l_neg_bc

l_cm_bc:

    ; bc = abs(bc)
    
    bit 7,b
    ret z
    
    jp l_neg_bc
