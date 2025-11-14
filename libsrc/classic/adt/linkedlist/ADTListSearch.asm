; void *adt_ListSearch(struct adt_List *list, void *match, void *item1)
; 02.2003, 08.2005 aralbrec

SECTION code_clib
PUBLIC ADTListSearch
EXTERN l_jpix

; enter: HL = struct adt_List *
;        DE = item1 *
;        IX = void (*match)(DE = void *item1, BC = void *item2)  -- MUST PRESERVE BC,DE,IX,HL
;             sets carry if equal
; exit : no carry = item not found, current points past end of list
;        else  BC = item found, current points at found item
; uses : AF,BC,DE,HL


.ADTListSearch

   inc hl
   inc hl
   
   ld a,(hl)           ; a = list state
   inc hl
   or a
   jp nz, notbefore

   inc hl
   push hl             ; stack = list.current + 1
   inc hl
   ld a,(hl)
   inc hl
   jp rejoin   

.notbefore

   ld a,(hl)
   inc hl
   push hl             ; stack = list.current + 1

.rejoin

   ld l,(hl)
   ld h,a              ; hl = current NODE

.while

   ld a,h
   or l
   jr z, fail          ; if hl = NULL, failure

   ld c,(hl)
   inc hl
   ld b,(hl)           ; bc = item2 *
   inc hl              ; hl = NODE.next

   call l_jpix         ; compare two items, set carry if =
   jr c, found

   ld a,(hl)
   inc hl
   ld l,(hl)
   ld h,a
   jp while

.found

   dec hl
   dec hl              ; hl = NODE
   pop de
   ex de,hl            ; de = NODE, hl = list.current + 1
   ld (hl),e
   dec hl
   ld (hl),d           ; list.current = NODE
   dec hl
   ld (hl),1           ; current ptr is INLIST
   scf
   ret

.fail

   pop hl              ; hl = list.current + 1
   xor a
   ld (hl),a
   dec hl
   ld (hl),a           ; list.current = NULL
   dec hl
   ld (hl),2           ; current ptr past end of list
   ret
