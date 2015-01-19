; void __CALLEE__ sp1_ClearRect_callee(struct sp1_Rect *r, uchar tile, uchar rflag)
; 01.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

PUBLIC sp1_ClearRect_callee
PUBLIC ASMDISP_SP1_CLEARRECT_CALLEE, ASMDISP_SP1CRSELECT

EXTERN sp1_GetUpdateStruct_callee, l_jpix
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE, SP1V_DISPWIDTH

.sp1_ClearRect_callee

   pop af
   pop bc
   pop hl
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
; and changing tile depending on flags.
;
; enter :  d = row coord
;          e = col coord
;          b = width
;          c = height
;          l = tile
;          a = bit 0 set for tiles, bit 1 set for tile colours (ignored), bit 2 set for sprites
; uses  : af, bc, de, hl, af', ix

.SP1ClearRect
 
   and $07
   ret z                          ; ret if all flags reset

   push hl
   call SP1CRSELECT               ; ix = address of operation code (depending on flags passed in)
   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE  ; hl = & struct update
   pop de                         ; e = tile

.rowloop

   push bc                        ; save b = width
   push hl                        ; save update position

.colloop

   call l_jpix                    ; apply operation on hl, advance hl to next struct sp1_update to the right
   djnz colloop

   pop hl
   ld bc,9*SP1V_DISPWIDTH
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

   defw OPTION0, OPTION1, OPTION2, OPTION1
   defw OPTION4, OPTION5, OPTION4, OPTION5

.OPTION0                                             ; no flags

   ld a,9
   add a,l
   ld l,a
   ret nc
   inc h
   ret
   
.OPTION1                                             ; tile only

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

.OPTION2                                             ; colour only - NOP

   ld a,9
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
   push hl

   ld a,(hl)                                         ; if no sprites in this tile, done
   or a
   jr z, done

   ld (hl),0                                         ; mark no sprites in this tile
   inc hl
   ld l,(hl)
   ld h,a

.loop                                                ; hl = & struct sp1_cs.ss_draw

   dec hl
   dec hl
   dec hl
   dec hl                                            ; hl = & struct sp1_cs.update

   ld (hl),0                                         ; remove from sprite char from tile
   ld a,16
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
   ld (hl),e
   inc hl
   ld (hl),0
   dec hl
   dec hl
   jp OPTION4

DEFC ASMDISP_SP1_CLEARRECT_CALLEE = # asmentry - sp1_ClearRect_callee
DEFC ASMDISP_SP1CRSELECT = # SP1CRSELECT - sp1_ClearRect_callee
