 ld b, b                        ; 40
 altd ld b, b                   ; 76 40
 ld b', b                       ; 76 40
 ld b, c                        ; 41
 altd ld b, c                   ; 76 41
 ld b', c                       ; 76 41
 ld b, d                        ; 42
 altd ld b, d                   ; 76 42
 ld b', d                       ; 76 42
 ld b, e                        ; 43
 altd ld b, e                   ; 76 43
 ld b', e                       ; 76 43
 ld b, h                        ; 44
 altd ld b, h                   ; 76 44
 ld b', h                       ; 76 44
 ld b, l                        ; 45
 altd ld b, l                   ; 76 45
 ld b', l                       ; 76 45
 ld b, a                        ; 47
 altd ld b, a                   ; 76 47
 ld b', a                       ; 76 47
 ld b,  42                      ; 06 2A
 ld b, (42)                     ; 06 2A
 altd ld b,  42                 ; 76 06 2A
 altd ld b, (42)                ; 76 06 2A
 ld b',  42                     ; 76 06 2A
 ld b', (42)                    ; 76 06 2A
 ld b, (hl)                     ; 46
 altd ld b, (hl)                ; 76 46
 ld b', (hl)                    ; 76 46
 ld b, (ix)                     ; DD 46 00
 altd ld b, (ix)                ; 76 DD 46 00
 ld b', (ix)                    ; 76 DD 46 00
 ld b, (ix + 127)               ; DD 46 7F
 ld b, (ix - 128)               ; DD 46 80
 altd ld b, (ix + 127)          ; 76 DD 46 7F
 altd ld b, (ix - 128)          ; 76 DD 46 80
 ld b', (ix + 127)              ; 76 DD 46 7F
 ld b', (ix - 128)              ; 76 DD 46 80
 ld b, (iy)                     ; FD 46 00
 altd ld b, (iy)                ; 76 FD 46 00
 ld b', (iy)                    ; 76 FD 46 00
 ld b, (iy + 127)               ; FD 46 7F
 ld b, (iy - 128)               ; FD 46 80
 altd ld b, (iy + 127)          ; 76 FD 46 7F
 altd ld b, (iy - 128)          ; 76 FD 46 80
 ld b', (iy + 127)              ; 76 FD 46 7F
 ld b', (iy - 128)              ; 76 FD 46 80
 ld (hl), b                     ; 70
 ld (ix), b                     ; DD 70 00
 ld (ix + 127), b               ; DD 70 7F
 ld (ix - 128), b               ; DD 70 80
 ld (iy), b                     ; FD 70 00
 ld (iy + 127), b               ; FD 70 7F
 ld (iy - 128), b               ; FD 70 80
 ld c, b                        ; 48
 altd ld c, b                   ; 76 48
 ld c', b                       ; 76 48
 ld c, c                        ; 49
 altd ld c, c                   ; 76 49
 ld c', c                       ; 76 49
 ld c, d                        ; 4A
 altd ld c, d                   ; 76 4A
 ld c', d                       ; 76 4A
 ld c, e                        ; 4B
 altd ld c, e                   ; 76 4B
 ld c', e                       ; 76 4B
 ld c, h                        ; 4C
 altd ld c, h                   ; 76 4C
 ld c', h                       ; 76 4C
 ld c, l                        ; 4D
 altd ld c, l                   ; 76 4D
 ld c', l                       ; 76 4D
 ld c, a                        ; 4F
 altd ld c, a                   ; 76 4F
 ld c', a                       ; 76 4F
 ld c,  42                      ; 0E 2A
 ld c, (42)                     ; 0E 2A
 altd ld c,  42                 ; 76 0E 2A
 altd ld c, (42)                ; 76 0E 2A
 ld c',  42                     ; 76 0E 2A
 ld c', (42)                    ; 76 0E 2A
 ld c, (hl)                     ; 4E
 altd ld c, (hl)                ; 76 4E
 ld c', (hl)                    ; 76 4E
 ld c, (ix)                     ; DD 4E 00
 altd ld c, (ix)                ; 76 DD 4E 00
 ld c', (ix)                    ; 76 DD 4E 00
 ld c, (ix + 127)               ; DD 4E 7F
 ld c, (ix - 128)               ; DD 4E 80
 altd ld c, (ix + 127)          ; 76 DD 4E 7F
 altd ld c, (ix - 128)          ; 76 DD 4E 80
 ld c', (ix + 127)              ; 76 DD 4E 7F
 ld c', (ix - 128)              ; 76 DD 4E 80
 ld c, (iy)                     ; FD 4E 00
 altd ld c, (iy)                ; 76 FD 4E 00
 ld c', (iy)                    ; 76 FD 4E 00
 ld c, (iy + 127)               ; FD 4E 7F
 ld c, (iy - 128)               ; FD 4E 80
 altd ld c, (iy + 127)          ; 76 FD 4E 7F
 altd ld c, (iy - 128)          ; 76 FD 4E 80
 ld c', (iy + 127)              ; 76 FD 4E 7F
 ld c', (iy - 128)              ; 76 FD 4E 80
 ld (hl), c                     ; 71
 ld (ix), c                     ; DD 71 00
 ld (ix + 127), c               ; DD 71 7F
 ld (ix - 128), c               ; DD 71 80
 ld (iy), c                     ; FD 71 00
 ld (iy + 127), c               ; FD 71 7F
 ld (iy - 128), c               ; FD 71 80
 ld d, b                        ; 50
 altd ld d, b                   ; 76 50
 ld d', b                       ; 76 50
 ld d, c                        ; 51
 altd ld d, c                   ; 76 51
 ld d', c                       ; 76 51
 ld d, d                        ; 52
 altd ld d, d                   ; 76 52
 ld d', d                       ; 76 52
 ld d, e                        ; 53
 altd ld d, e                   ; 76 53
 ld d', e                       ; 76 53
 ld d, h                        ; 54
 altd ld d, h                   ; 76 54
 ld d', h                       ; 76 54
 ld d, l                        ; 55
 altd ld d, l                   ; 76 55
 ld d', l                       ; 76 55
 ld d, a                        ; 57
 altd ld d, a                   ; 76 57
 ld d', a                       ; 76 57
 ld d,  42                      ; 16 2A
 ld d, (42)                     ; 16 2A
 altd ld d,  42                 ; 76 16 2A
 altd ld d, (42)                ; 76 16 2A
 ld d',  42                     ; 76 16 2A
 ld d', (42)                    ; 76 16 2A
 ld d, (hl)                     ; 56
 altd ld d, (hl)                ; 76 56
 ld d', (hl)                    ; 76 56
 ld d, (ix)                     ; DD 56 00
 altd ld d, (ix)                ; 76 DD 56 00
 ld d', (ix)                    ; 76 DD 56 00
 ld d, (ix + 127)               ; DD 56 7F
 ld d, (ix - 128)               ; DD 56 80
 altd ld d, (ix + 127)          ; 76 DD 56 7F
 altd ld d, (ix - 128)          ; 76 DD 56 80
 ld d', (ix + 127)              ; 76 DD 56 7F
 ld d', (ix - 128)              ; 76 DD 56 80
 ld d, (iy)                     ; FD 56 00
 altd ld d, (iy)                ; 76 FD 56 00
 ld d', (iy)                    ; 76 FD 56 00
 ld d, (iy + 127)               ; FD 56 7F
 ld d, (iy - 128)               ; FD 56 80
 altd ld d, (iy + 127)          ; 76 FD 56 7F
 altd ld d, (iy - 128)          ; 76 FD 56 80
 ld d', (iy + 127)              ; 76 FD 56 7F
 ld d', (iy - 128)              ; 76 FD 56 80
 ld (hl), d                     ; 72
 ld (ix), d                     ; DD 72 00
 ld (ix + 127), d               ; DD 72 7F
 ld (ix - 128), d               ; DD 72 80
 ld (iy), d                     ; FD 72 00
 ld (iy + 127), d               ; FD 72 7F
 ld (iy - 128), d               ; FD 72 80
 ld e, b                        ; 58
 altd ld e, b                   ; 76 58
 ld e', b                       ; 76 58
 ld e, c                        ; 59
 altd ld e, c                   ; 76 59
 ld e', c                       ; 76 59
 ld e, d                        ; 5A
 altd ld e, d                   ; 76 5A
 ld e', d                       ; 76 5A
 ld e, e                        ; 5B
 altd ld e, e                   ; 76 5B
 ld e', e                       ; 76 5B
 ld e, h                        ; 5C
 altd ld e, h                   ; 76 5C
 ld e', h                       ; 76 5C
 ld e, l                        ; 5D
 altd ld e, l                   ; 76 5D
 ld e', l                       ; 76 5D
 ld e, a                        ; 5F
 altd ld e, a                   ; 76 5F
 ld e', a                       ; 76 5F
 ld e,  42                      ; 1E 2A
 ld e, (42)                     ; 1E 2A
 altd ld e,  42                 ; 76 1E 2A
 altd ld e, (42)                ; 76 1E 2A
 ld e',  42                     ; 76 1E 2A
 ld e', (42)                    ; 76 1E 2A
 ld e, (hl)                     ; 5E
 altd ld e, (hl)                ; 76 5E
 ld e', (hl)                    ; 76 5E
 ld e, (ix)                     ; DD 5E 00
 altd ld e, (ix)                ; 76 DD 5E 00
 ld e', (ix)                    ; 76 DD 5E 00
 ld e, (ix + 127)               ; DD 5E 7F
 ld e, (ix - 128)               ; DD 5E 80
 altd ld e, (ix + 127)          ; 76 DD 5E 7F
 altd ld e, (ix - 128)          ; 76 DD 5E 80
 ld e', (ix + 127)              ; 76 DD 5E 7F
 ld e', (ix - 128)              ; 76 DD 5E 80
 ld e, (iy)                     ; FD 5E 00
 altd ld e, (iy)                ; 76 FD 5E 00
 ld e', (iy)                    ; 76 FD 5E 00
 ld e, (iy + 127)               ; FD 5E 7F
 ld e, (iy - 128)               ; FD 5E 80
 altd ld e, (iy + 127)          ; 76 FD 5E 7F
 altd ld e, (iy - 128)          ; 76 FD 5E 80
 ld e', (iy + 127)              ; 76 FD 5E 7F
 ld e', (iy - 128)              ; 76 FD 5E 80
 ld (hl), e                     ; 73
 ld (ix), e                     ; DD 73 00
 ld (ix + 127), e               ; DD 73 7F
 ld (ix - 128), e               ; DD 73 80
 ld (iy), e                     ; FD 73 00
 ld (iy + 127), e               ; FD 73 7F
 ld (iy - 128), e               ; FD 73 80
 ld h, b                        ; 60
 altd ld h, b                   ; 76 60
 ld h', b                       ; 76 60
 ld h, c                        ; 61
 altd ld h, c                   ; 76 61
 ld h', c                       ; 76 61
 ld h, d                        ; 62
 altd ld h, d                   ; 76 62
 ld h', d                       ; 76 62
 ld h, e                        ; 63
 altd ld h, e                   ; 76 63
 ld h', e                       ; 76 63
 ld h, h                        ; 64
 altd ld h, h                   ; 76 64
 ld h', h                       ; 76 64
 ld h, l                        ; 65
 altd ld h, l                   ; 76 65
 ld h', l                       ; 76 65
 ld h, a                        ; 67
 altd ld h, a                   ; 76 67
 ld h', a                       ; 76 67
 ld h,  42                      ; 26 2A
 ld h, (42)                     ; 26 2A
 altd ld h,  42                 ; 76 26 2A
 altd ld h, (42)                ; 76 26 2A
 ld h',  42                     ; 76 26 2A
 ld h', (42)                    ; 76 26 2A
 ld h, (hl)                     ; 66
 altd ld h, (hl)                ; 76 66
 ld h', (hl)                    ; 76 66
 ld h, (ix)                     ; DD 66 00
 altd ld h, (ix)                ; 76 DD 66 00
 ld h', (ix)                    ; 76 DD 66 00
 ld h, (ix + 127)               ; DD 66 7F
 ld h, (ix - 128)               ; DD 66 80
 altd ld h, (ix + 127)          ; 76 DD 66 7F
 altd ld h, (ix - 128)          ; 76 DD 66 80
 ld h', (ix + 127)              ; 76 DD 66 7F
 ld h', (ix - 128)              ; 76 DD 66 80
 ld h, (iy)                     ; FD 66 00
 altd ld h, (iy)                ; 76 FD 66 00
 ld h', (iy)                    ; 76 FD 66 00
 ld h, (iy + 127)               ; FD 66 7F
 ld h, (iy - 128)               ; FD 66 80
 altd ld h, (iy + 127)          ; 76 FD 66 7F
 altd ld h, (iy - 128)          ; 76 FD 66 80
 ld h', (iy + 127)              ; 76 FD 66 7F
 ld h', (iy - 128)              ; 76 FD 66 80
 ld (hl), h                     ; 74
 ld (ix), h                     ; DD 74 00
 ld (ix + 127), h               ; DD 74 7F
 ld (ix - 128), h               ; DD 74 80
 ld (iy), h                     ; FD 74 00
 ld (iy + 127), h               ; FD 74 7F
 ld (iy - 128), h               ; FD 74 80
 ld l, b                        ; 68
 altd ld l, b                   ; 76 68
 ld l', b                       ; 76 68
 ld l, c                        ; 69
 altd ld l, c                   ; 76 69
 ld l', c                       ; 76 69
 ld l, d                        ; 6A
 altd ld l, d                   ; 76 6A
 ld l', d                       ; 76 6A
 ld l, e                        ; 6B
 altd ld l, e                   ; 76 6B
 ld l', e                       ; 76 6B
 ld l, h                        ; 6C
 altd ld l, h                   ; 76 6C
 ld l', h                       ; 76 6C
 ld l, l                        ; 6D
 altd ld l, l                   ; 76 6D
 ld l', l                       ; 76 6D
 ld l, a                        ; 6F
 altd ld l, a                   ; 76 6F
 ld l', a                       ; 76 6F
 ld l,  42                      ; 2E 2A
 ld l, (42)                     ; 2E 2A
 altd ld l,  42                 ; 76 2E 2A
 altd ld l, (42)                ; 76 2E 2A
 ld l',  42                     ; 76 2E 2A
 ld l', (42)                    ; 76 2E 2A
 ld l, (hl)                     ; 6E
 altd ld l, (hl)                ; 76 6E
 ld l', (hl)                    ; 76 6E
 ld l, (ix)                     ; DD 6E 00
 altd ld l, (ix)                ; 76 DD 6E 00
 ld l', (ix)                    ; 76 DD 6E 00
 ld l, (ix + 127)               ; DD 6E 7F
 ld l, (ix - 128)               ; DD 6E 80
 altd ld l, (ix + 127)          ; 76 DD 6E 7F
 altd ld l, (ix - 128)          ; 76 DD 6E 80
 ld l', (ix + 127)              ; 76 DD 6E 7F
 ld l', (ix - 128)              ; 76 DD 6E 80
 ld l, (iy)                     ; FD 6E 00
 altd ld l, (iy)                ; 76 FD 6E 00
 ld l', (iy)                    ; 76 FD 6E 00
 ld l, (iy + 127)               ; FD 6E 7F
 ld l, (iy - 128)               ; FD 6E 80
 altd ld l, (iy + 127)          ; 76 FD 6E 7F
 altd ld l, (iy - 128)          ; 76 FD 6E 80
 ld l', (iy + 127)              ; 76 FD 6E 7F
 ld l', (iy - 128)              ; 76 FD 6E 80
 ld (hl), l                     ; 75
 ld (ix), l                     ; DD 75 00
 ld (ix + 127), l               ; DD 75 7F
 ld (ix - 128), l               ; DD 75 80
 ld (iy), l                     ; FD 75 00
 ld (iy + 127), l               ; FD 75 7F
 ld (iy - 128), l               ; FD 75 80
 ld a, b                        ; 78
 altd ld a, b                   ; 76 78
 ld a', b                       ; 76 78
 ld a, c                        ; 79
 altd ld a, c                   ; 76 79
 ld a', c                       ; 76 79
 ld a, d                        ; 7A
 altd ld a, d                   ; 76 7A
 ld a', d                       ; 76 7A
 ld a, e                        ; 7B
 altd ld a, e                   ; 76 7B
 ld a', e                       ; 76 7B
 ld a, h                        ; 7C
 altd ld a, h                   ; 76 7C
 ld a', h                       ; 76 7C
 ld a, l                        ; 7D
 altd ld a, l                   ; 76 7D
 ld a', l                       ; 76 7D
 ld a, a                        ; 7F
 altd ld a, a                   ; 76 7F
 ld a', a                       ; 76 7F
 ld a, 42                       ; 3E 2A
 ld a, (256)                    ; 3A 00 01
 altd ld a, 42                  ; 76 3E 2A
 altd ld a, (256)               ; 76 3A 00 01
 ld a', 42                      ; 76 3E 2A
 ld a', (256)                   ; 76 3A 00 01
 ld a, (hl)                     ; 7E
 altd ld a, (hl)                ; 76 7E
 ld a', (hl)                    ; 76 7E
 ld a, (ix)                     ; DD 7E 00
 altd ld a, (ix)                ; 76 DD 7E 00
 ld a', (ix)                    ; 76 DD 7E 00
 ld a, (ix + 127)               ; DD 7E 7F
 ld a, (ix - 128)               ; DD 7E 80
 altd ld a, (ix + 127)          ; 76 DD 7E 7F
 altd ld a, (ix - 128)          ; 76 DD 7E 80
 ld a', (ix + 127)              ; 76 DD 7E 7F
 ld a', (ix - 128)              ; 76 DD 7E 80
 ld a, (iy)                     ; FD 7E 00
 altd ld a, (iy)                ; 76 FD 7E 00
 ld a', (iy)                    ; 76 FD 7E 00
 ld a, (iy + 127)               ; FD 7E 7F
 ld a, (iy - 128)               ; FD 7E 80
 altd ld a, (iy + 127)          ; 76 FD 7E 7F
 altd ld a, (iy - 128)          ; 76 FD 7E 80
 ld a', (iy + 127)              ; 76 FD 7E 7F
 ld a', (iy - 128)              ; 76 FD 7E 80
 ld (hl), a                     ; 77
 ld (ix), a                     ; DD 77 00
 ld (ix + 127), a               ; DD 77 7F
 ld (ix - 128), a               ; DD 77 80
 ld (iy), a                     ; FD 77 00
 ld (iy + 127), a               ; FD 77 7F
 ld (iy - 128), a               ; FD 77 80
 ld (hl), 42                    ; 36 2A
 ld (ix), 42                    ; DD 36 00 2A
 ld (ix + 127), 42              ; DD 36 7F 2A
 ld (ix - 128), 42              ; DD 36 80 2A
 ld (iy), 42                    ; FD 36 00 2A
 ld (iy + 127), 42              ; FD 36 7F 2A
 ld (iy - 128), 42              ; FD 36 80 2A
 ld (bc), a                     ; 02
 ld a, (bc)                     ; 0A
 altd ld a, (bc)                ; 76 0A
 ld a', (bc)                    ; 76 0A
 ld (de), a                     ; 12
 ld a, (de)                     ; 1A
 altd ld a, (de)                ; 76 1A
 ld a', (de)                    ; 76 1A
 ld (256), a                    ; 32 00 01
