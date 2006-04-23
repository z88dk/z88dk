
; b  = row coord
; c  = col coord (in column loop)
; hl = struct sp1_update
; hl'= & struct sp1_cs
; a' = bit 0 = 1 if last row should not draw, bit 1 = 1 if last col should not draw
; iy = & clipping rectangle
; ix = & struct sp1_ss
; stack = & struct sp1_update.ulist (tail of invalidated list), row

.CCrowloop

   ld a,b
   inc b                     ; row++
   
   ; is row in clipping rectangle?
   
   sub (iy+0)
   jp c, CCcliprow0
   sub (iy+3)
   jp nc, CCcliprow0
   
   ; is this the last row?
   
   inc a
   jp nz, CCnotlastrow
   
   ; this is the last row, should it be drawn?
   
   ex af,af
   bit 0,a
   jp nz, CCcliprow1
   ex af,af
   
.CCnotlastrow

   ld c,(ix+1)               ; c = column

.CCcolloop

   ld a,c
   inc c                     ; column++
   
   ; has this update struct been removed from the display?

   bit 6,(hl)
   jr nz, CCremoved
   ex (sp),hl
   
   ; hl = & struct sp1_update.ulist (tail)
   ; stack = & struct sp1_update, row

   ; is column in clipping rectangle?

   sub (iy+1)
   jr c, CCclipcol0
   sub (iy+2)
   jr nc, CCclipcol0
   
   ; is this the last column in row?
   
   inc a
   jp nz, CCnotlastcol
   
   ; this is the last column, should it be drawn?
   
   ex af,af
   bit 1,a
   jr nz, CCclipcol1
   ex af,af

.CCnotlastcol

   exx
   inc (ix+19)               ; number of active spr chars++
   
   ; hl = & struct sp1_cs
   ; stack = & struct sp1_update, row

   ld b,(hl)
   inc hl
   ld c,(hl)                 ; bc = & next struct sp1_cs in sprite
   inc hl
   
   ld a,(hl)
   or a
   jr z, CCnoremovenec0
   
   ; first remove spr char from current update struct
   
   push bc
   push hl                   ; stack = sp1_cs.update, next sp1_cs, sp1_update, row
   ld bc,4
   add hl,bc                 ; hl = & struct sp1_cs.attr_mask
   call RemoveSprChar
   pop de
   pop hl
   ex (sp),hl
   ex de,hl
   
   ; hl = & struct sp1_cs.update
   ; de = & struct sp1_update
   ; stack = & next struct sp1_cs, row
   
   ; change update struct spr char belongs to
   
   ld b,(hl)
   inc hl
   ld c,(hl)                 ; bc = old struct sp1_update
   ld (hl),e
   dec hl
   ld (hl),d                 ; store new struct sp1_update
   
   ; do count for occluding sprites
   
   inc hl
   inc hl
   inc hl                    ; hl = & struct sp1_cs.type
   bit 7,(hl)                ; is this occluding type?
   jp z, CCnotoccl0
   ld a,(bc)
   dec a
   ld (bc),a                 ; decrease num of occl sprites in old update struct
   ld a,(de)
   inc a
   ld (de),a                 ; increase num of occl sprites in new update struct

.CCnotoccl0

   ; invalidate update chars

   ld a,(de)
   xor $80
   jp p, CCnoinvnew          ; new update struct already invalidated so skip
   ld (de),a                 ; mark it as invalidated now

   push de
   exx
   pop de                    ; de = & struct sp1_update to invalidate
   ld (hl),d                 ; write & struct sp1_update into tail's ptr
   inc hl
   ld (hl),e
   ld hl,5
   add hl,de                 ; hl = & struct sp1_update.ulist
;;;   ld (hl),0                 ; nothing after this one in list
   exx

.CCnoinvnew

   ld a,(bc)
   xor $80
   jp p, CCnoinvold          ; old update struct already invalidated so skip
   ld (bc),a                 ; mark it as invalidated now
   
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

.CCnoinvold

   ; hl = & struct sp1_cs.type
   ; de = & struct sp1_update
   ; stack = & next struct sp1_cs, row

   ; now add spr char to new update struct it occupies
   
   dec hl
   ld a,(hl)                 ; a = plane
   inc hl
   ld c,(hl)
   push bc                   ; save type
   inc hl
   ld b,h
   ld c,l                    ; bc = & struct sp1_cs.attr_mask
   ld hl,3
   add hl,de                 ; hl = & struct sp1_update.slist
   push de                   ; save sp1_update
   call AddSprChar
   pop hl
   pop af
   pop de
   
   ; hl = & struct sp1_update
   ; de = & next struct sp1_cs
   ;  f = z flag set if last col in row
   ; stack = row
   
   jr z, CCnextrow
   
   ld bc,9
   add hl,bc
   push hl
   ex de,hl                  ; hl = & next struct sp1_cs
   exx
   ex (sp),hl
   
   jp CCcolloop
   
.CCnextrow

   ; hl = & struct sp1_update
   ; de = & next struct sp1_cs
   ; stack = row

   pop hl                    ; hl = & struct sp1_update at start of row

   ld a,d                    ; all done if there is no next sp1_cs
   or a
   jp z, done

   ld bc,9*SP1V_DISPWIDTH
   add hl,bc
   push hl
   push hl
   ex de,hl
   exx
   ex (sp),hl
   
   jp CCrowloop

.CCremoved

   ex (sp),hl
   exx
   
   ; hl = & struct sp1_cs
   ; stack = & struct sp1_update, row

   ld d,(hl)
   inc hl
   ld e,(hl)
   ld bc,4
   add hl,bc
   pop bc

   ; bc = & struct sp1_update
   ; hl = & struct sp1_cs.type
   ; de = & next struct sp1_cs
   ; stack = row

   jp CCalreadyinv66

.CCnoremovenec0

   ; hl = & struct sp1_cs.update
   ; bc = & next struct sp1_cs in sprite
   ; stack = & struct sp1_update, row

   pop de                    ; de = & struct sp1_update
   ld (hl),d
   inc hl
   ld (hl),e                 ; store update struct the spr char occupies now
   inc hl
   inc hl                    ; hl = & struct sp1_cs.type
   
   ld a,(de)
   bit 7,(hl)                ; is spr char occluding?
   jp z, CCnotoccl12
   inc a                     ; increase # occluding sprites in update struct
   ld (de),a
   
.CCnotoccl12

   ; invalidate the update struct
   
   xor $80
   jp p, CCalreadyinv33      ; skip if already invalidated
   ld (de),a                 ; mark it as invalidated
   
   push de
   exx
   pop de                    ; de = & struct sp1_update to invalidate
   ld (hl),d                 ; write & struct sp1_update into tail's ptr
   inc hl
   ld (hl),e
   ld hl,5
   add hl,de                 ; hl = & struct sp1_update.ulist
   ld (hl),0                 ; nothing after this one in list
   exx

.CCalreadyinv33

   push bc
   
   ; hl = & struct sp1_cs.type
   ; de = & struct sp1_update
   ; stack = & next struct sp1_cs, row

   jp CCnoinvold             ; add spr char to update list, loop

.CCclipcol1

   ex af,af
   
.CCclipcol0

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
   jr z, CCskipremoveit

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
   inc hl                    ; hl = & struct sp1_cs.attr_mask
   call RemoveSprChar
   pop hl                    ; hl = & struct sp1_cs.type
   pop de                    ; de = & next struct sp1_cs
   
   ; invalidate so char is redrawn without sprite
   
   pop bc                    ; bc = & struct sp1_update

   ld a,(bc)
   bit 7,(hl)                ; is spr char occluding type?
   jp z, CCnotoccl44
   dec a                     ; number of occluding sprites in update struct --
   ld (bc),a

.CCnotoccl44

   xor $80                   ; is char already invalidated?
   jp p, CCalreadyinv66      ; if so skip invalidation step
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

.CCalreadyinv66

   ; bc = & struct sp1_update
   ; hl = & struct sp1_cs.type
   ; de = & next struct sp1_cs
   ; stack = row
   
   bit 6,(hl)                ; last column in row?
   jp nz, CCnextrow

   ; this is not the last column
   
   ld hl,9
   add hl,bc
   push hl
   ex de,hl
   exx
   ex (sp),hl
   
   jp CCcolloop

.CCskipremoveit

   ; hl = & struct sp1_cs.update
   ; de = & next struct sp1_cs in sprite
   ; stack = & struct sp1_update, row

   inc hl
   inc hl
   inc hl
   pop bc
   
   jp CCalreadyinv66

.CCcliprow1

   ex af,af

.CCcliprow0

   ; skipping an entire row, only need to remove
   ; spr chars from update struct list + invalidate
   ; if they are on-screen

   ex (sp),hl
   exx

.CCcliprowlp
   
   ; hl = & struct sp1_cs
   ; stack = & struct sp1_update, row

   ld d,(hl)
   inc hl
   ld e,(hl)                 ; de = & next struct sp1_cs in sprite
   inc hl
   
   ; is this spr char on the display now?
   
   ld a,(hl)
   or a
   jr nz, CCCRremoveit
   
   ; ok, not on display
   
   inc hl
   inc hl
   inc hl                    ; hl = & struct sp1_cs.type

.CCCRrejoinremove

   ; is this the last col in row?
   
   bit 6,(hl)
   pop hl                    ; hl = & struct sp1_update
   jr nz, CCCRnextrow

   ; this is not the last column in row
   
   ; hl = & struct sp1_update
   ; de = & next struct sp1_cs
   ; stack = row
   
   ld bc,9
   add hl,bc
   push hl
   ex de,hl                  ; hl = & next struct sp1_cs

   jp CCcliprowlp

.CCCRnextrow

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

   jp CCrowloop

.CCCRremoveit

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
   inc hl                    ; hl = & struct sp1_cs.attr_mask
   call RemoveSprChar
   pop hl                    ; hl = & struct sp1_cs.type
   pop de                    ; de = & next struct sp1_cs
   
   ; invalidate so char is redrawn without sprite
   
   pop bc                    ; bc = & struct sp1_update
   push bc

   ld a,(bc)
   bit 7,(hl)                ; is spr char occluding type?
   jp z, CCCRnotoccluding0
   dec a                     ; number of occluding sprites in update struct --
   ld (bc),a

.CCCRnotoccluding0

   xor $80                   ; is char already invalidated?
   jp p, CCCRrejoinremove    ; if so skip invalidation step
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

   jp CCCRrejoinremove
