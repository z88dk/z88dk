
; ===============================================================
; Jan 2014
; ===============================================================
; 
; char *strerror(int errnum)
;
; Return string message corresponding to errnum.
;
; ===============================================================

XLIB asm_strerror

LIB error_strings, error_string_default, __str_locate_nul

asm_strerror:

   ; enter : hl = errnum
   ;
   ; exit  : hl = char *message
   ;         carry set if errnum was not found
   ;
   ; uses  : af, bc, e, hl
   
   ld a,h
   or a
   jr nz, use_default
   
   ld e,l
   ld hl,error_strings
   
search_loop:

   ld a,(hl)
   or a
   jr z, use_default           ; if errnum not found
   
   cp e
   inc hl
   
   ret z                       ; if found string
   
   call __str_locate_nul
   inc hl
   
   jp search_loop

use_default:

   ld hl,error_string_default
   
   scf
   ret

