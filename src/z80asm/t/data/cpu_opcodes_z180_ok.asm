 ld (4660), a           ;; 32 34 12
 ld (bc), a             ;; 02
 ld (de), a             ;; 12
 ld (hl), 42            ;; 36 2A
 ld (hl), a             ;; 77
 ld (hl), b             ;; 70
 ld (hl), c             ;; 71
 ld (hl), d             ;; 72
 ld (hl), e             ;; 73
 ld (hl), h             ;; 74
 ld (hl), l             ;; 75
 ld (ix), 42            ;; DD 36 00 2A
 ld (ix), a             ;; DD 77 00
 ld (ix), b             ;; DD 70 00
 ld (ix), c             ;; DD 71 00
 ld (ix), d             ;; DD 72 00
 ld (ix), e             ;; DD 73 00
 ld (ix), h             ;; DD 74 00
 ld (ix), l             ;; DD 75 00
 ld (ix+127), 42        ;; DD 36 7F 2A
 ld (ix+127), a         ;; DD 77 7F
 ld (ix+127), b         ;; DD 70 7F
 ld (ix+127), c         ;; DD 71 7F
 ld (ix+127), d         ;; DD 72 7F
 ld (ix+127), e         ;; DD 73 7F
 ld (ix+127), h         ;; DD 74 7F
 ld (ix+127), l         ;; DD 75 7F
 ld (iy), 42            ;; FD 36 00 2A
 ld (iy), a             ;; FD 77 00
 ld (iy), b             ;; FD 70 00
 ld (iy), c             ;; FD 71 00
 ld (iy), d             ;; FD 72 00
 ld (iy), e             ;; FD 73 00
 ld (iy), h             ;; FD 74 00
 ld (iy), l             ;; FD 75 00
 ld (iy+127), 42        ;; FD 36 7F 2A
 ld (iy+127), a         ;; FD 77 7F
 ld (iy+127), b         ;; FD 70 7F
 ld (iy+127), c         ;; FD 71 7F
 ld (iy+127), d         ;; FD 72 7F
 ld (iy+127), e         ;; FD 73 7F
 ld (iy+127), h         ;; FD 74 7F
 ld (iy+127), l         ;; FD 75 7F
 ld a, (4660)           ;; 3A 34 12
 ld a, (bc)             ;; 0A
 ld a, (de)             ;; 1A
 ld a, (hl)             ;; 7E
 ld a, (ix)             ;; DD 7E 00
 ld a, (ix+127)         ;; DD 7E 7F
 ld a, (iy)             ;; FD 7E 00
 ld a, (iy+127)         ;; FD 7E 7F
 ld a, 42               ;; 3E 2A
 ld a, a                ;; 7F
 ld a, b                ;; 78
 ld a, c                ;; 79
 ld a, d                ;; 7A
 ld a, e                ;; 7B
 ld a, h                ;; 7C
 ld a, l                ;; 7D
 ld b, (hl)             ;; 46
 ld b, (ix)             ;; DD 46 00
 ld b, (ix+127)         ;; DD 46 7F
 ld b, (iy)             ;; FD 46 00
 ld b, (iy+127)         ;; FD 46 7F
 ld b, 42               ;; 06 2A
 ld b, a                ;; 47
 ld b, b                ;; 40
 ld b, c                ;; 41
 ld b, d                ;; 42
 ld b, e                ;; 43
 ld b, h                ;; 44
 ld b, l                ;; 45
 ld c, (hl)             ;; 4E
 ld c, (ix)             ;; DD 4E 00
 ld c, (ix+127)         ;; DD 4E 7F
 ld c, (iy)             ;; FD 4E 00
 ld c, (iy+127)         ;; FD 4E 7F
 ld c, 42               ;; 0E 2A
 ld c, a                ;; 4F
 ld c, b                ;; 48
 ld c, c                ;; 49
 ld c, d                ;; 4A
 ld c, e                ;; 4B
 ld c, h                ;; 4C
 ld c, l                ;; 4D
 ld d, (hl)             ;; 56
 ld d, (ix)             ;; DD 56 00
 ld d, (ix+127)         ;; DD 56 7F
 ld d, (iy)             ;; FD 56 00
 ld d, (iy+127)         ;; FD 56 7F
 ld d, 42               ;; 16 2A
 ld d, a                ;; 57
 ld d, b                ;; 50
 ld d, c                ;; 51
 ld d, d                ;; 52
 ld d, e                ;; 53
 ld d, h                ;; 54
 ld d, l                ;; 55
 ld e, (hl)             ;; 5E
 ld e, (ix)             ;; DD 5E 00
 ld e, (ix+127)         ;; DD 5E 7F
 ld e, (iy)             ;; FD 5E 00
 ld e, (iy+127)         ;; FD 5E 7F
 ld e, 42               ;; 1E 2A
 ld e, a                ;; 5F
 ld e, b                ;; 58
 ld e, c                ;; 59
 ld e, d                ;; 5A
 ld e, e                ;; 5B
 ld e, h                ;; 5C
 ld e, l                ;; 5D
 ld h, (hl)             ;; 66
 ld h, (ix)             ;; DD 66 00
 ld h, (ix+127)         ;; DD 66 7F
 ld h, (iy)             ;; FD 66 00
 ld h, (iy+127)         ;; FD 66 7F
 ld h, 42               ;; 26 2A
 ld h, a                ;; 67
 ld h, b                ;; 60
 ld h, c                ;; 61
 ld h, d                ;; 62
 ld h, e                ;; 63
 ld h, h                ;; 64
 ld h, l                ;; 65
 ld l, (hl)             ;; 6E
 ld l, (ix)             ;; DD 6E 00
 ld l, (ix+127)         ;; DD 6E 7F
 ld l, (iy)             ;; FD 6E 00
 ld l, (iy+127)         ;; FD 6E 7F
 ld l, 42               ;; 2E 2A
 ld l, a                ;; 6F
 ld l, b                ;; 68
 ld l, c                ;; 69
 ld l, d                ;; 6A
 ld l, e                ;; 6B
 ld l, h                ;; 6C
 ld l, l                ;; 6D
