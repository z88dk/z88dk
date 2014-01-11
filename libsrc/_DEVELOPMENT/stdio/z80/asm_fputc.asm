
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fputc(int c, FILE *stream)
;
; Write char on stream.
;
; ===============================================================

XLIB asm_fputc
XDEF asm_fputc_unlocked, asm_putc, asm_putc_unlocked

LIB error_mc, __stdio_verify_output, __stdio_send_output_raw_chars_unchecked
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc

asm_fputc:
asm_putc:

   ; enter : ix = FILE *
   ;          e = char c
   ;
   ; exit  : ix = FILE *
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
   ; uses  : all except ix

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm_fputc_unlocked
   jp __stdio_lock_release

asm_fputc_unlocked:
asm_putc_unlocked:

   ; enter : ix = FILE *
   ;          e = char c
   ;
   ; exit  : ix = FILE *
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
   ; uses  : all except ix

   call __stdio_verify_output  ; check that output on stream is ok
   jp c, error_mc              ; if output on stream not possible

   push de                     ; save char c
   
   ld bc,1
   call __stdio_send_output_raw_chars_unchecked

   pop hl                      ; l = char c
   
   ld h,0
   ret nc                      ; if no error
   
   jp error_mc
