// Empathic Qubit - Jan. 2023
#include <errno.h>

#include "ticalc_fcntl.h"

__asm
	INCLUDE "../../../../lib/target/ti83p/def/Ti83p.def"
__endasm;

static void _ti_del_var_arc(unsigned long addr) __FASTCALL__ {
	__asm
	ld b,e
	ld de,0

	rst 0x28
	DEFW _DelVarArc
	__endasm;
}

/** Remove an AppVar by name */
int remove(char *name)
{
	unsigned long addr = _ti_chk_find_sym(name);
	if(!addr) {
		errno = ESTAT;
		return -1;
	}

	_ti_del_var_arc(addr);

	return 0;
}
