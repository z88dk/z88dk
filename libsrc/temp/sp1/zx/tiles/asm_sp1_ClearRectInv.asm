; void sp1_ClearRectInv(struct sp1_Rect *r, uchar colour, uchar tile, uchar rflag)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_ClearRectInv

EXTERN asm_sp1_GetUpdateStruct, asm_sp1_ClearRect, SP1CRSELECT, l_jpix

asm_sp1_ClearRectInv:

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
 
   and $07
   ret z                          ; ret if all flags reset

   push hl
   call SP1CRSELECT               ; ix = address of operation code (depending on flags passed in)
   call asm_sp1_GetUpdateStruct   ; hl = & struct update
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
