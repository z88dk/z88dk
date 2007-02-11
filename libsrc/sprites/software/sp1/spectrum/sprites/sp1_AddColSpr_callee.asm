; uint __CALLEE__ sp1_AddColSpr_callee(struct sp1_ss *s, uchar type, int graphic, uchar plane)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB sp1_AddColSpr_callee
XDEF ASMDISP_SP1_ADDCOLSPR_CALLEE

LIB SP1_CS_PROTOTYPE
XREF _u_malloc, _u_free, SP1V_SPRDRAWTBL

.sp1_AddColSpr_callee

   pop af
   pop de
   pop bc
   pop hl
   ld h,e
   pop ix
   push af

.asmentry

; Adds another column to an existing sprite.
;
; enter : ix = struct sp1_ss *
;          h = plane
;          l = type (index into table), bit 7 = 1 for occluding, bit 4 = 1 clear pixelbuffer
;         bc = graphic definition for column
; uses  : af, bc, de, hl, bc', de', hl', iy
; exit  : carry flag for success and hl=1, else memory allocation failed and hl=0

.SP1AddColSpr

   exx
   ld hl,0                    ; first try to get all the memory we need
   push hl                    ; push a 0 on stack to indicate end of allocated memory blocks
   ld b,(ix+3)                ; b = height
   
.csalloc

   push bc
   push ix
   ld hl,24                   ; sizeof(struct sp1_cs)
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

   ; have all necessary memory blocks on stack, hl = new struct sp1_cs
   
   ld de,SP1_CS_PROTOTYPE
   ex de,hl                   ; hl = & struct sp1_cs prototype, de = & new struct sp1_cs
   ld iyl,e
   ld iyh,d                   ; iy = & struct sp1_cs
   push bc                    ; save bc = graphic def
   ld bc,24                   ; sizeof(struct sp1_cs)
   ldir                       ; copy prototype into new struct
   pop bc                     ; bc = graphic def
   
   ; have copied prototype struct sp1_cs, now fill in the rest of the details
   
   pop hl
   push bc                    ; stack graphic def
   
   ld (iy+4),h                ; store plane
   ld a,l
   and $9f
   or $40
   ld (iy+5),a                ; store type

   ld e,iyl
   ld d,iyh
   ld hl,10
   add hl,de
   ex de,hl                   ; de = & struct sp1_cs.draw_code (& embedded code in struct sp1_cs)
   and $0f                    ; a = sprite type but only index portion
   add a,a
   ld hl,(SP1V_SPRDRAWTBL)
   add a,l
   ld l,a
   ld a,0
   adc a,h
   ld h,a                     ; hl = & draw function to copy into struct sp1_cs
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld bc,10                   ; length of draw code
   ldir                       ; copy draw code into struct sp1_cs

   ld a,ixl
   add a,8
   ld (iy+8),a                ; store & struct sp1_ss + 8 (& embedded code in struct sp1_ss)
   ld a,ixh
   adc a,0
   ld (iy+9),a
   
   pop bc
   ld (iy+11),c               ; store graphics ptr
   ld (iy+12),b

   ld h,(ix+15)               ; hl = first struct sp1_cs in sprite
   ld l,(ix+16)

.loop

   ; ix = struct sp1_ss, iy = next struct sp1_cs to be added to sprite, hl = & next struct sp1_cs in sprite being iterated
   
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

   ld a,iyh                   ; store ptr to new struct sp1_cs as following this one
   ld (hl),a
   inc hl
   ld a,iyl
   ld (hl),a

   ld (iy+0),d                ; and store next struct sp1_cs at start of next row as following the new one
   ld (iy+1),e
   
   ld bc,10
   add hl,bc                  ; hl = & struct sp1_cs.def formerly in last column
   ld a,(hl)
   ld (iy+15),a               ; copy left struct's graphic pointer into new struct's left graphic ptr
   inc hl
   ld a,(hl)
   ld (iy+16),a
   
   pop hl                     ; get next allocated memory block

   ld a,h
   or l
   jr z, done
   
   push de                    ; save & first struct sp1_cs in next row of sprite
   push hl                    ; stack new memory block
   ld e,iyl
   ld d,iyh
   ex de,hl                   ; hl = & new struct sp1_cs just added, de = memory block for new struct sp1_cs
   ld bc,24                   ; sizeof(struct sp1_cs)
   ldir                       ; copy struct sp1_cs just added into new one
   
   ld e,(iy+11)
   ld d,(iy+12)               ; de = graphics ptr from last struct sp1_cs
   
   pop iy                     ; iy = new struct sp1_cs
   
   ld hl,8                    ; offset to next character in sprite graphic def
   bit 7,(ix+4)
   jr z, onebyte2
   ld l,16                    ; if 2-byte def, offset is 16 bytes
   
.onebyte2

   add hl,de
   ld (iy+11),l               ; store correct graphics ptr for this struct sp1_cs
   ld (iy+12),h

   pop hl                     ; hl = & first struct sp1_cs in next row of sprite
   jp loop

.done

   set 5,(iy+5)               ; indicate last struct sp1_cs added is in the last row of sprite
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

DEFC ASMDISP_SP1_ADDCOLSPR_CALLEE = asmentry - sp1_AddColSpr_callee
