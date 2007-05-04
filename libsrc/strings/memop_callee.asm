; void __CALLEE__ *memop(void *dst, void *src, uint n, uchar op)
; *dst = *src OP *dst
; OP: 0=load, 1=or, 2=xor, 3=and, 4=add, 5=sub
; 05.2007 aralbrec

XLIB memop_callee
XDEF ASMDISP_MEMOP_CALLEE

.memop_callee

   pop hl
   pop bc
   ld a,c
   pop bc
   pop de
   ex (sp),hl

.asmentry

   ; enter :  a = OP
   ;         bc = uint n
   ;         de = src
   ;         hl = dst
   
   add a,a
   add a,a
   add a,opload%256
   ld ixl,a
   ld a,0
   adc a,opload/256
   ld ixh,a
   
   ; ix = addr of op function
      
   ld a,b
   or c
   ret z
   
   push hl

.loop

   ld a,(de)
   jp (ix)

.return

   ld (hl),a
   inc hl
   inc de
   
   ld a,b
   or c
   jp nz, loop
   
   pop hl
   ret
   
.opload

   nop
   jp return

.opor

   or (hl)
   jp return

.opxor

   xor (hl)
   jp return

.opand

   and (hl)
   jp return

.opadd

   add a,(hl)
   jp return

.opsub

   sub (hl)
   jp return

DEFC ASMDISP_MEMOP_CALLEE = asmentry - memop_callee
