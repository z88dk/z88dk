
; long long strtoll( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtoll_callee

EXTERN asm_strtoll, l_store_64_dehldehl_mbc

_strtoll_callee:

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   push af
   
   push ix                     ; save result *
   
   call asm_strtoll
   
   pop bc                      ; bc = result *
   jp l_store_64_dehldehl_mbc  ; store result
