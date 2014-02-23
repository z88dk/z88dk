
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int getchar_unlocked(void)
;
; Read char from stdin.
;
; ===============================================================

XLIB asm_getchar_unlocked

LIB asm_fgetc_unlocked

asm_getchar_unlocked:

   ; enter : none
   ;
   ; exit  : ix = FILE *stdin
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
   ; uses  : all

   ld ix,(__stdio_file_stdin)
   jp asm_fgetc_unlocked
