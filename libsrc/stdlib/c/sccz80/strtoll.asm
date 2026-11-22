
; long long strtoll( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtoll

EXTERN asm_strtoll, l_store_64_dehldehl_mbc

strtoll:

   pop af	;return address
   pop bc	;place to stuff
   
   exx
   
   pop bc	;base
   pop de	;endptr
   pop hl	;nptr
   
   push hl
   push de
   push bc
   
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

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtoll
defc _strtoll = strtoll
ENDIF
