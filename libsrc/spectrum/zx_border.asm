; 04.2006 aralbrec

; void __FASTCALL__ zx_border(uchar colour)

XLIB zx_border

zx_border:

   in a,(254)
   and $40
   
   rra
   rra
   or l
   
   out (254),a
   
   ld a,l
   add a,a
   add a,a
   add a,a
   ld (23624),a   ; system var bordcr is where we are storing border colour for now
   
   ret
