 altd ld b, (0)         ;; 002A: 76 06 00
 altd ld b, (127)       ;; 002D: 76 06 7F
 altd ld b, (255)       ;; 0030: 76 06 FF
 altd ld c, (0)         ;; 0043: 76 0E 00
 altd ld c, (127)       ;; 0046: 76 0E 7F
 altd ld c, (255)       ;; 0049: 76 0E FF
 altd ld d, (0)         ;; 005C: 76 16 00
 altd ld d, (127)       ;; 005F: 76 16 7F
 altd ld d, (255)       ;; 0062: 76 16 FF
 altd ld e, (0)         ;; 0075: 76 1E 00
 altd ld e, (127)       ;; 0078: 76 1E 7F
 altd ld e, (255)       ;; 007B: 76 1E FF
 altd ld h, (0)         ;; 008E: 76 26 00
 altd ld h, (127)       ;; 0091: 76 26 7F
 altd ld h, (255)       ;; 0094: 76 26 FF
 altd ld l, (0)         ;; 00A7: 76 2E 00
 altd ld l, (127)       ;; 00AA: 76 2E 7F
 altd ld l, (255)       ;; 00AD: 76 2E FF
 ld a, ixh              ;; 00D1: DD 7C
 ld a, ixl              ;; 00D1: DD 7D
 ld a, iyh              ;; 00D1: FD 7C
 ld a, iyl              ;; 00D1: FD 7D
 ld b, (0)              ;; 00FA: 06 00
 ld b, (127)            ;; 00FC: 06 7F
 ld b, (255)            ;; 00FE: 06 FF
 ld b, ixh              ;; 0104: DD 44
 ld b, ixl              ;; 0104: DD 45
 ld b, iyh              ;; 0104: FD 44
 ld b, iyl              ;; 0104: FD 45
 ld b', (0)             ;; 010A: 76 06 00
 ld b', (127)           ;; 010D: 76 06 7F
 ld b', (255)           ;; 0110: 76 06 FF
 ld c, (0)              ;; 0121: 0E 00
 ld c, (127)            ;; 0123: 0E 7F
 ld c, (255)            ;; 0125: 0E FF
 ld c, ixh              ;; 012B: DD 4C
 ld c, ixl              ;; 012B: DD 4D
 ld c, iyh              ;; 012B: FD 4C
 ld c, iyl              ;; 012B: FD 4D
 ld c', (0)             ;; 0131: 76 0E 00
 ld c', (127)           ;; 0134: 76 0E 7F
 ld c', (255)           ;; 0137: 76 0E FF
 ld d, (0)              ;; 0148: 16 00
 ld d, (127)            ;; 014A: 16 7F
 ld d, (255)            ;; 014C: 16 FF
 ld d, ixh              ;; 0152: DD 54
 ld d, ixl              ;; 0152: DD 55
 ld d, iyh              ;; 0152: FD 54
 ld d, iyl              ;; 0152: FD 55
 ld d', (0)             ;; 0158: 76 16 00
 ld d', (127)           ;; 015B: 76 16 7F
 ld d', (255)           ;; 015E: 76 16 FF
 ld e, (0)              ;; 016F: 1E 00
 ld e, (127)            ;; 0171: 1E 7F
 ld e, (255)            ;; 0173: 1E FF
 ld e, ixh              ;; 0179: DD 5C
 ld e, ixl              ;; 0179: DD 5D
 ld e, iyh              ;; 0179: FD 5C
 ld e, iyl              ;; 0179: FD 5D
 ld e', (0)             ;; 017F: 76 1E 00
 ld e', (127)           ;; 0182: 76 1E 7F
 ld e', (255)           ;; 0185: 76 1E FF
 ld h, (0)              ;; 0196: 26 00
 ld h, (127)            ;; 0198: 26 7F
 ld h, (255)            ;; 019A: 26 FF
 ld h', (0)             ;; 01A6: 76 26 00
 ld h', (127)           ;; 01A9: 76 26 7F
 ld h', (255)           ;; 01AC: 76 26 FF
 ld ixh, 0              ;; 01BA: DD 26 00
 ld ixh, (0)            ;; 01BA: DD 26 00
 ld ixh, 127            ;; 01BA: DD 26 7F
 ld ixh, (127)          ;; 01BA: DD 26 7F
 ld ixh, 255            ;; 01BA: DD 26 FF
 ld ixh, (255)          ;; 01BA: DD 26 FF
 ld ixh, a              ;; 01BA: DD 67
 ld ixh, b              ;; 01BA: DD 60
 ld ixh, c              ;; 01BA: DD 61
 ld ixh, d              ;; 01BA: DD 62
 ld ixh, e              ;; 01BA: DD 63
 ld ixh, ixh            ;; 01BA: DD 64
 ld ixh, ixl            ;; 01BA: DD 65
 ld ixl, 0              ;; 01BA: DD 2E 00
 ld ixl, (0)            ;; 01BA: DD 2E 00
 ld ixl, 127            ;; 01BA: DD 2E 7F
 ld ixl, (127)          ;; 01BA: DD 2E 7F
 ld ixl, 255            ;; 01BA: DD 2E FF
 ld ixl, (255)          ;; 01BA: DD 2E FF
 ld ixl, a              ;; 01BA: DD 6F
 ld ixl, b              ;; 01BA: DD 68
 ld ixl, c              ;; 01BA: DD 69
 ld ixl, d              ;; 01BA: DD 6A
 ld ixl, e              ;; 01BA: DD 6B
 ld ixl, ixh            ;; 01BA: DD 6C
 ld ixl, ixl            ;; 01BA: DD 6D
 ld iyh, 0              ;; 01BA: FD 26 00
 ld iyh, (0)            ;; 01BA: FD 26 00
 ld iyh, 127            ;; 01BA: FD 26 7F
 ld iyh, (127)          ;; 01BA: FD 26 7F
 ld iyh, 255            ;; 01BA: FD 26 FF
 ld iyh, (255)          ;; 01BA: FD 26 FF
 ld iyh, a              ;; 01BA: FD 67
 ld iyh, b              ;; 01BA: FD 60
 ld iyh, c              ;; 01BA: FD 61
 ld iyh, d              ;; 01BA: FD 62
 ld iyh, e              ;; 01BA: FD 63
 ld iyh, iyh            ;; 01BA: FD 64
 ld iyh, iyl            ;; 01BA: FD 65
 ld iyl, 0              ;; 01BA: FD 2E 00
 ld iyl, (0)            ;; 01BA: FD 2E 00
 ld iyl, 127            ;; 01BA: FD 2E 7F
 ld iyl, (127)          ;; 01BA: FD 2E 7F
 ld iyl, 255            ;; 01BA: FD 2E FF
 ld iyl, (255)          ;; 01BA: FD 2E FF
 ld iyl, a              ;; 01BA: FD 6F
 ld iyl, b              ;; 01BA: FD 68
 ld iyl, c              ;; 01BA: FD 69
 ld iyl, d              ;; 01BA: FD 6A
 ld iyl, e              ;; 01BA: FD 6B
 ld iyl, iyh            ;; 01BA: FD 6C
 ld iyl, iyl            ;; 01BA: FD 6D
 ld l, (0)              ;; 01BD: 2E 00
 ld l, (127)            ;; 01BF: 2E 7F
 ld l, (255)            ;; 01C1: 2E FF
 ld l', (0)             ;; 01CD: 76 2E 00
 ld l', (127)           ;; 01D0: 76 2E 7F
 ld l', (255)           ;; 01D3: 76 2E FF
