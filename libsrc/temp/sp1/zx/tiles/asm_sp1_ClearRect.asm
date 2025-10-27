; void sp1_ClearRect(struct sp1_Rect *r, uchar colour, uchar tile, uchar rflag)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_ClearRect
PUBLIC SP1CRSELECT

EXTERN asm_sp1_GetUpdateStruct, l_jpix

asm_sp1_ClearRect:

; Clear a rectangular area on screen, erasing sprites,
; changing tile and changing colour depending on flags.
;
; enter :  d = row coord
;          e = col coord
;          b = width
;          c = height
;          h = attr
;          l = tile
;          a = bit 0 set for tiles, bit 1 set for tile colours, bit 2 set for sprites
; uses  : af, bc, de, hl, af', ix
 
   and $07
   ret z                          ; ret if all flags reset

   push hl
   call SP1CRSELECT               ; ix = address of operation code (depending on flags passed in)
   call asm_sp1_GetUpdateStruct   ; hl = & struct update
   pop de                         ; d = attr, e = tile

.rowloop

   push bc                        ; save b = width
   push hl                        ; save update position

.colloop

   call l_jpix                    ; apply operation on hl, advance hl to next struct sp1_update to the right
   djnz colloop

   pop hl
   ld bc,10*SP1V_DISPWIDTH
   add hl,bc
   pop bc
   
   dec c
   jp nz, rowloop

   ret

.SP1CRSELECT

   add a,a
   add a,seltbl%256
   ld l,a
   ld h,seltbl/256
   jp nc, noinc0
   inc h
   
.noinc0

   ld a,(hl)
   ld ixl,a
   inc hl
   ld a,(hl)
   ld ixh,a

   ret
   
.seltbl

   defw OPTION0, OPTION1, OPTION2, OPTION3
   defw OPTION4, OPTION5, OPTION6, OPTION7

.OPTION0                                             ; no flags

   ld a,10
   add a,l
   ld l,a
   ret nc
   inc h
   ret
   
.OPTION1                                             ; tile only

   inc hl
   inc hl
   ld (hl),e
   inc hl
   ld (hl),0
   ld a,7
   add a,l
   ld l,a
   ret nc
   inc h
   ret

.OPTION2                                             ; colour only

   inc hl
   ld (hl),d
   ld a,9
   add a,l
   ld l,a
   ret nc
   inc h
   ret

.OPTION3                                             ; tile and colour

   inc hl
   ld (hl),d
   inc hl
   ld (hl),e
   inc hl
   ld (hl),0
   ld a,7
   add a,l
   ld l,a
   ret nc
   inc h
   ret

.OPTION4                                             ; sprite only

   ld a,(hl)
   and $c0
   inc a                                             ; keep bit 6:7 flag, occluding spr count reset to 1
   ld (hl),a
   inc hl
   inc hl
   inc hl
   inc hl
   push hl

   ld a,(hl)                                         ; if no sprites in this tile, done
   or a
   jr z, done

   ld (hl),0                                         ; mark no sprites in this tile
   inc hl
   ld l,(hl)
   ld h,a

.loop                                                ; hl = & struct sp1_cs.attr_mask

   dec hl
   dec hl
   dec hl
   dec hl                                            ; hl = & struct sp1_cs.update

   ld (hl),0                                         ; remove from sprite char from tile
   ld a,18
   add a,l
   ld l,a
   jp nc, noinc1
   inc h

.noinc1                                              ; hl = & struct sp1_cs.next_in_upd

   ld a,(hl)
   or a
   jr z, done

   inc hl
   ld l,(hl)
   ld h,a
   jp loop

.done

   pop hl
   ld a,6
   add a,l
   ld l,a
   ret nc
   inc h
   ret

.OPTION5                                             ; sprite and tile

   inc hl
   inc hl
   ld (hl),e
   inc hl
   ld (hl),0
   dec hl
   dec hl
   dec hl
   jp OPTION4

.OPTION6                                             ; sprite and colour

   inc hl
   ld (hl),d
   dec hl
   jp OPTION4

.OPTION7                                             ; sprite, tile and colour

   inc hl
   ld (hl),d
   inc hl
   ld (hl),e
   inc hl
   ld (hl),0
   dec hl
   dec hl
   dec hl
   jp OPTION4
