; 04.2004 aralbrec

XLIB IM2CreateGenericISR
XDEF _im2_hookDisp

; Copies a generic interrupt service routine to the given address
; in RAM.  This ISR must be installed on vector(s) with a separate
; call to im2_installISR.  The generic ISR can have multiple hooks
; registered with it, causing each hook to be called in sequence.
; If any of those hooks set the carry flag on exit, succeeding
; hooks are not called.  The maximum number of hooks for
; a specific generic ISR is specified as a parameter to this
; create function.  The ISR size is 15+hooks*2 bytes in length.
;
; enter:  A = maximum number of hooks
;        DE = RAM address to copy ISR to
; exit : DE = address just past ISR
; uses : AF,BC,DE,HL

.IM2CreateGenericISR
   ld hl,GenericISR
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

DEFC _im2_hookDisp = runhooks - GenericISR

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
