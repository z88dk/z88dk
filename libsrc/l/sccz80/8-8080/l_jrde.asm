
SECTION code_clib
SECTION code_l

PUBLIC l_jrde

; 8080 relative 16-bit jump
; call with twos complement offset in de
;
;       ld de,destination-origin
;       call l_jrde
;   .origin

l_jrde:

   ex (sp),hl
   add hl,de
   ex (sp),hl
   ret
