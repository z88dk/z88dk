
; sp1_ValUpdateStruct
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_ValUpdateStruct

; FASTCALL

; Validate struct_sp1_update so that it is not drawn in
; the next update.  You must make sure that this tile is
; not invalidated by any call before the next update or
; portions of the screen may become inactive (ie will never
; be drawn during update).
;
; enter : HL = & struct sp1_update
; uses  : none

.sp1_ValUpdateStruct

   bit 6,(hl)         ; must not validate removed update chars
   ret nz
   res 7,(hl)
   ret
