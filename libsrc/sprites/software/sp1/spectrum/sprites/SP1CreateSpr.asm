
; SP1CreateSpr
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1CreateSpr
LIB SP1_SS_PROTOTYPE, SP1_CS_PROTOTYPE
XREF _u_malloc, _u_free, SP1V_SPRDRAWTBL

; Create sprite of given height one column wide.  Further columns are
; added with successive calls to SP1AddColSpr.
;
; enter :  b = height in chars
;          c = plane sprite occupies (0 = closest to viewer)
;          e = type (index into table), bit 7 = 1 occluding, bit 6 = 1 2 byte definition, bit 4 = 1 clear pixelbuff
;         hl = graphic definition for column
; uses  : af, bc, de, hl, bc', de', hl', ix, iy
; exit  : no carry if memory allocation failed else ix = struct sp1_ss *

.SP1CreateSpr

   ld a,b
   exx

   ld hl,0                    ; first try to get all the memory we need
   push hl                    ; push a 0 on stack to indicate end of allocated memory blocks
   ld b,a                     ; b = height

.csalloc

   push bc                    ; save height counter
   ld hl,24                   ; sizeof(struct sp1_cs)
   push hl
   call _u_malloc
   pop bc
   jp nc, fail
   pop bc
   push hl                    ; stack allocated block
   djnz csalloc

   ld hl,20                   ; sizeof(struct sp1_ss)
   push hl
   call _u_malloc
   pop bc
   jp nc, fail
   push hl
   
   exx
   ex (sp),hl                 ; stack = graphic pointer
   push de                    ; save e = type
   push bc                    ; save b = height, c = plane

   ; have all necessary memory blocks on stack, hl = & struct sp1_ss

   ld de,SP1_SS_PROTOTYPE
   ex de,hl                   ; hl = & struct sp1_ss prototype, de = & new struct sp1_ss
   ld ixl,e
   ld ixh,d                   ; ix = & struct sp1_ss
   ld bc,20                   ; sizeof(struct sp1_ss)
   ldir                       ; copy prototype into new struct
   
   ; have copied prototype struct sp1_ss, now fill in the rest of the details
   
   pop bc                     ; b = height, c = plane
   ld (ix+3),b                ; store height
   pop de                     ; e = type, bit 7 = 1 occluding, bit 6 = 1 2-byte def, bit 4 = 1 clear pixel buff
   bit 6,e
   jr z, onebyte
   set 7,(ix+4)               ; indicate 2-byte definition

.onebyte

   ld a,e                     ; a = type
   and $9f
   or $40                     ; a = type entry for struct sp1_cs
   
   pop hl
   ex (sp),hl                 ; stack = graphics ptr, hl = & first struct sp1_cs
   
   ld (ix+15),h               ; store ptr to first struct sp1_cs in struct sp1_ss
   ld (ix+16),l
   
   ; done with struct sp1_ss, now do first struct sp1_cs
   
   ld de,SP1_CS_PROTOTYPE
   ex de,hl                   ; hl = & struct sp1_cs prototype, de = & new struct sp1_cs
   ld iyl,e
   ld iyh,d                   ; iy = & struct sp1_cs
   push bc                    ; save c = plane
   ld bc,24                   ; sizeof(struct sp1_cs)
   ldir                       ; copy prototype into new struct
   pop bc                     ; c = plane
   
   ; have copied prototype struct sp1_cs, now fill in the rest of the details
   
   ld (iy+4),c                ; store plane
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
   
   pop hl                     ; hl = graphics ptr
   ld (iy+11),l               ; store graphics ptr
   ld (iy+12),h

.loop

   ; ix = struct sp1_ss, iy = last struct sp1_cs added to sprite

   pop hl                     ; hl = & next struct sp1_cs to add

   ld a,h
   or l
   jr z, done
   
   push hl

   ld (iy+0),h                ; store ptr to next struct sp1_cs
   ld (iy+1),l

   ld e,iyl
   ld d,iyh
   ex de,hl                   ; hl = last struct sp1_cs, de = new struct sp1_cs
   ld bc,24                   ; sizeof(struct sp1_cs)
   ldir                       ; make copy of last one into new one

   ld e,(iy+11)
   ld d,(iy+12)               ; de = graphics ptr from last struct sp1_cs

   pop iy                     ; iy = new struct sp1_cs

   ld (iy+0),c                ; place 0 into struct sp1_cs.next_in_spr to indicate
   ld (iy+1),c                ;  this is currently last struct sp1_cs in sprite

   ld hl,8                    ; offset to next character in sprite graphic def
   bit 7,(ix+4)
   jr z, onebyte2
   ld l,16                    ; if 2-byte def, offset is 16 bytes
   
.onebyte2

   add hl,de
   ld (iy+11),l               ; store correct graphics ptr for this struct sp1_cs
   ld (iy+12),h
   
   jp loop

.done

   set 5,(iy+5)               ; indicate last struct sp1_cs added is in the last row of sprite
   scf                        ; indicate success
   ret

.fail

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
