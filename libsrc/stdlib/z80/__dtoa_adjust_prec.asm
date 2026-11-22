
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoa_adjust_prec

__dtoa_adjust_prec:

   ; e = precision
   ; c = signficant digits reported by math lib
   
   ld a,e
   
   inc a
   ret nz                      ; if precision != 255
   
   ld e,c
   ret
