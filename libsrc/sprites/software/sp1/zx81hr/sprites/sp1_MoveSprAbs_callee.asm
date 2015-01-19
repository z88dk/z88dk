; void __CALLEE__ sp1_MoveSprAbs_callee(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uchar row, uchar col, uchar vrot, uchar hrot)
; 02.2008 aralbrec, Sprite Pack v3.0
; zx81 hi-res version

; *** PLEASE HELP ME I'VE BEEN MADE UGLY BY BUGFIXES

PUBLIC sp1_MoveSprAbs_callee
PUBLIC ASMDISP_SP1_MOVESPRABS_CALLEE

EXTERN sp1_GetUpdateStruct_callee
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE
EXTERN SP1V_ROTTBL, SP1V_DISPWIDTH, SP1V_UPDATELISTT
EXTERN SP1V_TEMP_AF, SP1V_TEMP_IX, SP1V_TEMP_IY

EXTERN SP1AddSprChar, SP1RemoveSprChar

.sp1_MoveSprAbs_callee

   pop af
   pop de
   pop bc
   ld b,e
   pop de
   pop hl
   ld d,l
   pop hl
   pop ix
   ld (SP1V_TEMP_IY),ix
   pop ix
   push af

.asmentry

; enter: ix = & struct sp1_ss 
;        hl = sprite frame address (0 = no change)
;         d = new row coord in chars 
;         e = new col coord in chars 
;         b = new horizontal rotation (0..7) ie horizontal pixel position 
;         c = new vertical rotation (0..7) ie vertical pixel position 
; (SP1V_TEMP_IY) = clipping rectangle entirely on screen
;             (..+0) = row, (..+1) = col, (..+2) = width, (..+3) = height
; uses : all except iy, af'

.SP1MoveSprAbs

   ld (SP1V_TEMP_IX),ix

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
   ld (SP1V_TEMP_AF + 1),a

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
   ld bc,5
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

   INCLUDE "./zx81hr/sprites/MoveNC.asm"

.done

   exx
   ld de,-5
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
   ld bc,5
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

   INCLUDE "./zx81hr/sprites/MoveC.asm"

   ; jumps to done for exit inside INCLUDE

DEFC ASMDISP_SP1_MOVESPRABS_CALLEE = # asmentry - sp1_MoveSprAbs_callee
