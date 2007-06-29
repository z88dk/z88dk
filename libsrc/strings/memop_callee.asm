; void __CALLEE__ *memop(void *dst, void *src, uint n, uint op)
; *dst = *src OP *dst
; OP: 0=load, 1=or, 2=xor, 3=and, 4=add, 5 = adc, 6=sub, 7 = sbc, 8 = rls, 9 = rrs else address of OP function
; 05.2007 aralbrec

XLIB memop_callee
XDEF ASMDISP_MEMOP_CALLEE

LIB l_jpix

.memop_callee

   pop hl
   pop ix
   pop bc
   pop de
   ex (sp),hl

.asmentry

   ; enter : ix = OP
   ;         bc = uint n
   ;         de = src
   ;         hl = dst

   ld a,b
   or c
   ret z

   push hl
   
   ld a,ixh
   or a
   jr nz, func
   
   ld a,ixl
   cp 10
   jr nc, func

   add a,a
   add a,a
   add a,opload%256
   ld ixl,a
   ld a,0
   adc a,opload/256
   ld ixh,a

   ; ix = addr of op function
   
.loop

   ld a,(de)
   jp (ix)

.return

   ld (hl),a
   inc hl
   inc de
   
   dec bc                      ; must not mess with carry flag in loop
   inc c
   dec c
   jp nz, loop
   
   inc b
   djnz loop
   
   pop hl
   ret

.func

   push bc
   push de
   push hl
   ld a,(de)
   ld e,a
   ld l,(hl)
   push hl
   push de
   call l_jpix                 ; (func)(uchar dst_byte, uchar src_byte)
   ld a,l
   pop de
   pop hl
   pop hl
   pop de
   pop bc

   ld (hl),a
   inc hl
   inc de
   
   dec bc                      ; must not mess with carry flag in loop
   inc c
   dec c
   jp nz, func
   
   inc b
   djnz func
      
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
   
.opadc

   adc a,(hl)
   jp return

.opsub

   sub (hl)
   jp return

.opsbc

   sbc a,(hl)
   jp return

.oprls

   rla
   jp return

.oprrs

   rra
   jp return

DEFC ASMDISP_MEMOP_CALLEE = asmentry - memop_callee
