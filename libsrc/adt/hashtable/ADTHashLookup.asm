; void *adt_HashLookup(struct adt_HashTable *ht, void *key)
; 08.2005 aralbrec

XLIB ADTHashLookup
LIB l_jpix, l_jphl

; enter:  BC = key to search on
;         DE = size of hash table
;         HL = hash function on key BC table size DE  MUST PRESERVE BC,IX
;              return hash index in HL, 0<=HL<DE
;         IX = key compare function on (BC,DE) MUST PRESERVE BC,HL,IX
;              return A<0 for less, A==0 for equal
; stack:  before call push hash table address (will be popped here)
; exit :  no carry = did not find key
;            carry = found key, DE = value
; used :  AF,DE,HL

.ADTHashLookup
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
   ld a,(hl)
   or a
   ret z                     ; return nc = fail, gone through list
   inc hl
   ld l,(hl)
   ld h,a                    ; hl = & next struct adt_HashCell

   ld e,(hl)
   inc hl
   ld d,(hl)                 ; de = key in table
   inc hl
   call l_jpix               ; key compare (bc,de)
   or a
   jp m, loop                ; if less, keep looking

   ret nz                    ; if not equal didn't find so return nc = fail
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                 ; de = retrieved value
   scf                       ; set carry to indicate success
   ret
