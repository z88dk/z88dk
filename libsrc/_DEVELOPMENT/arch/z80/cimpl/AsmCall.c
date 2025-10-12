/*
 * ASMLIB - SDCC library for assembler and UNAPI interop v1.0
 * By Konamiman, 2/2010
 * 
 * Copyright (c) 2014 Nestor Soriano Vilchez (www.konamiman.com)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */


#include <arch/z80.h>

void AsmCall(uint16_t address, Z80_registers* regs, register_usage inRegistersDetail, register_usage outRegistersDetail) __naked
{
    __asm
    push    ix
    ld      ix,+4
    add     ix,sp

    ld      hl,(ix+0)  ;HL=Routine address
    ld      de,(ix+2) ;DE=regs address
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

    ld      bc,(ix+2) ;BC, DE, HL
    ld      de,(ix+4)
    ld      hl,(ix+6)
    dec	    a
    exx
    jr	    z,ASMRUT_DOAF

    ld      bc,(ix+8)	 ;IX
    ld      de,(ix+10) ;IY
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
    ld	    (ix+0),hl
    exx		;Main HLDEBC
    ex	    af,af	;Alternate AF
    dec 	a
    jr	    z,CALL_END

    ld      (ix+2),bc ;BC, DE, HL
    ld      (ix+4),de
    ld      (ix+6),hl
    dec	a
    jr	z,CALL_END

    exx		;Alternate HLDEBC
    pop     hl
    ld      (ix+8),hl ;IX
    push    iy
    pop     hl
    ld      (ix+10),hl ;IY
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
