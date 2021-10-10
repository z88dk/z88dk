
; long long strtoll( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtoll_callee

EXTERN asm_strtoll, l_store_64_dehldehl_mbc

strtoll_callee:

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
   
   call asm_strtoll
   
   pop bc                      ; bc = result *
   pop ix
   
   jp l_store_64_dehldehl_mbc  ; store result

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtoll_callee
defc _strtoll_callee = strtoll_callee
ENDIF
