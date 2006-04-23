; 04.2006 aralbrec

; void *scr_getscrnaddr(uint xcoord, uchar ycoord, uchar *mask)

XLIB scr_getscrnaddr
LIB SCRgetscrnaddr

.scr_getscrnaddr

   ld hl,6
   add hl,sp
   ld e,(hl)
   dec hl
   dec hl
   ld d,(hl)
   dec hl
   push hl
   ex de,hl
   ld a,h
   call SCRgetscrnaddr
   ex de,hl
   ex (sp),hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   ld a,b
   ld (de),a
   pop hl
   ret

; Computes the screen address given a valid pixel coordinate.
; (0,0) is located at the top left corner of the screen.
;
; enter: a = h = y coord
;        l = x coord
; exit : de = screen address, b = pixel mask
; uses : af, b, de, hl
