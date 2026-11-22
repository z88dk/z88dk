; void in_WaitForNoKey(void)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_WaitForNoKey
PUBLIC _in_WaitForNoKey

EXTERN in_Inkey
; uses : AF

.in_WaitForNoKey
._in_WaitForNoKey
	call	in_Inkey
	jr	nc,in_WaitForNoKey
	ret
