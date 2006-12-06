; void *adt_HashRemove(struct adt_HashTable *ht, void *key)
; 09.2005, 11.2006 aralbrec

XLIB ADTHashRemove
LIB l_jphl, l_jpix
XREF _u_free

; enter:  BC = key to search on
;         DE = size of hash table
;         HL = hash function on key BC table size DE  MUST PRESERVE BC,IX
;              return hash index in HL, 0<=HL<DE
;         IX = key compare function on (BC,DE) MUST PRESERVE BC,HL,IX
;              return A<0 for less, A==0 for equal
; stack:  before call push delete() then hash table address (will be popped here)
; exit :  no carry = did not find key
;            carry = removed (key,value) pair from table, HL = value
; used :  AF,BC,DE,HL

.ADTHashRemove
   call l_jphl               ; hl = hash index computed on bc=key de=table size
   add hl,hl
   ex de,hl                  ; de = offset into hash table of computed hash index
   pop hl
   ex (sp),hl                ; hl = hash table's base address
   add hl,de

; hl = &hashcell->next
; ix = key compare function
; bc = key to search on

.loop
   push hl                   ; save lagger

   ld a,(hl)                 ; reached end of list without finding key
   or a                      ; so add new hashcell here (at stacked lagger)
   jr z, keynotfound

   inc hl
   ld l,(hl)
   ld h,a                    ; hl = next hashcell
   ld e,(hl)
   inc hl
   ld d,(hl)                 ; de = next key
   inc hl                    ; hl = &next hashcell->next

   call l_jpix               ; compare keys (BC,DE)
   or a
   jp p, stopsearch          ; either found key or went past key's proper position

   pop de                    ; junk lagger
   jp loop

.stopsearch
   jr nz, keynotfound
   pop de                    ; de = lagger
   ldi                       ; lagger->next = current HashCell->next
   ldi
   ld e,(hl)
   inc hl
   ld d,(hl)                 ; de = value in HashCell about to be deleted
   ld (hl),0
   dec hl
   ld (hl),0                 ; zero out value in the HashCell
   ld bc,-4
   add hl,bc                 ; hl = & HashCell
   pop bc                    ; bc = return address
   pop ix                    ; ix = user delete function
   push bc                   ; push return address
   push de                   ; push value
   push hl                   ; push & HashCell
   call l_jpix               ; delete(HashCell)
   pop hl   
   push hl
   call _u_free              ; free the HashCell
   pop hl
   pop hl                    ; hl = value from deleted hashcell
   scf                       ; indicate successfully removed (key,value) pair
   ret

.keynotfound
   pop de                    ; junk lagger
   pop hl                    ; hl = return address
   pop de                    ; junk delete() function
   jp (hl)
