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
 daa                    ;; 051E:  27
 rld                    ;; 051F:  ED 6F
 rrd                    ;; 0521:  ED 67
 cpl                    ;; 0523:  2F
 cpl a                  ;; 0524:  2F
 neg                    ;; 0525:  ED 44
 neg a                  ;; 0527:  ED 44
 ccf                    ;; 0529:  3F
 ccf f                  ;; 052A:  3F
 scf                    ;; 052B:  37
 scf f                  ;; 052C:  37
 ld bc, 0               ;; 052D:  01 00 00
 ld bc, 291             ;; 0530:  01 23 01
 ld bc, 17767           ;; 0533:  01 67 45
 ld bc, 35243           ;; 0536:  01 AB 89
 ld bc, 52719           ;; 0539:  01 EF CD
 ld bc, 65535           ;; 053C:  01 FF FF
 ld de, 0               ;; 053F:  11 00 00
 ld de, 291             ;; 0542:  11 23 01
 ld de, 17767           ;; 0545:  11 67 45
 ld de, 35243           ;; 0548:  11 AB 89
 ld de, 52719           ;; 054B:  11 EF CD
 ld de, 65535           ;; 054E:  11 FF FF
 ld hl, 0               ;; 0551:  21 00 00
 ld hl, 291             ;; 0554:  21 23 01
 ld hl, 17767           ;; 0557:  21 67 45
 ld hl, 35243           ;; 055A:  21 AB 89
 ld hl, 52719           ;; 055D:  21 EF CD
 ld hl, 65535           ;; 0560:  21 FF FF
 ld sp, 0               ;; 0563:  31 00 00
 ld sp, 291             ;; 0566:  31 23 01
 ld sp, 17767           ;; 0569:  31 67 45
 ld sp, 35243           ;; 056C:  31 AB 89
 ld sp, 52719           ;; 056F:  31 EF CD
 ld sp, 65535           ;; 0572:  31 FF FF
 ld ix, 0               ;; 0575:  DD 21 00 00
 ld ix, 291             ;; 0579:  DD 21 23 01
 ld ix, 17767           ;; 057D:  DD 21 67 45
 ld ix, 35243           ;; 0581:  DD 21 AB 89
 ld ix, 52719           ;; 0585:  DD 21 EF CD
 ld ix, 65535           ;; 0589:  DD 21 FF FF
 ld iy, 0               ;; 058D:  FD 21 00 00
 ld iy, 291             ;; 0591:  FD 21 23 01
 ld iy, 17767           ;; 0595:  FD 21 67 45
 ld iy, 35243           ;; 0599:  FD 21 AB 89
 ld iy, 52719           ;; 059D:  FD 21 EF CD
 ld iy, 65535           ;; 05A1:  FD 21 FF FF
 ld hl, (0)             ;; 05A5:  2A 00 00
 ld hl, (291)           ;; 05A8:  2A 23 01
 ld hl, (17767)         ;; 05AB:  2A 67 45
 ld hl, (35243)         ;; 05AE:  2A AB 89
 ld hl, (52719)         ;; 05B1:  2A EF CD
 ld hl, (65535)         ;; 05B4:  2A FF FF
 ld ix, (0)             ;; 05B7:  DD 2A 00 00
 ld ix, (291)           ;; 05BB:  DD 2A 23 01
 ld ix, (17767)         ;; 05BF:  DD 2A 67 45
 ld ix, (35243)         ;; 05C3:  DD 2A AB 89
 ld ix, (52719)         ;; 05C7:  DD 2A EF CD
 ld ix, (65535)         ;; 05CB:  DD 2A FF FF
 ld iy, (0)             ;; 05CF:  FD 2A 00 00
 ld iy, (291)           ;; 05D3:  FD 2A 23 01
 ld iy, (17767)         ;; 05D7:  FD 2A 67 45
 ld iy, (35243)         ;; 05DB:  FD 2A AB 89
 ld iy, (52719)         ;; 05DF:  FD 2A EF CD
 ld iy, (65535)         ;; 05E3:  FD 2A FF FF
 ld (0), hl             ;; 05E7:  22 00 00
 ld (291), hl           ;; 05EA:  22 23 01
 ld (17767), hl         ;; 05ED:  22 67 45
 ld (35243), hl         ;; 05F0:  22 AB 89
 ld (52719), hl         ;; 05F3:  22 EF CD
 ld (65535), hl         ;; 05F6:  22 FF FF
 ld (0), ix             ;; 05F9:  DD 22 00 00
 ld (291), ix           ;; 05FD:  DD 22 23 01
 ld (17767), ix         ;; 0601:  DD 22 67 45
 ld (35243), ix         ;; 0605:  DD 22 AB 89
 ld (52719), ix         ;; 0609:  DD 22 EF CD
 ld (65535), ix         ;; 060D:  DD 22 FF FF
 ld (0), iy             ;; 0611:  FD 22 00 00
 ld (291), iy           ;; 0615:  FD 22 23 01
 ld (17767), iy         ;; 0619:  FD 22 67 45
 ld (35243), iy         ;; 061D:  FD 22 AB 89
 ld (52719), iy         ;; 0621:  FD 22 EF CD
 ld (65535), iy         ;; 0625:  FD 22 FF FF
 ld bc, (0)             ;; 0629:  ED 4B 00 00
 ld bc, (291)           ;; 062D:  ED 4B 23 01
 ld bc, (17767)         ;; 0631:  ED 4B 67 45
 ld bc, (35243)         ;; 0635:  ED 4B AB 89
 ld bc, (52719)         ;; 0639:  ED 4B EF CD
 ld bc, (65535)         ;; 063D:  ED 4B FF FF
 ld de, (0)             ;; 0641:  ED 5B 00 00
 ld de, (291)           ;; 0645:  ED 5B 23 01
 ld de, (17767)         ;; 0649:  ED 5B 67 45
 ld de, (35243)         ;; 064D:  ED 5B AB 89
 ld de, (52719)         ;; 0651:  ED 5B EF CD
 ld de, (65535)         ;; 0655:  ED 5B FF FF
 ld sp, (0)             ;; 0659:  ED 7B 00 00
 ld sp, (291)           ;; 065D:  ED 7B 23 01
 ld sp, (17767)         ;; 0661:  ED 7B 67 45
 ld sp, (35243)         ;; 0665:  ED 7B AB 89
 ld sp, (52719)         ;; 0669:  ED 7B EF CD
 ld sp, (65535)         ;; 066D:  ED 7B FF FF
 ld (0), bc             ;; 0671:  ED 43 00 00
 ld (291), bc           ;; 0675:  ED 43 23 01
 ld (17767), bc         ;; 0679:  ED 43 67 45
 ld (35243), bc         ;; 067D:  ED 43 AB 89
 ld (52719), bc         ;; 0681:  ED 43 EF CD
 ld (65535), bc         ;; 0685:  ED 43 FF FF
 ld (0), de             ;; 0689:  ED 53 00 00
 ld (291), de           ;; 068D:  ED 53 23 01
 ld (17767), de         ;; 0691:  ED 53 67 45
 ld (35243), de         ;; 0695:  ED 53 AB 89
 ld (52719), de         ;; 0699:  ED 53 EF CD
 ld (65535), de         ;; 069D:  ED 53 FF FF
 ld (0), sp             ;; 06A1:  ED 73 00 00
 ld (291), sp           ;; 06A5:  ED 73 23 01
 ld (17767), sp         ;; 06A9:  ED 73 67 45
 ld (35243), sp         ;; 06AD:  ED 73 AB 89
 ld (52719), sp         ;; 06B1:  ED 73 EF CD
 ld (65535), sp         ;; 06B5:  ED 73 FF FF
 ld sp, hl              ;; 06B9:  F9
 ld sp, ix              ;; 06BA:  DD F9
 ld sp, iy              ;; 06BC:  FD F9
 push bc                ;; 06BE:  C5
 push de                ;; 06BF:  D5
 push hl                ;; 06C0:  E5
 push af                ;; 06C1:  F5
 push ix                ;; 06C2:  DD E5
 push iy                ;; 06C4:  FD E5
 pop bc                 ;; 06C6:  C1
 pop de                 ;; 06C7:  D1
 pop hl                 ;; 06C8:  E1
 pop af                 ;; 06C9:  F1
 pop ix                 ;; 06CA:  DD E1
 pop iy                 ;; 06CC:  FD E1
 add hl, bc             ;; 06CE:  09
 add hl, de             ;; 06CF:  19
 add hl, hl             ;; 06D0:  29
 add hl, sp             ;; 06D1:  39
 add ix, bc             ;; 06D2:  DD 09
 add ix, de             ;; 06D4:  DD 19
 add ix, ix             ;; 06D6:  DD 29
 add ix, sp             ;; 06D8:  DD 39
 add iy, bc             ;; 06DA:  FD 09
 add iy, de             ;; 06DC:  FD 19
 add iy, iy             ;; 06DE:  FD 29
 add iy, sp             ;; 06E0:  FD 39
 sbc hl, bc             ;; 06E2:  ED 42
 sbc hl, de             ;; 06E4:  ED 52
 sbc hl, hl             ;; 06E6:  ED 62
 sbc hl, sp             ;; 06E8:  ED 72
 adc hl, bc             ;; 06EA:  ED 4A
 adc hl, de             ;; 06EC:  ED 5A
 adc hl, hl             ;; 06EE:  ED 6A
 adc hl, sp             ;; 06F0:  ED 7A
 inc bc                 ;; 06F2:  03
 inc de                 ;; 06F3:  13
 inc hl                 ;; 06F4:  23
 inc sp                 ;; 06F5:  33
 dec bc                 ;; 06F6:  0B
 dec de                 ;; 06F7:  1B
 dec hl                 ;; 06F8:  2B
 dec sp                 ;; 06F9:  3B
 inc ix                 ;; 06FA:  DD 23
 dec ix                 ;; 06FC:  DD 2B
 inc iy                 ;; 06FE:  FD 23
 dec iy                 ;; 0700:  FD 2B
 ex af, af              ;; 0702:  08
 ex af, af'             ;; 0703:  08
 exx                    ;; 0704:  D9
 ex (sp), hl            ;; 0705:  E3
 ex (sp), ix            ;; 0706:  DD E3
 ex (sp), iy            ;; 0708:  FD E3
 ex de, hl              ;; 070A:  EB
 rlca                   ;; 070B:  07
 rrca                   ;; 070C:  0F
 rla                    ;; 070D:  17
 rra                    ;; 070E:  1F
 rlc b                  ;; 070F:  CB 00
 rlc c                  ;; 0711:  CB 01
 rlc d                  ;; 0713:  CB 02
 rlc e                  ;; 0715:  CB 03
 rlc h                  ;; 0717:  CB 04
 rlc l                  ;; 0719:  CB 05
 rlc (hl)               ;; 071B:  CB 06
 rlc a                  ;; 071D:  CB 07
 rrc b                  ;; 071F:  CB 08
 rrc c                  ;; 0721:  CB 09
 rrc d                  ;; 0723:  CB 0A
 rrc e                  ;; 0725:  CB 0B
 rrc h                  ;; 0727:  CB 0C
 rrc l                  ;; 0729:  CB 0D
 rrc (hl)               ;; 072B:  CB 0E
 rrc a                  ;; 072D:  CB 0F
 rl b                   ;; 072F:  CB 10
 rl c                   ;; 0731:  CB 11
 rl d                   ;; 0733:  CB 12
 rl e                   ;; 0735:  CB 13
 rl h                   ;; 0737:  CB 14
 rl l                   ;; 0739:  CB 15
 rl (hl)                ;; 073B:  CB 16
 rl a                   ;; 073D:  CB 17
 rr b                   ;; 073F:  CB 18
 rr c                   ;; 0741:  CB 19
 rr d                   ;; 0743:  CB 1A
 rr e                   ;; 0745:  CB 1B
 rr h                   ;; 0747:  CB 1C
 rr l                   ;; 0749:  CB 1D
 rr (hl)                ;; 074B:  CB 1E
 rr a                   ;; 074D:  CB 1F
 sla b                  ;; 074F:  CB 20
 sla c                  ;; 0751:  CB 21
 sla d                  ;; 0753:  CB 22
 sla e                  ;; 0755:  CB 23
 sla h                  ;; 0757:  CB 24
 sla l                  ;; 0759:  CB 25
 sla (hl)               ;; 075B:  CB 26
 sla a                  ;; 075D:  CB 27
 sra b                  ;; 075F:  CB 28
 sra c                  ;; 0761:  CB 29
 sra d                  ;; 0763:  CB 2A
 sra e                  ;; 0765:  CB 2B
 sra h                  ;; 0767:  CB 2C
 sra l                  ;; 0769:  CB 2D
 sra (hl)               ;; 076B:  CB 2E
 sra a                  ;; 076D:  CB 2F
 srl b                  ;; 076F:  CB 38
 srl c                  ;; 0771:  CB 39
 srl d                  ;; 0773:  CB 3A
 srl e                  ;; 0775:  CB 3B
 srl h                  ;; 0777:  CB 3C
 srl l                  ;; 0779:  CB 3D
 srl (hl)               ;; 077B:  CB 3E
 srl a                  ;; 077D:  CB 3F
 sll b                  ;; 077F:  CB 30
 sll c                  ;; 0781:  CB 31
 sll d                  ;; 0783:  CB 32
 sll e                  ;; 0785:  CB 33
 sll h                  ;; 0787:  CB 34
 sll l                  ;; 0789:  CB 35
 sll (hl)               ;; 078B:  CB 36
 sll a                  ;; 078D:  CB 37
 rlc (ix+-128)          ;; 078F:  DD CB 80 06
 rlc (ix)               ;; 0793:  DD CB 00 06
 rlc (ix+127)           ;; 0797:  DD CB 7F 06
 rrc (ix+-128)          ;; 079B:  DD CB 80 0E
 rrc (ix)               ;; 079F:  DD CB 00 0E
 rrc (ix+127)           ;; 07A3:  DD CB 7F 0E
 rl (ix+-128)           ;; 07A7:  DD CB 80 16
 rl (ix)                ;; 07AB:  DD CB 00 16
 rl (ix+127)            ;; 07AF:  DD CB 7F 16
 rr (ix+-128)           ;; 07B3:  DD CB 80 1E
 rr (ix)                ;; 07B7:  DD CB 00 1E
 rr (ix+127)            ;; 07BB:  DD CB 7F 1E
 sla (ix+-128)          ;; 07BF:  DD CB 80 26
 sla (ix)               ;; 07C3:  DD CB 00 26
 sla (ix+127)           ;; 07C7:  DD CB 7F 26
 sra (ix+-128)          ;; 07CB:  DD CB 80 2E
 sra (ix)               ;; 07CF:  DD CB 00 2E
 sra (ix+127)           ;; 07D3:  DD CB 7F 2E
 srl (ix+-128)          ;; 07D7:  DD CB 80 3E
 srl (ix)               ;; 07DB:  DD CB 00 3E
 srl (ix+127)           ;; 07DF:  DD CB 7F 3E
 sll (ix+-128)          ;; 07E3:  DD CB 80 36
 sll (ix)               ;; 07E7:  DD CB 00 36
 sll (ix+127)           ;; 07EB:  DD CB 7F 36
 rlc (iy+-128)          ;; 07EF:  FD CB 80 06
 rlc (iy)               ;; 07F3:  FD CB 00 06
 rlc (iy+127)           ;; 07F7:  FD CB 7F 06
 rrc (iy+-128)          ;; 07FB:  FD CB 80 0E
 rrc (iy)               ;; 07FF:  FD CB 00 0E
 rrc (iy+127)           ;; 0803:  FD CB 7F 0E
 rl (iy+-128)           ;; 0807:  FD CB 80 16
 rl (iy)                ;; 080B:  FD CB 00 16
 rl (iy+127)            ;; 080F:  FD CB 7F 16
 rr (iy+-128)           ;; 0813:  FD CB 80 1E
 rr (iy)                ;; 0817:  FD CB 00 1E
 rr (iy+127)            ;; 081B:  FD CB 7F 1E
 sla (iy+-128)          ;; 081F:  FD CB 80 26
 sla (iy)               ;; 0823:  FD CB 00 26
 sla (iy+127)           ;; 0827:  FD CB 7F 26
 sra (iy+-128)          ;; 082B:  FD CB 80 2E
 sra (iy)               ;; 082F:  FD CB 00 2E
 sra (iy+127)           ;; 0833:  FD CB 7F 2E
 srl (iy+-128)          ;; 0837:  FD CB 80 3E
 srl (iy)               ;; 083B:  FD CB 00 3E
 srl (iy+127)           ;; 083F:  FD CB 7F 3E
 sll (iy+-128)          ;; 0843:  FD CB 80 36
 sll (iy)               ;; 0847:  FD CB 00 36
 sll (iy+127)           ;; 084B:  FD CB 7F 36
 bit 0, b               ;; 084F:  CB 40
 bit 0, c               ;; 0851:  CB 41
 bit 0, d               ;; 0853:  CB 42
 bit 0, e               ;; 0855:  CB 43
 bit 0, h               ;; 0857:  CB 44
 bit 0, l               ;; 0859:  CB 45
 bit 0, (hl)            ;; 085B:  CB 46
 bit 0, a               ;; 085D:  CB 47
 bit 1, b               ;; 085F:  CB 48
 bit 1, c               ;; 0861:  CB 49
 bit 1, d               ;; 0863:  CB 4A
 bit 1, e               ;; 0865:  CB 4B
 bit 1, h               ;; 0867:  CB 4C
 bit 1, l               ;; 0869:  CB 4D
 bit 1, (hl)            ;; 086B:  CB 4E
 bit 1, a               ;; 086D:  CB 4F
 bit 2, b               ;; 086F:  CB 50
 bit 2, c               ;; 0871:  CB 51
 bit 2, d               ;; 0873:  CB 52
 bit 2, e               ;; 0875:  CB 53
 bit 2, h               ;; 0877:  CB 54
 bit 2, l               ;; 0879:  CB 55
 bit 2, (hl)            ;; 087B:  CB 56
 bit 2, a               ;; 087D:  CB 57
 bit 3, b               ;; 087F:  CB 58
 bit 3, c               ;; 0881:  CB 59
 bit 3, d               ;; 0883:  CB 5A
 bit 3, e               ;; 0885:  CB 5B
 bit 3, h               ;; 0887:  CB 5C
 bit 3, l               ;; 0889:  CB 5D
 bit 3, (hl)            ;; 088B:  CB 5E
 bit 3, a               ;; 088D:  CB 5F
 bit 4, b               ;; 088F:  CB 60
 bit 4, c               ;; 0891:  CB 61
 bit 4, d               ;; 0893:  CB 62
 bit 4, e               ;; 0895:  CB 63
 bit 4, h               ;; 0897:  CB 64
 bit 4, l               ;; 0899:  CB 65
 bit 4, (hl)            ;; 089B:  CB 66
 bit 4, a               ;; 089D:  CB 67
 bit 5, b               ;; 089F:  CB 68
 bit 5, c               ;; 08A1:  CB 69
 bit 5, d               ;; 08A3:  CB 6A
 bit 5, e               ;; 08A5:  CB 6B
 bit 5, h               ;; 08A7:  CB 6C
 bit 5, l               ;; 08A9:  CB 6D
 bit 5, (hl)            ;; 08AB:  CB 6E
 bit 5, a               ;; 08AD:  CB 6F
 bit 6, b               ;; 08AF:  CB 70
 bit 6, c               ;; 08B1:  CB 71
 bit 6, d               ;; 08B3:  CB 72
 bit 6, e               ;; 08B5:  CB 73
 bit 6, h               ;; 08B7:  CB 74
 bit 6, l               ;; 08B9:  CB 75
 bit 6, (hl)            ;; 08BB:  CB 76
 bit 6, a               ;; 08BD:  CB 77
 bit 7, b               ;; 08BF:  CB 78
 bit 7, c               ;; 08C1:  CB 79
 bit 7, d               ;; 08C3:  CB 7A
 bit 7, e               ;; 08C5:  CB 7B
 bit 7, h               ;; 08C7:  CB 7C
 bit 7, l               ;; 08C9:  CB 7D
 bit 7, (hl)            ;; 08CB:  CB 7E
 bit 7, a               ;; 08CD:  CB 7F
 res 0, b               ;; 08CF:  CB 80
 res 0, c               ;; 08D1:  CB 81
 res 0, d               ;; 08D3:  CB 82
 res 0, e               ;; 08D5:  CB 83
 res 0, h               ;; 08D7:  CB 84
 res 0, l               ;; 08D9:  CB 85
 res 0, (hl)            ;; 08DB:  CB 86
 res 0, a               ;; 08DD:  CB 87
 res 1, b               ;; 08DF:  CB 88
 res 1, c               ;; 08E1:  CB 89
 res 1, d               ;; 08E3:  CB 8A
 res 1, e               ;; 08E5:  CB 8B
 res 1, h               ;; 08E7:  CB 8C
 res 1, l               ;; 08E9:  CB 8D
 res 1, (hl)            ;; 08EB:  CB 8E
 res 1, a               ;; 08ED:  CB 8F
 res 2, b               ;; 08EF:  CB 90
 res 2, c               ;; 08F1:  CB 91
 res 2, d               ;; 08F3:  CB 92
 res 2, e               ;; 08F5:  CB 93
 res 2, h               ;; 08F7:  CB 94
 res 2, l               ;; 08F9:  CB 95
 res 2, (hl)            ;; 08FB:  CB 96
 res 2, a               ;; 08FD:  CB 97
 res 3, b               ;; 08FF:  CB 98
 res 3, c               ;; 0901:  CB 99
 res 3, d               ;; 0903:  CB 9A
 res 3, e               ;; 0905:  CB 9B
 res 3, h               ;; 0907:  CB 9C
 res 3, l               ;; 0909:  CB 9D
 res 3, (hl)            ;; 090B:  CB 9E
 res 3, a               ;; 090D:  CB 9F
 res 4, b               ;; 090F:  CB A0
 res 4, c               ;; 0911:  CB A1
 res 4, d               ;; 0913:  CB A2
 res 4, e               ;; 0915:  CB A3
 res 4, h               ;; 0917:  CB A4
 res 4, l               ;; 0919:  CB A5
 res 4, (hl)            ;; 091B:  CB A6
 res 4, a               ;; 091D:  CB A7
 res 5, b               ;; 091F:  CB A8
 res 5, c               ;; 0921:  CB A9
 res 5, d               ;; 0923:  CB AA
 res 5, e               ;; 0925:  CB AB
 res 5, h               ;; 0927:  CB AC
 res 5, l               ;; 0929:  CB AD
 res 5, (hl)            ;; 092B:  CB AE
 res 5, a               ;; 092D:  CB AF
 res 6, b               ;; 092F:  CB B0
 res 6, c               ;; 0931:  CB B1
 res 6, d               ;; 0933:  CB B2
 res 6, e               ;; 0935:  CB B3
 res 6, h               ;; 0937:  CB B4
 res 6, l               ;; 0939:  CB B5
 res 6, (hl)            ;; 093B:  CB B6
 res 6, a               ;; 093D:  CB B7
 res 7, b               ;; 093F:  CB B8
 res 7, c               ;; 0941:  CB B9
 res 7, d               ;; 0943:  CB BA
 res 7, e               ;; 0945:  CB BB
 res 7, h               ;; 0947:  CB BC
 res 7, l               ;; 0949:  CB BD
 res 7, (hl)            ;; 094B:  CB BE
 res 7, a               ;; 094D:  CB BF
 set 0, b               ;; 094F:  CB C0
 set 0, c               ;; 0951:  CB C1
 set 0, d               ;; 0953:  CB C2
 set 0, e               ;; 0955:  CB C3
 set 0, h               ;; 0957:  CB C4
 set 0, l               ;; 0959:  CB C5
 set 0, (hl)            ;; 095B:  CB C6
 set 0, a               ;; 095D:  CB C7
 set 1, b               ;; 095F:  CB C8
 set 1, c               ;; 0961:  CB C9
 set 1, d               ;; 0963:  CB CA
 set 1, e               ;; 0965:  CB CB
 set 1, h               ;; 0967:  CB CC
 set 1, l               ;; 0969:  CB CD
 set 1, (hl)            ;; 096B:  CB CE
 set 1, a               ;; 096D:  CB CF
 set 2, b               ;; 096F:  CB D0
 set 2, c               ;; 0971:  CB D1
 set 2, d               ;; 0973:  CB D2
 set 2, e               ;; 0975:  CB D3
 set 2, h               ;; 0977:  CB D4
 set 2, l               ;; 0979:  CB D5
 set 2, (hl)            ;; 097B:  CB D6
 set 2, a               ;; 097D:  CB D7
 set 3, b               ;; 097F:  CB D8
 set 3, c               ;; 0981:  CB D9
 set 3, d               ;; 0983:  CB DA
 set 3, e               ;; 0985:  CB DB
 set 3, h               ;; 0987:  CB DC
 set 3, l               ;; 0989:  CB DD
 set 3, (hl)            ;; 098B:  CB DE
 set 3, a               ;; 098D:  CB DF
 set 4, b               ;; 098F:  CB E0
 set 4, c               ;; 0991:  CB E1
 set 4, d               ;; 0993:  CB E2
 set 4, e               ;; 0995:  CB E3
 set 4, h               ;; 0997:  CB E4
 set 4, l               ;; 0999:  CB E5
 set 4, (hl)            ;; 099B:  CB E6
 set 4, a               ;; 099D:  CB E7
 set 5, b               ;; 099F:  CB E8
 set 5, c               ;; 09A1:  CB E9
 set 5, d               ;; 09A3:  CB EA
 set 5, e               ;; 09A5:  CB EB
 set 5, h               ;; 09A7:  CB EC
 set 5, l               ;; 09A9:  CB ED
 set 5, (hl)            ;; 09AB:  CB EE
 set 5, a               ;; 09AD:  CB EF
 set 6, b               ;; 09AF:  CB F0
 set 6, c               ;; 09B1:  CB F1
 set 6, d               ;; 09B3:  CB F2
 set 6, e               ;; 09B5:  CB F3
 set 6, h               ;; 09B7:  CB F4
 set 6, l               ;; 09B9:  CB F5
 set 6, (hl)            ;; 09BB:  CB F6
 set 6, a               ;; 09BD:  CB F7
 set 7, b               ;; 09BF:  CB F8
 set 7, c               ;; 09C1:  CB F9
 set 7, d               ;; 09C3:  CB FA
 set 7, e               ;; 09C5:  CB FB
 set 7, h               ;; 09C7:  CB FC
 set 7, l               ;; 09C9:  CB FD
 set 7, (hl)            ;; 09CB:  CB FE
 set 7, a               ;; 09CD:  CB FF
 bit 0, (ix+-128)       ;; 09CF:  DD CB 80 46
 bit 0, (ix)            ;; 09D3:  DD CB 00 46
 bit 0, (ix+127)        ;; 09D7:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 09DB:  DD CB 80 4E
 bit 1, (ix)            ;; 09DF:  DD CB 00 4E
 bit 1, (ix+127)        ;; 09E3:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 09E7:  DD CB 80 56
 bit 2, (ix)            ;; 09EB:  DD CB 00 56
 bit 2, (ix+127)        ;; 09EF:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 09F3:  DD CB 80 5E
 bit 3, (ix)            ;; 09F7:  DD CB 00 5E
 bit 3, (ix+127)        ;; 09FB:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 09FF:  DD CB 80 66
 bit 4, (ix)            ;; 0A03:  DD CB 00 66
 bit 4, (ix+127)        ;; 0A07:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 0A0B:  DD CB 80 6E
 bit 5, (ix)            ;; 0A0F:  DD CB 00 6E
 bit 5, (ix+127)        ;; 0A13:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 0A17:  DD CB 80 76
 bit 6, (ix)            ;; 0A1B:  DD CB 00 76
 bit 6, (ix+127)        ;; 0A1F:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 0A23:  DD CB 80 7E
 bit 7, (ix)            ;; 0A27:  DD CB 00 7E
 bit 7, (ix+127)        ;; 0A2B:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 0A2F:  DD CB 80 86
 res 0, (ix)            ;; 0A33:  DD CB 00 86
 res 0, (ix+127)        ;; 0A37:  DD CB 7F 86
 res 1, (ix+-128)       ;; 0A3B:  DD CB 80 8E
 res 1, (ix)            ;; 0A3F:  DD CB 00 8E
 res 1, (ix+127)        ;; 0A43:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 0A47:  DD CB 80 96
 res 2, (ix)            ;; 0A4B:  DD CB 00 96
 res 2, (ix+127)        ;; 0A4F:  DD CB 7F 96
 res 3, (ix+-128)       ;; 0A53:  DD CB 80 9E
 res 3, (ix)            ;; 0A57:  DD CB 00 9E
 res 3, (ix+127)        ;; 0A5B:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 0A5F:  DD CB 80 A6
 res 4, (ix)            ;; 0A63:  DD CB 00 A6
 res 4, (ix+127)        ;; 0A67:  DD CB 7F A6
 res 5, (ix+-128)       ;; 0A6B:  DD CB 80 AE
 res 5, (ix)            ;; 0A6F:  DD CB 00 AE
 res 5, (ix+127)        ;; 0A73:  DD CB 7F AE
 res 6, (ix+-128)       ;; 0A77:  DD CB 80 B6
 res 6, (ix)            ;; 0A7B:  DD CB 00 B6
 res 6, (ix+127)        ;; 0A7F:  DD CB 7F B6
 res 7, (ix+-128)       ;; 0A83:  DD CB 80 BE
 res 7, (ix)            ;; 0A87:  DD CB 00 BE
 res 7, (ix+127)        ;; 0A8B:  DD CB 7F BE
 set 0, (ix+-128)       ;; 0A8F:  DD CB 80 C6
 set 0, (ix)            ;; 0A93:  DD CB 00 C6
 set 0, (ix+127)        ;; 0A97:  DD CB 7F C6
 set 1, (ix+-128)       ;; 0A9B:  DD CB 80 CE
 set 1, (ix)            ;; 0A9F:  DD CB 00 CE
 set 1, (ix+127)        ;; 0AA3:  DD CB 7F CE
 set 2, (ix+-128)       ;; 0AA7:  DD CB 80 D6
 set 2, (ix)            ;; 0AAB:  DD CB 00 D6
 set 2, (ix+127)        ;; 0AAF:  DD CB 7F D6
 set 3, (ix+-128)       ;; 0AB3:  DD CB 80 DE
 set 3, (ix)            ;; 0AB7:  DD CB 00 DE
 set 3, (ix+127)        ;; 0ABB:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0ABF:  DD CB 80 E6
 set 4, (ix)            ;; 0AC3:  DD CB 00 E6
 set 4, (ix+127)        ;; 0AC7:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0ACB:  DD CB 80 EE
 set 5, (ix)            ;; 0ACF:  DD CB 00 EE
 set 5, (ix+127)        ;; 0AD3:  DD CB 7F EE
 set 6, (ix+-128)       ;; 0AD7:  DD CB 80 F6
 set 6, (ix)            ;; 0ADB:  DD CB 00 F6
 set 6, (ix+127)        ;; 0ADF:  DD CB 7F F6
 set 7, (ix+-128)       ;; 0AE3:  DD CB 80 FE
 set 7, (ix)            ;; 0AE7:  DD CB 00 FE
 set 7, (ix+127)        ;; 0AEB:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 0AEF:  FD CB 80 46
 bit 0, (iy)            ;; 0AF3:  FD CB 00 46
 bit 0, (iy+127)        ;; 0AF7:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 0AFB:  FD CB 80 4E
 bit 1, (iy)            ;; 0AFF:  FD CB 00 4E
 bit 1, (iy+127)        ;; 0B03:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 0B07:  FD CB 80 56
 bit 2, (iy)            ;; 0B0B:  FD CB 00 56
 bit 2, (iy+127)        ;; 0B0F:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 0B13:  FD CB 80 5E
 bit 3, (iy)            ;; 0B17:  FD CB 00 5E
 bit 3, (iy+127)        ;; 0B1B:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 0B1F:  FD CB 80 66
 bit 4, (iy)            ;; 0B23:  FD CB 00 66
 bit 4, (iy+127)        ;; 0B27:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 0B2B:  FD CB 80 6E
 bit 5, (iy)            ;; 0B2F:  FD CB 00 6E
 bit 5, (iy+127)        ;; 0B33:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 0B37:  FD CB 80 76
 bit 6, (iy)            ;; 0B3B:  FD CB 00 76
 bit 6, (iy+127)        ;; 0B3F:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 0B43:  FD CB 80 7E
 bit 7, (iy)            ;; 0B47:  FD CB 00 7E
 bit 7, (iy+127)        ;; 0B4B:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 0B4F:  FD CB 80 86
 res 0, (iy)            ;; 0B53:  FD CB 00 86
 res 0, (iy+127)        ;; 0B57:  FD CB 7F 86
 res 1, (iy+-128)       ;; 0B5B:  FD CB 80 8E
 res 1, (iy)            ;; 0B5F:  FD CB 00 8E
 res 1, (iy+127)        ;; 0B63:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 0B67:  FD CB 80 96
 res 2, (iy)            ;; 0B6B:  FD CB 00 96
 res 2, (iy+127)        ;; 0B6F:  FD CB 7F 96
 res 3, (iy+-128)       ;; 0B73:  FD CB 80 9E
 res 3, (iy)            ;; 0B77:  FD CB 00 9E
 res 3, (iy+127)        ;; 0B7B:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 0B7F:  FD CB 80 A6
 res 4, (iy)            ;; 0B83:  FD CB 00 A6
 res 4, (iy+127)        ;; 0B87:  FD CB 7F A6
 res 5, (iy+-128)       ;; 0B8B:  FD CB 80 AE
 res 5, (iy)            ;; 0B8F:  FD CB 00 AE
 res 5, (iy+127)        ;; 0B93:  FD CB 7F AE
 res 6, (iy+-128)       ;; 0B97:  FD CB 80 B6
 res 6, (iy)            ;; 0B9B:  FD CB 00 B6
 res 6, (iy+127)        ;; 0B9F:  FD CB 7F B6
 res 7, (iy+-128)       ;; 0BA3:  FD CB 80 BE
 res 7, (iy)            ;; 0BA7:  FD CB 00 BE
 res 7, (iy+127)        ;; 0BAB:  FD CB 7F BE
 set 0, (iy+-128)       ;; 0BAF:  FD CB 80 C6
 set 0, (iy)            ;; 0BB3:  FD CB 00 C6
 set 0, (iy+127)        ;; 0BB7:  FD CB 7F C6
 set 1, (iy+-128)       ;; 0BBB:  FD CB 80 CE
 set 1, (iy)            ;; 0BBF:  FD CB 00 CE
 set 1, (iy+127)        ;; 0BC3:  FD CB 7F CE
 set 2, (iy+-128)       ;; 0BC7:  FD CB 80 D6
 set 2, (iy)            ;; 0BCB:  FD CB 00 D6
 set 2, (iy+127)        ;; 0BCF:  FD CB 7F D6
 set 3, (iy+-128)       ;; 0BD3:  FD CB 80 DE
 set 3, (iy)            ;; 0BD7:  FD CB 00 DE
 set 3, (iy+127)        ;; 0BDB:  FD CB 7F DE
 set 4, (iy+-128)       ;; 0BDF:  FD CB 80 E6
 set 4, (iy)            ;; 0BE3:  FD CB 00 E6
 set 4, (iy+127)        ;; 0BE7:  FD CB 7F E6
 set 5, (iy+-128)       ;; 0BEB:  FD CB 80 EE
 set 5, (iy)            ;; 0BEF:  FD CB 00 EE
 set 5, (iy+127)        ;; 0BF3:  FD CB 7F EE
 set 6, (iy+-128)       ;; 0BF7:  FD CB 80 F6
 set 6, (iy)            ;; 0BFB:  FD CB 00 F6
 set 6, (iy+127)        ;; 0BFF:  FD CB 7F F6
 set 7, (iy+-128)       ;; 0C03:  FD CB 80 FE
 set 7, (iy)            ;; 0C07:  FD CB 00 FE
 set 7, (iy+127)        ;; 0C0B:  FD CB 7F FE
 ldi                    ;; 0C0F:  ED A0
 ldir                   ;; 0C11:  ED B0
 ldd                    ;; 0C13:  ED A8
 lddr                   ;; 0C15:  ED B8
 cpi                    ;; 0C17:  ED A1
 cpir                   ;; 0C19:  ED B1
 cpd                    ;; 0C1B:  ED A9
 cpdr                   ;; 0C1D:  ED B9
 nop                    ;; 0C1F:  00
 halt                   ;; 0C20:  76
 jp 0                   ;; 0C21:  C3 00 00
 jp 291                 ;; 0C24:  C3 23 01
 jp 17767               ;; 0C27:  C3 67 45
 jp 35243               ;; 0C2A:  C3 AB 89
 jp 52719               ;; 0C2D:  C3 EF CD
 jp 65535               ;; 0C30:  C3 FF FF
 jp nz, 0               ;; 0C33:  C2 00 00
 jp nz, 291             ;; 0C36:  C2 23 01
 jp nz, 17767           ;; 0C39:  C2 67 45
 jp nz, 35243           ;; 0C3C:  C2 AB 89
 jp nz, 52719           ;; 0C3F:  C2 EF CD
 jp nz, 65535           ;; 0C42:  C2 FF FF
 jp z, 0                ;; 0C45:  CA 00 00
 jp z, 291              ;; 0C48:  CA 23 01
 jp z, 17767            ;; 0C4B:  CA 67 45
 jp z, 35243            ;; 0C4E:  CA AB 89
 jp z, 52719            ;; 0C51:  CA EF CD
 jp z, 65535            ;; 0C54:  CA FF FF
 jp nc, 0               ;; 0C57:  D2 00 00
 jp nc, 291             ;; 0C5A:  D2 23 01
 jp nc, 17767           ;; 0C5D:  D2 67 45
 jp nc, 35243           ;; 0C60:  D2 AB 89
 jp nc, 52719           ;; 0C63:  D2 EF CD
 jp nc, 65535           ;; 0C66:  D2 FF FF
 jp c, 0                ;; 0C69:  DA 00 00
 jp c, 291              ;; 0C6C:  DA 23 01
 jp c, 17767            ;; 0C6F:  DA 67 45
 jp c, 35243            ;; 0C72:  DA AB 89
 jp c, 52719            ;; 0C75:  DA EF CD
 jp c, 65535            ;; 0C78:  DA FF FF
 jp po, 0               ;; 0C7B:  E2 00 00
 jp po, 291             ;; 0C7E:  E2 23 01
 jp po, 17767           ;; 0C81:  E2 67 45
 jp po, 35243           ;; 0C84:  E2 AB 89
 jp po, 52719           ;; 0C87:  E2 EF CD
 jp po, 65535           ;; 0C8A:  E2 FF FF
 jp pe, 0               ;; 0C8D:  EA 00 00
 jp pe, 291             ;; 0C90:  EA 23 01
 jp pe, 17767           ;; 0C93:  EA 67 45
 jp pe, 35243           ;; 0C96:  EA AB 89
 jp pe, 52719           ;; 0C99:  EA EF CD
 jp pe, 65535           ;; 0C9C:  EA FF FF
 jp p, 0                ;; 0C9F:  F2 00 00
 jp p, 291              ;; 0CA2:  F2 23 01
 jp p, 17767            ;; 0CA5:  F2 67 45
 jp p, 35243            ;; 0CA8:  F2 AB 89
 jp p, 52719            ;; 0CAB:  F2 EF CD
 jp p, 65535            ;; 0CAE:  F2 FF FF
 jp m, 0                ;; 0CB1:  FA 00 00
 jp m, 291              ;; 0CB4:  FA 23 01
 jp m, 17767            ;; 0CB7:  FA 67 45
 jp m, 35243            ;; 0CBA:  FA AB 89
 jp m, 52719            ;; 0CBD:  FA EF CD
 jp m, 65535            ;; 0CC0:  FA FF FF
 jp (hl)                ;; 0CC3:  E9
 jp (ix)                ;; 0CC4:  DD E9
 jp (iy)                ;; 0CC6:  FD E9
 djnz ASMPC             ;; 0CC8:  10 FE
 djnz b, ASMPC          ;; 0CCA:  10 FE
 jr ASMPC               ;; 0CCC:  18 FE
 jr nz, ASMPC           ;; 0CCE:  20 FE
 jr z, ASMPC            ;; 0CD0:  28 FE
 jr nc, ASMPC           ;; 0CD2:  30 FE
 jr c, ASMPC            ;; 0CD4:  38 FE
 call 0                 ;; 0CD6:  CD 00 00
 call 291               ;; 0CD9:  CD 23 01
 call 17767             ;; 0CDC:  CD 67 45
 call 35243             ;; 0CDF:  CD AB 89
 call 52719             ;; 0CE2:  CD EF CD
 call 65535             ;; 0CE5:  CD FF FF
 call nz, 0             ;; 0CE8:  C4 00 00
 call nz, 291           ;; 0CEB:  C4 23 01
 call nz, 17767         ;; 0CEE:  C4 67 45
 call nz, 35243         ;; 0CF1:  C4 AB 89
 call nz, 52719         ;; 0CF4:  C4 EF CD
 call nz, 65535         ;; 0CF7:  C4 FF FF
 call z, 0              ;; 0CFA:  CC 00 00
 call z, 291            ;; 0CFD:  CC 23 01
 call z, 17767          ;; 0D00:  CC 67 45
 call z, 35243          ;; 0D03:  CC AB 89
 call z, 52719          ;; 0D06:  CC EF CD
 call z, 65535          ;; 0D09:  CC FF FF
 call nc, 0             ;; 0D0C:  D4 00 00
 call nc, 291           ;; 0D0F:  D4 23 01
 call nc, 17767         ;; 0D12:  D4 67 45
 call nc, 35243         ;; 0D15:  D4 AB 89
 call nc, 52719         ;; 0D18:  D4 EF CD
 call nc, 65535         ;; 0D1B:  D4 FF FF
 call c, 0              ;; 0D1E:  DC 00 00
 call c, 291            ;; 0D21:  DC 23 01
 call c, 17767          ;; 0D24:  DC 67 45
 call c, 35243          ;; 0D27:  DC AB 89
 call c, 52719          ;; 0D2A:  DC EF CD
 call c, 65535          ;; 0D2D:  DC FF FF
 call po, 0             ;; 0D30:  E4 00 00
 call po, 291           ;; 0D33:  E4 23 01
 call po, 17767         ;; 0D36:  E4 67 45
 call po, 35243         ;; 0D39:  E4 AB 89
 call po, 52719         ;; 0D3C:  E4 EF CD
 call po, 65535         ;; 0D3F:  E4 FF FF
 call pe, 0             ;; 0D42:  EC 00 00
 call pe, 291           ;; 0D45:  EC 23 01
 call pe, 17767         ;; 0D48:  EC 67 45
 call pe, 35243         ;; 0D4B:  EC AB 89
 call pe, 52719         ;; 0D4E:  EC EF CD
 call pe, 65535         ;; 0D51:  EC FF FF
 call p, 0              ;; 0D54:  F4 00 00
 call p, 291            ;; 0D57:  F4 23 01
 call p, 17767          ;; 0D5A:  F4 67 45
 call p, 35243          ;; 0D5D:  F4 AB 89
 call p, 52719          ;; 0D60:  F4 EF CD
 call p, 65535          ;; 0D63:  F4 FF FF
 call m, 0              ;; 0D66:  FC 00 00
 call m, 291            ;; 0D69:  FC 23 01
 call m, 17767          ;; 0D6C:  FC 67 45
 call m, 35243          ;; 0D6F:  FC AB 89
 call m, 52719          ;; 0D72:  FC EF CD
 call m, 65535          ;; 0D75:  FC FF FF
 ret                    ;; 0D78:  C9
 ret nz                 ;; 0D79:  C0
 ret z                  ;; 0D7A:  C8
 ret nc                 ;; 0D7B:  D0
 ret c                  ;; 0D7C:  D8
 ret po                 ;; 0D7D:  E0
 ret pe                 ;; 0D7E:  E8
 ret p                  ;; 0D7F:  F0
 ret m                  ;; 0D80:  F8
 rst 16                 ;; 0D81:  D7
 rst 24                 ;; 0D82:  DF
 rst 32                 ;; 0D83:  E7
 rst 40                 ;; 0D84:  EF
 rst 56                 ;; 0D85:  FF
 rst 0                  ;; 0D86:  C7
 rst 8                  ;; 0D87:  CF
 rst 48                 ;; 0D88:  F7
 in a, (0)              ;; 0D89:  DB 00
 in a, (85)             ;; 0D8B:  DB 55
 in a, (170)            ;; 0D8D:  DB AA
 in a, (255)            ;; 0D8F:  DB FF
 in b, (c)              ;; 0D91:  ED 40
 in c, (c)              ;; 0D93:  ED 48
 in d, (c)              ;; 0D95:  ED 50
 in e, (c)              ;; 0D97:  ED 58
 in h, (c)              ;; 0D99:  ED 60
 in l, (c)              ;; 0D9B:  ED 68
 in f, (c)              ;; 0D9D:  ED 70
 in a, (c)              ;; 0D9F:  ED 78
 out (0), a             ;; 0DA1:  D3 00
 out (85), a            ;; 0DA3:  D3 55
 out (170), a           ;; 0DA5:  D3 AA
 out (255), a           ;; 0DA7:  D3 FF
 out (c), b             ;; 0DA9:  ED 41
 out (c), c             ;; 0DAB:  ED 49
 out (c), d             ;; 0DAD:  ED 51
 out (c), e             ;; 0DAF:  ED 59
 out (c), h             ;; 0DB1:  ED 61
 out (c), l             ;; 0DB3:  ED 69
 out (c), 0             ;; 0DB5:  ED 71
 out (c), a             ;; 0DB7:  ED 79
 ini                    ;; 0DB9:  ED A2
 inir                   ;; 0DBB:  ED B2
 ind                    ;; 0DBD:  ED AA
 indr                   ;; 0DBF:  ED BA
 outi                   ;; 0DC1:  ED A3
 otir                   ;; 0DC3:  ED B3
 outd                   ;; 0DC5:  ED AB
 otdr                   ;; 0DC7:  ED BB
 di                     ;; 0DC9:  F3
 ei                     ;; 0DCA:  FB
 im 0                   ;; 0DCB:  ED 46
 im 1                   ;; 0DCD:  ED 56
 im 2                   ;; 0DCF:  ED 5E
 ld i, a                ;; 0DD1:  ED 47
 ld a, i                ;; 0DD3:  ED 57
 ld r, a                ;; 0DD5:  ED 4F
 ld a, r                ;; 0DD7:  ED 5F
 reti                   ;; 0DD9:  ED 4D
 retn                   ;; 0DDB:  ED 45
