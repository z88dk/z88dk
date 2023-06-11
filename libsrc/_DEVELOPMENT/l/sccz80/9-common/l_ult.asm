;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_ult
EXTERN l_compare_result

l_ult:

   ld a,d
	cp h
	jp nz, l_compare_result
	
	ld a,e
	cp l
	jp l_compare_result
