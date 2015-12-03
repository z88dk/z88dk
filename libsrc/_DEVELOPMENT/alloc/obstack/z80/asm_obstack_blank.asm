
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_blank(struct obstack *ob, int size)
;
; Attempt to resize the currently growing object by
; signed size bytes.
;
; If size < 0, the object will not be allowed to shrink
; past its start address.
;
; If size > 0, additional bytes will be uninitialized.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC asm_obstack_blank
PUBLIC asm0_obstack_blank

EXTERN asm_obstack_room, error_zc

asm_obstack_blank:

   ; enter : hl = struct obstack *ob
   ;         bc = int size
   
   ; exit  : if shrinking, de = new ob->fence (where object grows from)
   ;         if growing,   de = old ob->fence (where new space in object begins)
   ;
   ;         success
   ;
   ;            carry reset
   ;            hl = struct obstack *ob
   ;
   ;         fail
   ;
   ;            carry set
   ;            hl = 0
   ;
   ; uses  : af, de, hl
   
   bit 7,b
   jr nz, shrink_object

asm0_obstack_blank:
grow_object:

   push hl                     ; save ob
   
   call asm_obstack_room       ; hl = bytes available, de = ob->fence
   
   sbc hl,bc                   ; room for request?
   jp c, error_zc - 1
   
   pop hl                      ; hl = ob
   push de                     ; save old ob->fence
   
   ex de,hl
   add hl,bc                   ; hl = fence + size = new fence
   ex de,hl                    ; de = new fence
   
   ; hl = struct obstack *ob
   ; de = new fence
   ; stack = old fence
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; ob->fence = new fence
   dec hl                      ; hl = struct obstack *ob

   pop de                      ; de = old fence
   ret

shrink_object:

   ; hl = struct obstack *ob
   ; bc = int size
   
   push hl                     ; save ob
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = ob->fence
   
   ex de,hl
   add hl,bc
   ex de,hl                    ; de = fence + size = proposed new fence
   
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = ob->object = base address of object
   
   ; if proposed fence < base address of object, set fence to base address
   
   ld a,d
   cp h
   jr c, hl_holds_fence
   
   ld a,e
   cp l
   jr c, hl_holds_fence
   
   ex de,hl
   
hl_holds_fence:

   ex de,hl                    ; de = new fence
   pop hl                      ; hl = struct obstack *ob
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; ob->fence = new fence
   dec hl                      ; hl = ob
   
   or a                        ; carry reset
   ret
