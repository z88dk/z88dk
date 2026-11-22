; unsigned char glob_dos(const char *s, const char *pattern)

SECTION code_string

PUBLIC glob_dos_callee
PUBLIC l0_glob_dos_callee

EXTERN asm_glob_dos

glob_dos_callee:

   pop hl
   pop de
   ex (sp),hl

l0_glob_dos_callee:

   call asm_glob_dos
   
   ld hl,1
   ret nc                      ; return 1 for match
   
   dec l                       ; return 0 for no match
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _glob_dos_callee
defc _glob_dos_callee = glob_dos_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC __glob_dos_callee
defc __glob_dos_callee = glob_dos_callee
ENDIF

