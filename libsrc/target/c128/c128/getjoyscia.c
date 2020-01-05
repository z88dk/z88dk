/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: getjoyscia.c,v 1.2 2015-01-21 17:49:59 stefano Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>


extern unsigned char ciaJoy1;
extern unsigned char ciaJoy2;

unsigned char ciaJoy1;
unsigned char ciaJoy2;


/* read joy sticks.  disable interrupts before calling or cp/m's key scan */
/* routine will affect values */

void getjoyscia(void)
{
#asm

	EXTERN savecia
	EXTERN restorecia


;  uchar SaveReg;
;  SaveReg = inp(cia1+ciaDataDirA);
	call savecia
 
;  outp(cia1+ciaDataDirA,0x00);
;  ciaJoy2 = inp(cia1+ciaDataA) & ciaNone;

        push	bc
        dec     bc              ;cia1+ciaDataDirA
        xor	a
        out     (c),a

        ld      bc,$DC00        ;cia1+ciaDataA
        in	a,(c)
        ld	(_ciaJoy2),a

;  outp(cia1+ciaDataDirA,SaveReg);
        
        call	restorecia

;  SaveReg = inp(cia1+ciaDataDirB);
;	... savecia done already
        
;  outp(cia1+ciaDataDirB,0x00);
;  ciaJoy1 = inp(cia1+ciaDataB) & ciaNone;

        pop	bc		;cia1+ciaDataDirB
        xor	a
        out     (c),a

        ld      bc,$DC01        ;cia1+ciaDataB
        in	a,(c)
        ld	(_ciaJoy1),a

;  outp(cia1+ciaDataDirB,SaveReg);

	call restorecia
	
#endasm

}

