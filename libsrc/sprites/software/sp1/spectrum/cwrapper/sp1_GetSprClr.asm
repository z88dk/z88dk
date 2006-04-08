
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_GetSprClr(uchar **sprsrc, struct sp1_ap *dest, uchar n)

XLIB sp1_GetSprClr
LIB SP1GetSprClr

.sp1_GetSprClr

   ld hl,2
   add hl,sp
   ld b,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   jp SP1GetSprClr

; enter :  b = number of colour pairs to copy (size of sprite in tiles)
;         de = struct sp1_ap[] dest array of colour pairs
;         hl = array of sprite colour addresses (all point at struct sp1_cs.attr_mask)
; uses  : f, bc, de, hl

