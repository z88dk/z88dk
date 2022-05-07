

; b  = row coord
; c  = col coord (in column loop)
; hl = struct sp1_update
; hl'= & struct sp1_cs
; a' = bit 0 = 1 if last row should not draw, bit 1 = 1 if last col should not draw
; iy = & clipping rectangle
; ix = & struct sp1_ss
; stack = & struct sp1_update.ulist (tail of invalidated list), row

.NCrowloop

   ld a,b
   inc b                     ; row++
   
   ; is row in clipping rectangle?
   
   sub (iy+0)
   jp c, NCcliprow0
   sub (iy+3)
   jp nc, NCcliprow0
   
   ; is this the last row?
   
   ; ****************************************************************
   ; **** FIXED BUG HERE MESSED UP REGISTER ALLOCATION, IMPROVE LATER
   ld a,b
   sub (ix+0)
   cp (ix+3)
   jp nz, NCnotlastrow
   ; ****************************************************************
   
   ; this is the last row, should it be drawn?
   
   ex af,af
   bit 0,a
   jp nz, NCcliprow1
   ex af,af

.NCnotlastrow

   ld c,(ix+1)               ; c = column

.NCcolloop

   ld a,c
   inc c                     ; column++

   ; has this update struct been removed from the display?
   
   bit 6,(hl)
   ex (sp),hl
   jr nz, NCclipcol0

   ; hl = & struct sp1_update.ulist (tail)
   ; stack = & struct sp1_update, row

   ; is column in clipping rectangle?
   
   sub (iy+1)
   jr c, NCclipcol0
   sub (iy+2)
   jr nc, NCclipcol0
   
   ; is this the last column in row?

   ; ****************************************************************
   ; **** FIXED BUG HERE MESSED UP REGISTER ALLOCATION, IMPROVE LATER
   ld a,c
   sub (ix+1)
   cp (ix+2)
   jp nz, NCnotlastcol       ; z flag set if it is the last column in row
   ; ****************************************************************
   
   ; this is the last col, should it be drawn?
   
   ex af,af
   bit 1,a
   jr nz, NCclipcol1
   ex af,af

.NCnotlastcol

   exx
   push af
   inc (ix+19)               ; number of active sprite chars++

   ; hl = & struct sp1_cs
   ; stack = flag = z if last col, & struct sp1_update, row
   
   ; is sprite char already in update struct list?
   
   ld d,(hl)
   inc hl
   ld e,(hl)                 ; de = & next struct sp1_cs in sprite
   inc hl                    ; hl = & struct sp1_cs.update
   
   ld a,(hl)                 ; if MSB of update struct this spr char is != 0
   or a                      ;   then already in list
   jr z, NCaddit

   ; already in update struct list so no need to add spr char to update struct list

   ; de = & next struct sp1_cs in sprite
   ; hl = & struct sp1_cs.update
   ; stack = flag = z if last col, & struct sp1_update, row
   
   pop bc
   pop hl

.NCrejoinaddit

   ; de = & next struct sp1_cs
   ; hl = & struct sp1_update
   ;  c = bit 6 set if last col
   ; stack = row

   ; invalidate
   
   ld a,(hl)                 ; skip if char already invalidated
   xor $80
   jp p, NCalreadyinv0
   ld (hl),a                 ; mark as invalidated
   
   push hl
   exx
   pop de                    ; de = & struct sp1_update to invalidate
   ld (hl),d                 ; write & struct sp1_update into tail's ptr
   inc hl
   ld (hl),e
   ld hl,5
   add hl,de                 ; hl = & struct sp1_update.ulist
   ld (hl),0                 ; nothing after this one in list
   exx

.NCalreadyinv0

   bit 6,c                   ; is this last col?
   jr nz, NCnextrow

.NCnextcol

   ; this is not the last column in row
   
   ; hl = & struct sp1_update
   ; de = & next struct sp1_cs
   ; stack = row
   
   ld bc,9
   add hl,bc
   push hl
   ex de,hl                  ; hl = & next struct sp1_cs
   exx
   ex (sp),hl

   jp NCcolloop

.NCclipcol1

   ex af,af

.NCclipcol0

   exx
   
   ; hl = & struct sp1_cs
   ; stack = & struct sp1_update, row
   
   ld d,(hl)
   inc hl
   ld e,(hl)                 ; de = & next struct sp1_cs in sprite
   inc hl
   
   ; is this spr char on the display now?
   
   ld a,(hl)
   or a
   jr nz, NCremoveit
   
   ; ok, not on display
   
   inc hl
   inc hl
   inc hl                    ; hl = & struct sp1_cs.type

.NCrejoinremove

   ; is this the last col in row?
   
   bit 6,(hl)
   pop hl                    ; hl = & struct sp1_update
   jr z, NCnextcol

.NCnextrow

   ; this was last column, move to next row

   ; de = & next struct sp1_cs
   ; hl = & struct sp1_update
   ; stack = row

   pop hl

   ld a,d                    ; all done if there is no next sp1_cs
   or a
   jp z, done

   ld bc,9*SP1V_DISPWIDTH
   add hl,bc
   push hl
   push hl
   ex de,hl                  ; hl = & next struct sp1_cs
   exx
   ex (sp),hl

   jp NCrowloop

.NCaddit

   ; add the sprite char to update struct's sprite list

   ; de = & next struct sp1_cs in sprite
   ; hl = & struct sp1_cs.update
   ; stack = flag = z if last col, & struct sp1_update, row

   pop af                    ; f = flag
   ld b,d
   ld c,e                    ; bc = & next struct sp1_cs in update
   pop de                    ; de = & struct sp1_update
   push de
   push af
   ld (hl),d
   inc hl
   ld (hl),e                 ; write struct update this spr char belongs to
   inc hl
   ld a,(hl)                 ; a = plane
   inc hl
   
   bit 7,(hl)                ; is spr char occluding type?
   jp z, NCnotoccluding10
   ex de,hl
   inc (hl)                  ; increase # occluding sprites in update struct
   ex de,hl

.NCnotoccluding10

   inc hl
   push bc
   ld b,h
   ld c,l                    ; bc = & struct sp1_cs.ss_draw
   ld hl,3
   add hl,de                 ; hl = & struct sp1_update.slist
   call SP1AddSprChar           ; add sprite to update list
   pop de
   pop bc
   pop hl

   ; de = & next struct sp1_cs
   ; hl = & struct sp1_update
   ;  c = bit 6 set if last col
   ; stack = row

   jp NCrejoinaddit

.NCremoveit

   ; need to remove this spr char from update list

   ; de = & next struct sp1_cs in sprite
   ; hl = & struct sp1_cs.update
   ; stack = & struct sp1_update, row

   push de
   ld (hl),0                 ; this spr char no longer belongs to update struct
   inc hl
   inc hl
   inc hl
   push hl
   inc hl                    ; hl = & struct sp1_cs.ss_draw
   call SP1RemoveSprChar
   pop hl                    ; hl = & struct sp1_cs.type
   pop de                    ; de = & next struct sp1_cs
   
   ; invalidate so char is redrawn without sprite
   
   pop bc                    ; bc = & struct sp1_update
   push bc

   ld a,(bc)
   bit 7,(hl)                ; is spr char occluding type?
   jp z, NCnotoccluding0
   dec a                     ; number of occluding sprites in update struct --
   ld (bc),a

.NCnotoccluding0

   xor $80                   ; is char already invalidated?
   jp p, NCrejoinremove      ; if so skip invalidation step
   ld (bc),a                 ; mark as invalidated
   
   push bc
   exx
   pop de                    ; de = & struct sp1_update to invalidate
   ld (hl),d                 ; write & struct sp1_update into tail's ptr
   inc hl
   ld (hl),e
   ld hl,5
   add hl,de                 ; hl = & struct sp1_update.ulist
   ld (hl),0                 ; nothing after this one in list
   exx

   jp NCrejoinremove

.NCcliprow1

   ex af,af

.NCcliprow0

   ; skipping an entire row, only need to remove
   ; spr chars from update struct list + invalidate
   ; if they are on-screen

   ex (sp),hl
   exx

.NCcliprowlp

   ; hl = & struct sp1_cs
   ; stack = & struct sp1_update, row
   
   ld d,(hl)
   inc hl
   ld e,(hl)                 ; de = & next struct sp1_cs in sprite
   inc hl
   
   ; is this spr char on the display now?
   
   ld a,(hl)
   or a
   jr nz, NCCRremoveit
   
   ; ok, not on display
   
   inc hl
   inc hl
   inc hl                    ; hl = & struct sp1_cs.type

.NCCRrejoinremove

   ; is this the last col in row?
   
   bit 6,(hl)
   pop hl                    ; hl = & struct sp1_update
   jr nz, NCCRnextrow

   ; this is not the last column in row
   
   ; hl = & struct sp1_update
   ; de = & next struct sp1_cs
   ; stack = row
   
   ld bc,9
   add hl,bc
   push hl
   ex de,hl                  ; hl = & next struct sp1_cs

   jp NCcliprowlp

.NCCRnextrow

   ; this was last column, move to next row

   ; de = & next struct sp1_cs
   ; hl = & struct sp1_update
   ; stack = row

   pop hl

   ld a,d                    ; all done if there is no next sp1_cs
   or a
   jp z, done

   ld bc,9*SP1V_DISPWIDTH
   add hl,bc
   push hl
   push hl
   ex de,hl                  ; hl = & next struct sp1_cs
   exx
   ex (sp),hl

   jp NCrowloop

.NCCRremoveit

   ; need to remove this spr char from update list

   ; de = & next struct sp1_cs in sprite
   ; hl = & struct sp1_cs.update
   ; stack = & struct sp1_update, row

   push de
   ld (hl),0                 ; spr char no longer belongs to update struct
   inc hl
   inc hl
   inc hl
   push hl
   inc hl                    ; hl = & struct sp1_cs.ss_draw
   call SP1RemoveSprChar
   pop hl                    ; hl = & struct sp1_cs.type
   pop de                    ; de = & next struct sp1_cs
   
   ; invalidate so char is redrawn without sprite
   
   pop bc                    ; bc = & struct sp1_update
   push bc

   ld a,(bc)
   bit 7,(hl)                ; is spr char occluding type?
   jp z, NCCRnotoccluding0
   dec a                     ; number of occluding sprites in update struct --
   ld (bc),a

.NCCRnotoccluding0

   xor $80                   ; is char already invalidated?
   jp p, NCCRrejoinremove    ; if so skip invalidation step
   ld (bc),a                 ; mark as invalidated
   
   push bc
   exx
   pop de                    ; de = & struct sp1_update to invalidate
   ld (hl),d                 ; write & struct sp1_update into tail's ptr
   inc hl
   ld (hl),e
   ld hl,5
   add hl,de                 ; hl = & struct sp1_update.ulist
   ld (hl),0                 ; nothing after this one in list
   exx

   jp NCCRrejoinremove
