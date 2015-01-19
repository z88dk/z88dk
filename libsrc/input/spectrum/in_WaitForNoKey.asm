; void in_WaitForNoKey(void)
; 09.2005 aralbrec

PUBLIC in_WaitForNoKey

; uses : AF

.in_WaitForNoKey
   xor a
   in a,($fe)
   and $1f
   cp 31
   jr nz, in_WaitForNoKey
   ret
