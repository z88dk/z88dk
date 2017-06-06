 ld b, ixh                      ; DD 44
 ld b, iyh                      ; FD 44
 ld b, ixl                      ; DD 45
 ld b, iyl                      ; FD 45
 ld c, ixh                      ; DD 4C
 ld c, iyh                      ; FD 4C
 ld c, ixl                      ; DD 4D
 ld c, iyl                      ; FD 4D
 ld d, ixh                      ; DD 54
 ld d, iyh                      ; FD 54
 ld d, ixl                      ; DD 55
 ld d, iyl                      ; FD 55
 ld e, ixh                      ; DD 5C
 ld e, iyh                      ; FD 5C
 ld e, ixl                      ; DD 5D
 ld e, iyl                      ; FD 5D
 ld ixh, b                      ; DD 60
 ld iyh, b                      ; FD 60
 ld ixh, c                      ; DD 61
 ld iyh, c                      ; FD 61
 ld ixh, d                      ; DD 62
 ld iyh, d                      ; FD 62
 ld ixh, e                      ; DD 63
 ld iyh, e                      ; FD 63
 ld ixh, ixh                    ; DD 64
 ld iyh, iyh                    ; FD 64
 ld ixh, ixl                    ; DD 65
 ld iyh, iyl                    ; FD 65
 ld ixh, a                      ; DD 67
 ld iyh, a                      ; FD 67
 ld ixh,  42                    ; DD 26 2A
 ld ixh, (42)                   ; DD 26 2A
 ld iyh,  42                    ; FD 26 2A
 ld iyh, (42)                   ; FD 26 2A
 ld ixl, b                      ; DD 68
 ld iyl, b                      ; FD 68
 ld ixl, c                      ; DD 69
 ld iyl, c                      ; FD 69
 ld ixl, d                      ; DD 6A
 ld iyl, d                      ; FD 6A
 ld ixl, e                      ; DD 6B
 ld iyl, e                      ; FD 6B
 ld ixl, ixh                    ; DD 6C
 ld iyl, iyh                    ; FD 6C
 ld ixl, ixl                    ; DD 6D
 ld iyl, iyl                    ; FD 6D
 ld ixl, a                      ; DD 6F
 ld iyl, a                      ; FD 6F
 ld ixl,  42                    ; DD 2E 2A
 ld ixl, (42)                   ; DD 2E 2A
 ld iyl,  42                    ; FD 2E 2A
 ld iyl, (42)                   ; FD 2E 2A
 ld a, ixh                      ; DD 7C
 ld a, iyh                      ; FD 7C
 ld a, ixl                      ; DD 7D
 ld a, iyl                      ; FD 7D
 add a, ixh                     ; DD 84
 add ixh                        ; DD 84
 add a, iyh                     ; FD 84
 add iyh                        ; FD 84
 add a, ixl                     ; DD 85
 add ixl                        ; DD 85
 add a, iyl                     ; FD 85
 add iyl                        ; FD 85
 adc a, ixh                     ; DD 8C
 adc ixh                        ; DD 8C
 adc a, iyh                     ; FD 8C
 adc iyh                        ; FD 8C
 adc a, ixl                     ; DD 8D
 adc ixl                        ; DD 8D
 adc a, iyl                     ; FD 8D
 adc iyl                        ; FD 8D
 sub a, ixh                     ; DD 94
 sub ixh                        ; DD 94
 sub a, iyh                     ; FD 94
 sub iyh                        ; FD 94
 sub a, ixl                     ; DD 95
 sub ixl                        ; DD 95
 sub a, iyl                     ; FD 95
 sub iyl                        ; FD 95
 sbc a, ixh                     ; DD 9C
 sbc ixh                        ; DD 9C
 sbc a, iyh                     ; FD 9C
 sbc iyh                        ; FD 9C
 sbc a, ixl                     ; DD 9D
 sbc ixl                        ; DD 9D
 sbc a, iyl                     ; FD 9D
 sbc iyl                        ; FD 9D
 and a, ixh                     ; DD A4
 and ixh                        ; DD A4
 and a, iyh                     ; FD A4
 and iyh                        ; FD A4
 and a, ixl                     ; DD A5
 and ixl                        ; DD A5
 and a, iyl                     ; FD A5
 and iyl                        ; FD A5
 xor a, ixh                     ; DD AC
 xor ixh                        ; DD AC
 xor a, iyh                     ; FD AC
 xor iyh                        ; FD AC
 xor a, ixl                     ; DD AD
 xor ixl                        ; DD AD
 xor a, iyl                     ; FD AD
 xor iyl                        ; FD AD
 or a, ixh                      ; DD B4
 or ixh                         ; DD B4
 or a, iyh                      ; FD B4
 or iyh                         ; FD B4
 or a, ixl                      ; DD B5
 or ixl                         ; DD B5
 or a, iyl                      ; FD B5
 or iyl                         ; FD B5
 cp a, ixh                      ; DD BC
 cp ixh                         ; DD BC
 cp a, iyh                      ; FD BC
 cp iyh                         ; FD BC
 cp a, ixl                      ; DD BD
 cp ixl                         ; DD BD
 cp a, iyl                      ; FD BD
 cp iyl                         ; FD BD
 inc ixh                        ; DD 24
 inc iyh                        ; FD 24
 inc ixl                        ; DD 2C
 inc iyl                        ; FD 2C
 dec ixh                        ; DD 25
 dec iyh                        ; FD 25
 dec ixl                        ; DD 2D
 dec iyl                        ; FD 2D
