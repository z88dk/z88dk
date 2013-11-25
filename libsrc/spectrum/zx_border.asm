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
   ret
