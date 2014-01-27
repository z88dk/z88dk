
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fgetc(FILE *stream)
;
; Read char from stream.
;
; ===============================================================

XLIB asm_fgetc
XDEF asm_fgetc_unlocked, asm_getc, asm_getc_unlocked
XDEF asm_getchar, asm_getchar_unlocked

LIB __stdio_verify_input, __stdio_recv_input_raw_getc, error_mc
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

XREF __FILE_STDIN

asm_getchar:

   ld ix,__FILE_STDIN

asm_fgetc:
asm_getc:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
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
   
   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm_fgetc_unlocked
   jp __stdio_lock_release

asm_getchar_unlocked:

   ld ix,__FILE_STDIN

asm_fgetc_unlocked:
asm_getc_unlocked:

   ; enter : ix = FILE *
   ;
   ; exit  : ix = FILE *
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

   call __stdio_verify_input   ; check that input from stream is ok
   ret c

   call __stdio_recv_input_raw_getc
   ret nc
   
   jp error_mc
