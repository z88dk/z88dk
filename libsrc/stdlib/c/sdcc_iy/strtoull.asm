
; long long strtoull( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtoull

EXTERN asm_strtoull, l_store_64_dehldehl_mbc

_strtoull:

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push ix
   push af

   push ix                     ; save result *
   
   call asm_strtoull
   
   pop bc                      ; bc = result *
   jp l_store_64_dehldehl_mbc  ; store result
