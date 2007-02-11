; void __CALLEE__ sp1_MoveSprAbs_callee(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uchar row, uchar col, uchar vrot, uchar hrot)
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

; *** PLEASE HELP ME I'VE BEEN MADE UGLY BY BUGFIXES

XLIB sp1_MoveSprAbs_callee
XDEF ASMDISP_SP1_MOVESPRABS_CALLEE

LIB sp1_GetUpdateStruct_callee
XREF ASMDISP_SP1_GETUPDATESTRUCT_CALLEE
XREF SP1V_ROTTBL, SP1V_DISPWIDTH, SP1V_UPDATELISTT

.sp1_MoveSprAbs_callee

   pop af
   pop de
   pop bc
   ld b,e
   pop de
   pop hl
   ld d,l
   pop hl
   pop iy
   pop ix
   push af

.asmentry

; enter: ix = & struct sp1_ss 
;        hl = sprite frame address (0 = no change)
;         d = new row coord in chars 
;         e = new col coord in chars 
;         b = new horizontal rotation (0..7) ie horizontal pixel position 
;         c = new vertical rotation (0..7) ie vertical pixel position 
;        iy = clipping rectangle entirely on screen
;             (iy+0) = row, (iy+1) = col, (iy+2) = width, (iy+3) = height
; uses : all except ix, iy which remain unchanged

.SP1MoveSprAbs

   ld (ix+5),b             ; store new horizontal rotation
   ld a,b
   
   cp (ix+17)              ; decide if last col should draw, result in b
   rl b
   
   add a,a
   add a,SP1V_ROTTBL/256
   ld (ix+9),a             ; store effective horizontal rotation (MSB of lookup table to use)
   
   xor a
   sub c                   ; a = - (vertical rotation in pixels)
   bit 7,(ix+4)
   jp z, onebytedef
   sub c                   ; a = - 2*(vertical rotation) for 2-byte definitions
   set 7,c

.onebytedef

   ld (ix+4),c             ; store new vertical rotation
   ld c,a                  ; c = vertical rotation offset for graphics ptrs
   
   ld a,(ix+4)             ; decide if last row should draw
   and $07
   cp (ix+18)
   ld a,b
   rla
   ex af,af

   ld a,h
   or l
   jr nz, newframe
   
   ld l,(ix+6)
   ld h,(ix+7)             ; hl = old sprite frame pointer
   jp framerejoin
   
.newframe

   ld (ix+6),l
   ld (ix+7),h             ; store new frame pointer
   
.framerejoin

   ld a,c
   or a
   jr z, skipadj
   
   ld b,$ff                ; bc = negative vertical rotation offset
   add hl,bc               ; add vertical rotation offset

.skipadj

   ld (ix+11),l
   ld (ix+12),h            ; store new effective offset for graphics pointers
   
   ;  d = new row coord (chars)
   ;  e = new col coord (chars)
   ; ix = & struct sp1_ss
   ; iy = clipping rectangle
   ; a' = bit 0 = 1 if last row should not draw, bit 1 = 1 if last col should not draw
   ;
   ; 329 cycles to this point worst case

   ld (ix+19),0

   ld a,(ix+0)             ; has the row coord changed?
   cp d
   jp nz, changing0
   ld a,(ix+1)             ; has the col coord changed?
   cp e
   jp nz, changing1

; not changing character coordinate, no need to remove sprite from update struct lists

; /////////////////////////////////////////////////////////////////////////////////
;              MOVE SPRITE, CHARACTER COORDINATES NOT CHANGING
; /////////////////////////////////////////////////////////////////////////////////

   ld h,(ix+15)
   ld l,(ix+16)
   push de
   exx
   pop de
   ld hl,(SP1V_UPDATELISTT)
   ld bc,6
   add hl,bc
   push hl
   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE
   ld b,(ix+0)
   pop de
   push hl
   push de

   ; b  = row coord
   ; c  = col coord (in column loop)
   ; hl = struct sp1_update
   ; hl'= & struct sp1_cs
   ; a' = bit 0 = 1 if last row should not draw, bit 1 = 1 if last col should not draw
   ; iy = & clipping rectangle
   ; ix = & struct sp1_ss
   ; stack = & struct sp1_update.ulist (tail of invalidated list), row

   INCLUDE "./spectrum/sprites/MoveNC.asm"

.done

   exx
   ld de,-6
   add hl,de                 ; hl = & last struct sp1_update.ulist in invalidated list
   ld (SP1V_UPDATELISTT),hl
   ret

; changing character coordinate, must remove and place sprite in update struct lists

; /////////////////////////////////////////////////////////////////////////////////
;               MOVE SPRITE, CHANGING CHARACTER COORDINATES
; /////////////////////////////////////////////////////////////////////////////////

.changing0

   ld (ix+0),d             ; write new row coord

.changing1

   ld (ix+1),e             ; write new col coord

   ;  d = new row coord (chars)
   ;  e = new col coord (chars)
   ; ix = & struct sp1_ss
   ; iy = & clipping rectangle
   ; a' = bit 0 = 1 if last row should not draw, bit 1 = 1 if last col should not draw

   ld h,(ix+15)
   ld l,(ix+16)
   push de
   exx
   pop de
   ld hl,(SP1V_UPDATELISTT)
   ld bc,6
   add hl,bc
   push hl
   call sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE
   ld b,(ix+0)
   pop de
   push hl
   push de

   ; b  = row coord
   ; c  = col coord (in column loop)
   ; hl = struct sp1_update
   ; hl'= & struct sp1_cs
   ; a' = bit 0 = 1 if last row should not draw, bit 1 = 1 if last col should not draw
   ; iy = & clipping rectangle
   ; ix = & struct sp1_ss
   ; stack = & struct sp1_update.ulist (tail of invalidated list), row

   INCLUDE "./spectrum/sprites/MoveC.asm"

   ; jumps to done for exit inside INCLUDE

; /////////////////////////////////////////////////////////////////////////////////

; Remove a sprite char from the linked list of sprites
; it occupies in a struct sp1_update
;
; enter : hl = & struct sp1_cs.attr_mask
; exit  : de = & struct sp1_cs.prev_in_upd + 1
; uses  : f, bc, de, hl
;
; 179 cycles worst case

.RemoveSprChar

   ld de,14
   add hl,de                 ; hl = & struct sp1_cs.next_in_upd
   
   ld b,(hl)                 ; check if there's any sprite char after this one in list
   inc b
   inc hl                    ; hl = & struct sp1_cs.next_in_upd + 1
   djnz nextexists
   
   ; no sprite char after this one in list so removing from end of list
   
   inc hl
   ld d,(hl)
   inc hl
   ld e,(hl)                 ; de = & left link's sp1_cs.next_in_upd
   ex de,hl                  ; de = & struct sp1_cs.prev_in_upd + 1
   ld (hl),0                 ; mark no next sprite, removing this one from list
   
   ret

.nextexists

   ; there is a sprite char after this one in update list, so removing from middle of list

   ld c,(hl)                 ; bc = & right link's struct sp1_cs.attr_mask
   inc hl
   ld d,(hl)
   inc hl
   ld e,(hl)                 ; de = & left link's struct sp1_cs.next_in_upd

   ex de,hl                  ; de = & struct sp1_cs.prev_in_upd + 1b
   push hl                   ; stack & left link's struct sp1_cs.next_in_upd

   ld (hl),b
   inc hl
   ld (hl),c                 ; previous sprite's next ptr = & right link's struct sp1_cs.attr_mask

   ld hl,16
   add hl,bc                 ; hl = & right link's struct sp1_cs.prev_in_update
   pop bc                    ; bc = & left link's struct sp1_cs.next_in_upd

   ld (hl),b
   inc hl
   ld (hl),c                 ; next sprite's prev ptr = & left link's struct sp1_cs.next_in_upd

   ret

; /////////////////////////////////////////////////////////////////////////////////

; Adds a sprite char to the linked list of sprites in a
; struct sp1_update at the correct position dependant on plane.
;
; enter :  a = plane
;         hl = & struct update.slist
;         bc = & sp1_cs.attr_mask of sprite char being added
; uses  : f, bc, de, hl
;
; 98n - 26 + 197 = 98n + 171 (n = # sprites in char; n=3: 465, n=1: 130)

.AddSprChar

   ; hl = prev sprite's & sp1_cs.next_in_upd (pending point to add current sprite after)

   ld d,(hl)
   inc hl
   inc d
   dec d
   jr z, donesearch1         ; if no next sprite, we add this sprite to end of list

   ld e,(hl)
   dec de
   dec de
   ex de,hl                  ; hl = the next sprite's & sp1_cs.plane, de = prev sprite's & sp1_cs.next_in_upd + 1b
   cp (hl)
   jr nc, donesearch0        ; if plane >= this sprite's plane, place before it
   ld de,16
   add hl,de                 ; hl = the next sprite's & sp1_cs.next_in_upd
   
   jp AddSprChar

.donesearch1                 ; no next sprite
 
   ld (hl),c                 ; hl = & prev sprite's sp1_cs.next_in_upd + 1b
   dec hl
   ld (hl),b                 ; write new sprite char into next ptr
   ex de,hl                  ; de = & prev sprite's sp1_cs.next_in_upd
   ld hl,14
   add hl,bc                 ; hl = & sp1_cs.next_in_upd of spr char to add
   ld (hl),0                 ; no sprite chars follow this one in list
   inc hl
   inc hl
   ld (hl),d                 ; write prev sprite into prev spr ptr
   inc hl
   ld (hl),e

   ret

.donesearch0                 ; there is a next sprite

   inc hl
   inc hl
   ex de,hl                  ; hl = & prev sprite's sp1_cs.next_in_upd + 1b, de = next sprite's & sp1_cs.attr_mask
   ld (hl),c
   dec hl
   ld (hl),b                 ; prev sprite's next ptr points at new sprite char
   push hl                   ; stack = prev sprite's & sp1_cs.next_in_upd
   ld hl,14
   add hl,bc                 ; hl = new sprite's & sp1_cs.next_in_upd
   ld (hl),d 
   inc hl
   ld (hl),e                 ; new sprite's next ptr points at next sprite
   inc hl                    ; hl = new sprite's & sp1_cs.prev_in_upd
   pop bc                    ; bc = prev sprite's & sp1_cs.next_in_upd
   ld (hl),b  
   inc hl
   ld (hl),c                 ; new sprite's prev ptr points at prev sprite
   dec hl
   dec hl
   dec hl
   ex de,hl                  ; de = new sprite's & sp1_cs.next_in_upd
   ld bc,16
   add hl,bc                 ; hl = next sprite's & sp1_cs.prev_in_upd
   ld (hl),d
   inc hl
   ld (hl),e                 ; next sprite's prev ptr points at new sprite

   ret

DEFC ASMDISP_SP1_MOVESPRABS_CALLEE = asmentry - sp1_MoveSprAbs_callee
