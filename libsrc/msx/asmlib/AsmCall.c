#include <arch/msx.h>

void AsmCall(uint16_t address, Z80_registers* regs, register_usage inRegistersDetail, register_usage outRegistersDetail) __naked
{
    __asm
    push    ix
    ld      ix,#4
    add     ix,sp

    ld      l,(ix+0)  ;HL=Routine address
    ld      h,(ix+1)
    ld      e,(ix+2) ;DE=regs address
    ld      d,(ix+3)
    push    de
    ld      a,(ix+5) ;A=out registers detail
    push    af
    ld	    a,(ix+4)	;A=in registers detail

    push    de
    pop     ix   ;IX=&Z80regs

    ld      de,CONT
    push    de
    push    hl

    or	    a
    ret     z   ;Execute code, then CONT (both in stack)

    exx
    ld	    l,(ix)
    ld	    h,(ix+1)	;AF
    dec	    a
    jr	    z,ASMRUT_DOAF
    exx

    ld      c,(ix+2) ;BC, DE, HL
    ld      b,(ix+3)
    ld      e,(ix+4)
    ld      d,(ix+5)
    ld      l,(ix+6)
    ld      h,(ix+7)
    dec	    a
    exx
    jr	    z,ASMRUT_DOAF

    ld      c,(ix+8)	 ;IX
    ld      b,(ix+9)
    ld      e,(ix+10) ;IY
    ld      d,(ix+11)
    push	de
    push	bc
    pop	    ix
    pop	    iy

ASMRUT_DOAF:
    push	hl
    pop	    af
    exx

    ret  ;Execute code, then CONT (both in stack)
CONT:

    ex	    af,af	;Alternate AF
    pop     af      ;out registers detail
    ex      (sp),ix ;IX to stack, now IX=&Z80regs

    or	    a
    jr	    z,CALL_END

    exx		;Alternate HLDEBC
    ex  	af,af	;Main AF
    push	af
    pop	    hl
    ld	    (ix+0),l
    ld	    (ix+1),h
    exx		;Main HLDEBC
    ex	    af,af	;Alternate AF
    dec 	a
    jr	    z,CALL_END

    ld      (ix+2),c ;BC, DE, HL
    ld      (ix+3),b
    ld      (ix+4),e
    ld      (ix+5),d
    ld      (ix+6),l
    ld      (ix+7),h
    dec	a
    jr	z,CALL_END

    exx		;Alternate HLDEBC
    pop     hl
    ld      (ix+8),l ;IX
    ld      (ix+9),h
    push    iy
    pop     hl
    ld      (ix+10),l ;IY
    ld      (ix+11),h
    exx		;Main HLDEBC

    ex	    af,af
    pop 	ix
    ret

CALL_END:
    ex	    af,af
    pop	    hl
    pop 	ix
    ret

    __endasm;
}
