
; ===============================================================
; aralbrec - Nov 2013
; ===============================================================

SECTION code_font
SECTION code_font_fzx

PUBLIC __fzx_char_struct

__fzx_char_struct:

   ; enter :  a = char
   ;         hl = struct fzx_font *
   ;
   ; exit  : hl = struct fzx_char *
   ;
   ; uses  : af, bc, hl

   cp 32
   jr nc, char_over
   
   ld a,'?'

char_over:

   inc hl
   inc hl                      ; hl = & fzx_char.last_char
   
   dec a
   cp (hl)
   jr c, char_ok
   
   ld a,'?'-1

char_ok:

   sub 31
   
   ld c,a
   ld b,0
   
   inc hl                      ; hl = & first fzx_char
   
   add hl,bc
   add hl,bc
   add hl,bc
   
   ret
