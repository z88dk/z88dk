/*
 *	Get process PID
 *
 *	Uses the package system
 *
 *	djm 9/12/99
 *	Returns -1 on failure
 */

#include <z88.h>

pid_t	getpid(void)
{
#pragma asm
	INCLUDE	"packages.def"
	call_pkg(pkg_ayt)
	ld	hl,-1		;failure
	ret	c		;failed
	call_pkg(pkg_pid)	;always succeeds, preserves ix
	ld	l,a		;pkg_pid returns in a
	ld	h,0
#pragma endasm
}

