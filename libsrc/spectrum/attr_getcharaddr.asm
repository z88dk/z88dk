; 04.2006 aralbrec

; void *attr_getcharaddr(uchar row, uchar col)

XLIB attr_getcharaddr
LIB ATTRgetcharaddr

.attr_getcharaddr

   ld hl,2
   add hl,sp
   ld a,(hl)
   inc hl
   inc hl
   ld h,(hl)
   ld l,a
   jp ATTRgetcharaddr

; enter :  h = y coord (0..23)
;          l = x coord (0..31)
; exit  : hl = attribute address
; uses  : af, hl

