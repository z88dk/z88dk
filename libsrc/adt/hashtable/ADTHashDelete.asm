; void adt_HashDelete(struct adt_HashTable *ht)
; 09.2005 aralbrec

XLIB ADTHashDelete
LIB l_jpix
XREF _u_free

;
; This subroutine deletes the contents of the hash table (the
; hashcells) and does not deallocate the adt_HashTable or the
; hash table array
;
; enter: IX = delete function on HL = struct adt_HashCell (and HL stacked)
;             wrap up key,value members only  MUST PRESERVE HL
;             = 0 for no user wrap up (do nothing)
;        HL = &hash table array  (adt_HashTable->table)
;        BC = size of hash table
; uses : AF,BC,DE,HL

.ADTHashDelete
   ld a,ixl
   or ixh
   jr nz, notzero
   ld ix,justret

.notzero
   push hl                      ; save hash table address

.indexloop
   push hl                      ; save next index in hash table
   push bc
   ld a,(hl)
   inc hl
   ld l,(hl)
   ld h,a

.listloop
   ld a,h
   or a
   jr z, nolist

   push hl
   call l_jpix                  ; user cleanup function on HashCell
   pop hl
   inc hl
   inc hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   pop hl
   push de
   push hl
   call _u_free                 ; free struct adt_HashCell
   pop hl
   pop hl
   jp listloop

.nolist
   pop bc
   pop hl
   inc hl
   inc hl
   dec bc
   ld a,b
   or c
   jp nz, indexloop

.justret
   ret
