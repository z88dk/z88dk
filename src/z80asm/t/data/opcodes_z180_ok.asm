 ld (hl), a             ;; 0000: 77
 ld (hl), b             ;; 0001: 70
 ld (hl), c             ;; 0002: 71
 ld (hl), d             ;; 0003: 72
 ld (hl), e             ;; 0004: 73
 ld (hl), h             ;; 0005: 74
 ld (hl), l             ;; 0006: 75
 ld (ix), a             ;; 0007: DD 77 00
 ld (ix), b             ;; 000A: DD 70 00
 ld (ix), c             ;; 000D: DD 71 00
 ld (ix), d             ;; 0010: DD 72 00
 ld (ix), e             ;; 0013: DD 73 00
 ld (ix), h             ;; 0016: DD 74 00
 ld (ix), l             ;; 0019: DD 75 00
 ld (ix +0), a          ;; 001C: DD 77 00
 ld (ix -128), a        ;; 001F: DD 77 80
 ld (ix +127), a        ;; 0022: DD 77 7F
 ld (ix +0), b          ;; 0025: DD 70 00
 ld (ix -128), b        ;; 0028: DD 70 80
 ld (ix +127), b        ;; 002B: DD 70 7F
 ld (ix +0), c          ;; 002E: DD 71 00
 ld (ix -128), c        ;; 0031: DD 71 80
 ld (ix +127), c        ;; 0034: DD 71 7F
 ld (ix +0), d          ;; 0037: DD 72 00
 ld (ix -128), d        ;; 003A: DD 72 80
 ld (ix +127), d        ;; 003D: DD 72 7F
 ld (ix +0), e          ;; 0040: DD 73 00
 ld (ix -128), e        ;; 0043: DD 73 80
 ld (ix +127), e        ;; 0046: DD 73 7F
 ld (ix +0), h          ;; 0049: DD 74 00
 ld (ix -128), h        ;; 004C: DD 74 80
 ld (ix +127), h        ;; 004F: DD 74 7F
 ld (ix +0), l          ;; 0052: DD 75 00
 ld (ix -128), l        ;; 0055: DD 75 80
 ld (ix +127), l        ;; 0058: DD 75 7F
 ld (iy), a             ;; 005B: FD 77 00
 ld (iy), b             ;; 005E: FD 70 00
 ld (iy), c             ;; 0061: FD 71 00
 ld (iy), d             ;; 0064: FD 72 00
 ld (iy), e             ;; 0067: FD 73 00
 ld (iy), h             ;; 006A: FD 74 00
 ld (iy), l             ;; 006D: FD 75 00
 ld (iy +0), a          ;; 0070: FD 77 00
 ld (iy -128), a        ;; 0073: FD 77 80
 ld (iy +127), a        ;; 0076: FD 77 7F
 ld (iy +0), b          ;; 0079: FD 70 00
 ld (iy -128), b        ;; 007C: FD 70 80
 ld (iy +127), b        ;; 007F: FD 70 7F
 ld (iy +0), c          ;; 0082: FD 71 00
 ld (iy -128), c        ;; 0085: FD 71 80
 ld (iy +127), c        ;; 0088: FD 71 7F
 ld (iy +0), d          ;; 008B: FD 72 00
 ld (iy -128), d        ;; 008E: FD 72 80
 ld (iy +127), d        ;; 0091: FD 72 7F
 ld (iy +0), e          ;; 0094: FD 73 00
 ld (iy -128), e        ;; 0097: FD 73 80
 ld (iy +127), e        ;; 009A: FD 73 7F
 ld (iy +0), h          ;; 009D: FD 74 00
 ld (iy -128), h        ;; 00A0: FD 74 80
 ld (iy +127), h        ;; 00A3: FD 74 7F
 ld (iy +0), l          ;; 00A6: FD 75 00
 ld (iy -128), l        ;; 00A9: FD 75 80
 ld (iy +127), l        ;; 00AC: FD 75 7F
 ld a, (hl)             ;; 00AF: 7E
 ld a, (ix)             ;; 00B0: DD 7E 00
 ld a, (ix +0)          ;; 00B3: DD 7E 00
 ld a, (ix -128)        ;; 00B6: DD 7E 80
 ld a, (ix +127)        ;; 00B9: DD 7E 7F
 ld a, (iy)             ;; 00BC: FD 7E 00
 ld a, (iy +0)          ;; 00BF: FD 7E 00
 ld a, (iy -128)        ;; 00C2: FD 7E 80
 ld a, (iy +127)        ;; 00C5: FD 7E 7F
 ld a, 0                ;; 00C8: 3E 00
 ld a, 127              ;; 00CA: 3E 7F
 ld a, 255              ;; 00CC: 3E FF
 ld a, (0)              ;; 00CE: 3A 00 00
 ld a, (32767)          ;; 00D1: 3A FF 7F
 ld a, (65535)          ;; 00D4: 3A FF FF
 ld a, a                ;; 00D7: 7F
 ld a, b                ;; 00D8: 78
 ld a, c                ;; 00D9: 79
 ld a, d                ;; 00DA: 7A
 ld a, e                ;; 00DB: 7B
 ld a, h                ;; 00DC: 7C
 ld a, l                ;; 00DD: 7D
 ld b, (hl)             ;; 00DE: 46
 ld b, (ix)             ;; 00DF: DD 46 00
 ld b, (ix +0)          ;; 00E2: DD 46 00
 ld b, (ix -128)        ;; 00E5: DD 46 80
 ld b, (ix +127)        ;; 00E8: DD 46 7F
 ld b, (iy)             ;; 00EB: FD 46 00
 ld b, (iy +0)          ;; 00EE: FD 46 00
 ld b, (iy -128)        ;; 00F1: FD 46 80
 ld b, (iy +127)        ;; 00F4: FD 46 7F
 ld b, 0                ;; 00F7: 06 00
 ld b, 127              ;; 00F9: 06 7F
 ld b, 255              ;; 00FB: 06 FF
 ld b, a                ;; 00FD: 47
 ld b, b                ;; 00FE: 40
 ld b, c                ;; 00FF: 41
 ld b, d                ;; 0100: 42
 ld b, e                ;; 0101: 43
 ld b, h                ;; 0102: 44
 ld b, l                ;; 0103: 45
 ld c, (hl)             ;; 0104: 4E
 ld c, (ix)             ;; 0105: DD 4E 00
 ld c, (ix +0)          ;; 0108: DD 4E 00
 ld c, (ix -128)        ;; 010B: DD 4E 80
 ld c, (ix +127)        ;; 010E: DD 4E 7F
 ld c, (iy)             ;; 0111: FD 4E 00
 ld c, (iy +0)          ;; 0114: FD 4E 00
 ld c, (iy -128)        ;; 0117: FD 4E 80
 ld c, (iy +127)        ;; 011A: FD 4E 7F
 ld c, 0                ;; 011D: 0E 00
 ld c, 127              ;; 011F: 0E 7F
 ld c, 255              ;; 0121: 0E FF
 ld c, a                ;; 0123: 4F
 ld c, b                ;; 0124: 48
 ld c, c                ;; 0125: 49
 ld c, d                ;; 0126: 4A
 ld c, e                ;; 0127: 4B
 ld c, h                ;; 0128: 4C
 ld c, l                ;; 0129: 4D
 ld d, (hl)             ;; 012A: 56
 ld d, (ix)             ;; 012B: DD 56 00
 ld d, (ix +0)          ;; 012E: DD 56 00
 ld d, (ix -128)        ;; 0131: DD 56 80
 ld d, (ix +127)        ;; 0134: DD 56 7F
 ld d, (iy)             ;; 0137: FD 56 00
 ld d, (iy +0)          ;; 013A: FD 56 00
 ld d, (iy -128)        ;; 013D: FD 56 80
 ld d, (iy +127)        ;; 0140: FD 56 7F
 ld d, 0                ;; 0143: 16 00
 ld d, 127              ;; 0145: 16 7F
 ld d, 255              ;; 0147: 16 FF
 ld d, a                ;; 0149: 57
 ld d, b                ;; 014A: 50
 ld d, c                ;; 014B: 51
 ld d, d                ;; 014C: 52
 ld d, e                ;; 014D: 53
 ld d, h                ;; 014E: 54
 ld d, l                ;; 014F: 55
 ld e, (hl)             ;; 0150: 5E
 ld e, (ix)             ;; 0151: DD 5E 00
 ld e, (ix +0)          ;; 0154: DD 5E 00
 ld e, (ix -128)        ;; 0157: DD 5E 80
 ld e, (ix +127)        ;; 015A: DD 5E 7F
 ld e, (iy)             ;; 015D: FD 5E 00
 ld e, (iy +0)          ;; 0160: FD 5E 00
 ld e, (iy -128)        ;; 0163: FD 5E 80
 ld e, (iy +127)        ;; 0166: FD 5E 7F
 ld e, 0                ;; 0169: 1E 00
 ld e, 127              ;; 016B: 1E 7F
 ld e, 255              ;; 016D: 1E FF
 ld e, a                ;; 016F: 5F
 ld e, b                ;; 0170: 58
 ld e, c                ;; 0171: 59
 ld e, d                ;; 0172: 5A
 ld e, e                ;; 0173: 5B
 ld e, h                ;; 0174: 5C
 ld e, l                ;; 0175: 5D
 ld h, (hl)             ;; 0176: 66
 ld h, (ix)             ;; 0177: DD 66 00
 ld h, (ix +0)          ;; 017A: DD 66 00
 ld h, (ix -128)        ;; 017D: DD 66 80
 ld h, (ix +127)        ;; 0180: DD 66 7F
 ld h, (iy)             ;; 0183: FD 66 00
 ld h, (iy +0)          ;; 0186: FD 66 00
 ld h, (iy -128)        ;; 0189: FD 66 80
 ld h, (iy +127)        ;; 018C: FD 66 7F
 ld h, 0                ;; 018F: 26 00
 ld h, 127              ;; 0191: 26 7F
 ld h, 255              ;; 0193: 26 FF
 ld h, a                ;; 0195: 67
 ld h, b                ;; 0196: 60
 ld h, c                ;; 0197: 61
 ld h, d                ;; 0198: 62
 ld h, e                ;; 0199: 63
 ld h, h                ;; 019A: 64
 ld h, l                ;; 019B: 65
 ld l, (hl)             ;; 019C: 6E
 ld l, (ix)             ;; 019D: DD 6E 00
 ld l, (ix +0)          ;; 01A0: DD 6E 00
 ld l, (ix -128)        ;; 01A3: DD 6E 80
 ld l, (ix +127)        ;; 01A6: DD 6E 7F
 ld l, (iy)             ;; 01A9: FD 6E 00
 ld l, (iy +0)          ;; 01AC: FD 6E 00
 ld l, (iy -128)        ;; 01AF: FD 6E 80
 ld l, (iy +127)        ;; 01B2: FD 6E 7F
 ld l, 0                ;; 01B5: 2E 00
 ld l, 127              ;; 01B7: 2E 7F
 ld l, 255              ;; 01B9: 2E FF
 ld l, a                ;; 01BB: 6F
 ld l, b                ;; 01BC: 68
 ld l, c                ;; 01BD: 69
 ld l, d                ;; 01BE: 6A
 ld l, e                ;; 01BF: 6B
 ld l, h                ;; 01C0: 6C
 ld l, l                ;; 01C1: 6D
