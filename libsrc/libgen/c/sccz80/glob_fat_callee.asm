; unsigned char glob_fat(const char *s, const char *pattern)

SECTION code_string

PUBLIC glob_fat_callee
PUBLIC l0_glob_fat_callee

EXTERN asm_glob_fat

glob_fat_callee:

   pop hl
   pop de
   ex (sp),hl

l0_glob_fat_callee:

   call asm_glob_fat
   
   ld hl,1
   ret nc                      ; return 1 for match
   
   dec l                       ; return 0 for no match
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _glob_fat_callee
defc _glob_fat_callee = glob_fat_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC __glob_fat_callee
defc __glob_fat_callee = glob_fat_callee
ENDIF

