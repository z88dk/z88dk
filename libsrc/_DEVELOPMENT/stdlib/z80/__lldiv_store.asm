
SECTION code_clib
SECTION code_stdlib

PUBLIC __lldiv_store

EXTERN l_store_64_dehldehl_mbc

__lldiv_store:

   ; dehl'dehl = remainder
   ; stack.numer = quotient
   
   ld c,(ix-2)
   ld b,(ix-1)                 ; bc = & lldivu_t->rem
   
   call l_store_64_dehldehl_mbc  ; store remainder
   
   ; bc = & lldivu_t->quot
   
   push ix
   pop hl                      ; hl = & quotient
   
   ld e,c
   ld d,b                      ; de = & lldivut_t->quot
   
   ld bc,8
   ldir                        ; store quotient

   ret
