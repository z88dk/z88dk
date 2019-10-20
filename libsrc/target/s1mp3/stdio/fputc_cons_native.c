

static void wrapper() __naked {
#asm
PUBLIC fputc_cons_native
PUBLIC _fputc_cons_native
fputc_cons_native:
_fputc_cons_native:
	ret

#endasm
}
