
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int putchar_unlocked(int c)
;
; Write char to stdout.
;
; ===============================================================

XLIB asm_putchar_unlocked
XDEF asm0_putchar_unlocked

LIB asm_fputc_unlocked

asm_putchar_unlocked:

   ; enter :  l = char c
   ;
   ; exit  : ix = FILE *stdout
   ;
   ;         success
   ;
   ;            hl = char c
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all

   ld ix,(__stdio_file_stdout)

asm0_putchar_unlocked:
   
   ld e,l
   jp asm_fputc_unlocked
