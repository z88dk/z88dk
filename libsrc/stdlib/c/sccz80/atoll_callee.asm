
; long long atoll(const char *buf)

SECTION code_clib
SECTION code_stdlib

PUBLIC atoll_callee

EXTERN asm_atoll, l_store_64_dehldehl_mbc

atoll_callee:

   pop hl
   pop bc
   ex (sp),hl

   push ix
   push bc                     ; save result *
   
   call asm_atoll
   
   pop bc                      ; bc = result *
   pop ix
   
   jp l_store_64_dehldehl_mbc  ; store result

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _atoll_callee
defc _atoll_callee = atoll_callee
ENDIF
