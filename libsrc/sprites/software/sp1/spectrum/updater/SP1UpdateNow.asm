
; SP1UpdateNow
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1UpdateNow
XDEF SP1RETSPRDRAW
XREF SP1V_PIXELBUFFER, SP1V_ATTRBUFFER, SP1V_TILEARRAY, SP1V_UPDATELISTH, SP1V_UPDATELISTT

; Iterates through the invalidated tiles list, drawing all invalidated tiles on screen.
;
; enter : none
; uses  : af, bc, de, hl, ix

.SP1UpdateNow

   ld hl,(SP1V_UPDATELISTH+5) ; get the first struct update char to draw
   ld a,l
   ld l,h
   ld h,a                    ; correct endianness
   or a
   jp nz, updatelp1
   ret                       ; if empty update list

.skipthischar

   ld bc,5
   add hl,bc                 ; hl = & struct update.next_update
   ld a,(hl)
   or a
   jp z, doneupdate          ; return if no next struct update
   inc hl
   ld l,(hl)
   ld h,a                    ; hl = next struct update
   jp updatelp1

.updatelp0

   ld l,c
   ld h,b

.updatelp1                   ; hl = & struct update

   ld a,$80
   xor (hl)                  ; (hl) = # load sprites, bit 7 set for marked to update
   jp m, skipthischar        ; if bit 7 was reset (now set), this char was validated so skip it

   ld (hl),a                 ; mark char as not needing update (bit 7 is reset)
   ld b,a                    ; b = # of occluding sprites in this char + 1
   inc hl
   ld a,(hl)                 ; a = background tile attr
   ld (SP1V_ATTRBUFFER),a    ; write colour into the attribute buffer
   inc hl                    ; hl = & update.tile
   djnz skiptile             ; if there are occluding sprites in this char, save draw
                             ;   time by not drawing sprites underneath them
   ld e,(hl)                 ; else e = tile # for this char
   ld d,SP1V_TILEARRAY/256
   inc hl
   push hl                   ; save & update.sprite_list
   ex de,hl
   ld e,(hl)
   inc h
   ld d,(hl)
   ex de,hl                  ; hl = UDG definition for this tile
   ld de,SP1V_PIXELBUFFER    ; copy the 8 bytes of UDG definition into the pixel buffer
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ldi
   ld a,(hl)
   ld (de),a
   pop hl                    ; hl = & update.sprite_list

   ld a,(hl)
   or a
   jr z, donesprites         ; if there are no sprites to draw, we are done

   push hl                   ; save & update.sprite_list

.spritedrawlp

   inc hl                    ; get first sprite in char
   ld l,(hl)
   ld h,a                    ; hl = & sp1_CS.attr_mask

.spritedraw

   ld a,(SP1V_ATTRBUFF)      ; get current char colour
   and (hl)                  ; apply sprite's colour mask
   inc hl
   or (hl)                   ; apply sprite's colour
   ld (SP1V_ATTRBUFF),a      ; write back as current char colour
   inc hl

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ex de,hl                  ; de = & sp1_CS.draw_code, hl = & sp1_SS.draw_code

   jp (hl)                   ; sprite structure contains code that draws itself

.SP1RETSPRDRAW               ; return here after sprite char drawn

   pop hl                    ; hl = & sp1_CS.next_draw (pushed by sprite draw code)
   ld a,(hl)
   or a
   jr nz, spritedrawlp       ; if there are more sprites in this char, go draw them

   pop hl                    ; hl = & update.sprite_list

.donesprites

   inc hl
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)                 ; bc = next update char
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                    ; hl = screen address for this char cell

   ld de,(SP1V_PIXELBUFFER+0) ; copy final graphic in pixel buffer to screen
   ld (hl),e
   inc h
   ld (hl),d
   inc h
   ld de,(SP1V_PIXELBUFFER+2)
   ld (hl),e
   inc h
   ld (hl),d
   inc h
   ld de,(SP1V_PIXELBUFFER+4)
   ld (hl),e
   inc h
   ld (hl),d
   inc h
   ld de,(SP1V_PIXELBUFFER+6)
   ld (hl),e
   inc h
   ld (hl),d

   ld a,h                    ; compute attribute addr from pixel addr
   xor $85
   rrca
   rrca
   rrca
   ld h,a

   ld a,(SP1V_ATTRBUFFER)
   ld (hl),a                 ; write colour to screen

   inc b                     ; go to next char to update (more if b!=0)
   djnz updatelp0

.doneupdate

   xor a
   ld (SP1V_UPDATELISTH+5),a ; mark update list empty
   ld hl,SP1V_UPDATELISTH
   ld (SP1V_UPDATELISTT),hl
   ret

.skiptile

   inc hl
   push hl                   ; save & update.sprite_list

.skiplp

   ld d,(hl)                 ; get sprite descriptor
   inc hl
   ld e,(hl)                 ; de = & sp1_CS.attr_mask
   dec de                    ; de = & sp1_CS.type
   ld a,(de)                 ; a = sprite type
   rla                       ; is this an occluding sprite?
   jr c, occludetype         ; if yes, branch and check if we've seen them all yet

.skipthisload                ; otherwise don't need to draw this sprite

   ld hl,15
   add hl,de                 ; hl = & sp1_CS.next_draw
   jp skiplp                 ; check out next sprite in char

.occludetype

   djnz skipthisload         ; if we haven't seen all occluding sprites in this char
   ex de,hl                  ;   yet, skip this occluding sprite and decrease count
   inc hl                    ; hl = & sp1_CS.attr_mask
   jp spritedraw             ; draw sprites beginning with this one
