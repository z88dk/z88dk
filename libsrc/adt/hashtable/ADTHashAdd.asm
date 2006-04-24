; void *adt_HashAdd(struct adt_HashTable *ht, void *key, void *value)
; 08.2005 aralbrec

XLIB ADTHashAdd
LIB l_jpix, l_jphl
XREF _u_malloc

; enter:  BC = key to search on
;         DE = size of hash table
;         HL = &hash function on key BC table size DE  MUST PRESERVE BC,IX
;              return hash index in HL, 0<=HL<DE
;         IX = key compare function on (BC,DE) MUST PRESERVE BC,HL,IX
;              return A<0 for less, A==0 for equal
; stack:  before call push value then hash table address (both will be popped here)
; exit :  carry = successfully added to HashTable
;                 if HL!=0 then already present value was replaced (old value in HL)
;         no carry = memory allocation error
;                    DE = value passed in on stack
; used :  AF,DE,HL

.ADTHashAdd
   call l_jphl               ; hl = hash index computed on bc=key de=table size
   add hl,hl
   ex de,hl                  ; de = offset into hash table of computed hash index
   pop hl
   ex (sp),hl                ; hl = hash table's base address
   add hl,de

; hl = &hashcell->next
; ix = key compare function
; bc = key to search on
; stack = value, return address

.loop
   push hl                   ; save lagger

   ld a,(hl)                 ; reached end of list without finding key
   or a                      ; so add new hashcell here (at stacked lagger)
   jr z, addnew

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
   jr z, keyfound

.addnew                      ; insert new hashcell at stacked lagger
   push bc
   ld hl,6                   ; sizeof(struct adt_HashCell)
   push hl
   call _u_malloc
   pop bc
   pop bc
   jr nc, allocfail          ; if memory allocation fails...

   pop de
   ex de,hl                  ; de = struct adt_HashCell, hl = lagger
   ld a,(hl)
   ld (hl),d
   inc hl
   ld d,(hl)
   ld (hl),e
   ex de,hl                  ; hl = struct adt_HashCell, ad = next ptr
   ld (hl),c
   inc hl
   ld (hl),b                 ; store key into new HashCell
   inc hl
   ld (hl),a
   inc hl
   ld (hl),d                 ; store next HashCell ptr
   inc hl
   pop af
   pop de                    ; de = value
   push af
   ld (hl),e
   inc hl
   ld (hl),d                 ; store value into new HashCell
   ld hl,0
   scf
   ret

.keyfound                    ; hl = &adt_HashCell->next
   pop de                    ; junk lagger
   inc hl
   inc hl
   pop af
   pop de                    ; de = new value
   push af
   ld a,(hl)
   ld (hl),e                 ; store new value into existing HashCell
   inc hl
   ld e,(hl)
   ld (hl),d
   ld l,a
   ld h,e                    ; hl = value stored there prior
   scf
   ret

.allocfail
   pop de                    ; junk lagger
   pop hl                    ; hl = return address
   pop de                    ; de = value passed in
   jp (hl)                   ; return with carry reset to indicate failure
