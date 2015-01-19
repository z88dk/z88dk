
; sp1_InvUpdateStruct
; 01.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

PUBLIC sp1_InvUpdateStruct
EXTERN SP1V_UPDATELISTT

; FASTCALL

; Add struct_sp1_update to invalidated list so that it is
; drawn at next update.
;
; enter : hl = & struct sp1_update
; uses  : af, bc, de, hl

.sp1_InvUpdateStruct

   ld a,$80
   xor (hl)                  ; bit 7 of (hl) = 1 if already invalidated
   ret p                     ; return if update struct already invalidated
   ld (hl),a                 ; mark it as invalidated

   ex de,hl                  ; de = struct sp1_update needing invalidation
   ld hl,(SP1V_UPDATELISTT)  ; last struct sp_update in invalidated list
   ld bc,5
   add hl,bc
   ld (hl),d
   inc hl
   ld (hl),e                 ; store link to new one being invalidated
   ex de,hl
   ld (SP1V_UPDATELISTT),hl  ; new one becomes last in list
   add hl,bc
   ld (hl),0                 ; no next after this one in list

   ret
