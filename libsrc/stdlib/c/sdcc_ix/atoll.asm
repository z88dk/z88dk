
; long long atoll(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC _atoll

EXTERN asm_atoll, l_store_64_dehldehl_mbc

_atoll:

   pop af
   pop bc
   pop hl

   push hl
   push bc
   push af

   push ix
   push bc                     ; save result *
   
   call asm_atoll
   
   pop bc                      ; bc = result *
   pop ix
   
   jp l_store_64_dehldehl_mbc  ; store result
