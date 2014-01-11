
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
XDEF asm_puts_unlocked

LIB asm_fputs_unlocked, l_utod_hl, error_mc
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc
XREF __FILE_STDOUT

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

   ld ix,__FILE_STDOUT

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm0_puts_unlocked
   jp __stdio_lock_release

asm_puts_unlocked:

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

   ld ix,__FILE_STDOUT

asm0_puts_unlocked:

   call asm_fputs_unlocked     ; output string
   ret c                       ; if error
   
   push hl                     ; save strlen(s)
   
   ld e,'\n'
   call asm_fputc_unlocked     ; output '\n'
   
   pop hl                      ; hl = strlen(s)
   jp c, error_mc              ; if error
   
   inc hl
   jp l_utod_hl                ; saturate hl
