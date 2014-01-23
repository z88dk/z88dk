
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fputs(const char *s, FILE *stream)
;
; Write string to stream.  Return number of bytes written.
;
; ===============================================================

XLIB asm_fputs
XDEF asm_fputs_unlocked

LIB __stdio_send_output_raw_buffer_unchecked, error_mc, __stdio_verify_output
LIB __stdio_lock_acquire, __stdio_lock_release, error_enolck_mc, asm_strlen, l_utod_hl

asm_fputs:

   ; enter : ix = FILE *
   ;         hl = char *s
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = strlen(s)
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
   
   call asm_fputs_unlocked
   jp __stdio_lock_release

asm_fputs_unlocked:

   ; enter : ix = FILE *
   ;         hl = char *s
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = strlen(s)
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

   ld e,l
   ld d,h                      ; de = char *s
   
   call asm_strlen
   ret z                       ; if strlen(s) = 0
   
   ld c,l
   ld b,h                      ; bc = strlen(s)

   ex de,hl                    ; hl = char *s
   push bc                     ; save strlen(s)

   call __stdio_send_output_raw_buffer_unchecked

   pop hl                      ; hl = strlen(s)
   
   call l_utod_hl              ; saturate hl
   ret nc                      ; if no error
   
   jp error_mc
