; void sp1_MoveSprAbs(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uchar row, uchar col, uchar vrot, uchar hrot)
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

; *** PLEASE HELP ME I'VE BEEN MADE UGLY BY BUGFIXES

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_MoveSprAbs

EXTERN asm_sp1_GetUpdateStruct, __sp1_add_spr_char, __sp1_remove_spr_char

asm_sp1_MoveSprAbs:

; enter: ix = & struct sp1_ss 
;        hl = sprite frame address (0 = no change)
;         d = new row coord in chars 
;         e = new col coord in chars 
;         b = new horizontal rotation (0..7) ie horizontal pixel position 
;         c = new vertical rotation (0..7) ie vertical pixel position 
;        iy = clipping rectangle entirely on screen
;             (iy+0) = row, (iy+1) = col, (iy+2) = width, (iy+3) = height
; uses : all except ix, iy which remain unchanged

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
   call asm_sp1_GetUpdateStruct
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

   INCLUDE "temp/sp1/zx/sprites/__sp1_move_nc.asm"

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
   call asm_sp1_GetUpdateStruct
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

   INCLUDE "temp/sp1/zx/sprites/__sp1_move_c.asm"

   ; jumps to done for exit inside INCLUDE
