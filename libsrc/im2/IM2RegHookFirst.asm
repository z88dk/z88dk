; 04.2004 aralbrec

XLIB IM2RegHookFirst
XREF _im2_hookDisp, _im2_vtable

; DISABLE INTERRUPTS PRIOR TO CALLING

; For use with the generic ISR only.  Installs a hook at the front
; of the list of registered hooks for a particular generic ISR
; installed on the vector passed in.
;
; enter: DE = address of hook (subroutine)
;         L = interrupt vector where generic ISR is installed
; used : AF,BC,DE,HL

.IM2RegHookFirst
   ld h,_im2_vtable/256
   ld c,(hl)
   inc hl
   ld b,(hl)
   ld hl,_im2_hookDisp - 1
   add hl,bc            ; hl points at hooks list-1

.loop
   inc hl
   ld c,(hl)
   ld (hl),e
   inc hl
   ld a,(hl)            ; ac = old first hook
   ld (hl),d            ; insert new first hook
   ld d,a
   or c
   ret z                ; if old==NULL, done insertion
   ld e,c               ; de = old hook = new hook to insert
   jp loop
