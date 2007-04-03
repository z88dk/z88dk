;       Z88 Small C+ Run Time Library 
;       Long functions
;

XLIB    l_long_ne

;
; DEhl' != deHL
; set carry if result true


.l_long_ne

   push hl
   push de
   exx
   ex (sp),hl
   or a
   sbc hl,de
   pop hl
   pop de
   scf
   ret nz
   sbc hl,de
   ld a,h
   and l
   inc a
   ret z
   scf
   ret


;        call    l_long_cmp
;        scf
;        ret   nz
;        ccf
;        dec   hl
;        ret
