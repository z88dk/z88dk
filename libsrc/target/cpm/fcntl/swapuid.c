
#include <cpm.h>


int swapuid(int id) __z88dk_fastcall __naked  {
#asm
    push    hl
    ld      c,CPM_SUID
    ld      e,0xff	;query
IF !__CPU_INTEL__
	push	ix
	call	5
	pop	ix
ELSE
	call	5
ENDIF
    pop     hl
    cp      l
    ret     z           ;Existing id was the same
    ld      e,l         ;It was different, so set it
    push    af
    ld      c,CPM_SUID
IF !__CPU_INTEL__
	push	ix
	call	5
	pop	ix
ELSE
	call	5
ENDIF
    pop     af
    ld      l,a
    ld      h,0
    ret
#endasm
}
