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
 add bc, a                      ; Error
 add de, a                      ; Error
 add hl, a                      ; Error
 add ixh                        ; Error
 add ixl                        ; Error
 add iyh                        ; Error
 add iyl                        ; Error
 adi hl, -128                   ; Error
 adi hl, 127                    ; Error
 adi hl, 255                    ; Error
 adi sp, -128                   ; Error
 adi sp, 127                    ; Error
 adi sp, 255                    ; Error
 altd bit -1, (hl)              ; Error
 altd bit -1, (hl)              ; Error
 altd bit -1, (ix)              ; Error
 altd bit -1, (ix)              ; Error
 altd bit -1, (ix+127)          ; Error
 altd bit -1, (ix+127)          ; Error
 altd bit -1, (ix-128)          ; Error
 altd bit -1, (ix-128)          ; Error
 altd bit -1, (iy)              ; Error
 altd bit -1, (iy)              ; Error
 altd bit -1, (iy+127)          ; Error
 altd bit -1, (iy+127)          ; Error
 altd bit -1, (iy-128)          ; Error
 altd bit -1, (iy-128)          ; Error
 altd bit -1, a                 ; Error
 altd bit -1, a                 ; Error
 altd bit -1, b                 ; Error
 altd bit -1, b                 ; Error
 altd bit -1, c                 ; Error
 altd bit -1, c                 ; Error
 altd bit -1, d                 ; Error
 altd bit -1, d                 ; Error
 altd bit -1, e                 ; Error
 altd bit -1, e                 ; Error
 altd bit -1, h                 ; Error
 altd bit -1, h                 ; Error
 altd bit -1, l                 ; Error
 altd bit -1, l                 ; Error
 altd bit 8, (hl)               ; Error
 altd bit 8, (hl)               ; Error
 altd bit 8, (ix)               ; Error
 altd bit 8, (ix)               ; Error
 altd bit 8, (ix+127)           ; Error
 altd bit 8, (ix+127)           ; Error
 altd bit 8, (ix-128)           ; Error
 altd bit 8, (ix-128)           ; Error
 altd bit 8, (iy)               ; Error
 altd bit 8, (iy)               ; Error
 altd bit 8, (iy+127)           ; Error
 altd bit 8, (iy+127)           ; Error
 altd bit 8, (iy-128)           ; Error
 altd bit 8, (iy-128)           ; Error
 altd bit 8, a                  ; Error
 altd bit 8, a                  ; Error
 altd bit 8, b                  ; Error
 altd bit 8, b                  ; Error
 altd bit 8, c                  ; Error
 altd bit 8, c                  ; Error
 altd bit 8, d                  ; Error
 altd bit 8, d                  ; Error
 altd bit 8, e                  ; Error
 altd bit 8, e                  ; Error
 altd bit 8, h                  ; Error
 altd bit 8, h                  ; Error
 altd bit 8, l                  ; Error
 altd bit 8, l                  ; Error
 altd ioe bit -1, (hl)          ; Error
 altd ioe bit -1, (hl)          ; Error
 altd ioe bit -1, (ix)          ; Error
 altd ioe bit -1, (ix)          ; Error
 altd ioe bit -1, (ix+127)      ; Error
 altd ioe bit -1, (ix+127)      ; Error
 altd ioe bit -1, (ix-128)      ; Error
 altd ioe bit -1, (ix-128)      ; Error
 altd ioe bit -1, (iy)          ; Error
 altd ioe bit -1, (iy)          ; Error
 altd ioe bit -1, (iy+127)      ; Error
 altd ioe bit -1, (iy+127)      ; Error
 altd ioe bit -1, (iy-128)      ; Error
 altd ioe bit -1, (iy-128)      ; Error
 altd ioe bit 8, (hl)           ; Error
 altd ioe bit 8, (hl)           ; Error
 altd ioe bit 8, (ix)           ; Error
 altd ioe bit 8, (ix)           ; Error
 altd ioe bit 8, (ix+127)       ; Error
 altd ioe bit 8, (ix+127)       ; Error
 altd ioe bit 8, (ix-128)       ; Error
 altd ioe bit 8, (ix-128)       ; Error
 altd ioe bit 8, (iy)           ; Error
 altd ioe bit 8, (iy)           ; Error
 altd ioe bit 8, (iy+127)       ; Error
 altd ioe bit 8, (iy+127)       ; Error
 altd ioe bit 8, (iy-128)       ; Error
 altd ioe bit 8, (iy-128)       ; Error
 altd ioi bit -1, (hl)          ; Error
 altd ioi bit -1, (hl)          ; Error
 altd ioi bit -1, (ix)          ; Error
 altd ioi bit -1, (ix)          ; Error
 altd ioi bit -1, (ix+127)      ; Error
 altd ioi bit -1, (ix+127)      ; Error
 altd ioi bit -1, (ix-128)      ; Error
 altd ioi bit -1, (ix-128)      ; Error
 altd ioi bit -1, (iy)          ; Error
 altd ioi bit -1, (iy)          ; Error
 altd ioi bit -1, (iy+127)      ; Error
 altd ioi bit -1, (iy+127)      ; Error
 altd ioi bit -1, (iy-128)      ; Error
 altd ioi bit -1, (iy-128)      ; Error
 altd ioi bit 8, (hl)           ; Error
 altd ioi bit 8, (hl)           ; Error
 altd ioi bit 8, (ix)           ; Error
 altd ioi bit 8, (ix)           ; Error
 altd ioi bit 8, (ix+127)       ; Error
 altd ioi bit 8, (ix+127)       ; Error
 altd ioi bit 8, (ix-128)       ; Error
 altd ioi bit 8, (ix-128)       ; Error
 altd ioi bit 8, (iy)           ; Error
 altd ioi bit 8, (iy)           ; Error
 altd ioi bit 8, (iy+127)       ; Error
 altd ioi bit 8, (iy+127)       ; Error
 altd ioi bit 8, (iy-128)       ; Error
 altd ioi bit 8, (iy-128)       ; Error
 altd res -1, a                 ; Error
 altd res -1, a                 ; Error
 altd res -1, b                 ; Error
 altd res -1, b                 ; Error
 altd res -1, c                 ; Error
 altd res -1, c                 ; Error
 altd res -1, d                 ; Error
 altd res -1, d                 ; Error
 altd res -1, e                 ; Error
 altd res -1, e                 ; Error
 altd res -1, h                 ; Error
 altd res -1, h                 ; Error
 altd res -1, l                 ; Error
 altd res -1, l                 ; Error
 altd res 8, a                  ; Error
 altd res 8, a                  ; Error
 altd res 8, b                  ; Error
 altd res 8, b                  ; Error
 altd res 8, c                  ; Error
 altd res 8, c                  ; Error
 altd res 8, d                  ; Error
 altd res 8, d                  ; Error
 altd res 8, e                  ; Error
 altd res 8, e                  ; Error
 altd res 8, h                  ; Error
 altd res 8, h                  ; Error
 altd res 8, l                  ; Error
 altd res 8, l                  ; Error
 altd set -1, a                 ; Error
 altd set -1, a                 ; Error
 altd set -1, b                 ; Error
 altd set -1, b                 ; Error
 altd set -1, c                 ; Error
 altd set -1, c                 ; Error
 altd set -1, d                 ; Error
 altd set -1, d                 ; Error
 altd set -1, e                 ; Error
 altd set -1, e                 ; Error
 altd set -1, h                 ; Error
 altd set -1, h                 ; Error
 altd set -1, l                 ; Error
 altd set -1, l                 ; Error
 altd set 8, a                  ; Error
 altd set 8, a                  ; Error
 altd set 8, b                  ; Error
 altd set 8, b                  ; Error
 altd set 8, c                  ; Error
 altd set 8, c                  ; Error
 altd set 8, d                  ; Error
 altd set 8, d                  ; Error
 altd set 8, e                  ; Error
 altd set 8, e                  ; Error
 altd set 8, h                  ; Error
 altd set 8, h                  ; Error
 altd set 8, l                  ; Error
 altd set 8, l                  ; Error
 and a, ixh                     ; Error
 and a, ixl                     ; Error
 and a, iyh                     ; Error
 and a, iyl                     ; Error
 and ixh                        ; Error
 and ixl                        ; Error
 and iyh                        ; Error
 and iyl                        ; Error
 arhl                           ; Error
 bit -1, (hl)                   ; Error
 bit -1, (hl)                   ; Error
 bit -1, (ix)                   ; Error
 bit -1, (ix)                   ; Error
 bit -1, (ix+127)               ; Error
 bit -1, (ix+127)               ; Error
 bit -1, (ix-128)               ; Error
 bit -1, (ix-128)               ; Error
 bit -1, (iy)                   ; Error
 bit -1, (iy)                   ; Error
 bit -1, (iy+127)               ; Error
 bit -1, (iy+127)               ; Error
 bit -1, (iy-128)               ; Error
 bit -1, (iy-128)               ; Error
 bit -1, a                      ; Error
 bit -1, a                      ; Error
 bit -1, b                      ; Error
 bit -1, b                      ; Error
 bit -1, c                      ; Error
 bit -1, c                      ; Error
 bit -1, d                      ; Error
 bit -1, d                      ; Error
 bit -1, e                      ; Error
 bit -1, e                      ; Error
 bit -1, h                      ; Error
 bit -1, h                      ; Error
 bit -1, ixh                    ; Error
 bit -1, ixh                    ; Error
 bit -1, ixl                    ; Error
 bit -1, ixl                    ; Error
 bit -1, iyh                    ; Error
 bit -1, iyh                    ; Error
 bit -1, iyl                    ; Error
 bit -1, iyl                    ; Error
 bit -1, l                      ; Error
 bit -1, l                      ; Error
 bit 0, ixh                     ; Error
 bit 0, ixl                     ; Error
 bit 0, iyh                     ; Error
 bit 0, iyl                     ; Error
 bit 1, ixh                     ; Error
 bit 1, ixl                     ; Error
 bit 1, iyh                     ; Error
 bit 1, iyl                     ; Error
 bit 2, ixh                     ; Error
 bit 2, ixl                     ; Error
 bit 2, iyh                     ; Error
 bit 2, iyl                     ; Error
 bit 3, ixh                     ; Error
 bit 3, ixl                     ; Error
 bit 3, iyh                     ; Error
 bit 3, iyl                     ; Error
 bit 4, ixh                     ; Error
 bit 4, ixl                     ; Error
 bit 4, iyh                     ; Error
 bit 4, iyl                     ; Error
 bit 5, ixh                     ; Error
 bit 5, ixl                     ; Error
 bit 5, iyh                     ; Error
 bit 5, iyl                     ; Error
 bit 6, ixh                     ; Error
 bit 6, ixl                     ; Error
 bit 6, iyh                     ; Error
 bit 6, iyl                     ; Error
 bit 7, ixh                     ; Error
 bit 7, ixl                     ; Error
 bit 7, iyh                     ; Error
 bit 7, iyl                     ; Error
 bit 8, (hl)                    ; Error
 bit 8, (hl)                    ; Error
 bit 8, (ix)                    ; Error
 bit 8, (ix)                    ; Error
 bit 8, (ix+127)                ; Error
 bit 8, (ix+127)                ; Error
 bit 8, (ix-128)                ; Error
 bit 8, (ix-128)                ; Error
 bit 8, (iy)                    ; Error
 bit 8, (iy)                    ; Error
 bit 8, (iy+127)                ; Error
 bit 8, (iy+127)                ; Error
 bit 8, (iy-128)                ; Error
 bit 8, (iy-128)                ; Error
 bit 8, a                       ; Error
 bit 8, a                       ; Error
 bit 8, b                       ; Error
 bit 8, b                       ; Error
 bit 8, c                       ; Error
 bit 8, c                       ; Error
 bit 8, d                       ; Error
 bit 8, d                       ; Error
 bit 8, e                       ; Error
 bit 8, e                       ; Error
 bit 8, h                       ; Error
 bit 8, h                       ; Error
 bit 8, ixh                     ; Error
 bit 8, ixh                     ; Error
 bit 8, ixl                     ; Error
 bit 8, ixl                     ; Error
 bit 8, iyh                     ; Error
 bit 8, iyh                     ; Error
 bit 8, iyl                     ; Error
 bit 8, iyl                     ; Error
 bit 8, l                       ; Error
 bit 8, l                       ; Error
 bit.a -1, (hl)                 ; Error
 bit.a -1, (hl)                 ; Error
 bit.a -1, (ix)                 ; Error
 bit.a -1, (ix)                 ; Error
 bit.a -1, (ix+127)             ; Error
 bit.a -1, (ix+127)             ; Error
 bit.a -1, (ix-128)             ; Error
 bit.a -1, (ix-128)             ; Error
 bit.a -1, (iy)                 ; Error
 bit.a -1, (iy)                 ; Error
 bit.a -1, (iy+127)             ; Error
 bit.a -1, (iy+127)             ; Error
 bit.a -1, (iy-128)             ; Error
 bit.a -1, (iy-128)             ; Error
 bit.a -1, a                    ; Error
 bit.a -1, a                    ; Error
 bit.a -1, b                    ; Error
 bit.a -1, b                    ; Error
 bit.a -1, c                    ; Error
 bit.a -1, c                    ; Error
 bit.a -1, d                    ; Error
 bit.a -1, d                    ; Error
 bit.a -1, e                    ; Error
 bit.a -1, e                    ; Error
 bit.a -1, h                    ; Error
 bit.a -1, h                    ; Error
 bit.a -1, ixh                  ; Error
 bit.a -1, ixh                  ; Error
 bit.a -1, ixl                  ; Error
 bit.a -1, ixl                  ; Error
 bit.a -1, iyh                  ; Error
 bit.a -1, iyh                  ; Error
 bit.a -1, iyl                  ; Error
 bit.a -1, iyl                  ; Error
 bit.a -1, l                    ; Error
 bit.a -1, l                    ; Error
 bit.a 0, ixh                   ; Error
 bit.a 0, ixl                   ; Error
 bit.a 0, iyh                   ; Error
 bit.a 0, iyl                   ; Error
 bit.a 1, ixh                   ; Error
 bit.a 1, ixl                   ; Error
 bit.a 1, iyh                   ; Error
 bit.a 1, iyl                   ; Error
 bit.a 2, ixh                   ; Error
 bit.a 2, ixl                   ; Error
 bit.a 2, iyh                   ; Error
 bit.a 2, iyl                   ; Error
 bit.a 3, ixh                   ; Error
 bit.a 3, ixl                   ; Error
 bit.a 3, iyh                   ; Error
 bit.a 3, iyl                   ; Error
 bit.a 4, ixh                   ; Error
 bit.a 4, ixl                   ; Error
 bit.a 4, iyh                   ; Error
 bit.a 4, iyl                   ; Error
 bit.a 5, ixh                   ; Error
 bit.a 5, ixl                   ; Error
 bit.a 5, iyh                   ; Error
 bit.a 5, iyl                   ; Error
 bit.a 6, ixh                   ; Error
 bit.a 6, ixl                   ; Error
 bit.a 6, iyh                   ; Error
 bit.a 6, iyl                   ; Error
 bit.a 7, ixh                   ; Error
 bit.a 7, ixl                   ; Error
 bit.a 7, iyh                   ; Error
 bit.a 7, iyl                   ; Error
 bit.a 8, (hl)                  ; Error
 bit.a 8, (hl)                  ; Error
 bit.a 8, (ix)                  ; Error
 bit.a 8, (ix)                  ; Error
 bit.a 8, (ix+127)              ; Error
 bit.a 8, (ix+127)              ; Error
 bit.a 8, (ix-128)              ; Error
 bit.a 8, (ix-128)              ; Error
 bit.a 8, (iy)                  ; Error
 bit.a 8, (iy)                  ; Error
 bit.a 8, (iy+127)              ; Error
 bit.a 8, (iy+127)              ; Error
 bit.a 8, (iy-128)              ; Error
 bit.a 8, (iy-128)              ; Error
 bit.a 8, a                     ; Error
 bit.a 8, a                     ; Error
 bit.a 8, b                     ; Error
 bit.a 8, b                     ; Error
 bit.a 8, c                     ; Error
 bit.a 8, c                     ; Error
 bit.a 8, d                     ; Error
 bit.a 8, d                     ; Error
 bit.a 8, e                     ; Error
 bit.a 8, e                     ; Error
 bit.a 8, h                     ; Error
 bit.a 8, h                     ; Error
 bit.a 8, ixh                   ; Error
 bit.a 8, ixh                   ; Error
 bit.a 8, ixl                   ; Error
 bit.a 8, ixl                   ; Error
 bit.a 8, iyh                   ; Error
 bit.a 8, iyh                   ; Error
 bit.a 8, iyl                   ; Error
 bit.a 8, iyl                   ; Error
 bit.a 8, l                     ; Error
 bit.a 8, l                     ; Error
 brlc de,b                      ; Error
 bsla de,b                      ; Error
 bsra de,b                      ; Error
 bsrf de,b                      ; Error
 bsrl de,b                      ; Error
 cmp a, ixh                     ; Error
 cmp a, ixl                     ; Error
 cmp a, iyh                     ; Error
 cmp a, iyl                     ; Error
 cmp ixh                        ; Error
 cmp ixl                        ; Error
 cmp iyh                        ; Error
 cmp iyl                        ; Error
 cp a, ixh                      ; Error
 cp a, ixl                      ; Error
 cp a, iyh                      ; Error
 cp a, iyl                      ; Error
 cp ixh                         ; Error
 cp ixl                         ; Error
 cp iyh                         ; Error
 cp iyl                         ; Error
 dcr ixh                        ; Error
 dcr ixl                        ; Error
 dcr iyh                        ; Error
 dcr iyl                        ; Error
 dcx ixh                        ; Error
 dcx iyh                        ; Error
 dec ixh                        ; Error
 dec ixl                        ; Error
 dec iyh                        ; Error
 dec iyl                        ; Error
 di                             ; Error
 dsub                           ; Error
 ei                             ; Error
 halt                           ; Error
 hlt                            ; Error
 im -1                          ; Error
 im -1                          ; Error
 im 0                           ; Error
 im 1                           ; Error
 im 2                           ; Error
 im 3                           ; Error
 im 3                           ; Error
 in (c)                         ; Error
 in -128                        ; Error
 in 127                         ; Error
 in 255                         ; Error
 in a, (-128)                   ; Error
 in a, (127)                    ; Error
 in a, (255)                    ; Error
 in a, (c)                      ; Error
 in b, (c)                      ; Error
 in c, (c)                      ; Error
 in d, (c)                      ; Error
 in e, (c)                      ; Error
 in f, (c)                      ; Error
 in h, (c)                      ; Error
 in l, (c)                      ; Error
 in0 (-128)                     ; Error
 in0 (127)                      ; Error
 in0 (255)                      ; Error
 in0 a, (-128)                  ; Error
 in0 a, (127)                   ; Error
 in0 a, (255)                   ; Error
 in0 b, (-128)                  ; Error
 in0 b, (127)                   ; Error
 in0 b, (255)                   ; Error
 in0 c, (-128)                  ; Error
 in0 c, (127)                   ; Error
 in0 c, (255)                   ; Error
 in0 d, (-128)                  ; Error
 in0 d, (127)                   ; Error
 in0 d, (255)                   ; Error
 in0 e, (-128)                  ; Error
 in0 e, (127)                   ; Error
 in0 e, (255)                   ; Error
 in0 f, (-128)                  ; Error
 in0 f, (127)                   ; Error
 in0 f, (255)                   ; Error
 in0 h, (-128)                  ; Error
 in0 h, (127)                   ; Error
 in0 h, (255)                   ; Error
 in0 l, (-128)                  ; Error
 in0 l, (127)                   ; Error
 in0 l, (255)                   ; Error
 inc ixh                        ; Error
 inc ixl                        ; Error
 inc iyh                        ; Error
 inc iyl                        ; Error
 ind                            ; Error
 indr                           ; Error
 ini                            ; Error
 inir                           ; Error
 inr ixh                        ; Error
 inr ixl                        ; Error
 inr iyh                        ; Error
 inr iyl                        ; Error
 inx ixh                        ; Error
 inx iyh                        ; Error
 ioe altd bit -1, (hl)          ; Error
 ioe altd bit -1, (hl)          ; Error
 ioe altd bit -1, (ix)          ; Error
 ioe altd bit -1, (ix)          ; Error
 ioe altd bit -1, (ix+127)      ; Error
 ioe altd bit -1, (ix+127)      ; Error
 ioe altd bit -1, (ix-128)      ; Error
 ioe altd bit -1, (ix-128)      ; Error
 ioe altd bit -1, (iy)          ; Error
 ioe altd bit -1, (iy)          ; Error
 ioe altd bit -1, (iy+127)      ; Error
 ioe altd bit -1, (iy+127)      ; Error
 ioe altd bit -1, (iy-128)      ; Error
 ioe altd bit -1, (iy-128)      ; Error
 ioe altd bit 8, (hl)           ; Error
 ioe altd bit 8, (hl)           ; Error
 ioe altd bit 8, (ix)           ; Error
 ioe altd bit 8, (ix)           ; Error
 ioe altd bit 8, (ix+127)       ; Error
 ioe altd bit 8, (ix+127)       ; Error
 ioe altd bit 8, (ix-128)       ; Error
 ioe altd bit 8, (ix-128)       ; Error
 ioe altd bit 8, (iy)           ; Error
 ioe altd bit 8, (iy)           ; Error
 ioe altd bit 8, (iy+127)       ; Error
 ioe altd bit 8, (iy+127)       ; Error
 ioe altd bit 8, (iy-128)       ; Error
 ioe altd bit 8, (iy-128)       ; Error
 ioe bit -1, (hl)               ; Error
 ioe bit -1, (hl)               ; Error
 ioe bit -1, (ix)               ; Error
 ioe bit -1, (ix)               ; Error
 ioe bit -1, (ix+127)           ; Error
 ioe bit -1, (ix+127)           ; Error
 ioe bit -1, (ix-128)           ; Error
 ioe bit -1, (ix-128)           ; Error
 ioe bit -1, (iy)               ; Error
 ioe bit -1, (iy)               ; Error
 ioe bit -1, (iy+127)           ; Error
 ioe bit -1, (iy+127)           ; Error
 ioe bit -1, (iy-128)           ; Error
 ioe bit -1, (iy-128)           ; Error
 ioe bit 8, (hl)                ; Error
 ioe bit 8, (hl)                ; Error
 ioe bit 8, (ix)                ; Error
 ioe bit 8, (ix)                ; Error
 ioe bit 8, (ix+127)            ; Error
 ioe bit 8, (ix+127)            ; Error
 ioe bit 8, (ix-128)            ; Error
 ioe bit 8, (ix-128)            ; Error
 ioe bit 8, (iy)                ; Error
 ioe bit 8, (iy)                ; Error
 ioe bit 8, (iy+127)            ; Error
 ioe bit 8, (iy+127)            ; Error
 ioe bit 8, (iy-128)            ; Error
 ioe bit 8, (iy-128)            ; Error
 ioe bit.a -1, (hl)             ; Error
 ioe bit.a -1, (hl)             ; Error
 ioe bit.a -1, (ix)             ; Error
 ioe bit.a -1, (ix)             ; Error
 ioe bit.a -1, (ix+127)         ; Error
 ioe bit.a -1, (ix+127)         ; Error
 ioe bit.a -1, (ix-128)         ; Error
 ioe bit.a -1, (ix-128)         ; Error
 ioe bit.a -1, (iy)             ; Error
 ioe bit.a -1, (iy)             ; Error
 ioe bit.a -1, (iy+127)         ; Error
 ioe bit.a -1, (iy+127)         ; Error
 ioe bit.a -1, (iy-128)         ; Error
 ioe bit.a -1, (iy-128)         ; Error
 ioe bit.a 8, (hl)              ; Error
 ioe bit.a 8, (hl)              ; Error
 ioe bit.a 8, (ix)              ; Error
 ioe bit.a 8, (ix)              ; Error
 ioe bit.a 8, (ix+127)          ; Error
 ioe bit.a 8, (ix+127)          ; Error
 ioe bit.a 8, (ix-128)          ; Error
 ioe bit.a 8, (ix-128)          ; Error
 ioe bit.a 8, (iy)              ; Error
 ioe bit.a 8, (iy)              ; Error
 ioe bit.a 8, (iy+127)          ; Error
 ioe bit.a 8, (iy+127)          ; Error
 ioe bit.a 8, (iy-128)          ; Error
 ioe bit.a 8, (iy-128)          ; Error
 ioe res -1, (hl)               ; Error
 ioe res -1, (hl)               ; Error
 ioe res -1, (ix)               ; Error
 ioe res -1, (ix)               ; Error
 ioe res -1, (ix+127)           ; Error
 ioe res -1, (ix+127)           ; Error
 ioe res -1, (ix-128)           ; Error
 ioe res -1, (ix-128)           ; Error
 ioe res -1, (iy)               ; Error
 ioe res -1, (iy)               ; Error
 ioe res -1, (iy+127)           ; Error
 ioe res -1, (iy+127)           ; Error
 ioe res -1, (iy-128)           ; Error
 ioe res -1, (iy-128)           ; Error
 ioe res 8, (hl)                ; Error
 ioe res 8, (hl)                ; Error
 ioe res 8, (ix)                ; Error
 ioe res 8, (ix)                ; Error
 ioe res 8, (ix+127)            ; Error
 ioe res 8, (ix+127)            ; Error
 ioe res 8, (ix-128)            ; Error
 ioe res 8, (ix-128)            ; Error
 ioe res 8, (iy)                ; Error
 ioe res 8, (iy)                ; Error
 ioe res 8, (iy+127)            ; Error
 ioe res 8, (iy+127)            ; Error
 ioe res 8, (iy-128)            ; Error
 ioe res 8, (iy-128)            ; Error
 ioe res.a -1, (hl)             ; Error
 ioe res.a -1, (hl)             ; Error
 ioe res.a -1, (ix)             ; Error
 ioe res.a -1, (ix)             ; Error
 ioe res.a -1, (ix+127)         ; Error
 ioe res.a -1, (ix+127)         ; Error
 ioe res.a -1, (ix-128)         ; Error
 ioe res.a -1, (ix-128)         ; Error
 ioe res.a -1, (iy)             ; Error
 ioe res.a -1, (iy)             ; Error
 ioe res.a -1, (iy+127)         ; Error
 ioe res.a -1, (iy+127)         ; Error
 ioe res.a -1, (iy-128)         ; Error
 ioe res.a -1, (iy-128)         ; Error
 ioe res.a 8, (hl)              ; Error
 ioe res.a 8, (hl)              ; Error
 ioe res.a 8, (ix)              ; Error
 ioe res.a 8, (ix)              ; Error
 ioe res.a 8, (ix+127)          ; Error
 ioe res.a 8, (ix+127)          ; Error
 ioe res.a 8, (ix-128)          ; Error
 ioe res.a 8, (ix-128)          ; Error
 ioe res.a 8, (iy)              ; Error
 ioe res.a 8, (iy)              ; Error
 ioe res.a 8, (iy+127)          ; Error
 ioe res.a 8, (iy+127)          ; Error
 ioe res.a 8, (iy-128)          ; Error
 ioe res.a 8, (iy-128)          ; Error
 ioe set -1, (hl)               ; Error
 ioe set -1, (hl)               ; Error
 ioe set -1, (ix)               ; Error
 ioe set -1, (ix)               ; Error
 ioe set -1, (ix+127)           ; Error
 ioe set -1, (ix+127)           ; Error
 ioe set -1, (ix-128)           ; Error
 ioe set -1, (ix-128)           ; Error
 ioe set -1, (iy)               ; Error
 ioe set -1, (iy)               ; Error
 ioe set -1, (iy+127)           ; Error
 ioe set -1, (iy+127)           ; Error
 ioe set -1, (iy-128)           ; Error
 ioe set -1, (iy-128)           ; Error
 ioe set 8, (hl)                ; Error
 ioe set 8, (hl)                ; Error
 ioe set 8, (ix)                ; Error
 ioe set 8, (ix)                ; Error
 ioe set 8, (ix+127)            ; Error
 ioe set 8, (ix+127)            ; Error
 ioe set 8, (ix-128)            ; Error
 ioe set 8, (ix-128)            ; Error
 ioe set 8, (iy)                ; Error
 ioe set 8, (iy)                ; Error
 ioe set 8, (iy+127)            ; Error
 ioe set 8, (iy+127)            ; Error
 ioe set 8, (iy-128)            ; Error
 ioe set 8, (iy-128)            ; Error
 ioe set.a -1, (hl)             ; Error
 ioe set.a -1, (hl)             ; Error
 ioe set.a -1, (ix)             ; Error
 ioe set.a -1, (ix)             ; Error
 ioe set.a -1, (ix+127)         ; Error
 ioe set.a -1, (ix+127)         ; Error
 ioe set.a -1, (ix-128)         ; Error
 ioe set.a -1, (ix-128)         ; Error
 ioe set.a -1, (iy)             ; Error
 ioe set.a -1, (iy)             ; Error
 ioe set.a -1, (iy+127)         ; Error
 ioe set.a -1, (iy+127)         ; Error
 ioe set.a -1, (iy-128)         ; Error
 ioe set.a -1, (iy-128)         ; Error
 ioe set.a 8, (hl)              ; Error
 ioe set.a 8, (hl)              ; Error
 ioe set.a 8, (ix)              ; Error
 ioe set.a 8, (ix)              ; Error
 ioe set.a 8, (ix+127)          ; Error
 ioe set.a 8, (ix+127)          ; Error
 ioe set.a 8, (ix-128)          ; Error
 ioe set.a 8, (ix-128)          ; Error
 ioe set.a 8, (iy)              ; Error
 ioe set.a 8, (iy)              ; Error
 ioe set.a 8, (iy+127)          ; Error
 ioe set.a 8, (iy+127)          ; Error
 ioe set.a 8, (iy-128)          ; Error
 ioe set.a 8, (iy-128)          ; Error
 ioi altd bit -1, (hl)          ; Error
 ioi altd bit -1, (hl)          ; Error
 ioi altd bit -1, (ix)          ; Error
 ioi altd bit -1, (ix)          ; Error
 ioi altd bit -1, (ix+127)      ; Error
 ioi altd bit -1, (ix+127)      ; Error
 ioi altd bit -1, (ix-128)      ; Error
 ioi altd bit -1, (ix-128)      ; Error
 ioi altd bit -1, (iy)          ; Error
 ioi altd bit -1, (iy)          ; Error
 ioi altd bit -1, (iy+127)      ; Error
 ioi altd bit -1, (iy+127)      ; Error
 ioi altd bit -1, (iy-128)      ; Error
 ioi altd bit -1, (iy-128)      ; Error
 ioi altd bit 8, (hl)           ; Error
 ioi altd bit 8, (hl)           ; Error
 ioi altd bit 8, (ix)           ; Error
 ioi altd bit 8, (ix)           ; Error
 ioi altd bit 8, (ix+127)       ; Error
 ioi altd bit 8, (ix+127)       ; Error
 ioi altd bit 8, (ix-128)       ; Error
 ioi altd bit 8, (ix-128)       ; Error
 ioi altd bit 8, (iy)           ; Error
 ioi altd bit 8, (iy)           ; Error
 ioi altd bit 8, (iy+127)       ; Error
 ioi altd bit 8, (iy+127)       ; Error
 ioi altd bit 8, (iy-128)       ; Error
 ioi altd bit 8, (iy-128)       ; Error
 ioi bit -1, (hl)               ; Error
 ioi bit -1, (hl)               ; Error
 ioi bit -1, (ix)               ; Error
 ioi bit -1, (ix)               ; Error
 ioi bit -1, (ix+127)           ; Error
 ioi bit -1, (ix+127)           ; Error
 ioi bit -1, (ix-128)           ; Error
 ioi bit -1, (ix-128)           ; Error
 ioi bit -1, (iy)               ; Error
 ioi bit -1, (iy)               ; Error
 ioi bit -1, (iy+127)           ; Error
 ioi bit -1, (iy+127)           ; Error
 ioi bit -1, (iy-128)           ; Error
 ioi bit -1, (iy-128)           ; Error
 ioi bit 8, (hl)                ; Error
 ioi bit 8, (hl)                ; Error
 ioi bit 8, (ix)                ; Error
 ioi bit 8, (ix)                ; Error
 ioi bit 8, (ix+127)            ; Error
 ioi bit 8, (ix+127)            ; Error
 ioi bit 8, (ix-128)            ; Error
 ioi bit 8, (ix-128)            ; Error
 ioi bit 8, (iy)                ; Error
 ioi bit 8, (iy)                ; Error
 ioi bit 8, (iy+127)            ; Error
 ioi bit 8, (iy+127)            ; Error
 ioi bit 8, (iy-128)            ; Error
 ioi bit 8, (iy-128)            ; Error
 ioi bit.a -1, (hl)             ; Error
 ioi bit.a -1, (hl)             ; Error
 ioi bit.a -1, (ix)             ; Error
 ioi bit.a -1, (ix)             ; Error
 ioi bit.a -1, (ix+127)         ; Error
 ioi bit.a -1, (ix+127)         ; Error
 ioi bit.a -1, (ix-128)         ; Error
 ioi bit.a -1, (ix-128)         ; Error
 ioi bit.a -1, (iy)             ; Error
 ioi bit.a -1, (iy)             ; Error
 ioi bit.a -1, (iy+127)         ; Error
 ioi bit.a -1, (iy+127)         ; Error
 ioi bit.a -1, (iy-128)         ; Error
 ioi bit.a -1, (iy-128)         ; Error
 ioi bit.a 8, (hl)              ; Error
 ioi bit.a 8, (hl)              ; Error
 ioi bit.a 8, (ix)              ; Error
 ioi bit.a 8, (ix)              ; Error
 ioi bit.a 8, (ix+127)          ; Error
 ioi bit.a 8, (ix+127)          ; Error
 ioi bit.a 8, (ix-128)          ; Error
 ioi bit.a 8, (ix-128)          ; Error
 ioi bit.a 8, (iy)              ; Error
 ioi bit.a 8, (iy)              ; Error
 ioi bit.a 8, (iy+127)          ; Error
 ioi bit.a 8, (iy+127)          ; Error
 ioi bit.a 8, (iy-128)          ; Error
 ioi bit.a 8, (iy-128)          ; Error
 ioi res -1, (hl)               ; Error
 ioi res -1, (hl)               ; Error
 ioi res -1, (ix)               ; Error
 ioi res -1, (ix)               ; Error
 ioi res -1, (ix+127)           ; Error
 ioi res -1, (ix+127)           ; Error
 ioi res -1, (ix-128)           ; Error
 ioi res -1, (ix-128)           ; Error
 ioi res -1, (iy)               ; Error
 ioi res -1, (iy)               ; Error
 ioi res -1, (iy+127)           ; Error
 ioi res -1, (iy+127)           ; Error
 ioi res -1, (iy-128)           ; Error
 ioi res -1, (iy-128)           ; Error
 ioi res 8, (hl)                ; Error
 ioi res 8, (hl)                ; Error
 ioi res 8, (ix)                ; Error
 ioi res 8, (ix)                ; Error
 ioi res 8, (ix+127)            ; Error
 ioi res 8, (ix+127)            ; Error
 ioi res 8, (ix-128)            ; Error
 ioi res 8, (ix-128)            ; Error
 ioi res 8, (iy)                ; Error
 ioi res 8, (iy)                ; Error
 ioi res 8, (iy+127)            ; Error
 ioi res 8, (iy+127)            ; Error
 ioi res 8, (iy-128)            ; Error
 ioi res 8, (iy-128)            ; Error
 ioi res.a -1, (hl)             ; Error
 ioi res.a -1, (hl)             ; Error
 ioi res.a -1, (ix)             ; Error
 ioi res.a -1, (ix)             ; Error
 ioi res.a -1, (ix+127)         ; Error
 ioi res.a -1, (ix+127)         ; Error
 ioi res.a -1, (ix-128)         ; Error
 ioi res.a -1, (ix-128)         ; Error
 ioi res.a -1, (iy)             ; Error
 ioi res.a -1, (iy)             ; Error
 ioi res.a -1, (iy+127)         ; Error
 ioi res.a -1, (iy+127)         ; Error
 ioi res.a -1, (iy-128)         ; Error
 ioi res.a -1, (iy-128)         ; Error
 ioi res.a 8, (hl)              ; Error
 ioi res.a 8, (hl)              ; Error
 ioi res.a 8, (ix)              ; Error
 ioi res.a 8, (ix)              ; Error
 ioi res.a 8, (ix+127)          ; Error
 ioi res.a 8, (ix+127)          ; Error
 ioi res.a 8, (ix-128)          ; Error
 ioi res.a 8, (ix-128)          ; Error
 ioi res.a 8, (iy)              ; Error
 ioi res.a 8, (iy)              ; Error
 ioi res.a 8, (iy+127)          ; Error
 ioi res.a 8, (iy+127)          ; Error
 ioi res.a 8, (iy-128)          ; Error
 ioi res.a 8, (iy-128)          ; Error
 ioi set -1, (hl)               ; Error
 ioi set -1, (hl)               ; Error
 ioi set -1, (ix)               ; Error
 ioi set -1, (ix)               ; Error
 ioi set -1, (ix+127)           ; Error
 ioi set -1, (ix+127)           ; Error
 ioi set -1, (ix-128)           ; Error
 ioi set -1, (ix-128)           ; Error
 ioi set -1, (iy)               ; Error
 ioi set -1, (iy)               ; Error
 ioi set -1, (iy+127)           ; Error
 ioi set -1, (iy+127)           ; Error
 ioi set -1, (iy-128)           ; Error
 ioi set -1, (iy-128)           ; Error
 ioi set 8, (hl)                ; Error
 ioi set 8, (hl)                ; Error
 ioi set 8, (ix)                ; Error
 ioi set 8, (ix)                ; Error
 ioi set 8, (ix+127)            ; Error
 ioi set 8, (ix+127)            ; Error
 ioi set 8, (ix-128)            ; Error
 ioi set 8, (ix-128)            ; Error
 ioi set 8, (iy)                ; Error
 ioi set 8, (iy)                ; Error
 ioi set 8, (iy+127)            ; Error
 ioi set 8, (iy+127)            ; Error
 ioi set 8, (iy-128)            ; Error
 ioi set 8, (iy-128)            ; Error
 ioi set.a -1, (hl)             ; Error
 ioi set.a -1, (hl)             ; Error
 ioi set.a -1, (ix)             ; Error
 ioi set.a -1, (ix)             ; Error
 ioi set.a -1, (ix+127)         ; Error
 ioi set.a -1, (ix+127)         ; Error
 ioi set.a -1, (ix-128)         ; Error
 ioi set.a -1, (ix-128)         ; Error
 ioi set.a -1, (iy)             ; Error
 ioi set.a -1, (iy)             ; Error
 ioi set.a -1, (iy+127)         ; Error
 ioi set.a -1, (iy+127)         ; Error
 ioi set.a -1, (iy-128)         ; Error
 ioi set.a -1, (iy-128)         ; Error
 ioi set.a 8, (hl)              ; Error
 ioi set.a 8, (hl)              ; Error
 ioi set.a 8, (ix)              ; Error
 ioi set.a 8, (ix)              ; Error
 ioi set.a 8, (ix+127)          ; Error
 ioi set.a 8, (ix+127)          ; Error
 ioi set.a 8, (ix-128)          ; Error
 ioi set.a 8, (ix-128)          ; Error
 ioi set.a 8, (iy)              ; Error
 ioi set.a 8, (iy)              ; Error
 ioi set.a 8, (iy+127)          ; Error
 ioi set.a 8, (iy+127)          ; Error
 ioi set.a 8, (iy-128)          ; Error
 ioi set.a 8, (iy-128)          ; Error
 ipset -1                       ; Error
 ipset -1                       ; Error
 ipset 4                        ; Error
 ipset 4                        ; Error
 j_k -32768                     ; Error
 j_k 32767                      ; Error
 j_k 65535                      ; Error
 j_nk -32768                    ; Error
 j_nk 32767                     ; Error
 j_nk 65535                     ; Error
 j_nx5 -32768                   ; Error
 j_nx5 32767                    ; Error
 j_nx5 65535                    ; Error
 j_x5 -32768                    ; Error
 j_x5 32767                     ; Error
 j_x5 65535                     ; Error
 jk -32768                      ; Error
 jk 32767                       ; Error
 jk 65535                       ; Error
 jnk -32768                     ; Error
 jnk 32767                      ; Error
 jnk 65535                      ; Error
 jnx5 -32768                    ; Error
 jnx5 32767                     ; Error
 jnx5 65535                     ; Error
 jp (c)                         ; Error
 jx5 -32768                     ; Error
 jx5 32767                      ; Error
 jx5 65535                      ; Error
 ld (c), a                      ; Error
 ld (de), hl                    ; Error
 ld a, (c)                      ; Error
 ld a, i                        ; Error
 ld a, ixh                      ; Error
 ld a, ixl                      ; Error
 ld a, iyh                      ; Error
 ld a, iyl                      ; Error
 ld a, r                        ; Error
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
 ld de, hl+0                    ; Error
 ld de, hl+255                  ; Error
 ld de, sp                      ; Error
 ld de, sp+0                    ; Error
 ld de, sp+255                  ; Error
 ld e, ixh                      ; Error
 ld e, ixl                      ; Error
 ld e, iyh                      ; Error
 ld e, iyl                      ; Error
 ld hl, (de)                    ; Error
 ld hl, sp                      ; Error
 ld hl, sp+-128                 ; Error
 ld hl, sp+127                  ; Error
 ld i, a                        ; Error
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
 ld r, a                        ; Error
 lddrx                          ; Error
 lddx                           ; Error
 ldh (-128), a                  ; Error
 ldh (127), a                   ; Error
 ldh (255), a                   ; Error
 ldh (c), a                     ; Error
 ldh a, (-128)                  ; Error
 ldh a, (127)                   ; Error
 ldh a, (255)                   ; Error
 ldh a, (c)                     ; Error
 ldhi -128                      ; Error
 ldhi 127                       ; Error
 ldhi 255                       ; Error
 ldhl sp, -128                  ; Error
 ldhl sp, 127                   ; Error
 ldirx                          ; Error
 ldix                           ; Error
 ldpirx                         ; Error
 ldsi -128                      ; Error
 ldsi 127                       ; Error
 ldsi 255                       ; Error
 ldws                           ; Error
 lhlde                          ; Error
 lhlx                           ; Error
 lxi ixh, -32768                ; Error
 lxi ixh, 32767                 ; Error
 lxi ixh, 65535                 ; Error
 lxi iyh, -32768                ; Error
 lxi iyh, 32767                 ; Error
 lxi iyh, 65535                 ; Error
 mirror a                       ; Error
 mlt bc                         ; Error
 mlt de                         ; Error
 mlt hl                         ; Error
 mlt sp                         ; Error
 mmu -1, -128                   ; Error
 mmu -1, -128                   ; Error
 mmu -1, 127                    ; Error
 mmu -1, 127                    ; Error
 mmu -1, 255                    ; Error
 mmu -1, 255                    ; Error
 mmu -1, a                      ; Error
 mmu -1, a                      ; Error
 mmu 0, -128                    ; Error
 mmu 0, 127                     ; Error
 mmu 0, 255                     ; Error
 mmu 0, a                       ; Error
 mmu 1, -128                    ; Error
 mmu 1, 127                     ; Error
 mmu 1, 255                     ; Error
 mmu 1, a                       ; Error
 mmu 2, -128                    ; Error
 mmu 2, 127                     ; Error
 mmu 2, 255                     ; Error
 mmu 2, a                       ; Error
 mmu 3, -128                    ; Error
 mmu 3, 127                     ; Error
 mmu 3, 255                     ; Error
 mmu 3, a                       ; Error
 mmu 4, -128                    ; Error
 mmu 4, 127                     ; Error
 mmu 4, 255                     ; Error
 mmu 4, a                       ; Error
 mmu 5, -128                    ; Error
 mmu 5, 127                     ; Error
 mmu 5, 255                     ; Error
 mmu 5, a                       ; Error
 mmu 6, -128                    ; Error
 mmu 6, 127                     ; Error
 mmu 6, 255                     ; Error
 mmu 6, a                       ; Error
 mmu 7, -128                    ; Error
 mmu 7, 127                     ; Error
 mmu 7, 255                     ; Error
 mmu 7, a                       ; Error
 mmu 8, -128                    ; Error
 mmu 8, -128                    ; Error
 mmu 8, 127                     ; Error
 mmu 8, 127                     ; Error
 mmu 8, 255                     ; Error
 mmu 8, 255                     ; Error
 mmu 8, a                       ; Error
 mmu 8, a                       ; Error
 mmu0 -128                      ; Error
 mmu0 127                       ; Error
 mmu0 255                       ; Error
 mmu0 a                         ; Error
 mmu1 -128                      ; Error
 mmu1 127                       ; Error
 mmu1 255                       ; Error
 mmu1 a                         ; Error
 mmu2 -128                      ; Error
 mmu2 127                       ; Error
 mmu2 255                       ; Error
 mmu2 a                         ; Error
 mmu3 -128                      ; Error
 mmu3 127                       ; Error
 mmu3 255                       ; Error
 mmu3 a                         ; Error
 mmu4 -128                      ; Error
 mmu4 127                       ; Error
 mmu4 255                       ; Error
 mmu4 a                         ; Error
 mmu5 -128                      ; Error
 mmu5 127                       ; Error
 mmu5 255                       ; Error
 mmu5 a                         ; Error
 mmu6 -128                      ; Error
 mmu6 127                       ; Error
 mmu6 255                       ; Error
 mmu6 a                         ; Error
 mmu7 -128                      ; Error
 mmu7 127                       ; Error
 mmu7 255                       ; Error
 mmu7 a                         ; Error
 mov a, ixh                     ; Error
 mov a, ixl                     ; Error
 mov a, iyh                     ; Error
 mov a, iyl                     ; Error
 mov b, ixh                     ; Error
 mov b, ixl                     ; Error
 mov b, iyh                     ; Error
 mov b, iyl                     ; Error
 mov c, ixh                     ; Error
 mov c, ixl                     ; Error
 mov c, iyh                     ; Error
 mov c, iyl                     ; Error
 mov d, ixh                     ; Error
 mov d, ixl                     ; Error
 mov d, iyh                     ; Error
 mov d, iyl                     ; Error
 mov e, ixh                     ; Error
 mov e, ixl                     ; Error
 mov e, iyh                     ; Error
 mov e, iyl                     ; Error
 mov ixh, a                     ; Error
 mov ixh, b                     ; Error
 mov ixh, c                     ; Error
 mov ixh, d                     ; Error
 mov ixh, e                     ; Error
 mov ixh, ixh                   ; Error
 mov ixh, ixl                   ; Error
 mov ixh, m                     ; Error
 mov ixl, a                     ; Error
 mov ixl, b                     ; Error
 mov ixl, c                     ; Error
 mov ixl, d                     ; Error
 mov ixl, e                     ; Error
 mov ixl, ixh                   ; Error
 mov ixl, ixl                   ; Error
 mov ixl, m                     ; Error
 mov iyh, a                     ; Error
 mov iyh, b                     ; Error
 mov iyh, c                     ; Error
 mov iyh, d                     ; Error
 mov iyh, e                     ; Error
 mov iyh, iyh                   ; Error
 mov iyh, iyl                   ; Error
 mov iyh, m                     ; Error
 mov iyl, a                     ; Error
 mov iyl, b                     ; Error
 mov iyl, c                     ; Error
 mov iyl, d                     ; Error
 mov iyl, e                     ; Error
 mov iyl, iyh                   ; Error
 mov iyl, iyl                   ; Error
 mov iyl, m                     ; Error
 mov m, ixh                     ; Error
 mov m, ixl                     ; Error
 mov m, iyh                     ; Error
 mov m, iyl                     ; Error
 mul d, e                       ; Error
 mul de                         ; Error
 mvi ixh, -128                  ; Error
 mvi ixh, 127                   ; Error
 mvi ixh, 255                   ; Error
 mvi ixl, -128                  ; Error
 mvi ixl, 127                   ; Error
 mvi ixl, 255                   ; Error
 mvi iyh, -128                  ; Error
 mvi iyh, 127                   ; Error
 mvi iyh, 255                   ; Error
 mvi iyl, -128                  ; Error
 mvi iyl, 127                   ; Error
 mvi iyl, 255                   ; Error
 nextreg -128, -128             ; Error
 nextreg -128, a                ; Error
 nextreg 127, 127               ; Error
 nextreg 127, a                 ; Error
 nextreg 255, 255               ; Error
 nextreg 255, a                 ; Error
 or a, ixh                      ; Error
 or a, ixl                      ; Error
 or a, iyh                      ; Error
 or a, iyl                      ; Error
 or ixh                         ; Error
 or ixl                         ; Error
 or iyh                         ; Error
 or iyl                         ; Error
 ora ixh                        ; Error
 ora ixl                        ; Error
 ora iyh                        ; Error
 ora iyl                        ; Error
 otdm                           ; Error
 otdmr                          ; Error
 otdr                           ; Error
 otim                           ; Error
 otimr                          ; Error
 otir                           ; Error
 out (-128), a                  ; Error
 out (127), a                   ; Error
 out (255), a                   ; Error
 out (c), -1                    ; Error
 out (c), -1                    ; Error
 out (c), 0                     ; Error
 out (c), 1                     ; Error
 out (c), 1                     ; Error
 out (c), a                     ; Error
 out (c), b                     ; Error
 out (c), c                     ; Error
 out (c), d                     ; Error
 out (c), e                     ; Error
 out (c), h                     ; Error
 out (c), l                     ; Error
 out -128                       ; Error
 out 127                        ; Error
 out 255                        ; Error
 out0 (-128), a                 ; Error
 out0 (-128), b                 ; Error
 out0 (-128), c                 ; Error
 out0 (-128), d                 ; Error
 out0 (-128), e                 ; Error
 out0 (-128), h                 ; Error
 out0 (-128), l                 ; Error
 out0 (127), a                  ; Error
 out0 (127), b                  ; Error
 out0 (127), c                  ; Error
 out0 (127), d                  ; Error
 out0 (127), e                  ; Error
 out0 (127), h                  ; Error
 out0 (127), l                  ; Error
 out0 (255), a                  ; Error
 out0 (255), b                  ; Error
 out0 (255), c                  ; Error
 out0 (255), d                  ; Error
 out0 (255), e                  ; Error
 out0 (255), h                  ; Error
 out0 (255), l                  ; Error
 outd                           ; Error
 outi                           ; Error
 outinb                         ; Error
 ovrst8                         ; Error
 pixelad                        ; Error
 pixeldn                        ; Error
 pop ixh                        ; Error
 pop iyh                        ; Error
 push -32768                    ; Error
 push 32767                     ; Error
 push 65535                     ; Error
 push ixh                       ; Error
 push iyh                       ; Error
 rdel                           ; Error
 res -1, (hl)                   ; Error
 res -1, (hl)                   ; Error
 res -1, (ix)                   ; Error
 res -1, (ix)                   ; Error
 res -1, (ix+127)               ; Error
 res -1, (ix+127)               ; Error
 res -1, (ix-128)               ; Error
 res -1, (ix-128)               ; Error
 res -1, (iy)                   ; Error
 res -1, (iy)                   ; Error
 res -1, (iy+127)               ; Error
 res -1, (iy+127)               ; Error
 res -1, (iy-128)               ; Error
 res -1, (iy-128)               ; Error
 res -1, a                      ; Error
 res -1, a                      ; Error
 res -1, a'                     ; Error
 res -1, a'                     ; Error
 res -1, b                      ; Error
 res -1, b                      ; Error
 res -1, b'                     ; Error
 res -1, b'                     ; Error
 res -1, c                      ; Error
 res -1, c                      ; Error
 res -1, c'                     ; Error
 res -1, c'                     ; Error
 res -1, d                      ; Error
 res -1, d                      ; Error
 res -1, d'                     ; Error
 res -1, d'                     ; Error
 res -1, e                      ; Error
 res -1, e                      ; Error
 res -1, e'                     ; Error
 res -1, e'                     ; Error
 res -1, h                      ; Error
 res -1, h                      ; Error
 res -1, h'                     ; Error
 res -1, h'                     ; Error
 res -1, ixh                    ; Error
 res -1, ixh                    ; Error
 res -1, ixl                    ; Error
 res -1, ixl                    ; Error
 res -1, iyh                    ; Error
 res -1, iyh                    ; Error
 res -1, iyl                    ; Error
 res -1, iyl                    ; Error
 res -1, l                      ; Error
 res -1, l                      ; Error
 res -1, l'                     ; Error
 res -1, l'                     ; Error
 res 0, ixh                     ; Error
 res 0, ixl                     ; Error
 res 0, iyh                     ; Error
 res 0, iyl                     ; Error
 res 1, ixh                     ; Error
 res 1, ixl                     ; Error
 res 1, iyh                     ; Error
 res 1, iyl                     ; Error
 res 2, ixh                     ; Error
 res 2, ixl                     ; Error
 res 2, iyh                     ; Error
 res 2, iyl                     ; Error
 res 3, ixh                     ; Error
 res 3, ixl                     ; Error
 res 3, iyh                     ; Error
 res 3, iyl                     ; Error
 res 4, ixh                     ; Error
 res 4, ixl                     ; Error
 res 4, iyh                     ; Error
 res 4, iyl                     ; Error
 res 5, ixh                     ; Error
 res 5, ixl                     ; Error
 res 5, iyh                     ; Error
 res 5, iyl                     ; Error
 res 6, ixh                     ; Error
 res 6, ixl                     ; Error
 res 6, iyh                     ; Error
 res 6, iyl                     ; Error
 res 7, ixh                     ; Error
 res 7, ixl                     ; Error
 res 7, iyh                     ; Error
 res 7, iyl                     ; Error
 res 8, (hl)                    ; Error
 res 8, (hl)                    ; Error
 res 8, (ix)                    ; Error
 res 8, (ix)                    ; Error
 res 8, (ix+127)                ; Error
 res 8, (ix+127)                ; Error
 res 8, (ix-128)                ; Error
 res 8, (ix-128)                ; Error
 res 8, (iy)                    ; Error
 res 8, (iy)                    ; Error
 res 8, (iy+127)                ; Error
 res 8, (iy+127)                ; Error
 res 8, (iy-128)                ; Error
 res 8, (iy-128)                ; Error
 res 8, a                       ; Error
 res 8, a                       ; Error
 res 8, a'                      ; Error
 res 8, a'                      ; Error
 res 8, b                       ; Error
 res 8, b                       ; Error
 res 8, b'                      ; Error
 res 8, b'                      ; Error
 res 8, c                       ; Error
 res 8, c                       ; Error
 res 8, c'                      ; Error
 res 8, c'                      ; Error
 res 8, d                       ; Error
 res 8, d                       ; Error
 res 8, d'                      ; Error
 res 8, d'                      ; Error
 res 8, e                       ; Error
 res 8, e                       ; Error
 res 8, e'                      ; Error
 res 8, e'                      ; Error
 res 8, h                       ; Error
 res 8, h                       ; Error
 res 8, h'                      ; Error
 res 8, h'                      ; Error
 res 8, ixh                     ; Error
 res 8, ixh                     ; Error
 res 8, ixl                     ; Error
 res 8, ixl                     ; Error
 res 8, iyh                     ; Error
 res 8, iyh                     ; Error
 res 8, iyl                     ; Error
 res 8, iyl                     ; Error
 res 8, l                       ; Error
 res 8, l                       ; Error
 res 8, l'                      ; Error
 res 8, l'                      ; Error
 res.a -1, (hl)                 ; Error
 res.a -1, (hl)                 ; Error
 res.a -1, (ix)                 ; Error
 res.a -1, (ix)                 ; Error
 res.a -1, (ix+127)             ; Error
 res.a -1, (ix+127)             ; Error
 res.a -1, (ix-128)             ; Error
 res.a -1, (ix-128)             ; Error
 res.a -1, (iy)                 ; Error
 res.a -1, (iy)                 ; Error
 res.a -1, (iy+127)             ; Error
 res.a -1, (iy+127)             ; Error
 res.a -1, (iy-128)             ; Error
 res.a -1, (iy-128)             ; Error
 res.a -1, a                    ; Error
 res.a -1, a                    ; Error
 res.a -1, b                    ; Error
 res.a -1, b                    ; Error
 res.a -1, c                    ; Error
 res.a -1, c                    ; Error
 res.a -1, d                    ; Error
 res.a -1, d                    ; Error
 res.a -1, e                    ; Error
 res.a -1, e                    ; Error
 res.a -1, h                    ; Error
 res.a -1, h                    ; Error
 res.a -1, ixh                  ; Error
 res.a -1, ixh                  ; Error
 res.a -1, ixl                  ; Error
 res.a -1, ixl                  ; Error
 res.a -1, iyh                  ; Error
 res.a -1, iyh                  ; Error
 res.a -1, iyl                  ; Error
 res.a -1, iyl                  ; Error
 res.a -1, l                    ; Error
 res.a -1, l                    ; Error
 res.a 0, ixh                   ; Error
 res.a 0, ixl                   ; Error
 res.a 0, iyh                   ; Error
 res.a 0, iyl                   ; Error
 res.a 1, ixh                   ; Error
 res.a 1, ixl                   ; Error
 res.a 1, iyh                   ; Error
 res.a 1, iyl                   ; Error
 res.a 2, ixh                   ; Error
 res.a 2, ixl                   ; Error
 res.a 2, iyh                   ; Error
 res.a 2, iyl                   ; Error
 res.a 3, ixh                   ; Error
 res.a 3, ixl                   ; Error
 res.a 3, iyh                   ; Error
 res.a 3, iyl                   ; Error
 res.a 4, ixh                   ; Error
 res.a 4, ixl                   ; Error
 res.a 4, iyh                   ; Error
 res.a 4, iyl                   ; Error
 res.a 5, ixh                   ; Error
 res.a 5, ixl                   ; Error
 res.a 5, iyh                   ; Error
 res.a 5, iyl                   ; Error
 res.a 6, ixh                   ; Error
 res.a 6, ixl                   ; Error
 res.a 6, iyh                   ; Error
 res.a 6, iyl                   ; Error
 res.a 7, ixh                   ; Error
 res.a 7, ixl                   ; Error
 res.a 7, iyh                   ; Error
 res.a 7, iyl                   ; Error
 res.a 8, (hl)                  ; Error
 res.a 8, (hl)                  ; Error
 res.a 8, (ix)                  ; Error
 res.a 8, (ix)                  ; Error
 res.a 8, (ix+127)              ; Error
 res.a 8, (ix+127)              ; Error
 res.a 8, (ix-128)              ; Error
 res.a 8, (ix-128)              ; Error
 res.a 8, (iy)                  ; Error
 res.a 8, (iy)                  ; Error
 res.a 8, (iy+127)              ; Error
 res.a 8, (iy+127)              ; Error
 res.a 8, (iy-128)              ; Error
 res.a 8, (iy-128)              ; Error
 res.a 8, a                     ; Error
 res.a 8, a                     ; Error
 res.a 8, b                     ; Error
 res.a 8, b                     ; Error
 res.a 8, c                     ; Error
 res.a 8, c                     ; Error
 res.a 8, d                     ; Error
 res.a 8, d                     ; Error
 res.a 8, e                     ; Error
 res.a 8, e                     ; Error
 res.a 8, h                     ; Error
 res.a 8, h                     ; Error
 res.a 8, ixh                   ; Error
 res.a 8, ixh                   ; Error
 res.a 8, ixl                   ; Error
 res.a 8, ixl                   ; Error
 res.a 8, iyh                   ; Error
 res.a 8, iyh                   ; Error
 res.a 8, iyl                   ; Error
 res.a 8, iyl                   ; Error
 res.a 8, l                     ; Error
 res.a 8, l                     ; Error
 retn                           ; Error
 rim                            ; Error
 rl (ix), a                     ; Error
 rl (ix), b                     ; Error
 rl (ix), c                     ; Error
 rl (ix), d                     ; Error
 rl (ix), e                     ; Error
 rl (ix), h                     ; Error
 rl (ix), l                     ; Error
 rl (ix+127), a                 ; Error
 rl (ix+127), b                 ; Error
 rl (ix+127), c                 ; Error
 rl (ix+127), d                 ; Error
 rl (ix+127), e                 ; Error
 rl (ix+127), h                 ; Error
 rl (ix+127), l                 ; Error
 rl (ix-128), a                 ; Error
 rl (ix-128), b                 ; Error
 rl (ix-128), c                 ; Error
 rl (ix-128), d                 ; Error
 rl (ix-128), e                 ; Error
 rl (ix-128), h                 ; Error
 rl (ix-128), l                 ; Error
 rl (iy), a                     ; Error
 rl (iy), b                     ; Error
 rl (iy), c                     ; Error
 rl (iy), d                     ; Error
 rl (iy), e                     ; Error
 rl (iy), h                     ; Error
 rl (iy), l                     ; Error
 rl (iy+127), a                 ; Error
 rl (iy+127), b                 ; Error
 rl (iy+127), c                 ; Error
 rl (iy+127), d                 ; Error
 rl (iy+127), e                 ; Error
 rl (iy+127), h                 ; Error
 rl (iy+127), l                 ; Error
 rl (iy-128), a                 ; Error
 rl (iy-128), b                 ; Error
 rl (iy-128), c                 ; Error
 rl (iy-128), d                 ; Error
 rl (iy-128), e                 ; Error
 rl (iy-128), h                 ; Error
 rl (iy-128), l                 ; Error
 rl ixh                         ; Error
 rl ixl                         ; Error
 rl iyh                         ; Error
 rl iyl                         ; Error
 rlc (ix), a                    ; Error
 rlc (ix), b                    ; Error
 rlc (ix), c                    ; Error
 rlc (ix), d                    ; Error
 rlc (ix), e                    ; Error
 rlc (ix), h                    ; Error
 rlc (ix), l                    ; Error
 rlc (ix+127), a                ; Error
 rlc (ix+127), b                ; Error
 rlc (ix+127), c                ; Error
 rlc (ix+127), d                ; Error
 rlc (ix+127), e                ; Error
 rlc (ix+127), h                ; Error
 rlc (ix+127), l                ; Error
 rlc (ix-128), a                ; Error
 rlc (ix-128), b                ; Error
 rlc (ix-128), c                ; Error
 rlc (ix-128), d                ; Error
 rlc (ix-128), e                ; Error
 rlc (ix-128), h                ; Error
 rlc (ix-128), l                ; Error
 rlc (iy), a                    ; Error
 rlc (iy), b                    ; Error
 rlc (iy), c                    ; Error
 rlc (iy), d                    ; Error
 rlc (iy), e                    ; Error
 rlc (iy), h                    ; Error
 rlc (iy), l                    ; Error
 rlc (iy+127), a                ; Error
 rlc (iy+127), b                ; Error
 rlc (iy+127), c                ; Error
 rlc (iy+127), d                ; Error
 rlc (iy+127), e                ; Error
 rlc (iy+127), h                ; Error
 rlc (iy+127), l                ; Error
 rlc (iy-128), a                ; Error
 rlc (iy-128), b                ; Error
 rlc (iy-128), c                ; Error
 rlc (iy-128), d                ; Error
 rlc (iy-128), e                ; Error
 rlc (iy-128), h                ; Error
 rlc (iy-128), l                ; Error
 rlc ixh                        ; Error
 rlc ixl                        ; Error
 rlc iyh                        ; Error
 rlc iyl                        ; Error
 rlde                           ; Error
 rr (ix), a                     ; Error
 rr (ix), b                     ; Error
 rr (ix), c                     ; Error
 rr (ix), d                     ; Error
 rr (ix), e                     ; Error
 rr (ix), h                     ; Error
 rr (ix), l                     ; Error
 rr (ix+127), a                 ; Error
 rr (ix+127), b                 ; Error
 rr (ix+127), c                 ; Error
 rr (ix+127), d                 ; Error
 rr (ix+127), e                 ; Error
 rr (ix+127), h                 ; Error
 rr (ix+127), l                 ; Error
 rr (ix-128), a                 ; Error
 rr (ix-128), b                 ; Error
 rr (ix-128), c                 ; Error
 rr (ix-128), d                 ; Error
 rr (ix-128), e                 ; Error
 rr (ix-128), h                 ; Error
 rr (ix-128), l                 ; Error
 rr (iy), a                     ; Error
 rr (iy), b                     ; Error
 rr (iy), c                     ; Error
 rr (iy), d                     ; Error
 rr (iy), e                     ; Error
 rr (iy), h                     ; Error
 rr (iy), l                     ; Error
 rr (iy+127), a                 ; Error
 rr (iy+127), b                 ; Error
 rr (iy+127), c                 ; Error
 rr (iy+127), d                 ; Error
 rr (iy+127), e                 ; Error
 rr (iy+127), h                 ; Error
 rr (iy+127), l                 ; Error
 rr (iy-128), a                 ; Error
 rr (iy-128), b                 ; Error
 rr (iy-128), c                 ; Error
 rr (iy-128), d                 ; Error
 rr (iy-128), e                 ; Error
 rr (iy-128), h                 ; Error
 rr (iy-128), l                 ; Error
 rr ixh                         ; Error
 rr ixl                         ; Error
 rr iyh                         ; Error
 rr iyl                         ; Error
 rrc (ix), a                    ; Error
 rrc (ix), b                    ; Error
 rrc (ix), c                    ; Error
 rrc (ix), d                    ; Error
 rrc (ix), e                    ; Error
 rrc (ix), h                    ; Error
 rrc (ix), l                    ; Error
 rrc (ix+127), a                ; Error
 rrc (ix+127), b                ; Error
 rrc (ix+127), c                ; Error
 rrc (ix+127), d                ; Error
 rrc (ix+127), e                ; Error
 rrc (ix+127), h                ; Error
 rrc (ix+127), l                ; Error
 rrc (ix-128), a                ; Error
 rrc (ix-128), b                ; Error
 rrc (ix-128), c                ; Error
 rrc (ix-128), d                ; Error
 rrc (ix-128), e                ; Error
 rrc (ix-128), h                ; Error
 rrc (ix-128), l                ; Error
 rrc (iy), a                    ; Error
 rrc (iy), b                    ; Error
 rrc (iy), c                    ; Error
 rrc (iy), d                    ; Error
 rrc (iy), e                    ; Error
 rrc (iy), h                    ; Error
 rrc (iy), l                    ; Error
 rrc (iy+127), a                ; Error
 rrc (iy+127), b                ; Error
 rrc (iy+127), c                ; Error
 rrc (iy+127), d                ; Error
 rrc (iy+127), e                ; Error
 rrc (iy+127), h                ; Error
 rrc (iy+127), l                ; Error
 rrc (iy-128), a                ; Error
 rrc (iy-128), b                ; Error
 rrc (iy-128), c                ; Error
 rrc (iy-128), d                ; Error
 rrc (iy-128), e                ; Error
 rrc (iy-128), h                ; Error
 rrc (iy-128), l                ; Error
 rrc ixh                        ; Error
 rrc ixl                        ; Error
 rrc iyh                        ; Error
 rrc iyl                        ; Error
 rrhl                           ; Error
 rst -1                         ; Error
 rst -1                         ; Error
 rst 10                         ; Error
 rst 10                         ; Error
 rst 11                         ; Error
 rst 11                         ; Error
 rst 12                         ; Error
 rst 12                         ; Error
 rst 13                         ; Error
 rst 13                         ; Error
 rst 14                         ; Error
 rst 14                         ; Error
 rst 15                         ; Error
 rst 15                         ; Error
 rst 17                         ; Error
 rst 17                         ; Error
 rst 18                         ; Error
 rst 18                         ; Error
 rst 19                         ; Error
 rst 19                         ; Error
 rst 20                         ; Error
 rst 20                         ; Error
 rst 21                         ; Error
 rst 21                         ; Error
 rst 22                         ; Error
 rst 22                         ; Error
 rst 23                         ; Error
 rst 23                         ; Error
 rst 25                         ; Error
 rst 25                         ; Error
 rst 26                         ; Error
 rst 26                         ; Error
 rst 27                         ; Error
 rst 27                         ; Error
 rst 28                         ; Error
 rst 28                         ; Error
 rst 29                         ; Error
 rst 29                         ; Error
 rst 30                         ; Error
 rst 30                         ; Error
 rst 31                         ; Error
 rst 31                         ; Error
 rst 33                         ; Error
 rst 33                         ; Error
 rst 34                         ; Error
 rst 34                         ; Error
 rst 35                         ; Error
 rst 35                         ; Error
 rst 36                         ; Error
 rst 36                         ; Error
 rst 37                         ; Error
 rst 37                         ; Error
 rst 38                         ; Error
 rst 38                         ; Error
 rst 39                         ; Error
 rst 39                         ; Error
 rst 41                         ; Error
 rst 41                         ; Error
 rst 42                         ; Error
 rst 42                         ; Error
 rst 43                         ; Error
 rst 43                         ; Error
 rst 44                         ; Error
 rst 44                         ; Error
 rst 45                         ; Error
 rst 45                         ; Error
 rst 46                         ; Error
 rst 46                         ; Error
 rst 47                         ; Error
 rst 47                         ; Error
 rst 49                         ; Error
 rst 49                         ; Error
 rst 50                         ; Error
 rst 50                         ; Error
 rst 51                         ; Error
 rst 51                         ; Error
 rst 52                         ; Error
 rst 52                         ; Error
 rst 53                         ; Error
 rst 53                         ; Error
 rst 54                         ; Error
 rst 54                         ; Error
 rst 55                         ; Error
 rst 55                         ; Error
 rst 57                         ; Error
 rst 57                         ; Error
 rst 58                         ; Error
 rst 58                         ; Error
 rst 59                         ; Error
 rst 59                         ; Error
 rst 60                         ; Error
 rst 60                         ; Error
 rst 61                         ; Error
 rst 61                         ; Error
 rst 62                         ; Error
 rst 62                         ; Error
 rst 63                         ; Error
 rst 63                         ; Error
 rst 64                         ; Error
 rst 64                         ; Error
 rst 9                          ; Error
 rst 9                          ; Error
 rstv                           ; Error
 sbb ixh                        ; Error
 sbb ixl                        ; Error
 sbb iyh                        ; Error
 sbb iyl                        ; Error
 sbc a, ixh                     ; Error
 sbc a, ixl                     ; Error
 sbc a, iyh                     ; Error
 sbc a, iyl                     ; Error
 sbc ixh                        ; Error
 sbc ixl                        ; Error
 sbc iyh                        ; Error
 sbc iyl                        ; Error
 set -1, (hl)                   ; Error
 set -1, (hl)                   ; Error
 set -1, (ix)                   ; Error
 set -1, (ix)                   ; Error
 set -1, (ix+127)               ; Error
 set -1, (ix+127)               ; Error
 set -1, (ix-128)               ; Error
 set -1, (ix-128)               ; Error
 set -1, (iy)                   ; Error
 set -1, (iy)                   ; Error
 set -1, (iy+127)               ; Error
 set -1, (iy+127)               ; Error
 set -1, (iy-128)               ; Error
 set -1, (iy-128)               ; Error
 set -1, a                      ; Error
 set -1, a                      ; Error
 set -1, a'                     ; Error
 set -1, a'                     ; Error
 set -1, b                      ; Error
 set -1, b                      ; Error
 set -1, b'                     ; Error
 set -1, b'                     ; Error
 set -1, c                      ; Error
 set -1, c                      ; Error
 set -1, c'                     ; Error
 set -1, c'                     ; Error
 set -1, d                      ; Error
 set -1, d                      ; Error
 set -1, d'                     ; Error
 set -1, d'                     ; Error
 set -1, e                      ; Error
 set -1, e                      ; Error
 set -1, e'                     ; Error
 set -1, e'                     ; Error
 set -1, h                      ; Error
 set -1, h                      ; Error
 set -1, h'                     ; Error
 set -1, h'                     ; Error
 set -1, ixh                    ; Error
 set -1, ixh                    ; Error
 set -1, ixl                    ; Error
 set -1, ixl                    ; Error
 set -1, iyh                    ; Error
 set -1, iyh                    ; Error
 set -1, iyl                    ; Error
 set -1, iyl                    ; Error
 set -1, l                      ; Error
 set -1, l                      ; Error
 set -1, l'                     ; Error
 set -1, l'                     ; Error
 set 0, ixh                     ; Error
 set 0, ixl                     ; Error
 set 0, iyh                     ; Error
 set 0, iyl                     ; Error
 set 1, ixh                     ; Error
 set 1, ixl                     ; Error
 set 1, iyh                     ; Error
 set 1, iyl                     ; Error
 set 2, ixh                     ; Error
 set 2, ixl                     ; Error
 set 2, iyh                     ; Error
 set 2, iyl                     ; Error
 set 3, ixh                     ; Error
 set 3, ixl                     ; Error
 set 3, iyh                     ; Error
 set 3, iyl                     ; Error
 set 4, ixh                     ; Error
 set 4, ixl                     ; Error
 set 4, iyh                     ; Error
 set 4, iyl                     ; Error
 set 5, ixh                     ; Error
 set 5, ixl                     ; Error
 set 5, iyh                     ; Error
 set 5, iyl                     ; Error
 set 6, ixh                     ; Error
 set 6, ixl                     ; Error
 set 6, iyh                     ; Error
 set 6, iyl                     ; Error
 set 7, ixh                     ; Error
 set 7, ixl                     ; Error
 set 7, iyh                     ; Error
 set 7, iyl                     ; Error
 set 8, (hl)                    ; Error
 set 8, (hl)                    ; Error
 set 8, (ix)                    ; Error
 set 8, (ix)                    ; Error
 set 8, (ix+127)                ; Error
 set 8, (ix+127)                ; Error
 set 8, (ix-128)                ; Error
 set 8, (ix-128)                ; Error
 set 8, (iy)                    ; Error
 set 8, (iy)                    ; Error
 set 8, (iy+127)                ; Error
 set 8, (iy+127)                ; Error
 set 8, (iy-128)                ; Error
 set 8, (iy-128)                ; Error
 set 8, a                       ; Error
 set 8, a                       ; Error
 set 8, a'                      ; Error
 set 8, a'                      ; Error
 set 8, b                       ; Error
 set 8, b                       ; Error
 set 8, b'                      ; Error
 set 8, b'                      ; Error
 set 8, c                       ; Error
 set 8, c                       ; Error
 set 8, c'                      ; Error
 set 8, c'                      ; Error
 set 8, d                       ; Error
 set 8, d                       ; Error
 set 8, d'                      ; Error
 set 8, d'                      ; Error
 set 8, e                       ; Error
 set 8, e                       ; Error
 set 8, e'                      ; Error
 set 8, e'                      ; Error
 set 8, h                       ; Error
 set 8, h                       ; Error
 set 8, h'                      ; Error
 set 8, h'                      ; Error
 set 8, ixh                     ; Error
 set 8, ixh                     ; Error
 set 8, ixl                     ; Error
 set 8, ixl                     ; Error
 set 8, iyh                     ; Error
 set 8, iyh                     ; Error
 set 8, iyl                     ; Error
 set 8, iyl                     ; Error
 set 8, l                       ; Error
 set 8, l                       ; Error
 set 8, l'                      ; Error
 set 8, l'                      ; Error
 set.a -1, (hl)                 ; Error
 set.a -1, (hl)                 ; Error
 set.a -1, (ix)                 ; Error
 set.a -1, (ix)                 ; Error
 set.a -1, (ix+127)             ; Error
 set.a -1, (ix+127)             ; Error
 set.a -1, (ix-128)             ; Error
 set.a -1, (ix-128)             ; Error
 set.a -1, (iy)                 ; Error
 set.a -1, (iy)                 ; Error
 set.a -1, (iy+127)             ; Error
 set.a -1, (iy+127)             ; Error
 set.a -1, (iy-128)             ; Error
 set.a -1, (iy-128)             ; Error
 set.a -1, a                    ; Error
 set.a -1, a                    ; Error
 set.a -1, b                    ; Error
 set.a -1, b                    ; Error
 set.a -1, c                    ; Error
 set.a -1, c                    ; Error
 set.a -1, d                    ; Error
 set.a -1, d                    ; Error
 set.a -1, e                    ; Error
 set.a -1, e                    ; Error
 set.a -1, h                    ; Error
 set.a -1, h                    ; Error
 set.a -1, ixh                  ; Error
 set.a -1, ixh                  ; Error
 set.a -1, ixl                  ; Error
 set.a -1, ixl                  ; Error
 set.a -1, iyh                  ; Error
 set.a -1, iyh                  ; Error
 set.a -1, iyl                  ; Error
 set.a -1, iyl                  ; Error
 set.a -1, l                    ; Error
 set.a -1, l                    ; Error
 set.a 0, ixh                   ; Error
 set.a 0, ixl                   ; Error
 set.a 0, iyh                   ; Error
 set.a 0, iyl                   ; Error
 set.a 1, ixh                   ; Error
 set.a 1, ixl                   ; Error
 set.a 1, iyh                   ; Error
 set.a 1, iyl                   ; Error
 set.a 2, ixh                   ; Error
 set.a 2, ixl                   ; Error
 set.a 2, iyh                   ; Error
 set.a 2, iyl                   ; Error
 set.a 3, ixh                   ; Error
 set.a 3, ixl                   ; Error
 set.a 3, iyh                   ; Error
 set.a 3, iyl                   ; Error
 set.a 4, ixh                   ; Error
 set.a 4, ixl                   ; Error
 set.a 4, iyh                   ; Error
 set.a 4, iyl                   ; Error
 set.a 5, ixh                   ; Error
 set.a 5, ixl                   ; Error
 set.a 5, iyh                   ; Error
 set.a 5, iyl                   ; Error
 set.a 6, ixh                   ; Error
 set.a 6, ixl                   ; Error
 set.a 6, iyh                   ; Error
 set.a 6, iyl                   ; Error
 set.a 7, ixh                   ; Error
 set.a 7, ixl                   ; Error
 set.a 7, iyh                   ; Error
 set.a 7, iyl                   ; Error
 set.a 8, (hl)                  ; Error
 set.a 8, (hl)                  ; Error
 set.a 8, (ix)                  ; Error
 set.a 8, (ix)                  ; Error
 set.a 8, (ix+127)              ; Error
 set.a 8, (ix+127)              ; Error
 set.a 8, (ix-128)              ; Error
 set.a 8, (ix-128)              ; Error
 set.a 8, (iy)                  ; Error
 set.a 8, (iy)                  ; Error
 set.a 8, (iy+127)              ; Error
 set.a 8, (iy+127)              ; Error
 set.a 8, (iy-128)              ; Error
 set.a 8, (iy-128)              ; Error
 set.a 8, a                     ; Error
 set.a 8, a                     ; Error
 set.a 8, b                     ; Error
 set.a 8, b                     ; Error
 set.a 8, c                     ; Error
 set.a 8, c                     ; Error
 set.a 8, d                     ; Error
 set.a 8, d                     ; Error
 set.a 8, e                     ; Error
 set.a 8, e                     ; Error
 set.a 8, h                     ; Error
 set.a 8, h                     ; Error
 set.a 8, ixh                   ; Error
 set.a 8, ixh                   ; Error
 set.a 8, ixl                   ; Error
 set.a 8, ixl                   ; Error
 set.a 8, iyh                   ; Error
 set.a 8, iyh                   ; Error
 set.a 8, iyl                   ; Error
 set.a 8, iyl                   ; Error
 set.a 8, l                     ; Error
 set.a 8, l                     ; Error
 setae                          ; Error
 shlde                          ; Error
 shlx                           ; Error
 sim                            ; Error
 sla (ix), a                    ; Error
 sla (ix), b                    ; Error
 sla (ix), c                    ; Error
 sla (ix), d                    ; Error
 sla (ix), e                    ; Error
 sla (ix), h                    ; Error
 sla (ix), l                    ; Error
 sla (ix+127), a                ; Error
 sla (ix+127), b                ; Error
 sla (ix+127), c                ; Error
 sla (ix+127), d                ; Error
 sla (ix+127), e                ; Error
 sla (ix+127), h                ; Error
 sla (ix+127), l                ; Error
 sla (ix-128), a                ; Error
 sla (ix-128), b                ; Error
 sla (ix-128), c                ; Error
 sla (ix-128), d                ; Error
 sla (ix-128), e                ; Error
 sla (ix-128), h                ; Error
 sla (ix-128), l                ; Error
 sla (iy), a                    ; Error
 sla (iy), b                    ; Error
 sla (iy), c                    ; Error
 sla (iy), d                    ; Error
 sla (iy), e                    ; Error
 sla (iy), h                    ; Error
 sla (iy), l                    ; Error
 sla (iy+127), a                ; Error
 sla (iy+127), b                ; Error
 sla (iy+127), c                ; Error
 sla (iy+127), d                ; Error
 sla (iy+127), e                ; Error
 sla (iy+127), h                ; Error
 sla (iy+127), l                ; Error
 sla (iy-128), a                ; Error
 sla (iy-128), b                ; Error
 sla (iy-128), c                ; Error
 sla (iy-128), d                ; Error
 sla (iy-128), e                ; Error
 sla (iy-128), h                ; Error
 sla (iy-128), l                ; Error
 sla ixh                        ; Error
 sla ixl                        ; Error
 sla iyh                        ; Error
 sla iyl                        ; Error
 sli (hl)                       ; Error
 sli (ix)                       ; Error
 sli (ix), a                    ; Error
 sli (ix), b                    ; Error
 sli (ix), c                    ; Error
 sli (ix), d                    ; Error
 sli (ix), e                    ; Error
 sli (ix), h                    ; Error
 sli (ix), l                    ; Error
 sli (ix+127)                   ; Error
 sli (ix+127), a                ; Error
 sli (ix+127), b                ; Error
 sli (ix+127), c                ; Error
 sli (ix+127), d                ; Error
 sli (ix+127), e                ; Error
 sli (ix+127), h                ; Error
 sli (ix+127), l                ; Error
 sli (ix-128)                   ; Error
 sli (ix-128), a                ; Error
 sli (ix-128), b                ; Error
 sli (ix-128), c                ; Error
 sli (ix-128), d                ; Error
 sli (ix-128), e                ; Error
 sli (ix-128), h                ; Error
 sli (ix-128), l                ; Error
 sli (iy)                       ; Error
 sli (iy), a                    ; Error
 sli (iy), b                    ; Error
 sli (iy), c                    ; Error
 sli (iy), d                    ; Error
 sli (iy), e                    ; Error
 sli (iy), h                    ; Error
 sli (iy), l                    ; Error
 sli (iy+127)                   ; Error
 sli (iy+127), a                ; Error
 sli (iy+127), b                ; Error
 sli (iy+127), c                ; Error
 sli (iy+127), d                ; Error
 sli (iy+127), e                ; Error
 sli (iy+127), h                ; Error
 sli (iy+127), l                ; Error
 sli (iy-128)                   ; Error
 sli (iy-128), a                ; Error
 sli (iy-128), b                ; Error
 sli (iy-128), c                ; Error
 sli (iy-128), d                ; Error
 sli (iy-128), e                ; Error
 sli (iy-128), h                ; Error
 sli (iy-128), l                ; Error
 sli a                          ; Error
 sli b                          ; Error
 sli c                          ; Error
 sli d                          ; Error
 sli e                          ; Error
 sli h                          ; Error
 sli ixh                        ; Error
 sli ixl                        ; Error
 sli iyh                        ; Error
 sli iyl                        ; Error
 sli l                          ; Error
 sll (hl)                       ; Error
 sll (ix)                       ; Error
 sll (ix), a                    ; Error
 sll (ix), b                    ; Error
 sll (ix), c                    ; Error
 sll (ix), d                    ; Error
 sll (ix), e                    ; Error
 sll (ix), h                    ; Error
 sll (ix), l                    ; Error
 sll (ix+127)                   ; Error
 sll (ix+127), a                ; Error
 sll (ix+127), b                ; Error
 sll (ix+127), c                ; Error
 sll (ix+127), d                ; Error
 sll (ix+127), e                ; Error
 sll (ix+127), h                ; Error
 sll (ix+127), l                ; Error
 sll (ix-128)                   ; Error
 sll (ix-128), a                ; Error
 sll (ix-128), b                ; Error
 sll (ix-128), c                ; Error
 sll (ix-128), d                ; Error
 sll (ix-128), e                ; Error
 sll (ix-128), h                ; Error
 sll (ix-128), l                ; Error
 sll (iy)                       ; Error
 sll (iy), a                    ; Error
 sll (iy), b                    ; Error
 sll (iy), c                    ; Error
 sll (iy), d                    ; Error
 sll (iy), e                    ; Error
 sll (iy), h                    ; Error
 sll (iy), l                    ; Error
 sll (iy+127)                   ; Error
 sll (iy+127), a                ; Error
 sll (iy+127), b                ; Error
 sll (iy+127), c                ; Error
 sll (iy+127), d                ; Error
 sll (iy+127), e                ; Error
 sll (iy+127), h                ; Error
 sll (iy+127), l                ; Error
 sll (iy-128)                   ; Error
 sll (iy-128), a                ; Error
 sll (iy-128), b                ; Error
 sll (iy-128), c                ; Error
 sll (iy-128), d                ; Error
 sll (iy-128), e                ; Error
 sll (iy-128), h                ; Error
 sll (iy-128), l                ; Error
 sll a                          ; Error
 sll b                          ; Error
 sll c                          ; Error
 sll d                          ; Error
 sll e                          ; Error
 sll h                          ; Error
 sll ixh                        ; Error
 sll ixl                        ; Error
 sll iyh                        ; Error
 sll iyl                        ; Error
 sll l                          ; Error
 slp                            ; Error
 sra (ix), a                    ; Error
 sra (ix), b                    ; Error
 sra (ix), c                    ; Error
 sra (ix), d                    ; Error
 sra (ix), e                    ; Error
 sra (ix), h                    ; Error
 sra (ix), l                    ; Error
 sra (ix+127), a                ; Error
 sra (ix+127), b                ; Error
 sra (ix+127), c                ; Error
 sra (ix+127), d                ; Error
 sra (ix+127), e                ; Error
 sra (ix+127), h                ; Error
 sra (ix+127), l                ; Error
 sra (ix-128), a                ; Error
 sra (ix-128), b                ; Error
 sra (ix-128), c                ; Error
 sra (ix-128), d                ; Error
 sra (ix-128), e                ; Error
 sra (ix-128), h                ; Error
 sra (ix-128), l                ; Error
 sra (iy), a                    ; Error
 sra (iy), b                    ; Error
 sra (iy), c                    ; Error
 sra (iy), d                    ; Error
 sra (iy), e                    ; Error
 sra (iy), h                    ; Error
 sra (iy), l                    ; Error
 sra (iy+127), a                ; Error
 sra (iy+127), b                ; Error
 sra (iy+127), c                ; Error
 sra (iy+127), d                ; Error
 sra (iy+127), e                ; Error
 sra (iy+127), h                ; Error
 sra (iy+127), l                ; Error
 sra (iy-128), a                ; Error
 sra (iy-128), b                ; Error
 sra (iy-128), c                ; Error
 sra (iy-128), d                ; Error
 sra (iy-128), e                ; Error
 sra (iy-128), h                ; Error
 sra (iy-128), l                ; Error
 sra hl                         ; Error
 sra ixh                        ; Error
 sra ixl                        ; Error
 sra iyh                        ; Error
 sra iyl                        ; Error
 srl (ix), a                    ; Error
 srl (ix), b                    ; Error
 srl (ix), c                    ; Error
 srl (ix), d                    ; Error
 srl (ix), e                    ; Error
 srl (ix), h                    ; Error
 srl (ix), l                    ; Error
 srl (ix+127), a                ; Error
 srl (ix+127), b                ; Error
 srl (ix+127), c                ; Error
 srl (ix+127), d                ; Error
 srl (ix+127), e                ; Error
 srl (ix+127), h                ; Error
 srl (ix+127), l                ; Error
 srl (ix-128), a                ; Error
 srl (ix-128), b                ; Error
 srl (ix-128), c                ; Error
 srl (ix-128), d                ; Error
 srl (ix-128), e                ; Error
 srl (ix-128), h                ; Error
 srl (ix-128), l                ; Error
 srl (iy), a                    ; Error
 srl (iy), b                    ; Error
 srl (iy), c                    ; Error
 srl (iy), d                    ; Error
 srl (iy), e                    ; Error
 srl (iy), h                    ; Error
 srl (iy), l                    ; Error
 srl (iy+127), a                ; Error
 srl (iy+127), b                ; Error
 srl (iy+127), c                ; Error
 srl (iy+127), d                ; Error
 srl (iy+127), e                ; Error
 srl (iy+127), h                ; Error
 srl (iy+127), l                ; Error
 srl (iy-128), a                ; Error
 srl (iy-128), b                ; Error
 srl (iy-128), c                ; Error
 srl (iy-128), d                ; Error
 srl (iy-128), e                ; Error
 srl (iy-128), h                ; Error
 srl (iy-128), l                ; Error
 srl ixh                        ; Error
 srl ixl                        ; Error
 srl iyh                        ; Error
 srl iyl                        ; Error
 stop                           ; Error
 sub a, ixh                     ; Error
 sub a, ixl                     ; Error
 sub a, iyh                     ; Error
 sub a, iyl                     ; Error
 sub hl, bc                     ; Error
 sub ixh                        ; Error
 sub ixl                        ; Error
 sub iyh                        ; Error
 sub iyl                        ; Error
 swap (hl)                      ; Error
 swap a                         ; Error
 swap b                         ; Error
 swap c                         ; Error
 swap d                         ; Error
 swap e                         ; Error
 swap h                         ; Error
 swap l                         ; Error
 swapnib                        ; Error
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
 tstio -128                     ; Error
 tstio 127                      ; Error
 tstio 255                      ; Error
 xor a, ixh                     ; Error
 xor a, ixl                     ; Error
 xor a, iyh                     ; Error
 xor a, iyl                     ; Error
 xor ixh                        ; Error
 xor ixl                        ; Error
 xor iyh                        ; Error
 xor iyl                        ; Error
 xra ixh                        ; Error
 xra ixl                        ; Error
 xra iyh                        ; Error
 xra iyl                        ; Error
 xthl                           ; Error
