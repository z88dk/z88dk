
; long long strtoull( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtoull

EXTERN asm_strtoull, l_store_64_dehldehl_mbc

strtoull:

   pop af
   pop bc
   
   exx
   
   pop bc	;base
   pop de	;endptr
   pop hl	;nptr
   
   push bc
   push de
   push hl
   
   exx
   
   push bc
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
PUBLIC _strtoull
defc _strtoull = strtoull
ENDIF
