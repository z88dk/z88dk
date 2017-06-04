 ld b, b                        ; 40
 ld b, c                        ; 41
 ld b, d                        ; 42
 ld b, e                        ; 43
 ld b, h                        ; 44
 ld b, ixh                      ; DD 44
 ld b, iyh                      ; FD 44
 ld b, l                        ; 45
 ld b, ixl                      ; DD 45
 ld b, iyl                      ; FD 45
 ld b, a                        ; 47
 ld b,  42                      ; 06 2A
 ld b, (42)                     ; 06 2A
 ld b, (hl)                     ; 46
 ld b, (ix)                     ; DD 46 00
 ld b, (ix + 127)               ; DD 46 7F
 ld b, (ix - 128)               ; DD 46 80
 ld b, (iy)                     ; FD 46 00
 ld b, (iy + 127)               ; FD 46 7F
 ld b, (iy - 128)               ; FD 46 80
 ld (hl), b                     ; 70
 ld (ix), b                     ; DD 70 00
 ld (ix + 127), b               ; DD 70 7F
 ld (ix - 128), b               ; DD 70 80
 ld (iy), b                     ; FD 70 00
 ld (iy + 127), b               ; FD 70 7F
 ld (iy - 128), b               ; FD 70 80
 ld c, b                        ; 48
 ld c, c                        ; 49
 ld c, d                        ; 4A
 ld c, e                        ; 4B
 ld c, h                        ; 4C
 ld c, ixh                      ; DD 4C
 ld c, iyh                      ; FD 4C
 ld c, l                        ; 4D
 ld c, ixl                      ; DD 4D
 ld c, iyl                      ; FD 4D
 ld c, a                        ; 4F
 ld c,  42                      ; 0E 2A
 ld c, (42)                     ; 0E 2A
 ld c, (hl)                     ; 4E
 ld c, (ix)                     ; DD 4E 00
 ld c, (ix + 127)               ; DD 4E 7F
 ld c, (ix - 128)               ; DD 4E 80
 ld c, (iy)                     ; FD 4E 00
 ld c, (iy + 127)               ; FD 4E 7F
 ld c, (iy - 128)               ; FD 4E 80
 ld (hl), c                     ; 71
 ld (ix), c                     ; DD 71 00
 ld (ix + 127), c               ; DD 71 7F
 ld (ix - 128), c               ; DD 71 80
 ld (iy), c                     ; FD 71 00
 ld (iy + 127), c               ; FD 71 7F
 ld (iy - 128), c               ; FD 71 80
 ld d, b                        ; 50
 ld d, c                        ; 51
 ld d, d                        ; 52
 ld d, e                        ; 53
 ld d, h                        ; 54
 ld d, ixh                      ; DD 54
 ld d, iyh                      ; FD 54
 ld d, l                        ; 55
 ld d, ixl                      ; DD 55
 ld d, iyl                      ; FD 55
 ld d, a                        ; 57
 ld d,  42                      ; 16 2A
 ld d, (42)                     ; 16 2A
 ld d, (hl)                     ; 56
 ld d, (ix)                     ; DD 56 00
 ld d, (ix + 127)               ; DD 56 7F
 ld d, (ix - 128)               ; DD 56 80
 ld d, (iy)                     ; FD 56 00
 ld d, (iy + 127)               ; FD 56 7F
 ld d, (iy - 128)               ; FD 56 80
 ld (hl), d                     ; 72
 ld (ix), d                     ; DD 72 00
 ld (ix + 127), d               ; DD 72 7F
 ld (ix - 128), d               ; DD 72 80
 ld (iy), d                     ; FD 72 00
 ld (iy + 127), d               ; FD 72 7F
 ld (iy - 128), d               ; FD 72 80
 ld e, b                        ; 58
 ld e, c                        ; 59
 ld e, d                        ; 5A
 ld e, e                        ; 5B
 ld e, h                        ; 5C
 ld e, ixh                      ; DD 5C
 ld e, iyh                      ; FD 5C
 ld e, l                        ; 5D
 ld e, ixl                      ; DD 5D
 ld e, iyl                      ; FD 5D
 ld e, a                        ; 5F
 ld e,  42                      ; 1E 2A
 ld e, (42)                     ; 1E 2A
 ld e, (hl)                     ; 5E
 ld e, (ix)                     ; DD 5E 00
 ld e, (ix + 127)               ; DD 5E 7F
 ld e, (ix - 128)               ; DD 5E 80
 ld e, (iy)                     ; FD 5E 00
 ld e, (iy + 127)               ; FD 5E 7F
 ld e, (iy - 128)               ; FD 5E 80
 ld (hl), e                     ; 73
 ld (ix), e                     ; DD 73 00
 ld (ix + 127), e               ; DD 73 7F
 ld (ix - 128), e               ; DD 73 80
 ld (iy), e                     ; FD 73 00
 ld (iy + 127), e               ; FD 73 7F
 ld (iy - 128), e               ; FD 73 80
 ld h, b                        ; 60
 ld ixh, b                      ; DD 60
 ld iyh, b                      ; FD 60
 ld h, c                        ; 61
 ld ixh, c                      ; DD 61
 ld iyh, c                      ; FD 61
 ld h, d                        ; 62
 ld ixh, d                      ; DD 62
 ld iyh, d                      ; FD 62
 ld h, e                        ; 63
 ld ixh, e                      ; DD 63
 ld iyh, e                      ; FD 63
 ld h, h                        ; 64
 ld ixh, ixh                    ; DD 64
 ld iyh, iyh                    ; FD 64
 ld h, l                        ; 65
 ld ixh, ixl                    ; DD 65
 ld iyh, iyl                    ; FD 65
 ld h, a                        ; 67
 ld ixh, a                      ; DD 67
 ld iyh, a                      ; FD 67
 ld h,  42                      ; 26 2A
 ld h, (42)                     ; 26 2A
 ld ixh,  42                    ; DD 26 2A
 ld ixh, (42)                   ; DD 26 2A
 ld iyh,  42                    ; FD 26 2A
 ld iyh, (42)                   ; FD 26 2A
 ld h, (hl)                     ; 66
 ld h, (ix)                     ; DD 66 00
 ld h, (ix + 127)               ; DD 66 7F
 ld h, (ix - 128)               ; DD 66 80
 ld h, (iy)                     ; FD 66 00
 ld h, (iy + 127)               ; FD 66 7F
 ld h, (iy - 128)               ; FD 66 80
 ld (hl), h                     ; 74
 ld (ix), h                     ; DD 74 00
 ld (ix + 127), h               ; DD 74 7F
 ld (ix - 128), h               ; DD 74 80
 ld (iy), h                     ; FD 74 00
 ld (iy + 127), h               ; FD 74 7F
 ld (iy - 128), h               ; FD 74 80
 ld l, b                        ; 68
 ld ixl, b                      ; DD 68
 ld iyl, b                      ; FD 68
 ld l, c                        ; 69
 ld ixl, c                      ; DD 69
 ld iyl, c                      ; FD 69
 ld l, d                        ; 6A
 ld ixl, d                      ; DD 6A
 ld iyl, d                      ; FD 6A
 ld l, e                        ; 6B
 ld ixl, e                      ; DD 6B
 ld iyl, e                      ; FD 6B
 ld l, h                        ; 6C
 ld ixl, ixh                    ; DD 6C
 ld iyl, iyh                    ; FD 6C
 ld l, l                        ; 6D
 ld ixl, ixl                    ; DD 6D
 ld iyl, iyl                    ; FD 6D
 ld l, a                        ; 6F
 ld ixl, a                      ; DD 6F
 ld iyl, a                      ; FD 6F
 ld l,  42                      ; 2E 2A
 ld l, (42)                     ; 2E 2A
 ld ixl,  42                    ; DD 2E 2A
 ld ixl, (42)                   ; DD 2E 2A
 ld iyl,  42                    ; FD 2E 2A
 ld iyl, (42)                   ; FD 2E 2A
 ld l, (hl)                     ; 6E
 ld l, (ix)                     ; DD 6E 00
 ld l, (ix + 127)               ; DD 6E 7F
 ld l, (ix - 128)               ; DD 6E 80
 ld l, (iy)                     ; FD 6E 00
 ld l, (iy + 127)               ; FD 6E 7F
 ld l, (iy - 128)               ; FD 6E 80
 ld (hl), l                     ; 75
 ld (ix), l                     ; DD 75 00
 ld (ix + 127), l               ; DD 75 7F
 ld (ix - 128), l               ; DD 75 80
 ld (iy), l                     ; FD 75 00
 ld (iy + 127), l               ; FD 75 7F
 ld (iy - 128), l               ; FD 75 80
 ld a, b                        ; 78
 ld a, c                        ; 79
 ld a, d                        ; 7A
 ld a, e                        ; 7B
 ld a, h                        ; 7C
 ld a, ixh                      ; DD 7C
 ld a, iyh                      ; FD 7C
 ld a, l                        ; 7D
 ld a, ixl                      ; DD 7D
 ld a, iyl                      ; FD 7D
 ld a, a                        ; 7F
 ld a, 42                       ; 3E 2A
 ld a, (256)                    ; 3A 00 01
 ld a, (hl)                     ; 7E
 ld a, (ix)                     ; DD 7E 00
 ld a, (ix + 127)               ; DD 7E 7F
 ld a, (ix - 128)               ; DD 7E 80
 ld a, (iy)                     ; FD 7E 00
 ld a, (iy + 127)               ; FD 7E 7F
 ld a, (iy - 128)               ; FD 7E 80
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
 ld (de), a                     ; 12
 ld a, (de)                     ; 1A
 ld (256), a                    ; 32 00 01
