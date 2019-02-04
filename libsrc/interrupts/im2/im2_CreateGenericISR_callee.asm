; void __CALLEE__ *im2_CreateGenericISR_callee(uchar numhooks, void *addr)
; 04.2004 aralbrec

SECTION code_clib
PUBLIC im2_CreateGenericISR_callee
PUBLIC _im2_CreateGenericISR_callee
PUBLIC ASMDISP_IM2_CREATEGENERICISR_CALLEE

EXTERN IM2CreateCommon

.im2_CreateGenericISR_callee
._im2_CreateGenericISR_callee

   pop hl
   pop de
   pop bc
   push hl
   ld a,c

.asmentry

; enter:  a = maximum number of hooks
;        de = RAM address to copy ISR to
; exit : hl = address just past ISR
; uses : af, bc, de, hl

.IM2CreateGenericISR

   ld hl,GenericISR
   jp IM2CreateCommon

.GenericISR

   call pushreg
   
.position

   ld bc,runhooks-position
   add hl,bc
   call runhooks
   jp popreg

.runhooks

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,d
   or e
   ret z

   push hl
   ex de,hl
   call JPHL
   pop hl
   ret c
   jp runhooks

.popreg

   pop iy
   pop ix
   pop hl
   pop de
   pop bc
   pop af
   exx
   ex af,af'
   pop de
   pop bc
   pop af
   pop hl
   ei
   reti

.pushreg

   ex (sp),hl
   push af
   push bc
   push de
   exx
   ex af,af'
   push af
   push bc
   push de
   push hl
   push ix
   push iy
   exx

.JPHL

   jp (hl)

DEFC ASMDISP_IM2_CREATEGENERICISR_CALLEE = # asmentry - im2_CreateGenericISR_callee
