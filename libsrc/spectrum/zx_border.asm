; 04.2006 aralbrec

; void __FASTCALL__ zx_border(uchar colour)

XLIB zx_border

XREF snd_tick

.zx_border
   ld a,l
   out (254),a
   ld (snd_tick),a
   ret
