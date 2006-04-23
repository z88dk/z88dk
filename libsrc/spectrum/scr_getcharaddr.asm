; 04.2006 aralbrec

; void *scr_getcharaddr(uchar row, uchar col)

XLIB scr_getcharaddr
LIB SCRgetcharaddr

.scr_getcharaddr

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   ex de,hl
   jp SCRgetcharaddr

; Computes the screen address of the top of a character square.
; (0,0) is located at the top left corner of the screen.
;
; enter: h = y coord 0..23, l = x coord 0..31
; exit : hl = screen address
; uses : af,hl
