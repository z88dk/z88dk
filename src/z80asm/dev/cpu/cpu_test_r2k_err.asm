 adc a, ixh                     ; Error
 adc a, ixl                     ; Error
 adc a, iyh                     ; Error
 adc a, iyl                     ; Error
 adc ixh                        ; Error
 adc ixl                        ; Error
 adc iyh                        ; Error
 adc iyl                        ; Error
 add a, ixh                     ; Error
 add a, ixl                     ; Error
 add a, iyh                     ; Error
 add a, iyl                     ; Error
 add ixh                        ; Error
 add ixl                        ; Error
 add iyh                        ; Error
 add iyl                        ; Error
 and a, ixh                     ; Error
 and a, ixl                     ; Error
 and a, iyh                     ; Error
 and a, iyl                     ; Error
 and ixh                        ; Error
 and ixl                        ; Error
 and iyh                        ; Error
 and iyl                        ; Error
 cp a, ixh                      ; Error
 cp a, ixl                      ; Error
 cp a, iyh                      ; Error
 cp a, iyl                      ; Error
 cp ixh                         ; Error
 cp ixl                         ; Error
 cp iyh                         ; Error
 cp iyl                         ; Error
 daa                            ; Error
 dec ixh                        ; Error
 dec ixl                        ; Error
 dec iyh                        ; Error
 dec iyl                        ; Error
 inc ixh                        ; Error
 inc ixl                        ; Error
 inc iyh                        ; Error
 inc iyl                        ; Error
 ld a, ixh                      ; Error
 ld a, ixl                      ; Error
 ld a, iyh                      ; Error
 ld a, iyl                      ; Error
 ld b, ixh                      ; Error
 ld b, ixl                      ; Error
 ld b, iyh                      ; Error
 ld b, iyl                      ; Error
 ld c, ixh                      ; Error
 ld c, ixl                      ; Error
 ld c, iyh                      ; Error
 ld c, iyl                      ; Error
 ld d, ixh                      ; Error
 ld d, ixl                      ; Error
 ld d, iyh                      ; Error
 ld d, iyl                      ; Error
 ld e, ixh                      ; Error
 ld e, ixl                      ; Error
 ld e, iyh                      ; Error
 ld e, iyl                      ; Error
 ld ixh, -128                   ; Error
 ld ixh, 127                    ; Error
 ld ixh, 255                    ; Error
 ld ixh, a                      ; Error
 ld ixh, b                      ; Error
 ld ixh, c                      ; Error
 ld ixh, d                      ; Error
 ld ixh, e                      ; Error
 ld ixh, ixh                    ; Error
 ld ixh, ixl                    ; Error
 ld ixl, -128                   ; Error
 ld ixl, 127                    ; Error
 ld ixl, 255                    ; Error
 ld ixl, a                      ; Error
 ld ixl, b                      ; Error
 ld ixl, c                      ; Error
 ld ixl, d                      ; Error
 ld ixl, e                      ; Error
 ld ixl, ixh                    ; Error
 ld ixl, ixl                    ; Error
 ld iyh, -128                   ; Error
 ld iyh, 127                    ; Error
 ld iyh, 255                    ; Error
 ld iyh, a                      ; Error
 ld iyh, b                      ; Error
 ld iyh, c                      ; Error
 ld iyh, d                      ; Error
 ld iyh, e                      ; Error
 ld iyh, iyh                    ; Error
 ld iyh, iyl                    ; Error
 ld iyl, -128                   ; Error
 ld iyl, 127                    ; Error
 ld iyl, 255                    ; Error
 ld iyl, a                      ; Error
 ld iyl, b                      ; Error
 ld iyl, c                      ; Error
 ld iyl, d                      ; Error
 ld iyl, e                      ; Error
 ld iyl, iyh                    ; Error
 ld iyl, iyl                    ; Error
 or a, ixh                      ; Error
 or a, ixl                      ; Error
 or a, iyh                      ; Error
 or a, iyl                      ; Error
 or ixh                         ; Error
 or ixl                         ; Error
 or iyh                         ; Error
 or iyl                         ; Error
 sbc a, ixh                     ; Error
 sbc a, ixl                     ; Error
 sbc a, iyh                     ; Error
 sbc a, iyl                     ; Error
 sbc ixh                        ; Error
 sbc ixl                        ; Error
 sbc iyh                        ; Error
 sbc iyl                        ; Error
 sub a, ixh                     ; Error
 sub a, ixl                     ; Error
 sub a, iyh                     ; Error
 sub a, iyl                     ; Error
 sub ixh                        ; Error
 sub ixl                        ; Error
 sub iyh                        ; Error
 sub iyl                        ; Error
 test (hl)                      ; Error
 test (ix)                      ; Error
 test (ix+127)                  ; Error
 test (ix-128)                  ; Error
 test (iy)                      ; Error
 test (iy+127)                  ; Error
 test (iy-128)                  ; Error
 test -128                      ; Error
 test 127                       ; Error
 test 255                       ; Error
 test a                         ; Error
 test a, (hl)                   ; Error
 test a, (ix)                   ; Error
 test a, (ix+127)               ; Error
 test a, (ix-128)               ; Error
 test a, (iy)                   ; Error
 test a, (iy+127)               ; Error
 test a, (iy-128)               ; Error
 test a, -128                   ; Error
 test a, 127                    ; Error
 test a, 255                    ; Error
 test a, a                      ; Error
 test a, b                      ; Error
 test a, c                      ; Error
 test a, d                      ; Error
 test a, e                      ; Error
 test a, h                      ; Error
 test a, l                      ; Error
 test b                         ; Error
 test c                         ; Error
 test d                         ; Error
 test e                         ; Error
 test h                         ; Error
 test l                         ; Error
 tst (hl)                       ; Error
 tst (ix)                       ; Error
 tst (ix+127)                   ; Error
 tst (ix-128)                   ; Error
 tst (iy)                       ; Error
 tst (iy+127)                   ; Error
 tst (iy-128)                   ; Error
 tst -128                       ; Error
 tst 127                        ; Error
 tst 255                        ; Error
 tst a                          ; Error
 tst a, (hl)                    ; Error
 tst a, (ix)                    ; Error
 tst a, (ix+127)                ; Error
 tst a, (ix-128)                ; Error
 tst a, (iy)                    ; Error
 tst a, (iy+127)                ; Error
 tst a, (iy-128)                ; Error
 tst a, -128                    ; Error
 tst a, 127                     ; Error
 tst a, 255                     ; Error
 tst a, a                       ; Error
 tst a, b                       ; Error
 tst a, c                       ; Error
 tst a, d                       ; Error
 tst a, e                       ; Error
 tst a, h                       ; Error
 tst a, l                       ; Error
 tst b                          ; Error
 tst c                          ; Error
 tst d                          ; Error
 tst e                          ; Error
 tst h                          ; Error
 tst l                          ; Error
 xor a, ixh                     ; Error
 xor a, ixl                     ; Error
 xor a, iyh                     ; Error
 xor a, iyl                     ; Error
 xor ixh                        ; Error
 xor ixl                        ; Error
 xor iyh                        ; Error
 xor iyl                        ; Error
