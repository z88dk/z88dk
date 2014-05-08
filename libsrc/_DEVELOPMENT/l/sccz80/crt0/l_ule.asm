;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

                PUBLIC    l_ule

;
; DE <= HL [unsigned]
; set carry if true

.l_ule

   ld a,h
   cp d
   ccf
   ret nz
   ld a,l
   cp e
   ccf
   ret

;        call    l_ucmp
;        ret     c
;	ret	nz	;nc is set
;        scf
;        ret
