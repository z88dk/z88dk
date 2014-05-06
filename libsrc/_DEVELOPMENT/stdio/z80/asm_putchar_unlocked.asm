
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

XREF __stdio_file_stdout

LIB asm0_fputc_unlocked

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   LIB __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0_putchar_unlocked:
   
   ld e,l
   jp asm0_fputc_unlocked
