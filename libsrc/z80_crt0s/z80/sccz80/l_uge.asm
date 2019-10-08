;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm
;
;       13/5/99 djm, inverted carry conditions

SECTION   code_crt0_sccz80
PUBLIC    l_uge
EXTERN    l_compare_result

;
; DE >= HL [unsigned]
; set carry if true


.l_uge

   ld a,d
   cp h
   ccf
   jp nz, l_compare_result
   ld a,e
   cp l
   ccf
   jp l_compare_result

;        call    l_ucmp
;        ccf
;	ret

