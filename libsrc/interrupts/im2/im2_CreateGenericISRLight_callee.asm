; void __CALLEE__ *im2_CreateGenericISRLight_callee(uchar numhooks, void *addr)
; 10.2005 aralbrec

SECTION code_clib
PUBLIC im2_CreateGenericISRLight_callee
PUBLIC _im2_CreateGenericISRLight_callee
PUBLIC ASMDISP_IM2_CREATEGENERICISRLIGHT_CALLEE

EXTERN IM2CreateCommon

.im2_CreateGenericISRLight_callee
._im2_CreateGenericISRLight_callee

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

.IM2CreateGenericISRLight

   ld hl,GenericISRLight
   jp IM2CreateCommon

.GenericISRLight

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
   
.JPHL

   jp (hl)

DEFC ASMDISP_IM2_CREATEGENERICISRLIGHT_CALLEE = # asmentry - im2_CreateGenericISRLight_callee
