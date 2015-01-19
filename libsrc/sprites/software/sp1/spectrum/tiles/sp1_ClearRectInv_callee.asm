; void __CALLEE__ sp1_ClearRectInv_callee(struct sp1_Rect *r, uchar colour, uchar tile, uchar rflag)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_ClearRectInv_callee
PUBLIC ASMDISP_SP1_CLEARRECTINV_CALLEE

EXTERN sp1_GetUpdateStruct_callee, sp1_ClearRect_callee, l_jpix
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE, ASMDISP_SP1CRSELECT
EXTERN SP1V_DISPWIDTH, SP1V_UPDATELISTT

.sp1_ClearRectInv_callee

   pop af
   pop bc
   pop hl
   pop de
   ld h,e
   pop de
   push af
   ld a,c
   push hl
   ex de,hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl   

.asmentry

; Clear a rectangular area on screen, erasing sprites,
; changing tile and changing colour depending on flags.
; Invalidate the area so that it is drawn in the next update.
;
; enter :  d = row coord
;          e = col coord
;          b = width
;          c = height
;          h = attr
;          l = tile
;          a = bit 0 set for tiles, bit 1 set for tile colours, bit 2 set for sprites
; uses  : af, bc, de, hl, af', ix, iy

.SP1ClearRectInv
 
   and $07
   ret z                          ; ret if all flags reset

   push hl
   call sp1_ClearRect_callee + ASMDISP_SP1CRSELECT  ; ix = address of operation code (depending on flags passed in)
   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE  ; hl = & struct update
   pop de                         ; d = attr, e = tile
   
   ld iy,(SP1V_UPDATELISTT)       ; iy = last struct sp1_update in draw queue

.rowloop

   push bc                        ; save b = width
   push hl                        ; save update position

.colloop

   ld a,$80
   xor (hl)
   jp p, alreadyinv               ; if this update struct already invalidated, skip ahead
   ld (hl),a

   ld (iy+6),h                    ; store link in last invalidated update struct to this struct update
   ld (iy+7),l
   
   ld a,l                         ; make this update struct the last one in invalidated list
   ld iyl,a                       ; "ld iyl,l" is likely taken as "ld iyl,iyl"
   ld a,h
   ld iyh,a
   
.alreadyinv

   call l_jpix                    ; apply operation on hl, advance hl to next struct sp1_update to the right
   djnz colloop

   pop hl
   ld bc,10*SP1V_DISPWIDTH
   add hl,bc
   pop bc
   
   dec c
   jp nz, rowloop

   ld (iy+6),0
   ld (SP1V_UPDATELISTT),iy
   ret

DEFC ASMDISP_SP1_CLEARRECTINV_CALLEE = # asmentry - sp1_ClearRectInv_callee
