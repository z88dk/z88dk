/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

Rewritten in assembly by Stefano Bodrato - 17/6/2008

$Id: getkeyscia.c,v 1.2 2015-01-21 17:49:59 stefano Exp $

*/

#include <stdlib.h>
#include <c128/cia.h>


extern unsigned char *ciaKeyScan;

//unsigned char ciaKeyScan[12];
#asm
._ciaKeyScan defw ciaKeyScantbl
.ciaKeyScantbl defs 12
#endasm

char *getkeyscia(void)
{

/*
  register uchar I, SaveA, SaveB, KeyMask;

  SaveA = inp(cia1+ciaDataDirA);
  SaveB = inp(cia1+ciaDataDirB);
  outp(cia1+ciaDataDirA,0xFF);
  outp(cia1+ciaDataDirB,0x00);
  for(I = 0, KeyMask = 1; I < 8; I++, KeyMask <<= 1)
  {
    outp(cia1+ciaDataA,~KeyMask);
    ciaKeyScan[I] = inp(cia1+ciaDataB);
  }
  for(KeyMask = 1; I < sizeof(ciaKeyScan); I++, KeyMask <<= 1)
  {
    outp(vicExtKey,~KeyMask);
    outp(cia1+ciaDataA,0xFF);
    ciaKeyScan[I] = inp(cia1+ciaDataB);
  }
  outp(vicExtKey,0x07);
  outp(cia1+ciaDataDirA,SaveA);
  outp(cia1+ciaDataDirB,SaveB);
*/

#asm
        EXTERN     savecia
        EXTERN     restorecia
        
        
        call    savecia         ; save CIA registers

        ; main keyboard scan loop
        dec     bc              ;cia1+ciaDataDirA
        ld      a,$ff
        out     (c),a
        inc     bc              ;cia1+ciaDataDirB
        xor     a
        out     (c),a
        
        ld      hl,ciaKeyScantbl
        push    hl
        
        ld      a,$fe
.loop1
        ld      bc,$DC00        ;cia1+ciaDataA
        out     (c),a
        ld      e,a
        inc     bc              ;cia1+ciaDataB
        in      a,(c)
        ld      (hl),a
        ld      a,e
        inc     hl
        rlca
        jr      c,loop1

;       ; extended keys scan loop
;       ld      a,$fe
;.loop2
;       ld      bc,$D02F        ;vicExtKey
;       out     (c),a
;       ld      e,a
;       ld      a,$ff
;       ld      bc,$DC00        ;cia1+ciaDataA
;       out     (c),a
;       inc     bc              ;cia1+ciaDataB
;       in      a,(c)
;       ld      (hl),a
;       ld      a,e
;       inc     hl
;       rlca
;       cp      @11110111       ; passed first three bits ?
;       jr      nz,loop2        ; no, loop..
        
        call    restorecia      ; restore CIA registers

        pop     hl      ; Point to ciaKeyScan

#endasm

}
