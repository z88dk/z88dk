; void in_WaitForNoKey(void)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_WaitForNoKey
PUBLIC _in_WaitForNoKey

; uses : AF

.in_WaitForNoKey
._in_WaitForNoKey
   xor a
   in a,($fe)
   and $1f
   cp 31
   jr nz, in_WaitForNoKey
   ret
