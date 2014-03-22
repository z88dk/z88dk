
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int putchar(int c)
;
; Write char to stdout.
;
; ===============================================================

XLIB asm_putchar

XREF __stdio_file_stdout

LIB asm0_putchar_unlocked
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_putchar:

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

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm0_putchar_unlocked
   jp __stdio_lock_release
