void __FASTCALL__ func(long x) {
}

void __FASTCALL__ WaitForBOF(void)
{
#asm
WaitForBOF:
	ld	bc,0x243B
	ld	a,0x1f
	out	(c),a
	ld	bc,0x253B
	in	a,(c)
	cp	192
	jr	nz,WaitForBOF
#endasm

}
