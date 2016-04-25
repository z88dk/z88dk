; void in_WaitForKey(void)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_WaitForKey
PUBLIC _in_WaitForKey

; uses : AF

.in_WaitForKey
._in_WaitForKey
   xor a
   in a,($fe)
   and 31
   cp 31
   jr z, in_WaitForKey
   ret
