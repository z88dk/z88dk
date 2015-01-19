; SP1DrawUpdateStruct
; 02.2008 aralbrec, Sprite Pack v3.0
; zx81 hi-res version

PUBLIC SP1DrawUpdateStruct
PUBLIC SP1RETSPRDRAW
EXTERN SP1V_PIXELBUFFER, SP1V_TILEARRAY

; Draw the tile described by the indicated update struct
; to screen -- not meant to be called directly, just a
; code fragment called from other functions.
;
; enter :  b = # occluding sprites in char + 1
;         hl = & struct sp1_update
; exit  : bc = & next sp1_update in update list

.haveocclspr                 ; there are occluding sprites in this char

   ;  b = # occl sprites
   ; de = 16-bit tile code
   ; hl = & update.slist

   inc hl
   push hl
   dec hl
   push de
   jp skiplp

.skipthisone                 ; don't need to draw this sprite

   ld hl,13
   add hl,de

   ; stack = & update.slist + 1b, 16-bit tile code
   
.skiplp

   ld d,(hl)
   inc hl
   ld e,(hl)                 ; de = & sp1_cs.ss_draw
   dec de                    ; de = & sp1_cs.type
   ld a,(de)
   rla                       ; is this an occluding sprite?
   jr nc, skipthisone        ; if no skip it
   
   djnz skipthisone          ; if haven't seen all occl sprites yet, skip this one too

   ; de = & sp1_cs.type
   ;  a = sprite type rotated left one bit
   ; stack = & update.slist + 1b, 16-bit tile code

   and $20                   ; type has been rot left one bit, check orig bit 4 if should clear pixel buff
   pop hl                    ; hl = 16-bit tile code
   jr z, noclearbuff
   
   ; clear pixel buffer
   ; de = & sp1_cs.type
   ; hl = 16-bit tile code
   ; stack = & update.slist + 1b

   ld a,h
   or a
   jr nz, havetiledef2       ; if MSB of tile code != 0 we have & tile definition already
   
   ld h,SP1V_TILEARRAY/256
   ld a,(hl)
   inc h
   ld h,(hl)
   ld l,a
   
   ; hl = & tile definition
   
.havetiledef2
 
   push de
   ld de,SP1V_PIXELBUFFER
   ldi                       ; copy background tile graphics into pixel buffer
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ld a,(hl)
   ld (de),a
   pop de

.noclearbuff

   ; de = & sp1_cs.type
   ; stack = & update.slist + 1b

   ex de,hl
   inc hl                    ; hl = & sp1_cs.ss_draw
   jp spritedraw

.SP1DrawUpdateStruct

   ;  b = # occluding sprites in char + 1
   ; hl = & struct sp1_update

   inc hl                    ; hl = & update.tile
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   
   djnz haveocclspr          ; deal with case of occluding sprites
   
   ex de,hl                  ; hl = 16-bit tile code, de = & update.slist

   ld a,h
   or a
   jr nz, havetiledef        ; if MSB of tile code != 0 we have & tile definition already
   
   ld h,SP1V_TILEARRAY/256
   ld a,(hl)
   inc h
   ld h,(hl)
   ld l,a
   
   ; hl = & tile definition
   ; de = & update.slist
   
.havetiledef

   ld a,(de)
   or a
   jr z, drawtileonly        ; if there are no sprites in this char, just draw background tile
   
   push de                   ; save & update.slist
   ld de,SP1V_PIXELBUFFER
   ldi                       ; copy background tile graphics into pixel buffer
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ld a,(hl)
   ld (de),a
   pop hl                    ; hl = & update.slist

   ld a,(hl)
   inc hl
   push hl                   ; save & update.slist + 1b
   
.spritedrawlp

   ; hl = & sp1_cs.next_in_upd + 1b
   ;  a = MSB of next sp1_cs.ss_draw
   
   ld l,(hl)
   ld h,a                    ; hl = & sp1_cs.ss_draw
   
.spritedraw

   ; hl = & sp1_cs.ss_draw
   ; stack = & update.slist + 1b
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ex de,hl                  ; de = & sp1_cs.draw_code, hl = & sp1_ss.draw_code
   
   jp (hl)                   ; jump into sp1_ss's draw code

.drawtileonly

   ; hl = & tile definition
   ; de = & update.slist

   ex de,hl
   inc hl
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)                 ; bc = & next sp1_update in update list
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

   ; hl = screen address for char
   ; de = tile definition
   
   push bc
   ld bc,32
   
   ld a,(de)                 ; copy tile directly to screen
   ld (hl),a
   add hl,bc
   inc de
   
   ld a,(de)
   ld (hl),a
   add hl,bc
   inc de

   ld a,(de)
   ld (hl),a
   add hl,bc
   inc de

   ld a,(de)
   ld (hl),a
   add hl,bc
   inc de

   ld a,(de)
   ld (hl),a
   add hl,bc
   inc de

   ld a,(de)
   ld (hl),a
   add hl,bc
   inc de

   ld a,(de)
   ld (hl),a
   add hl,bc
   inc de

   ld a,(de)
   ld (hl),a

   pop bc
   
   ; bc = & next sp1_update in update list

   ret

.SP1RETSPRDRAW               ; return here after sprite char drawn

   pop hl                    ; hl = & sp1_cs.next_in_upd (pushed by sprite draw code)
   ld a,(hl)
   inc hl
   or a
   jr nz, spritedrawlp       ; if there are more sprites in this char go draw them
   
   pop hl                    ; hl = & update.slist + 1b

.donesprites

   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)                 ; bc = & next sp1_update in update list
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                    ; hl = screen address for this char cell
   
   push bc
   ld bc,32
   ld de,(SP1V_PIXELBUFFER+0) ; copy final graphic in pixel buffer to screen
   ld (hl),e
   add hl,bc
   ld (hl),d
   add hl,bc
   ld de,(SP1V_PIXELBUFFER+2)
   ld (hl),e
   add hl,bc
   ld (hl),d
   add hl,bc
   ld de,(SP1V_PIXELBUFFER+4)
   ld (hl),e
   add hl,bc
   ld (hl),d
   add hl,bc
   ld de,(SP1V_PIXELBUFFER+6)
   ld (hl),e
   add hl,bc
   ld (hl),d
   pop bc
   
   ; bc = & next sp1_update in update list

   ret
