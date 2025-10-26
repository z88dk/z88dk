
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC RIntersectRect16
EXTERN RIntersectIval16

; Returns the intersection of two 16-bit rectangles.
; Since rectangles can wrap across their 0-65535
; boundaries, the result of the intersection can be
; 0, 1, 2 or 3 rectangles.  This routine will return
; one result only.
;
; enter :  hl = rect #1 x coord
;          bc = rect #2 x coord
;          de = rect #2 width
;         de' = rect #1 width
;          ix = & struct r_Rect16 to hold result
; stack : rect #1 y coord, rect #1 height, rect #2 y coord, rect #2 height, ret addr
; exit  : carry flag set = intersection detected, stack cleared
;         and ix rectangle filled with result of intersection
; uses  : f, bc, de, hl, bc', de', hl'

.RIntersectRect16

   call RIntersectIval16
   jr nc, exitearly
   
   ld (ix+0),c
   ld (ix+1),b
   ld (ix+2),e
   ld (ix+3),d
   
   pop hl
   pop de
   pop bc
   exx
   pop de
   exx
   ex (sp),hl

   call RIntersectIval16
   ret nc
   
   ld (ix+4),c
   ld (ix+5),b
   ld (ix+6),e
   ld (ix+7),d
   ret
   
.exitearly

   pop de
   ld hl,8
   add hl,sp
   ld sp,hl
   ex de,hl
   or a
   jp (hl)

