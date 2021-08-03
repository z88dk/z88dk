; void in_WaitForKey(void)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_WaitForKey
PUBLIC _in_WaitForKey

; uses : AF

.in_WaitForKey
._in_WaitForKey
   xor a
   in a,($b2)
   and 127
   cp 127
   jr z, in_WaitForKey
   ret
