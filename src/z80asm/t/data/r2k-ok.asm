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
 add a, b                       ; 80
 add b                          ; 80
 altd add a, b                  ; 76 80
 altd add b                     ; 76 80
 add a', b                      ; 76 80
 add a, c                       ; 81
 add c                          ; 81
 altd add a, c                  ; 76 81
 altd add c                     ; 76 81
 add a', c                      ; 76 81
 add a, d                       ; 82
 add d                          ; 82
 altd add a, d                  ; 76 82
 altd add d                     ; 76 82
 add a', d                      ; 76 82
 add a, e                       ; 83
 add e                          ; 83
 altd add a, e                  ; 76 83
 altd add e                     ; 76 83
 add a', e                      ; 76 83
 add a, h                       ; 84
 add h                          ; 84
 altd add a, h                  ; 76 84
 altd add h                     ; 76 84
 add a', h                      ; 76 84
 add a, l                       ; 85
 add l                          ; 85
 altd add a, l                  ; 76 85
 altd add l                     ; 76 85
 add a', l                      ; 76 85
 add a, a                       ; 87
 add a                          ; 87
 altd add a, a                  ; 76 87
 altd add a                     ; 76 87
 add a', a                      ; 76 87
 add a, (hl)                    ; 86
 add (hl)                       ; 86
 altd add a, (hl)               ; 76 86
 altd add (hl)                  ; 76 86
 add a', (hl)                   ; 76 86
 add a, (ix)                    ; DD 86 00
 add a, (ix + 127)              ; DD 86 7F
 add a, (ix - 128)              ; DD 86 80
 add (ix)                       ; DD 86 00
 add (ix + 127)                 ; DD 86 7F
 add (ix - 128)                 ; DD 86 80
 altd add a, (ix)               ; 76 DD 86 00
 altd add a, (ix + 127)         ; 76 DD 86 7F
 altd add a, (ix - 128)         ; 76 DD 86 80
 altd add (ix)                  ; 76 DD 86 00
 altd add (ix + 127)            ; 76 DD 86 7F
 altd add (ix - 128)            ; 76 DD 86 80
 add a', (ix)                   ; 76 DD 86 00
 add a', (ix + 127)             ; 76 DD 86 7F
 add a', (ix - 128)             ; 76 DD 86 80
 add a, (iy)                    ; FD 86 00
 add a, (iy + 127)              ; FD 86 7F
 add a, (iy - 128)              ; FD 86 80
 add (iy)                       ; FD 86 00
 add (iy + 127)                 ; FD 86 7F
 add (iy - 128)                 ; FD 86 80
 altd add a, (iy)               ; 76 FD 86 00
 altd add a, (iy + 127)         ; 76 FD 86 7F
 altd add a, (iy - 128)         ; 76 FD 86 80
 altd add (iy)                  ; 76 FD 86 00
 altd add (iy + 127)            ; 76 FD 86 7F
 altd add (iy - 128)            ; 76 FD 86 80
 add a', (iy)                   ; 76 FD 86 00
 add a', (iy + 127)             ; 76 FD 86 7F
 add a', (iy - 128)             ; 76 FD 86 80
 adc a, b                       ; 88
 adc b                          ; 88
 altd adc a, b                  ; 76 88
 altd adc b                     ; 76 88
 adc a', b                      ; 76 88
 adc a, c                       ; 89
 adc c                          ; 89
 altd adc a, c                  ; 76 89
 altd adc c                     ; 76 89
 adc a', c                      ; 76 89
 adc a, d                       ; 8A
 adc d                          ; 8A
 altd adc a, d                  ; 76 8A
 altd adc d                     ; 76 8A
 adc a', d                      ; 76 8A
 adc a, e                       ; 8B
 adc e                          ; 8B
 altd adc a, e                  ; 76 8B
 altd adc e                     ; 76 8B
 adc a', e                      ; 76 8B
 adc a, h                       ; 8C
 adc h                          ; 8C
 altd adc a, h                  ; 76 8C
 altd adc h                     ; 76 8C
 adc a', h                      ; 76 8C
 adc a, l                       ; 8D
 adc l                          ; 8D
 altd adc a, l                  ; 76 8D
 altd adc l                     ; 76 8D
 adc a', l                      ; 76 8D
 adc a, a                       ; 8F
 adc a                          ; 8F
 altd adc a, a                  ; 76 8F
 altd adc a                     ; 76 8F
 adc a', a                      ; 76 8F
 adc a, (hl)                    ; 8E
 adc (hl)                       ; 8E
 altd adc a, (hl)               ; 76 8E
 altd adc (hl)                  ; 76 8E
 adc a', (hl)                   ; 76 8E
 adc a, (ix)                    ; DD 8E 00
 adc a, (ix + 127)              ; DD 8E 7F
 adc a, (ix - 128)              ; DD 8E 80
 adc (ix)                       ; DD 8E 00
 adc (ix + 127)                 ; DD 8E 7F
 adc (ix - 128)                 ; DD 8E 80
 altd adc a, (ix)               ; 76 DD 8E 00
 altd adc a, (ix + 127)         ; 76 DD 8E 7F
 altd adc a, (ix - 128)         ; 76 DD 8E 80
 altd adc (ix)                  ; 76 DD 8E 00
 altd adc (ix + 127)            ; 76 DD 8E 7F
 altd adc (ix - 128)            ; 76 DD 8E 80
 adc a', (ix)                   ; 76 DD 8E 00
 adc a', (ix + 127)             ; 76 DD 8E 7F
 adc a', (ix - 128)             ; 76 DD 8E 80
 adc a, (iy)                    ; FD 8E 00
 adc a, (iy + 127)              ; FD 8E 7F
 adc a, (iy - 128)              ; FD 8E 80
 adc (iy)                       ; FD 8E 00
 adc (iy + 127)                 ; FD 8E 7F
 adc (iy - 128)                 ; FD 8E 80
 altd adc a, (iy)               ; 76 FD 8E 00
 altd adc a, (iy + 127)         ; 76 FD 8E 7F
 altd adc a, (iy - 128)         ; 76 FD 8E 80
 altd adc (iy)                  ; 76 FD 8E 00
 altd adc (iy + 127)            ; 76 FD 8E 7F
 altd adc (iy - 128)            ; 76 FD 8E 80
 adc a', (iy)                   ; 76 FD 8E 00
 adc a', (iy + 127)             ; 76 FD 8E 7F
 adc a', (iy - 128)             ; 76 FD 8E 80
 sub a, b                       ; 90
 sub b                          ; 90
 altd sub a, b                  ; 76 90
 altd sub b                     ; 76 90
 sub a', b                      ; 76 90
 sub a, c                       ; 91
 sub c                          ; 91
 altd sub a, c                  ; 76 91
 altd sub c                     ; 76 91
 sub a', c                      ; 76 91
 sub a, d                       ; 92
 sub d                          ; 92
 altd sub a, d                  ; 76 92
 altd sub d                     ; 76 92
 sub a', d                      ; 76 92
 sub a, e                       ; 93
 sub e                          ; 93
 altd sub a, e                  ; 76 93
 altd sub e                     ; 76 93
 sub a', e                      ; 76 93
 sub a, h                       ; 94
 sub h                          ; 94
 altd sub a, h                  ; 76 94
 altd sub h                     ; 76 94
 sub a', h                      ; 76 94
 sub a, l                       ; 95
 sub l                          ; 95
 altd sub a, l                  ; 76 95
 altd sub l                     ; 76 95
 sub a', l                      ; 76 95
 sub a, a                       ; 97
 sub a                          ; 97
 altd sub a, a                  ; 76 97
 altd sub a                     ; 76 97
 sub a', a                      ; 76 97
 sub a, (hl)                    ; 96
 sub (hl)                       ; 96
 altd sub a, (hl)               ; 76 96
 altd sub (hl)                  ; 76 96
 sub a', (hl)                   ; 76 96
 sub a, (ix)                    ; DD 96 00
 sub a, (ix + 127)              ; DD 96 7F
 sub a, (ix - 128)              ; DD 96 80
 sub (ix)                       ; DD 96 00
 sub (ix + 127)                 ; DD 96 7F
 sub (ix - 128)                 ; DD 96 80
 altd sub a, (ix)               ; 76 DD 96 00
 altd sub a, (ix + 127)         ; 76 DD 96 7F
 altd sub a, (ix - 128)         ; 76 DD 96 80
 altd sub (ix)                  ; 76 DD 96 00
 altd sub (ix + 127)            ; 76 DD 96 7F
 altd sub (ix - 128)            ; 76 DD 96 80
 sub a', (ix)                   ; 76 DD 96 00
 sub a', (ix + 127)             ; 76 DD 96 7F
 sub a', (ix - 128)             ; 76 DD 96 80
 sub a, (iy)                    ; FD 96 00
 sub a, (iy + 127)              ; FD 96 7F
 sub a, (iy - 128)              ; FD 96 80
 sub (iy)                       ; FD 96 00
 sub (iy + 127)                 ; FD 96 7F
 sub (iy - 128)                 ; FD 96 80
 altd sub a, (iy)               ; 76 FD 96 00
 altd sub a, (iy + 127)         ; 76 FD 96 7F
 altd sub a, (iy - 128)         ; 76 FD 96 80
 altd sub (iy)                  ; 76 FD 96 00
 altd sub (iy + 127)            ; 76 FD 96 7F
 altd sub (iy - 128)            ; 76 FD 96 80
 sub a', (iy)                   ; 76 FD 96 00
 sub a', (iy + 127)             ; 76 FD 96 7F
 sub a', (iy - 128)             ; 76 FD 96 80
 sbc a, b                       ; 98
 sbc b                          ; 98
 altd sbc a, b                  ; 76 98
 altd sbc b                     ; 76 98
 sbc a', b                      ; 76 98
 sbc a, c                       ; 99
 sbc c                          ; 99
 altd sbc a, c                  ; 76 99
 altd sbc c                     ; 76 99
 sbc a', c                      ; 76 99
 sbc a, d                       ; 9A
 sbc d                          ; 9A
 altd sbc a, d                  ; 76 9A
 altd sbc d                     ; 76 9A
 sbc a', d                      ; 76 9A
 sbc a, e                       ; 9B
 sbc e                          ; 9B
 altd sbc a, e                  ; 76 9B
 altd sbc e                     ; 76 9B
 sbc a', e                      ; 76 9B
 sbc a, h                       ; 9C
 sbc h                          ; 9C
 altd sbc a, h                  ; 76 9C
 altd sbc h                     ; 76 9C
 sbc a', h                      ; 76 9C
 sbc a, l                       ; 9D
 sbc l                          ; 9D
 altd sbc a, l                  ; 76 9D
 altd sbc l                     ; 76 9D
 sbc a', l                      ; 76 9D
 sbc a, a                       ; 9F
 sbc a                          ; 9F
 altd sbc a, a                  ; 76 9F
 altd sbc a                     ; 76 9F
 sbc a', a                      ; 76 9F
 sbc a, (hl)                    ; 9E
 sbc (hl)                       ; 9E
 altd sbc a, (hl)               ; 76 9E
 altd sbc (hl)                  ; 76 9E
 sbc a', (hl)                   ; 76 9E
 sbc a, (ix)                    ; DD 9E 00
 sbc a, (ix + 127)              ; DD 9E 7F
 sbc a, (ix - 128)              ; DD 9E 80
 sbc (ix)                       ; DD 9E 00
 sbc (ix + 127)                 ; DD 9E 7F
 sbc (ix - 128)                 ; DD 9E 80
 altd sbc a, (ix)               ; 76 DD 9E 00
 altd sbc a, (ix + 127)         ; 76 DD 9E 7F
 altd sbc a, (ix - 128)         ; 76 DD 9E 80
 altd sbc (ix)                  ; 76 DD 9E 00
 altd sbc (ix + 127)            ; 76 DD 9E 7F
 altd sbc (ix - 128)            ; 76 DD 9E 80
 sbc a', (ix)                   ; 76 DD 9E 00
 sbc a', (ix + 127)             ; 76 DD 9E 7F
 sbc a', (ix - 128)             ; 76 DD 9E 80
 sbc a, (iy)                    ; FD 9E 00
 sbc a, (iy + 127)              ; FD 9E 7F
 sbc a, (iy - 128)              ; FD 9E 80
 sbc (iy)                       ; FD 9E 00
 sbc (iy + 127)                 ; FD 9E 7F
 sbc (iy - 128)                 ; FD 9E 80
 altd sbc a, (iy)               ; 76 FD 9E 00
 altd sbc a, (iy + 127)         ; 76 FD 9E 7F
 altd sbc a, (iy - 128)         ; 76 FD 9E 80
 altd sbc (iy)                  ; 76 FD 9E 00
 altd sbc (iy + 127)            ; 76 FD 9E 7F
 altd sbc (iy - 128)            ; 76 FD 9E 80
 sbc a', (iy)                   ; 76 FD 9E 00
 sbc a', (iy + 127)             ; 76 FD 9E 7F
 sbc a', (iy - 128)             ; 76 FD 9E 80
 and a, b                       ; A0
 and b                          ; A0
 altd and a, b                  ; 76 A0
 altd and b                     ; 76 A0
 and a', b                      ; 76 A0
 and a, c                       ; A1
 and c                          ; A1
 altd and a, c                  ; 76 A1
 altd and c                     ; 76 A1
 and a', c                      ; 76 A1
 and a, d                       ; A2
 and d                          ; A2
 altd and a, d                  ; 76 A2
 altd and d                     ; 76 A2
 and a', d                      ; 76 A2
 and a, e                       ; A3
 and e                          ; A3
 altd and a, e                  ; 76 A3
 altd and e                     ; 76 A3
 and a', e                      ; 76 A3
 and a, h                       ; A4
 and h                          ; A4
 altd and a, h                  ; 76 A4
 altd and h                     ; 76 A4
 and a', h                      ; 76 A4
 and a, l                       ; A5
 and l                          ; A5
 altd and a, l                  ; 76 A5
 altd and l                     ; 76 A5
 and a', l                      ; 76 A5
 and a, a                       ; A7
 and a                          ; A7
 altd and a, a                  ; 76 A7
 altd and a                     ; 76 A7
 and a', a                      ; 76 A7
 and a, (hl)                    ; A6
 and (hl)                       ; A6
 altd and a, (hl)               ; 76 A6
 altd and (hl)                  ; 76 A6
 and a', (hl)                   ; 76 A6
 and a, (ix)                    ; DD A6 00
 and a, (ix + 127)              ; DD A6 7F
 and a, (ix - 128)              ; DD A6 80
 and (ix)                       ; DD A6 00
 and (ix + 127)                 ; DD A6 7F
 and (ix - 128)                 ; DD A6 80
 altd and a, (ix)               ; 76 DD A6 00
 altd and a, (ix + 127)         ; 76 DD A6 7F
 altd and a, (ix - 128)         ; 76 DD A6 80
 altd and (ix)                  ; 76 DD A6 00
 altd and (ix + 127)            ; 76 DD A6 7F
 altd and (ix - 128)            ; 76 DD A6 80
 and a', (ix)                   ; 76 DD A6 00
 and a', (ix + 127)             ; 76 DD A6 7F
 and a', (ix - 128)             ; 76 DD A6 80
 and a, (iy)                    ; FD A6 00
 and a, (iy + 127)              ; FD A6 7F
 and a, (iy - 128)              ; FD A6 80
 and (iy)                       ; FD A6 00
 and (iy + 127)                 ; FD A6 7F
 and (iy - 128)                 ; FD A6 80
 altd and a, (iy)               ; 76 FD A6 00
 altd and a, (iy + 127)         ; 76 FD A6 7F
 altd and a, (iy - 128)         ; 76 FD A6 80
 altd and (iy)                  ; 76 FD A6 00
 altd and (iy + 127)            ; 76 FD A6 7F
 altd and (iy - 128)            ; 76 FD A6 80
 and a', (iy)                   ; 76 FD A6 00
 and a', (iy + 127)             ; 76 FD A6 7F
 and a', (iy - 128)             ; 76 FD A6 80
 xor a, b                       ; A8
 xor b                          ; A8
 altd xor a, b                  ; 76 A8
 altd xor b                     ; 76 A8
 xor a', b                      ; 76 A8
 xor a, c                       ; A9
 xor c                          ; A9
 altd xor a, c                  ; 76 A9
 altd xor c                     ; 76 A9
 xor a', c                      ; 76 A9
 xor a, d                       ; AA
 xor d                          ; AA
 altd xor a, d                  ; 76 AA
 altd xor d                     ; 76 AA
 xor a', d                      ; 76 AA
 xor a, e                       ; AB
 xor e                          ; AB
 altd xor a, e                  ; 76 AB
 altd xor e                     ; 76 AB
 xor a', e                      ; 76 AB
 xor a, h                       ; AC
 xor h                          ; AC
 altd xor a, h                  ; 76 AC
 altd xor h                     ; 76 AC
 xor a', h                      ; 76 AC
 xor a, l                       ; AD
 xor l                          ; AD
 altd xor a, l                  ; 76 AD
 altd xor l                     ; 76 AD
 xor a', l                      ; 76 AD
 xor a, a                       ; AF
 xor a                          ; AF
 altd xor a, a                  ; 76 AF
 altd xor a                     ; 76 AF
 xor a', a                      ; 76 AF
 xor a, (hl)                    ; AE
 xor (hl)                       ; AE
 altd xor a, (hl)               ; 76 AE
 altd xor (hl)                  ; 76 AE
 xor a', (hl)                   ; 76 AE
 xor a, (ix)                    ; DD AE 00
 xor a, (ix + 127)              ; DD AE 7F
 xor a, (ix - 128)              ; DD AE 80
 xor (ix)                       ; DD AE 00
 xor (ix + 127)                 ; DD AE 7F
 xor (ix - 128)                 ; DD AE 80
 altd xor a, (ix)               ; 76 DD AE 00
 altd xor a, (ix + 127)         ; 76 DD AE 7F
 altd xor a, (ix - 128)         ; 76 DD AE 80
 altd xor (ix)                  ; 76 DD AE 00
 altd xor (ix + 127)            ; 76 DD AE 7F
 altd xor (ix - 128)            ; 76 DD AE 80
 xor a', (ix)                   ; 76 DD AE 00
 xor a', (ix + 127)             ; 76 DD AE 7F
 xor a', (ix - 128)             ; 76 DD AE 80
 xor a, (iy)                    ; FD AE 00
 xor a, (iy + 127)              ; FD AE 7F
 xor a, (iy - 128)              ; FD AE 80
 xor (iy)                       ; FD AE 00
 xor (iy + 127)                 ; FD AE 7F
 xor (iy - 128)                 ; FD AE 80
 altd xor a, (iy)               ; 76 FD AE 00
 altd xor a, (iy + 127)         ; 76 FD AE 7F
 altd xor a, (iy - 128)         ; 76 FD AE 80
 altd xor (iy)                  ; 76 FD AE 00
 altd xor (iy + 127)            ; 76 FD AE 7F
 altd xor (iy - 128)            ; 76 FD AE 80
 xor a', (iy)                   ; 76 FD AE 00
 xor a', (iy + 127)             ; 76 FD AE 7F
 xor a', (iy - 128)             ; 76 FD AE 80
 or a, b                        ; B0
 or b                           ; B0
 altd or a, b                   ; 76 B0
 altd or b                      ; 76 B0
 or a', b                       ; 76 B0
 or a, c                        ; B1
 or c                           ; B1
 altd or a, c                   ; 76 B1
 altd or c                      ; 76 B1
 or a', c                       ; 76 B1
 or a, d                        ; B2
 or d                           ; B2
 altd or a, d                   ; 76 B2
 altd or d                      ; 76 B2
 or a', d                       ; 76 B2
 or a, e                        ; B3
 or e                           ; B3
 altd or a, e                   ; 76 B3
 altd or e                      ; 76 B3
 or a', e                       ; 76 B3
 or a, h                        ; B4
 or h                           ; B4
 altd or a, h                   ; 76 B4
 altd or h                      ; 76 B4
 or a', h                       ; 76 B4
 or a, l                        ; B5
 or l                           ; B5
 altd or a, l                   ; 76 B5
 altd or l                      ; 76 B5
 or a', l                       ; 76 B5
 or a, a                        ; B7
 or a                           ; B7
 altd or a, a                   ; 76 B7
 altd or a                      ; 76 B7
 or a', a                       ; 76 B7
 or a, (hl)                     ; B6
 or (hl)                        ; B6
 altd or a, (hl)                ; 76 B6
 altd or (hl)                   ; 76 B6
 or a', (hl)                    ; 76 B6
 or a, (ix)                     ; DD B6 00
 or a, (ix + 127)               ; DD B6 7F
 or a, (ix - 128)               ; DD B6 80
 or (ix)                        ; DD B6 00
 or (ix + 127)                  ; DD B6 7F
 or (ix - 128)                  ; DD B6 80
 altd or a, (ix)                ; 76 DD B6 00
 altd or a, (ix + 127)          ; 76 DD B6 7F
 altd or a, (ix - 128)          ; 76 DD B6 80
 altd or (ix)                   ; 76 DD B6 00
 altd or (ix + 127)             ; 76 DD B6 7F
 altd or (ix - 128)             ; 76 DD B6 80
 or a', (ix)                    ; 76 DD B6 00
 or a', (ix + 127)              ; 76 DD B6 7F
 or a', (ix - 128)              ; 76 DD B6 80
 or a, (iy)                     ; FD B6 00
 or a, (iy + 127)               ; FD B6 7F
 or a, (iy - 128)               ; FD B6 80
 or (iy)                        ; FD B6 00
 or (iy + 127)                  ; FD B6 7F
 or (iy - 128)                  ; FD B6 80
 altd or a, (iy)                ; 76 FD B6 00
 altd or a, (iy + 127)          ; 76 FD B6 7F
 altd or a, (iy - 128)          ; 76 FD B6 80
 altd or (iy)                   ; 76 FD B6 00
 altd or (iy + 127)             ; 76 FD B6 7F
 altd or (iy - 128)             ; 76 FD B6 80
 or a', (iy)                    ; 76 FD B6 00
 or a', (iy + 127)              ; 76 FD B6 7F
 or a', (iy - 128)              ; 76 FD B6 80
 cp a, b                        ; B8
 cp b                           ; B8
 altd cp a, b                   ; 76 B8
 altd cp b                      ; 76 B8
 cp a', b                       ; 76 B8
 cp a, c                        ; B9
 cp c                           ; B9
 altd cp a, c                   ; 76 B9
 altd cp c                      ; 76 B9
 cp a', c                       ; 76 B9
 cp a, d                        ; BA
 cp d                           ; BA
 altd cp a, d                   ; 76 BA
 altd cp d                      ; 76 BA
 cp a', d                       ; 76 BA
 cp a, e                        ; BB
 cp e                           ; BB
 altd cp a, e                   ; 76 BB
 altd cp e                      ; 76 BB
 cp a', e                       ; 76 BB
 cp a, h                        ; BC
 cp h                           ; BC
 altd cp a, h                   ; 76 BC
 altd cp h                      ; 76 BC
 cp a', h                       ; 76 BC
 cp a, l                        ; BD
 cp l                           ; BD
 altd cp a, l                   ; 76 BD
 altd cp l                      ; 76 BD
 cp a', l                       ; 76 BD
 cp a, a                        ; BF
 cp a                           ; BF
 altd cp a, a                   ; 76 BF
 altd cp a                      ; 76 BF
 cp a', a                       ; 76 BF
 cp a, (hl)                     ; BE
 cp (hl)                        ; BE
 altd cp a, (hl)                ; 76 BE
 altd cp (hl)                   ; 76 BE
 cp a', (hl)                    ; 76 BE
 cp a, (ix)                     ; DD BE 00
 cp a, (ix + 127)               ; DD BE 7F
 cp a, (ix - 128)               ; DD BE 80
 cp (ix)                        ; DD BE 00
 cp (ix + 127)                  ; DD BE 7F
 cp (ix - 128)                  ; DD BE 80
 altd cp a, (ix)                ; 76 DD BE 00
 altd cp a, (ix + 127)          ; 76 DD BE 7F
 altd cp a, (ix - 128)          ; 76 DD BE 80
 altd cp (ix)                   ; 76 DD BE 00
 altd cp (ix + 127)             ; 76 DD BE 7F
 altd cp (ix - 128)             ; 76 DD BE 80
 cp a', (ix)                    ; 76 DD BE 00
 cp a', (ix + 127)              ; 76 DD BE 7F
 cp a', (ix - 128)              ; 76 DD BE 80
 cp a, (iy)                     ; FD BE 00
 cp a, (iy + 127)               ; FD BE 7F
 cp a, (iy - 128)               ; FD BE 80
 cp (iy)                        ; FD BE 00
 cp (iy + 127)                  ; FD BE 7F
 cp (iy - 128)                  ; FD BE 80
 altd cp a, (iy)                ; 76 FD BE 00
 altd cp a, (iy + 127)          ; 76 FD BE 7F
 altd cp a, (iy - 128)          ; 76 FD BE 80
 altd cp (iy)                   ; 76 FD BE 00
 altd cp (iy + 127)             ; 76 FD BE 7F
 altd cp (iy - 128)             ; 76 FD BE 80
 cp a', (iy)                    ; 76 FD BE 00
 cp a', (iy + 127)              ; 76 FD BE 7F
 cp a', (iy - 128)              ; 76 FD BE 80
