
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_number_tail_longlong

EXTERN l_testzero_64_dehldehl, l_store_64_dehldehl_mbc

__stdio_scanf_number_tail_longlong:

   ; enter :   bc = longlong *p
   ;         dehl'dehl = longlong
   ;         stack = chars consumed, items assigned
   ;
   ;         carry flag state set by strtoll / strtoull
   ;
   ;            carry reset, number is valid
   ;
   ;            carry set, number valid only if dehl'dehl != 0
   
   jr nc, number_valid
   
   call l_testzero_64_dehldehl
   jr z, number_invalid

number_valid:

   ; enter :   bc = longlong *p
   ;         dehl'dehl = longlong

   ; WRITE LONGLONG TO LONGLONG *P
   
   ld a,b
   or c
   
   call nz, l_store_64_dehldehl_mbc  ; if assignment not suppressed
   
   pop hl                      ; restore items assigned
   pop de                      ; restore chars consumed
   
   jr z, skip_inc              ; if assignment suppressed
   
   inc hl                      ; items assigned++

skip_inc:

   exx
   ret

number_invalid:

   pop hl                      ; restore items assigned
   pop de                      ; restore chars consumed

   scf
   
   exx
   ret
