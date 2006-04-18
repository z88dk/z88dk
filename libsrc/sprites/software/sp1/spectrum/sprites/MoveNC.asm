

; b  = row coord
; c  = col coord (in column loop)
; hl = struct sp1_update
; hl'= & struct sp1_cs
; a' = bit 0 = 1 if last row should not draw, bit 1 = 1 if last col should not draw
; iy = & clipping rectangle
; ix = & struct sp1_ss
; stack = & struct sp1_update.ulist (tail of invalidated list)

.NCrowloop

   ld a,b
   inc b                     ; row++
   
   ; is row in clipping rectangle?
   
   sub (iy+0)
   jp c, NCcliprow0
   sub (iy+3)
   jp nc, NCcliprow0
   
   ; is this the last row?
   
   inc a
   jp nz, NCnotlastrow
   
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
   jr nz, NCremoved
   ex (sp),hl

   ; hl = & struct sp1_update.ulist (tail)
   ; stack = & struct sp1_update

   ; is column in clipping rectangle?
   
   sub (iy+1)
   jr c, NCclipcol0
   sub (iy+2)
   jr nc, NCclipcol0
   
   ; is this the last column in row?
   
   inc a                     ; z flag set if it is the last column in row
   jp nz, NCnotlastcol
   
   ; this is the last col, should it be drawn?
   
   ex af,af
   bit 1,a
   jr nz, NCclipcol1
   ex af,af

.NCnotlastcol

   exx
   push af
   
   ; hl = & struct sp1_cs
   ; stack = flag = z if last col, & struct sp1_update
   
   ; is sprite char already in update struct list?
   
   ld d,(hl)
   inc hl
   ld e,(hl)                 ; de = & next struct sp1_cs in sprite
   inc hl                    ; hl = & struct sp1_cs.update
   
   ld a,(hl)                 ; if MSB of update struct this spr char is in != 0
   or a                      ;   then already in list
   jr z, NCaddit

   ; already in update struct list so no need to add spr char to update struct list

   ; de = & next struct sp1_cs in sprite
   ; hl = & struct sp1_cs.update
   ; stack = flag = z if last col, & struct sp1_update
   
   pop bc
   pop hl

.NCrejoinaddit

   ; de = & next struct sp1_cs
   ; hl = & struct sp1_update
   ;  c = bit 6 set if last col

   ; invalidate
   
   ld a,(hl)                 ; skip if char already invalidated
   xor $80
   jp p, alreadyinv0
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

.alreadyinv0

   inc (ix+19)               ; number of active sprite chars++

   bit 6,c                   ; is this last col?
   jr nz, NCnextrow

.NCnextcol

   ; this is not the last column in row
   
   ; hl = & struct sp1_update
   ; de = & next struct sp1_cs
   
   ld bc,9
   add hl,bc
   push hl
   ex de,hl                  ; hl = & next struct sp1_cs
   exx
   ex (sp),hl

   jp NCcolloop

.NCremoved

   ex (sp),hl
   exx
   
   ; hl = & struct sp1_cs
   ; stack = & struct sp1_update
   
   ld d,(hl)
   inc hl
   ld e,(hl)                 ; de = & next struct sp1_cs in sprite
   ld bc,4
   add hl,bc                 ; hl = & struct sp1_cs.type
   
   jp NCrejoinremove

.NCclipcol1

   ex af,af

.NCclipcol0

   exx
   
   ; hl = & struct sp1_cs
   ; stack = & struct sp1_update
   
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
   
   ld a,(hl)
   and $40
   pop hl                    ; hl = & struct sp1_update
   jr z, NCnextcol

.NCnextrow

   ; this was last column, move to next row

   ; de = & next struct sp1_cs
   ; hl = & struct sp1_update

   ld a,d                    ; all done if there is no next sp1_cs
   or a
   ret z

   ld bc,9*SP1V_DISPWIDTH
   add hl,bc
   push hl
   ex de,hl                  ; hl = & next struct sp1_cs
   exx
   ex (sp),hl

   jp NCrowloop

.NCaddit

   ; add the sprite char to update struct's sprite list

   ; de = & next struct sp1_cs in sprite
   ; hl = & struct sp1_cs.update
   ; stack = flag = z if last col, & struct sp1_update

   inc hl
   inc hl
   ld a,(hl)                 ; a = plane
   inc hl
   inc hl
   ld b,h
   ld c,l                    ; bc = & struct sp1_cs.attr_mask
   
   pop hl
   ex (sp),hl                ; hl = & struct sp1_update
   push bc
   push de
   push hl                   ; stack = & struct sp1_update, & next struct sp1_cs in sprite, & sp1_cs.attr_mask, flag
   inc hl
   inc hl
   inc hl                    ; hl = & struct sp1_update.slist
   call AddSprChar           ; add sprite to update list
   pop hl
   pop de
   pop bc
   
   dec bc
   ld a,(bc)                 ; a = sprite type
   pop bc
   
   ; de = & next struct sp1_cs
   ; hl = & struct sp1_update
   ;  c = bit 6 set if last col
   ;  a = type
   
   and $80                   ; is it occluding type?
   jp z, NCrejoinaddit

   inc (hl)                  ; number of occluding sprites in update struct ++

   jp NCrejoinaddit

.NCremoveit

   ; need to remove this spr char from update list

   ; de = & next struct sp1_cs in sprite
   ; hl = & struct sp1_cs.update
   ; stack = & struct sp1_update

   push de
   inc hl
   inc hl
   inc hl
   push hl
   inc hl                    ; hl = & struct sp1_cs.attr_mask
   call RemoveSprChar
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
   ; stack = & struct sp1_update
   
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
   
   ld a,(hl)
   and $40
   pop hl                    ; hl = & struct sp1_update
   jr nz, NCCRnextrow

   ; this is not the last column in row
   
   ; hl = & struct sp1_update
   ; de = & next struct sp1_cs
   
   ld bc,9
   add hl,bc
   push hl
   ex de,hl                  ; hl = & next struct sp1_cs

   jp NCcliprowlp

.NCCRnextrow

   ; this was last column, move to next row

   ; de = & next struct sp1_cs
   ; hl = & struct sp1_update

   ld a,d                    ; all done if there is no next sp1_cs
   or a
   ret z

   ld bc,9*SP1V_DISPWIDTH
   add hl,bc
   push hl
   ex de,hl                  ; hl = & next struct sp1_cs
   exx
   ex (sp),hl

   jp NCrowloop

.NCCRremoveit

   ; need to remove this spr char from update list

   ; de = & next struct sp1_cs in sprite
   ; hl = & struct sp1_cs.update
   ; stack = & struct sp1_update

   push de
   inc hl
   inc hl
   inc hl
   push hl
   inc hl                    ; hl = & struct sp1_cs.attr_mask
   call RemoveSprChar
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

   jp NCCRrejoinremove
