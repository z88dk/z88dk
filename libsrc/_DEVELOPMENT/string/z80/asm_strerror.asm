
; ===============================================================
; Jan 2014
; ===============================================================
; 
; char *strerror(int errnum)
;
; Return string message corresponding to errnum.
;
; ===============================================================

SECTION seg_code_string

PUBLIC asm_strerror

EXTERN __error_strings, __error_string_default, __str_locate_nul

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
   ld hl,__error_strings
   
   ld a,(hl)
   
search_loop:
   
   cp e
   inc hl
   
   ret z                       ; if found string
   
   call __str_locate_nul
   inc hl
   
   ld a,(hl)
   or a
   jr nz, search_loop          ; if end of strings not met

use_default:

   ld hl,__error_string_default
   
   scf
   ret

