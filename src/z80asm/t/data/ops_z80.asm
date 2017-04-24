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
 ld b, (ix + 0)         ;; 00DB:  DD 46 00
 ld b, (ix + 127)       ;; 00DE:  DD 46 7F
 ld c, (ix + -128)      ;; 00E1:  DD 4E 80
 ld c, (ix + 0)         ;; 00E4:  DD 4E 00
 ld c, (ix + 127)       ;; 00E7:  DD 4E 7F
 ld d, (ix + -128)      ;; 00EA:  DD 56 80
 ld d, (ix + 0)         ;; 00ED:  DD 56 00
 ld d, (ix + 127)       ;; 00F0:  DD 56 7F
 ld e, (ix + -128)      ;; 00F3:  DD 5E 80
 ld e, (ix + 0)         ;; 00F6:  DD 5E 00
 ld e, (ix + 127)       ;; 00F9:  DD 5E 7F
 ld h, (ix + -128)      ;; 00FC:  DD 66 80
 ld h, (ix + 0)         ;; 00FF:  DD 66 00
 ld h, (ix + 127)       ;; 0102:  DD 66 7F
 ld l, (ix + -128)      ;; 0105:  DD 6E 80
 ld l, (ix + 0)         ;; 0108:  DD 6E 00
 ld l, (ix + 127)       ;; 010B:  DD 6E 7F
 ld a, (ix + -128)      ;; 010E:  DD 7E 80
 ld a, (ix + 0)         ;; 0111:  DD 7E 00
 ld a, (ix + 127)       ;; 0114:  DD 7E 7F
 ld b, (iy + -128)      ;; 0117:  FD 46 80
 ld b, (iy + 0)         ;; 011A:  FD 46 00
 ld b, (iy + 127)       ;; 011D:  FD 46 7F
 ld c, (iy + -128)      ;; 0120:  FD 4E 80
 ld c, (iy + 0)         ;; 0123:  FD 4E 00
 ld c, (iy + 127)       ;; 0126:  FD 4E 7F
 ld d, (iy + -128)      ;; 0129:  FD 56 80
 ld d, (iy + 0)         ;; 012C:  FD 56 00
 ld d, (iy + 127)       ;; 012F:  FD 56 7F
 ld e, (iy + -128)      ;; 0132:  FD 5E 80
 ld e, (iy + 0)         ;; 0135:  FD 5E 00
 ld e, (iy + 127)       ;; 0138:  FD 5E 7F
 ld h, (iy + -128)      ;; 013B:  FD 66 80
 ld h, (iy + 0)         ;; 013E:  FD 66 00
 ld h, (iy + 127)       ;; 0141:  FD 66 7F
 ld l, (iy + -128)      ;; 0144:  FD 6E 80
 ld l, (iy + 0)         ;; 0147:  FD 6E 00
 ld l, (iy + 127)       ;; 014A:  FD 6E 7F
 ld a, (iy + -128)      ;; 014D:  FD 7E 80
 ld a, (iy + 0)         ;; 0150:  FD 7E 00
 ld a, (iy + 127)       ;; 0153:  FD 7E 7F
 ld (hl), b             ;; 0156:  70
 ld (hl), c             ;; 0157:  71
 ld (hl), d             ;; 0158:  72
 ld (hl), e             ;; 0159:  73
 ld (hl), h             ;; 015A:  74
 ld (hl), l             ;; 015B:  75
 ld (hl), a             ;; 015C:  77
 ld (ix + -128), b      ;; 015D:  DD 70 80
 ld (ix + 0), b         ;; 0160:  DD 70 00
 ld (ix + 127), b       ;; 0163:  DD 70 7F
 ld (ix + -128), c      ;; 0166:  DD 71 80
 ld (ix + 0), c         ;; 0169:  DD 71 00
 ld (ix + 127), c       ;; 016C:  DD 71 7F
 ld (ix + -128), d      ;; 016F:  DD 72 80
 ld (ix + 0), d         ;; 0172:  DD 72 00
 ld (ix + 127), d       ;; 0175:  DD 72 7F
 ld (ix + -128), e      ;; 0178:  DD 73 80
 ld (ix + 0), e         ;; 017B:  DD 73 00
 ld (ix + 127), e       ;; 017E:  DD 73 7F
 ld (ix + -128), h      ;; 0181:  DD 74 80
 ld (ix + 0), h         ;; 0184:  DD 74 00
 ld (ix + 127), h       ;; 0187:  DD 74 7F
 ld (ix + -128), l      ;; 018A:  DD 75 80
 ld (ix + 0), l         ;; 018D:  DD 75 00
 ld (ix + 127), l       ;; 0190:  DD 75 7F
 ld (ix + -128), a      ;; 0193:  DD 77 80
 ld (ix + 0), a         ;; 0196:  DD 77 00
 ld (ix + 127), a       ;; 0199:  DD 77 7F
 ld (iy + -128), b      ;; 019C:  FD 70 80
 ld (iy + 0), b         ;; 019F:  FD 70 00
 ld (iy + 127), b       ;; 01A2:  FD 70 7F
 ld (iy + -128), c      ;; 01A5:  FD 71 80
 ld (iy + 0), c         ;; 01A8:  FD 71 00
 ld (iy + 127), c       ;; 01AB:  FD 71 7F
 ld (iy + -128), d      ;; 01AE:  FD 72 80
 ld (iy + 0), d         ;; 01B1:  FD 72 00
 ld (iy + 127), d       ;; 01B4:  FD 72 7F
 ld (iy + -128), e      ;; 01B7:  FD 73 80
 ld (iy + 0), e         ;; 01BA:  FD 73 00
 ld (iy + 127), e       ;; 01BD:  FD 73 7F
 ld (iy + -128), h      ;; 01C0:  FD 74 80
 ld (iy + 0), h         ;; 01C3:  FD 74 00
 ld (iy + 127), h       ;; 01C6:  FD 74 7F
 ld (iy + -128), l      ;; 01C9:  FD 75 80
 ld (iy + 0), l         ;; 01CC:  FD 75 00
 ld (iy + 127), l       ;; 01CF:  FD 75 7F
 ld (iy + -128), a      ;; 01D2:  FD 77 80
 ld (iy + 0), a         ;; 01D5:  FD 77 00
 ld (iy + 127), a       ;; 01D8:  FD 77 7F
 ld (hl), 0             ;; 01DB:  36 00
 ld (hl), 85            ;; 01DD:  36 55
 ld (hl), 170           ;; 01DF:  36 AA
 ld (hl), 255           ;; 01E1:  36 FF
 ld (ix + -128), 0      ;; 01E3:  DD 36 80 00
 ld (ix + 0), 0         ;; 01E7:  DD 36 00 00
 ld (ix + 127), 0       ;; 01EB:  DD 36 7F 00
 ld (ix + -128), 85     ;; 01EF:  DD 36 80 55
 ld (ix + 0), 85        ;; 01F3:  DD 36 00 55
 ld (ix + 127), 85      ;; 01F7:  DD 36 7F 55
 ld (ix + -128), 170    ;; 01FB:  DD 36 80 AA
 ld (ix + 0), 170       ;; 01FF:  DD 36 00 AA
 ld (ix + 127), 170     ;; 0203:  DD 36 7F AA
 ld (ix + -128), 255    ;; 0207:  DD 36 80 FF
 ld (ix + 0), 255       ;; 020B:  DD 36 00 FF
 ld (ix + 127), 255     ;; 020F:  DD 36 7F FF
 ld (iy + -128), 0      ;; 0213:  FD 36 80 00
 ld (iy + 0), 0         ;; 0217:  FD 36 00 00
 ld (iy + 127), 0       ;; 021B:  FD 36 7F 00
 ld (iy + -128), 85     ;; 021F:  FD 36 80 55
 ld (iy + 0), 85        ;; 0223:  FD 36 00 55
 ld (iy + 127), 85      ;; 0227:  FD 36 7F 55
 ld (iy + -128), 170    ;; 022B:  FD 36 80 AA
 ld (iy + 0), 170       ;; 022F:  FD 36 00 AA
 ld (iy + 127), 170     ;; 0233:  FD 36 7F AA
 ld (iy + -128), 255    ;; 0237:  FD 36 80 FF
 ld (iy + 0), 255       ;; 023B:  FD 36 00 FF
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
 add a, (ix+0)          ;; 02EE:  DD 86 00
 add a, (ix+127)        ;; 02F1:  DD 86 7F
 adc a, (ix+-128)       ;; 02F4:  DD 8E 80
 adc a, (ix+0)          ;; 02F7:  DD 8E 00
 adc a, (ix+127)        ;; 02FA:  DD 8E 7F
 sub a, (ix+-128)       ;; 02FD:  DD 96 80
 sub a, (ix+0)          ;; 0300:  DD 96 00
 sub a, (ix+127)        ;; 0303:  DD 96 7F
 sbc a, (ix+-128)       ;; 0306:  DD 9E 80
 sbc a, (ix+0)          ;; 0309:  DD 9E 00
 sbc a, (ix+127)        ;; 030C:  DD 9E 7F
 and a, (ix+-128)       ;; 030F:  DD A6 80
 and a, (ix+0)          ;; 0312:  DD A6 00
 and a, (ix+127)        ;; 0315:  DD A6 7F
 xor a, (ix+-128)       ;; 0318:  DD AE 80
 xor a, (ix+0)          ;; 031B:  DD AE 00
 xor a, (ix+127)        ;; 031E:  DD AE 7F
 or a, (ix+-128)        ;; 0321:  DD B6 80
 or a, (ix+0)           ;; 0324:  DD B6 00
 or a, (ix+127)         ;; 0327:  DD B6 7F
 cp a, (ix+-128)        ;; 032A:  DD BE 80
 cp a, (ix+0)           ;; 032D:  DD BE 00
 cp a, (ix+127)         ;; 0330:  DD BE 7F
 add (ix+-128)          ;; 0333:  DD 86 80
 add (ix+0)             ;; 0336:  DD 86 00
 add (ix+127)           ;; 0339:  DD 86 7F
 adc (ix+-128)          ;; 033C:  DD 8E 80
 adc (ix+0)             ;; 033F:  DD 8E 00
 adc (ix+127)           ;; 0342:  DD 8E 7F
 sub (ix+-128)          ;; 0345:  DD 96 80
 sub (ix+0)             ;; 0348:  DD 96 00
 sub (ix+127)           ;; 034B:  DD 96 7F
 sbc (ix+-128)          ;; 034E:  DD 9E 80
 sbc (ix+0)             ;; 0351:  DD 9E 00
 sbc (ix+127)           ;; 0354:  DD 9E 7F
 and (ix+-128)          ;; 0357:  DD A6 80
 and (ix+0)             ;; 035A:  DD A6 00
 and (ix+127)           ;; 035D:  DD A6 7F
 xor (ix+-128)          ;; 0360:  DD AE 80
 xor (ix+0)             ;; 0363:  DD AE 00
 xor (ix+127)           ;; 0366:  DD AE 7F
 or (ix+-128)           ;; 0369:  DD B6 80
 or (ix+0)              ;; 036C:  DD B6 00
 or (ix+127)            ;; 036F:  DD B6 7F
 cp (ix+-128)           ;; 0372:  DD BE 80
 cp (ix+0)              ;; 0375:  DD BE 00
 cp (ix+127)            ;; 0378:  DD BE 7F
 add a, (iy+-128)       ;; 037B:  FD 86 80
 add a, (iy+0)          ;; 037E:  FD 86 00
 add a, (iy+127)        ;; 0381:  FD 86 7F
 adc a, (iy+-128)       ;; 0384:  FD 8E 80
 adc a, (iy+0)          ;; 0387:  FD 8E 00
 adc a, (iy+127)        ;; 038A:  FD 8E 7F
 sub a, (iy+-128)       ;; 038D:  FD 96 80
 sub a, (iy+0)          ;; 0390:  FD 96 00
 sub a, (iy+127)        ;; 0393:  FD 96 7F
 sbc a, (iy+-128)       ;; 0396:  FD 9E 80
 sbc a, (iy+0)          ;; 0399:  FD 9E 00
 sbc a, (iy+127)        ;; 039C:  FD 9E 7F
 and a, (iy+-128)       ;; 039F:  FD A6 80
 and a, (iy+0)          ;; 03A2:  FD A6 00
 and a, (iy+127)        ;; 03A5:  FD A6 7F
 xor a, (iy+-128)       ;; 03A8:  FD AE 80
 xor a, (iy+0)          ;; 03AB:  FD AE 00
 xor a, (iy+127)        ;; 03AE:  FD AE 7F
 or a, (iy+-128)        ;; 03B1:  FD B6 80
 or a, (iy+0)           ;; 03B4:  FD B6 00
 or a, (iy+127)         ;; 03B7:  FD B6 7F
 cp a, (iy+-128)        ;; 03BA:  FD BE 80
 cp a, (iy+0)           ;; 03BD:  FD BE 00
 cp a, (iy+127)         ;; 03C0:  FD BE 7F
 add (iy+-128)          ;; 03C3:  FD 86 80
 add (iy+0)             ;; 03C6:  FD 86 00
 add (iy+127)           ;; 03C9:  FD 86 7F
 adc (iy+-128)          ;; 03CC:  FD 8E 80
 adc (iy+0)             ;; 03CF:  FD 8E 00
 adc (iy+127)           ;; 03D2:  FD 8E 7F
 sub (iy+-128)          ;; 03D5:  FD 96 80
 sub (iy+0)             ;; 03D8:  FD 96 00
 sub (iy+127)           ;; 03DB:  FD 96 7F
 sbc (iy+-128)          ;; 03DE:  FD 9E 80
 sbc (iy+0)             ;; 03E1:  FD 9E 00
 sbc (iy+127)           ;; 03E4:  FD 9E 7F
 and (iy+-128)          ;; 03E7:  FD A6 80
 and (iy+0)             ;; 03EA:  FD A6 00
 and (iy+127)           ;; 03ED:  FD A6 7F
 xor (iy+-128)          ;; 03F0:  FD AE 80
 xor (iy+0)             ;; 03F3:  FD AE 00
 xor (iy+127)           ;; 03F6:  FD AE 7F
 or (iy+-128)           ;; 03F9:  FD B6 80
 or (iy+0)              ;; 03FC:  FD B6 00
 or (iy+127)            ;; 03FF:  FD B6 7F
 cp (iy+-128)           ;; 0402:  FD BE 80
 cp (iy+0)              ;; 0405:  FD BE 00
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
 inc (ix + 0)           ;; 052E:  DD 34 00
 inc (ix + 127)         ;; 0531:  DD 34 7F
 dec (ix + -128)        ;; 0534:  DD 35 80
 dec (ix + 0)           ;; 0537:  DD 35 00
 dec (ix + 127)         ;; 053A:  DD 35 7F
 inc (iy + -128)        ;; 053D:  FD 34 80
 inc (iy + 0)           ;; 0540:  FD 34 00
 inc (iy + 127)         ;; 0543:  FD 34 7F
 dec (iy + -128)        ;; 0546:  FD 35 80
 dec (iy + 0)           ;; 0549:  FD 35 00
 dec (iy + 127)         ;; 054C:  FD 35 7F
 daa                    ;; 054F:  27
 rld                    ;; 0550:  ED 6F
 rrd                    ;; 0552:  ED 67
 cpl                    ;; 0554:  2F
 neg                    ;; 0555:  ED 44
 ccf                    ;; 0557:  3F
 scf                    ;; 0558:  37
 ld bc, 0               ;; 0559:  01 00 00
 ld bc, 291             ;; 055C:  01 23 01
 ld bc, 17767           ;; 055F:  01 67 45
 ld bc, 35243           ;; 0562:  01 AB 89
 ld bc, 52719           ;; 0565:  01 EF CD
 ld bc, 65535           ;; 0568:  01 FF FF
 ld de, 0               ;; 056B:  11 00 00
 ld de, 291             ;; 056E:  11 23 01
 ld de, 17767           ;; 0571:  11 67 45
 ld de, 35243           ;; 0574:  11 AB 89
 ld de, 52719           ;; 0577:  11 EF CD
 ld de, 65535           ;; 057A:  11 FF FF
 ld hl, 0               ;; 057D:  21 00 00
 ld hl, 291             ;; 0580:  21 23 01
 ld hl, 17767           ;; 0583:  21 67 45
 ld hl, 35243           ;; 0586:  21 AB 89
 ld hl, 52719           ;; 0589:  21 EF CD
 ld hl, 65535           ;; 058C:  21 FF FF
 ld sp, 0               ;; 058F:  31 00 00
 ld sp, 291             ;; 0592:  31 23 01
 ld sp, 17767           ;; 0595:  31 67 45
 ld sp, 35243           ;; 0598:  31 AB 89
 ld sp, 52719           ;; 059B:  31 EF CD
 ld sp, 65535           ;; 059E:  31 FF FF
 ld ix, 0               ;; 05A1:  DD 21 00 00
 ld ix, 291             ;; 05A5:  DD 21 23 01
 ld ix, 17767           ;; 05A9:  DD 21 67 45
 ld ix, 35243           ;; 05AD:  DD 21 AB 89
 ld ix, 52719           ;; 05B1:  DD 21 EF CD
 ld ix, 65535           ;; 05B5:  DD 21 FF FF
 ld iy, 0               ;; 05B9:  FD 21 00 00
 ld iy, 291             ;; 05BD:  FD 21 23 01
 ld iy, 17767           ;; 05C1:  FD 21 67 45
 ld iy, 35243           ;; 05C5:  FD 21 AB 89
 ld iy, 52719           ;; 05C9:  FD 21 EF CD
 ld iy, 65535           ;; 05CD:  FD 21 FF FF
 ld hl, (0)             ;; 05D1:  2A 00 00
 ld hl, (291)           ;; 05D4:  2A 23 01
 ld hl, (17767)         ;; 05D7:  2A 67 45
 ld hl, (35243)         ;; 05DA:  2A AB 89
 ld hl, (52719)         ;; 05DD:  2A EF CD
 ld hl, (65535)         ;; 05E0:  2A FF FF
 ld ix, (0)             ;; 05E3:  DD 2A 00 00
 ld ix, (291)           ;; 05E7:  DD 2A 23 01
 ld ix, (17767)         ;; 05EB:  DD 2A 67 45
 ld ix, (35243)         ;; 05EF:  DD 2A AB 89
 ld ix, (52719)         ;; 05F3:  DD 2A EF CD
 ld ix, (65535)         ;; 05F7:  DD 2A FF FF
 ld iy, (0)             ;; 05FB:  FD 2A 00 00
 ld iy, (291)           ;; 05FF:  FD 2A 23 01
 ld iy, (17767)         ;; 0603:  FD 2A 67 45
 ld iy, (35243)         ;; 0607:  FD 2A AB 89
 ld iy, (52719)         ;; 060B:  FD 2A EF CD
 ld iy, (65535)         ;; 060F:  FD 2A FF FF
 ld (0), hl             ;; 0613:  22 00 00
 ld (291), hl           ;; 0616:  22 23 01
 ld (17767), hl         ;; 0619:  22 67 45
 ld (35243), hl         ;; 061C:  22 AB 89
 ld (52719), hl         ;; 061F:  22 EF CD
 ld (65535), hl         ;; 0622:  22 FF FF
 ld (0), ix             ;; 0625:  DD 22 00 00
 ld (291), ix           ;; 0629:  DD 22 23 01
 ld (17767), ix         ;; 062D:  DD 22 67 45
 ld (35243), ix         ;; 0631:  DD 22 AB 89
 ld (52719), ix         ;; 0635:  DD 22 EF CD
 ld (65535), ix         ;; 0639:  DD 22 FF FF
 ld (0), iy             ;; 063D:  FD 22 00 00
 ld (291), iy           ;; 0641:  FD 22 23 01
 ld (17767), iy         ;; 0645:  FD 22 67 45
 ld (35243), iy         ;; 0649:  FD 22 AB 89
 ld (52719), iy         ;; 064D:  FD 22 EF CD
 ld (65535), iy         ;; 0651:  FD 22 FF FF
 LD bc, (0)             ;; 0655:  ED 4B 00 00
 LD bc, (291)           ;; 0659:  ED 4B 23 01
 LD bc, (17767)         ;; 065D:  ED 4B 67 45
 LD bc, (35243)         ;; 0661:  ED 4B AB 89
 LD bc, (52719)         ;; 0665:  ED 4B EF CD
 LD bc, (65535)         ;; 0669:  ED 4B FF FF
 LD de, (0)             ;; 066D:  ED 5B 00 00
 LD de, (291)           ;; 0671:  ED 5B 23 01
 LD de, (17767)         ;; 0675:  ED 5B 67 45
 LD de, (35243)         ;; 0679:  ED 5B AB 89
 LD de, (52719)         ;; 067D:  ED 5B EF CD
 LD de, (65535)         ;; 0681:  ED 5B FF FF
 LD sp, (0)             ;; 0685:  ED 7B 00 00
 LD sp, (291)           ;; 0689:  ED 7B 23 01
 LD sp, (17767)         ;; 068D:  ED 7B 67 45
 LD sp, (35243)         ;; 0691:  ED 7B AB 89
 LD sp, (52719)         ;; 0695:  ED 7B EF CD
 LD sp, (65535)         ;; 0699:  ED 7B FF FF
 LD (0), bc             ;; 069D:  ED 43 00 00
 LD (291), bc           ;; 06A1:  ED 43 23 01
 LD (17767), bc         ;; 06A5:  ED 43 67 45
 LD (35243), bc         ;; 06A9:  ED 43 AB 89
 LD (52719), bc         ;; 06AD:  ED 43 EF CD
 LD (65535), bc         ;; 06B1:  ED 43 FF FF
 LD (0), de             ;; 06B5:  ED 53 00 00
 LD (291), de           ;; 06B9:  ED 53 23 01
 LD (17767), de         ;; 06BD:  ED 53 67 45
 LD (35243), de         ;; 06C1:  ED 53 AB 89
 LD (52719), de         ;; 06C5:  ED 53 EF CD
 LD (65535), de         ;; 06C9:  ED 53 FF FF
 LD (0), sp             ;; 06CD:  ED 73 00 00
 LD (291), sp           ;; 06D1:  ED 73 23 01
 LD (17767), sp         ;; 06D5:  ED 73 67 45
 LD (35243), sp         ;; 06D9:  ED 73 AB 89
 LD (52719), sp         ;; 06DD:  ED 73 EF CD
 LD (65535), sp         ;; 06E1:  ED 73 FF FF
 ld sp, hl              ;; 06E5:  F9
 ld sp, ix              ;; 06E6:  DD F9
 ld sp, iy              ;; 06E8:  FD F9
 push bc                ;; 06EA:  C5
 push de                ;; 06EB:  D5
 push hl                ;; 06EC:  E5
 push af                ;; 06ED:  F5
 push ix                ;; 06EE:  DD E5
 push iy                ;; 06F0:  FD E5
 pop bc                 ;; 06F2:  C1
 pop de                 ;; 06F3:  D1
 pop hl                 ;; 06F4:  E1
 pop af                 ;; 06F5:  F1
 pop ix                 ;; 06F6:  DD E1
 pop iy                 ;; 06F8:  FD E1
 add hl, bc             ;; 06FA:  09
 add hl, de             ;; 06FB:  19
 add hl, hl             ;; 06FC:  29
 add hl, sp             ;; 06FD:  39
 add ix, bc             ;; 06FE:  DD 09
 add ix, de             ;; 0700:  DD 19
 add ix, ix             ;; 0702:  DD 29
 add ix, sp             ;; 0704:  DD 39
 add iy, bc             ;; 0706:  FD 09
 add iy, de             ;; 0708:  FD 19
 add iy, iy             ;; 070A:  FD 29
 add iy, sp             ;; 070C:  FD 39
 sbc hl, bc             ;; 070E:  ED 42
 sbc hl, de             ;; 0710:  ED 52
 sbc hl, hl             ;; 0712:  ED 62
 sbc hl, sp             ;; 0714:  ED 72
 adc hl, bc             ;; 0716:  ED 4A
 adc hl, de             ;; 0718:  ED 5A
 adc hl, hl             ;; 071A:  ED 6A
 adc hl, sp             ;; 071C:  ED 7A
 inc bc                 ;; 071E:  03
 inc de                 ;; 071F:  13
 inc hl                 ;; 0720:  23
 inc sp                 ;; 0721:  33
 dec bc                 ;; 0722:  0B
 dec de                 ;; 0723:  1B
 dec hl                 ;; 0724:  2B
 dec sp                 ;; 0725:  3B
 inc ix                 ;; 0726:  DD 23
 dec ix                 ;; 0728:  DD 2B
 inc iy                 ;; 072A:  FD 23
 dec iy                 ;; 072C:  FD 2B
 ex af, af              ;; 072E:  08
 ex af, af'             ;; 072F:  08
 exx                    ;; 0730:  D9
 ex (sp), hl            ;; 0731:  E3
 ex (sp), ix            ;; 0732:  DD E3
 ex (sp), iy            ;; 0734:  FD E3
 ex de, hl              ;; 0736:  EB
 rlca                   ;; 0737:  07
 rrca                   ;; 0738:  0F
 rla                    ;; 0739:  17
 rra                    ;; 073A:  1F
 rlc b                  ;; 073B:  CB 00
 rlc c                  ;; 073D:  CB 01
 rlc d                  ;; 073F:  CB 02
 rlc e                  ;; 0741:  CB 03
 rlc h                  ;; 0743:  CB 04
 rlc l                  ;; 0745:  CB 05
 rlc (hl)               ;; 0747:  CB 06
 rlc a                  ;; 0749:  CB 07
 rrc b                  ;; 074B:  CB 08
 rrc c                  ;; 074D:  CB 09
 rrc d                  ;; 074F:  CB 0A
 rrc e                  ;; 0751:  CB 0B
 rrc h                  ;; 0753:  CB 0C
 rrc l                  ;; 0755:  CB 0D
 rrc (hl)               ;; 0757:  CB 0E
 rrc a                  ;; 0759:  CB 0F
 rl b                   ;; 075B:  CB 10
 rl c                   ;; 075D:  CB 11
 rl d                   ;; 075F:  CB 12
 rl e                   ;; 0761:  CB 13
 rl h                   ;; 0763:  CB 14
 rl l                   ;; 0765:  CB 15
 rl (hl)                ;; 0767:  CB 16
 rl a                   ;; 0769:  CB 17
 rr b                   ;; 076B:  CB 18
 rr c                   ;; 076D:  CB 19
 rr d                   ;; 076F:  CB 1A
 rr e                   ;; 0771:  CB 1B
 rr h                   ;; 0773:  CB 1C
 rr l                   ;; 0775:  CB 1D
 rr (hl)                ;; 0777:  CB 1E
 rr a                   ;; 0779:  CB 1F
 sla b                  ;; 077B:  CB 20
 sla c                  ;; 077D:  CB 21
 sla d                  ;; 077F:  CB 22
 sla e                  ;; 0781:  CB 23
 sla h                  ;; 0783:  CB 24
 sla l                  ;; 0785:  CB 25
 sla (hl)               ;; 0787:  CB 26
 sla a                  ;; 0789:  CB 27
 sra b                  ;; 078B:  CB 28
 sra c                  ;; 078D:  CB 29
 sra d                  ;; 078F:  CB 2A
 sra e                  ;; 0791:  CB 2B
 sra h                  ;; 0793:  CB 2C
 sra l                  ;; 0795:  CB 2D
 sra (hl)               ;; 0797:  CB 2E
 sra a                  ;; 0799:  CB 2F
 srl b                  ;; 079B:  CB 38
 srl c                  ;; 079D:  CB 39
 srl d                  ;; 079F:  CB 3A
 srl e                  ;; 07A1:  CB 3B
 srl h                  ;; 07A3:  CB 3C
 srl l                  ;; 07A5:  CB 3D
 srl (hl)               ;; 07A7:  CB 3E
 srl a                  ;; 07A9:  CB 3F
 sll b                  ;; 07AB:  CB 30
 sll c                  ;; 07AD:  CB 31
 sll d                  ;; 07AF:  CB 32
 sll e                  ;; 07B1:  CB 33
 sll h                  ;; 07B3:  CB 34
 sll l                  ;; 07B5:  CB 35
 sll (hl)               ;; 07B7:  CB 36
 sll a                  ;; 07B9:  CB 37
 rlc (ix+-128)          ;; 07BB:  DD CB 80 06
 rlc (ix+0)             ;; 07BF:  DD CB 00 06
 rlc (ix+127)           ;; 07C3:  DD CB 7F 06
 rrc (ix+-128)          ;; 07C7:  DD CB 80 0E
 rrc (ix+0)             ;; 07CB:  DD CB 00 0E
 rrc (ix+127)           ;; 07CF:  DD CB 7F 0E
 rl (ix+-128)           ;; 07D3:  DD CB 80 16
 rl (ix+0)              ;; 07D7:  DD CB 00 16
 rl (ix+127)            ;; 07DB:  DD CB 7F 16
 rr (ix+-128)           ;; 07DF:  DD CB 80 1E
 rr (ix+0)              ;; 07E3:  DD CB 00 1E
 rr (ix+127)            ;; 07E7:  DD CB 7F 1E
 sla (ix+-128)          ;; 07EB:  DD CB 80 26
 sla (ix+0)             ;; 07EF:  DD CB 00 26
 sla (ix+127)           ;; 07F3:  DD CB 7F 26
 sra (ix+-128)          ;; 07F7:  DD CB 80 2E
 sra (ix+0)             ;; 07FB:  DD CB 00 2E
 sra (ix+127)           ;; 07FF:  DD CB 7F 2E
 srl (ix+-128)          ;; 0803:  DD CB 80 3E
 srl (ix+0)             ;; 0807:  DD CB 00 3E
 srl (ix+127)           ;; 080B:  DD CB 7F 3E
 sll (ix+-128)          ;; 080F:  DD CB 80 36
 sll (ix+0)             ;; 0813:  DD CB 00 36
 sll (ix+127)           ;; 0817:  DD CB 7F 36
 rlc (iy+-128)          ;; 081B:  FD CB 80 06
 rlc (iy+0)             ;; 081F:  FD CB 00 06
 rlc (iy+127)           ;; 0823:  FD CB 7F 06
 rrc (iy+-128)          ;; 0827:  FD CB 80 0E
 rrc (iy+0)             ;; 082B:  FD CB 00 0E
 rrc (iy+127)           ;; 082F:  FD CB 7F 0E
 rl (iy+-128)           ;; 0833:  FD CB 80 16
 rl (iy+0)              ;; 0837:  FD CB 00 16
 rl (iy+127)            ;; 083B:  FD CB 7F 16
 rr (iy+-128)           ;; 083F:  FD CB 80 1E
 rr (iy+0)              ;; 0843:  FD CB 00 1E
 rr (iy+127)            ;; 0847:  FD CB 7F 1E
 sla (iy+-128)          ;; 084B:  FD CB 80 26
 sla (iy+0)             ;; 084F:  FD CB 00 26
 sla (iy+127)           ;; 0853:  FD CB 7F 26
 sra (iy+-128)          ;; 0857:  FD CB 80 2E
 sra (iy+0)             ;; 085B:  FD CB 00 2E
 sra (iy+127)           ;; 085F:  FD CB 7F 2E
 srl (iy+-128)          ;; 0863:  FD CB 80 3E
 srl (iy+0)             ;; 0867:  FD CB 00 3E
 srl (iy+127)           ;; 086B:  FD CB 7F 3E
 sll (iy+-128)          ;; 086F:  FD CB 80 36
 sll (iy+0)             ;; 0873:  FD CB 00 36
 sll (iy+127)           ;; 0877:  FD CB 7F 36
 bit 0, b               ;; 087B:  CB 40
 bit 0, c               ;; 087D:  CB 41
 bit 0, d               ;; 087F:  CB 42
 bit 0, e               ;; 0881:  CB 43
 bit 0, h               ;; 0883:  CB 44
 bit 0, l               ;; 0885:  CB 45
 bit 0, (hl)            ;; 0887:  CB 46
 bit 0, a               ;; 0889:  CB 47
 bit 1, b               ;; 088B:  CB 48
 bit 1, c               ;; 088D:  CB 49
 bit 1, d               ;; 088F:  CB 4A
 bit 1, e               ;; 0891:  CB 4B
 bit 1, h               ;; 0893:  CB 4C
 bit 1, l               ;; 0895:  CB 4D
 bit 1, (hl)            ;; 0897:  CB 4E
 bit 1, a               ;; 0899:  CB 4F
 bit 2, b               ;; 089B:  CB 50
 bit 2, c               ;; 089D:  CB 51
 bit 2, d               ;; 089F:  CB 52
 bit 2, e               ;; 08A1:  CB 53
 bit 2, h               ;; 08A3:  CB 54
 bit 2, l               ;; 08A5:  CB 55
 bit 2, (hl)            ;; 08A7:  CB 56
 bit 2, a               ;; 08A9:  CB 57
 bit 3, b               ;; 08AB:  CB 58
 bit 3, c               ;; 08AD:  CB 59
 bit 3, d               ;; 08AF:  CB 5A
 bit 3, e               ;; 08B1:  CB 5B
 bit 3, h               ;; 08B3:  CB 5C
 bit 3, l               ;; 08B5:  CB 5D
 bit 3, (hl)            ;; 08B7:  CB 5E
 bit 3, a               ;; 08B9:  CB 5F
 bit 4, b               ;; 08BB:  CB 60
 bit 4, c               ;; 08BD:  CB 61
 bit 4, d               ;; 08BF:  CB 62
 bit 4, e               ;; 08C1:  CB 63
 bit 4, h               ;; 08C3:  CB 64
 bit 4, l               ;; 08C5:  CB 65
 bit 4, (hl)            ;; 08C7:  CB 66
 bit 4, a               ;; 08C9:  CB 67
 bit 5, b               ;; 08CB:  CB 68
 bit 5, c               ;; 08CD:  CB 69
 bit 5, d               ;; 08CF:  CB 6A
 bit 5, e               ;; 08D1:  CB 6B
 bit 5, h               ;; 08D3:  CB 6C
 bit 5, l               ;; 08D5:  CB 6D
 bit 5, (hl)            ;; 08D7:  CB 6E
 bit 5, a               ;; 08D9:  CB 6F
 bit 6, b               ;; 08DB:  CB 70
 bit 6, c               ;; 08DD:  CB 71
 bit 6, d               ;; 08DF:  CB 72
 bit 6, e               ;; 08E1:  CB 73
 bit 6, h               ;; 08E3:  CB 74
 bit 6, l               ;; 08E5:  CB 75
 bit 6, (hl)            ;; 08E7:  CB 76
 bit 6, a               ;; 08E9:  CB 77
 bit 7, b               ;; 08EB:  CB 78
 bit 7, c               ;; 08ED:  CB 79
 bit 7, d               ;; 08EF:  CB 7A
 bit 7, e               ;; 08F1:  CB 7B
 bit 7, h               ;; 08F3:  CB 7C
 bit 7, l               ;; 08F5:  CB 7D
 bit 7, (hl)            ;; 08F7:  CB 7E
 bit 7, a               ;; 08F9:  CB 7F
 res 0, b               ;; 08FB:  CB 80
 res 0, c               ;; 08FD:  CB 81
 res 0, d               ;; 08FF:  CB 82
 res 0, e               ;; 0901:  CB 83
 res 0, h               ;; 0903:  CB 84
 res 0, l               ;; 0905:  CB 85
 res 0, (hl)            ;; 0907:  CB 86
 res 0, a               ;; 0909:  CB 87
 res 1, b               ;; 090B:  CB 88
 res 1, c               ;; 090D:  CB 89
 res 1, d               ;; 090F:  CB 8A
 res 1, e               ;; 0911:  CB 8B
 res 1, h               ;; 0913:  CB 8C
 res 1, l               ;; 0915:  CB 8D
 res 1, (hl)            ;; 0917:  CB 8E
 res 1, a               ;; 0919:  CB 8F
 res 2, b               ;; 091B:  CB 90
 res 2, c               ;; 091D:  CB 91
 res 2, d               ;; 091F:  CB 92
 res 2, e               ;; 0921:  CB 93
 res 2, h               ;; 0923:  CB 94
 res 2, l               ;; 0925:  CB 95
 res 2, (hl)            ;; 0927:  CB 96
 res 2, a               ;; 0929:  CB 97
 res 3, b               ;; 092B:  CB 98
 res 3, c               ;; 092D:  CB 99
 res 3, d               ;; 092F:  CB 9A
 res 3, e               ;; 0931:  CB 9B
 res 3, h               ;; 0933:  CB 9C
 res 3, l               ;; 0935:  CB 9D
 res 3, (hl)            ;; 0937:  CB 9E
 res 3, a               ;; 0939:  CB 9F
 res 4, b               ;; 093B:  CB A0
 res 4, c               ;; 093D:  CB A1
 res 4, d               ;; 093F:  CB A2
 res 4, e               ;; 0941:  CB A3
 res 4, h               ;; 0943:  CB A4
 res 4, l               ;; 0945:  CB A5
 res 4, (hl)            ;; 0947:  CB A6
 res 4, a               ;; 0949:  CB A7
 res 5, b               ;; 094B:  CB A8
 res 5, c               ;; 094D:  CB A9
 res 5, d               ;; 094F:  CB AA
 res 5, e               ;; 0951:  CB AB
 res 5, h               ;; 0953:  CB AC
 res 5, l               ;; 0955:  CB AD
 res 5, (hl)            ;; 0957:  CB AE
 res 5, a               ;; 0959:  CB AF
 res 6, b               ;; 095B:  CB B0
 res 6, c               ;; 095D:  CB B1
 res 6, d               ;; 095F:  CB B2
 res 6, e               ;; 0961:  CB B3
 res 6, h               ;; 0963:  CB B4
 res 6, l               ;; 0965:  CB B5
 res 6, (hl)            ;; 0967:  CB B6
 res 6, a               ;; 0969:  CB B7
 res 7, b               ;; 096B:  CB B8
 res 7, c               ;; 096D:  CB B9
 res 7, d               ;; 096F:  CB BA
 res 7, e               ;; 0971:  CB BB
 res 7, h               ;; 0973:  CB BC
 res 7, l               ;; 0975:  CB BD
 res 7, (hl)            ;; 0977:  CB BE
 res 7, a               ;; 0979:  CB BF
 set 0, b               ;; 097B:  CB C0
 set 0, c               ;; 097D:  CB C1
 set 0, d               ;; 097F:  CB C2
 set 0, e               ;; 0981:  CB C3
 set 0, h               ;; 0983:  CB C4
 set 0, l               ;; 0985:  CB C5
 set 0, (hl)            ;; 0987:  CB C6
 set 0, a               ;; 0989:  CB C7
 set 1, b               ;; 098B:  CB C8
 set 1, c               ;; 098D:  CB C9
 set 1, d               ;; 098F:  CB CA
 set 1, e               ;; 0991:  CB CB
 set 1, h               ;; 0993:  CB CC
 set 1, l               ;; 0995:  CB CD
 set 1, (hl)            ;; 0997:  CB CE
 set 1, a               ;; 0999:  CB CF
 set 2, b               ;; 099B:  CB D0
 set 2, c               ;; 099D:  CB D1
 set 2, d               ;; 099F:  CB D2
 set 2, e               ;; 09A1:  CB D3
 set 2, h               ;; 09A3:  CB D4
 set 2, l               ;; 09A5:  CB D5
 set 2, (hl)            ;; 09A7:  CB D6
 set 2, a               ;; 09A9:  CB D7
 set 3, b               ;; 09AB:  CB D8
 set 3, c               ;; 09AD:  CB D9
 set 3, d               ;; 09AF:  CB DA
 set 3, e               ;; 09B1:  CB DB
 set 3, h               ;; 09B3:  CB DC
 set 3, l               ;; 09B5:  CB DD
 set 3, (hl)            ;; 09B7:  CB DE
 set 3, a               ;; 09B9:  CB DF
 set 4, b               ;; 09BB:  CB E0
 set 4, c               ;; 09BD:  CB E1
 set 4, d               ;; 09BF:  CB E2
 set 4, e               ;; 09C1:  CB E3
 set 4, h               ;; 09C3:  CB E4
 set 4, l               ;; 09C5:  CB E5
 set 4, (hl)            ;; 09C7:  CB E6
 set 4, a               ;; 09C9:  CB E7
 set 5, b               ;; 09CB:  CB E8
 set 5, c               ;; 09CD:  CB E9
 set 5, d               ;; 09CF:  CB EA
 set 5, e               ;; 09D1:  CB EB
 set 5, h               ;; 09D3:  CB EC
 set 5, l               ;; 09D5:  CB ED
 set 5, (hl)            ;; 09D7:  CB EE
 set 5, a               ;; 09D9:  CB EF
 set 6, b               ;; 09DB:  CB F0
 set 6, c               ;; 09DD:  CB F1
 set 6, d               ;; 09DF:  CB F2
 set 6, e               ;; 09E1:  CB F3
 set 6, h               ;; 09E3:  CB F4
 set 6, l               ;; 09E5:  CB F5
 set 6, (hl)            ;; 09E7:  CB F6
 set 6, a               ;; 09E9:  CB F7
 set 7, b               ;; 09EB:  CB F8
 set 7, c               ;; 09ED:  CB F9
 set 7, d               ;; 09EF:  CB FA
 set 7, e               ;; 09F1:  CB FB
 set 7, h               ;; 09F3:  CB FC
 set 7, l               ;; 09F5:  CB FD
 set 7, (hl)            ;; 09F7:  CB FE
 set 7, a               ;; 09F9:  CB FF
 bit 0, (ix+-128)       ;; 09FB:  DD CB 80 46
 bit 0, (ix+0)          ;; 09FF:  DD CB 00 46
 bit 0, (ix+127)        ;; 0A03:  DD CB 7F 46
 bit 1, (ix+-128)       ;; 0A07:  DD CB 80 4E
 bit 1, (ix+0)          ;; 0A0B:  DD CB 00 4E
 bit 1, (ix+127)        ;; 0A0F:  DD CB 7F 4E
 bit 2, (ix+-128)       ;; 0A13:  DD CB 80 56
 bit 2, (ix+0)          ;; 0A17:  DD CB 00 56
 bit 2, (ix+127)        ;; 0A1B:  DD CB 7F 56
 bit 3, (ix+-128)       ;; 0A1F:  DD CB 80 5E
 bit 3, (ix+0)          ;; 0A23:  DD CB 00 5E
 bit 3, (ix+127)        ;; 0A27:  DD CB 7F 5E
 bit 4, (ix+-128)       ;; 0A2B:  DD CB 80 66
 bit 4, (ix+0)          ;; 0A2F:  DD CB 00 66
 bit 4, (ix+127)        ;; 0A33:  DD CB 7F 66
 bit 5, (ix+-128)       ;; 0A37:  DD CB 80 6E
 bit 5, (ix+0)          ;; 0A3B:  DD CB 00 6E
 bit 5, (ix+127)        ;; 0A3F:  DD CB 7F 6E
 bit 6, (ix+-128)       ;; 0A43:  DD CB 80 76
 bit 6, (ix+0)          ;; 0A47:  DD CB 00 76
 bit 6, (ix+127)        ;; 0A4B:  DD CB 7F 76
 bit 7, (ix+-128)       ;; 0A4F:  DD CB 80 7E
 bit 7, (ix+0)          ;; 0A53:  DD CB 00 7E
 bit 7, (ix+127)        ;; 0A57:  DD CB 7F 7E
 res 0, (ix+-128)       ;; 0A5B:  DD CB 80 86
 res 0, (ix+0)          ;; 0A5F:  DD CB 00 86
 res 0, (ix+127)        ;; 0A63:  DD CB 7F 86
 res 1, (ix+-128)       ;; 0A67:  DD CB 80 8E
 res 1, (ix+0)          ;; 0A6B:  DD CB 00 8E
 res 1, (ix+127)        ;; 0A6F:  DD CB 7F 8E
 res 2, (ix+-128)       ;; 0A73:  DD CB 80 96
 res 2, (ix+0)          ;; 0A77:  DD CB 00 96
 res 2, (ix+127)        ;; 0A7B:  DD CB 7F 96
 res 3, (ix+-128)       ;; 0A7F:  DD CB 80 9E
 res 3, (ix+0)          ;; 0A83:  DD CB 00 9E
 res 3, (ix+127)        ;; 0A87:  DD CB 7F 9E
 res 4, (ix+-128)       ;; 0A8B:  DD CB 80 A6
 res 4, (ix+0)          ;; 0A8F:  DD CB 00 A6
 res 4, (ix+127)        ;; 0A93:  DD CB 7F A6
 res 5, (ix+-128)       ;; 0A97:  DD CB 80 AE
 res 5, (ix+0)          ;; 0A9B:  DD CB 00 AE
 res 5, (ix+127)        ;; 0A9F:  DD CB 7F AE
 res 6, (ix+-128)       ;; 0AA3:  DD CB 80 B6
 res 6, (ix+0)          ;; 0AA7:  DD CB 00 B6
 res 6, (ix+127)        ;; 0AAB:  DD CB 7F B6
 res 7, (ix+-128)       ;; 0AAF:  DD CB 80 BE
 res 7, (ix+0)          ;; 0AB3:  DD CB 00 BE
 res 7, (ix+127)        ;; 0AB7:  DD CB 7F BE
 set 0, (ix+-128)       ;; 0ABB:  DD CB 80 C6
 set 0, (ix+0)          ;; 0ABF:  DD CB 00 C6
 set 0, (ix+127)        ;; 0AC3:  DD CB 7F C6
 set 1, (ix+-128)       ;; 0AC7:  DD CB 80 CE
 set 1, (ix+0)          ;; 0ACB:  DD CB 00 CE
 set 1, (ix+127)        ;; 0ACF:  DD CB 7F CE
 set 2, (ix+-128)       ;; 0AD3:  DD CB 80 D6
 set 2, (ix+0)          ;; 0AD7:  DD CB 00 D6
 set 2, (ix+127)        ;; 0ADB:  DD CB 7F D6
 set 3, (ix+-128)       ;; 0ADF:  DD CB 80 DE
 set 3, (ix+0)          ;; 0AE3:  DD CB 00 DE
 set 3, (ix+127)        ;; 0AE7:  DD CB 7F DE
 set 4, (ix+-128)       ;; 0AEB:  DD CB 80 E6
 set 4, (ix+0)          ;; 0AEF:  DD CB 00 E6
 set 4, (ix+127)        ;; 0AF3:  DD CB 7F E6
 set 5, (ix+-128)       ;; 0AF7:  DD CB 80 EE
 set 5, (ix+0)          ;; 0AFB:  DD CB 00 EE
 set 5, (ix+127)        ;; 0AFF:  DD CB 7F EE
 set 6, (ix+-128)       ;; 0B03:  DD CB 80 F6
 set 6, (ix+0)          ;; 0B07:  DD CB 00 F6
 set 6, (ix+127)        ;; 0B0B:  DD CB 7F F6
 set 7, (ix+-128)       ;; 0B0F:  DD CB 80 FE
 set 7, (ix+0)          ;; 0B13:  DD CB 00 FE
 set 7, (ix+127)        ;; 0B17:  DD CB 7F FE
 bit 0, (iy+-128)       ;; 0B1B:  FD CB 80 46
 bit 0, (iy+0)          ;; 0B1F:  FD CB 00 46
 bit 0, (iy+127)        ;; 0B23:  FD CB 7F 46
 bit 1, (iy+-128)       ;; 0B27:  FD CB 80 4E
 bit 1, (iy+0)          ;; 0B2B:  FD CB 00 4E
 bit 1, (iy+127)        ;; 0B2F:  FD CB 7F 4E
 bit 2, (iy+-128)       ;; 0B33:  FD CB 80 56
 bit 2, (iy+0)          ;; 0B37:  FD CB 00 56
 bit 2, (iy+127)        ;; 0B3B:  FD CB 7F 56
 bit 3, (iy+-128)       ;; 0B3F:  FD CB 80 5E
 bit 3, (iy+0)          ;; 0B43:  FD CB 00 5E
 bit 3, (iy+127)        ;; 0B47:  FD CB 7F 5E
 bit 4, (iy+-128)       ;; 0B4B:  FD CB 80 66
 bit 4, (iy+0)          ;; 0B4F:  FD CB 00 66
 bit 4, (iy+127)        ;; 0B53:  FD CB 7F 66
 bit 5, (iy+-128)       ;; 0B57:  FD CB 80 6E
 bit 5, (iy+0)          ;; 0B5B:  FD CB 00 6E
 bit 5, (iy+127)        ;; 0B5F:  FD CB 7F 6E
 bit 6, (iy+-128)       ;; 0B63:  FD CB 80 76
 bit 6, (iy+0)          ;; 0B67:  FD CB 00 76
 bit 6, (iy+127)        ;; 0B6B:  FD CB 7F 76
 bit 7, (iy+-128)       ;; 0B6F:  FD CB 80 7E
 bit 7, (iy+0)          ;; 0B73:  FD CB 00 7E
 bit 7, (iy+127)        ;; 0B77:  FD CB 7F 7E
 res 0, (iy+-128)       ;; 0B7B:  FD CB 80 86
 res 0, (iy+0)          ;; 0B7F:  FD CB 00 86
 res 0, (iy+127)        ;; 0B83:  FD CB 7F 86
 res 1, (iy+-128)       ;; 0B87:  FD CB 80 8E
 res 1, (iy+0)          ;; 0B8B:  FD CB 00 8E
 res 1, (iy+127)        ;; 0B8F:  FD CB 7F 8E
 res 2, (iy+-128)       ;; 0B93:  FD CB 80 96
 res 2, (iy+0)          ;; 0B97:  FD CB 00 96
 res 2, (iy+127)        ;; 0B9B:  FD CB 7F 96
 res 3, (iy+-128)       ;; 0B9F:  FD CB 80 9E
 res 3, (iy+0)          ;; 0BA3:  FD CB 00 9E
 res 3, (iy+127)        ;; 0BA7:  FD CB 7F 9E
 res 4, (iy+-128)       ;; 0BAB:  FD CB 80 A6
 res 4, (iy+0)          ;; 0BAF:  FD CB 00 A6
 res 4, (iy+127)        ;; 0BB3:  FD CB 7F A6
 res 5, (iy+-128)       ;; 0BB7:  FD CB 80 AE
 res 5, (iy+0)          ;; 0BBB:  FD CB 00 AE
 res 5, (iy+127)        ;; 0BBF:  FD CB 7F AE
 res 6, (iy+-128)       ;; 0BC3:  FD CB 80 B6
 res 6, (iy+0)          ;; 0BC7:  FD CB 00 B6
 res 6, (iy+127)        ;; 0BCB:  FD CB 7F B6
 res 7, (iy+-128)       ;; 0BCF:  FD CB 80 BE
 res 7, (iy+0)          ;; 0BD3:  FD CB 00 BE
 res 7, (iy+127)        ;; 0BD7:  FD CB 7F BE
 set 0, (iy+-128)       ;; 0BDB:  FD CB 80 C6
 set 0, (iy+0)          ;; 0BDF:  FD CB 00 C6
 set 0, (iy+127)        ;; 0BE3:  FD CB 7F C6
 set 1, (iy+-128)       ;; 0BE7:  FD CB 80 CE
 set 1, (iy+0)          ;; 0BEB:  FD CB 00 CE
 set 1, (iy+127)        ;; 0BEF:  FD CB 7F CE
 set 2, (iy+-128)       ;; 0BF3:  FD CB 80 D6
 set 2, (iy+0)          ;; 0BF7:  FD CB 00 D6
 set 2, (iy+127)        ;; 0BFB:  FD CB 7F D6
 set 3, (iy+-128)       ;; 0BFF:  FD CB 80 DE
 set 3, (iy+0)          ;; 0C03:  FD CB 00 DE
 set 3, (iy+127)        ;; 0C07:  FD CB 7F DE
 set 4, (iy+-128)       ;; 0C0B:  FD CB 80 E6
 set 4, (iy+0)          ;; 0C0F:  FD CB 00 E6
 set 4, (iy+127)        ;; 0C13:  FD CB 7F E6
 set 5, (iy+-128)       ;; 0C17:  FD CB 80 EE
 set 5, (iy+0)          ;; 0C1B:  FD CB 00 EE
 set 5, (iy+127)        ;; 0C1F:  FD CB 7F EE
 set 6, (iy+-128)       ;; 0C23:  FD CB 80 F6
 set 6, (iy+0)          ;; 0C27:  FD CB 00 F6
 set 6, (iy+127)        ;; 0C2B:  FD CB 7F F6
 set 7, (iy+-128)       ;; 0C2F:  FD CB 80 FE
 set 7, (iy+0)          ;; 0C33:  FD CB 00 FE
 set 7, (iy+127)        ;; 0C37:  FD CB 7F FE
 ldi                    ;; 0C3B:  ED A0
 ldir                   ;; 0C3D:  ED B0
 ldd                    ;; 0C3F:  ED A8
 lddr                   ;; 0C41:  ED B8
 cpi                    ;; 0C43:  ED A1
 cpir                   ;; 0C45:  ED B1
 cpd                    ;; 0C47:  ED A9
 cpdr                   ;; 0C49:  ED B9
 nop                    ;; 0C4B:  00
 halt                   ;; 0C4C:  76
 jp 0                   ;; 0C4D:  C3 00 00
 jp 291                 ;; 0C50:  C3 23 01
 jp 17767               ;; 0C53:  C3 67 45
 jp 35243               ;; 0C56:  C3 AB 89
 jp 52719               ;; 0C59:  C3 EF CD
 jp 65535               ;; 0C5C:  C3 FF FF
 jp nz, 0               ;; 0C5F:  C2 00 00
 jp nz, 291             ;; 0C62:  C2 23 01
 jp nz, 17767           ;; 0C65:  C2 67 45
 jp nz, 35243           ;; 0C68:  C2 AB 89
 jp nz, 52719           ;; 0C6B:  C2 EF CD
 jp nz, 65535           ;; 0C6E:  C2 FF FF
 jp z, 0                ;; 0C71:  CA 00 00
 jp z, 291              ;; 0C74:  CA 23 01
 jp z, 17767            ;; 0C77:  CA 67 45
 jp z, 35243            ;; 0C7A:  CA AB 89
 jp z, 52719            ;; 0C7D:  CA EF CD
 jp z, 65535            ;; 0C80:  CA FF FF
 jp nc, 0               ;; 0C83:  D2 00 00
 jp nc, 291             ;; 0C86:  D2 23 01
 jp nc, 17767           ;; 0C89:  D2 67 45
 jp nc, 35243           ;; 0C8C:  D2 AB 89
 jp nc, 52719           ;; 0C8F:  D2 EF CD
 jp nc, 65535           ;; 0C92:  D2 FF FF
 jp c, 0                ;; 0C95:  DA 00 00
 jp c, 291              ;; 0C98:  DA 23 01
 jp c, 17767            ;; 0C9B:  DA 67 45
 jp c, 35243            ;; 0C9E:  DA AB 89
 jp c, 52719            ;; 0CA1:  DA EF CD
 jp c, 65535            ;; 0CA4:  DA FF FF
 jp po, 0               ;; 0CA7:  E2 00 00
 jp po, 291             ;; 0CAA:  E2 23 01
 jp po, 17767           ;; 0CAD:  E2 67 45
 jp po, 35243           ;; 0CB0:  E2 AB 89
 jp po, 52719           ;; 0CB3:  E2 EF CD
 jp po, 65535           ;; 0CB6:  E2 FF FF
 jp pe, 0               ;; 0CB9:  EA 00 00
 jp pe, 291             ;; 0CBC:  EA 23 01
 jp pe, 17767           ;; 0CBF:  EA 67 45
 jp pe, 35243           ;; 0CC2:  EA AB 89
 jp pe, 52719           ;; 0CC5:  EA EF CD
 jp pe, 65535           ;; 0CC8:  EA FF FF
 jp p, 0                ;; 0CCB:  F2 00 00
 jp p, 291              ;; 0CCE:  F2 23 01
 jp p, 17767            ;; 0CD1:  F2 67 45
 jp p, 35243            ;; 0CD4:  F2 AB 89
 jp p, 52719            ;; 0CD7:  F2 EF CD
 jp p, 65535            ;; 0CDA:  F2 FF FF
 jp m, 0                ;; 0CDD:  FA 00 00
 jp m, 291              ;; 0CE0:  FA 23 01
 jp m, 17767            ;; 0CE3:  FA 67 45
 jp m, 35243            ;; 0CE6:  FA AB 89
 jp m, 52719            ;; 0CE9:  FA EF CD
 jp m, 65535            ;; 0CEC:  FA FF FF
 jp (hl)                ;; 0CEF:  E9
 jp (ix)                ;; 0CF0:  DD E9
 jp (iy)                ;; 0CF2:  FD E9
 djnz ASMPC             ;; 0CF4:  10 FE
 jr ASMPC               ;; 0CF6:  18 FE
 jr nz, ASMPC           ;; 0CF8:  20 FE
 jr z, ASMPC            ;; 0CFA:  28 FE
 jr nc, ASMPC           ;; 0CFC:  30 FE
 jr c, ASMPC            ;; 0CFE:  38 FE
 call 0                 ;; 0D00:  CD 00 00
 call 291               ;; 0D03:  CD 23 01
 call 17767             ;; 0D06:  CD 67 45
 call 35243             ;; 0D09:  CD AB 89
 call 52719             ;; 0D0C:  CD EF CD
 call 65535             ;; 0D0F:  CD FF FF
 call nz, 0             ;; 0D12:  C4 00 00
 call nz, 291           ;; 0D15:  C4 23 01
 call nz, 17767         ;; 0D18:  C4 67 45
 call nz, 35243         ;; 0D1B:  C4 AB 89
 call nz, 52719         ;; 0D1E:  C4 EF CD
 call nz, 65535         ;; 0D21:  C4 FF FF
 call z, 0              ;; 0D24:  CC 00 00
 call z, 291            ;; 0D27:  CC 23 01
 call z, 17767          ;; 0D2A:  CC 67 45
 call z, 35243          ;; 0D2D:  CC AB 89
 call z, 52719          ;; 0D30:  CC EF CD
 call z, 65535          ;; 0D33:  CC FF FF
 call nc, 0             ;; 0D36:  D4 00 00
 call nc, 291           ;; 0D39:  D4 23 01
 call nc, 17767         ;; 0D3C:  D4 67 45
 call nc, 35243         ;; 0D3F:  D4 AB 89
 call nc, 52719         ;; 0D42:  D4 EF CD
 call nc, 65535         ;; 0D45:  D4 FF FF
 call c, 0              ;; 0D48:  DC 00 00
 call c, 291            ;; 0D4B:  DC 23 01
 call c, 17767          ;; 0D4E:  DC 67 45
 call c, 35243          ;; 0D51:  DC AB 89
 call c, 52719          ;; 0D54:  DC EF CD
 call c, 65535          ;; 0D57:  DC FF FF
 call po, 0             ;; 0D5A:  E4 00 00
 call po, 291           ;; 0D5D:  E4 23 01
 call po, 17767         ;; 0D60:  E4 67 45
 call po, 35243         ;; 0D63:  E4 AB 89
 call po, 52719         ;; 0D66:  E4 EF CD
 call po, 65535         ;; 0D69:  E4 FF FF
 call pe, 0             ;; 0D6C:  EC 00 00
 call pe, 291           ;; 0D6F:  EC 23 01
 call pe, 17767         ;; 0D72:  EC 67 45
 call pe, 35243         ;; 0D75:  EC AB 89
 call pe, 52719         ;; 0D78:  EC EF CD
 call pe, 65535         ;; 0D7B:  EC FF FF
 call p, 0              ;; 0D7E:  F4 00 00
 call p, 291            ;; 0D81:  F4 23 01
 call p, 17767          ;; 0D84:  F4 67 45
 call p, 35243          ;; 0D87:  F4 AB 89
 call p, 52719          ;; 0D8A:  F4 EF CD
 call p, 65535          ;; 0D8D:  F4 FF FF
 call m, 0              ;; 0D90:  FC 00 00
 call m, 291            ;; 0D93:  FC 23 01
 call m, 17767          ;; 0D96:  FC 67 45
 call m, 35243          ;; 0D99:  FC AB 89
 call m, 52719          ;; 0D9C:  FC EF CD
 call m, 65535          ;; 0D9F:  FC FF FF
 ret                    ;; 0DA2:  C9
 ret nz                 ;; 0DA3:  C0
 ret z                  ;; 0DA4:  C8
 ret nc                 ;; 0DA5:  D0
 ret c                  ;; 0DA6:  D8
 ret po                 ;; 0DA7:  E0
 ret pe                 ;; 0DA8:  E8
 ret p                  ;; 0DA9:  F0
 ret m                  ;; 0DAA:  F8
 rst 16                 ;; 0DAB:  D7
 rst 24                 ;; 0DAC:  DF
 rst 32                 ;; 0DAD:  E7
 rst 40                 ;; 0DAE:  EF
 rst 56                 ;; 0DAF:  FF
 rst 0                  ;; 0DB0:  C7
 rst 8                  ;; 0DB1:  CF
 rst 48                 ;; 0DB2:  F7
 in a, (0)              ;; 0DB3:  DB 00
 in a, (85)             ;; 0DB5:  DB 55
 in a, (170)            ;; 0DB7:  DB AA
 in a, (255)            ;; 0DB9:  DB FF
 in b, (c)              ;; 0DBB:  ED 40
 in c, (c)              ;; 0DBD:  ED 48
 in d, (c)              ;; 0DBF:  ED 50
 in e, (c)              ;; 0DC1:  ED 58
 in h, (c)              ;; 0DC3:  ED 60
 in l, (c)              ;; 0DC5:  ED 68
 in f, (c)              ;; 0DC7:  ED 70
 in a, (c)              ;; 0DC9:  ED 78
 out (0), a             ;; 0DCB:  D3 00
 out (85), a            ;; 0DCD:  D3 55
 out (170), a           ;; 0DCF:  D3 AA
 out (255), a           ;; 0DD1:  D3 FF
 out (c), b             ;; 0DD3:  ED 41
 out (c), c             ;; 0DD5:  ED 49
 out (c), d             ;; 0DD7:  ED 51
 out (c), e             ;; 0DD9:  ED 59
 out (c), h             ;; 0DDB:  ED 61
 out (c), l             ;; 0DDD:  ED 69
 out (c), 0             ;; 0DDF:  ED 71
 out (c), a             ;; 0DE1:  ED 79
 ini                    ;; 0DE3:  ED A2
 inir                   ;; 0DE5:  ED B2
 ind                    ;; 0DE7:  ED AA
 indr                   ;; 0DE9:  ED BA
 outi                   ;; 0DEB:  ED A3
 otir                   ;; 0DED:  ED B3
 outd                   ;; 0DEF:  ED AB
 otdr                   ;; 0DF1:  ED BB
 di                     ;; 0DF3:  F3
 ei                     ;; 0DF4:  FB
 im 0                   ;; 0DF5:  ED 46
 im 1                   ;; 0DF7:  ED 56
 im 2                   ;; 0DF9:  ED 5E
 ld i, a                ;; 0DFB:  ED 47
 ld a, i                ;; 0DFD:  ED 57
 ld r, a                ;; 0DFF:  ED 4F
 ld a, r                ;; 0E01:  ED 5F
 reti                   ;; 0E03:  ED 4D
 retn                   ;; 0E05:  ED 45
