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
 ld a, ixh              ;; 00DD: DD 7C
 ld a, ixl              ;; 00DF: DD 7D
 ld a, iyh              ;; 00E1: FD 7C
 ld a, iyl              ;; 00E3: FD 7D
 ld a, l                ;; 00E5: 7D
 ld b, (hl)             ;; 00E6: 46
 ld b, (ix)             ;; 00E7: DD 46 00
 ld b, (ix +0)          ;; 00EA: DD 46 00
 ld b, (ix -128)        ;; 00ED: DD 46 80
 ld b, (ix +127)        ;; 00F0: DD 46 7F
 ld b, (iy)             ;; 00F3: FD 46 00
 ld b, (iy +0)          ;; 00F6: FD 46 00
 ld b, (iy -128)        ;; 00F9: FD 46 80
 ld b, (iy +127)        ;; 00FC: FD 46 7F
 ld b, 0                ;; 00FF: 06 00
 ld b, 127              ;; 0101: 06 7F
 ld b, 255              ;; 0103: 06 FF
 ld b, a                ;; 0105: 47
 ld b, b                ;; 0106: 40
 ld b, c                ;; 0107: 41
 ld b, d                ;; 0108: 42
 ld b, e                ;; 0109: 43
 ld b, h                ;; 010A: 44
 ld b, ixh              ;; 010B: DD 44
 ld b, ixl              ;; 010D: DD 45
 ld b, iyh              ;; 010F: FD 44
 ld b, iyl              ;; 0111: FD 45
 ld b, l                ;; 0113: 45
 ld c, (hl)             ;; 0114: 4E
 ld c, (ix)             ;; 0115: DD 4E 00
 ld c, (ix +0)          ;; 0118: DD 4E 00
 ld c, (ix -128)        ;; 011B: DD 4E 80
 ld c, (ix +127)        ;; 011E: DD 4E 7F
 ld c, (iy)             ;; 0121: FD 4E 00
 ld c, (iy +0)          ;; 0124: FD 4E 00
 ld c, (iy -128)        ;; 0127: FD 4E 80
 ld c, (iy +127)        ;; 012A: FD 4E 7F
 ld c, 0                ;; 012D: 0E 00
 ld c, 127              ;; 012F: 0E 7F
 ld c, 255              ;; 0131: 0E FF
 ld c, a                ;; 0133: 4F
 ld c, b                ;; 0134: 48
 ld c, c                ;; 0135: 49
 ld c, d                ;; 0136: 4A
 ld c, e                ;; 0137: 4B
 ld c, h                ;; 0138: 4C
 ld c, ixh              ;; 0139: DD 4C
 ld c, ixl              ;; 013B: DD 4D
 ld c, iyh              ;; 013D: FD 4C
 ld c, iyl              ;; 013F: FD 4D
 ld c, l                ;; 0141: 4D
 ld d, (hl)             ;; 0142: 56
 ld d, (ix)             ;; 0143: DD 56 00
 ld d, (ix +0)          ;; 0146: DD 56 00
 ld d, (ix -128)        ;; 0149: DD 56 80
 ld d, (ix +127)        ;; 014C: DD 56 7F
 ld d, (iy)             ;; 014F: FD 56 00
 ld d, (iy +0)          ;; 0152: FD 56 00
 ld d, (iy -128)        ;; 0155: FD 56 80
 ld d, (iy +127)        ;; 0158: FD 56 7F
 ld d, 0                ;; 015B: 16 00
 ld d, 127              ;; 015D: 16 7F
 ld d, 255              ;; 015F: 16 FF
 ld d, a                ;; 0161: 57
 ld d, b                ;; 0162: 50
 ld d, c                ;; 0163: 51
 ld d, d                ;; 0164: 52
 ld d, e                ;; 0165: 53
 ld d, h                ;; 0166: 54
 ld d, ixh              ;; 0167: DD 54
 ld d, ixl              ;; 0169: DD 55
 ld d, iyh              ;; 016B: FD 54
 ld d, iyl              ;; 016D: FD 55
 ld d, l                ;; 016F: 55
 ld e, (hl)             ;; 0170: 5E
 ld e, (ix)             ;; 0171: DD 5E 00
 ld e, (ix +0)          ;; 0174: DD 5E 00
 ld e, (ix -128)        ;; 0177: DD 5E 80
 ld e, (ix +127)        ;; 017A: DD 5E 7F
 ld e, (iy)             ;; 017D: FD 5E 00
 ld e, (iy +0)          ;; 0180: FD 5E 00
 ld e, (iy -128)        ;; 0183: FD 5E 80
 ld e, (iy +127)        ;; 0186: FD 5E 7F
 ld e, 0                ;; 0189: 1E 00
 ld e, 127              ;; 018B: 1E 7F
 ld e, 255              ;; 018D: 1E FF
 ld e, a                ;; 018F: 5F
 ld e, b                ;; 0190: 58
 ld e, c                ;; 0191: 59
 ld e, d                ;; 0192: 5A
 ld e, e                ;; 0193: 5B
 ld e, h                ;; 0194: 5C
 ld e, ixh              ;; 0195: DD 5C
 ld e, ixl              ;; 0197: DD 5D
 ld e, iyh              ;; 0199: FD 5C
 ld e, iyl              ;; 019B: FD 5D
 ld e, l                ;; 019D: 5D
 ld h, (hl)             ;; 019E: 66
 ld h, (ix)             ;; 019F: DD 66 00
 ld h, (ix +0)          ;; 01A2: DD 66 00
 ld h, (ix -128)        ;; 01A5: DD 66 80
 ld h, (ix +127)        ;; 01A8: DD 66 7F
 ld h, (iy)             ;; 01AB: FD 66 00
 ld h, (iy +0)          ;; 01AE: FD 66 00
 ld h, (iy -128)        ;; 01B1: FD 66 80
 ld h, (iy +127)        ;; 01B4: FD 66 7F
 ld h, 0                ;; 01B7: 26 00
 ld h, 127              ;; 01B9: 26 7F
 ld h, 255              ;; 01BB: 26 FF
 ld h, a                ;; 01BD: 67
 ld h, b                ;; 01BE: 60
 ld h, c                ;; 01BF: 61
 ld h, d                ;; 01C0: 62
 ld h, e                ;; 01C1: 63
 ld h, h                ;; 01C2: 64
 ld h, l                ;; 01C3: 65
 ld ixh, 0              ;; 01C4: DD 26 00
 ld ixh, 127            ;; 01C7: DD 26 7F
 ld ixh, 255            ;; 01CA: DD 26 FF
 ld ixh, a              ;; 01CD: DD 67
 ld ixh, b              ;; 01CF: DD 60
 ld ixh, c              ;; 01D1: DD 61
 ld ixh, d              ;; 01D3: DD 62
 ld ixh, e              ;; 01D5: DD 63
 ld ixh, ixh            ;; 01D7: DD 64
 ld ixh, ixl            ;; 01D9: DD 65
 ld ixl, 0              ;; 01DB: DD 2E 00
 ld ixl, 127            ;; 01DE: DD 2E 7F
 ld ixl, 255            ;; 01E1: DD 2E FF
 ld ixl, a              ;; 01E4: DD 6F
 ld ixl, b              ;; 01E6: DD 68
 ld ixl, c              ;; 01E8: DD 69
 ld ixl, d              ;; 01EA: DD 6A
 ld ixl, e              ;; 01EC: DD 6B
 ld ixl, ixh            ;; 01EE: DD 6C
 ld ixl, ixl            ;; 01F0: DD 6D
 ld iyh, 0              ;; 01F2: FD 26 00
 ld iyh, 127            ;; 01F5: FD 26 7F
 ld iyh, 255            ;; 01F8: FD 26 FF
 ld iyh, a              ;; 01FB: FD 67
 ld iyh, b              ;; 01FD: FD 60
 ld iyh, c              ;; 01FF: FD 61
 ld iyh, d              ;; 0201: FD 62
 ld iyh, e              ;; 0203: FD 63
 ld iyh, iyh            ;; 0205: FD 64
 ld iyh, iyl            ;; 0207: FD 65
 ld iyl, 0              ;; 0209: FD 2E 00
 ld iyl, 127            ;; 020C: FD 2E 7F
 ld iyl, 255            ;; 020F: FD 2E FF
 ld iyl, a              ;; 0212: FD 6F
 ld iyl, b              ;; 0214: FD 68
 ld iyl, c              ;; 0216: FD 69
 ld iyl, d              ;; 0218: FD 6A
 ld iyl, e              ;; 021A: FD 6B
 ld iyl, iyh            ;; 021C: FD 6C
 ld iyl, iyl            ;; 021E: FD 6D
 ld l, (hl)             ;; 0220: 6E
 ld l, (ix)             ;; 0221: DD 6E 00
 ld l, (ix +0)          ;; 0224: DD 6E 00
 ld l, (ix -128)        ;; 0227: DD 6E 80
 ld l, (ix +127)        ;; 022A: DD 6E 7F
 ld l, (iy)             ;; 022D: FD 6E 00
 ld l, (iy +0)          ;; 0230: FD 6E 00
 ld l, (iy -128)        ;; 0233: FD 6E 80
 ld l, (iy +127)        ;; 0236: FD 6E 7F
 ld l, 0                ;; 0239: 2E 00
 ld l, 127              ;; 023B: 2E 7F
 ld l, 255              ;; 023D: 2E FF
 ld l, a                ;; 023F: 6F
 ld l, b                ;; 0240: 68
 ld l, c                ;; 0241: 69
 ld l, d                ;; 0242: 6A
 ld l, e                ;; 0243: 6B
 ld l, h                ;; 0244: 6C
 ld l, l                ;; 0245: 6D
