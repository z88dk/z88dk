;
;  Speed-optimized ZX0 decompressor by spke (191 bytes)
;
;  ver.00 by spke (27/01-23/03/2021, 191 bytes)
;  ver.01 by spke (24/03/2021, 193(+2) bytes - fixed a bug in the initialization)
;  ver.01patch2 by uniabis (25/03/2021, 191(-2) bytes - fixed a bug with elias over 8bits)
;  ver.01patch5 by uniabis (29/03/2021, 191 bytes - a bit faster)
;
;  Original ZX0 decompressors were written by Einar Saukas
;
;  This decompressor was written on the basis of "Standard" decompressor by
;  Einar Saukas and optimized for speed by spke. This decompressor is
;  about 5% faster than the "Turbo" decompressor, which is 128 bytes long.
;  It has about the same speed as the 412 bytes version of the "Mega" decompressor.
;  
;  The decompressor uses AF, AF', BC, DE, HL and IX and relies upon self-modified code.
;
;  The decompression is done in the standard way:
;
;  ld hl,FirstByteOfCompressedData
;  ld de,FirstByteOfMemoryForDecompressedData
;  call DecompressZX0
;
;  Of course, ZX0 compression algorithms are (c) 2021 Einar Saukas,
;  see https://github.com/einar-saukas/ZX0 for more information
;
;  Drop me an email if you have any comments/ideas/suggestions: zxintrospec@gmail.com
;
;  This software is provided 'as-is', without any express or implied
;  warranty.  In no event will the authors be held liable for any damages
;  arising from the use of this software.
;
;  Permission is granted to anyone to use this software for any purpose,
;  including commercial applications, and to alter it and redistribute it
;  freely, subject to the following restrictions:
;
;  1. The origin of this software must not be misrepresented; you must not
;     claim that you wrote the original software. If you use this software
;     in a product, an acknowledgment in the product documentation would be
;     appreciated but is not required.
;  2. Altered source versions must be plainly marked as such, and must not be
;     misrepresented as being the original software.
;  3. This notice may not be removed or altered from any source distribution.

DecompressZX0:
        scf 
        ex      af, af'
        ld      ix, CopyMatch1
        ld      bc, $ffff
        ld      (PrevOffset+1), bc      ; default offset is -1
        inc     bc
        ld      a, $80
        jr      RunOfLiterals           ; BC is assumed to contains 0 most of the time

        ; 7-bit offsets allow additional optimizations, based on the facts that C==0 and AF' has C ON!
ShorterOffsets:
        ex      af, af'
        sbc     a, a
        ld      (PrevOffset+2), a       ; the top byte of the offset is always $FF
        ld      a, (hl)
        inc     hl
        rra
        ld      (PrevOffset+1), a       ; note that AF' always has flag C ON
        jr      nc, LongerMatch

CopyMatch2:                             ; the case of matches with len=2
        ex      af, af'
        ld      c, 2

        ; the faster match copying code
CopyMatch1:
        push    hl                      ; preserve source

PrevOffset:
        ld      hl, $ffff               ; restore offset (default offset is -1)
        add     hl, de                  ; HL = dest - offset
        ldir
        pop     hl                      ; restore source

        ; after a match you can have either
        ; 0 + <elias length> = run of literals, or
        ; 1 + <elias offset msb> + [7-bits of offset lsb + 1-bit of length] + <elias length> = another match
AfterMatch1:
        add     a, a
        jr      nc, RunOfLiterals

UsualMatch:                             ; this is the case of usual match+offset
        add     a, a
        jr      nc, LongerOffets
        jr      nz, ShorterOffsets      ; NZ after NC == "confirmed C"
        
        ld      a, (hl)                 ; reload bits
        inc     hl
        rla

        jr      c, ShorterOffsets

LongerOffets:
        inc     c

        add     a, a                    ; inline read gamma
        rl      c
        add     a, a
        jr      nc, $-4

        call    z, ReloadReadGamma

ProcessOffset:
        ex      af, af'
        xor     a
        sub     c
        ret     z                       ; end-of-data marker (only checked for longer offsets)
        rra
        ld      (PrevOffset+2),a
        ld      a, (hl)
        inc     hl
        rra
        ld      (PrevOffset+1), a

        ; lowest bit is the first bit of the gamma code for length
        jr      c, CopyMatch2

        ; this wastes 1 t-state for longer matches far away,
        ; but saves 4 t-states for longer nearby (seems to pay off in testing)
        ld      c, b
LongerMatch:
        inc     c
        ; doing SCF here ensures that AF' has flag C ON and costs
        ; cheaper than doing SCF in the ShortestOffsets branch
        scf
        ex      af, af'

        add     a, a                    ; inline read gamma
        rl      c
        add     a, a
        jr      nc, $-4

        call    z,ReloadReadGamma

CopyMatch3:
        push    hl                      ; preserve source
        ld      hl, (PrevOffset+1)      ; restore offset
        add     hl, de                  ; HL = dest - offset

        ; because BC>=3-1, we can do 2 x LDI safely
        ldi
        ldir
        inc     c
        ldi
        pop     hl                      ; restore source

        ; after a match you can have either
        ; 0 + <elias length> = run of literals, or
        ; 1 + <elias offset msb> + [7-bits of offset lsb + 1-bit of length] + <elias length> = another match
AfterMatch3:
        add     a, a
        jr      c, UsualMatch

RunOfLiterals:
        inc     c
        add     a, a
        jr      nc, LongerRun
        jr      nz, CopyLiteral         ; NZ after NC == "confirmed C"
        
        ld      a, (hl)                 ; reload bits
        inc     hl
        rla

        jr      c, CopyLiteral

LongerRun:
        add     a, a                    ; inline read gamma
        rl      c
        add     a, a
        jr      nc, $-4

        jr      nz, CopyLiterals
        
        ld      a, (hl)                 ; reload bits
        inc     hl
        rla

        call    nc, ReadGammaAligned

CopyLiterals:
        ldi

CopyLiteral:
        ldir

        ; after a literal run you can have either
        ; 0 + <elias length> = match using a repeated offset, or
        ; 1 + <elias offset msb> + [7-bits of offset lsb + 1-bit of length] + <elias length> = another match
        add     a, a
        jr      c, UsualMatch

RepMatch:
        inc     c
        add     a, a
        jr      nc, LongerRepMatch
        jr      nz, CopyMatch1          ; NZ after NC == "confirmed C"
        
        ld      a, (hl)                 ; reload bits
        inc     hl
        rla

        jr      c, CopyMatch1

LongerRepMatch:
        add     a, a                    ; inline read gamma
        rl      c
        add     a, a
        jr      nc, $-4

        jp      nz, CopyMatch1

        ; this is a crafty equivalent of CALL ReloadReadGamma : JP CopyMatch1
        push    ix

        ;  the subroutine for reading the remainder of the partly read Elias gamma code.
        ;  it has two entry points: ReloadReadGamma first refills the bit reservoir in A,
        ;  while ReadGammaAligned assumes that the bit reservoir has just been refilled.
ReloadReadGamma:
        ld      a, (hl)                 ; reload bits
        inc     hl
        rla

        ret     c
ReadGammaAligned:
        add     a, a
        rl      c
        add     a, a
        ret     c
        add     a, a
        rl      c
        add     a, a

ReadingLongGamma:                       ; this loop does not need unrolling, as it does not get much use anyway
        ret     c
        add     a, a
        rl      c
        rl      b
        add     a, a
        jr      nz, ReadingLongGamma

        ld      a, (hl)                 ; reload bits
        inc     hl
        rla

        jr      ReadingLongGamma
