
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_border(uchar colour)
;
; Set border colour and avoid audible click.
;
; ===============================================================

XLIB asm_zx_border

asm_zx_border:

   ; enter :  l = border colour 0..7
   ;
   ; uses  : af, hl
   
   in a,($fe)
   and $40                     ; current beeper state
   
   rra
   rra
   or l
   
   out ($fe),a

   ; will have to fix this up
   ; once sound code is added

   ret
