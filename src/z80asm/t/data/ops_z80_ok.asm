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
 cpl                    ;; 051F:  2F
 cpl a                  ;; 0520:  2F
 neg                    ;; 0521:  ED 44
 neg a                  ;; 0523:  ED 44
 ccf                    ;; 0525:  3F
 ccf f                  ;; 0526:  3F
 scf                    ;; 0527:  37
 scf f                  ;; 0528:  37
 ld bc, 0               ;; 0529:  01 00 00
 ld bc, 291             ;; 052C:  01 23 01
 ld bc, 17767           ;; 052F:  01 67 45
 ld bc, 35243           ;; 0532:  01 AB 89
 ld bc, 52719           ;; 0535:  01 EF CD
 ld bc, 65535           ;; 0538:  01 FF FF
 ld de, 0               ;; 053B:  11 00 00
 ld de, 291             ;; 053E:  11 23 01
 ld de, 17767           ;; 0541:  11 67 45
 ld de, 35243           ;; 0544:  11 AB 89
 ld de, 52719           ;; 0547:  11 EF CD
 ld de, 65535           ;; 054A:  11 FF FF
 ld hl, 0               ;; 054D:  21 00 00
 ld hl, 291             ;; 0550:  21 23 01
 ld hl, 17767           ;; 0553:  21 67 45
 ld hl, 35243           ;; 0556:  21 AB 89
 ld hl, 52719           ;; 0559:  21 EF CD
 ld hl, 65535           ;; 055C:  21 FF FF
 ld sp, 0               ;; 055F:  31 00 00
 ld sp, 291             ;; 0562:  31 23 01
 ld sp, 17767           ;; 0565:  31 67 45
 ld sp, 35243           ;; 0568:  31 AB 89
 ld sp, 52719           ;; 056B:  31 EF CD
 ld sp, 65535           ;; 056E:  31 FF FF
 ld ix, 0               ;; 0571:  DD 21 00 00
 ld ix, 291             ;; 0575:  DD 21 23 01
 ld ix, 17767           ;; 0579:  DD 21 67 45
 ld ix, 35243           ;; 057D:  DD 21 AB 89
 ld ix, 52719           ;; 0581:  DD 21 EF CD
 ld ix, 65535           ;; 0585:  DD 21 FF FF
 ld iy, 0               ;; 0589:  FD 21 00 00
 ld iy, 291             ;; 058D:  FD 21 23 01
 ld iy, 17767           ;; 0591:  FD 21 67 45
 ld iy, 35243           ;; 0595:  FD 21 AB 89
 ld iy, 52719           ;; 0599:  FD 21 EF CD
 ld iy, 65535           ;; 059D:  FD 21 FF FF
 ld hl, (0)             ;; 05A1:  2A 00 00
 ld hl, (291)           ;; 05A4:  2A 23 01
 ld hl, (17767)         ;; 05A7:  2A 67 45
 ld hl, (35243)         ;; 05AA:  2A AB 89
 ld hl, (52719)         ;; 05AD:  2A EF CD
 ld hl, (65535)         ;; 05B0:  2A FF FF
 ld ix, (0)             ;; 05B3:  DD 2A 00 00
 ld ix, (291)           ;; 05B7:  DD 2A 23 01
 ld ix, (17767)         ;; 05BB:  DD 2A 67 45
 ld ix, (35243)         ;; 05BF:  DD 2A AB 89
 ld ix, (52719)         ;; 05C3:  DD 2A EF CD
 ld ix, (65535)         ;; 05C7:  DD 2A FF FF
 ld iy, (0)             ;; 05CB:  FD 2A 00 00
 ld iy, (291)           ;; 05CF:  FD 2A 23 01
 ld iy, (17767)         ;; 05D3:  FD 2A 67 45
 ld iy, (35243)         ;; 05D7:  FD 2A AB 89
 ld iy, (52719)         ;; 05DB:  FD 2A EF CD
 ld iy, (65535)         ;; 05DF:  FD 2A FF FF
 ld (0), hl             ;; 05E3:  22 00 00
 ld (291), hl           ;; 05E6:  22 23 01
 ld (17767), hl         ;; 05E9:  22 67 45
 ld (35243), hl         ;; 05EC:  22 AB 89
 ld (52719), hl         ;; 05EF:  22 EF CD
 ld (65535), hl         ;; 05F2:  22 FF FF
 ld (0), ix             ;; 05F5:  DD 22 00 00
 ld (291), ix           ;; 05F9:  DD 22 23 01
 ld (17767), ix         ;; 05FD:  DD 22 67 45
 ld (35243), ix         ;; 0601:  DD 22 AB 89
 ld (52719), ix         ;; 0605:  DD 22 EF CD
 ld (65535), ix         ;; 0609:  DD 22 FF FF
 ld (0), iy             ;; 060D:  FD 22 00 00
 ld (291), iy           ;; 0611:  FD 22 23 01
 ld (17767), iy         ;; 0615:  FD 22 67 45
 ld (35243), iy         ;; 0619:  FD 22 AB 89
 ld (52719), iy         ;; 061D:  FD 22 EF CD
 ld (65535), iy         ;; 0621:  FD 22 FF FF
 ld bc, (0)             ;; 0625:  ED 4B 00 00
 ld bc, (291)           ;; 0629:  ED 4B 23 01
 ld bc, (17767)         ;; 062D:  ED 4B 67 45
 ld bc, (35243)         ;; 0631:  ED 4B AB 89
 ld bc, (52719)         ;; 0635:  ED 4B EF CD
 ld bc, (65535)         ;; 0639:  ED 4B FF FF
 ld de, (0)             ;; 063D:  ED 5B 00 00
 ld de, (291)           ;; 0641:  ED 5B 23 01
 ld de, (17767)         ;; 0645:  ED 5B 67 45
 ld de, (35243)         ;; 0649:  ED 5B AB 89
 ld de, (52719)         ;; 064D:  ED 5B EF CD
 ld de, (65535)         ;; 0651:  ED 5B FF FF
 ld sp, (0)             ;; 0655:  ED 7B 00 00
 ld sp, (291)           ;; 0659:  ED 7B 23 01
 ld sp, (17767)         ;; 065D:  ED 7B 67 45
 ld sp, (35243)         ;; 0661:  ED 7B AB 89
 ld sp, (52719)         ;; 0665:  ED 7B EF CD
 ld sp, (65535)         ;; 0669:  ED 7B FF FF
 ld (0), bc             ;; 066D:  ED 43 00 00
 ld (291), bc           ;; 0671:  ED 43 23 01
 ld (17767), bc         ;; 0675:  ED 43 67 45
 ld (35243), bc         ;; 0679:  ED 43 AB 89
 ld (52719), bc         ;; 067D:  ED 43 EF CD
 ld (65535), bc         ;; 0681:  ED 43 FF FF
 ld (0), de             ;; 0685:  ED 53 00 00
 ld (291), de           ;; 0689:  ED 53 23 01
 ld (17767), de         ;; 068D:  ED 53 67 45
 ld (35243), de         ;; 0691:  ED 53 AB 89
 ld (52719), de         ;; 0695:  ED 53 EF CD
 ld (65535), de         ;; 0699:  ED 53 FF FF
 ld (0), sp             ;; 069D:  ED 73 00 00
 ld (291), sp           ;; 06A1:  ED 73 23 01
 ld (17767), sp         ;; 06A5:  ED 73 67 45
 ld (35243), sp         ;; 06A9:  ED 73 AB 89
 ld (52719), sp         ;; 06AD:  ED 73 EF CD
 ld (65535), sp         ;; 06B1:  ED 73 FF FF
 ld sp, hl              ;; 06B5:  F9
 ld sp, ix              ;; 06B6:  DD F9
 ld sp, iy              ;; 06B8:  FD F9
 push bc                ;; 06BA:  C5
 push de                ;; 06BB:  D5
 push hl                ;; 06BC:  E5
 push af                ;; 06BD:  F5
 push ix                ;; 06BE:  DD E5
 push iy                ;; 06C0:  FD E5
 pop bc                 ;; 06C2:  C1
 pop de                 ;; 06C3:  D1
 pop hl                 ;; 06C4:  E1
 pop af                 ;; 06C5:  F1
 pop ix                 ;; 06C6:  DD E1
 pop iy                 ;; 06C8:  FD E1
 add hl, bc             ;; 06CA:  09
 add hl, de             ;; 06CB:  19
 add hl, hl             ;; 06CC:  29
 add hl, sp             ;; 06CD:  39
 add ix, bc             ;; 06CE:  DD 09
 add ix, de             ;; 06D0:  DD 19
 add ix, ix             ;; 06D2:  DD 29
 add ix, sp             ;; 06D4:  DD 39
 add iy, bc             ;; 06D6:  FD 09
 add iy, de             ;; 06D8:  FD 19
 add iy, iy             ;; 06DA:  FD 29
 add iy, sp             ;; 06DC:  FD 39
 sbc hl, bc             ;; 06DE:  ED 42
 sbc hl, de             ;; 06E0:  ED 52
 sbc hl, hl             ;; 06E2:  ED 62
 sbc hl, sp             ;; 06E4:  ED 72
 adc hl, bc             ;; 06E6:  ED 4A
 adc hl, de             ;; 06E8:  ED 5A
 adc hl, hl             ;; 06EA:  ED 6A
 adc hl, sp             ;; 06EC:  ED 7A
 inc bc                 ;; 06EE:  03
 inc de                 ;; 06EF:  13
 inc hl                 ;; 06F0:  23
 inc sp                 ;; 06F1:  33
 dec bc                 ;; 06F2:  0B
 dec de                 ;; 06F3:  1B
 dec hl                 ;; 06F4:  2B
 dec sp                 ;; 06F5:  3B
 inc ix                 ;; 06F6:  DD 23
 dec ix                 ;; 06F8:  DD 2B
 inc iy                 ;; 06FA:  FD 23
 dec iy                 ;; 06FC:  FD 2B
 ex af, af              ;; 06FE:  08
 ex af, af'             ;; 06FF:  08
 exx                    ;; 0700:  D9
 ex (sp), hl            ;; 0701:  E3
 ex (sp), ix            ;; 0702:  DD E3
 ex (sp), iy            ;; 0704:  FD E3
 ex de, hl              ;; 0706:  EB
 rlca                   ;; 0707:  07
 rrca                   ;; 0708:  0F
 rla                    ;; 0709:  17
 rra                    ;; 070A:  1F
 rlc b                  ;; 070B:  CB 00
 rlc c                  ;; 070D:  CB 01
 rlc d                  ;; 070F:  CB 02
 rlc e                  ;; 0711:  CB 03
 rlc h                  ;; 0713:  CB 04
 rlc l                  ;; 0715:  CB 05
 rlc (hl)               ;; 0717:  CB 06
 rlc a                  ;; 0719:  CB 07
 rrc b                  ;; 071B:  CB 08
 rrc c                  ;; 071D:  CB 09
 rrc d                  ;; 071F:  CB 0A
 rrc e                  ;; 0721:  CB 0B
 rrc h                  ;; 0723:  CB 0C
 rrc l                  ;; 0725:  CB 0D
 rrc (hl)               ;; 0727:  CB 0E
 rrc a                  ;; 0729:  CB 0F
 rl b                   ;; 072B:  CB 10
 rl c                   ;; 072D:  CB 11
 rl d                   ;; 072F:  CB 12
 rl e                   ;; 0731:  CB 13
 rl h                   ;; 0733:  CB 14
 rl l                   ;; 0735:  CB 15
 rl (hl)                ;; 0737:  CB 16
 rl a                   ;; 0739:  CB 17
 rr b                   ;; 073B:  CB 18
 rr c                   ;; 073D:  CB 19
 rr d                   ;; 073F:  CB 1A
 rr e                   ;; 0741:  CB 1B
 rr h                   ;; 0743:  CB 1C
 rr l                   ;; 0745:  CB 1D
 rr (hl)                ;; 0747:  CB 1E
 rr a                   ;; 0749:  CB 1F
 sla b                  ;; 074B:  CB 20
 sla c                  ;; 074D:  CB 21
 sla d                  ;; 074F:  CB 22
 sla e                  ;; 0751:  CB 23
 sla h                  ;; 0753:  CB 24
 sla l                  ;; 0755:  CB 25
 sla (hl)               ;; 0757:  CB 26
 sla a                  ;; 0759:  CB 27
 sra b                  ;; 075B:  CB 28
 sra c                  ;; 075D:  CB 29
 sra d                  ;; 075F:  CB 2A
 sra e                  ;; 0761:  CB 2B
 sra h                  ;; 0763:  CB 2C
 sra l                  ;; 0765:  CB 2D
 sra (hl)               ;; 0767:  CB 2E
 sra a                  ;; 0769:  CB 2F
 srl b                  ;; 076B:  CB 38
 srl c                  ;; 076D:  CB 39
 srl d                  ;; 076F:  CB 3A
 srl e                  ;; 0771:  CB 3B
 srl h                  ;; 0773:  CB 3C
 srl l                  ;; 0775:  CB 3D
 srl (hl)               ;; 0777:  CB 3E
 srl a                  ;; 0779:  CB 3F
 sll b                  ;; 077B:  CB 30
 sll c                  ;; 077D:  CB 31
 sll d                  ;; 077F:  CB 32
 sll e                  ;; 0781:  CB 33
 sll h                  ;; 0783:  CB 34
 sll l                  ;; 0785:  CB 35
 sll (hl)               ;; 0787:  CB 36
 sll a                  ;; 0789:  CB 37
 rlc (ix+-128)          ;; 078B:  DD CB 80 06
 rlc (ix)               ;; 078F:  DD CB 00 06
 rlc (ix+127)           ;; 0793:  DD CB 7F 06
 rrc (ix+-128)          ;; 0797:  DD CB 80 0E
 rrc (ix)               ;; 079B:  DD CB 00 0E
 rrc (ix+127)           ;; 079F:  DD CB 7F 0E
 rl (ix+-128)           ;; 07A3:  DD CB 80 16
 rl (ix)                ;; 07A7:  DD CB 00 16
 rl (ix+127)            ;; 07AB:  DD CB 7F 16
 rr (ix+-128)           ;; 07AF:  DD CB 80 1E
 rr (ix)                ;; 07B3:  DD CB 00 1E
 rr (ix+127)            ;; 07B7:  DD CB 7F 1E
 sla (ix+-128)          ;; 07BB:  DD CB 80 26
 sla (ix)               ;; 07BF:  DD CB 00 26
 sla (ix+127)           ;; 07C3:  DD CB 7F 26
 sra (ix+-128)          ;; 07C7:  DD CB 80 2E
 sra (ix)               ;; 07CB:  DD CB 00 2E
 sra (ix+127)           ;; 07CF:  DD CB 7F 2E
 srl (ix+-128)          ;; 07D3:  DD CB 80 3E
 srl (ix)               ;; 07D7:  DD CB 00 3E
 srl (ix+127)           ;; 07DB:  DD CB 7F 3E
 sll (ix+-128)          ;; 07DF:  DD CB 80 36
 sll (ix)               ;; 07E3:  DD CB 00 36
 sll (ix+127)           ;; 07E7:  DD CB 7F 36
 rlc (iy+-128)          ;; 07EB:  FD CB 80 06
 rlc (iy)               ;; 07EF:  FD CB 00 06
 rlc (iy+127)           ;; 07F3:  FD CB 7F 06
 rrc (iy+-128)          ;; 07F7:  FD CB 80 0E
 rrc (iy)               ;; 07FB:  FD CB 00 0E
 rrc (iy+127)           ;; 07FF:  FD CB 7F 0E
 rl (iy+-128)           ;; 0803:  FD CB 80 16
 rl (iy)                ;; 0807:  FD CB 00 16
 rl (iy+127)            ;; 080B:  FD CB 7F 16
 rr (iy+-128)           ;; 080F:  FD CB 80 1E
 rr (iy)                ;; 0813:  FD CB 00 1E
 rr (iy+127)            ;; 0817:  FD CB 7F 1E
 sla (iy+-128)          ;; 081B:  FD CB 80 26
 sla (iy)               ;; 081F:  FD CB 00 26
 sla (iy+127)           ;; 0823:  FD CB 7F 26
 sra (iy+-128)          ;; 0827:  FD CB 80 2E
 sra (iy)               ;; 082B:  FD CB 00 2E
 sra (iy+127)           ;; 082F:  FD CB 7F 2E
 srl (iy+-128)          ;; 0833:  FD CB 80 3E
 srl (iy)               ;; 0837:  FD CB 00 3E
 srl (iy+127)           ;; 083B:  FD CB 7F 3E
 sll (iy+-128)          ;; 083F:  FD CB 80 36
 sll (iy)               ;; 0843:  FD CB 00 36
 sll (iy+127)           ;; 0847:  FD CB 7F 36
 bit 0, b               ;; 084B:  CB 40
 bit 0, c               ;; 084D:  CB 41
 bit 0, d               ;; 084F:  CB 42
 bit 0, e               ;; 0851:  CB 43
 bit 0, h               ;; 0853:  CB 44
 bit 0, l               ;; 0855:  CB 45
 bit 0, (hl)            ;; 0857:  CB 46
 bit 0, a               ;; 0859:  CB 47
 bit 1, b               ;; 085B:  CB 48
 bit 1, c               ;; 085D:  CB 49
 bit 1, d               ;; 085F:  CB 4A
 bit 1, e               ;; 0861:  CB 4B
 bit 1, h               ;; 0863:  CB 4C
 bit 1, l               ;; 0865:  CB 4D
 bit 1, (hl)            ;; 0867:  CB 4E
 bit 1, a               ;; 0869:  CB 4F
 bit 2, b               ;; 086B:  CB 50
 bit 2, c               ;; 086D:  CB 51
 bit 2, d               ;; 086F:  CB 52
 bit 2, e               ;; 0871:  CB 53
 bit 2, h               ;; 0873:  CB 54
 bit 2, l               ;; 0875:  CB 55
 bit 2, (hl)            ;; 0877:  CB 56
 bit 2, a               ;; 0879:  CB 57
 bit 3, b               ;; 087B:  CB 58
 bit 3, c               ;; 087D:  CB 59
 bit 3, d               ;; 087F:  CB 5A
 bit 3, e               ;; 0881:  CB 5B
 bit 3, h               ;; 0883:  CB 5C
 bit 3, l               ;; 0885:  CB 5D
 bit 3, (hl)            ;; 0887:  CB 5E
 bit 3, a               ;; 0889:  CB 5F
 bit 4, b               ;; 088B:  CB 60
 bit 4, c               ;; 088D:  CB 61
 bit 4, d               ;; 088F:  CB 62
 bit 4, e               ;; 0891:  CB 63
 bit 4, h               ;; 0893:  CB 64
 bit 4, l               ;; 0895:  CB 65
 bit 4, (hl)            ;; 0897:  CB 66
 bit 4, a               ;; 0899:  CB 67
 bit 5, b               ;; 089B:  CB 68
 bit 5, c               ;; 089D:  CB 69
 bit 5, d               ;; 089F:  CB 6A
 bit 5, e               ;; 08A1:  CB 6B
 bit 5, h               ;; 08A3:  CB 6C
 bit 5, l               ;; 08A5:  CB 6D
 bit 5, (hl)            ;; 08A7:  CB 6E
 bit 5, a               ;; 08A9:  CB 6F
 bit 6, b               ;; 08AB:  CB 70
 bit 6, c               ;; 08AD:  CB 71
 bit 6, d               ;; 08AF:  CB 72
 bit 6, e               ;; 08B1:  CB 73
 bit 6, h               ;; 08B3:  CB 74
 bit 6, l               ;; 08B5:  CB 75
 bit 6, (hl)            ;; 08B7:  CB 76
 bit 6, a               ;; 08B9:  CB 77
 bit 7, b               ;; 08BB:  CB 78
 bit 7, c               ;; 08BD:  CB 79
 bit 7, d               ;; 08BF:  CB 7A
 bit 7, e               ;; 08C1:  CB 7B
 bit 7, h               ;; 08C3:  CB 7C
 bit 7, l               ;; 08C5:  CB 7D
 bit 7, (hl)            ;; 08C7:  CB 7E
 bit 7, a               ;; 08C9:  CB 7F
 res 0, b               ;; 08CB:  CB 80
 res 0, c               ;; 08CD:  CB 81
 res 0, d               ;; 08CF:  CB 82
 res 0, e               ;; 08D1:  CB 83
 res 0, h               ;; 08D3:  CB 84
 res 0, l               ;; 08D5:  CB 85
 res 0, (hl)            ;; 08D7:  CB 86
 res 0, a               ;; 08D9:  CB 87
 res 1, b               ;; 08DB:  CB 88
 res 1, c               ;; 08DD:  CB 89
 res 1, d               ;; 08DF:  CB 8A
 res 1, e               ;; 08E1:  CB 8B
 res 1, h               ;; 08E3:  CB 8C
 res 1, l               ;; 08E5:  CB 8D
 res 1, (hl)            ;; 08E7:  CB 8E
 res 1, a               ;; 08E9:  CB 8F
 res 2, b               ;; 08EB:  CB 90
 res 2, c               ;; 08ED:  CB 91
 res 2, d               ;; 08EF:  CB 92
 res 2, e               ;; 08F1:  CB 93
 res 2, h               ;; 08F3:  CB 94
 res 2, l               ;; 08F5:  CB 95
 res 2, (hl)            ;; 08F7:  CB 96
 res 2, a               ;; 08F9:  CB 97
 res 3, b               ;; 08FB:  CB 98
 res 3, c               ;; 08FD:  CB 99
 res 3, d               ;; 08FF:  CB 9A
 res 3, e               ;; 0901:  CB 9B
 res 3, h               ;; 0903:  CB 9C
 res 3, l               ;; 0905:  CB 9D
 res 3, (hl)            ;; 0907:  CB 9E
 res 3, a               ;; 0909:  CB 9F
 res 4, b               ;; 090B:  CB A0
 res 4, c               ;; 090D:  CB A1
 res 4, d               ;; 090F:  CB A2
 res 4, e               ;; 0911:  CB A3
 res 4, h               ;; 0913:  CB A4
 res 4, l               ;; 0915:  CB A5
 res 4, (hl)            ;; 0917:  CB A6
 res 4, a               ;; 0919:  CB A7
 res 5, b               ;; 091B:  CB A8
 res 5, c               ;; 091D:  CB A9
 res 5, d               ;; 091F:  CB AA
 res 5, e               ;; 0921:  CB AB
 res 5, h               ;; 0923:  CB AC
 res 5, l               ;; 0925:  CB AD
 res 5, (hl)            ;; 0927:  CB AE
 res 5, a               ;; 0929:  CB AF
 res 6, b               ;; 092B:  CB B0
 res 6, c               ;; 092D:  CB B1
 res 6, d               ;; 092F:  CB B2
 res 6, e               ;; 0931:  CB B3
 res 6, h               ;; 0933:  CB B4
 res 6, l               ;; 0935:  CB B5
 res 6, (hl)            ;; 0937:  CB B6
 res 6, a               ;; 0939:  CB B7
 res 7, b               ;; 093B:  CB B8
 res 7, c               ;; 093D:  CB B9
 res 7, d               ;; 093F:  CB BA
 res 7, e               ;; 0941:  CB BB
 res 7, h               ;; 0943:  CB BC
 res 7, l               ;; 0945:  CB BD
 res 7, (hl)            ;; 0947:  CB BE
 res 7, a               ;; 0949:  CB BF
 set 0, b               ;; 094B:  CB C0
 set 0, c               ;; 094D:  CB C1
 set 0, d               ;; 094F:  CB C2
 set 0, e               ;; 0951:  CB C3
 set 0, h               ;; 0953:  CB C4
 set 0, l               ;; 0955:  CB C5
 set 0, (hl)            ;; 0957:  CB C6
 set 0, a               ;; 0959:  CB C7
 set 1, b               ;; 095B:  CB C8
 set 1, c               ;; 095D:  CB C9
 set 1, d               ;; 095F:  CB CA
 set 1, e               ;; 0961:  CB CB
 set 1, h               ;; 0963:  CB CC
 set 1, l               ;; 0965:  CB CD
 set 1, (hl)            ;; 0967:  CB CE
 set 1, a               ;; 0969:  CB CF
 set 2, b               ;; 096B:  CB D0
 set 2, c               ;; 096D:  CB D1
 set 2, d               ;; 096F:  CB D2
 set 2, e               ;; 0971:  CB D3
 set 2, h               ;; 0973:  CB D4
 set 2, l               ;; 0975:  CB D5
 set 2, (hl)            ;; 0977:  CB D6
 set 2, a               ;; 0979:  CB D7
 set 3, b               ;; 097B:  CB D8
 set 3, c               ;; 097D:  CB D9
 set 3, d               ;; 097F:  CB DA
 set 3, e               ;; 0981:  CB DB
 set 3, h               ;; 0983:  CB DC
 set 3, l               ;; 0985:  CB DD
 set 3, (hl)            ;; 0987:  CB DE
 set 3, a               ;; 0989:  CB DF
 set 4, b               ;; 098B:  CB E0
 set 4, c               ;; 098D:  CB E1
 set 4, d               ;; 098F:  CB E2
 set 4, e               ;; 0991:  CB E3
 set 4, h               ;; 0993:  CB E4
 set 4, l               ;; 0995:  CB E5
 set 4, (hl)            ;; 0997:  CB E6
 set 4, a               ;; 0999:  CB E7
 set 5, b               ;; 099B:  CB E8
 set 5, c               ;; 099D:  CB E9
 set 5, d               ;; 099F:  CB EA
 set 5, e               ;; 09A1:  CB EB
 set 5, h               ;; 09A3:  CB EC
 set 5, l               ;; 09A5:  CB ED
 set 5, (hl)            ;; 09A7:  CB EE
 set 5, a               ;; 09A9:  CB EF
 set 6, b               ;; 09AB:  CB F0
 set 6, c               ;; 09AD:  CB F1
 set 6, d               ;; 09AF:  CB F2
 set 6, e               ;; 09B1:  CB F3
 set 6, h               ;; 09B3:  CB F4
 set 6, l               ;; 09B5:  CB F5
 set 6, (hl)            ;; 09B7:  CB F6
 set 6, a               ;; 09B9:  CB F7
 set 7, b               ;; 09BB:  CB F8
 set 7, c               ;; 09BD:  CB F9
 set 7, d               ;; 09BF:  CB FA
 set 7, e               ;; 09C1:  CB FB
 set 7, h               ;; 09C3:  CB FC
 set 7, l               ;; 09C5:  CB FD
 set 7, (hl)            ;; 09C7:  CB FE
 set 7, a               ;; 09C9:  CB FF
 bit 0, (ix+-128)       ;; 09CB:  DD CB 80 46
 bit 0, (ix)            ;; 09CF:  DD CB 00 46
 bit 0, (ix+127)        ;; 09D3:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 09D7:  DD CB 80 4E
 bit 1, (ix)            ;; 09DB:  DD CB 00 4E
 bit 1, (ix+127)        ;; 09DF:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 09E3:  DD CB 80 56
 bit 2, (ix)            ;; 09E7:  DD CB 00 56
 bit 2, (ix+127)        ;; 09EB:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 09EF:  DD CB 80 5E
 bit 3, (ix)            ;; 09F3:  DD CB 00 5E
 bit 3, (ix+127)        ;; 09F7:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 09FB:  DD CB 80 66
 bit 4, (ix)            ;; 09FF:  DD CB 00 66
 bit 4, (ix+127)        ;; 0A03:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 0A07:  DD CB 80 6E
 bit 5, (ix)            ;; 0A0B:  DD CB 00 6E
 bit 5, (ix+127)        ;; 0A0F:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 0A13:  DD CB 80 76
 bit 6, (ix)            ;; 0A17:  DD CB 00 76
 bit 6, (ix+127)        ;; 0A1B:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 0A1F:  DD CB 80 7E
 bit 7, (ix)            ;; 0A23:  DD CB 00 7E
 bit 7, (ix+127)        ;; 0A27:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 0A2B:  DD CB 80 86
 res 0, (ix)            ;; 0A2F:  DD CB 00 86
 res 0, (ix+127)        ;; 0A33:  DD CB 7F 86
 res 1, (ix+-128)       ;; 0A37:  DD CB 80 8E
 res 1, (ix)            ;; 0A3B:  DD CB 00 8E
 res 1, (ix+127)        ;; 0A3F:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 0A43:  DD CB 80 96
 res 2, (ix)            ;; 0A47:  DD CB 00 96
 res 2, (ix+127)        ;; 0A4B:  DD CB 7F 96
 res 3, (ix+-128)       ;; 0A4F:  DD CB 80 9E
 res 3, (ix)            ;; 0A53:  DD CB 00 9E
 res 3, (ix+127)        ;; 0A57:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 0A5B:  DD CB 80 A6
 res 4, (ix)            ;; 0A5F:  DD CB 00 A6
 res 4, (ix+127)        ;; 0A63:  DD CB 7F A6
 res 5, (ix+-128)       ;; 0A67:  DD CB 80 AE
 res 5, (ix)            ;; 0A6B:  DD CB 00 AE
 res 5, (ix+127)        ;; 0A6F:  DD CB 7F AE
 res 6, (ix+-128)       ;; 0A73:  DD CB 80 B6
 res 6, (ix)            ;; 0A77:  DD CB 00 B6
 res 6, (ix+127)        ;; 0A7B:  DD CB 7F B6
 res 7, (ix+-128)       ;; 0A7F:  DD CB 80 BE
 res 7, (ix)            ;; 0A83:  DD CB 00 BE
 res 7, (ix+127)        ;; 0A87:  DD CB 7F BE
 set 0, (ix+-128)       ;; 0A8B:  DD CB 80 C6
 set 0, (ix)            ;; 0A8F:  DD CB 00 C6
 set 0, (ix+127)        ;; 0A93:  DD CB 7F C6
 set 1, (ix+-128)       ;; 0A97:  DD CB 80 CE
 set 1, (ix)            ;; 0A9B:  DD CB 00 CE
 set 1, (ix+127)        ;; 0A9F:  DD CB 7F CE
 set 2, (ix+-128)       ;; 0AA3:  DD CB 80 D6
 set 2, (ix)            ;; 0AA7:  DD CB 00 D6
 set 2, (ix+127)        ;; 0AAB:  DD CB 7F D6
 set 3, (ix+-128)       ;; 0AAF:  DD CB 80 DE
 set 3, (ix)            ;; 0AB3:  DD CB 00 DE
 set 3, (ix+127)        ;; 0AB7:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0ABB:  DD CB 80 E6
 set 4, (ix)            ;; 0ABF:  DD CB 00 E6
 set 4, (ix+127)        ;; 0AC3:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0AC7:  DD CB 80 EE
 set 5, (ix)            ;; 0ACB:  DD CB 00 EE
 set 5, (ix+127)        ;; 0ACF:  DD CB 7F EE
 set 6, (ix+-128)       ;; 0AD3:  DD CB 80 F6
 set 6, (ix)            ;; 0AD7:  DD CB 00 F6
 set 6, (ix+127)        ;; 0ADB:  DD CB 7F F6
 set 7, (ix+-128)       ;; 0ADF:  DD CB 80 FE
 set 7, (ix)            ;; 0AE3:  DD CB 00 FE
 set 7, (ix+127)        ;; 0AE7:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 0AEB:  FD CB 80 46
 bit 0, (iy)            ;; 0AEF:  FD CB 00 46
 bit 0, (iy+127)        ;; 0AF3:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 0AF7:  FD CB 80 4E
 bit 1, (iy)            ;; 0AFB:  FD CB 00 4E
 bit 1, (iy+127)        ;; 0AFF:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 0B03:  FD CB 80 56
 bit 2, (iy)            ;; 0B07:  FD CB 00 56
 bit 2, (iy+127)        ;; 0B0B:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 0B0F:  FD CB 80 5E
 bit 3, (iy)            ;; 0B13:  FD CB 00 5E
 bit 3, (iy+127)        ;; 0B17:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 0B1B:  FD CB 80 66
 bit 4, (iy)            ;; 0B1F:  FD CB 00 66
 bit 4, (iy+127)        ;; 0B23:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 0B27:  FD CB 80 6E
 bit 5, (iy)            ;; 0B2B:  FD CB 00 6E
 bit 5, (iy+127)        ;; 0B2F:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 0B33:  FD CB 80 76
 bit 6, (iy)            ;; 0B37:  FD CB 00 76
 bit 6, (iy+127)        ;; 0B3B:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 0B3F:  FD CB 80 7E
 bit 7, (iy)            ;; 0B43:  FD CB 00 7E
 bit 7, (iy+127)        ;; 0B47:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 0B4B:  FD CB 80 86
 res 0, (iy)            ;; 0B4F:  FD CB 00 86
 res 0, (iy+127)        ;; 0B53:  FD CB 7F 86
 res 1, (iy+-128)       ;; 0B57:  FD CB 80 8E
 res 1, (iy)            ;; 0B5B:  FD CB 00 8E
 res 1, (iy+127)        ;; 0B5F:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 0B63:  FD CB 80 96
 res 2, (iy)            ;; 0B67:  FD CB 00 96
 res 2, (iy+127)        ;; 0B6B:  FD CB 7F 96
 res 3, (iy+-128)       ;; 0B6F:  FD CB 80 9E
 res 3, (iy)            ;; 0B73:  FD CB 00 9E
 res 3, (iy+127)        ;; 0B77:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 0B7B:  FD CB 80 A6
 res 4, (iy)            ;; 0B7F:  FD CB 00 A6
 res 4, (iy+127)        ;; 0B83:  FD CB 7F A6
 res 5, (iy+-128)       ;; 0B87:  FD CB 80 AE
 res 5, (iy)            ;; 0B8B:  FD CB 00 AE
 res 5, (iy+127)        ;; 0B8F:  FD CB 7F AE
 res 6, (iy+-128)       ;; 0B93:  FD CB 80 B6
 res 6, (iy)            ;; 0B97:  FD CB 00 B6
 res 6, (iy+127)        ;; 0B9B:  FD CB 7F B6
 res 7, (iy+-128)       ;; 0B9F:  FD CB 80 BE
 res 7, (iy)            ;; 0BA3:  FD CB 00 BE
 res 7, (iy+127)        ;; 0BA7:  FD CB 7F BE
 set 0, (iy+-128)       ;; 0BAB:  FD CB 80 C6
 set 0, (iy)            ;; 0BAF:  FD CB 00 C6
 set 0, (iy+127)        ;; 0BB3:  FD CB 7F C6
 set 1, (iy+-128)       ;; 0BB7:  FD CB 80 CE
 set 1, (iy)            ;; 0BBB:  FD CB 00 CE
 set 1, (iy+127)        ;; 0BBF:  FD CB 7F CE
 set 2, (iy+-128)       ;; 0BC3:  FD CB 80 D6
 set 2, (iy)            ;; 0BC7:  FD CB 00 D6
 set 2, (iy+127)        ;; 0BCB:  FD CB 7F D6
 set 3, (iy+-128)       ;; 0BCF:  FD CB 80 DE
 set 3, (iy)            ;; 0BD3:  FD CB 00 DE
 set 3, (iy+127)        ;; 0BD7:  FD CB 7F DE
 set 4, (iy+-128)       ;; 0BDB:  FD CB 80 E6
 set 4, (iy)            ;; 0BDF:  FD CB 00 E6
 set 4, (iy+127)        ;; 0BE3:  FD CB 7F E6
 set 5, (iy+-128)       ;; 0BE7:  FD CB 80 EE
 set 5, (iy)            ;; 0BEB:  FD CB 00 EE
 set 5, (iy+127)        ;; 0BEF:  FD CB 7F EE
 set 6, (iy+-128)       ;; 0BF3:  FD CB 80 F6
 set 6, (iy)            ;; 0BF7:  FD CB 00 F6
 set 6, (iy+127)        ;; 0BFB:  FD CB 7F F6
 set 7, (iy+-128)       ;; 0BFF:  FD CB 80 FE
 set 7, (iy)            ;; 0C03:  FD CB 00 FE
 set 7, (iy+127)        ;; 0C07:  FD CB 7F FE
 ldi                    ;; 0C0B:  ED A0
 ldir                   ;; 0C0D:  ED B0
 ldd                    ;; 0C0F:  ED A8
 lddr                   ;; 0C11:  ED B8
 cpi                    ;; 0C13:  ED A1
 cpir                   ;; 0C15:  ED B1
 cpd                    ;; 0C17:  ED A9
 cpdr                   ;; 0C19:  ED B9
 nop                    ;; 0C1B:  00
 halt                   ;; 0C1C:  76
 jp 0                   ;; 0C1D:  C3 00 00
 jp 291                 ;; 0C20:  C3 23 01
 jp 17767               ;; 0C23:  C3 67 45
 jp 35243               ;; 0C26:  C3 AB 89
 jp 52719               ;; 0C29:  C3 EF CD
 jp 65535               ;; 0C2C:  C3 FF FF
 jp nz, 0               ;; 0C2F:  C2 00 00
 jp nz, 291             ;; 0C32:  C2 23 01
 jp nz, 17767           ;; 0C35:  C2 67 45
 jp nz, 35243           ;; 0C38:  C2 AB 89
 jp nz, 52719           ;; 0C3B:  C2 EF CD
 jp nz, 65535           ;; 0C3E:  C2 FF FF
 jp z, 0                ;; 0C41:  CA 00 00
 jp z, 291              ;; 0C44:  CA 23 01
 jp z, 17767            ;; 0C47:  CA 67 45
 jp z, 35243            ;; 0C4A:  CA AB 89
 jp z, 52719            ;; 0C4D:  CA EF CD
 jp z, 65535            ;; 0C50:  CA FF FF
 jp nc, 0               ;; 0C53:  D2 00 00
 jp nc, 291             ;; 0C56:  D2 23 01
 jp nc, 17767           ;; 0C59:  D2 67 45
 jp nc, 35243           ;; 0C5C:  D2 AB 89
 jp nc, 52719           ;; 0C5F:  D2 EF CD
 jp nc, 65535           ;; 0C62:  D2 FF FF
 jp c, 0                ;; 0C65:  DA 00 00
 jp c, 291              ;; 0C68:  DA 23 01
 jp c, 17767            ;; 0C6B:  DA 67 45
 jp c, 35243            ;; 0C6E:  DA AB 89
 jp c, 52719            ;; 0C71:  DA EF CD
 jp c, 65535            ;; 0C74:  DA FF FF
 jp po, 0               ;; 0C77:  E2 00 00
 jp po, 291             ;; 0C7A:  E2 23 01
 jp po, 17767           ;; 0C7D:  E2 67 45
 jp po, 35243           ;; 0C80:  E2 AB 89
 jp po, 52719           ;; 0C83:  E2 EF CD
 jp po, 65535           ;; 0C86:  E2 FF FF
 jp pe, 0               ;; 0C89:  EA 00 00
 jp pe, 291             ;; 0C8C:  EA 23 01
 jp pe, 17767           ;; 0C8F:  EA 67 45
 jp pe, 35243           ;; 0C92:  EA AB 89
 jp pe, 52719           ;; 0C95:  EA EF CD
 jp pe, 65535           ;; 0C98:  EA FF FF
 jp p, 0                ;; 0C9B:  F2 00 00
 jp p, 291              ;; 0C9E:  F2 23 01
 jp p, 17767            ;; 0CA1:  F2 67 45
 jp p, 35243            ;; 0CA4:  F2 AB 89
 jp p, 52719            ;; 0CA7:  F2 EF CD
 jp p, 65535            ;; 0CAA:  F2 FF FF
 jp m, 0                ;; 0CAD:  FA 00 00
 jp m, 291              ;; 0CB0:  FA 23 01
 jp m, 17767            ;; 0CB3:  FA 67 45
 jp m, 35243            ;; 0CB6:  FA AB 89
 jp m, 52719            ;; 0CB9:  FA EF CD
 jp m, 65535            ;; 0CBC:  FA FF FF
 jp (hl)                ;; 0CBF:  E9
 jp (ix)                ;; 0CC0:  DD E9
 jp (iy)                ;; 0CC2:  FD E9
 djnz ASMPC             ;; 0CC4:  10 FE
 djnz b, ASMPC          ;; 0CC6:  10 FE
 jr ASMPC               ;; 0CC8:  18 FE
 jr nz, ASMPC           ;; 0CCA:  20 FE
 jr z, ASMPC            ;; 0CCC:  28 FE
 jr nc, ASMPC           ;; 0CCE:  30 FE
 jr c, ASMPC            ;; 0CD0:  38 FE
 call 0                 ;; 0CD2:  CD 00 00
 call 291               ;; 0CD5:  CD 23 01
 call 17767             ;; 0CD8:  CD 67 45
 call 35243             ;; 0CDB:  CD AB 89
 call 52719             ;; 0CDE:  CD EF CD
 call 65535             ;; 0CE1:  CD FF FF
 call nz, 0             ;; 0CE4:  C4 00 00
 call nz, 291           ;; 0CE7:  C4 23 01
 call nz, 17767         ;; 0CEA:  C4 67 45
 call nz, 35243         ;; 0CED:  C4 AB 89
 call nz, 52719         ;; 0CF0:  C4 EF CD
 call nz, 65535         ;; 0CF3:  C4 FF FF
 call z, 0              ;; 0CF6:  CC 00 00
 call z, 291            ;; 0CF9:  CC 23 01
 call z, 17767          ;; 0CFC:  CC 67 45
 call z, 35243          ;; 0CFF:  CC AB 89
 call z, 52719          ;; 0D02:  CC EF CD
 call z, 65535          ;; 0D05:  CC FF FF
 call nc, 0             ;; 0D08:  D4 00 00
 call nc, 291           ;; 0D0B:  D4 23 01
 call nc, 17767         ;; 0D0E:  D4 67 45
 call nc, 35243         ;; 0D11:  D4 AB 89
 call nc, 52719         ;; 0D14:  D4 EF CD
 call nc, 65535         ;; 0D17:  D4 FF FF
 call c, 0              ;; 0D1A:  DC 00 00
 call c, 291            ;; 0D1D:  DC 23 01
 call c, 17767          ;; 0D20:  DC 67 45
 call c, 35243          ;; 0D23:  DC AB 89
 call c, 52719          ;; 0D26:  DC EF CD
 call c, 65535          ;; 0D29:  DC FF FF
 call po, 0             ;; 0D2C:  E4 00 00
 call po, 291           ;; 0D2F:  E4 23 01
 call po, 17767         ;; 0D32:  E4 67 45
 call po, 35243         ;; 0D35:  E4 AB 89
 call po, 52719         ;; 0D38:  E4 EF CD
 call po, 65535         ;; 0D3B:  E4 FF FF
 call pe, 0             ;; 0D3E:  EC 00 00
 call pe, 291           ;; 0D41:  EC 23 01
 call pe, 17767         ;; 0D44:  EC 67 45
 call pe, 35243         ;; 0D47:  EC AB 89
 call pe, 52719         ;; 0D4A:  EC EF CD
 call pe, 65535         ;; 0D4D:  EC FF FF
 call p, 0              ;; 0D50:  F4 00 00
 call p, 291            ;; 0D53:  F4 23 01
 call p, 17767          ;; 0D56:  F4 67 45
 call p, 35243          ;; 0D59:  F4 AB 89
 call p, 52719          ;; 0D5C:  F4 EF CD
 call p, 65535          ;; 0D5F:  F4 FF FF
 call m, 0              ;; 0D62:  FC 00 00
 call m, 291            ;; 0D65:  FC 23 01
 call m, 17767          ;; 0D68:  FC 67 45
 call m, 35243          ;; 0D6B:  FC AB 89
 call m, 52719          ;; 0D6E:  FC EF CD
 call m, 65535          ;; 0D71:  FC FF FF
 ret                    ;; 0D74:  C9
 ret nz                 ;; 0D75:  C0
 ret z                  ;; 0D76:  C8
 ret nc                 ;; 0D77:  D0
 ret c                  ;; 0D78:  D8
 ret po                 ;; 0D79:  E0
 ret pe                 ;; 0D7A:  E8
 ret p                  ;; 0D7B:  F0
 ret m                  ;; 0D7C:  F8
 rst 16                 ;; 0D7D:  D7
 rst 24                 ;; 0D7E:  DF
 rst 32                 ;; 0D7F:  E7
 rst 40                 ;; 0D80:  EF
 rst 56                 ;; 0D81:  FF
 rst 0                  ;; 0D82:  C7
 rst 8                  ;; 0D83:  CF
 rst 48                 ;; 0D84:  F7
 in a, (0)              ;; 0D85:  DB 00
 in a, (85)             ;; 0D87:  DB 55
 in a, (170)            ;; 0D89:  DB AA
 in a, (255)            ;; 0D8B:  DB FF
 in b, (c)              ;; 0D8D:  ED 40
 in c, (c)              ;; 0D8F:  ED 48
 in d, (c)              ;; 0D91:  ED 50
 in e, (c)              ;; 0D93:  ED 58
 in h, (c)              ;; 0D95:  ED 60
 in l, (c)              ;; 0D97:  ED 68
 in f, (c)              ;; 0D99:  ED 70
 in a, (c)              ;; 0D9B:  ED 78
 out (0), a             ;; 0D9D:  D3 00
 out (85), a            ;; 0D9F:  D3 55
 out (170), a           ;; 0DA1:  D3 AA
 out (255), a           ;; 0DA3:  D3 FF
 out (c), b             ;; 0DA5:  ED 41
 out (c), c             ;; 0DA7:  ED 49
 out (c), d             ;; 0DA9:  ED 51
 out (c), e             ;; 0DAB:  ED 59
 out (c), h             ;; 0DAD:  ED 61
 out (c), l             ;; 0DAF:  ED 69
 out (c), 0             ;; 0DB1:  ED 71
 out (c), a             ;; 0DB3:  ED 79
 ini                    ;; 0DB5:  ED A2
 inir                   ;; 0DB7:  ED B2
 ind                    ;; 0DB9:  ED AA
 indr                   ;; 0DBB:  ED BA
 outi                   ;; 0DBD:  ED A3
 otir                   ;; 0DBF:  ED B3
 outd                   ;; 0DC1:  ED AB
 otdr                   ;; 0DC3:  ED BB
 di                     ;; 0DC5:  F3
 ei                     ;; 0DC6:  FB
 im 0                   ;; 0DC7:  ED 46
 im 1                   ;; 0DC9:  ED 56
 im 2                   ;; 0DCB:  ED 5E
 ld i, a                ;; 0DCD:  ED 47
 ld a, i                ;; 0DCF:  ED 57
 ld r, a                ;; 0DD1:  ED 4F
 ld a, r                ;; 0DD3:  ED 5F
 reti                   ;; 0DD5:  ED 4D
 retn                   ;; 0DD7:  ED 45
