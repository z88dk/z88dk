 altd ld b, (0)         ;; 006A: 76 06 00
 altd ld b, (127)       ;; 006D: 76 06 7F
 altd ld b, (255)       ;; 0070: 76 06 FF
 altd ld c, (0)         ;; 00A3: 76 0E 00
 altd ld c, (127)       ;; 00A6: 76 0E 7F
 altd ld c, (255)       ;; 00A9: 76 0E FF
 altd ld d, (0)         ;; 00DC: 76 16 00
 altd ld d, (127)       ;; 00DF: 76 16 7F
 altd ld d, (255)       ;; 00E2: 76 16 FF
 altd ld e, (0)         ;; 0115: 76 1E 00
 altd ld e, (127)       ;; 0118: 76 1E 7F
 altd ld e, (255)       ;; 011B: 76 1E FF
 altd ld h, (0)         ;; 014E: 76 26 00
 altd ld h, (127)       ;; 0151: 76 26 7F
 altd ld h, (255)       ;; 0154: 76 26 FF
 altd ld l, (0)         ;; 0187: 76 2E 00
 altd ld l, (127)       ;; 018A: 76 2E 7F
 altd ld l, (255)       ;; 018D: 76 2E FF
 ld a, ixh              ;; 0278: DD 7C
 ld a, ixl              ;; 0278: DD 7D
 ld a, iyh              ;; 0278: FD 7C
 ld a, iyl              ;; 0278: FD 7D
 ld b, (0)              ;; 02D9: 06 00
 ld b, (127)            ;; 02DB: 06 7F
 ld b, (255)            ;; 02DD: 06 FF
 ld b, ixh              ;; 02E3: DD 44
 ld b, ixl              ;; 02E3: DD 45
 ld b, iyh              ;; 02E3: FD 44
 ld b, iyl              ;; 02E3: FD 45
 ld b', (0)             ;; 0309: 76 06 00
 ld b', (127)           ;; 030C: 76 06 7F
 ld b', (255)           ;; 030F: 76 06 FF
 ld c, (0)              ;; 0338: 0E 00
 ld c, (127)            ;; 033A: 0E 7F
 ld c, (255)            ;; 033C: 0E FF
 ld c, ixh              ;; 0342: DD 4C
 ld c, ixl              ;; 0342: DD 4D
 ld c, iyh              ;; 0342: FD 4C
 ld c, iyl              ;; 0342: FD 4D
 ld c', (0)             ;; 0368: 76 0E 00
 ld c', (127)           ;; 036B: 76 0E 7F
 ld c', (255)           ;; 036E: 76 0E FF
 ld d, (0)              ;; 0397: 16 00
 ld d, (127)            ;; 0399: 16 7F
 ld d, (255)            ;; 039B: 16 FF
 ld d, ixh              ;; 03A1: DD 54
 ld d, ixl              ;; 03A1: DD 55
 ld d, iyh              ;; 03A1: FD 54
 ld d, iyl              ;; 03A1: FD 55
 ld d', (0)             ;; 03C7: 76 16 00
 ld d', (127)           ;; 03CA: 76 16 7F
 ld d', (255)           ;; 03CD: 76 16 FF
 ld e, (0)              ;; 03F6: 1E 00
 ld e, (127)            ;; 03F8: 1E 7F
 ld e, (255)            ;; 03FA: 1E FF
 ld e, ixh              ;; 0400: DD 5C
 ld e, ixl              ;; 0400: DD 5D
 ld e, iyh              ;; 0400: FD 5C
 ld e, iyl              ;; 0400: FD 5D
 ld e', (0)             ;; 0426: 76 1E 00
 ld e', (127)           ;; 0429: 76 1E 7F
 ld e', (255)           ;; 042C: 76 1E FF
 ld h, (0)              ;; 0455: 26 00
 ld h, (127)            ;; 0457: 26 7F
 ld h, (255)            ;; 0459: 26 FF
 ld h', (0)             ;; 0485: 76 26 00
 ld h', (127)           ;; 0488: 76 26 7F
 ld h', (255)           ;; 048B: 76 26 FF
 ld ixh, 0              ;; 0499: DD 26 00
 ld ixh, (0)            ;; 0499: DD 26 00
 ld ixh, 127            ;; 0499: DD 26 7F
 ld ixh, (127)          ;; 0499: DD 26 7F
 ld ixh, 255            ;; 0499: DD 26 FF
 ld ixh, (255)          ;; 0499: DD 26 FF
 ld ixh, a              ;; 0499: DD 67
 ld ixh, b              ;; 0499: DD 60
 ld ixh, c              ;; 0499: DD 61
 ld ixh, d              ;; 0499: DD 62
 ld ixh, e              ;; 0499: DD 63
 ld ixh, ixh            ;; 0499: DD 64
 ld ixh, ixl            ;; 0499: DD 65
 ld ixl, 0              ;; 0499: DD 2E 00
 ld ixl, (0)            ;; 0499: DD 2E 00
 ld ixl, 127            ;; 0499: DD 2E 7F
 ld ixl, (127)          ;; 0499: DD 2E 7F
 ld ixl, 255            ;; 0499: DD 2E FF
 ld ixl, (255)          ;; 0499: DD 2E FF
 ld ixl, a              ;; 0499: DD 6F
 ld ixl, b              ;; 0499: DD 68
 ld ixl, c              ;; 0499: DD 69
 ld ixl, d              ;; 0499: DD 6A
 ld ixl, e              ;; 0499: DD 6B
 ld ixl, ixh            ;; 0499: DD 6C
 ld ixl, ixl            ;; 0499: DD 6D
 ld iyh, 0              ;; 0499: FD 26 00
 ld iyh, (0)            ;; 0499: FD 26 00
 ld iyh, 127            ;; 0499: FD 26 7F
 ld iyh, (127)          ;; 0499: FD 26 7F
 ld iyh, 255            ;; 0499: FD 26 FF
 ld iyh, (255)          ;; 0499: FD 26 FF
 ld iyh, a              ;; 0499: FD 67
 ld iyh, b              ;; 0499: FD 60
 ld iyh, c              ;; 0499: FD 61
 ld iyh, d              ;; 0499: FD 62
 ld iyh, e              ;; 0499: FD 63
 ld iyh, iyh            ;; 0499: FD 64
 ld iyh, iyl            ;; 0499: FD 65
 ld iyl, 0              ;; 0499: FD 2E 00
 ld iyl, (0)            ;; 0499: FD 2E 00
 ld iyl, 127            ;; 0499: FD 2E 7F
 ld iyl, (127)          ;; 0499: FD 2E 7F
 ld iyl, 255            ;; 0499: FD 2E FF
 ld iyl, (255)          ;; 0499: FD 2E FF
 ld iyl, a              ;; 0499: FD 6F
 ld iyl, b              ;; 0499: FD 68
 ld iyl, c              ;; 0499: FD 69
 ld iyl, d              ;; 0499: FD 6A
 ld iyl, e              ;; 0499: FD 6B
 ld iyl, iyh            ;; 0499: FD 6C
 ld iyl, iyl            ;; 0499: FD 6D
 ld l, (0)              ;; 04B4: 2E 00
 ld l, (127)            ;; 04B6: 2E 7F
 ld l, (255)            ;; 04B8: 2E FF
 ld l', (0)             ;; 04E4: 76 2E 00
 ld l', (127)           ;; 04E7: 76 2E 7F
 ld l', (255)           ;; 04EA: 76 2E FF
