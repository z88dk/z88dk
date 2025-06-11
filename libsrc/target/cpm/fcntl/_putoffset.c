/*
 *  Write the file offset into the FCB
 *
 *  27/1/2002 - djm
 *  11/6/2025 - feilipu (assembly)
 *
 */


#include <cpm.h>

#if defined(__SDCC_IX) || defined(__SDCC_IY)

void _putoffset(unsigned char *where,long offset)
{
    where[0] = offset & 0xFF;
    where[1] = ((unsigned long)offset >> 8 ) & 0xFF;
    where[2] = ((unsigned long)offset >> 16) & 0xFF;
}

#elif defined(__8085)

// Function _putoffset flags 0x00000280 __smallc 
// void _putoffset(unsigned char * where, long offset)
// parameter 'long offset' at sp+2 size(4)
// parameter 'unsigned char * where' at sp+6 size(2)

void _putoffset(unsigned char *where, long offset)
{
    #asm
    ld de,sp+6
    ld hl,(de)
    ld de,sp+2
    ld a,(de+)
    ld (hl+),a
    ld a,(de+)
    ld (hl+),a
    ld a,(de)
    ld (hl),a
    #endasm
}

#else

// Function _putoffset flags 0x00000280 __smallc 
// void _putoffset(unsigned char * where, long offset)
// parameter 'long offset' at sp+2 size(4)
// parameter 'unsigned char * where' at sp+6 size(2)

void _putoffset(unsigned char *where, long offset)
{
    #asm
    ld hl,6
    add hl,sp
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld hl,2
    add hl,sp
    ldi
    ldi
    ldi
    #endasm
}

#endif
