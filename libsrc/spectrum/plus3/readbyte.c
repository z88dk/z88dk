/*
 *	Read byte from file (+3DOS)
 *
 *	18/3/2000 djm
 *
 *	Not user callable - internal LIB routine
 *
 *	Enter with de = filehandle
 */


int readbyte(int handle)
{
#asm
	XREF	dodos
	ld	b,e	;file handle
	ld	iy,280	;DOS_BYTE_READ
	call	dodos
	ld	hl,-1	;EOF
	ret	nc	;error
	ld	l,c
	ld	h,0
#endasm
}
