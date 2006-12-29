
; uint sp1_GetUpdateListLength(void)
; 11.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB sp1_GetUpdateListLength
XREF SP1V_UPDATELISTH

; Return the number of struct sp1_updates in the
; current update list.
;
; exit  : hl = number in list
; uses  : af, bc, de, hl

.sp1_GetUpdateListLength

   ld hl,(SP1V_UPDATELISTH+6)
   ld de,0
   ld bc,6
   ld a,h

.loop

   or a
   jr z, exitloop
   
   inc de
   add hl,bc
   ld a,(hl)
   inc hl
   ld l,(hl)
   ld h,a
   jp loop

.exitloop

   ex de,hl
   ret
