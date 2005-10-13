; 10.2005 aralbrec

XLIB IM2CreateGenericISRLight

; See IM2CreateGenericISR for comments.  This ISR is a light
; version that only saves registers AF,BC,DE,HL on interrupt.
;
; enter:  A = maximum number of hooks
;        DE = RAM address to copy ISR to
; exit : DE = address just past ISR
; uses : AF,BC,DE,HL

.IM2CreateGenericISRLight
   ld hl,GenericISRLight
   ld bc,_im2_hookDisp
   ldir
   add a,a
   inc a
   ld c,a
   ld l,e
   ld h,d
   inc de
   ld (hl),0
   ldir
   ret

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

DEFC _im2_hookDisp = runhooks - GenericISRLight

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
