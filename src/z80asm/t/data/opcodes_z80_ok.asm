 ld a, ( hl )           ;; 0000: 7E
 ld a, 0                ;; 0001: 3E 00
 ld a, 127              ;; 0003: 3E 7F
 ld a, 255              ;; 0005: 3E FF
 ld a, (0)              ;; 0007: 3A 00 00
 ld a, (32767)          ;; 000A: 3A FF 7F
 ld a, (65535)          ;; 000D: 3A FF FF
 ld a, a                ;; 0010: 7F
 ld a, b                ;; 0011: 78
 ld a, c                ;; 0012: 79
 ld a, d                ;; 0013: 7A
 ld a, e                ;; 0014: 7B
 ld a, h                ;; 0015: 7C
 ld a, ixh              ;; 0016: DD 7C
 ld a, ixl              ;; 0018: DD 7D
 ld a, iyh              ;; 001A: FD 7C
 ld a, iyl              ;; 001C: FD 7D
 ld a, l                ;; 001E: 7D
 ld b, ( hl )           ;; 001F: 46
 ld b, 0                ;; 0020: 06 00
 ld b, 127              ;; 0022: 06 7F
 ld b, 255              ;; 0024: 06 FF
 ld b, a                ;; 0026: 47
 ld b, b                ;; 0027: 40
 ld b, c                ;; 0028: 41
 ld b, d                ;; 0029: 42
 ld b, e                ;; 002A: 43
 ld b, h                ;; 002B: 44
 ld b, ixh              ;; 002C: DD 44
 ld b, ixl              ;; 002E: DD 45
 ld b, iyh              ;; 0030: FD 44
 ld b, iyl              ;; 0032: FD 45
 ld b, l                ;; 0034: 45
 ld c, ( hl )           ;; 0035: 4E
 ld c, 0                ;; 0036: 0E 00
 ld c, 127              ;; 0038: 0E 7F
 ld c, 255              ;; 003A: 0E FF
 ld c, a                ;; 003C: 4F
 ld c, b                ;; 003D: 48
 ld c, c                ;; 003E: 49
 ld c, d                ;; 003F: 4A
 ld c, e                ;; 0040: 4B
 ld c, h                ;; 0041: 4C
 ld c, ixh              ;; 0042: DD 4C
 ld c, ixl              ;; 0044: DD 4D
 ld c, iyh              ;; 0046: FD 4C
 ld c, iyl              ;; 0048: FD 4D
 ld c, l                ;; 004A: 4D
 ld d, ( hl )           ;; 004B: 56
 ld d, 0                ;; 004C: 16 00
 ld d, 127              ;; 004E: 16 7F
 ld d, 255              ;; 0050: 16 FF
 ld d, a                ;; 0052: 57
 ld d, b                ;; 0053: 50
 ld d, c                ;; 0054: 51
 ld d, d                ;; 0055: 52
 ld d, e                ;; 0056: 53
 ld d, h                ;; 0057: 54
 ld d, ixh              ;; 0058: DD 54
 ld d, ixl              ;; 005A: DD 55
 ld d, iyh              ;; 005C: FD 54
 ld d, iyl              ;; 005E: FD 55
 ld d, l                ;; 0060: 55
 ld e, ( hl )           ;; 0061: 5E
 ld e, 0                ;; 0062: 1E 00
 ld e, 127              ;; 0064: 1E 7F
 ld e, 255              ;; 0066: 1E FF
 ld e, a                ;; 0068: 5F
 ld e, b                ;; 0069: 58
 ld e, c                ;; 006A: 59
 ld e, d                ;; 006B: 5A
 ld e, e                ;; 006C: 5B
 ld e, h                ;; 006D: 5C
 ld e, ixh              ;; 006E: DD 5C
 ld e, ixl              ;; 0070: DD 5D
 ld e, iyh              ;; 0072: FD 5C
 ld e, iyl              ;; 0074: FD 5D
 ld e, l                ;; 0076: 5D
 ld h, ( hl )           ;; 0077: 66
 ld h, 0                ;; 0078: 26 00
 ld h, 127              ;; 007A: 26 7F
 ld h, 255              ;; 007C: 26 FF
 ld h, a                ;; 007E: 67
 ld h, b                ;; 007F: 60
 ld h, c                ;; 0080: 61
 ld h, d                ;; 0081: 62
 ld h, e                ;; 0082: 63
 ld h, h                ;; 0083: 64
 ld h, l                ;; 0084: 65
 ld ixh, 0              ;; 0085: DD 26 00
 ld ixh, 127            ;; 0088: DD 26 7F
 ld ixh, 255            ;; 008B: DD 26 FF
 ld ixh, a              ;; 008E: DD 67
 ld ixh, b              ;; 0090: DD 60
 ld ixh, c              ;; 0092: DD 61
 ld ixh, d              ;; 0094: DD 62
 ld ixh, e              ;; 0096: DD 63
 ld ixh, ixh            ;; 0098: DD 64
 ld ixh, ixl            ;; 009A: DD 65
 ld ixl, 0              ;; 009C: DD 2E 00
 ld ixl, 127            ;; 009F: DD 2E 7F
 ld ixl, 255            ;; 00A2: DD 2E FF
 ld ixl, a              ;; 00A5: DD 6F
 ld ixl, b              ;; 00A7: DD 68
 ld ixl, c              ;; 00A9: DD 69
 ld ixl, d              ;; 00AB: DD 6A
 ld ixl, e              ;; 00AD: DD 6B
 ld ixl, ixh            ;; 00AF: DD 6C
 ld ixl, ixl            ;; 00B1: DD 6D
 ld iyh, 0              ;; 00B3: FD 26 00
 ld iyh, 127            ;; 00B6: FD 26 7F
 ld iyh, 255            ;; 00B9: FD 26 FF
 ld iyh, a              ;; 00BC: FD 67
 ld iyh, b              ;; 00BE: FD 60
 ld iyh, c              ;; 00C0: FD 61
 ld iyh, d              ;; 00C2: FD 62
 ld iyh, e              ;; 00C4: FD 63
 ld iyh, iyh            ;; 00C6: FD 64
 ld iyh, iyl            ;; 00C8: FD 65
 ld iyl, 0              ;; 00CA: FD 2E 00
 ld iyl, 127            ;; 00CD: FD 2E 7F
 ld iyl, 255            ;; 00D0: FD 2E FF
 ld iyl, a              ;; 00D3: FD 6F
 ld iyl, b              ;; 00D5: FD 68
 ld iyl, c              ;; 00D7: FD 69
 ld iyl, d              ;; 00D9: FD 6A
 ld iyl, e              ;; 00DB: FD 6B
 ld iyl, iyh            ;; 00DD: FD 6C
 ld iyl, iyl            ;; 00DF: FD 6D
 ld l, ( hl )           ;; 00E1: 6E
 ld l, 0                ;; 00E2: 2E 00
 ld l, 127              ;; 00E4: 2E 7F
 ld l, 255              ;; 00E6: 2E FF
 ld l, a                ;; 00E8: 6F
 ld l, b                ;; 00E9: 68
 ld l, c                ;; 00EA: 69
 ld l, d                ;; 00EB: 6A
 ld l, e                ;; 00EC: 6B
 ld l, h                ;; 00ED: 6C
 ld l, l                ;; 00EE: 6D
