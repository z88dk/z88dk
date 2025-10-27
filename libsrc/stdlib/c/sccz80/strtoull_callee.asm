
; long long strtoull( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtoull_callee

EXTERN asm_strtoull, l_store_64_dehldehl_mbc

strtoull_callee:

   pop af
   pop bc
   
   exx
   
   pop bc	;base
   pop de	;endptr
   pop hl	;nptr
      
   exx
   
   push af
   
   push ix
   push bc                     ; save result *
   
   exx
   
   call asm_strtoull
   
   pop bc                      ; bc = result *
   pop ix
   
   jp l_store_64_dehldehl_mbc  ; store result

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtoull_callee
defc _strtoull_callee = strtoull_callee
ENDIF
