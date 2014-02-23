
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int puts(const char *s)
;
; Write string to stdout followed by a '\n'.
; Return number of bytes written.
;
; ===============================================================

XLIB asm_puts

LIB asm0_puts_unlocked
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_puts:

   ; enter : hl = char *s
   ;
   ; exit  : ix = FILE *stdout
   ;
   ;         success
   ;
   ;            hl = strlen(s) + 1
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
   
   call asm0_puts_unlocked
   jp __stdio_lock_release
