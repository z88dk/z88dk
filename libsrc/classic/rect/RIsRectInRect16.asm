
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC RIsRectInRect16
EXTERN RIsIvalInIval16

; Determine if two 16-bit rectangles intersect.  Rectangles
; can wrap across 0-65535 boundaries.
;
; enter :  hl = rect #1 x coord
;          bc = rect #2 x coord
;          de = rect #2 width
;         de' = rect #1 width
; stack : rect #1 y coord, rect #1 height, rect #2 y coord, rect #2 height, ret addr
; exit  : carry flag set = intersection detected, stack cleared
; uses  : f, bc, de, hl, bc', de', hl'

.RIsRectInRect16

   call RIsIvalInIval16
   jp c, maybe
   
   pop de
   ld hl,8
   add hl,sp
   ld sp,hl
   ex de,hl
   or a
   jp (hl)

.maybe

   pop hl
   pop de
   pop bc
   exx
   pop de
   exx
   ex (sp),hl

   jp RIsIvalInIval16
