; unsigned char glob_fat(const char *s, const char *pattern)

SECTION code_string

PUBLIC glob_fat

EXTERN l0_glob_fat_callee

glob_fat:

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   ELSE
   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   ENDIF
   
   jp l0_glob_fat_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _glob_fat
defc _glob_fat = glob_fat
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___glob_fat
defc ___glob_fat = glob_fat
ENDIF

