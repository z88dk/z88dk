
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int fputs_unlocked(const char *s, FILE *stream)
;
; Write string to stream.  Return number of bytes written.
;
; ===============================================================

XLIB asm_fputs_unlocked

LIB asm_strlen, l_utod_hl
LIB __stdio_send_output_raw_buffer_unchecked, error_mc, __stdio_verify_output

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
   ret c

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
