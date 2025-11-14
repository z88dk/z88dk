; void in_WaitForKey(void)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_WaitForKey
PUBLIC _in_WaitForKey

EXTERN in_Inkey

; uses : AF

.in_WaitForKey
._in_WaitForKey
	call	in_Inkey
	jr	c,in_WaitForKey
	ret
