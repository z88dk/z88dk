
; long long strtoull( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtoull_callee

EXTERN asm_strtoull, l_store_64_dehldehl_mbc

_strtoull_callee:

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   push af
   
   push ix                     ; save result *
   
   call asm_strtoull
   
   pop bc                      ; bc = result *
   jp l_store_64_dehldehl_mbc  ; store result
