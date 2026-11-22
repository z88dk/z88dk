
SECTION code_clib
SECTION code_stdlib

PUBLIC __ldiv_store

EXTERN l_long_store_mhl

__ldiv_store:

   ld c,l
   ld b,h
   
   pop hl
   
   call l_long_store_mhl       ; ldiv_t -> quot = numer / denom
   inc hl

   push hl
   
   ld l,c
   ld h,b
   
   exx
   
   ld c,l
   ld b,h
   
   pop hl
   
   call l_long_store_mhl       ; ldiv_t -> rem = numer % denom

   ld l,c
   ld h,b
   
   exx
   ret
