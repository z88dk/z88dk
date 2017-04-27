 ld b, b                ;; 0000:  40
 ld b, c                ;; 0001:  41
 ld b, d                ;; 0002:  42
 ld b, e                ;; 0003:  43
 ld b, h                ;; 0004:  44
 ld b, l                ;; 0005:  45
 ld b, a                ;; 0006:  47
 ld c, b                ;; 0007:  48
 ld c, c                ;; 0008:  49
 ld c, d                ;; 0009:  4A
 ld c, e                ;; 000A:  4B
 ld c, h                ;; 000B:  4C
 ld c, l                ;; 000C:  4D
 ld c, a                ;; 000D:  4F
 ld d, b                ;; 000E:  50
 ld d, c                ;; 000F:  51
 ld d, d                ;; 0010:  52
 ld d, e                ;; 0011:  53
 ld d, h                ;; 0012:  54
 ld d, l                ;; 0013:  55
 ld d, a                ;; 0014:  57
 ld e, b                ;; 0015:  58
 ld e, c                ;; 0016:  59
 ld e, d                ;; 0017:  5A
 ld e, e                ;; 0018:  5B
 ld e, h                ;; 0019:  5C
 ld e, l                ;; 001A:  5D
 ld e, a                ;; 001B:  5F
 ld h, b                ;; 001C:  60
 ld h, c                ;; 001D:  61
 ld h, d                ;; 001E:  62
 ld h, e                ;; 001F:  63
 ld h, h                ;; 0020:  64
 ld h, l                ;; 0021:  65
 ld h, a                ;; 0022:  67
 ld l, b                ;; 0023:  68
 ld l, c                ;; 0024:  69
 ld l, d                ;; 0025:  6A
 ld l, e                ;; 0026:  6B
 ld l, h                ;; 0027:  6C
 ld l, l                ;; 0028:  6D
 ld l, a                ;; 0029:  6F
 ld a, b                ;; 002A:  78
 ld a, c                ;; 002B:  79
 ld a, d                ;; 002C:  7A
 ld a, e                ;; 002D:  7B
 ld a, h                ;; 002E:  7C
 ld a, l                ;; 002F:  7D
 ld a, a                ;; 0030:  7F
 ld b, ixh              ;; 0031:  DD 44
 ld b, ixl              ;; 0033:  DD 45
 ld c, ixh              ;; 0035:  DD 4C
 ld c, ixl              ;; 0037:  DD 4D
 ld d, ixh              ;; 0039:  DD 54
 ld d, ixl              ;; 003B:  DD 55
 ld e, ixh              ;; 003D:  DD 5C
 ld e, ixl              ;; 003F:  DD 5D
 ld ixh, ixh            ;; 0041:  DD 64
 ld ixh, ixl            ;; 0043:  DD 65
 ld ixl, ixh            ;; 0045:  DD 6C
 ld ixl, ixl            ;; 0047:  DD 6D
 ld a, ixh              ;; 0049:  DD 7C
 ld a, ixl              ;; 004B:  DD 7D
 ld b, iyh              ;; 004D:  FD 44
 ld b, iyl              ;; 004F:  FD 45
 ld c, iyh              ;; 0051:  FD 4C
 ld c, iyl              ;; 0053:  FD 4D
 ld d, iyh              ;; 0055:  FD 54
 ld d, iyl              ;; 0057:  FD 55
 ld e, iyh              ;; 0059:  FD 5C
 ld e, iyl              ;; 005B:  FD 5D
 ld iyh, iyh            ;; 005D:  FD 64
 ld iyh, iyl            ;; 005F:  FD 65
 ld iyl, iyh            ;; 0061:  FD 6C
 ld iyl, iyl            ;; 0063:  FD 6D
 ld a, iyh              ;; 0065:  FD 7C
 ld a, iyl              ;; 0067:  FD 7D
 ld b, 0                ;; 0069:  06 00
 ld b, 85               ;; 006B:  06 55
 ld b, 170              ;; 006D:  06 AA
 ld b, 255              ;; 006F:  06 FF
 ld c, 0                ;; 0071:  0E 00
 ld c, 85               ;; 0073:  0E 55
 ld c, 170              ;; 0075:  0E AA
 ld c, 255              ;; 0077:  0E FF
 ld d, 0                ;; 0079:  16 00
 ld d, 85               ;; 007B:  16 55
 ld d, 170              ;; 007D:  16 AA
 ld d, 255              ;; 007F:  16 FF
 ld e, 0                ;; 0081:  1E 00
 ld e, 85               ;; 0083:  1E 55
 ld e, 170              ;; 0085:  1E AA
 ld e, 255              ;; 0087:  1E FF
 ld h, 0                ;; 0089:  26 00
 ld h, 85               ;; 008B:  26 55
 ld h, 170              ;; 008D:  26 AA
 ld h, 255              ;; 008F:  26 FF
 ld l, 0                ;; 0091:  2E 00
 ld l, 85               ;; 0093:  2E 55
 ld l, 170              ;; 0095:  2E AA
 ld l, 255              ;; 0097:  2E FF
 ld a, 0                ;; 0099:  3E 00
 ld a, 85               ;; 009B:  3E 55
 ld a, 170              ;; 009D:  3E AA
 ld a, 255              ;; 009F:  3E FF
 ld ixh, 0              ;; 00A1:  DD 26 00
 ld ixh, 85             ;; 00A4:  DD 26 55
 ld ixh, 170            ;; 00A7:  DD 26 AA
 ld ixh, 255            ;; 00AA:  DD 26 FF
 ld ixl, 0              ;; 00AD:  DD 2E 00
 ld ixl, 85             ;; 00B0:  DD 2E 55
 ld ixl, 170            ;; 00B3:  DD 2E AA
 ld ixl, 255            ;; 00B6:  DD 2E FF
 ld iyh, 0              ;; 00B9:  FD 26 00
 ld iyh, 85             ;; 00BC:  FD 26 55
 ld iyh, 170            ;; 00BF:  FD 26 AA
 ld iyh, 255            ;; 00C2:  FD 26 FF
 ld iyl, 0              ;; 00C5:  FD 2E 00
 ld iyl, 85             ;; 00C8:  FD 2E 55
 ld iyl, 170            ;; 00CB:  FD 2E AA
 ld iyl, 255            ;; 00CE:  FD 2E FF
 ld b, (hl)             ;; 00D1:  46
 ld c, (hl)             ;; 00D2:  4E
 ld d, (hl)             ;; 00D3:  56
 ld e, (hl)             ;; 00D4:  5E
 ld h, (hl)             ;; 00D5:  66
 ld l, (hl)             ;; 00D6:  6E
 ld a, (hl)             ;; 00D7:  7E
 ld b, (ix + -128)      ;; 00D8:  DD 46 80
 ld b, (ix)             ;; 00DB:  DD 46 00
 ld b, (ix + 127)       ;; 00DE:  DD 46 7F
 ld c, (ix + -128)      ;; 00E1:  DD 4E 80
 ld c, (ix)             ;; 00E4:  DD 4E 00
 ld c, (ix + 127)       ;; 00E7:  DD 4E 7F
 ld d, (ix + -128)      ;; 00EA:  DD 56 80
 ld d, (ix)             ;; 00ED:  DD 56 00
 ld d, (ix + 127)       ;; 00F0:  DD 56 7F
 ld e, (ix + -128)      ;; 00F3:  DD 5E 80
 ld e, (ix)             ;; 00F6:  DD 5E 00
 ld e, (ix + 127)       ;; 00F9:  DD 5E 7F
 ld h, (ix + -128)      ;; 00FC:  DD 66 80
 ld h, (ix)             ;; 00FF:  DD 66 00
 ld h, (ix + 127)       ;; 0102:  DD 66 7F
 ld l, (ix + -128)      ;; 0105:  DD 6E 80
 ld l, (ix)             ;; 0108:  DD 6E 00
 ld l, (ix + 127)       ;; 010B:  DD 6E 7F
 ld a, (ix + -128)      ;; 010E:  DD 7E 80
 ld a, (ix)             ;; 0111:  DD 7E 00
 ld a, (ix + 127)       ;; 0114:  DD 7E 7F
 ld b, (iy + -128)      ;; 0117:  FD 46 80
 ld b, (iy)             ;; 011A:  FD 46 00
 ld b, (iy + 127)       ;; 011D:  FD 46 7F
 ld c, (iy + -128)      ;; 0120:  FD 4E 80
 ld c, (iy)             ;; 0123:  FD 4E 00
 ld c, (iy + 127)       ;; 0126:  FD 4E 7F
 ld d, (iy + -128)      ;; 0129:  FD 56 80
 ld d, (iy)             ;; 012C:  FD 56 00
 ld d, (iy + 127)       ;; 012F:  FD 56 7F
 ld e, (iy + -128)      ;; 0132:  FD 5E 80
 ld e, (iy)             ;; 0135:  FD 5E 00
 ld e, (iy + 127)       ;; 0138:  FD 5E 7F
 ld h, (iy + -128)      ;; 013B:  FD 66 80
 ld h, (iy)             ;; 013E:  FD 66 00
 ld h, (iy + 127)       ;; 0141:  FD 66 7F
 ld l, (iy + -128)      ;; 0144:  FD 6E 80
 ld l, (iy)             ;; 0147:  FD 6E 00
 ld l, (iy + 127)       ;; 014A:  FD 6E 7F
 ld a, (iy + -128)      ;; 014D:  FD 7E 80
 ld a, (iy)             ;; 0150:  FD 7E 00
 ld a, (iy + 127)       ;; 0153:  FD 7E 7F
 ld (hl), b             ;; 0156:  70
 ld (hl), c             ;; 0157:  71
 ld (hl), d             ;; 0158:  72
 ld (hl), e             ;; 0159:  73
 ld (hl), h             ;; 015A:  74
 ld (hl), l             ;; 015B:  75
 ld (hl), a             ;; 015C:  77
 ld (ix + -128), b      ;; 015D:  DD 70 80
 ld (ix), b             ;; 0160:  DD 70 00
 ld (ix + 127), b       ;; 0163:  DD 70 7F
 ld (ix + -128), c      ;; 0166:  DD 71 80
 ld (ix), c             ;; 0169:  DD 71 00
 ld (ix + 127), c       ;; 016C:  DD 71 7F
 ld (ix + -128), d      ;; 016F:  DD 72 80
 ld (ix), d             ;; 0172:  DD 72 00
 ld (ix + 127), d       ;; 0175:  DD 72 7F
 ld (ix + -128), e      ;; 0178:  DD 73 80
 ld (ix), e             ;; 017B:  DD 73 00
 ld (ix + 127), e       ;; 017E:  DD 73 7F
 ld (ix + -128), h      ;; 0181:  DD 74 80
 ld (ix), h             ;; 0184:  DD 74 00
 ld (ix + 127), h       ;; 0187:  DD 74 7F
 ld (ix + -128), l      ;; 018A:  DD 75 80
 ld (ix), l             ;; 018D:  DD 75 00
 ld (ix + 127), l       ;; 0190:  DD 75 7F
 ld (ix + -128), a      ;; 0193:  DD 77 80
 ld (ix), a             ;; 0196:  DD 77 00
 ld (ix + 127), a       ;; 0199:  DD 77 7F
 ld (iy + -128), b      ;; 019C:  FD 70 80
 ld (iy), b             ;; 019F:  FD 70 00
 ld (iy + 127), b       ;; 01A2:  FD 70 7F
 ld (iy + -128), c      ;; 01A5:  FD 71 80
 ld (iy), c             ;; 01A8:  FD 71 00
 ld (iy + 127), c       ;; 01AB:  FD 71 7F
 ld (iy + -128), d      ;; 01AE:  FD 72 80
 ld (iy), d             ;; 01B1:  FD 72 00
 ld (iy + 127), d       ;; 01B4:  FD 72 7F
 ld (iy + -128), e      ;; 01B7:  FD 73 80
 ld (iy), e             ;; 01BA:  FD 73 00
 ld (iy + 127), e       ;; 01BD:  FD 73 7F
 ld (iy + -128), h      ;; 01C0:  FD 74 80
 ld (iy), h             ;; 01C3:  FD 74 00
 ld (iy + 127), h       ;; 01C6:  FD 74 7F
 ld (iy + -128), l      ;; 01C9:  FD 75 80
 ld (iy), l             ;; 01CC:  FD 75 00
 ld (iy + 127), l       ;; 01CF:  FD 75 7F
 ld (iy + -128), a      ;; 01D2:  FD 77 80
 ld (iy), a             ;; 01D5:  FD 77 00
 ld (iy + 127), a       ;; 01D8:  FD 77 7F
 ld (hl), 0             ;; 01DB:  36 00
 ld (hl), 85            ;; 01DD:  36 55
 ld (hl), 170           ;; 01DF:  36 AA
 ld (hl), 255           ;; 01E1:  36 FF
 ld (ix + -128), 0      ;; 01E3:  DD 36 80 00
 ld (ix), 0             ;; 01E7:  DD 36 00 00
 ld (ix + 127), 0       ;; 01EB:  DD 36 7F 00
 ld (ix + -128), 85     ;; 01EF:  DD 36 80 55
 ld (ix), 85            ;; 01F3:  DD 36 00 55
 ld (ix + 127), 85      ;; 01F7:  DD 36 7F 55
 ld (ix + -128), 170    ;; 01FB:  DD 36 80 AA
 ld (ix), 170           ;; 01FF:  DD 36 00 AA
 ld (ix + 127), 170     ;; 0203:  DD 36 7F AA
 ld (ix + -128), 255    ;; 0207:  DD 36 80 FF
 ld (ix), 255           ;; 020B:  DD 36 00 FF
 ld (ix + 127), 255     ;; 020F:  DD 36 7F FF
 ld (iy + -128), 0      ;; 0213:  FD 36 80 00
 ld (iy), 0             ;; 0217:  FD 36 00 00
 ld (iy + 127), 0       ;; 021B:  FD 36 7F 00
 ld (iy + -128), 85     ;; 021F:  FD 36 80 55
 ld (iy), 85            ;; 0223:  FD 36 00 55
 ld (iy + 127), 85      ;; 0227:  FD 36 7F 55
 ld (iy + -128), 170    ;; 022B:  FD 36 80 AA
 ld (iy), 170           ;; 022F:  FD 36 00 AA
 ld (iy + 127), 170     ;; 0233:  FD 36 7F AA
 ld (iy + -128), 255    ;; 0237:  FD 36 80 FF
 ld (iy), 255           ;; 023B:  FD 36 00 FF
 ld (iy + 127), 255     ;; 023F:  FD 36 7F FF
 ld a, (bc)             ;; 0243:  0A
 ld a, (de)             ;; 0244:  1A
 ld (bc), a             ;; 0245:  02
 ld (de), a             ;; 0246:  12
 ld a, (0)              ;; 0247:  3A 00 00
 ld a, (291)            ;; 024A:  3A 23 01
 ld a, (17767)          ;; 024D:  3A 67 45
 ld a, (35243)          ;; 0250:  3A AB 89
 ld a, (52719)          ;; 0253:  3A EF CD
 ld a, (65535)          ;; 0256:  3A FF FF
 ld (0), a              ;; 0259:  32 00 00
 ld (291), a            ;; 025C:  32 23 01
 ld (17767), a          ;; 025F:  32 67 45
 ld (35243), a          ;; 0262:  32 AB 89
 ld (52719), a          ;; 0265:  32 EF CD
 ld (65535), a          ;; 0268:  32 FF FF
 add a, b               ;; 026B:  80
 add a, c               ;; 026C:  81
 add a, d               ;; 026D:  82
 add a, e               ;; 026E:  83
 add a, h               ;; 026F:  84
 add a, l               ;; 0270:  85
 add a, (hl)            ;; 0271:  86
 add a, a               ;; 0272:  87
 adc a, b               ;; 0273:  88
 adc a, c               ;; 0274:  89
 adc a, d               ;; 0275:  8A
 adc a, e               ;; 0276:  8B
 adc a, h               ;; 0277:  8C
 adc a, l               ;; 0278:  8D
 adc a, (hl)            ;; 0279:  8E
 adc a, a               ;; 027A:  8F
 sub a, b               ;; 027B:  90
 sub a, c               ;; 027C:  91
 sub a, d               ;; 027D:  92
 sub a, e               ;; 027E:  93
 sub a, h               ;; 027F:  94
 sub a, l               ;; 0280:  95
 sub a, (hl)            ;; 0281:  96
 sub a, a               ;; 0282:  97
 sbc a, b               ;; 0283:  98
 sbc a, c               ;; 0284:  99
 sbc a, d               ;; 0285:  9A
 sbc a, e               ;; 0286:  9B
 sbc a, h               ;; 0287:  9C
 sbc a, l               ;; 0288:  9D
 sbc a, (hl)            ;; 0289:  9E
 sbc a, a               ;; 028A:  9F
 and a, b               ;; 028B:  A0
 and a, c               ;; 028C:  A1
 and a, d               ;; 028D:  A2
 and a, e               ;; 028E:  A3
 and a, h               ;; 028F:  A4
 and a, l               ;; 0290:  A5
 and a, (hl)            ;; 0291:  A6
 and a, a               ;; 0292:  A7
 xor a, b               ;; 0293:  A8
 xor a, c               ;; 0294:  A9
 xor a, d               ;; 0295:  AA
 xor a, e               ;; 0296:  AB
 xor a, h               ;; 0297:  AC
 xor a, l               ;; 0298:  AD
 xor a, (hl)            ;; 0299:  AE
 xor a, a               ;; 029A:  AF
 or a, b                ;; 029B:  B0
 or a, c                ;; 029C:  B1
 or a, d                ;; 029D:  B2
 or a, e                ;; 029E:  B3
 or a, h                ;; 029F:  B4
 or a, l                ;; 02A0:  B5
 or a, (hl)             ;; 02A1:  B6
 or a, a                ;; 02A2:  B7
 cp a, b                ;; 02A3:  B8
 cp a, c                ;; 02A4:  B9
 cp a, d                ;; 02A5:  BA
 cp a, e                ;; 02A6:  BB
 cp a, h                ;; 02A7:  BC
 cp a, l                ;; 02A8:  BD
 cp a, (hl)             ;; 02A9:  BE
 cp a, a                ;; 02AA:  BF
 add b                  ;; 02AB:  80
 add c                  ;; 02AC:  81
 add d                  ;; 02AD:  82
 add e                  ;; 02AE:  83
 add h                  ;; 02AF:  84
 add l                  ;; 02B0:  85
 add (hl)               ;; 02B1:  86
 add a                  ;; 02B2:  87
 adc b                  ;; 02B3:  88
 adc c                  ;; 02B4:  89
 adc d                  ;; 02B5:  8A
 adc e                  ;; 02B6:  8B
 adc h                  ;; 02B7:  8C
 adc l                  ;; 02B8:  8D
 adc (hl)               ;; 02B9:  8E
 adc a                  ;; 02BA:  8F
 sub b                  ;; 02BB:  90
 sub c                  ;; 02BC:  91
 sub d                  ;; 02BD:  92
 sub e                  ;; 02BE:  93
 sub h                  ;; 02BF:  94
 sub l                  ;; 02C0:  95
 sub (hl)               ;; 02C1:  96
 sub a                  ;; 02C2:  97
 sbc b                  ;; 02C3:  98
 sbc c                  ;; 02C4:  99
 sbc d                  ;; 02C5:  9A
 sbc e                  ;; 02C6:  9B
 sbc h                  ;; 02C7:  9C
 sbc l                  ;; 02C8:  9D
 sbc (hl)               ;; 02C9:  9E
 sbc a                  ;; 02CA:  9F
 and b                  ;; 02CB:  A0
 and c                  ;; 02CC:  A1
 and d                  ;; 02CD:  A2
 and e                  ;; 02CE:  A3
 and h                  ;; 02CF:  A4
 and l                  ;; 02D0:  A5
 and (hl)               ;; 02D1:  A6
 and a                  ;; 02D2:  A7
 xor b                  ;; 02D3:  A8
 xor c                  ;; 02D4:  A9
 xor d                  ;; 02D5:  AA
 xor e                  ;; 02D6:  AB
 xor h                  ;; 02D7:  AC
 xor l                  ;; 02D8:  AD
 xor (hl)               ;; 02D9:  AE
 xor a                  ;; 02DA:  AF
 or b                   ;; 02DB:  B0
 or c                   ;; 02DC:  B1
 or d                   ;; 02DD:  B2
 or e                   ;; 02DE:  B3
 or h                   ;; 02DF:  B4
 or l                   ;; 02E0:  B5
 or (hl)                ;; 02E1:  B6
 or a                   ;; 02E2:  B7
 cp b                   ;; 02E3:  B8
 cp c                   ;; 02E4:  B9
 cp d                   ;; 02E5:  BA
 cp e                   ;; 02E6:  BB
 cp h                   ;; 02E7:  BC
 cp l                   ;; 02E8:  BD
 cp (hl)                ;; 02E9:  BE
 cp a                   ;; 02EA:  BF
 add a, (ix+-128)       ;; 02EB:  DD 86 80
 add a, (ix)            ;; 02EE:  DD 86 00
 add a, (ix+127)        ;; 02F1:  DD 86 7F
 adc a, (ix+-128)       ;; 02F4:  DD 8E 80
 adc a, (ix)            ;; 02F7:  DD 8E 00
 adc a, (ix+127)        ;; 02FA:  DD 8E 7F
 sub a, (ix+-128)       ;; 02FD:  DD 96 80
 sub a, (ix)            ;; 0300:  DD 96 00
 sub a, (ix+127)        ;; 0303:  DD 96 7F
 sbc a, (ix+-128)       ;; 0306:  DD 9E 80
 sbc a, (ix)            ;; 0309:  DD 9E 00
 sbc a, (ix+127)        ;; 030C:  DD 9E 7F
 and a, (ix+-128)       ;; 030F:  DD A6 80
 and a, (ix)            ;; 0312:  DD A6 00
 and a, (ix+127)        ;; 0315:  DD A6 7F
 xor a, (ix+-128)       ;; 0318:  DD AE 80
 xor a, (ix)            ;; 031B:  DD AE 00
 xor a, (ix+127)        ;; 031E:  DD AE 7F
 or a, (ix+-128)        ;; 0321:  DD B6 80
 or a, (ix)             ;; 0324:  DD B6 00
 or a, (ix+127)         ;; 0327:  DD B6 7F
 cp a, (ix+-128)        ;; 032A:  DD BE 80
 cp a, (ix)             ;; 032D:  DD BE 00
 cp a, (ix+127)         ;; 0330:  DD BE 7F
 add (ix+-128)          ;; 0333:  DD 86 80
 add (ix)               ;; 0336:  DD 86 00
 add (ix+127)           ;; 0339:  DD 86 7F
 adc (ix+-128)          ;; 033C:  DD 8E 80
 adc (ix)               ;; 033F:  DD 8E 00
 adc (ix+127)           ;; 0342:  DD 8E 7F
 sub (ix+-128)          ;; 0345:  DD 96 80
 sub (ix)               ;; 0348:  DD 96 00
 sub (ix+127)           ;; 034B:  DD 96 7F
 sbc (ix+-128)          ;; 034E:  DD 9E 80
 sbc (ix)               ;; 0351:  DD 9E 00
 sbc (ix+127)           ;; 0354:  DD 9E 7F
 and (ix+-128)          ;; 0357:  DD A6 80
 and (ix)               ;; 035A:  DD A6 00
 and (ix+127)           ;; 035D:  DD A6 7F
 xor (ix+-128)          ;; 0360:  DD AE 80
 xor (ix)               ;; 0363:  DD AE 00
 xor (ix+127)           ;; 0366:  DD AE 7F
 or (ix+-128)           ;; 0369:  DD B6 80
 or (ix)                ;; 036C:  DD B6 00
 or (ix+127)            ;; 036F:  DD B6 7F
 cp (ix+-128)           ;; 0372:  DD BE 80
 cp (ix)                ;; 0375:  DD BE 00
 cp (ix+127)            ;; 0378:  DD BE 7F
 add a, (iy+-128)       ;; 037B:  FD 86 80
 add a, (iy)            ;; 037E:  FD 86 00
 add a, (iy+127)        ;; 0381:  FD 86 7F
 adc a, (iy+-128)       ;; 0384:  FD 8E 80
 adc a, (iy)            ;; 0387:  FD 8E 00
 adc a, (iy+127)        ;; 038A:  FD 8E 7F
 sub a, (iy+-128)       ;; 038D:  FD 96 80
 sub a, (iy)            ;; 0390:  FD 96 00
 sub a, (iy+127)        ;; 0393:  FD 96 7F
 sbc a, (iy+-128)       ;; 0396:  FD 9E 80
 sbc a, (iy)            ;; 0399:  FD 9E 00
 sbc a, (iy+127)        ;; 039C:  FD 9E 7F
 and a, (iy+-128)       ;; 039F:  FD A6 80
 and a, (iy)            ;; 03A2:  FD A6 00
 and a, (iy+127)        ;; 03A5:  FD A6 7F
 xor a, (iy+-128)       ;; 03A8:  FD AE 80
 xor a, (iy)            ;; 03AB:  FD AE 00
 xor a, (iy+127)        ;; 03AE:  FD AE 7F
 or a, (iy+-128)        ;; 03B1:  FD B6 80
 or a, (iy)             ;; 03B4:  FD B6 00
 or a, (iy+127)         ;; 03B7:  FD B6 7F
 cp a, (iy+-128)        ;; 03BA:  FD BE 80
 cp a, (iy)             ;; 03BD:  FD BE 00
 cp a, (iy+127)         ;; 03C0:  FD BE 7F
 add (iy+-128)          ;; 03C3:  FD 86 80
 add (iy)               ;; 03C6:  FD 86 00
 add (iy+127)           ;; 03C9:  FD 86 7F
 adc (iy+-128)          ;; 03CC:  FD 8E 80
 adc (iy)               ;; 03CF:  FD 8E 00
 adc (iy+127)           ;; 03D2:  FD 8E 7F
 sub (iy+-128)          ;; 03D5:  FD 96 80
 sub (iy)               ;; 03D8:  FD 96 00
 sub (iy+127)           ;; 03DB:  FD 96 7F
 sbc (iy+-128)          ;; 03DE:  FD 9E 80
 sbc (iy)               ;; 03E1:  FD 9E 00
 sbc (iy+127)           ;; 03E4:  FD 9E 7F
 and (iy+-128)          ;; 03E7:  FD A6 80
 and (iy)               ;; 03EA:  FD A6 00
 and (iy+127)           ;; 03ED:  FD A6 7F
 xor (iy+-128)          ;; 03F0:  FD AE 80
 xor (iy)               ;; 03F3:  FD AE 00
 xor (iy+127)           ;; 03F6:  FD AE 7F
 or (iy+-128)           ;; 03F9:  FD B6 80
 or (iy)                ;; 03FC:  FD B6 00
 or (iy+127)            ;; 03FF:  FD B6 7F
 cp (iy+-128)           ;; 0402:  FD BE 80
 cp (iy)                ;; 0405:  FD BE 00
 cp (iy+127)            ;; 0408:  FD BE 7F
 add a, ixh             ;; 040B:  DD 84
 add a, ixl             ;; 040D:  DD 85
 adc a, ixh             ;; 040F:  DD 8C
 adc a, ixl             ;; 0411:  DD 8D
 sub a, ixh             ;; 0413:  DD 94
 sub a, ixl             ;; 0415:  DD 95
 sbc a, ixh             ;; 0417:  DD 9C
 sbc a, ixl             ;; 0419:  DD 9D
 and a, ixh             ;; 041B:  DD A4
 and a, ixl             ;; 041D:  DD A5
 xor a, ixh             ;; 041F:  DD AC
 xor a, ixl             ;; 0421:  DD AD
 or a, ixh              ;; 0423:  DD B4
 or a, ixl              ;; 0425:  DD B5
 cp a, ixh              ;; 0427:  DD BC
 cp a, ixl              ;; 0429:  DD BD
 add ixh                ;; 042B:  DD 84
 add ixl                ;; 042D:  DD 85
 adc ixh                ;; 042F:  DD 8C
 adc ixl                ;; 0431:  DD 8D
 sub ixh                ;; 0433:  DD 94
 sub ixl                ;; 0435:  DD 95
 sbc ixh                ;; 0437:  DD 9C
 sbc ixl                ;; 0439:  DD 9D
 and ixh                ;; 043B:  DD A4
 and ixl                ;; 043D:  DD A5
 xor ixh                ;; 043F:  DD AC
 xor ixl                ;; 0441:  DD AD
 or ixh                 ;; 0443:  DD B4
 or ixl                 ;; 0445:  DD B5
 cp ixh                 ;; 0447:  DD BC
 cp ixl                 ;; 0449:  DD BD
 add a, iyh             ;; 044B:  FD 84
 add a, iyl             ;; 044D:  FD 85
 adc a, iyh             ;; 044F:  FD 8C
 adc a, iyl             ;; 0451:  FD 8D
 sub a, iyh             ;; 0453:  FD 94
 sub a, iyl             ;; 0455:  FD 95
 sbc a, iyh             ;; 0457:  FD 9C
 sbc a, iyl             ;; 0459:  FD 9D
 and a, iyh             ;; 045B:  FD A4
 and a, iyl             ;; 045D:  FD A5
 xor a, iyh             ;; 045F:  FD AC
 xor a, iyl             ;; 0461:  FD AD
 or a, iyh              ;; 0463:  FD B4
 or a, iyl              ;; 0465:  FD B5
 cp a, iyh              ;; 0467:  FD BC
 cp a, iyl              ;; 0469:  FD BD
 add iyh                ;; 046B:  FD 84
 add iyl                ;; 046D:  FD 85
 adc iyh                ;; 046F:  FD 8C
 adc iyl                ;; 0471:  FD 8D
 sub iyh                ;; 0473:  FD 94
 sub iyl                ;; 0475:  FD 95
 sbc iyh                ;; 0477:  FD 9C
 sbc iyl                ;; 0479:  FD 9D
 and iyh                ;; 047B:  FD A4
 and iyl                ;; 047D:  FD A5
 xor iyh                ;; 047F:  FD AC
 xor iyl                ;; 0481:  FD AD
 or iyh                 ;; 0483:  FD B4
 or iyl                 ;; 0485:  FD B5
 cp iyh                 ;; 0487:  FD BC
 cp iyl                 ;; 0489:  FD BD
 add a, 0               ;; 048B:  C6 00
 add a, 85              ;; 048D:  C6 55
 add a, 170             ;; 048F:  C6 AA
 add a, 255             ;; 0491:  C6 FF
 adc a, 0               ;; 0493:  CE 00
 adc a, 85              ;; 0495:  CE 55
 adc a, 170             ;; 0497:  CE AA
 adc a, 255             ;; 0499:  CE FF
 sub a, 0               ;; 049B:  D6 00
 sub a, 85              ;; 049D:  D6 55
 sub a, 170             ;; 049F:  D6 AA
 sub a, 255             ;; 04A1:  D6 FF
 sbc a, 0               ;; 04A3:  DE 00
 sbc a, 85              ;; 04A5:  DE 55
 sbc a, 170             ;; 04A7:  DE AA
 sbc a, 255             ;; 04A9:  DE FF
 and a, 0               ;; 04AB:  E6 00
 and a, 85              ;; 04AD:  E6 55
 and a, 170             ;; 04AF:  E6 AA
 and a, 255             ;; 04B1:  E6 FF
 xor a, 0               ;; 04B3:  EE 00
 xor a, 85              ;; 04B5:  EE 55
 xor a, 170             ;; 04B7:  EE AA
 xor a, 255             ;; 04B9:  EE FF
 or a, 0                ;; 04BB:  F6 00
 or a, 85               ;; 04BD:  F6 55
 or a, 170              ;; 04BF:  F6 AA
 or a, 255              ;; 04C1:  F6 FF
 cp a, 0                ;; 04C3:  FE 00
 cp a, 85               ;; 04C5:  FE 55
 cp a, 170              ;; 04C7:  FE AA
 cp a, 255              ;; 04C9:  FE FF
 add 0                  ;; 04CB:  C6 00
 add 85                 ;; 04CD:  C6 55
 add 170                ;; 04CF:  C6 AA
 add 255                ;; 04D1:  C6 FF
 adc 0                  ;; 04D3:  CE 00
 adc 85                 ;; 04D5:  CE 55
 adc 170                ;; 04D7:  CE AA
 adc 255                ;; 04D9:  CE FF
 sub 0                  ;; 04DB:  D6 00
 sub 85                 ;; 04DD:  D6 55
 sub 170                ;; 04DF:  D6 AA
 sub 255                ;; 04E1:  D6 FF
 sbc 0                  ;; 04E3:  DE 00
 sbc 85                 ;; 04E5:  DE 55
 sbc 170                ;; 04E7:  DE AA
 sbc 255                ;; 04E9:  DE FF
 and 0                  ;; 04EB:  E6 00
 and 85                 ;; 04ED:  E6 55
 and 170                ;; 04EF:  E6 AA
 and 255                ;; 04F1:  E6 FF
 xor 0                  ;; 04F3:  EE 00
 xor 85                 ;; 04F5:  EE 55
 xor 170                ;; 04F7:  EE AA
 xor 255                ;; 04F9:  EE FF
 or 0                   ;; 04FB:  F6 00
 or 85                  ;; 04FD:  F6 55
 or 170                 ;; 04FF:  F6 AA
 or 255                 ;; 0501:  F6 FF
 cp 0                   ;; 0503:  FE 00
 cp 85                  ;; 0505:  FE 55
 cp 170                 ;; 0507:  FE AA
 cp 255                 ;; 0509:  FE FF
 inc b                  ;; 050B:  04
 inc c                  ;; 050C:  0C
 inc d                  ;; 050D:  14
 inc e                  ;; 050E:  1C
 inc h                  ;; 050F:  24
 inc l                  ;; 0510:  2C
 inc a                  ;; 0511:  3C
 dec b                  ;; 0512:  05
 dec c                  ;; 0513:  0D
 dec d                  ;; 0514:  15
 dec e                  ;; 0515:  1D
 dec h                  ;; 0516:  25
 dec l                  ;; 0517:  2D
 dec a                  ;; 0518:  3D
 inc ixh                ;; 0519:  DD 24
 inc ixl                ;; 051B:  DD 2C
 dec ixh                ;; 051D:  DD 25
 dec ixl                ;; 051F:  DD 2D
 inc iyh                ;; 0521:  FD 24
 inc iyl                ;; 0523:  FD 2C
 dec iyh                ;; 0525:  FD 25
 dec iyl                ;; 0527:  FD 2D
 inc (hl)               ;; 0529:  34
 dec (hl)               ;; 052A:  35
 inc (ix + -128)        ;; 052B:  DD 34 80
 inc (ix)               ;; 052E:  DD 34 00
 inc (ix + 127)         ;; 0531:  DD 34 7F
 dec (ix + -128)        ;; 0534:  DD 35 80
 dec (ix)               ;; 0537:  DD 35 00
 dec (ix + 127)         ;; 053A:  DD 35 7F
 inc (iy + -128)        ;; 053D:  FD 34 80
 inc (iy)               ;; 0540:  FD 34 00
 inc (iy + 127)         ;; 0543:  FD 34 7F
 dec (iy + -128)        ;; 0546:  FD 35 80
 dec (iy)               ;; 0549:  FD 35 00
 dec (iy + 127)         ;; 054C:  FD 35 7F
 daa                    ;; 054F:  27
 rld                    ;; 0550:  ED 6F
 rrd                    ;; 0552:  ED 67
 cpl                    ;; 0554:  2F
 cpl a                  ;; 0555:  2F
 neg                    ;; 0556:  ED 44
 neg a                  ;; 0558:  ED 44
 ccf                    ;; 055A:  3F
 ccf f                  ;; 055B:  3F
 scf                    ;; 055C:  37
 scf f                  ;; 055D:  37
 ld bc, 0               ;; 055E:  01 00 00
 ld bc, 291             ;; 0561:  01 23 01
 ld bc, 17767           ;; 0564:  01 67 45
 ld bc, 35243           ;; 0567:  01 AB 89
 ld bc, 52719           ;; 056A:  01 EF CD
 ld bc, 65535           ;; 056D:  01 FF FF
 ld de, 0               ;; 0570:  11 00 00
 ld de, 291             ;; 0573:  11 23 01
 ld de, 17767           ;; 0576:  11 67 45
 ld de, 35243           ;; 0579:  11 AB 89
 ld de, 52719           ;; 057C:  11 EF CD
 ld de, 65535           ;; 057F:  11 FF FF
 ld hl, 0               ;; 0582:  21 00 00
 ld hl, 291             ;; 0585:  21 23 01
 ld hl, 17767           ;; 0588:  21 67 45
 ld hl, 35243           ;; 058B:  21 AB 89
 ld hl, 52719           ;; 058E:  21 EF CD
 ld hl, 65535           ;; 0591:  21 FF FF
 ld sp, 0               ;; 0594:  31 00 00
 ld sp, 291             ;; 0597:  31 23 01
 ld sp, 17767           ;; 059A:  31 67 45
 ld sp, 35243           ;; 059D:  31 AB 89
 ld sp, 52719           ;; 05A0:  31 EF CD
 ld sp, 65535           ;; 05A3:  31 FF FF
 ld ix, 0               ;; 05A6:  DD 21 00 00
 ld ix, 291             ;; 05AA:  DD 21 23 01
 ld ix, 17767           ;; 05AE:  DD 21 67 45
 ld ix, 35243           ;; 05B2:  DD 21 AB 89
 ld ix, 52719           ;; 05B6:  DD 21 EF CD
 ld ix, 65535           ;; 05BA:  DD 21 FF FF
 ld iy, 0               ;; 05BE:  FD 21 00 00
 ld iy, 291             ;; 05C2:  FD 21 23 01
 ld iy, 17767           ;; 05C6:  FD 21 67 45
 ld iy, 35243           ;; 05CA:  FD 21 AB 89
 ld iy, 52719           ;; 05CE:  FD 21 EF CD
 ld iy, 65535           ;; 05D2:  FD 21 FF FF
 ld hl, (0)             ;; 05D6:  2A 00 00
 ld hl, (291)           ;; 05D9:  2A 23 01
 ld hl, (17767)         ;; 05DC:  2A 67 45
 ld hl, (35243)         ;; 05DF:  2A AB 89
 ld hl, (52719)         ;; 05E2:  2A EF CD
 ld hl, (65535)         ;; 05E5:  2A FF FF
 ld ix, (0)             ;; 05E8:  DD 2A 00 00
 ld ix, (291)           ;; 05EC:  DD 2A 23 01
 ld ix, (17767)         ;; 05F0:  DD 2A 67 45
 ld ix, (35243)         ;; 05F4:  DD 2A AB 89
 ld ix, (52719)         ;; 05F8:  DD 2A EF CD
 ld ix, (65535)         ;; 05FC:  DD 2A FF FF
 ld iy, (0)             ;; 0600:  FD 2A 00 00
 ld iy, (291)           ;; 0604:  FD 2A 23 01
 ld iy, (17767)         ;; 0608:  FD 2A 67 45
 ld iy, (35243)         ;; 060C:  FD 2A AB 89
 ld iy, (52719)         ;; 0610:  FD 2A EF CD
 ld iy, (65535)         ;; 0614:  FD 2A FF FF
 ld (0), hl             ;; 0618:  22 00 00
 ld (291), hl           ;; 061B:  22 23 01
 ld (17767), hl         ;; 061E:  22 67 45
 ld (35243), hl         ;; 0621:  22 AB 89
 ld (52719), hl         ;; 0624:  22 EF CD
 ld (65535), hl         ;; 0627:  22 FF FF
 ld (0), ix             ;; 062A:  DD 22 00 00
 ld (291), ix           ;; 062E:  DD 22 23 01
 ld (17767), ix         ;; 0632:  DD 22 67 45
 ld (35243), ix         ;; 0636:  DD 22 AB 89
 ld (52719), ix         ;; 063A:  DD 22 EF CD
 ld (65535), ix         ;; 063E:  DD 22 FF FF
 ld (0), iy             ;; 0642:  FD 22 00 00
 ld (291), iy           ;; 0646:  FD 22 23 01
 ld (17767), iy         ;; 064A:  FD 22 67 45
 ld (35243), iy         ;; 064E:  FD 22 AB 89
 ld (52719), iy         ;; 0652:  FD 22 EF CD
 ld (65535), iy         ;; 0656:  FD 22 FF FF
 ld bc, (0)             ;; 065A:  ED 4B 00 00
 ld bc, (291)           ;; 065E:  ED 4B 23 01
 ld bc, (17767)         ;; 0662:  ED 4B 67 45
 ld bc, (35243)         ;; 0666:  ED 4B AB 89
 ld bc, (52719)         ;; 066A:  ED 4B EF CD
 ld bc, (65535)         ;; 066E:  ED 4B FF FF
 ld de, (0)             ;; 0672:  ED 5B 00 00
 ld de, (291)           ;; 0676:  ED 5B 23 01
 ld de, (17767)         ;; 067A:  ED 5B 67 45
 ld de, (35243)         ;; 067E:  ED 5B AB 89
 ld de, (52719)         ;; 0682:  ED 5B EF CD
 ld de, (65535)         ;; 0686:  ED 5B FF FF
 ld sp, (0)             ;; 068A:  ED 7B 00 00
 ld sp, (291)           ;; 068E:  ED 7B 23 01
 ld sp, (17767)         ;; 0692:  ED 7B 67 45
 ld sp, (35243)         ;; 0696:  ED 7B AB 89
 ld sp, (52719)         ;; 069A:  ED 7B EF CD
 ld sp, (65535)         ;; 069E:  ED 7B FF FF
 ld (0), bc             ;; 06A2:  ED 43 00 00
 ld (291), bc           ;; 06A6:  ED 43 23 01
 ld (17767), bc         ;; 06AA:  ED 43 67 45
 ld (35243), bc         ;; 06AE:  ED 43 AB 89
 ld (52719), bc         ;; 06B2:  ED 43 EF CD
 ld (65535), bc         ;; 06B6:  ED 43 FF FF
 ld (0), de             ;; 06BA:  ED 53 00 00
 ld (291), de           ;; 06BE:  ED 53 23 01
 ld (17767), de         ;; 06C2:  ED 53 67 45
 ld (35243), de         ;; 06C6:  ED 53 AB 89
 ld (52719), de         ;; 06CA:  ED 53 EF CD
 ld (65535), de         ;; 06CE:  ED 53 FF FF
 ld (0), sp             ;; 06D2:  ED 73 00 00
 ld (291), sp           ;; 06D6:  ED 73 23 01
 ld (17767), sp         ;; 06DA:  ED 73 67 45
 ld (35243), sp         ;; 06DE:  ED 73 AB 89
 ld (52719), sp         ;; 06E2:  ED 73 EF CD
 ld (65535), sp         ;; 06E6:  ED 73 FF FF
 ld sp, hl              ;; 06EA:  F9
 ld sp, ix              ;; 06EB:  DD F9
 ld sp, iy              ;; 06ED:  FD F9
 push bc                ;; 06EF:  C5
 push de                ;; 06F0:  D5
 push hl                ;; 06F1:  E5
 push af                ;; 06F2:  F5
 push ix                ;; 06F3:  DD E5
 push iy                ;; 06F5:  FD E5
 pop bc                 ;; 06F7:  C1
 pop de                 ;; 06F8:  D1
 pop hl                 ;; 06F9:  E1
 pop af                 ;; 06FA:  F1
 pop ix                 ;; 06FB:  DD E1
 pop iy                 ;; 06FD:  FD E1
 add hl, bc             ;; 06FF:  09
 add hl, de             ;; 0700:  19
 add hl, hl             ;; 0701:  29
 add hl, sp             ;; 0702:  39
 add ix, bc             ;; 0703:  DD 09
 add ix, de             ;; 0705:  DD 19
 add ix, ix             ;; 0707:  DD 29
 add ix, sp             ;; 0709:  DD 39
 add iy, bc             ;; 070B:  FD 09
 add iy, de             ;; 070D:  FD 19
 add iy, iy             ;; 070F:  FD 29
 add iy, sp             ;; 0711:  FD 39
 sbc hl, bc             ;; 0713:  ED 42
 sbc hl, de             ;; 0715:  ED 52
 sbc hl, hl             ;; 0717:  ED 62
 sbc hl, sp             ;; 0719:  ED 72
 adc hl, bc             ;; 071B:  ED 4A
 adc hl, de             ;; 071D:  ED 5A
 adc hl, hl             ;; 071F:  ED 6A
 adc hl, sp             ;; 0721:  ED 7A
 inc bc                 ;; 0723:  03
 inc de                 ;; 0724:  13
 inc hl                 ;; 0725:  23
 inc sp                 ;; 0726:  33
 dec bc                 ;; 0727:  0B
 dec de                 ;; 0728:  1B
 dec hl                 ;; 0729:  2B
 dec sp                 ;; 072A:  3B
 inc ix                 ;; 072B:  DD 23
 dec ix                 ;; 072D:  DD 2B
 inc iy                 ;; 072F:  FD 23
 dec iy                 ;; 0731:  FD 2B
 ex af, af              ;; 0733:  08
 ex af, af'             ;; 0734:  08
 exx                    ;; 0735:  D9
 ex (sp), hl            ;; 0736:  E3
 ex (sp), ix            ;; 0737:  DD E3
 ex (sp), iy            ;; 0739:  FD E3
 ex de, hl              ;; 073B:  EB
 rlca                   ;; 073C:  07
 rrca                   ;; 073D:  0F
 rla                    ;; 073E:  17
 rra                    ;; 073F:  1F
 rlc b                  ;; 0740:  CB 00
 rlc c                  ;; 0742:  CB 01
 rlc d                  ;; 0744:  CB 02
 rlc e                  ;; 0746:  CB 03
 rlc h                  ;; 0748:  CB 04
 rlc l                  ;; 074A:  CB 05
 rlc (hl)               ;; 074C:  CB 06
 rlc a                  ;; 074E:  CB 07
 rrc b                  ;; 0750:  CB 08
 rrc c                  ;; 0752:  CB 09
 rrc d                  ;; 0754:  CB 0A
 rrc e                  ;; 0756:  CB 0B
 rrc h                  ;; 0758:  CB 0C
 rrc l                  ;; 075A:  CB 0D
 rrc (hl)               ;; 075C:  CB 0E
 rrc a                  ;; 075E:  CB 0F
 rl b                   ;; 0760:  CB 10
 rl c                   ;; 0762:  CB 11
 rl d                   ;; 0764:  CB 12
 rl e                   ;; 0766:  CB 13
 rl h                   ;; 0768:  CB 14
 rl l                   ;; 076A:  CB 15
 rl (hl)                ;; 076C:  CB 16
 rl a                   ;; 076E:  CB 17
 rr b                   ;; 0770:  CB 18
 rr c                   ;; 0772:  CB 19
 rr d                   ;; 0774:  CB 1A
 rr e                   ;; 0776:  CB 1B
 rr h                   ;; 0778:  CB 1C
 rr l                   ;; 077A:  CB 1D
 rr (hl)                ;; 077C:  CB 1E
 rr a                   ;; 077E:  CB 1F
 sla b                  ;; 0780:  CB 20
 sla c                  ;; 0782:  CB 21
 sla d                  ;; 0784:  CB 22
 sla e                  ;; 0786:  CB 23
 sla h                  ;; 0788:  CB 24
 sla l                  ;; 078A:  CB 25
 sla (hl)               ;; 078C:  CB 26
 sla a                  ;; 078E:  CB 27
 sra b                  ;; 0790:  CB 28
 sra c                  ;; 0792:  CB 29
 sra d                  ;; 0794:  CB 2A
 sra e                  ;; 0796:  CB 2B
 sra h                  ;; 0798:  CB 2C
 sra l                  ;; 079A:  CB 2D
 sra (hl)               ;; 079C:  CB 2E
 sra a                  ;; 079E:  CB 2F
 srl b                  ;; 07A0:  CB 38
 srl c                  ;; 07A2:  CB 39
 srl d                  ;; 07A4:  CB 3A
 srl e                  ;; 07A6:  CB 3B
 srl h                  ;; 07A8:  CB 3C
 srl l                  ;; 07AA:  CB 3D
 srl (hl)               ;; 07AC:  CB 3E
 srl a                  ;; 07AE:  CB 3F
 sll b                  ;; 07B0:  CB 30
 sll c                  ;; 07B2:  CB 31
 sll d                  ;; 07B4:  CB 32
 sll e                  ;; 07B6:  CB 33
 sll h                  ;; 07B8:  CB 34
 sll l                  ;; 07BA:  CB 35
 sll (hl)               ;; 07BC:  CB 36
 sll a                  ;; 07BE:  CB 37
 rlc (ix+-128)          ;; 07C0:  DD CB 80 06
 rlc (ix)               ;; 07C4:  DD CB 00 06
 rlc (ix+127)           ;; 07C8:  DD CB 7F 06
 rrc (ix+-128)          ;; 07CC:  DD CB 80 0E
 rrc (ix)               ;; 07D0:  DD CB 00 0E
 rrc (ix+127)           ;; 07D4:  DD CB 7F 0E
 rl (ix+-128)           ;; 07D8:  DD CB 80 16
 rl (ix)                ;; 07DC:  DD CB 00 16
 rl (ix+127)            ;; 07E0:  DD CB 7F 16
 rr (ix+-128)           ;; 07E4:  DD CB 80 1E
 rr (ix)                ;; 07E8:  DD CB 00 1E
 rr (ix+127)            ;; 07EC:  DD CB 7F 1E
 sla (ix+-128)          ;; 07F0:  DD CB 80 26
 sla (ix)               ;; 07F4:  DD CB 00 26
 sla (ix+127)           ;; 07F8:  DD CB 7F 26
 sra (ix+-128)          ;; 07FC:  DD CB 80 2E
 sra (ix)               ;; 0800:  DD CB 00 2E
 sra (ix+127)           ;; 0804:  DD CB 7F 2E
 srl (ix+-128)          ;; 0808:  DD CB 80 3E
 srl (ix)               ;; 080C:  DD CB 00 3E
 srl (ix+127)           ;; 0810:  DD CB 7F 3E
 sll (ix+-128)          ;; 0814:  DD CB 80 36
 sll (ix)               ;; 0818:  DD CB 00 36
 sll (ix+127)           ;; 081C:  DD CB 7F 36
 rlc (iy+-128)          ;; 0820:  FD CB 80 06
 rlc (iy)               ;; 0824:  FD CB 00 06
 rlc (iy+127)           ;; 0828:  FD CB 7F 06
 rrc (iy+-128)          ;; 082C:  FD CB 80 0E
 rrc (iy)               ;; 0830:  FD CB 00 0E
 rrc (iy+127)           ;; 0834:  FD CB 7F 0E
 rl (iy+-128)           ;; 0838:  FD CB 80 16
 rl (iy)                ;; 083C:  FD CB 00 16
 rl (iy+127)            ;; 0840:  FD CB 7F 16
 rr (iy+-128)           ;; 0844:  FD CB 80 1E
 rr (iy)                ;; 0848:  FD CB 00 1E
 rr (iy+127)            ;; 084C:  FD CB 7F 1E
 sla (iy+-128)          ;; 0850:  FD CB 80 26
 sla (iy)               ;; 0854:  FD CB 00 26
 sla (iy+127)           ;; 0858:  FD CB 7F 26
 sra (iy+-128)          ;; 085C:  FD CB 80 2E
 sra (iy)               ;; 0860:  FD CB 00 2E
 sra (iy+127)           ;; 0864:  FD CB 7F 2E
 srl (iy+-128)          ;; 0868:  FD CB 80 3E
 srl (iy)               ;; 086C:  FD CB 00 3E
 srl (iy+127)           ;; 0870:  FD CB 7F 3E
 sll (iy+-128)          ;; 0874:  FD CB 80 36
 sll (iy)               ;; 0878:  FD CB 00 36
 sll (iy+127)           ;; 087C:  FD CB 7F 36
 bit 0, b               ;; 0880:  CB 40
 bit 0, c               ;; 0882:  CB 41
 bit 0, d               ;; 0884:  CB 42
 bit 0, e               ;; 0886:  CB 43
 bit 0, h               ;; 0888:  CB 44
 bit 0, l               ;; 088A:  CB 45
 bit 0, (hl)            ;; 088C:  CB 46
 bit 0, a               ;; 088E:  CB 47
 bit 1, b               ;; 0890:  CB 48
 bit 1, c               ;; 0892:  CB 49
 bit 1, d               ;; 0894:  CB 4A
 bit 1, e               ;; 0896:  CB 4B
 bit 1, h               ;; 0898:  CB 4C
 bit 1, l               ;; 089A:  CB 4D
 bit 1, (hl)            ;; 089C:  CB 4E
 bit 1, a               ;; 089E:  CB 4F
 bit 2, b               ;; 08A0:  CB 50
 bit 2, c               ;; 08A2:  CB 51
 bit 2, d               ;; 08A4:  CB 52
 bit 2, e               ;; 08A6:  CB 53
 bit 2, h               ;; 08A8:  CB 54
 bit 2, l               ;; 08AA:  CB 55
 bit 2, (hl)            ;; 08AC:  CB 56
 bit 2, a               ;; 08AE:  CB 57
 bit 3, b               ;; 08B0:  CB 58
 bit 3, c               ;; 08B2:  CB 59
 bit 3, d               ;; 08B4:  CB 5A
 bit 3, e               ;; 08B6:  CB 5B
 bit 3, h               ;; 08B8:  CB 5C
 bit 3, l               ;; 08BA:  CB 5D
 bit 3, (hl)            ;; 08BC:  CB 5E
 bit 3, a               ;; 08BE:  CB 5F
 bit 4, b               ;; 08C0:  CB 60
 bit 4, c               ;; 08C2:  CB 61
 bit 4, d               ;; 08C4:  CB 62
 bit 4, e               ;; 08C6:  CB 63
 bit 4, h               ;; 08C8:  CB 64
 bit 4, l               ;; 08CA:  CB 65
 bit 4, (hl)            ;; 08CC:  CB 66
 bit 4, a               ;; 08CE:  CB 67
 bit 5, b               ;; 08D0:  CB 68
 bit 5, c               ;; 08D2:  CB 69
 bit 5, d               ;; 08D4:  CB 6A
 bit 5, e               ;; 08D6:  CB 6B
 bit 5, h               ;; 08D8:  CB 6C
 bit 5, l               ;; 08DA:  CB 6D
 bit 5, (hl)            ;; 08DC:  CB 6E
 bit 5, a               ;; 08DE:  CB 6F
 bit 6, b               ;; 08E0:  CB 70
 bit 6, c               ;; 08E2:  CB 71
 bit 6, d               ;; 08E4:  CB 72
 bit 6, e               ;; 08E6:  CB 73
 bit 6, h               ;; 08E8:  CB 74
 bit 6, l               ;; 08EA:  CB 75
 bit 6, (hl)            ;; 08EC:  CB 76
 bit 6, a               ;; 08EE:  CB 77
 bit 7, b               ;; 08F0:  CB 78
 bit 7, c               ;; 08F2:  CB 79
 bit 7, d               ;; 08F4:  CB 7A
 bit 7, e               ;; 08F6:  CB 7B
 bit 7, h               ;; 08F8:  CB 7C
 bit 7, l               ;; 08FA:  CB 7D
 bit 7, (hl)            ;; 08FC:  CB 7E
 bit 7, a               ;; 08FE:  CB 7F
 res 0, b               ;; 0900:  CB 80
 res 0, c               ;; 0902:  CB 81
 res 0, d               ;; 0904:  CB 82
 res 0, e               ;; 0906:  CB 83
 res 0, h               ;; 0908:  CB 84
 res 0, l               ;; 090A:  CB 85
 res 0, (hl)            ;; 090C:  CB 86
 res 0, a               ;; 090E:  CB 87
 res 1, b               ;; 0910:  CB 88
 res 1, c               ;; 0912:  CB 89
 res 1, d               ;; 0914:  CB 8A
 res 1, e               ;; 0916:  CB 8B
 res 1, h               ;; 0918:  CB 8C
 res 1, l               ;; 091A:  CB 8D
 res 1, (hl)            ;; 091C:  CB 8E
 res 1, a               ;; 091E:  CB 8F
 res 2, b               ;; 0920:  CB 90
 res 2, c               ;; 0922:  CB 91
 res 2, d               ;; 0924:  CB 92
 res 2, e               ;; 0926:  CB 93
 res 2, h               ;; 0928:  CB 94
 res 2, l               ;; 092A:  CB 95
 res 2, (hl)            ;; 092C:  CB 96
 res 2, a               ;; 092E:  CB 97
 res 3, b               ;; 0930:  CB 98
 res 3, c               ;; 0932:  CB 99
 res 3, d               ;; 0934:  CB 9A
 res 3, e               ;; 0936:  CB 9B
 res 3, h               ;; 0938:  CB 9C
 res 3, l               ;; 093A:  CB 9D
 res 3, (hl)            ;; 093C:  CB 9E
 res 3, a               ;; 093E:  CB 9F
 res 4, b               ;; 0940:  CB A0
 res 4, c               ;; 0942:  CB A1
 res 4, d               ;; 0944:  CB A2
 res 4, e               ;; 0946:  CB A3
 res 4, h               ;; 0948:  CB A4
 res 4, l               ;; 094A:  CB A5
 res 4, (hl)            ;; 094C:  CB A6
 res 4, a               ;; 094E:  CB A7
 res 5, b               ;; 0950:  CB A8
 res 5, c               ;; 0952:  CB A9
 res 5, d               ;; 0954:  CB AA
 res 5, e               ;; 0956:  CB AB
 res 5, h               ;; 0958:  CB AC
 res 5, l               ;; 095A:  CB AD
 res 5, (hl)            ;; 095C:  CB AE
 res 5, a               ;; 095E:  CB AF
 res 6, b               ;; 0960:  CB B0
 res 6, c               ;; 0962:  CB B1
 res 6, d               ;; 0964:  CB B2
 res 6, e               ;; 0966:  CB B3
 res 6, h               ;; 0968:  CB B4
 res 6, l               ;; 096A:  CB B5
 res 6, (hl)            ;; 096C:  CB B6
 res 6, a               ;; 096E:  CB B7
 res 7, b               ;; 0970:  CB B8
 res 7, c               ;; 0972:  CB B9
 res 7, d               ;; 0974:  CB BA
 res 7, e               ;; 0976:  CB BB
 res 7, h               ;; 0978:  CB BC
 res 7, l               ;; 097A:  CB BD
 res 7, (hl)            ;; 097C:  CB BE
 res 7, a               ;; 097E:  CB BF
 set 0, b               ;; 0980:  CB C0
 set 0, c               ;; 0982:  CB C1
 set 0, d               ;; 0984:  CB C2
 set 0, e               ;; 0986:  CB C3
 set 0, h               ;; 0988:  CB C4
 set 0, l               ;; 098A:  CB C5
 set 0, (hl)            ;; 098C:  CB C6
 set 0, a               ;; 098E:  CB C7
 set 1, b               ;; 0990:  CB C8
 set 1, c               ;; 0992:  CB C9
 set 1, d               ;; 0994:  CB CA
 set 1, e               ;; 0996:  CB CB
 set 1, h               ;; 0998:  CB CC
 set 1, l               ;; 099A:  CB CD
 set 1, (hl)            ;; 099C:  CB CE
 set 1, a               ;; 099E:  CB CF
 set 2, b               ;; 09A0:  CB D0
 set 2, c               ;; 09A2:  CB D1
 set 2, d               ;; 09A4:  CB D2
 set 2, e               ;; 09A6:  CB D3
 set 2, h               ;; 09A8:  CB D4
 set 2, l               ;; 09AA:  CB D5
 set 2, (hl)            ;; 09AC:  CB D6
 set 2, a               ;; 09AE:  CB D7
 set 3, b               ;; 09B0:  CB D8
 set 3, c               ;; 09B2:  CB D9
 set 3, d               ;; 09B4:  CB DA
 set 3, e               ;; 09B6:  CB DB
 set 3, h               ;; 09B8:  CB DC
 set 3, l               ;; 09BA:  CB DD
 set 3, (hl)            ;; 09BC:  CB DE
 set 3, a               ;; 09BE:  CB DF
 set 4, b               ;; 09C0:  CB E0
 set 4, c               ;; 09C2:  CB E1
 set 4, d               ;; 09C4:  CB E2
 set 4, e               ;; 09C6:  CB E3
 set 4, h               ;; 09C8:  CB E4
 set 4, l               ;; 09CA:  CB E5
 set 4, (hl)            ;; 09CC:  CB E6
 set 4, a               ;; 09CE:  CB E7
 set 5, b               ;; 09D0:  CB E8
 set 5, c               ;; 09D2:  CB E9
 set 5, d               ;; 09D4:  CB EA
 set 5, e               ;; 09D6:  CB EB
 set 5, h               ;; 09D8:  CB EC
 set 5, l               ;; 09DA:  CB ED
 set 5, (hl)            ;; 09DC:  CB EE
 set 5, a               ;; 09DE:  CB EF
 set 6, b               ;; 09E0:  CB F0
 set 6, c               ;; 09E2:  CB F1
 set 6, d               ;; 09E4:  CB F2
 set 6, e               ;; 09E6:  CB F3
 set 6, h               ;; 09E8:  CB F4
 set 6, l               ;; 09EA:  CB F5
 set 6, (hl)            ;; 09EC:  CB F6
 set 6, a               ;; 09EE:  CB F7
 set 7, b               ;; 09F0:  CB F8
 set 7, c               ;; 09F2:  CB F9
 set 7, d               ;; 09F4:  CB FA
 set 7, e               ;; 09F6:  CB FB
 set 7, h               ;; 09F8:  CB FC
 set 7, l               ;; 09FA:  CB FD
 set 7, (hl)            ;; 09FC:  CB FE
 set 7, a               ;; 09FE:  CB FF
 bit 0, (ix+-128)       ;; 0A00:  DD CB 80 46
 bit 0, (ix)            ;; 0A04:  DD CB 00 46
 bit 0, (ix+127)        ;; 0A08:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 0A0C:  DD CB 80 4E
 bit 1, (ix)            ;; 0A10:  DD CB 00 4E
 bit 1, (ix+127)        ;; 0A14:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 0A18:  DD CB 80 56
 bit 2, (ix)            ;; 0A1C:  DD CB 00 56
 bit 2, (ix+127)        ;; 0A20:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 0A24:  DD CB 80 5E
 bit 3, (ix)            ;; 0A28:  DD CB 00 5E
 bit 3, (ix+127)        ;; 0A2C:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 0A30:  DD CB 80 66
 bit 4, (ix)            ;; 0A34:  DD CB 00 66
 bit 4, (ix+127)        ;; 0A38:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 0A3C:  DD CB 80 6E
 bit 5, (ix)            ;; 0A40:  DD CB 00 6E
 bit 5, (ix+127)        ;; 0A44:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 0A48:  DD CB 80 76
 bit 6, (ix)            ;; 0A4C:  DD CB 00 76
 bit 6, (ix+127)        ;; 0A50:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 0A54:  DD CB 80 7E
 bit 7, (ix)            ;; 0A58:  DD CB 00 7E
 bit 7, (ix+127)        ;; 0A5C:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 0A60:  DD CB 80 86
 res 0, (ix)            ;; 0A64:  DD CB 00 86
 res 0, (ix+127)        ;; 0A68:  DD CB 7F 86
 res 1, (ix+-128)       ;; 0A6C:  DD CB 80 8E
 res 1, (ix)            ;; 0A70:  DD CB 00 8E
 res 1, (ix+127)        ;; 0A74:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 0A78:  DD CB 80 96
 res 2, (ix)            ;; 0A7C:  DD CB 00 96
 res 2, (ix+127)        ;; 0A80:  DD CB 7F 96
 res 3, (ix+-128)       ;; 0A84:  DD CB 80 9E
 res 3, (ix)            ;; 0A88:  DD CB 00 9E
 res 3, (ix+127)        ;; 0A8C:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 0A90:  DD CB 80 A6
 res 4, (ix)            ;; 0A94:  DD CB 00 A6
 res 4, (ix+127)        ;; 0A98:  DD CB 7F A6
 res 5, (ix+-128)       ;; 0A9C:  DD CB 80 AE
 res 5, (ix)            ;; 0AA0:  DD CB 00 AE
 res 5, (ix+127)        ;; 0AA4:  DD CB 7F AE
 res 6, (ix+-128)       ;; 0AA8:  DD CB 80 B6
 res 6, (ix)            ;; 0AAC:  DD CB 00 B6
 res 6, (ix+127)        ;; 0AB0:  DD CB 7F B6
 res 7, (ix+-128)       ;; 0AB4:  DD CB 80 BE
 res 7, (ix)            ;; 0AB8:  DD CB 00 BE
 res 7, (ix+127)        ;; 0ABC:  DD CB 7F BE
 set 0, (ix+-128)       ;; 0AC0:  DD CB 80 C6
 set 0, (ix)            ;; 0AC4:  DD CB 00 C6
 set 0, (ix+127)        ;; 0AC8:  DD CB 7F C6
 set 1, (ix+-128)       ;; 0ACC:  DD CB 80 CE
 set 1, (ix)            ;; 0AD0:  DD CB 00 CE
 set 1, (ix+127)        ;; 0AD4:  DD CB 7F CE
 set 2, (ix+-128)       ;; 0AD8:  DD CB 80 D6
 set 2, (ix)            ;; 0ADC:  DD CB 00 D6
 set 2, (ix+127)        ;; 0AE0:  DD CB 7F D6
 set 3, (ix+-128)       ;; 0AE4:  DD CB 80 DE
 set 3, (ix)            ;; 0AE8:  DD CB 00 DE
 set 3, (ix+127)        ;; 0AEC:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0AF0:  DD CB 80 E6
 set 4, (ix)            ;; 0AF4:  DD CB 00 E6
 set 4, (ix+127)        ;; 0AF8:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0AFC:  DD CB 80 EE
 set 5, (ix)            ;; 0B00:  DD CB 00 EE
 set 5, (ix+127)        ;; 0B04:  DD CB 7F EE
 set 6, (ix+-128)       ;; 0B08:  DD CB 80 F6
 set 6, (ix)            ;; 0B0C:  DD CB 00 F6
 set 6, (ix+127)        ;; 0B10:  DD CB 7F F6
 set 7, (ix+-128)       ;; 0B14:  DD CB 80 FE
 set 7, (ix)            ;; 0B18:  DD CB 00 FE
 set 7, (ix+127)        ;; 0B1C:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 0B20:  FD CB 80 46
 bit 0, (iy)            ;; 0B24:  FD CB 00 46
 bit 0, (iy+127)        ;; 0B28:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 0B2C:  FD CB 80 4E
 bit 1, (iy)            ;; 0B30:  FD CB 00 4E
 bit 1, (iy+127)        ;; 0B34:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 0B38:  FD CB 80 56
 bit 2, (iy)            ;; 0B3C:  FD CB 00 56
 bit 2, (iy+127)        ;; 0B40:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 0B44:  FD CB 80 5E
 bit 3, (iy)            ;; 0B48:  FD CB 00 5E
 bit 3, (iy+127)        ;; 0B4C:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 0B50:  FD CB 80 66
 bit 4, (iy)            ;; 0B54:  FD CB 00 66
 bit 4, (iy+127)        ;; 0B58:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 0B5C:  FD CB 80 6E
 bit 5, (iy)            ;; 0B60:  FD CB 00 6E
 bit 5, (iy+127)        ;; 0B64:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 0B68:  FD CB 80 76
 bit 6, (iy)            ;; 0B6C:  FD CB 00 76
 bit 6, (iy+127)        ;; 0B70:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 0B74:  FD CB 80 7E
 bit 7, (iy)            ;; 0B78:  FD CB 00 7E
 bit 7, (iy+127)        ;; 0B7C:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 0B80:  FD CB 80 86
 res 0, (iy)            ;; 0B84:  FD CB 00 86
 res 0, (iy+127)        ;; 0B88:  FD CB 7F 86
 res 1, (iy+-128)       ;; 0B8C:  FD CB 80 8E
 res 1, (iy)            ;; 0B90:  FD CB 00 8E
 res 1, (iy+127)        ;; 0B94:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 0B98:  FD CB 80 96
 res 2, (iy)            ;; 0B9C:  FD CB 00 96
 res 2, (iy+127)        ;; 0BA0:  FD CB 7F 96
 res 3, (iy+-128)       ;; 0BA4:  FD CB 80 9E
 res 3, (iy)            ;; 0BA8:  FD CB 00 9E
 res 3, (iy+127)        ;; 0BAC:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 0BB0:  FD CB 80 A6
 res 4, (iy)            ;; 0BB4:  FD CB 00 A6
 res 4, (iy+127)        ;; 0BB8:  FD CB 7F A6
 res 5, (iy+-128)       ;; 0BBC:  FD CB 80 AE
 res 5, (iy)            ;; 0BC0:  FD CB 00 AE
 res 5, (iy+127)        ;; 0BC4:  FD CB 7F AE
 res 6, (iy+-128)       ;; 0BC8:  FD CB 80 B6
 res 6, (iy)            ;; 0BCC:  FD CB 00 B6
 res 6, (iy+127)        ;; 0BD0:  FD CB 7F B6
 res 7, (iy+-128)       ;; 0BD4:  FD CB 80 BE
 res 7, (iy)            ;; 0BD8:  FD CB 00 BE
 res 7, (iy+127)        ;; 0BDC:  FD CB 7F BE
 set 0, (iy+-128)       ;; 0BE0:  FD CB 80 C6
 set 0, (iy)            ;; 0BE4:  FD CB 00 C6
 set 0, (iy+127)        ;; 0BE8:  FD CB 7F C6
 set 1, (iy+-128)       ;; 0BEC:  FD CB 80 CE
 set 1, (iy)            ;; 0BF0:  FD CB 00 CE
 set 1, (iy+127)        ;; 0BF4:  FD CB 7F CE
 set 2, (iy+-128)       ;; 0BF8:  FD CB 80 D6
 set 2, (iy)            ;; 0BFC:  FD CB 00 D6
 set 2, (iy+127)        ;; 0C00:  FD CB 7F D6
 set 3, (iy+-128)       ;; 0C04:  FD CB 80 DE
 set 3, (iy)            ;; 0C08:  FD CB 00 DE
 set 3, (iy+127)        ;; 0C0C:  FD CB 7F DE
 set 4, (iy+-128)       ;; 0C10:  FD CB 80 E6
 set 4, (iy)            ;; 0C14:  FD CB 00 E6
 set 4, (iy+127)        ;; 0C18:  FD CB 7F E6
 set 5, (iy+-128)       ;; 0C1C:  FD CB 80 EE
 set 5, (iy)            ;; 0C20:  FD CB 00 EE
 set 5, (iy+127)        ;; 0C24:  FD CB 7F EE
 set 6, (iy+-128)       ;; 0C28:  FD CB 80 F6
 set 6, (iy)            ;; 0C2C:  FD CB 00 F6
 set 6, (iy+127)        ;; 0C30:  FD CB 7F F6
 set 7, (iy+-128)       ;; 0C34:  FD CB 80 FE
 set 7, (iy)            ;; 0C38:  FD CB 00 FE
 set 7, (iy+127)        ;; 0C3C:  FD CB 7F FE
 ldi                    ;; 0C40:  ED A0
 ldir                   ;; 0C42:  ED B0
 ldd                    ;; 0C44:  ED A8
 lddr                   ;; 0C46:  ED B8
 cpi                    ;; 0C48:  ED A1
 cpir                   ;; 0C4A:  ED B1
 cpd                    ;; 0C4C:  ED A9
 cpdr                   ;; 0C4E:  ED B9
 nop                    ;; 0C50:  00
 halt                   ;; 0C51:  76
 jp 0                   ;; 0C52:  C3 00 00
 jp 291                 ;; 0C55:  C3 23 01
 jp 17767               ;; 0C58:  C3 67 45
 jp 35243               ;; 0C5B:  C3 AB 89
 jp 52719               ;; 0C5E:  C3 EF CD
 jp 65535               ;; 0C61:  C3 FF FF
 jp nz, 0               ;; 0C64:  C2 00 00
 jp nz, 291             ;; 0C67:  C2 23 01
 jp nz, 17767           ;; 0C6A:  C2 67 45
 jp nz, 35243           ;; 0C6D:  C2 AB 89
 jp nz, 52719           ;; 0C70:  C2 EF CD
 jp nz, 65535           ;; 0C73:  C2 FF FF
 jp z, 0                ;; 0C76:  CA 00 00
 jp z, 291              ;; 0C79:  CA 23 01
 jp z, 17767            ;; 0C7C:  CA 67 45
 jp z, 35243            ;; 0C7F:  CA AB 89
 jp z, 52719            ;; 0C82:  CA EF CD
 jp z, 65535            ;; 0C85:  CA FF FF
 jp nc, 0               ;; 0C88:  D2 00 00
 jp nc, 291             ;; 0C8B:  D2 23 01
 jp nc, 17767           ;; 0C8E:  D2 67 45
 jp nc, 35243           ;; 0C91:  D2 AB 89
 jp nc, 52719           ;; 0C94:  D2 EF CD
 jp nc, 65535           ;; 0C97:  D2 FF FF
 jp c, 0                ;; 0C9A:  DA 00 00
 jp c, 291              ;; 0C9D:  DA 23 01
 jp c, 17767            ;; 0CA0:  DA 67 45
 jp c, 35243            ;; 0CA3:  DA AB 89
 jp c, 52719            ;; 0CA6:  DA EF CD
 jp c, 65535            ;; 0CA9:  DA FF FF
 jp po, 0               ;; 0CAC:  E2 00 00
 jp po, 291             ;; 0CAF:  E2 23 01
 jp po, 17767           ;; 0CB2:  E2 67 45
 jp po, 35243           ;; 0CB5:  E2 AB 89
 jp po, 52719           ;; 0CB8:  E2 EF CD
 jp po, 65535           ;; 0CBB:  E2 FF FF
 jp pe, 0               ;; 0CBE:  EA 00 00
 jp pe, 291             ;; 0CC1:  EA 23 01
 jp pe, 17767           ;; 0CC4:  EA 67 45
 jp pe, 35243           ;; 0CC7:  EA AB 89
 jp pe, 52719           ;; 0CCA:  EA EF CD
 jp pe, 65535           ;; 0CCD:  EA FF FF
 jp p, 0                ;; 0CD0:  F2 00 00
 jp p, 291              ;; 0CD3:  F2 23 01
 jp p, 17767            ;; 0CD6:  F2 67 45
 jp p, 35243            ;; 0CD9:  F2 AB 89
 jp p, 52719            ;; 0CDC:  F2 EF CD
 jp p, 65535            ;; 0CDF:  F2 FF FF
 jp m, 0                ;; 0CE2:  FA 00 00
 jp m, 291              ;; 0CE5:  FA 23 01
 jp m, 17767            ;; 0CE8:  FA 67 45
 jp m, 35243            ;; 0CEB:  FA AB 89
 jp m, 52719            ;; 0CEE:  FA EF CD
 jp m, 65535            ;; 0CF1:  FA FF FF
 jp (hl)                ;; 0CF4:  E9
 jp (ix)                ;; 0CF5:  DD E9
 jp (iy)                ;; 0CF7:  FD E9
 djnz ASMPC             ;; 0CF9:  10 FE
 djnz b, ASMPC          ;; 0CFB:  10 FE
 jr ASMPC               ;; 0CFD:  18 FE
 jr nz, ASMPC           ;; 0CFF:  20 FE
 jr z, ASMPC            ;; 0D01:  28 FE
 jr nc, ASMPC           ;; 0D03:  30 FE
 jr c, ASMPC            ;; 0D05:  38 FE
 call 0                 ;; 0D07:  CD 00 00
 call 291               ;; 0D0A:  CD 23 01
 call 17767             ;; 0D0D:  CD 67 45
 call 35243             ;; 0D10:  CD AB 89
 call 52719             ;; 0D13:  CD EF CD
 call 65535             ;; 0D16:  CD FF FF
 call nz, 0             ;; 0D19:  C4 00 00
 call nz, 291           ;; 0D1C:  C4 23 01
 call nz, 17767         ;; 0D1F:  C4 67 45
 call nz, 35243         ;; 0D22:  C4 AB 89
 call nz, 52719         ;; 0D25:  C4 EF CD
 call nz, 65535         ;; 0D28:  C4 FF FF
 call z, 0              ;; 0D2B:  CC 00 00
 call z, 291            ;; 0D2E:  CC 23 01
 call z, 17767          ;; 0D31:  CC 67 45
 call z, 35243          ;; 0D34:  CC AB 89
 call z, 52719          ;; 0D37:  CC EF CD
 call z, 65535          ;; 0D3A:  CC FF FF
 call nc, 0             ;; 0D3D:  D4 00 00
 call nc, 291           ;; 0D40:  D4 23 01
 call nc, 17767         ;; 0D43:  D4 67 45
 call nc, 35243         ;; 0D46:  D4 AB 89
 call nc, 52719         ;; 0D49:  D4 EF CD
 call nc, 65535         ;; 0D4C:  D4 FF FF
 call c, 0              ;; 0D4F:  DC 00 00
 call c, 291            ;; 0D52:  DC 23 01
 call c, 17767          ;; 0D55:  DC 67 45
 call c, 35243          ;; 0D58:  DC AB 89
 call c, 52719          ;; 0D5B:  DC EF CD
 call c, 65535          ;; 0D5E:  DC FF FF
 call po, 0             ;; 0D61:  E4 00 00
 call po, 291           ;; 0D64:  E4 23 01
 call po, 17767         ;; 0D67:  E4 67 45
 call po, 35243         ;; 0D6A:  E4 AB 89
 call po, 52719         ;; 0D6D:  E4 EF CD
 call po, 65535         ;; 0D70:  E4 FF FF
 call pe, 0             ;; 0D73:  EC 00 00
 call pe, 291           ;; 0D76:  EC 23 01
 call pe, 17767         ;; 0D79:  EC 67 45
 call pe, 35243         ;; 0D7C:  EC AB 89
 call pe, 52719         ;; 0D7F:  EC EF CD
 call pe, 65535         ;; 0D82:  EC FF FF
 call p, 0              ;; 0D85:  F4 00 00
 call p, 291            ;; 0D88:  F4 23 01
 call p, 17767          ;; 0D8B:  F4 67 45
 call p, 35243          ;; 0D8E:  F4 AB 89
 call p, 52719          ;; 0D91:  F4 EF CD
 call p, 65535          ;; 0D94:  F4 FF FF
 call m, 0              ;; 0D97:  FC 00 00
 call m, 291            ;; 0D9A:  FC 23 01
 call m, 17767          ;; 0D9D:  FC 67 45
 call m, 35243          ;; 0DA0:  FC AB 89
 call m, 52719          ;; 0DA3:  FC EF CD
 call m, 65535          ;; 0DA6:  FC FF FF
 ret                    ;; 0DA9:  C9
 ret nz                 ;; 0DAA:  C0
 ret z                  ;; 0DAB:  C8
 ret nc                 ;; 0DAC:  D0
 ret c                  ;; 0DAD:  D8
 ret po                 ;; 0DAE:  E0
 ret pe                 ;; 0DAF:  E8
 ret p                  ;; 0DB0:  F0
 ret m                  ;; 0DB1:  F8
 rst 16                 ;; 0DB2:  D7
 rst 24                 ;; 0DB3:  DF
 rst 32                 ;; 0DB4:  E7
 rst 40                 ;; 0DB5:  EF
 rst 56                 ;; 0DB6:  FF
 rst 0                  ;; 0DB7:  C7
 rst 8                  ;; 0DB8:  CF
 rst 48                 ;; 0DB9:  F7
 in a, (0)              ;; 0DBA:  DB 00
 in a, (85)             ;; 0DBC:  DB 55
 in a, (170)            ;; 0DBE:  DB AA
 in a, (255)            ;; 0DC0:  DB FF
 in b, (c)              ;; 0DC2:  ED 40
 in c, (c)              ;; 0DC4:  ED 48
 in d, (c)              ;; 0DC6:  ED 50
 in e, (c)              ;; 0DC8:  ED 58
 in h, (c)              ;; 0DCA:  ED 60
 in l, (c)              ;; 0DCC:  ED 68
 in f, (c)              ;; 0DCE:  ED 70
 in a, (c)              ;; 0DD0:  ED 78
 out (0), a             ;; 0DD2:  D3 00
 out (85), a            ;; 0DD4:  D3 55
 out (170), a           ;; 0DD6:  D3 AA
 out (255), a           ;; 0DD8:  D3 FF
 out (c), b             ;; 0DDA:  ED 41
 out (c), c             ;; 0DDC:  ED 49
 out (c), d             ;; 0DDE:  ED 51
 out (c), e             ;; 0DE0:  ED 59
 out (c), h             ;; 0DE2:  ED 61
 out (c), l             ;; 0DE4:  ED 69
 out (c), 0             ;; 0DE6:  ED 71
 out (c), a             ;; 0DE8:  ED 79
 ini                    ;; 0DEA:  ED A2
 inir                   ;; 0DEC:  ED B2
 ind                    ;; 0DEE:  ED AA
 indr                   ;; 0DF0:  ED BA
 outi                   ;; 0DF2:  ED A3
 otir                   ;; 0DF4:  ED B3
 outd                   ;; 0DF6:  ED AB
 otdr                   ;; 0DF8:  ED BB
 di                     ;; 0DFA:  F3
 ei                     ;; 0DFB:  FB
 im 0                   ;; 0DFC:  ED 46
 im 1                   ;; 0DFE:  ED 56
 im 2                   ;; 0E00:  ED 5E
 ld i, a                ;; 0E02:  ED 47
 ld a, i                ;; 0E04:  ED 57
 ld r, a                ;; 0E06:  ED 4F
 ld a, r                ;; 0E08:  ED 5F
 reti                   ;; 0E0A:  ED 4D
 retn                   ;; 0E0C:  ED 45
