; operations for memopi() and memopd()
; 06.2007 aralbrec

SECTION code_clib

PUBLIC memops
PUBLIC _memops

.memops
._memops
.opload

   nop
   ret

.opor

   or (hl)
   ret

.opxor

   xor (hl)
   ret

.opand

   and (hl)
   ret

.opadd

   add a,(hl)
   ret
   
.opadc

   adc a,(hl)
   ret

.opsub

   sub (hl)
   ret

.opsbc

   sbc a,(hl)
   ret

.oprls

   rla
   ret

.oprrs

   rra
   ret
