
; long long strtoll( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtoll

EXTERN asm_strtoll, l_store_64_dehldehl_mbc

_strtoll:

   pop af
   pop bc
   
   exx
   
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   
   exx
   
   push bc
   push af
   
   push ix
   push bc                     ; save result *
   
   exx
   
   call asm_strtoll
   
   pop bc                      ; bc = result *
   pop ix
   
   jp l_store_64_dehldehl_mbc  ; store result
