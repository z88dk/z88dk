
; ===============================================================
; aralbrec - Nov 2013
; ===============================================================

XLIB __fzx_char_metrics

__fzx_char_metrics:

   ; enter : ix = struct fzx_font *
   ;          a = char
   ;
   ; exit  : hl = struct fzx_char * + 2
   ;          a = shift_width_1
   ;         bc = kern_offset
   ;
   ;         carry flag set if char unprintable
   ;
   ; uses  : af, bc, hl
   
   cp 32                       ; printable?
   ret c
   
   dec a
   cp (ix+2)                   ; compare to last defined char code in font
   ccf
   ret c
   
   sub 30                      ; a = char - 31
   ld l,a
   ld h,0
   ld c,l
   ld b,h
   add hl,hl
   add hl,bc
   ld c,ixl
   ld b,ixh
   add hl,bc                   ; hl = struct fzx_char *fzc
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = kern_offset
   inc hl
   ld a,(hl)                   ; a = shift_width_1
  
   ret
