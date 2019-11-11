 ld b, ixh              ;; 0000:  DD 44
 ld b, ixl              ;; 0002:  DD 45
 ld c, ixh              ;; 0004:  DD 4C
 ld c, ixl              ;; 0006:  DD 4D
 ld d, ixh              ;; 0008:  DD 54
 ld d, ixl              ;; 000A:  DD 55
 ld e, ixh              ;; 000C:  DD 5C
 ld e, ixl              ;; 000E:  DD 5D
 ld ixh, ixh            ;; 0010:  DD 64
 ld ixh, ixl            ;; 0012:  DD 65
 ld ixl, ixh            ;; 0014:  DD 6C
 ld ixl, ixl            ;; 0016:  DD 6D
 ld a, ixh              ;; 0018:  DD 7C
 ld a, ixl              ;; 001A:  DD 7D
 ld b, iyh              ;; 001C:  FD 44
 ld b, iyl              ;; 001E:  FD 45
 ld c, iyh              ;; 0020:  FD 4C
 ld c, iyl              ;; 0022:  FD 4D
 ld d, iyh              ;; 0024:  FD 54
 ld d, iyl              ;; 0026:  FD 55
 ld e, iyh              ;; 0028:  FD 5C
 ld e, iyl              ;; 002A:  FD 5D
 ld iyh, iyh            ;; 002C:  FD 64
 ld iyh, iyl            ;; 002E:  FD 65
 ld iyl, iyh            ;; 0030:  FD 6C
 ld iyl, iyl            ;; 0032:  FD 6D
 ld a, iyh              ;; 0034:  FD 7C
 ld a, iyl              ;; 0036:  FD 7D
 ld b, 0                ;; 0038:  06 00
 ld b, 85               ;; 003A:  06 55
 ld b, 170              ;; 003C:  06 AA
 ld b, 255              ;; 003E:  06 FF
 ld c, 0                ;; 0040:  0E 00
 ld c, 85               ;; 0042:  0E 55
 ld c, 170              ;; 0044:  0E AA
 ld c, 255              ;; 0046:  0E FF
 ld d, 0                ;; 0048:  16 00
 ld d, 85               ;; 004A:  16 55
 ld d, 170              ;; 004C:  16 AA
 ld d, 255              ;; 004E:  16 FF
 ld e, 0                ;; 0050:  1E 00
 ld e, 85               ;; 0052:  1E 55
 ld e, 170              ;; 0054:  1E AA
 ld e, 255              ;; 0056:  1E FF
 ld h, 0                ;; 0058:  26 00
 ld h, 85               ;; 005A:  26 55
 ld h, 170              ;; 005C:  26 AA
 ld h, 255              ;; 005E:  26 FF
 ld l, 0                ;; 0060:  2E 00
 ld l, 85               ;; 0062:  2E 55
 ld l, 170              ;; 0064:  2E AA
 ld l, 255              ;; 0066:  2E FF
 ld a, 0                ;; 0068:  3E 00
 ld a, 85               ;; 006A:  3E 55
 ld a, 170              ;; 006C:  3E AA
 ld a, 255              ;; 006E:  3E FF
 ld ixh, 0              ;; 0070:  DD 26 00
 ld ixh, 85             ;; 0073:  DD 26 55
 ld ixh, 170            ;; 0076:  DD 26 AA
 ld ixh, 255            ;; 0079:  DD 26 FF
 ld ixl, 0              ;; 007C:  DD 2E 00
 ld ixl, 85             ;; 007F:  DD 2E 55
 ld ixl, 170            ;; 0082:  DD 2E AA
 ld ixl, 255            ;; 0085:  DD 2E FF
 ld iyh, 0              ;; 0088:  FD 26 00
 ld iyh, 85             ;; 008B:  FD 26 55
 ld iyh, 170            ;; 008E:  FD 26 AA
 ld iyh, 255            ;; 0091:  FD 26 FF
 ld iyl, 0              ;; 0094:  FD 2E 00
 ld iyl, 85             ;; 0097:  FD 2E 55
 ld iyl, 170            ;; 009A:  FD 2E AA
 ld iyl, 255            ;; 009D:  FD 2E FF
 ld b, (hl)             ;; 00A0:  46
 ld c, (hl)             ;; 00A1:  4E
 ld d, (hl)             ;; 00A2:  56
 ld e, (hl)             ;; 00A3:  5E
 ld h, (hl)             ;; 00A4:  66
 ld l, (hl)             ;; 00A5:  6E
 ld a, (hl)             ;; 00A6:  7E
 ld b, (ix + -128)      ;; 00A7:  DD 46 80
 ld b, (ix)             ;; 00AA:  DD 46 00
 ld b, (ix + 127)       ;; 00AD:  DD 46 7F
 ld c, (ix + -128)      ;; 00B0:  DD 4E 80
 ld c, (ix)             ;; 00B3:  DD 4E 00
 ld c, (ix + 127)       ;; 00B6:  DD 4E 7F
 ld d, (ix + -128)      ;; 00B9:  DD 56 80
 ld d, (ix)             ;; 00BC:  DD 56 00
 ld d, (ix + 127)       ;; 00BF:  DD 56 7F
 ld e, (ix + -128)      ;; 00C2:  DD 5E 80
 ld e, (ix)             ;; 00C5:  DD 5E 00
 ld e, (ix + 127)       ;; 00C8:  DD 5E 7F
 ld h, (ix + -128)      ;; 00CB:  DD 66 80
 ld h, (ix)             ;; 00CE:  DD 66 00
 ld h, (ix + 127)       ;; 00D1:  DD 66 7F
 ld l, (ix + -128)      ;; 00D4:  DD 6E 80
 ld l, (ix)             ;; 00D7:  DD 6E 00
 ld l, (ix + 127)       ;; 00DA:  DD 6E 7F
 ld a, (ix + -128)      ;; 00DD:  DD 7E 80
 ld a, (ix)             ;; 00E0:  DD 7E 00
 ld a, (ix + 127)       ;; 00E3:  DD 7E 7F
 ld b, (iy + -128)      ;; 00E6:  FD 46 80
 ld b, (iy)             ;; 00E9:  FD 46 00
 ld b, (iy + 127)       ;; 00EC:  FD 46 7F
 ld c, (iy + -128)      ;; 00EF:  FD 4E 80
 ld c, (iy)             ;; 00F2:  FD 4E 00
 ld c, (iy + 127)       ;; 00F5:  FD 4E 7F
 ld d, (iy + -128)      ;; 00F8:  FD 56 80
 ld d, (iy)             ;; 00FB:  FD 56 00
 ld d, (iy + 127)       ;; 00FE:  FD 56 7F
 ld e, (iy + -128)      ;; 0101:  FD 5E 80
 ld e, (iy)             ;; 0104:  FD 5E 00
 ld e, (iy + 127)       ;; 0107:  FD 5E 7F
 ld h, (iy + -128)      ;; 010A:  FD 66 80
 ld h, (iy)             ;; 010D:  FD 66 00
 ld h, (iy + 127)       ;; 0110:  FD 66 7F
 ld l, (iy + -128)      ;; 0113:  FD 6E 80
 ld l, (iy)             ;; 0116:  FD 6E 00
 ld l, (iy + 127)       ;; 0119:  FD 6E 7F
 ld a, (iy + -128)      ;; 011C:  FD 7E 80
 ld a, (iy)             ;; 011F:  FD 7E 00
 ld a, (iy + 127)       ;; 0122:  FD 7E 7F
 ld (hl), b             ;; 0125:  70
 ld (hl), c             ;; 0126:  71
 ld (hl), d             ;; 0127:  72
 ld (hl), e             ;; 0128:  73
 ld (hl), h             ;; 0129:  74
 ld (hl), l             ;; 012A:  75
 ld (hl), a             ;; 012B:  77
 ld (ix + -128), b      ;; 012C:  DD 70 80
 ld (ix), b             ;; 012F:  DD 70 00
 ld (ix + 127), b       ;; 0132:  DD 70 7F
 ld (ix + -128), c      ;; 0135:  DD 71 80
 ld (ix), c             ;; 0138:  DD 71 00
 ld (ix + 127), c       ;; 013B:  DD 71 7F
 ld (ix + -128), d      ;; 013E:  DD 72 80
 ld (ix), d             ;; 0141:  DD 72 00
 ld (ix + 127), d       ;; 0144:  DD 72 7F
 ld (ix + -128), e      ;; 0147:  DD 73 80
 ld (ix), e             ;; 014A:  DD 73 00
 ld (ix + 127), e       ;; 014D:  DD 73 7F
 ld (ix + -128), h      ;; 0150:  DD 74 80
 ld (ix), h             ;; 0153:  DD 74 00
 ld (ix + 127), h       ;; 0156:  DD 74 7F
 ld (ix + -128), l      ;; 0159:  DD 75 80
 ld (ix), l             ;; 015C:  DD 75 00
 ld (ix + 127), l       ;; 015F:  DD 75 7F
 ld (ix + -128), a      ;; 0162:  DD 77 80
 ld (ix), a             ;; 0165:  DD 77 00
 ld (ix + 127), a       ;; 0168:  DD 77 7F
 ld (iy + -128), b      ;; 016B:  FD 70 80
 ld (iy), b             ;; 016E:  FD 70 00
 ld (iy + 127), b       ;; 0171:  FD 70 7F
 ld (iy + -128), c      ;; 0174:  FD 71 80
 ld (iy), c             ;; 0177:  FD 71 00
 ld (iy + 127), c       ;; 017A:  FD 71 7F
 ld (iy + -128), d      ;; 017D:  FD 72 80
 ld (iy), d             ;; 0180:  FD 72 00
 ld (iy + 127), d       ;; 0183:  FD 72 7F
 ld (iy + -128), e      ;; 0186:  FD 73 80
 ld (iy), e             ;; 0189:  FD 73 00
 ld (iy + 127), e       ;; 018C:  FD 73 7F
 ld (iy + -128), h      ;; 018F:  FD 74 80
 ld (iy), h             ;; 0192:  FD 74 00
 ld (iy + 127), h       ;; 0195:  FD 74 7F
 ld (iy + -128), l      ;; 0198:  FD 75 80
 ld (iy), l             ;; 019B:  FD 75 00
 ld (iy + 127), l       ;; 019E:  FD 75 7F
 ld (iy + -128), a      ;; 01A1:  FD 77 80
 ld (iy), a             ;; 01A4:  FD 77 00
 ld (iy + 127), a       ;; 01A7:  FD 77 7F
 ld (hl), 0             ;; 01AA:  36 00
 ld (hl), 85            ;; 01AC:  36 55
 ld (hl), 170           ;; 01AE:  36 AA
 ld (hl), 255           ;; 01B0:  36 FF
 ld (ix + -128), 0      ;; 01B2:  DD 36 80 00
 ld (ix), 0             ;; 01B6:  DD 36 00 00
 ld (ix + 127), 0       ;; 01BA:  DD 36 7F 00
 ld (ix + -128), 85     ;; 01BE:  DD 36 80 55
 ld (ix), 85            ;; 01C2:  DD 36 00 55
 ld (ix + 127), 85      ;; 01C6:  DD 36 7F 55
 ld (ix + -128), 170    ;; 01CA:  DD 36 80 AA
 ld (ix), 170           ;; 01CE:  DD 36 00 AA
 ld (ix + 127), 170     ;; 01D2:  DD 36 7F AA
 ld (ix + -128), 255    ;; 01D6:  DD 36 80 FF
 ld (ix), 255           ;; 01DA:  DD 36 00 FF
 ld (ix + 127), 255     ;; 01DE:  DD 36 7F FF
 ld (iy + -128), 0      ;; 01E2:  FD 36 80 00
 ld (iy), 0             ;; 01E6:  FD 36 00 00
 ld (iy + 127), 0       ;; 01EA:  FD 36 7F 00
 ld (iy + -128), 85     ;; 01EE:  FD 36 80 55
 ld (iy), 85            ;; 01F2:  FD 36 00 55
 ld (iy + 127), 85      ;; 01F6:  FD 36 7F 55
 ld (iy + -128), 170    ;; 01FA:  FD 36 80 AA
 ld (iy), 170           ;; 01FE:  FD 36 00 AA
 ld (iy + 127), 170     ;; 0202:  FD 36 7F AA
 ld (iy + -128), 255    ;; 0206:  FD 36 80 FF
 ld (iy), 255           ;; 020A:  FD 36 00 FF
 ld (iy + 127), 255     ;; 020E:  FD 36 7F FF
 ld a, (bc)             ;; 0212:  0A
 ld a, (de)             ;; 0213:  1A
 ld (bc), a             ;; 0214:  02
 ld (de), a             ;; 0215:  12
 ld a, (0)              ;; 0216:  3A 00 00
 ld a, (291)            ;; 0219:  3A 23 01
 ld a, (17767)          ;; 021C:  3A 67 45
 ld a, (35243)          ;; 021F:  3A AB 89
 ld a, (52719)          ;; 0222:  3A EF CD
 ld a, (65535)          ;; 0225:  3A FF FF
 ld (0), a              ;; 0228:  32 00 00
 ld (291), a            ;; 022B:  32 23 01
 ld (17767), a          ;; 022E:  32 67 45
 ld (35243), a          ;; 0231:  32 AB 89
 ld (52719), a          ;; 0234:  32 EF CD
 ld (65535), a          ;; 0237:  32 FF FF
 add a, b               ;; 023A:  80
 add a, c               ;; 023B:  81
 add a, d               ;; 023C:  82
 add a, e               ;; 023D:  83
 add a, h               ;; 023E:  84
 add a, l               ;; 023F:  85
 add a, (hl)            ;; 0240:  86
 add a, a               ;; 0241:  87
 adc a, b               ;; 0242:  88
 adc a, c               ;; 0243:  89
 adc a, d               ;; 0244:  8A
 adc a, e               ;; 0245:  8B
 adc a, h               ;; 0246:  8C
 adc a, l               ;; 0247:  8D
 adc a, (hl)            ;; 0248:  8E
 adc a, a               ;; 0249:  8F
 sub a, b               ;; 024A:  90
 sub a, c               ;; 024B:  91
 sub a, d               ;; 024C:  92
 sub a, e               ;; 024D:  93
 sub a, h               ;; 024E:  94
 sub a, l               ;; 024F:  95
 sub a, (hl)            ;; 0250:  96
 sub a, a               ;; 0251:  97
 sbc a, b               ;; 0252:  98
 sbc a, c               ;; 0253:  99
 sbc a, d               ;; 0254:  9A
 sbc a, e               ;; 0255:  9B
 sbc a, h               ;; 0256:  9C
 sbc a, l               ;; 0257:  9D
 sbc a, (hl)            ;; 0258:  9E
 sbc a, a               ;; 0259:  9F
 and a, b               ;; 025A:  A0
 and a, c               ;; 025B:  A1
 and a, d               ;; 025C:  A2
 and a, e               ;; 025D:  A3
 and a, h               ;; 025E:  A4
 and a, l               ;; 025F:  A5
 and a, (hl)            ;; 0260:  A6
 and a, a               ;; 0261:  A7
 xor a, b               ;; 0262:  A8
 xor a, c               ;; 0263:  A9
 xor a, d               ;; 0264:  AA
 xor a, e               ;; 0265:  AB
 xor a, h               ;; 0266:  AC
 xor a, l               ;; 0267:  AD
 xor a, (hl)            ;; 0268:  AE
 xor a, a               ;; 0269:  AF
 or a, b                ;; 026A:  B0
 or a, c                ;; 026B:  B1
 or a, d                ;; 026C:  B2
 or a, e                ;; 026D:  B3
 or a, h                ;; 026E:  B4
 or a, l                ;; 026F:  B5
 or a, (hl)             ;; 0270:  B6
 or a, a                ;; 0271:  B7
 cp a, b                ;; 0272:  B8
 cp a, c                ;; 0273:  B9
 cp a, d                ;; 0274:  BA
 cp a, e                ;; 0275:  BB
 cp a, h                ;; 0276:  BC
 cp a, l                ;; 0277:  BD
 cp a, (hl)             ;; 0278:  BE
 cp a, a                ;; 0279:  BF
 add b                  ;; 027A:  80
 add c                  ;; 027B:  81
 add d                  ;; 027C:  82
 add e                  ;; 027D:  83
 add h                  ;; 027E:  84
 add l                  ;; 027F:  85
 add (hl)               ;; 0280:  86
 add a                  ;; 0281:  87
 adc b                  ;; 0282:  88
 adc c                  ;; 0283:  89
 adc d                  ;; 0284:  8A
 adc e                  ;; 0285:  8B
 adc h                  ;; 0286:  8C
 adc l                  ;; 0287:  8D
 adc (hl)               ;; 0288:  8E
 adc a                  ;; 0289:  8F
 sub b                  ;; 028A:  90
 sub c                  ;; 028B:  91
 sub d                  ;; 028C:  92
 sub e                  ;; 028D:  93
 sub h                  ;; 028E:  94
 sub l                  ;; 028F:  95
 sub (hl)               ;; 0290:  96
 sub a                  ;; 0291:  97
 sbc b                  ;; 0292:  98
 sbc c                  ;; 0293:  99
 sbc d                  ;; 0294:  9A
 sbc e                  ;; 0295:  9B
 sbc h                  ;; 0296:  9C
 sbc l                  ;; 0297:  9D
 sbc (hl)               ;; 0298:  9E
 sbc a                  ;; 0299:  9F
 and b                  ;; 029A:  A0
 and c                  ;; 029B:  A1
 and d                  ;; 029C:  A2
 and e                  ;; 029D:  A3
 and h                  ;; 029E:  A4
 and l                  ;; 029F:  A5
 and (hl)               ;; 02A0:  A6
 and a                  ;; 02A1:  A7
 xor b                  ;; 02A2:  A8
 xor c                  ;; 02A3:  A9
 xor d                  ;; 02A4:  AA
 xor e                  ;; 02A5:  AB
 xor h                  ;; 02A6:  AC
 xor l                  ;; 02A7:  AD
 xor (hl)               ;; 02A8:  AE
 xor a                  ;; 02A9:  AF
 or b                   ;; 02AA:  B0
 or c                   ;; 02AB:  B1
 or d                   ;; 02AC:  B2
 or e                   ;; 02AD:  B3
 or h                   ;; 02AE:  B4
 or l                   ;; 02AF:  B5
 or (hl)                ;; 02B0:  B6
 or a                   ;; 02B1:  B7
 cp b                   ;; 02B2:  B8
 cp c                   ;; 02B3:  B9
 cp d                   ;; 02B4:  BA
 cp e                   ;; 02B5:  BB
 cp h                   ;; 02B6:  BC
 cp l                   ;; 02B7:  BD
 cp (hl)                ;; 02B8:  BE
 cp a                   ;; 02B9:  BF
 add a, (ix+-128)       ;; 02BA:  DD 86 80
 add a, (ix)            ;; 02BD:  DD 86 00
 add a, (ix+127)        ;; 02C0:  DD 86 7F
 adc a, (ix+-128)       ;; 02C3:  DD 8E 80
 adc a, (ix)            ;; 02C6:  DD 8E 00
 adc a, (ix+127)        ;; 02C9:  DD 8E 7F
 sub a, (ix+-128)       ;; 02CC:  DD 96 80
 sub a, (ix)            ;; 02CF:  DD 96 00
 sub a, (ix+127)        ;; 02D2:  DD 96 7F
 sbc a, (ix+-128)       ;; 02D5:  DD 9E 80
 sbc a, (ix)            ;; 02D8:  DD 9E 00
 sbc a, (ix+127)        ;; 02DB:  DD 9E 7F
 and a, (ix+-128)       ;; 02DE:  DD A6 80
 and a, (ix)            ;; 02E1:  DD A6 00
 and a, (ix+127)        ;; 02E4:  DD A6 7F
 xor a, (ix+-128)       ;; 02E7:  DD AE 80
 xor a, (ix)            ;; 02EA:  DD AE 00
 xor a, (ix+127)        ;; 02ED:  DD AE 7F
 or a, (ix+-128)        ;; 02F0:  DD B6 80
 or a, (ix)             ;; 02F3:  DD B6 00
 or a, (ix+127)         ;; 02F6:  DD B6 7F
 cp a, (ix+-128)        ;; 02F9:  DD BE 80
 cp a, (ix)             ;; 02FC:  DD BE 00
 cp a, (ix+127)         ;; 02FF:  DD BE 7F
 add (ix+-128)          ;; 0302:  DD 86 80
 add (ix)               ;; 0305:  DD 86 00
 add (ix+127)           ;; 0308:  DD 86 7F
 adc (ix+-128)          ;; 030B:  DD 8E 80
 adc (ix)               ;; 030E:  DD 8E 00
 adc (ix+127)           ;; 0311:  DD 8E 7F
 sub (ix+-128)          ;; 0314:  DD 96 80
 sub (ix)               ;; 0317:  DD 96 00
 sub (ix+127)           ;; 031A:  DD 96 7F
 sbc (ix+-128)          ;; 031D:  DD 9E 80
 sbc (ix)               ;; 0320:  DD 9E 00
 sbc (ix+127)           ;; 0323:  DD 9E 7F
 and (ix+-128)          ;; 0326:  DD A6 80
 and (ix)               ;; 0329:  DD A6 00
 and (ix+127)           ;; 032C:  DD A6 7F
 xor (ix+-128)          ;; 032F:  DD AE 80
 xor (ix)               ;; 0332:  DD AE 00
 xor (ix+127)           ;; 0335:  DD AE 7F
 or (ix+-128)           ;; 0338:  DD B6 80
 or (ix)                ;; 033B:  DD B6 00
 or (ix+127)            ;; 033E:  DD B6 7F
 cp (ix+-128)           ;; 0341:  DD BE 80
 cp (ix)                ;; 0344:  DD BE 00
 cp (ix+127)            ;; 0347:  DD BE 7F
 add a, (iy+-128)       ;; 034A:  FD 86 80
 add a, (iy)            ;; 034D:  FD 86 00
 add a, (iy+127)        ;; 0350:  FD 86 7F
 adc a, (iy+-128)       ;; 0353:  FD 8E 80
 adc a, (iy)            ;; 0356:  FD 8E 00
 adc a, (iy+127)        ;; 0359:  FD 8E 7F
 sub a, (iy+-128)       ;; 035C:  FD 96 80
 sub a, (iy)            ;; 035F:  FD 96 00
 sub a, (iy+127)        ;; 0362:  FD 96 7F
 sbc a, (iy+-128)       ;; 0365:  FD 9E 80
 sbc a, (iy)            ;; 0368:  FD 9E 00
 sbc a, (iy+127)        ;; 036B:  FD 9E 7F
 and a, (iy+-128)       ;; 036E:  FD A6 80
 and a, (iy)            ;; 0371:  FD A6 00
 and a, (iy+127)        ;; 0374:  FD A6 7F
 xor a, (iy+-128)       ;; 0377:  FD AE 80
 xor a, (iy)            ;; 037A:  FD AE 00
 xor a, (iy+127)        ;; 037D:  FD AE 7F
 or a, (iy+-128)        ;; 0380:  FD B6 80
 or a, (iy)             ;; 0383:  FD B6 00
 or a, (iy+127)         ;; 0386:  FD B6 7F
 cp a, (iy+-128)        ;; 0389:  FD BE 80
 cp a, (iy)             ;; 038C:  FD BE 00
 cp a, (iy+127)         ;; 038F:  FD BE 7F
 add (iy+-128)          ;; 0392:  FD 86 80
 add (iy)               ;; 0395:  FD 86 00
 add (iy+127)           ;; 0398:  FD 86 7F
 adc (iy+-128)          ;; 039B:  FD 8E 80
 adc (iy)               ;; 039E:  FD 8E 00
 adc (iy+127)           ;; 03A1:  FD 8E 7F
 sub (iy+-128)          ;; 03A4:  FD 96 80
 sub (iy)               ;; 03A7:  FD 96 00
 sub (iy+127)           ;; 03AA:  FD 96 7F
 sbc (iy+-128)          ;; 03AD:  FD 9E 80
 sbc (iy)               ;; 03B0:  FD 9E 00
 sbc (iy+127)           ;; 03B3:  FD 9E 7F
 and (iy+-128)          ;; 03B6:  FD A6 80
 and (iy)               ;; 03B9:  FD A6 00
 and (iy+127)           ;; 03BC:  FD A6 7F
 xor (iy+-128)          ;; 03BF:  FD AE 80
 xor (iy)               ;; 03C2:  FD AE 00
 xor (iy+127)           ;; 03C5:  FD AE 7F
 or (iy+-128)           ;; 03C8:  FD B6 80
 or (iy)                ;; 03CB:  FD B6 00
 or (iy+127)            ;; 03CE:  FD B6 7F
 cp (iy+-128)           ;; 03D1:  FD BE 80
 cp (iy)                ;; 03D4:  FD BE 00
 cp (iy+127)            ;; 03D7:  FD BE 7F
 add a, ixh             ;; 03DA:  DD 84
 add a, ixl             ;; 03DC:  DD 85
 adc a, ixh             ;; 03DE:  DD 8C
 adc a, ixl             ;; 03E0:  DD 8D
 sub a, ixh             ;; 03E2:  DD 94
 sub a, ixl             ;; 03E4:  DD 95
 sbc a, ixh             ;; 03E6:  DD 9C
 sbc a, ixl             ;; 03E8:  DD 9D
 and a, ixh             ;; 03EA:  DD A4
 and a, ixl             ;; 03EC:  DD A5
 xor a, ixh             ;; 03EE:  DD AC
 xor a, ixl             ;; 03F0:  DD AD
 or a, ixh              ;; 03F2:  DD B4
 or a, ixl              ;; 03F4:  DD B5
 cp a, ixh              ;; 03F6:  DD BC
 cp a, ixl              ;; 03F8:  DD BD
 add ixh                ;; 03FA:  DD 84
 add ixl                ;; 03FC:  DD 85
 adc ixh                ;; 03FE:  DD 8C
 adc ixl                ;; 0400:  DD 8D
 sub ixh                ;; 0402:  DD 94
 sub ixl                ;; 0404:  DD 95
 sbc ixh                ;; 0406:  DD 9C
 sbc ixl                ;; 0408:  DD 9D
 and ixh                ;; 040A:  DD A4
 and ixl                ;; 040C:  DD A5
 xor ixh                ;; 040E:  DD AC
 xor ixl                ;; 0410:  DD AD
 or ixh                 ;; 0412:  DD B4
 or ixl                 ;; 0414:  DD B5
 cp ixh                 ;; 0416:  DD BC
 cp ixl                 ;; 0418:  DD BD
 add a, iyh             ;; 041A:  FD 84
 add a, iyl             ;; 041C:  FD 85
 adc a, iyh             ;; 041E:  FD 8C
 adc a, iyl             ;; 0420:  FD 8D
 sub a, iyh             ;; 0422:  FD 94
 sub a, iyl             ;; 0424:  FD 95
 sbc a, iyh             ;; 0426:  FD 9C
 sbc a, iyl             ;; 0428:  FD 9D
 and a, iyh             ;; 042A:  FD A4
 and a, iyl             ;; 042C:  FD A5
 xor a, iyh             ;; 042E:  FD AC
 xor a, iyl             ;; 0430:  FD AD
 or a, iyh              ;; 0432:  FD B4
 or a, iyl              ;; 0434:  FD B5
 cp a, iyh              ;; 0436:  FD BC
 cp a, iyl              ;; 0438:  FD BD
 add iyh                ;; 043A:  FD 84
 add iyl                ;; 043C:  FD 85
 adc iyh                ;; 043E:  FD 8C
 adc iyl                ;; 0440:  FD 8D
 sub iyh                ;; 0442:  FD 94
 sub iyl                ;; 0444:  FD 95
 sbc iyh                ;; 0446:  FD 9C
 sbc iyl                ;; 0448:  FD 9D
 and iyh                ;; 044A:  FD A4
 and iyl                ;; 044C:  FD A5
 xor iyh                ;; 044E:  FD AC
 xor iyl                ;; 0450:  FD AD
 or iyh                 ;; 0452:  FD B4
 or iyl                 ;; 0454:  FD B5
 cp iyh                 ;; 0456:  FD BC
 cp iyl                 ;; 0458:  FD BD
 add a, 0               ;; 045A:  C6 00
 add a, 85              ;; 045C:  C6 55
 add a, 170             ;; 045E:  C6 AA
 add a, 255             ;; 0460:  C6 FF
 adc a, 0               ;; 0462:  CE 00
 adc a, 85              ;; 0464:  CE 55
 adc a, 170             ;; 0466:  CE AA
 adc a, 255             ;; 0468:  CE FF
 sub a, 0               ;; 046A:  D6 00
 sub a, 85              ;; 046C:  D6 55
 sub a, 170             ;; 046E:  D6 AA
 sub a, 255             ;; 0470:  D6 FF
 sbc a, 0               ;; 0472:  DE 00
 sbc a, 85              ;; 0474:  DE 55
 sbc a, 170             ;; 0476:  DE AA
 sbc a, 255             ;; 0478:  DE FF
 and a, 0               ;; 047A:  E6 00
 and a, 85              ;; 047C:  E6 55
 and a, 170             ;; 047E:  E6 AA
 and a, 255             ;; 0480:  E6 FF
 xor a, 0               ;; 0482:  EE 00
 xor a, 85              ;; 0484:  EE 55
 xor a, 170             ;; 0486:  EE AA
 xor a, 255             ;; 0488:  EE FF
 or a, 0                ;; 048A:  F6 00
 or a, 85               ;; 048C:  F6 55
 or a, 170              ;; 048E:  F6 AA
 or a, 255              ;; 0490:  F6 FF
 cp a, 0                ;; 0492:  FE 00
 cp a, 85               ;; 0494:  FE 55
 cp a, 170              ;; 0496:  FE AA
 cp a, 255              ;; 0498:  FE FF
 add 0                  ;; 049A:  C6 00
 add 85                 ;; 049C:  C6 55
 add 170                ;; 049E:  C6 AA
 add 255                ;; 04A0:  C6 FF
 adc 0                  ;; 04A2:  CE 00
 adc 85                 ;; 04A4:  CE 55
 adc 170                ;; 04A6:  CE AA
 adc 255                ;; 04A8:  CE FF
 sub 0                  ;; 04AA:  D6 00
 sub 85                 ;; 04AC:  D6 55
 sub 170                ;; 04AE:  D6 AA
 sub 255                ;; 04B0:  D6 FF
 sbc 0                  ;; 04B2:  DE 00
 sbc 85                 ;; 04B4:  DE 55
 sbc 170                ;; 04B6:  DE AA
 sbc 255                ;; 04B8:  DE FF
 and 0                  ;; 04BA:  E6 00
 and 85                 ;; 04BC:  E6 55
 and 170                ;; 04BE:  E6 AA
 and 255                ;; 04C0:  E6 FF
 xor 0                  ;; 04C2:  EE 00
 xor 85                 ;; 04C4:  EE 55
 xor 170                ;; 04C6:  EE AA
 xor 255                ;; 04C8:  EE FF
 or 0                   ;; 04CA:  F6 00
 or 85                  ;; 04CC:  F6 55
 or 170                 ;; 04CE:  F6 AA
 or 255                 ;; 04D0:  F6 FF
 cp 0                   ;; 04D2:  FE 00
 cp 85                  ;; 04D4:  FE 55
 cp 170                 ;; 04D6:  FE AA
 cp 255                 ;; 04D8:  FE FF
 inc b                  ;; 04DA:  04
 inc c                  ;; 04DB:  0C
 inc d                  ;; 04DC:  14
 inc e                  ;; 04DD:  1C
 inc h                  ;; 04DE:  24
 inc l                  ;; 04DF:  2C
 inc a                  ;; 04E0:  3C
 dec b                  ;; 04E1:  05
 dec c                  ;; 04E2:  0D
 dec d                  ;; 04E3:  15
 dec e                  ;; 04E4:  1D
 dec h                  ;; 04E5:  25
 dec l                  ;; 04E6:  2D
 dec a                  ;; 04E7:  3D
 inc ixh                ;; 04E8:  DD 24
 inc ixl                ;; 04EA:  DD 2C
 dec ixh                ;; 04EC:  DD 25
 dec ixl                ;; 04EE:  DD 2D
 inc iyh                ;; 04F0:  FD 24
 inc iyl                ;; 04F2:  FD 2C
 dec iyh                ;; 04F4:  FD 25
 dec iyl                ;; 04F6:  FD 2D
 inc (hl)               ;; 04F8:  34
 dec (hl)               ;; 04F9:  35
 inc (ix + -128)        ;; 04FA:  DD 34 80
 inc (ix)               ;; 04FD:  DD 34 00
 inc (ix + 127)         ;; 0500:  DD 34 7F
 dec (ix + -128)        ;; 0503:  DD 35 80
 dec (ix)               ;; 0506:  DD 35 00
 dec (ix + 127)         ;; 0509:  DD 35 7F
 inc (iy + -128)        ;; 050C:  FD 34 80
 inc (iy)               ;; 050F:  FD 34 00
 inc (iy + 127)         ;; 0512:  FD 34 7F
 dec (iy + -128)        ;; 0515:  FD 35 80
 dec (iy)               ;; 0518:  FD 35 00
 dec (iy + 127)         ;; 051B:  FD 35 7F
 cpl                    ;; 051E:  2F
 cpl a                  ;; 051F:  2F
 neg                    ;; 0520:  ED 44
 neg a                  ;; 0522:  ED 44
 ccf                    ;; 0524:  3F
 scf                    ;; 0525:  37
 ld bc, 0               ;; 0526:  01 00 00
 ld bc, 291             ;; 0529:  01 23 01
 ld bc, 17767           ;; 052C:  01 67 45
 ld bc, 35243           ;; 052F:  01 AB 89
 ld bc, 52719           ;; 0532:  01 EF CD
 ld bc, 65535           ;; 0535:  01 FF FF
 ld de, 0               ;; 0538:  11 00 00
 ld de, 291             ;; 053B:  11 23 01
 ld de, 17767           ;; 053E:  11 67 45
 ld de, 35243           ;; 0541:  11 AB 89
 ld de, 52719           ;; 0544:  11 EF CD
 ld de, 65535           ;; 0547:  11 FF FF
 ld hl, 0               ;; 054A:  21 00 00
 ld hl, 291             ;; 054D:  21 23 01
 ld hl, 17767           ;; 0550:  21 67 45
 ld hl, 35243           ;; 0553:  21 AB 89
 ld hl, 52719           ;; 0556:  21 EF CD
 ld hl, 65535           ;; 0559:  21 FF FF
 ld sp, 0               ;; 055C:  31 00 00
 ld sp, 291             ;; 055F:  31 23 01
 ld sp, 17767           ;; 0562:  31 67 45
 ld sp, 35243           ;; 0565:  31 AB 89
 ld sp, 52719           ;; 0568:  31 EF CD
 ld sp, 65535           ;; 056B:  31 FF FF
 ld ix, 0               ;; 056E:  DD 21 00 00
 ld ix, 291             ;; 0572:  DD 21 23 01
 ld ix, 17767           ;; 0576:  DD 21 67 45
 ld ix, 35243           ;; 057A:  DD 21 AB 89
 ld ix, 52719           ;; 057E:  DD 21 EF CD
 ld ix, 65535           ;; 0582:  DD 21 FF FF
 ld iy, 0               ;; 0586:  FD 21 00 00
 ld iy, 291             ;; 058A:  FD 21 23 01
 ld iy, 17767           ;; 058E:  FD 21 67 45
 ld iy, 35243           ;; 0592:  FD 21 AB 89
 ld iy, 52719           ;; 0596:  FD 21 EF CD
 ld iy, 65535           ;; 059A:  FD 21 FF FF
 ld hl, (0)             ;; 059E:  2A 00 00
 ld hl, (291)           ;; 05A1:  2A 23 01
 ld hl, (17767)         ;; 05A4:  2A 67 45
 ld hl, (35243)         ;; 05A7:  2A AB 89
 ld hl, (52719)         ;; 05AA:  2A EF CD
 ld hl, (65535)         ;; 05AD:  2A FF FF
 ld ix, (0)             ;; 05B0:  DD 2A 00 00
 ld ix, (291)           ;; 05B4:  DD 2A 23 01
 ld ix, (17767)         ;; 05B8:  DD 2A 67 45
 ld ix, (35243)         ;; 05BC:  DD 2A AB 89
 ld ix, (52719)         ;; 05C0:  DD 2A EF CD
 ld ix, (65535)         ;; 05C4:  DD 2A FF FF
 ld iy, (0)             ;; 05C8:  FD 2A 00 00
 ld iy, (291)           ;; 05CC:  FD 2A 23 01
 ld iy, (17767)         ;; 05D0:  FD 2A 67 45
 ld iy, (35243)         ;; 05D4:  FD 2A AB 89
 ld iy, (52719)         ;; 05D8:  FD 2A EF CD
 ld iy, (65535)         ;; 05DC:  FD 2A FF FF
 ld (0), hl             ;; 05E0:  22 00 00
 ld (291), hl           ;; 05E3:  22 23 01
 ld (17767), hl         ;; 05E6:  22 67 45
 ld (35243), hl         ;; 05E9:  22 AB 89
 ld (52719), hl         ;; 05EC:  22 EF CD
 ld (65535), hl         ;; 05EF:  22 FF FF
 ld (0), ix             ;; 05F2:  DD 22 00 00
 ld (291), ix           ;; 05F6:  DD 22 23 01
 ld (17767), ix         ;; 05FA:  DD 22 67 45
 ld (35243), ix         ;; 05FE:  DD 22 AB 89
 ld (52719), ix         ;; 0602:  DD 22 EF CD
 ld (65535), ix         ;; 0606:  DD 22 FF FF
 ld (0), iy             ;; 060A:  FD 22 00 00
 ld (291), iy           ;; 060E:  FD 22 23 01
 ld (17767), iy         ;; 0612:  FD 22 67 45
 ld (35243), iy         ;; 0616:  FD 22 AB 89
 ld (52719), iy         ;; 061A:  FD 22 EF CD
 ld (65535), iy         ;; 061E:  FD 22 FF FF
 ld bc, (0)             ;; 0622:  ED 4B 00 00
 ld bc, (291)           ;; 0626:  ED 4B 23 01
 ld bc, (17767)         ;; 062A:  ED 4B 67 45
 ld bc, (35243)         ;; 062E:  ED 4B AB 89
 ld bc, (52719)         ;; 0632:  ED 4B EF CD
 ld bc, (65535)         ;; 0636:  ED 4B FF FF
 ld de, (0)             ;; 063A:  ED 5B 00 00
 ld de, (291)           ;; 063E:  ED 5B 23 01
 ld de, (17767)         ;; 0642:  ED 5B 67 45
 ld de, (35243)         ;; 0646:  ED 5B AB 89
 ld de, (52719)         ;; 064A:  ED 5B EF CD
 ld de, (65535)         ;; 064E:  ED 5B FF FF
 ld sp, (0)             ;; 0652:  ED 7B 00 00
 ld sp, (291)           ;; 0656:  ED 7B 23 01
 ld sp, (17767)         ;; 065A:  ED 7B 67 45
 ld sp, (35243)         ;; 065E:  ED 7B AB 89
 ld sp, (52719)         ;; 0662:  ED 7B EF CD
 ld sp, (65535)         ;; 0666:  ED 7B FF FF
 ld (0), bc             ;; 066A:  ED 43 00 00
 ld (291), bc           ;; 066E:  ED 43 23 01
 ld (17767), bc         ;; 0672:  ED 43 67 45
 ld (35243), bc         ;; 0676:  ED 43 AB 89
 ld (52719), bc         ;; 067A:  ED 43 EF CD
 ld (65535), bc         ;; 067E:  ED 43 FF FF
 ld (0), de             ;; 0682:  ED 53 00 00
 ld (291), de           ;; 0686:  ED 53 23 01
 ld (17767), de         ;; 068A:  ED 53 67 45
 ld (35243), de         ;; 068E:  ED 53 AB 89
 ld (52719), de         ;; 0692:  ED 53 EF CD
 ld (65535), de         ;; 0696:  ED 53 FF FF
 ld (0), sp             ;; 069A:  ED 73 00 00
 ld (291), sp           ;; 069E:  ED 73 23 01
 ld (17767), sp         ;; 06A2:  ED 73 67 45
 ld (35243), sp         ;; 06A6:  ED 73 AB 89
 ld (52719), sp         ;; 06AA:  ED 73 EF CD
 ld (65535), sp         ;; 06AE:  ED 73 FF FF
 ld sp, hl              ;; 06B2:  F9
 ld sp, ix              ;; 06B3:  DD F9
 ld sp, iy              ;; 06B5:  FD F9
 push bc                ;; 06B7:  C5
 push de                ;; 06B8:  D5
 push hl                ;; 06B9:  E5
 push af                ;; 06BA:  F5
 push ix                ;; 06BB:  DD E5
 push iy                ;; 06BD:  FD E5
 pop bc                 ;; 06BF:  C1
 pop de                 ;; 06C0:  D1
 pop hl                 ;; 06C1:  E1
 pop af                 ;; 06C2:  F1
 pop ix                 ;; 06C3:  DD E1
 pop iy                 ;; 06C5:  FD E1
 add hl, bc             ;; 06C7:  09
 add hl, de             ;; 06C8:  19
 add hl, hl             ;; 06C9:  29
 add hl, sp             ;; 06CA:  39
 add ix, bc             ;; 06CB:  DD 09
 add ix, de             ;; 06CD:  DD 19
 add ix, ix             ;; 06CF:  DD 29
 add ix, sp             ;; 06D1:  DD 39
 add iy, bc             ;; 06D3:  FD 09
 add iy, de             ;; 06D5:  FD 19
 add iy, iy             ;; 06D7:  FD 29
 add iy, sp             ;; 06D9:  FD 39
 sbc hl, bc             ;; 06DB:  ED 42
 sbc hl, de             ;; 06DD:  ED 52
 sbc hl, hl             ;; 06DF:  ED 62
 sbc hl, sp             ;; 06E1:  ED 72
 adc hl, bc             ;; 06E3:  ED 4A
 adc hl, de             ;; 06E5:  ED 5A
 adc hl, hl             ;; 06E7:  ED 6A
 adc hl, sp             ;; 06E9:  ED 7A
 inc bc                 ;; 06EB:  03
 inc de                 ;; 06EC:  13
 inc hl                 ;; 06ED:  23
 inc sp                 ;; 06EE:  33
 dec bc                 ;; 06EF:  0B
 dec de                 ;; 06F0:  1B
 dec hl                 ;; 06F1:  2B
 dec sp                 ;; 06F2:  3B
 inc ix                 ;; 06F3:  DD 23
 dec ix                 ;; 06F5:  DD 2B
 inc iy                 ;; 06F7:  FD 23
 dec iy                 ;; 06F9:  FD 2B
 ex af, af              ;; 06FB:  08
 ex af, af'             ;; 06FC:  08
 exx                    ;; 06FD:  D9
 ex (sp), hl            ;; 06FE:  E3
 ex (sp), ix            ;; 06FF:  DD E3
 ex (sp), iy            ;; 0701:  FD E3
 ex de, hl              ;; 0703:  EB
 rlca                   ;; 0704:  07
 rrca                   ;; 0705:  0F
 rla                    ;; 0706:  17
 rra                    ;; 0707:  1F
 rlc b                  ;; 0708:  CB 00
 rlc c                  ;; 070A:  CB 01
 rlc d                  ;; 070C:  CB 02
 rlc e                  ;; 070E:  CB 03
 rlc h                  ;; 0710:  CB 04
 rlc l                  ;; 0712:  CB 05
 rlc (hl)               ;; 0714:  CB 06
 rlc a                  ;; 0716:  CB 07
 rrc b                  ;; 0718:  CB 08
 rrc c                  ;; 071A:  CB 09
 rrc d                  ;; 071C:  CB 0A
 rrc e                  ;; 071E:  CB 0B
 rrc h                  ;; 0720:  CB 0C
 rrc l                  ;; 0722:  CB 0D
 rrc (hl)               ;; 0724:  CB 0E
 rrc a                  ;; 0726:  CB 0F
 rl b                   ;; 0728:  CB 10
 rl c                   ;; 072A:  CB 11
 rl d                   ;; 072C:  CB 12
 rl e                   ;; 072E:  CB 13
 rl h                   ;; 0730:  CB 14
 rl l                   ;; 0732:  CB 15
 rl (hl)                ;; 0734:  CB 16
 rl a                   ;; 0736:  CB 17
 rr b                   ;; 0738:  CB 18
 rr c                   ;; 073A:  CB 19
 rr d                   ;; 073C:  CB 1A
 rr e                   ;; 073E:  CB 1B
 rr h                   ;; 0740:  CB 1C
 rr l                   ;; 0742:  CB 1D
 rr (hl)                ;; 0744:  CB 1E
 rr a                   ;; 0746:  CB 1F
 sla b                  ;; 0748:  CB 20
 sla c                  ;; 074A:  CB 21
 sla d                  ;; 074C:  CB 22
 sla e                  ;; 074E:  CB 23
 sla h                  ;; 0750:  CB 24
 sla l                  ;; 0752:  CB 25
 sla (hl)               ;; 0754:  CB 26
 sla a                  ;; 0756:  CB 27
 sra b                  ;; 0758:  CB 28
 sra c                  ;; 075A:  CB 29
 sra d                  ;; 075C:  CB 2A
 sra e                  ;; 075E:  CB 2B
 sra h                  ;; 0760:  CB 2C
 sra l                  ;; 0762:  CB 2D
 sra (hl)               ;; 0764:  CB 2E
 sra a                  ;; 0766:  CB 2F
 srl b                  ;; 0768:  CB 38
 srl c                  ;; 076A:  CB 39
 srl d                  ;; 076C:  CB 3A
 srl e                  ;; 076E:  CB 3B
 srl h                  ;; 0770:  CB 3C
 srl l                  ;; 0772:  CB 3D
 srl (hl)               ;; 0774:  CB 3E
 srl a                  ;; 0776:  CB 3F
 sll b                  ;; 0778:  CB 30
 sll c                  ;; 077A:  CB 31
 sll d                  ;; 077C:  CB 32
 sll e                  ;; 077E:  CB 33
 sll h                  ;; 0780:  CB 34
 sll l                  ;; 0782:  CB 35
 sll (hl)               ;; 0784:  CB 36
 sll a                  ;; 0786:  CB 37
 rlc (ix+-128)          ;; 0788:  DD CB 80 06
 rlc (ix)               ;; 078C:  DD CB 00 06
 rlc (ix+127)           ;; 0790:  DD CB 7F 06
 rrc (ix+-128)          ;; 0794:  DD CB 80 0E
 rrc (ix)               ;; 0798:  DD CB 00 0E
 rrc (ix+127)           ;; 079C:  DD CB 7F 0E
 rl (ix+-128)           ;; 07A0:  DD CB 80 16
 rl (ix)                ;; 07A4:  DD CB 00 16
 rl (ix+127)            ;; 07A8:  DD CB 7F 16
 rr (ix+-128)           ;; 07AC:  DD CB 80 1E
 rr (ix)                ;; 07B0:  DD CB 00 1E
 rr (ix+127)            ;; 07B4:  DD CB 7F 1E
 sla (ix+-128)          ;; 07B8:  DD CB 80 26
 sla (ix)               ;; 07BC:  DD CB 00 26
 sla (ix+127)           ;; 07C0:  DD CB 7F 26
 sra (ix+-128)          ;; 07C4:  DD CB 80 2E
 sra (ix)               ;; 07C8:  DD CB 00 2E
 sra (ix+127)           ;; 07CC:  DD CB 7F 2E
 srl (ix+-128)          ;; 07D0:  DD CB 80 3E
 srl (ix)               ;; 07D4:  DD CB 00 3E
 srl (ix+127)           ;; 07D8:  DD CB 7F 3E
 sll (ix+-128)          ;; 07DC:  DD CB 80 36
 sll (ix)               ;; 07E0:  DD CB 00 36
 sll (ix+127)           ;; 07E4:  DD CB 7F 36
 rlc (iy+-128)          ;; 07E8:  FD CB 80 06
 rlc (iy)               ;; 07EC:  FD CB 00 06
 rlc (iy+127)           ;; 07F0:  FD CB 7F 06
 rrc (iy+-128)          ;; 07F4:  FD CB 80 0E
 rrc (iy)               ;; 07F8:  FD CB 00 0E
 rrc (iy+127)           ;; 07FC:  FD CB 7F 0E
 rl (iy+-128)           ;; 0800:  FD CB 80 16
 rl (iy)                ;; 0804:  FD CB 00 16
 rl (iy+127)            ;; 0808:  FD CB 7F 16
 rr (iy+-128)           ;; 080C:  FD CB 80 1E
 rr (iy)                ;; 0810:  FD CB 00 1E
 rr (iy+127)            ;; 0814:  FD CB 7F 1E
 sla (iy+-128)          ;; 0818:  FD CB 80 26
 sla (iy)               ;; 081C:  FD CB 00 26
 sla (iy+127)           ;; 0820:  FD CB 7F 26
 sra (iy+-128)          ;; 0824:  FD CB 80 2E
 sra (iy)               ;; 0828:  FD CB 00 2E
 sra (iy+127)           ;; 082C:  FD CB 7F 2E
 srl (iy+-128)          ;; 0830:  FD CB 80 3E
 srl (iy)               ;; 0834:  FD CB 00 3E
 srl (iy+127)           ;; 0838:  FD CB 7F 3E
 sll (iy+-128)          ;; 083C:  FD CB 80 36
 sll (iy)               ;; 0840:  FD CB 00 36
 sll (iy+127)           ;; 0844:  FD CB 7F 36
 bit 0, b               ;; 0848:  CB 40
 bit 0, c               ;; 084A:  CB 41
 bit 0, d               ;; 084C:  CB 42
 bit 0, e               ;; 084E:  CB 43
 bit 0, h               ;; 0850:  CB 44
 bit 0, l               ;; 0852:  CB 45
 bit 0, (hl)            ;; 0854:  CB 46
 bit 0, a               ;; 0856:  CB 47
 bit 1, b               ;; 0858:  CB 48
 bit 1, c               ;; 085A:  CB 49
 bit 1, d               ;; 085C:  CB 4A
 bit 1, e               ;; 085E:  CB 4B
 bit 1, h               ;; 0860:  CB 4C
 bit 1, l               ;; 0862:  CB 4D
 bit 1, (hl)            ;; 0864:  CB 4E
 bit 1, a               ;; 0866:  CB 4F
 bit 2, b               ;; 0868:  CB 50
 bit 2, c               ;; 086A:  CB 51
 bit 2, d               ;; 086C:  CB 52
 bit 2, e               ;; 086E:  CB 53
 bit 2, h               ;; 0870:  CB 54
 bit 2, l               ;; 0872:  CB 55
 bit 2, (hl)            ;; 0874:  CB 56
 bit 2, a               ;; 0876:  CB 57
 bit 3, b               ;; 0878:  CB 58
 bit 3, c               ;; 087A:  CB 59
 bit 3, d               ;; 087C:  CB 5A
 bit 3, e               ;; 087E:  CB 5B
 bit 3, h               ;; 0880:  CB 5C
 bit 3, l               ;; 0882:  CB 5D
 bit 3, (hl)            ;; 0884:  CB 5E
 bit 3, a               ;; 0886:  CB 5F
 bit 4, b               ;; 0888:  CB 60
 bit 4, c               ;; 088A:  CB 61
 bit 4, d               ;; 088C:  CB 62
 bit 4, e               ;; 088E:  CB 63
 bit 4, h               ;; 0890:  CB 64
 bit 4, l               ;; 0892:  CB 65
 bit 4, (hl)            ;; 0894:  CB 66
 bit 4, a               ;; 0896:  CB 67
 bit 5, b               ;; 0898:  CB 68
 bit 5, c               ;; 089A:  CB 69
 bit 5, d               ;; 089C:  CB 6A
 bit 5, e               ;; 089E:  CB 6B
 bit 5, h               ;; 08A0:  CB 6C
 bit 5, l               ;; 08A2:  CB 6D
 bit 5, (hl)            ;; 08A4:  CB 6E
 bit 5, a               ;; 08A6:  CB 6F
 bit 6, b               ;; 08A8:  CB 70
 bit 6, c               ;; 08AA:  CB 71
 bit 6, d               ;; 08AC:  CB 72
 bit 6, e               ;; 08AE:  CB 73
 bit 6, h               ;; 08B0:  CB 74
 bit 6, l               ;; 08B2:  CB 75
 bit 6, (hl)            ;; 08B4:  CB 76
 bit 6, a               ;; 08B6:  CB 77
 bit 7, b               ;; 08B8:  CB 78
 bit 7, c               ;; 08BA:  CB 79
 bit 7, d               ;; 08BC:  CB 7A
 bit 7, e               ;; 08BE:  CB 7B
 bit 7, h               ;; 08C0:  CB 7C
 bit 7, l               ;; 08C2:  CB 7D
 bit 7, (hl)            ;; 08C4:  CB 7E
 bit 7, a               ;; 08C6:  CB 7F
 res 0, b               ;; 08C8:  CB 80
 res 0, c               ;; 08CA:  CB 81
 res 0, d               ;; 08CC:  CB 82
 res 0, e               ;; 08CE:  CB 83
 res 0, h               ;; 08D0:  CB 84
 res 0, l               ;; 08D2:  CB 85
 res 0, (hl)            ;; 08D4:  CB 86
 res 0, a               ;; 08D6:  CB 87
 res 1, b               ;; 08D8:  CB 88
 res 1, c               ;; 08DA:  CB 89
 res 1, d               ;; 08DC:  CB 8A
 res 1, e               ;; 08DE:  CB 8B
 res 1, h               ;; 08E0:  CB 8C
 res 1, l               ;; 08E2:  CB 8D
 res 1, (hl)            ;; 08E4:  CB 8E
 res 1, a               ;; 08E6:  CB 8F
 res 2, b               ;; 08E8:  CB 90
 res 2, c               ;; 08EA:  CB 91
 res 2, d               ;; 08EC:  CB 92
 res 2, e               ;; 08EE:  CB 93
 res 2, h               ;; 08F0:  CB 94
 res 2, l               ;; 08F2:  CB 95
 res 2, (hl)            ;; 08F4:  CB 96
 res 2, a               ;; 08F6:  CB 97
 res 3, b               ;; 08F8:  CB 98
 res 3, c               ;; 08FA:  CB 99
 res 3, d               ;; 08FC:  CB 9A
 res 3, e               ;; 08FE:  CB 9B
 res 3, h               ;; 0900:  CB 9C
 res 3, l               ;; 0902:  CB 9D
 res 3, (hl)            ;; 0904:  CB 9E
 res 3, a               ;; 0906:  CB 9F
 res 4, b               ;; 0908:  CB A0
 res 4, c               ;; 090A:  CB A1
 res 4, d               ;; 090C:  CB A2
 res 4, e               ;; 090E:  CB A3
 res 4, h               ;; 0910:  CB A4
 res 4, l               ;; 0912:  CB A5
 res 4, (hl)            ;; 0914:  CB A6
 res 4, a               ;; 0916:  CB A7
 res 5, b               ;; 0918:  CB A8
 res 5, c               ;; 091A:  CB A9
 res 5, d               ;; 091C:  CB AA
 res 5, e               ;; 091E:  CB AB
 res 5, h               ;; 0920:  CB AC
 res 5, l               ;; 0922:  CB AD
 res 5, (hl)            ;; 0924:  CB AE
 res 5, a               ;; 0926:  CB AF
 res 6, b               ;; 0928:  CB B0
 res 6, c               ;; 092A:  CB B1
 res 6, d               ;; 092C:  CB B2
 res 6, e               ;; 092E:  CB B3
 res 6, h               ;; 0930:  CB B4
 res 6, l               ;; 0932:  CB B5
 res 6, (hl)            ;; 0934:  CB B6
 res 6, a               ;; 0936:  CB B7
 res 7, b               ;; 0938:  CB B8
 res 7, c               ;; 093A:  CB B9
 res 7, d               ;; 093C:  CB BA
 res 7, e               ;; 093E:  CB BB
 res 7, h               ;; 0940:  CB BC
 res 7, l               ;; 0942:  CB BD
 res 7, (hl)            ;; 0944:  CB BE
 res 7, a               ;; 0946:  CB BF
 set 0, b               ;; 0948:  CB C0
 set 0, c               ;; 094A:  CB C1
 set 0, d               ;; 094C:  CB C2
 set 0, e               ;; 094E:  CB C3
 set 0, h               ;; 0950:  CB C4
 set 0, l               ;; 0952:  CB C5
 set 0, (hl)            ;; 0954:  CB C6
 set 0, a               ;; 0956:  CB C7
 set 1, b               ;; 0958:  CB C8
 set 1, c               ;; 095A:  CB C9
 set 1, d               ;; 095C:  CB CA
 set 1, e               ;; 095E:  CB CB
 set 1, h               ;; 0960:  CB CC
 set 1, l               ;; 0962:  CB CD
 set 1, (hl)            ;; 0964:  CB CE
 set 1, a               ;; 0966:  CB CF
 set 2, b               ;; 0968:  CB D0
 set 2, c               ;; 096A:  CB D1
 set 2, d               ;; 096C:  CB D2
 set 2, e               ;; 096E:  CB D3
 set 2, h               ;; 0970:  CB D4
 set 2, l               ;; 0972:  CB D5
 set 2, (hl)            ;; 0974:  CB D6
 set 2, a               ;; 0976:  CB D7
 set 3, b               ;; 0978:  CB D8
 set 3, c               ;; 097A:  CB D9
 set 3, d               ;; 097C:  CB DA
 set 3, e               ;; 097E:  CB DB
 set 3, h               ;; 0980:  CB DC
 set 3, l               ;; 0982:  CB DD
 set 3, (hl)            ;; 0984:  CB DE
 set 3, a               ;; 0986:  CB DF
 set 4, b               ;; 0988:  CB E0
 set 4, c               ;; 098A:  CB E1
 set 4, d               ;; 098C:  CB E2
 set 4, e               ;; 098E:  CB E3
 set 4, h               ;; 0990:  CB E4
 set 4, l               ;; 0992:  CB E5
 set 4, (hl)            ;; 0994:  CB E6
 set 4, a               ;; 0996:  CB E7
 set 5, b               ;; 0998:  CB E8
 set 5, c               ;; 099A:  CB E9
 set 5, d               ;; 099C:  CB EA
 set 5, e               ;; 099E:  CB EB
 set 5, h               ;; 09A0:  CB EC
 set 5, l               ;; 09A2:  CB ED
 set 5, (hl)            ;; 09A4:  CB EE
 set 5, a               ;; 09A6:  CB EF
 set 6, b               ;; 09A8:  CB F0
 set 6, c               ;; 09AA:  CB F1
 set 6, d               ;; 09AC:  CB F2
 set 6, e               ;; 09AE:  CB F3
 set 6, h               ;; 09B0:  CB F4
 set 6, l               ;; 09B2:  CB F5
 set 6, (hl)            ;; 09B4:  CB F6
 set 6, a               ;; 09B6:  CB F7
 set 7, b               ;; 09B8:  CB F8
 set 7, c               ;; 09BA:  CB F9
 set 7, d               ;; 09BC:  CB FA
 set 7, e               ;; 09BE:  CB FB
 set 7, h               ;; 09C0:  CB FC
 set 7, l               ;; 09C2:  CB FD
 set 7, (hl)            ;; 09C4:  CB FE
 set 7, a               ;; 09C6:  CB FF
 bit 0, (ix+-128)       ;; 09C8:  DD CB 80 46
 bit 0, (ix)            ;; 09CC:  DD CB 00 46
 bit 0, (ix+127)        ;; 09D0:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 09D4:  DD CB 80 4E
 bit 1, (ix)            ;; 09D8:  DD CB 00 4E
 bit 1, (ix+127)        ;; 09DC:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 09E0:  DD CB 80 56
 bit 2, (ix)            ;; 09E4:  DD CB 00 56
 bit 2, (ix+127)        ;; 09E8:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 09EC:  DD CB 80 5E
 bit 3, (ix)            ;; 09F0:  DD CB 00 5E
 bit 3, (ix+127)        ;; 09F4:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 09F8:  DD CB 80 66
 bit 4, (ix)            ;; 09FC:  DD CB 00 66
 bit 4, (ix+127)        ;; 0A00:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 0A04:  DD CB 80 6E
 bit 5, (ix)            ;; 0A08:  DD CB 00 6E
 bit 5, (ix+127)        ;; 0A0C:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 0A10:  DD CB 80 76
 bit 6, (ix)            ;; 0A14:  DD CB 00 76
 bit 6, (ix+127)        ;; 0A18:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 0A1C:  DD CB 80 7E
 bit 7, (ix)            ;; 0A20:  DD CB 00 7E
 bit 7, (ix+127)        ;; 0A24:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 0A28:  DD CB 80 86
 res 0, (ix)            ;; 0A2C:  DD CB 00 86
 res 0, (ix+127)        ;; 0A30:  DD CB 7F 86
 res 1, (ix+-128)       ;; 0A34:  DD CB 80 8E
 res 1, (ix)            ;; 0A38:  DD CB 00 8E
 res 1, (ix+127)        ;; 0A3C:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 0A40:  DD CB 80 96
 res 2, (ix)            ;; 0A44:  DD CB 00 96
 res 2, (ix+127)        ;; 0A48:  DD CB 7F 96
 res 3, (ix+-128)       ;; 0A4C:  DD CB 80 9E
 res 3, (ix)            ;; 0A50:  DD CB 00 9E
 res 3, (ix+127)        ;; 0A54:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 0A58:  DD CB 80 A6
 res 4, (ix)            ;; 0A5C:  DD CB 00 A6
 res 4, (ix+127)        ;; 0A60:  DD CB 7F A6
 res 5, (ix+-128)       ;; 0A64:  DD CB 80 AE
 res 5, (ix)            ;; 0A68:  DD CB 00 AE
 res 5, (ix+127)        ;; 0A6C:  DD CB 7F AE
 res 6, (ix+-128)       ;; 0A70:  DD CB 80 B6
 res 6, (ix)            ;; 0A74:  DD CB 00 B6
 res 6, (ix+127)        ;; 0A78:  DD CB 7F B6
 res 7, (ix+-128)       ;; 0A7C:  DD CB 80 BE
 res 7, (ix)            ;; 0A80:  DD CB 00 BE
 res 7, (ix+127)        ;; 0A84:  DD CB 7F BE
 set 0, (ix+-128)       ;; 0A88:  DD CB 80 C6
 set 0, (ix)            ;; 0A8C:  DD CB 00 C6
 set 0, (ix+127)        ;; 0A90:  DD CB 7F C6
 set 1, (ix+-128)       ;; 0A94:  DD CB 80 CE
 set 1, (ix)            ;; 0A98:  DD CB 00 CE
 set 1, (ix+127)        ;; 0A9C:  DD CB 7F CE
 set 2, (ix+-128)       ;; 0AA0:  DD CB 80 D6
 set 2, (ix)            ;; 0AA4:  DD CB 00 D6
 set 2, (ix+127)        ;; 0AA8:  DD CB 7F D6
 set 3, (ix+-128)       ;; 0AAC:  DD CB 80 DE
 set 3, (ix)            ;; 0AB0:  DD CB 00 DE
 set 3, (ix+127)        ;; 0AB4:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0AB8:  DD CB 80 E6
 set 4, (ix)            ;; 0ABC:  DD CB 00 E6
 set 4, (ix+127)        ;; 0AC0:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0AC4:  DD CB 80 EE
 set 5, (ix)            ;; 0AC8:  DD CB 00 EE
 set 5, (ix+127)        ;; 0ACC:  DD CB 7F EE
 set 6, (ix+-128)       ;; 0AD0:  DD CB 80 F6
 set 6, (ix)            ;; 0AD4:  DD CB 00 F6
 set 6, (ix+127)        ;; 0AD8:  DD CB 7F F6
 set 7, (ix+-128)       ;; 0ADC:  DD CB 80 FE
 set 7, (ix)            ;; 0AE0:  DD CB 00 FE
 set 7, (ix+127)        ;; 0AE4:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 0AE8:  FD CB 80 46
 bit 0, (iy)            ;; 0AEC:  FD CB 00 46
 bit 0, (iy+127)        ;; 0AF0:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 0AF4:  FD CB 80 4E
 bit 1, (iy)            ;; 0AF8:  FD CB 00 4E
 bit 1, (iy+127)        ;; 0AFC:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 0B00:  FD CB 80 56
 bit 2, (iy)            ;; 0B04:  FD CB 00 56
 bit 2, (iy+127)        ;; 0B08:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 0B0C:  FD CB 80 5E
 bit 3, (iy)            ;; 0B10:  FD CB 00 5E
 bit 3, (iy+127)        ;; 0B14:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 0B18:  FD CB 80 66
 bit 4, (iy)            ;; 0B1C:  FD CB 00 66
 bit 4, (iy+127)        ;; 0B20:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 0B24:  FD CB 80 6E
 bit 5, (iy)            ;; 0B28:  FD CB 00 6E
 bit 5, (iy+127)        ;; 0B2C:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 0B30:  FD CB 80 76
 bit 6, (iy)            ;; 0B34:  FD CB 00 76
 bit 6, (iy+127)        ;; 0B38:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 0B3C:  FD CB 80 7E
 bit 7, (iy)            ;; 0B40:  FD CB 00 7E
 bit 7, (iy+127)        ;; 0B44:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 0B48:  FD CB 80 86
 res 0, (iy)            ;; 0B4C:  FD CB 00 86
 res 0, (iy+127)        ;; 0B50:  FD CB 7F 86
 res 1, (iy+-128)       ;; 0B54:  FD CB 80 8E
 res 1, (iy)            ;; 0B58:  FD CB 00 8E
 res 1, (iy+127)        ;; 0B5C:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 0B60:  FD CB 80 96
 res 2, (iy)            ;; 0B64:  FD CB 00 96
 res 2, (iy+127)        ;; 0B68:  FD CB 7F 96
 res 3, (iy+-128)       ;; 0B6C:  FD CB 80 9E
 res 3, (iy)            ;; 0B70:  FD CB 00 9E
 res 3, (iy+127)        ;; 0B74:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 0B78:  FD CB 80 A6
 res 4, (iy)            ;; 0B7C:  FD CB 00 A6
 res 4, (iy+127)        ;; 0B80:  FD CB 7F A6
 res 5, (iy+-128)       ;; 0B84:  FD CB 80 AE
 res 5, (iy)            ;; 0B88:  FD CB 00 AE
 res 5, (iy+127)        ;; 0B8C:  FD CB 7F AE
 res 6, (iy+-128)       ;; 0B90:  FD CB 80 B6
 res 6, (iy)            ;; 0B94:  FD CB 00 B6
 res 6, (iy+127)        ;; 0B98:  FD CB 7F B6
 res 7, (iy+-128)       ;; 0B9C:  FD CB 80 BE
 res 7, (iy)            ;; 0BA0:  FD CB 00 BE
 res 7, (iy+127)        ;; 0BA4:  FD CB 7F BE
 set 0, (iy+-128)       ;; 0BA8:  FD CB 80 C6
 set 0, (iy)            ;; 0BAC:  FD CB 00 C6
 set 0, (iy+127)        ;; 0BB0:  FD CB 7F C6
 set 1, (iy+-128)       ;; 0BB4:  FD CB 80 CE
 set 1, (iy)            ;; 0BB8:  FD CB 00 CE
 set 1, (iy+127)        ;; 0BBC:  FD CB 7F CE
 set 2, (iy+-128)       ;; 0BC0:  FD CB 80 D6
 set 2, (iy)            ;; 0BC4:  FD CB 00 D6
 set 2, (iy+127)        ;; 0BC8:  FD CB 7F D6
 set 3, (iy+-128)       ;; 0BCC:  FD CB 80 DE
 set 3, (iy)            ;; 0BD0:  FD CB 00 DE
 set 3, (iy+127)        ;; 0BD4:  FD CB 7F DE
 set 4, (iy+-128)       ;; 0BD8:  FD CB 80 E6
 set 4, (iy)            ;; 0BDC:  FD CB 00 E6
 set 4, (iy+127)        ;; 0BE0:  FD CB 7F E6
 set 5, (iy+-128)       ;; 0BE4:  FD CB 80 EE
 set 5, (iy)            ;; 0BE8:  FD CB 00 EE
 set 5, (iy+127)        ;; 0BEC:  FD CB 7F EE
 set 6, (iy+-128)       ;; 0BF0:  FD CB 80 F6
 set 6, (iy)            ;; 0BF4:  FD CB 00 F6
 set 6, (iy+127)        ;; 0BF8:  FD CB 7F F6
 set 7, (iy+-128)       ;; 0BFC:  FD CB 80 FE
 set 7, (iy)            ;; 0C00:  FD CB 00 FE
 set 7, (iy+127)        ;; 0C04:  FD CB 7F FE
 ldi                    ;; 0C08:  ED A0
 ldir                   ;; 0C0A:  ED B0
 ldd                    ;; 0C0C:  ED A8
 lddr                   ;; 0C0E:  ED B8
 nop                    ;; 0C10:  00
 halt                   ;; 0C11:  76
 jp 0                   ;; 0C12:  C3 00 00
 jp 291                 ;; 0C15:  C3 23 01
 jp 17767               ;; 0C18:  C3 67 45
 jp 35243               ;; 0C1B:  C3 AB 89
 jp 52719               ;; 0C1E:  C3 EF CD
 jp 65535               ;; 0C21:  C3 FF FF
 jp nz, 0               ;; 0C24:  C2 00 00
 jp nz, 291             ;; 0C27:  C2 23 01
 jp nz, 17767           ;; 0C2A:  C2 67 45
 jp nz, 35243           ;; 0C2D:  C2 AB 89
 jp nz, 52719           ;; 0C30:  C2 EF CD
 jp nz, 65535           ;; 0C33:  C2 FF FF
 jp z, 0                ;; 0C36:  CA 00 00
 jp z, 291              ;; 0C39:  CA 23 01
 jp z, 17767            ;; 0C3C:  CA 67 45
 jp z, 35243            ;; 0C3F:  CA AB 89
 jp z, 52719            ;; 0C42:  CA EF CD
 jp z, 65535            ;; 0C45:  CA FF FF
 jp nc, 0               ;; 0C48:  D2 00 00
 jp nc, 291             ;; 0C4B:  D2 23 01
 jp nc, 17767           ;; 0C4E:  D2 67 45
 jp nc, 35243           ;; 0C51:  D2 AB 89
 jp nc, 52719           ;; 0C54:  D2 EF CD
 jp nc, 65535           ;; 0C57:  D2 FF FF
 jp c, 0                ;; 0C5A:  DA 00 00
 jp c, 291              ;; 0C5D:  DA 23 01
 jp c, 17767            ;; 0C60:  DA 67 45
 jp c, 35243            ;; 0C63:  DA AB 89
 jp c, 52719            ;; 0C66:  DA EF CD
 jp c, 65535            ;; 0C69:  DA FF FF
 jp po, 0               ;; 0C6C:  E2 00 00
 jp po, 291             ;; 0C6F:  E2 23 01
 jp po, 17767           ;; 0C72:  E2 67 45
 jp po, 35243           ;; 0C75:  E2 AB 89
 jp po, 52719           ;; 0C78:  E2 EF CD
 jp po, 65535           ;; 0C7B:  E2 FF FF
 jp pe, 0               ;; 0C7E:  EA 00 00
 jp pe, 291             ;; 0C81:  EA 23 01
 jp pe, 17767           ;; 0C84:  EA 67 45
 jp pe, 35243           ;; 0C87:  EA AB 89
 jp pe, 52719           ;; 0C8A:  EA EF CD
 jp pe, 65535           ;; 0C8D:  EA FF FF
 jp p, 0                ;; 0C90:  F2 00 00
 jp p, 291              ;; 0C93:  F2 23 01
 jp p, 17767            ;; 0C96:  F2 67 45
 jp p, 35243            ;; 0C99:  F2 AB 89
 jp p, 52719            ;; 0C9C:  F2 EF CD
 jp p, 65535            ;; 0C9F:  F2 FF FF
 jp m, 0                ;; 0CA2:  FA 00 00
 jp m, 291              ;; 0CA5:  FA 23 01
 jp m, 17767            ;; 0CA8:  FA 67 45
 jp m, 35243            ;; 0CAB:  FA AB 89
 jp m, 52719            ;; 0CAE:  FA EF CD
 jp m, 65535            ;; 0CB1:  FA FF FF
 jp (hl)                ;; 0CB4:  E9
 jp (ix)                ;; 0CB5:  DD E9
 jp (iy)                ;; 0CB7:  FD E9
 djnz ASMPC             ;; 0CB9:  10 FE
 djnz b, ASMPC          ;; 0CBB:  10 FE
 jr ASMPC               ;; 0CBD:  18 FE
 jr nz, ASMPC           ;; 0CBF:  20 FE
 jr z, ASMPC            ;; 0CC1:  28 FE
 jr nc, ASMPC           ;; 0CC3:  30 FE
 jr c, ASMPC            ;; 0CC5:  38 FE
 call 0                 ;; 0CC7:  CD 00 00
 call 291               ;; 0CCA:  CD 23 01
 call 17767             ;; 0CCD:  CD 67 45
 call 35243             ;; 0CD0:  CD AB 89
 call 52719             ;; 0CD3:  CD EF CD
 call 65535             ;; 0CD6:  CD FF FF
 ret                    ;; 0CD9:  C9
 ret nz                 ;; 0CDA:  C0
 ret z                  ;; 0CDB:  C8
 ret nc                 ;; 0CDC:  D0
 ret c                  ;; 0CDD:  D8
 ret po                 ;; 0CDE:  E0
 ret pe                 ;; 0CDF:  E8
 ret p                  ;; 0CE0:  F0
 ret m                  ;; 0CE1:  F8
 rst 16                 ;; 0CE2:  D7
 rst 24                 ;; 0CE3:  DF
 rst 32                 ;; 0CE4:  E7
 rst 40                 ;; 0CE5:  EF
 rst 56                 ;; 0CE6:  FF
 in a, (0)              ;; 0CE7:  DB 00
 in a, (85)             ;; 0CE9:  DB 55
 in a, (170)            ;; 0CEB:  DB AA
 in a, (255)            ;; 0CED:  DB FF
 in b, (c)              ;; 0CEF:  ED 40
 in c, (c)              ;; 0CF1:  ED 48
 in d, (c)              ;; 0CF3:  ED 50
 in e, (c)              ;; 0CF5:  ED 58
 in h, (c)              ;; 0CF7:  ED 60
 in l, (c)              ;; 0CF9:  ED 68
 in f, (c)              ;; 0CFB:  ED 70
 in a, (c)              ;; 0CFD:  ED 78
 out (0), a             ;; 0CFF:  D3 00
 out (85), a            ;; 0D01:  D3 55
 out (170), a           ;; 0D03:  D3 AA
 out (255), a           ;; 0D05:  D3 FF
 out (c), b             ;; 0D07:  ED 41
 out (c), c             ;; 0D09:  ED 49
 out (c), d             ;; 0D0B:  ED 51
 out (c), e             ;; 0D0D:  ED 59
 out (c), h             ;; 0D0F:  ED 61
 out (c), l             ;; 0D11:  ED 69
 out (c), 0             ;; 0D13:  ED 71
 out (c), a             ;; 0D15:  ED 79
 ini                    ;; 0D17:  ED A2
 inir                   ;; 0D19:  ED B2
 ind                    ;; 0D1B:  ED AA
 indr                   ;; 0D1D:  ED BA
 outi                   ;; 0D1F:  ED A3
 otir                   ;; 0D21:  ED B3
 outd                   ;; 0D23:  ED AB
 otdr                   ;; 0D25:  ED BB
 di                     ;; 0D27:  F3
 ei                     ;; 0D28:  FB
 im 0                   ;; 0D29:  ED 46
 im 1                   ;; 0D2B:  ED 56
 im 2                   ;; 0D2D:  ED 5E
 ld i, a                ;; 0D2F:  ED 47
 ld a, i                ;; 0D31:  ED 57
 ld r, a                ;; 0D33:  ED 4F
 ld a, r                ;; 0D35:  ED 5F
 reti                   ;; 0D37:  ED 4D
 retn                   ;; 0D39:  ED 45
