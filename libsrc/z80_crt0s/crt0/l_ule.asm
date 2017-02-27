;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION   code_crt0_sccz80
PUBLIC    l_ule
EXTERN    l_compare_result

;
; DE <= HL [unsigned]
; set carry if true

.l_ule

   ld a,h
   cp d
   ccf
   jp nz, l_compare_result
   ld a,l
   cp e
   ccf
   jp l_compare_result

;        call    l_ucmp
;        ret     c
;	ret	nz	;nc is set
;        scf
;        ret
