
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int getchar(void)
;
; Read char from stdin.
;
; ===============================================================

XLIB asm_getchar

LIB asm_fgetc

asm_getchar:

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
   jp asm_fgetc
