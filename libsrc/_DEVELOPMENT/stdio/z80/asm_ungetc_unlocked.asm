
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int ungetc_unlocked(int c, FILE *stream)
;
; Push char back onto stream.
;
; ===============================================================

XLIB asm_ungetc_unlocked

LIB __stdio_verify_input, error_mc

asm_ungetc_unlocked:

   ; enter : ix = FILE *
   ;         hl = char
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

   ld a,h
   or a
   jp nz, error_mc             ; if hl > 255

   bit 0,(ix+4)
   jp nz, error_mc             ; if ungetc already present

   ld (ix+6),l                 ; store ungetc
   
   ld a,(ix+3)
   and $88                     ; examine R and ERR flags
   cp $80                      ; open for reading and ERR = 0 ?
   jp nz, error_mc
   
   res 4,(ix+3)                ; clear eof
   
   bit 1,(ix+4)
   call z, __stdio_verify_input  ; if last operation was write, flush
   
   set 0,(ix+4)                ; ungetc is present
   ret
