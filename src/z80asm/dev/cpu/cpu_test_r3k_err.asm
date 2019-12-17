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
 bit -1, l                      ; Error
 bit -1, l                      ; Error
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
 bit.a -1, l                    ; Error
 bit.a -1, l                    ; Error
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
 dec ixh                        ; Error
 dec ixl                        ; Error
 dec iyh                        ; Error
 dec iyl                        ; Error
 di                             ; Error
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
 ld bc, ix                      ; Error
 ld bc, iy                      ; Error
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
 ld de, ix                      ; Error
 ld de, iy                      ; Error
