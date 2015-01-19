; uint __CALLEE__ sp1_AddColSpr_callee(struct sp1_ss *s, void *drawf, uchar type, int graphic, uchar plane)
; 02.2008 aralbrec, Sprite Pack v3.0
; zx81 hi-res version

PUBLIC sp1_AddColSpr_callee
PUBLIC ASMDISP_SP1_ADDCOLSPR_CALLEE

EXTERN _sp1_struct_cs_prototype
EXTERN _u_malloc, _u_free, SP1V_TEMP_IX

.sp1_AddColSpr_callee

   pop af
   pop hl
   ld h,l
   pop bc
   pop de
   ld l,e
   pop de
   pop ix
   push af

.asmentry

; Adds another column to an existing sprite.
;
; enter : ix = struct sp1_ss *
;          h = plane
;          l = type (index into table), bit 7 = 1 for occluding, bit 4 = 1 clear pixelbuffer
;         bc = graphic definition for column
;         de = address of sprite draw function
; uses  : af, bc, de, hl, bc', de', hl', ix
; exit  : carry flag for success and hl=1, else memory allocation failed and hl=0

.SP1AddColSpr

   exx
   ld hl,0                    ; first try to get all the memory we need
   push hl                    ; push a 0 on stack to indicate end of allocated memory blocks
   ld b,(ix+3)                ; b = height
   
.csalloc

   push bc
   ld hl,22                   ; sizeof(struct sp1_cs)
   push ix
   push hl
   call _u_malloc
   pop bc
   jp nc, fail
   pop ix
   pop bc
   push hl                    ; stack allocated block
   djnz csalloc
   
   exx
   ex (sp),hl                 ; hl = new struct sp1_cs, stack: l = type h = plane
   push de                    ; save draw function

   ld (SP1V_TEMP_IX),ix       ; (SP1_TEMP_IX) = struct sp1_ss *

   ; have all necessary memory blocks on stack, hl = new struct sp1_cs
   
   ld de,_sp1_struct_cs_prototype
   ex de,hl                   ; hl = & struct sp1_cs prototype, de = & new struct sp1_cs
   ld ixl,e
   ld ixh,d                   ; ix = & struct sp1_cs
   push bc                    ; save bc = graphic def
   ld bc,22                   ; sizeof(struct sp1_cs)
   ldir                       ; copy prototype into new struct
   pop bc                     ; bc = graphic def
   
   ; have copied prototype struct sp1_cs, now fill in the rest of the details
   
   pop de                     ; de = draw function
   pop hl                     ; h = plane, l = type
   push bc                    ; stack graphic def
   ld c,e
   ld b,d                     ; bc = draw function
   
   ld (ix+4),h                ; store plane
   ld a,l
   and $90
   or $40
   ld (ix+5),a                ; store type

   ld e,ixl
   ld d,ixh
   ld hl,8
   add hl,de
   ex de,hl                   ; de = & struct sp1_cs.draw_code (& embedded code in struct sp1_cs)
   ld hl,-10
   add hl,bc                  ; hl = & draw function data
   ld bc,10                   ; length of draw code
   ldir                       ; copy draw code into struct sp1_cs

   ld a,(SP1V_TEMP_IX)
   add a,8
   ld (ix+6),a                ; store & struct sp1_ss + 8 (& embedded code in struct sp1_ss)
   ld a,(SP1V_TEMP_IX + 1)
   adc a,0
   ld (ix+7),a
   
   pop bc
   ld (ix+9),c                ; store graphics ptr
   ld (ix+10),b

   ld hl,(SP1V_TEMP_IX)
   ld bc,15
   add hl,bc
   ld c,(hl)
   inc hl
   ld l,(hl)
   ld h,c                     ; hl = first struct sp1_cs in sprite

.loop

   ; (SP1_TEMP_IX) = struct sp1_ss, ix = next struct sp1_cs to be added to sprite, hl = & next struct sp1_cs in sprite being iterated
   
   ld bc,4
   
.search

   ld d,(hl)
   inc hl
   ld e,(hl)                  ; de = next struct sp1_cs within sprite in iteration
   add hl,bc                  ; hl = & struct sp1_cs.type
   bit 6,(hl)                 ; is this struct sp1_cs in last column?
   ex de,hl
   jp z, search
   
   ex de,hl                   ; hl = & struct sp1_cs.type in last column, de = next struct sp1_cs at start of next row
   res 6,(hl)                 ; no longer last in column
   ld bc,-5
   add hl,bc                  ; hl = & struct sp1_cs formerly in last column

   ld a,ixh                   ; store ptr to new struct sp1_cs as following this one
   ld (hl),a
   inc hl
   ld a,ixl
   ld (hl),a

   ld (ix+0),d                ; and store next struct sp1_cs at start of next row as following the new one
   ld (ix+1),e

   ld bc,8
   add hl,bc                  ; hl = & struct sp1_cs.def formerly in last column
   ld a,(hl)
   ld (ix+13),a               ; copy left struct's graphic pointer into new struct's left graphic ptr
   inc hl
   ld a,(hl)
   ld (ix+14),a
   
   pop hl                     ; get next allocated memory block

   ld a,h
   or l
   jr z, done
   
   push de                    ; save & first struct sp1_cs in next row of sprite
   push hl                    ; stack new memory block
   ld e,ixl
   ld d,ixh
   ex de,hl                   ; hl = & new struct sp1_cs just added, de = memory block for new struct sp1_cs
   ld bc,22                   ; sizeof(struct sp1_cs)
   ldir                       ; copy struct sp1_cs just added into new one
 
   ld e,(ix+9)
   ld d,(ix+10)               ; de = graphics ptr from last struct sp1_cs

   pop ix                     ; ix = new struct sp1_cs
   
   ld hl,(SP1V_TEMP_IX)
   ld bc,4
   add hl,bc
   bit 7,(hl)
   ld hl,8
   jr z, onebyte2
   ld l,16                    ; if 2-byte def, offset is 16 bytes
   
.onebyte2

   add hl,de
   ld (ix+9),l                ; store correct graphics ptr for this struct sp1_cs
   ld (ix+10),h

   pop hl                     ; hl = & first struct sp1_cs in next row of sprite
   jp loop

.done

   set 5,(ix+5)               ; indicate last struct sp1_cs added is in the last row of sprite
   ld ix,(SP1V_TEMP_IX)
   inc (ix+2)                 ; increase width of sprite
   inc l
   scf                        ; indicate success
   ret

.fail

   pop ix
   pop bc
   
.faillp

   pop hl                     ; hl = allocated memory block
   
   ld a,h
   or l
   ret z                      ; if 0 done freeing, ret with nc for failure
   
   push hl
   call _u_free               ; free the block
   pop hl
   jp faillp

DEFC ASMDISP_SP1_ADDCOLSPR_CALLEE = # asmentry - sp1_AddColSpr_callee
