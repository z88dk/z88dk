
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int getchar_unlocked(void)
;
; Read char from stdin.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_getchar_unlocked

EXTERN _stdin

EXTERN asm_fgetc_unlocked

asm_getchar_unlocked:

   ; enter : none
   ;
   ; exit  : ix unchanged
   ;
   ;         if success
   ;
   ;            hl = char
   ;            carry reset
   ;
   ;         if fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : all except ix

   push ix
   ld ix,(_stdin)
   call asm_fgetc_unlocked
   pop ix
   ret
