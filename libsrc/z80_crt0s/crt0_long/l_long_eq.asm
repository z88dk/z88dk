;       Z88 Small C+ Run Time Library 
;       Long functions
;

XLIB    l_long_eq

;
; dehl' == deHL
; set carry if true

.l_long_eq

   push hl
   push de
   exx
   ex (sp),hl
   or a
   sbc hl,de
   pop hl
   pop de
   scf
   ccf
   ret nz
   sbc hl,de
   ccf
   ret z
   or a
   ret
   
;        call    l_long_cmp
;        scf
;        ret   z
;	dec	hl
;	and	a
;        ret
