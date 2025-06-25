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
    unsigned char *offset_bytes = (unsigned char *)&offset;

    where[0] = offset_bytes[0];
    where[1] = offset_bytes[1];
    where[2] = offset_bytes[2];
}

#elif defined(__8085)

// Function _putoffset __smallc
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

#elif defined(__8080) || defined(__GBZ80)

// Function _putoffset __smallc
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
    ld a,(hl+)
    ld (de+),a
    ld a,(hl+)
    ld (de+),a
    ld a,(hl)
    ld (de),a
    #endasm
}

#else

// Function _putoffset __smallc
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
