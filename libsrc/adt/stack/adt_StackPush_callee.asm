; int __CALLEE__ adt_StackPush_callee(struct adt_Stack *s, void *item)
; 09.2005, 11.2006 aralbrec

SECTION code_clib
PUBLIC adt_StackPush_callee
PUBLIC _adt_StackPush_callee
PUBLIC ASMDISP_ADT_STACKPUSH_CALLEE

EXTERN _u_malloc

.adt_StackPush_callee
._adt_StackPush_callee

   pop hl
   pop de
   ex (sp),hl

.asmentry

; push item onto stack and update stack ptr
;
; enter: HL = struct adt_Stack *
;        DE = item
; exit : HL = 0 and no carry if fail (insufficient memory)
;        carry set if successful

   push hl
   push de
   ld hl,4             ; sizeof(struct adt_StackNode)
   push hl
   call _u_malloc
   pop bc
   pop bc              ; bc = item
   pop de              ; de = adt_Stack *
   ret nc              ; mem alloc failed, hl = 0

   push hl             ; save adt_StackNode
   
   ld (hl),c           ; hl = & new adt_StackNode
   inc hl
   ld (hl),b           ; store item
   inc hl
   ex de,hl            ; hl = adt_Stack *, de = &adt_StackNode.next

   inc (hl)            ; increase stack count
   inc hl
   jr nz, nohi
   inc (hl)
   
.nohi

   inc hl              ; hl = & adt_Stack.next
   
   ldi                 ; adt_StackNode.next = adt_Stack.next
   ldi

   pop de              ; de = &adt_StackNode

   dec hl              ; hl = &adt_Stack.next + 1b
   ld (hl),d
   dec hl
   ld (hl),e           ; new adt_StackNode at top of stack
   scf
   ret

DEFC ASMDISP_ADT_STACKPUSH_CALLEE = # asmentry - adt_StackPush_callee
