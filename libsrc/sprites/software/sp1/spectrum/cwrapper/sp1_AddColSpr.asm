
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; uint sp1_AddColSpr(struct sp1_ss *s, uchar type, uchar *graphic, uchar plane)

XLIB sp1_AddColSpr
LIB SP1AddColSpr

.sp1_AddColSpr

   ld hl,9
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld ixl,e
   ld ixh,d
   dec hl
   ld e,(hl)
   dec hl
   ld b,(hl)
   dec hl
   ld c,(hl)
   dec hl
   dec hl
   ld d,(hl)
   ex de,hl
   call SP1AddColSpr
   ld hl,0
   ret nc
   inc l
   ret

; enter : ix = struct sp1_ss *
;          h = plane
;          l = type (index into table), bit 7 = 1 for occluding
;         bc = graphic definition for column
; uses  : af, bc, de, hl, bc', de', hl', iy
; exit  : carry flag for success, else memory allocation failed

