
; long long strtoull( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtoull_callee

EXTERN asm_strtoull, l_store_64_dehldehl_mbc

_strtoull_callee:

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
   
   call asm_strtoull
   
   pop bc                      ; bc = result *
   pop ix
   
   jp l_store_64_dehldehl_mbc  ; store result
