
; long long strtoll( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtoll_callee

EXTERN asm_strtoll, l_store_64_dehldehl_mbc

_strtoll_callee:

   pop af
   pop bc
   
   exx
   
   pop hl
   pop de
   pop bc
      
   exx
   
   push af
   
   push ix
   push bc                     ; save result *
   
   exx
   
   call asm_strtoll
   
   pop bc                      ; bc = result *
   pop ix
   
   jp l_store_64_dehldehl_mbc  ; store result
