
SECTION code_clib
SECTION code_l

PUBLIC l_jrbc

; 8080 relative 16-bit jump
; call with twos complement offset in bc
;
;       ld bc,destination-origin
;       call l_jrbc
;   .origin

l_jrbc:

   ex (sp),hl
   add hl,bc
   ex (sp),hl
   ret
