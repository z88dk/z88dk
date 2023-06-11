 adc a, ixh                     ; Error
 adc a, ixl                     ; Error
 adc a, iyh                     ; Error
 adc a, iyl                     ; Error
 adc ixh                        ; Error
 adc ixl                        ; Error
 adc iyh                        ; Error
 adc iyl                        ; Error
 adc.l (hl)                     ; Error
 adc.l (hl+)                    ; Error
 adc.l (hl-)                    ; Error
 adc.l (ix)                     ; Error
 adc.l (ix+127)                 ; Error
 adc.l (ix-128)                 ; Error
 adc.l (iy)                     ; Error
 adc.l (iy+127)                 ; Error
 adc.l (iy-128)                 ; Error
 adc.l a, (hl)                  ; Error
 adc.l a, (hl+)                 ; Error
 adc.l a, (hl-)                 ; Error
 adc.l a, (ix)                  ; Error
 adc.l a, (ix+127)              ; Error
 adc.l a, (ix-128)              ; Error
 adc.l a, (iy)                  ; Error
 adc.l a, (iy+127)              ; Error
 adc.l a, (iy-128)              ; Error
 adc.l hl, bc                   ; Error
 adc.l hl, de                   ; Error
 adc.l hl, hl                   ; Error
 adc.l hl, sp                   ; Error
 adc.s (hl)                     ; Error
 adc.s (hl+)                    ; Error
 adc.s (hl-)                    ; Error
 adc.s (ix)                     ; Error
 adc.s (ix+127)                 ; Error
 adc.s (ix-128)                 ; Error
 adc.s (iy)                     ; Error
 adc.s (iy+127)                 ; Error
 adc.s (iy-128)                 ; Error
 adc.s a, (hl)                  ; Error
 adc.s a, (hl+)                 ; Error
 adc.s a, (hl-)                 ; Error
 adc.s a, (ix)                  ; Error
 adc.s a, (ix+127)              ; Error
 adc.s a, (ix-128)              ; Error
 adc.s a, (iy)                  ; Error
 adc.s a, (iy+127)              ; Error
 adc.s a, (iy-128)              ; Error
 adc.s hl, bc                   ; Error
 adc.s hl, de                   ; Error
 adc.s hl, hl                   ; Error
 adc.s hl, sp                   ; Error
 add a, ixh                     ; Error
 add a, ixl                     ; Error
 add a, iyh                     ; Error
 add a, iyl                     ; Error
 add ixh                        ; Error
 add ixl                        ; Error
 add iyh                        ; Error
 add iyl                        ; Error
 add.l (hl)                     ; Error
 add.l (hl+)                    ; Error
 add.l (hl-)                    ; Error
 add.l (ix)                     ; Error
 add.l (ix+127)                 ; Error
 add.l (ix-128)                 ; Error
 add.l (iy)                     ; Error
 add.l (iy+127)                 ; Error
 add.l (iy-128)                 ; Error
 add.l a, (hl)                  ; Error
 add.l a, (hl+)                 ; Error
 add.l a, (hl-)                 ; Error
 add.l a, (ix)                  ; Error
 add.l a, (ix+127)              ; Error
 add.l a, (ix-128)              ; Error
 add.l a, (iy)                  ; Error
 add.l a, (iy+127)              ; Error
 add.l a, (iy-128)              ; Error
 add.l hl, bc                   ; Error
 add.l hl, de                   ; Error
 add.l hl, hl                   ; Error
 add.l hl, sp                   ; Error
 add.l ix, bc                   ; Error
 add.l ix, de                   ; Error
 add.l ix, ix                   ; Error
 add.l ix, sp                   ; Error
 add.l iy, bc                   ; Error
 add.l iy, de                   ; Error
 add.l iy, iy                   ; Error
 add.l iy, sp                   ; Error
 add.s (hl)                     ; Error
 add.s (hl+)                    ; Error
 add.s (hl-)                    ; Error
 add.s (ix)                     ; Error
 add.s (ix+127)                 ; Error
 add.s (ix-128)                 ; Error
 add.s (iy)                     ; Error
 add.s (iy+127)                 ; Error
 add.s (iy-128)                 ; Error
 add.s a, (hl)                  ; Error
 add.s a, (hl+)                 ; Error
 add.s a, (hl-)                 ; Error
 add.s a, (ix)                  ; Error
 add.s a, (ix+127)              ; Error
 add.s a, (ix-128)              ; Error
 add.s a, (iy)                  ; Error
 add.s a, (iy+127)              ; Error
 add.s a, (iy-128)              ; Error
 add.s hl, bc                   ; Error
 add.s hl, de                   ; Error
 add.s hl, hl                   ; Error
 add.s hl, sp                   ; Error
 add.s ix, bc                   ; Error
 add.s ix, de                   ; Error
 add.s ix, ix                   ; Error
 add.s ix, sp                   ; Error
 add.s iy, bc                   ; Error
 add.s iy, de                   ; Error
 add.s iy, iy                   ; Error
 add.s iy, sp                   ; Error
 adi hl, -128                   ; Error
 adi hl, 127                    ; Error
 adi hl, 255                    ; Error
 adi sp, -128                   ; Error
 adi sp, 127                    ; Error
 adi sp, 255                    ; Error
 altd bit -1, (hl)              ; Error
 altd bit -1, (ix)              ; Error
 altd bit -1, (ix+127)          ; Error
 altd bit -1, (ix-128)          ; Error
 altd bit -1, (iy)              ; Error
 altd bit -1, (iy+127)          ; Error
 altd bit -1, (iy-128)          ; Error
 altd bit -1, a                 ; Error
 altd bit -1, b                 ; Error
 altd bit -1, c                 ; Error
 altd bit -1, d                 ; Error
 altd bit -1, e                 ; Error
 altd bit -1, h                 ; Error
 altd bit -1, l                 ; Error
 altd bit 8, (hl)               ; Error
 altd bit 8, (ix)               ; Error
 altd bit 8, (ix+127)           ; Error
 altd bit 8, (ix-128)           ; Error
 altd bit 8, (iy)               ; Error
 altd bit 8, (iy+127)           ; Error
 altd bit 8, (iy-128)           ; Error
 altd bit 8, a                  ; Error
 altd bit 8, b                  ; Error
 altd bit 8, c                  ; Error
 altd bit 8, d                  ; Error
 altd bit 8, e                  ; Error
 altd bit 8, h                  ; Error
 altd bit 8, l                  ; Error
 altd ioe bit -1, (hl)          ; Error
 altd ioe bit -1, (ix)          ; Error
 altd ioe bit -1, (ix+127)      ; Error
 altd ioe bit -1, (ix-128)      ; Error
 altd ioe bit -1, (iy)          ; Error
 altd ioe bit -1, (iy+127)      ; Error
 altd ioe bit -1, (iy-128)      ; Error
 altd ioe bit 8, (hl)           ; Error
 altd ioe bit 8, (ix)           ; Error
 altd ioe bit 8, (ix+127)       ; Error
 altd ioe bit 8, (ix-128)       ; Error
 altd ioe bit 8, (iy)           ; Error
 altd ioe bit 8, (iy+127)       ; Error
 altd ioe bit 8, (iy-128)       ; Error
 altd ioi bit -1, (hl)          ; Error
 altd ioi bit -1, (ix)          ; Error
 altd ioi bit -1, (ix+127)      ; Error
 altd ioi bit -1, (ix-128)      ; Error
 altd ioi bit -1, (iy)          ; Error
 altd ioi bit -1, (iy+127)      ; Error
 altd ioi bit -1, (iy-128)      ; Error
 altd ioi bit 8, (hl)           ; Error
 altd ioi bit 8, (ix)           ; Error
 altd ioi bit 8, (ix+127)       ; Error
 altd ioi bit 8, (ix-128)       ; Error
 altd ioi bit 8, (iy)           ; Error
 altd ioi bit 8, (iy+127)       ; Error
 altd ioi bit 8, (iy-128)       ; Error
 altd res -1, a                 ; Error
 altd res -1, b                 ; Error
 altd res -1, c                 ; Error
 altd res -1, d                 ; Error
 altd res -1, e                 ; Error
 altd res -1, h                 ; Error
 altd res -1, l                 ; Error
 altd res 8, a                  ; Error
 altd res 8, b                  ; Error
 altd res 8, c                  ; Error
 altd res 8, d                  ; Error
 altd res 8, e                  ; Error
 altd res 8, h                  ; Error
 altd res 8, l                  ; Error
 altd set -1, a                 ; Error
 altd set -1, b                 ; Error
 altd set -1, c                 ; Error
 altd set -1, d                 ; Error
 altd set -1, e                 ; Error
 altd set -1, h                 ; Error
 altd set -1, l                 ; Error
 altd set 8, a                  ; Error
 altd set 8, b                  ; Error
 altd set 8, c                  ; Error
 altd set 8, d                  ; Error
 altd set 8, e                  ; Error
 altd set 8, h                  ; Error
 altd set 8, l                  ; Error
 and a, ixh                     ; Error
 and a, ixl                     ; Error
 and a, iyh                     ; Error
 and a, iyl                     ; Error
 and ixh                        ; Error
 and ixl                        ; Error
 and iyh                        ; Error
 and iyl                        ; Error
 and.l (hl)                     ; Error
 and.l (hl+)                    ; Error
 and.l (hl-)                    ; Error
 and.l (ix)                     ; Error
 and.l (ix+127)                 ; Error
 and.l (ix-128)                 ; Error
 and.l (iy)                     ; Error
 and.l (iy+127)                 ; Error
 and.l (iy-128)                 ; Error
 and.l a, (hl)                  ; Error
 and.l a, (hl+)                 ; Error
 and.l a, (hl-)                 ; Error
 and.l a, (ix)                  ; Error
 and.l a, (ix+127)              ; Error
 and.l a, (ix-128)              ; Error
 and.l a, (iy)                  ; Error
 and.l a, (iy+127)              ; Error
 and.l a, (iy-128)              ; Error
 and.s (hl)                     ; Error
 and.s (hl+)                    ; Error
 and.s (hl-)                    ; Error
 and.s (ix)                     ; Error
 and.s (ix+127)                 ; Error
 and.s (ix-128)                 ; Error
 and.s (iy)                     ; Error
 and.s (iy+127)                 ; Error
 and.s (iy-128)                 ; Error
 and.s a, (hl)                  ; Error
 and.s a, (hl+)                 ; Error
 and.s a, (hl-)                 ; Error
 and.s a, (ix)                  ; Error
 and.s a, (ix+127)              ; Error
 and.s a, (ix-128)              ; Error
 and.s a, (iy)                  ; Error
 and.s a, (iy+127)              ; Error
 and.s a, (iy-128)              ; Error
 bit -1, (hl)                   ; Error
 bit -1, (ix)                   ; Error
 bit -1, (ix+127)               ; Error
 bit -1, (ix-128)               ; Error
 bit -1, (iy)                   ; Error
 bit -1, (iy+127)               ; Error
 bit -1, (iy-128)               ; Error
 bit -1, a                      ; Error
 bit -1, b                      ; Error
 bit -1, c                      ; Error
 bit -1, d                      ; Error
 bit -1, e                      ; Error
 bit -1, h                      ; Error
 bit -1, l                      ; Error
 bit 8, (hl)                    ; Error
 bit 8, (ix)                    ; Error
 bit 8, (ix+127)                ; Error
 bit 8, (ix-128)                ; Error
 bit 8, (iy)                    ; Error
 bit 8, (iy+127)                ; Error
 bit 8, (iy-128)                ; Error
 bit 8, a                       ; Error
 bit 8, b                       ; Error
 bit 8, c                       ; Error
 bit 8, d                       ; Error
 bit 8, e                       ; Error
 bit 8, h                       ; Error
 bit 8, l                       ; Error
 bit.l -1, (hl)                 ; Error
 bit.l -1, (ix)                 ; Error
 bit.l -1, (ix+127)             ; Error
 bit.l -1, (ix-128)             ; Error
 bit.l -1, (iy)                 ; Error
 bit.l -1, (iy+127)             ; Error
 bit.l -1, (iy-128)             ; Error
 bit.l 0, (hl)                  ; Error
 bit.l 0, (ix)                  ; Error
 bit.l 0, (ix+127)              ; Error
 bit.l 0, (ix-128)              ; Error
 bit.l 0, (iy)                  ; Error
 bit.l 0, (iy+127)              ; Error
 bit.l 0, (iy-128)              ; Error
 bit.l 1, (hl)                  ; Error
 bit.l 1, (ix)                  ; Error
 bit.l 1, (ix+127)              ; Error
 bit.l 1, (ix-128)              ; Error
 bit.l 1, (iy)                  ; Error
 bit.l 1, (iy+127)              ; Error
 bit.l 1, (iy-128)              ; Error
 bit.l 2, (hl)                  ; Error
 bit.l 2, (ix)                  ; Error
 bit.l 2, (ix+127)              ; Error
 bit.l 2, (ix-128)              ; Error
 bit.l 2, (iy)                  ; Error
 bit.l 2, (iy+127)              ; Error
 bit.l 2, (iy-128)              ; Error
 bit.l 3, (hl)                  ; Error
 bit.l 3, (ix)                  ; Error
 bit.l 3, (ix+127)              ; Error
 bit.l 3, (ix-128)              ; Error
 bit.l 3, (iy)                  ; Error
 bit.l 3, (iy+127)              ; Error
 bit.l 3, (iy-128)              ; Error
 bit.l 4, (hl)                  ; Error
 bit.l 4, (ix)                  ; Error
 bit.l 4, (ix+127)              ; Error
 bit.l 4, (ix-128)              ; Error
 bit.l 4, (iy)                  ; Error
 bit.l 4, (iy+127)              ; Error
 bit.l 4, (iy-128)              ; Error
 bit.l 5, (hl)                  ; Error
 bit.l 5, (ix)                  ; Error
 bit.l 5, (ix+127)              ; Error
 bit.l 5, (ix-128)              ; Error
 bit.l 5, (iy)                  ; Error
 bit.l 5, (iy+127)              ; Error
 bit.l 5, (iy-128)              ; Error
 bit.l 6, (hl)                  ; Error
 bit.l 6, (ix)                  ; Error
 bit.l 6, (ix+127)              ; Error
 bit.l 6, (ix-128)              ; Error
 bit.l 6, (iy)                  ; Error
 bit.l 6, (iy+127)              ; Error
 bit.l 6, (iy-128)              ; Error
 bit.l 7, (hl)                  ; Error
 bit.l 7, (ix)                  ; Error
 bit.l 7, (ix+127)              ; Error
 bit.l 7, (ix-128)              ; Error
 bit.l 7, (iy)                  ; Error
 bit.l 7, (iy+127)              ; Error
 bit.l 7, (iy-128)              ; Error
 bit.l 8, (hl)                  ; Error
 bit.l 8, (ix)                  ; Error
 bit.l 8, (ix+127)              ; Error
 bit.l 8, (ix-128)              ; Error
 bit.l 8, (iy)                  ; Error
 bit.l 8, (iy+127)              ; Error
 bit.l 8, (iy-128)              ; Error
 bit.s -1, (hl)                 ; Error
 bit.s -1, (ix)                 ; Error
 bit.s -1, (ix+127)             ; Error
 bit.s -1, (ix-128)             ; Error
 bit.s -1, (iy)                 ; Error
 bit.s -1, (iy+127)             ; Error
 bit.s -1, (iy-128)             ; Error
 bit.s 0, (hl)                  ; Error
 bit.s 0, (ix)                  ; Error
 bit.s 0, (ix+127)              ; Error
 bit.s 0, (ix-128)              ; Error
 bit.s 0, (iy)                  ; Error
 bit.s 0, (iy+127)              ; Error
 bit.s 0, (iy-128)              ; Error
 bit.s 1, (hl)                  ; Error
 bit.s 1, (ix)                  ; Error
 bit.s 1, (ix+127)              ; Error
 bit.s 1, (ix-128)              ; Error
 bit.s 1, (iy)                  ; Error
 bit.s 1, (iy+127)              ; Error
 bit.s 1, (iy-128)              ; Error
 bit.s 2, (hl)                  ; Error
 bit.s 2, (ix)                  ; Error
 bit.s 2, (ix+127)              ; Error
 bit.s 2, (ix-128)              ; Error
 bit.s 2, (iy)                  ; Error
 bit.s 2, (iy+127)              ; Error
 bit.s 2, (iy-128)              ; Error
 bit.s 3, (hl)                  ; Error
 bit.s 3, (ix)                  ; Error
 bit.s 3, (ix+127)              ; Error
 bit.s 3, (ix-128)              ; Error
 bit.s 3, (iy)                  ; Error
 bit.s 3, (iy+127)              ; Error
 bit.s 3, (iy-128)              ; Error
 bit.s 4, (hl)                  ; Error
 bit.s 4, (ix)                  ; Error
 bit.s 4, (ix+127)              ; Error
 bit.s 4, (ix-128)              ; Error
 bit.s 4, (iy)                  ; Error
 bit.s 4, (iy+127)              ; Error
 bit.s 4, (iy-128)              ; Error
 bit.s 5, (hl)                  ; Error
 bit.s 5, (ix)                  ; Error
 bit.s 5, (ix+127)              ; Error
 bit.s 5, (ix-128)              ; Error
 bit.s 5, (iy)                  ; Error
 bit.s 5, (iy+127)              ; Error
 bit.s 5, (iy-128)              ; Error
 bit.s 6, (hl)                  ; Error
 bit.s 6, (ix)                  ; Error
 bit.s 6, (ix+127)              ; Error
 bit.s 6, (ix-128)              ; Error
 bit.s 6, (iy)                  ; Error
 bit.s 6, (iy+127)              ; Error
 bit.s 6, (iy-128)              ; Error
 bit.s 7, (hl)                  ; Error
 bit.s 7, (ix)                  ; Error
 bit.s 7, (ix+127)              ; Error
 bit.s 7, (ix-128)              ; Error
 bit.s 7, (iy)                  ; Error
 bit.s 7, (iy+127)              ; Error
 bit.s 7, (iy-128)              ; Error
 bit.s 8, (hl)                  ; Error
 bit.s 8, (ix)                  ; Error
 bit.s 8, (ix+127)              ; Error
 bit.s 8, (ix-128)              ; Error
 bit.s 8, (iy)                  ; Error
 bit.s 8, (iy+127)              ; Error
 bit.s 8, (iy-128)              ; Error
 brlc de, b                     ; Error
 bsla de, b                     ; Error
 bsra de, b                     ; Error
 bsrf de, b                     ; Error
 bsrl de, b                     ; Error
 call.il 0x123456               ; Error
 call.il c, 0x123456            ; Error
 call.il m, 0x123456            ; Error
 call.il nc, 0x123456           ; Error
 call.il nv, 0x123456           ; Error
 call.il nz, 0x123456           ; Error
 call.il p, 0x123456            ; Error
 call.il pe, 0x123456           ; Error
 call.il po, 0x123456           ; Error
 call.il v, 0x123456            ; Error
 call.il z, 0x123456            ; Error
 call.is -32768                 ; Error
 call.is 32767                  ; Error
 call.is 65535                  ; Error
 call.is c, -32768              ; Error
 call.is c, 32767               ; Error
 call.is c, 65535               ; Error
 call.is m, -32768              ; Error
 call.is m, 32767               ; Error
 call.is m, 65535               ; Error
 call.is nc, -32768             ; Error
 call.is nc, 32767              ; Error
 call.is nc, 65535              ; Error
 call.is nv, -32768             ; Error
 call.is nv, 32767              ; Error
 call.is nv, 65535              ; Error
 call.is nz, -32768             ; Error
 call.is nz, 32767              ; Error
 call.is nz, 65535              ; Error
 call.is p, -32768              ; Error
 call.is p, 32767               ; Error
 call.is p, 65535               ; Error
 call.is pe, -32768             ; Error
 call.is pe, 32767              ; Error
 call.is pe, 65535              ; Error
 call.is po, -32768             ; Error
 call.is po, 32767              ; Error
 call.is po, 65535              ; Error
 call.is v, -32768              ; Error
 call.is v, 32767               ; Error
 call.is v, 65535               ; Error
 call.is z, -32768              ; Error
 call.is z, 32767               ; Error
 call.is z, 65535               ; Error
 cmp a, ixh                     ; Error
 cmp a, ixl                     ; Error
 cmp a, iyh                     ; Error
 cmp a, iyl                     ; Error
 cmp ixh                        ; Error
 cmp ixl                        ; Error
 cmp iyh                        ; Error
 cmp iyl                        ; Error
 cmp.l (hl)                     ; Error
 cmp.l (hl+)                    ; Error
 cmp.l (hl-)                    ; Error
 cmp.l (ix)                     ; Error
 cmp.l (ix+127)                 ; Error
 cmp.l (ix-128)                 ; Error
 cmp.l (iy)                     ; Error
 cmp.l (iy+127)                 ; Error
 cmp.l (iy-128)                 ; Error
 cmp.l a, (hl)                  ; Error
 cmp.l a, (hl+)                 ; Error
 cmp.l a, (hl-)                 ; Error
 cmp.l a, (ix)                  ; Error
 cmp.l a, (ix+127)              ; Error
 cmp.l a, (ix-128)              ; Error
 cmp.l a, (iy)                  ; Error
 cmp.l a, (iy+127)              ; Error
 cmp.l a, (iy-128)              ; Error
 cmp.s (hl)                     ; Error
 cmp.s (hl+)                    ; Error
 cmp.s (hl-)                    ; Error
 cmp.s (ix)                     ; Error
 cmp.s (ix+127)                 ; Error
 cmp.s (ix-128)                 ; Error
 cmp.s (iy)                     ; Error
 cmp.s (iy+127)                 ; Error
 cmp.s (iy-128)                 ; Error
 cmp.s a, (hl)                  ; Error
 cmp.s a, (hl+)                 ; Error
 cmp.s a, (hl-)                 ; Error
 cmp.s a, (ix)                  ; Error
 cmp.s a, (ix+127)              ; Error
 cmp.s a, (ix-128)              ; Error
 cmp.s a, (iy)                  ; Error
 cmp.s a, (iy+127)              ; Error
 cmp.s a, (iy-128)              ; Error
 cp a, ixh                      ; Error
 cp a, ixl                      ; Error
 cp a, iyh                      ; Error
 cp a, iyl                      ; Error
 cp ixh                         ; Error
 cp ixl                         ; Error
 cp iyh                         ; Error
 cp iyl                         ; Error
 cp.l (hl)                      ; Error
 cp.l (hl+)                     ; Error
 cp.l (hl-)                     ; Error
 cp.l (ix)                      ; Error
 cp.l (ix+127)                  ; Error
 cp.l (ix-128)                  ; Error
 cp.l (iy)                      ; Error
 cp.l (iy+127)                  ; Error
 cp.l (iy-128)                  ; Error
 cp.l a, (hl)                   ; Error
 cp.l a, (hl+)                  ; Error
 cp.l a, (hl-)                  ; Error
 cp.l a, (ix)                   ; Error
 cp.l a, (ix+127)               ; Error
 cp.l a, (ix-128)               ; Error
 cp.l a, (iy)                   ; Error
 cp.l a, (iy+127)               ; Error
 cp.l a, (iy-128)               ; Error
 cp.s (hl)                      ; Error
 cp.s (hl+)                     ; Error
 cp.s (hl-)                     ; Error
 cp.s (ix)                      ; Error
 cp.s (ix+127)                  ; Error
 cp.s (ix-128)                  ; Error
 cp.s (iy)                      ; Error
 cp.s (iy+127)                  ; Error
 cp.s (iy-128)                  ; Error
 cp.s a, (hl)                   ; Error
 cp.s a, (hl+)                  ; Error
 cp.s a, (hl-)                  ; Error
 cp.s a, (ix)                   ; Error
 cp.s a, (ix+127)               ; Error
 cp.s a, (ix-128)               ; Error
 cp.s a, (iy)                   ; Error
 cp.s a, (iy+127)               ; Error
 cp.s a, (iy-128)               ; Error
 cpd.l                          ; Error
 cpd.s                          ; Error
 cpdr.l                         ; Error
 cpdr.s                         ; Error
 cpi.l                          ; Error
 cpi.s                          ; Error
 cpir.l                         ; Error
 cpir.s                         ; Error
 dec ixh                        ; Error
 dec ixl                        ; Error
 dec iyh                        ; Error
 dec iyl                        ; Error
 dec.l (hl)                     ; Error
 dec.l (hl+)                    ; Error
 dec.l (hl-)                    ; Error
 dec.l (ix)                     ; Error
 dec.l (ix+127)                 ; Error
 dec.l (ix-128)                 ; Error
 dec.l (iy)                     ; Error
 dec.l (iy+127)                 ; Error
 dec.l (iy-128)                 ; Error
 dec.l bc                       ; Error
 dec.l de                       ; Error
 dec.l hl                       ; Error
 dec.l ix                       ; Error
 dec.l iy                       ; Error
 dec.l sp                       ; Error
 dec.s (hl)                     ; Error
 dec.s (hl+)                    ; Error
 dec.s (hl-)                    ; Error
 dec.s (ix)                     ; Error
 dec.s (ix+127)                 ; Error
 dec.s (ix-128)                 ; Error
 dec.s (iy)                     ; Error
 dec.s (iy+127)                 ; Error
 dec.s (iy-128)                 ; Error
 dec.s bc                       ; Error
 dec.s de                       ; Error
 dec.s hl                       ; Error
 dec.s ix                       ; Error
 dec.s iy                       ; Error
 dec.s sp                       ; Error
 di                             ; Error
 ei                             ; Error
 ex.l (sp), hl                  ; Error
 ex.l (sp), ix                  ; Error
 ex.l (sp), iy                  ; Error
 ex.s (sp), hl                  ; Error
 ex.s (sp), ix                  ; Error
 ex.s (sp), iy                  ; Error
 halt                           ; Error
 hlt                            ; Error
 idet                           ; Error
 im -1                          ; Error
 im 0                           ; Error
 im 1                           ; Error
 im 2                           ; Error
 im 3                           ; Error
 in (bc)                        ; Error
 in (c)                         ; Error
 in -128                        ; Error
 in 127                         ; Error
 in 255                         ; Error
 in a, (-128)                   ; Error
 in a, (127)                    ; Error
 in a, (255)                    ; Error
 in a, (bc)                     ; Error
 in a, (c)                      ; Error
 in b, (bc)                     ; Error
 in b, (c)                      ; Error
 in c, (bc)                     ; Error
 in c, (c)                      ; Error
 in d, (bc)                     ; Error
 in d, (c)                      ; Error
 in e, (bc)                     ; Error
 in e, (c)                      ; Error
 in f, (bc)                     ; Error
 in f, (c)                      ; Error
 in h, (bc)                     ; Error
 in h, (c)                      ; Error
 in l, (bc)                     ; Error
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
 inc.l (hl)                     ; Error
 inc.l (hl+)                    ; Error
 inc.l (hl-)                    ; Error
 inc.l (ix)                     ; Error
 inc.l (ix+127)                 ; Error
 inc.l (ix-128)                 ; Error
 inc.l (iy)                     ; Error
 inc.l (iy+127)                 ; Error
 inc.l (iy-128)                 ; Error
 inc.l bc                       ; Error
 inc.l de                       ; Error
 inc.l hl                       ; Error
 inc.l ix                       ; Error
 inc.l iy                       ; Error
 inc.l sp                       ; Error
 inc.s (hl)                     ; Error
 inc.s (hl+)                    ; Error
 inc.s (hl-)                    ; Error
 inc.s (ix)                     ; Error
 inc.s (ix+127)                 ; Error
 inc.s (ix-128)                 ; Error
 inc.s (iy)                     ; Error
 inc.s (iy+127)                 ; Error
 inc.s (iy-128)                 ; Error
 inc.s bc                       ; Error
 inc.s de                       ; Error
 inc.s hl                       ; Error
 inc.s ix                       ; Error
 inc.s iy                       ; Error
 inc.s sp                       ; Error
 ind                            ; Error
 ind.l                          ; Error
 ind.s                          ; Error
 ind2                           ; Error
 ind2.l                         ; Error
 ind2.s                         ; Error
 ind2r                          ; Error
 ind2r.l                        ; Error
 ind2r.s                        ; Error
 indm                           ; Error
 indm.l                         ; Error
 indm.s                         ; Error
 indmr                          ; Error
 indmr.l                        ; Error
 indmr.s                        ; Error
 indr                           ; Error
 indr.l                         ; Error
 indr.s                         ; Error
 indrx                          ; Error
 indrx.l                        ; Error
 indrx.s                        ; Error
 ini                            ; Error
 ini.l                          ; Error
 ini.s                          ; Error
 ini2                           ; Error
 ini2.l                         ; Error
 ini2.s                         ; Error
 ini2r                          ; Error
 ini2r.l                        ; Error
 ini2r.s                        ; Error
 inim                           ; Error
 inim.l                         ; Error
 inim.s                         ; Error
 inimr                          ; Error
 inimr.l                        ; Error
 inimr.s                        ; Error
 inir                           ; Error
 inir.l                         ; Error
 inir.s                         ; Error
 inirx                          ; Error
 inirx.l                        ; Error
 inirx.s                        ; Error
 ioe altd bit -1, (hl)          ; Error
 ioe altd bit -1, (ix)          ; Error
 ioe altd bit -1, (ix+127)      ; Error
 ioe altd bit -1, (ix-128)      ; Error
 ioe altd bit -1, (iy)          ; Error
 ioe altd bit -1, (iy+127)      ; Error
 ioe altd bit -1, (iy-128)      ; Error
 ioe altd bit 8, (hl)           ; Error
 ioe altd bit 8, (ix)           ; Error
 ioe altd bit 8, (ix+127)       ; Error
 ioe altd bit 8, (ix-128)       ; Error
 ioe altd bit 8, (iy)           ; Error
 ioe altd bit 8, (iy+127)       ; Error
 ioe altd bit 8, (iy-128)       ; Error
 ioe bit -1, (hl)               ; Error
 ioe bit -1, (ix)               ; Error
 ioe bit -1, (ix+127)           ; Error
 ioe bit -1, (ix-128)           ; Error
 ioe bit -1, (iy)               ; Error
 ioe bit -1, (iy+127)           ; Error
 ioe bit -1, (iy-128)           ; Error
 ioe bit 8, (hl)                ; Error
 ioe bit 8, (ix)                ; Error
 ioe bit 8, (ix+127)            ; Error
 ioe bit 8, (ix-128)            ; Error
 ioe bit 8, (iy)                ; Error
 ioe bit 8, (iy+127)            ; Error
 ioe bit 8, (iy-128)            ; Error
 ioe lddsr                      ; Error
 ioe ldisr                      ; Error
 ioe lsddr                      ; Error
 ioe lsdr                       ; Error
 ioe lsidr                      ; Error
 ioe lsir                       ; Error
 ioe res -1, (hl)               ; Error
 ioe res -1, (ix)               ; Error
 ioe res -1, (ix+127)           ; Error
 ioe res -1, (ix-128)           ; Error
 ioe res -1, (iy)               ; Error
 ioe res -1, (iy+127)           ; Error
 ioe res -1, (iy-128)           ; Error
 ioe res 8, (hl)                ; Error
 ioe res 8, (ix)                ; Error
 ioe res 8, (ix+127)            ; Error
 ioe res 8, (ix-128)            ; Error
 ioe res 8, (iy)                ; Error
 ioe res 8, (iy+127)            ; Error
 ioe res 8, (iy-128)            ; Error
 ioe set -1, (hl)               ; Error
 ioe set -1, (ix)               ; Error
 ioe set -1, (ix+127)           ; Error
 ioe set -1, (ix-128)           ; Error
 ioe set -1, (iy)               ; Error
 ioe set -1, (iy+127)           ; Error
 ioe set -1, (iy-128)           ; Error
 ioe set 8, (hl)                ; Error
 ioe set 8, (ix)                ; Error
 ioe set 8, (ix+127)            ; Error
 ioe set 8, (ix-128)            ; Error
 ioe set 8, (iy)                ; Error
 ioe set 8, (iy+127)            ; Error
 ioe set 8, (iy-128)            ; Error
 ioi altd bit -1, (hl)          ; Error
 ioi altd bit -1, (ix)          ; Error
 ioi altd bit -1, (ix+127)      ; Error
 ioi altd bit -1, (ix-128)      ; Error
 ioi altd bit -1, (iy)          ; Error
 ioi altd bit -1, (iy+127)      ; Error
 ioi altd bit -1, (iy-128)      ; Error
 ioi altd bit 8, (hl)           ; Error
 ioi altd bit 8, (ix)           ; Error
 ioi altd bit 8, (ix+127)       ; Error
 ioi altd bit 8, (ix-128)       ; Error
 ioi altd bit 8, (iy)           ; Error
 ioi altd bit 8, (iy+127)       ; Error
 ioi altd bit 8, (iy-128)       ; Error
 ioi bit -1, (hl)               ; Error
 ioi bit -1, (ix)               ; Error
 ioi bit -1, (ix+127)           ; Error
 ioi bit -1, (ix-128)           ; Error
 ioi bit -1, (iy)               ; Error
 ioi bit -1, (iy+127)           ; Error
 ioi bit -1, (iy-128)           ; Error
 ioi bit 8, (hl)                ; Error
 ioi bit 8, (ix)                ; Error
 ioi bit 8, (ix+127)            ; Error
 ioi bit 8, (ix-128)            ; Error
 ioi bit 8, (iy)                ; Error
 ioi bit 8, (iy+127)            ; Error
 ioi bit 8, (iy-128)            ; Error
 ioi lddsr                      ; Error
 ioi ldisr                      ; Error
 ioi lsddr                      ; Error
 ioi lsdr                       ; Error
 ioi lsidr                      ; Error
 ioi lsir                       ; Error
 ioi res -1, (hl)               ; Error
 ioi res -1, (ix)               ; Error
 ioi res -1, (ix+127)           ; Error
 ioi res -1, (ix-128)           ; Error
 ioi res -1, (iy)               ; Error
 ioi res -1, (iy+127)           ; Error
 ioi res -1, (iy-128)           ; Error
 ioi res 8, (hl)                ; Error
 ioi res 8, (ix)                ; Error
 ioi res 8, (ix+127)            ; Error
 ioi res 8, (ix-128)            ; Error
 ioi res 8, (iy)                ; Error
 ioi res 8, (iy+127)            ; Error
 ioi res 8, (iy-128)            ; Error
 ioi set -1, (hl)               ; Error
 ioi set -1, (ix)               ; Error
 ioi set -1, (ix+127)           ; Error
 ioi set -1, (ix-128)           ; Error
 ioi set -1, (iy)               ; Error
 ioi set -1, (iy+127)           ; Error
 ioi set -1, (iy-128)           ; Error
 ioi set 8, (hl)                ; Error
 ioi set 8, (ix)                ; Error
 ioi set 8, (ix+127)            ; Error
 ioi set 8, (ix-128)            ; Error
 ioi set 8, (iy)                ; Error
 ioi set 8, (iy+127)            ; Error
 ioi set 8, (iy-128)            ; Error
 ipset -1                       ; Error
 ipset 4                        ; Error
 jk -32768                      ; Error
 jk 32767                       ; Error
 jk 65535                       ; Error
 jmp (c)                        ; Error
 jmp k,-32768                   ; Error
 jmp k,32767                    ; Error
 jmp k,65535                    ; Error
 jmp nk,-32768                  ; Error
 jmp nk,32767                   ; Error
 jmp nk,65535                   ; Error
 jmp nx5,-32768                 ; Error
 jmp nx5,32767                  ; Error
 jmp nx5,65535                  ; Error
 jmp x5,-32768                  ; Error
 jmp x5,32767                   ; Error
 jmp x5,65535                   ; Error
 jmp.l (hl)                     ; Error
 jmp.l (ix)                     ; Error
 jmp.l (iy)                     ; Error
 jmp.lil 0x123456               ; Error
 jmp.lil c, 0x123456            ; Error
 jmp.lil m, 0x123456            ; Error
 jmp.lil nc, 0x123456           ; Error
 jmp.lil nv, 0x123456           ; Error
 jmp.lil nz, 0x123456           ; Error
 jmp.lil p, 0x123456            ; Error
 jmp.lil pe, 0x123456           ; Error
 jmp.lil po, 0x123456           ; Error
 jmp.lil v, 0x123456            ; Error
 jmp.lil z, 0x123456            ; Error
 jmp.s (hl)                     ; Error
 jmp.s (ix)                     ; Error
 jmp.s (iy)                     ; Error
 jmp.sis -32768                 ; Error
 jmp.sis 32767                  ; Error
 jmp.sis 65535                  ; Error
 jmp.sis c, -32768              ; Error
 jmp.sis c, 32767               ; Error
 jmp.sis c, 65535               ; Error
 jmp.sis m, -32768              ; Error
 jmp.sis m, 32767               ; Error
 jmp.sis m, 65535               ; Error
 jmp.sis nc, -32768             ; Error
 jmp.sis nc, 32767              ; Error
 jmp.sis nc, 65535              ; Error
 jmp.sis nv, -32768             ; Error
 jmp.sis nv, 32767              ; Error
 jmp.sis nv, 65535              ; Error
 jmp.sis nz, -32768             ; Error
 jmp.sis nz, 32767              ; Error
 jmp.sis nz, 65535              ; Error
 jmp.sis p, -32768              ; Error
 jmp.sis p, 32767               ; Error
 jmp.sis p, 65535               ; Error
 jmp.sis pe, -32768             ; Error
 jmp.sis pe, 32767              ; Error
 jmp.sis pe, 65535              ; Error
 jmp.sis po, -32768             ; Error
 jmp.sis po, 32767              ; Error
 jmp.sis po, 65535              ; Error
 jmp.sis v, -32768              ; Error
 jmp.sis v, 32767               ; Error
 jmp.sis v, 65535               ; Error
 jmp.sis z, -32768              ; Error
 jmp.sis z, 32767               ; Error
 jmp.sis z, 65535               ; Error
 jnk -32768                     ; Error
 jnk 32767                      ; Error
 jnk 65535                      ; Error
 jnx5 -32768                    ; Error
 jnx5 32767                     ; Error
 jnx5 65535                     ; Error
 jp (c)                         ; Error
 jp k,-32768                    ; Error
 jp k,32767                     ; Error
 jp k,65535                     ; Error
 jp nk,-32768                   ; Error
 jp nk,32767                    ; Error
 jp nk,65535                    ; Error
 jp nx5,-32768                  ; Error
 jp nx5,32767                   ; Error
 jp nx5,65535                   ; Error
 jp x5,-32768                   ; Error
 jp x5,32767                    ; Error
 jp x5,65535                    ; Error
 jp.l (hl)                      ; Error
 jp.l (ix)                      ; Error
 jp.l (iy)                      ; Error
 jp.lil 0x123456                ; Error
 jp.lil c, 0x123456             ; Error
 jp.lil m, 0x123456             ; Error
 jp.lil nc, 0x123456            ; Error
 jp.lil nv, 0x123456            ; Error
 jp.lil nz, 0x123456            ; Error
 jp.lil p, 0x123456             ; Error
 jp.lil pe, 0x123456            ; Error
 jp.lil po, 0x123456            ; Error
 jp.lil v, 0x123456             ; Error
 jp.lil z, 0x123456             ; Error
 jp.s (hl)                      ; Error
 jp.s (ix)                      ; Error
 jp.s (iy)                      ; Error
 jp.sis -32768                  ; Error
 jp.sis 32767                   ; Error
 jp.sis 65535                   ; Error
 jp.sis c, -32768               ; Error
 jp.sis c, 32767                ; Error
 jp.sis c, 65535                ; Error
 jp.sis m, -32768               ; Error
 jp.sis m, 32767                ; Error
 jp.sis m, 65535                ; Error
 jp.sis nc, -32768              ; Error
 jp.sis nc, 32767               ; Error
 jp.sis nc, 65535               ; Error
 jp.sis nv, -32768              ; Error
 jp.sis nv, 32767               ; Error
 jp.sis nv, 65535               ; Error
 jp.sis nz, -32768              ; Error
 jp.sis nz, 32767               ; Error
 jp.sis nz, 65535               ; Error
 jp.sis p, -32768               ; Error
 jp.sis p, 32767                ; Error
 jp.sis p, 65535                ; Error
 jp.sis pe, -32768              ; Error
 jp.sis pe, 32767               ; Error
 jp.sis pe, 65535               ; Error
 jp.sis po, -32768              ; Error
 jp.sis po, 32767               ; Error
 jp.sis po, 65535               ; Error
 jp.sis v, -32768               ; Error
 jp.sis v, 32767                ; Error
 jp.sis v, 65535                ; Error
 jp.sis z, -32768               ; Error
 jp.sis z, 32767                ; Error
 jp.sis z, 65535                ; Error
 jx5 -32768                     ; Error
 jx5 32767                      ; Error
 jx5 65535                      ; Error
 ld (c), a                      ; Error
 ld (de), hl                    ; Error
 ld (hl+), hl                   ; Error
 ld (ix), bc                    ; Error
 ld (ix), de                    ; Error
 ld (ix), ix                    ; Error
 ld (ix), iy                    ; Error
 ld (ix+127), bc                ; Error
 ld (ix+127), de                ; Error
 ld (ix+127), ix                ; Error
 ld (ix+127), iy                ; Error
 ld (ix-128), bc                ; Error
 ld (ix-128), de                ; Error
 ld (ix-128), ix                ; Error
 ld (ix-128), iy                ; Error
 ld (iy), bc                    ; Error
 ld (iy), de                    ; Error
 ld (iy), ix                    ; Error
 ld (iy), iy                    ; Error
 ld (iy+127), bc                ; Error
 ld (iy+127), de                ; Error
 ld (iy+127), ix                ; Error
 ld (iy+127), iy                ; Error
 ld (iy-128), bc                ; Error
 ld (iy-128), de                ; Error
 ld (iy-128), ix                ; Error
 ld (iy-128), iy                ; Error
 ld a, (c)                      ; Error
 ld a, i                        ; Error
 ld a, ixh                      ; Error
 ld a, ixl                      ; Error
 ld a, iyh                      ; Error
 ld a, iyl                      ; Error
 ld a, mb                       ; Error
 ld a, r                        ; Error
 ld b, ixh                      ; Error
 ld b, ixl                      ; Error
 ld b, iyh                      ; Error
 ld b, iyl                      ; Error
 ld bc, (ix)                    ; Error
 ld bc, (ix+127)                ; Error
 ld bc, (ix-128)                ; Error
 ld bc, (iy)                    ; Error
 ld bc, (iy+127)                ; Error
 ld bc, (iy-128)                ; Error
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
 ld de, (ix)                    ; Error
 ld de, (ix+127)                ; Error
 ld de, (ix-128)                ; Error
 ld de, (iy)                    ; Error
 ld de, (iy+127)                ; Error
 ld de, (iy-128)                ; Error
 ld de, hl+0                    ; Error
 ld de, hl+255                  ; Error
 ld de, ix                      ; Error
 ld de, iy                      ; Error
 ld e, ixh                      ; Error
 ld e, ixl                      ; Error
 ld e, iyh                      ; Error
 ld e, iyl                      ; Error
 ld hl, (de)                    ; Error
 ld hl, (hl+)                   ; Error
 ld hl, i                       ; Error
 ld i, a                        ; Error
 ld i, hl                       ; Error
 ld ix, (ix)                    ; Error
 ld ix, (ix+127)                ; Error
 ld ix, (ix-128)                ; Error
 ld ix, (iy)                    ; Error
 ld ix, (iy+127)                ; Error
 ld ix, (iy-128)                ; Error
 ld ix, bc                      ; Error
 ld ix, de                      ; Error
 ld ix, iy                      ; Error
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
 ld iy, (ix)                    ; Error
 ld iy, (ix+127)                ; Error
 ld iy, (ix-128)                ; Error
 ld iy, (iy)                    ; Error
 ld iy, (iy+127)                ; Error
 ld iy, (iy-128)                ; Error
 ld iy, bc                      ; Error
 ld iy, de                      ; Error
 ld iy, ix                      ; Error
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
 ld mb, a                       ; Error
 ld r, a                        ; Error
 ld.il (0x123456), a            ; Error
 ld.il a, (0x123456)            ; Error
 ld.is (-32768), a              ; Error
 ld.is (32767), a               ; Error
 ld.is (65535), a               ; Error
 ld.is a, (-32768)              ; Error
 ld.is a, (32767)               ; Error
 ld.is a, (65535)               ; Error
 ld.l (bc), a                   ; Error
 ld.l (bc+), a                  ; Error
 ld.l (bc-), a                  ; Error
 ld.l (de), a                   ; Error
 ld.l (de+), a                  ; Error
 ld.l (de-), a                  ; Error
 ld.l (hl), -128                ; Error
 ld.l (hl), 127                 ; Error
 ld.l (hl), 255                 ; Error
 ld.l (hl), a                   ; Error
 ld.l (hl), b                   ; Error
 ld.l (hl), bc                  ; Error
 ld.l (hl), c                   ; Error
 ld.l (hl), d                   ; Error
 ld.l (hl), de                  ; Error
 ld.l (hl), e                   ; Error
 ld.l (hl), h                   ; Error
 ld.l (hl), hl                  ; Error
 ld.l (hl), ix                  ; Error
 ld.l (hl), iy                  ; Error
 ld.l (hl), l                   ; Error
 ld.l (hl+), -128               ; Error
 ld.l (hl+), 127                ; Error
 ld.l (hl+), 255                ; Error
 ld.l (hl+), a                  ; Error
 ld.l (hl+), b                  ; Error
 ld.l (hl+), bc                 ; Error
 ld.l (hl+), c                  ; Error
 ld.l (hl+), d                  ; Error
 ld.l (hl+), de                 ; Error
 ld.l (hl+), e                  ; Error
 ld.l (hl+), h                  ; Error
 ld.l (hl+), hl                 ; Error
 ld.l (hl+), ix                 ; Error
 ld.l (hl+), iy                 ; Error
 ld.l (hl+), l                  ; Error
 ld.l (hl-), -128               ; Error
 ld.l (hl-), 127                ; Error
 ld.l (hl-), 255                ; Error
 ld.l (hl-), a                  ; Error
 ld.l (hl-), b                  ; Error
 ld.l (hl-), c                  ; Error
 ld.l (hl-), d                  ; Error
 ld.l (hl-), e                  ; Error
 ld.l (hl-), h                  ; Error
 ld.l (hl-), l                  ; Error
 ld.l (hld), a                  ; Error
 ld.l (hld), b                  ; Error
 ld.l (hld), c                  ; Error
 ld.l (hld), d                  ; Error
 ld.l (hld), e                  ; Error
 ld.l (hld), h                  ; Error
 ld.l (hld), l                  ; Error
 ld.l (hli), a                  ; Error
 ld.l (hli), b                  ; Error
 ld.l (hli), c                  ; Error
 ld.l (hli), d                  ; Error
 ld.l (hli), e                  ; Error
 ld.l (hli), h                  ; Error
 ld.l (hli), l                  ; Error
 ld.l (ix), -128                ; Error
 ld.l (ix), 127                 ; Error
 ld.l (ix), 255                 ; Error
 ld.l (ix), a                   ; Error
 ld.l (ix), b                   ; Error
 ld.l (ix), bc                  ; Error
 ld.l (ix), c                   ; Error
 ld.l (ix), d                   ; Error
 ld.l (ix), de                  ; Error
 ld.l (ix), e                   ; Error
 ld.l (ix), h                   ; Error
 ld.l (ix), hl                  ; Error
 ld.l (ix), ix                  ; Error
 ld.l (ix), iy                  ; Error
 ld.l (ix), l                   ; Error
 ld.l (ix+127), -128            ; Error
 ld.l (ix+127), 127             ; Error
 ld.l (ix+127), 255             ; Error
 ld.l (ix+127), a               ; Error
 ld.l (ix+127), b               ; Error
 ld.l (ix+127), bc              ; Error
 ld.l (ix+127), c               ; Error
 ld.l (ix+127), d               ; Error
 ld.l (ix+127), de              ; Error
 ld.l (ix+127), e               ; Error
 ld.l (ix+127), h               ; Error
 ld.l (ix+127), hl              ; Error
 ld.l (ix+127), ix              ; Error
 ld.l (ix+127), iy              ; Error
 ld.l (ix+127), l               ; Error
 ld.l (ix-128), -128            ; Error
 ld.l (ix-128), 127             ; Error
 ld.l (ix-128), 255             ; Error
 ld.l (ix-128), a               ; Error
 ld.l (ix-128), b               ; Error
 ld.l (ix-128), bc              ; Error
 ld.l (ix-128), c               ; Error
 ld.l (ix-128), d               ; Error
 ld.l (ix-128), de              ; Error
 ld.l (ix-128), e               ; Error
 ld.l (ix-128), h               ; Error
 ld.l (ix-128), hl              ; Error
 ld.l (ix-128), ix              ; Error
 ld.l (ix-128), iy              ; Error
 ld.l (ix-128), l               ; Error
 ld.l (iy), -128                ; Error
 ld.l (iy), 127                 ; Error
 ld.l (iy), 255                 ; Error
 ld.l (iy), a                   ; Error
 ld.l (iy), b                   ; Error
 ld.l (iy), bc                  ; Error
 ld.l (iy), c                   ; Error
 ld.l (iy), d                   ; Error
 ld.l (iy), de                  ; Error
 ld.l (iy), e                   ; Error
 ld.l (iy), h                   ; Error
 ld.l (iy), hl                  ; Error
 ld.l (iy), ix                  ; Error
 ld.l (iy), iy                  ; Error
 ld.l (iy), l                   ; Error
 ld.l (iy+127), -128            ; Error
 ld.l (iy+127), 127             ; Error
 ld.l (iy+127), 255             ; Error
 ld.l (iy+127), a               ; Error
 ld.l (iy+127), b               ; Error
 ld.l (iy+127), bc              ; Error
 ld.l (iy+127), c               ; Error
 ld.l (iy+127), d               ; Error
 ld.l (iy+127), de              ; Error
 ld.l (iy+127), e               ; Error
 ld.l (iy+127), h               ; Error
 ld.l (iy+127), hl              ; Error
 ld.l (iy+127), ix              ; Error
 ld.l (iy+127), iy              ; Error
 ld.l (iy+127), l               ; Error
 ld.l (iy-128), -128            ; Error
 ld.l (iy-128), 127             ; Error
 ld.l (iy-128), 255             ; Error
 ld.l (iy-128), a               ; Error
 ld.l (iy-128), b               ; Error
 ld.l (iy-128), bc              ; Error
 ld.l (iy-128), c               ; Error
 ld.l (iy-128), d               ; Error
 ld.l (iy-128), de              ; Error
 ld.l (iy-128), e               ; Error
 ld.l (iy-128), h               ; Error
 ld.l (iy-128), hl              ; Error
 ld.l (iy-128), ix              ; Error
 ld.l (iy-128), iy              ; Error
 ld.l (iy-128), l               ; Error
 ld.l a, (bc)                   ; Error
 ld.l a, (bc+)                  ; Error
 ld.l a, (bc-)                  ; Error
 ld.l a, (de)                   ; Error
 ld.l a, (de+)                  ; Error
 ld.l a, (de-)                  ; Error
 ld.l a, (hl)                   ; Error
 ld.l a, (hl+)                  ; Error
 ld.l a, (hl-)                  ; Error
 ld.l a, (hld)                  ; Error
 ld.l a, (hli)                  ; Error
 ld.l a, (ix)                   ; Error
 ld.l a, (ix+127)               ; Error
 ld.l a, (ix-128)               ; Error
 ld.l a, (iy)                   ; Error
 ld.l a, (iy+127)               ; Error
 ld.l a, (iy-128)               ; Error
 ld.l b, (hl)                   ; Error
 ld.l b, (hl+)                  ; Error
 ld.l b, (hl-)                  ; Error
 ld.l b, (hld)                  ; Error
 ld.l b, (hli)                  ; Error
 ld.l b, (ix)                   ; Error
 ld.l b, (ix+127)               ; Error
 ld.l b, (ix-128)               ; Error
 ld.l b, (iy)                   ; Error
 ld.l b, (iy+127)               ; Error
 ld.l b, (iy-128)               ; Error
 ld.l bc, (hl)                  ; Error
 ld.l bc, (hl+)                 ; Error
 ld.l bc, (ix)                  ; Error
 ld.l bc, (ix+127)              ; Error
 ld.l bc, (ix-128)              ; Error
 ld.l bc, (iy)                  ; Error
 ld.l bc, (iy+127)              ; Error
 ld.l bc, (iy-128)              ; Error
 ld.l c, (hl)                   ; Error
 ld.l c, (hl+)                  ; Error
 ld.l c, (hl-)                  ; Error
 ld.l c, (hld)                  ; Error
 ld.l c, (hli)                  ; Error
 ld.l c, (ix)                   ; Error
 ld.l c, (ix+127)               ; Error
 ld.l c, (ix-128)               ; Error
 ld.l c, (iy)                   ; Error
 ld.l c, (iy+127)               ; Error
 ld.l c, (iy-128)               ; Error
 ld.l d, (hl)                   ; Error
 ld.l d, (hl+)                  ; Error
 ld.l d, (hl-)                  ; Error
 ld.l d, (hld)                  ; Error
 ld.l d, (hli)                  ; Error
 ld.l d, (ix)                   ; Error
 ld.l d, (ix+127)               ; Error
 ld.l d, (ix-128)               ; Error
 ld.l d, (iy)                   ; Error
 ld.l d, (iy+127)               ; Error
 ld.l d, (iy-128)               ; Error
 ld.l de, (hl)                  ; Error
 ld.l de, (hl+)                 ; Error
 ld.l de, (ix)                  ; Error
 ld.l de, (ix+127)              ; Error
 ld.l de, (ix-128)              ; Error
 ld.l de, (iy)                  ; Error
 ld.l de, (iy+127)              ; Error
 ld.l de, (iy-128)              ; Error
 ld.l e, (hl)                   ; Error
 ld.l e, (hl+)                  ; Error
 ld.l e, (hl-)                  ; Error
 ld.l e, (hld)                  ; Error
 ld.l e, (hli)                  ; Error
 ld.l e, (ix)                   ; Error
 ld.l e, (ix+127)               ; Error
 ld.l e, (ix-128)               ; Error
 ld.l e, (iy)                   ; Error
 ld.l e, (iy+127)               ; Error
 ld.l e, (iy-128)               ; Error
 ld.l h, (hl)                   ; Error
 ld.l h, (hl+)                  ; Error
 ld.l h, (hl-)                  ; Error
 ld.l h, (hld)                  ; Error
 ld.l h, (hli)                  ; Error
 ld.l h, (ix)                   ; Error
 ld.l h, (ix+127)               ; Error
 ld.l h, (ix-128)               ; Error
 ld.l h, (iy)                   ; Error
 ld.l h, (iy+127)               ; Error
 ld.l h, (iy-128)               ; Error
 ld.l hl, (hl)                  ; Error
 ld.l hl, (hl+)                 ; Error
 ld.l hl, (ix)                  ; Error
 ld.l hl, (ix+127)              ; Error
 ld.l hl, (ix-128)              ; Error
 ld.l hl, (iy)                  ; Error
 ld.l hl, (iy+127)              ; Error
 ld.l hl, (iy-128)              ; Error
 ld.l ix, (hl)                  ; Error
 ld.l ix, (hl+)                 ; Error
 ld.l ix, (ix)                  ; Error
 ld.l ix, (ix+127)              ; Error
 ld.l ix, (ix-128)              ; Error
 ld.l ix, (iy)                  ; Error
 ld.l ix, (iy+127)              ; Error
 ld.l ix, (iy-128)              ; Error
 ld.l iy, (hl)                  ; Error
 ld.l iy, (hl+)                 ; Error
 ld.l iy, (ix)                  ; Error
 ld.l iy, (ix+127)              ; Error
 ld.l iy, (ix-128)              ; Error
 ld.l iy, (iy)                  ; Error
 ld.l iy, (iy+127)              ; Error
 ld.l iy, (iy-128)              ; Error
 ld.l l, (hl)                   ; Error
 ld.l l, (hl+)                  ; Error
 ld.l l, (hl-)                  ; Error
 ld.l l, (hld)                  ; Error
 ld.l l, (hli)                  ; Error
 ld.l l, (ix)                   ; Error
 ld.l l, (ix+127)               ; Error
 ld.l l, (ix-128)               ; Error
 ld.l l, (iy)                   ; Error
 ld.l l, (iy+127)               ; Error
 ld.l l, (iy-128)               ; Error
 ld.l sp, hl                    ; Error
 ld.l sp, ix                    ; Error
 ld.l sp, iy                    ; Error
 ld.lil (0x123456), bc          ; Error
 ld.lil (0x123456), de          ; Error
 ld.lil (0x123456), hl          ; Error
 ld.lil (0x123456), ix          ; Error
 ld.lil (0x123456), iy          ; Error
 ld.lil (0x123456), sp          ; Error
 ld.lil bc, (0x123456)          ; Error
 ld.lil bc, 0x123456            ; Error
 ld.lil de, (0x123456)          ; Error
 ld.lil de, 0x123456            ; Error
 ld.lil hl, (0x123456)          ; Error
 ld.lil hl, 0x123456            ; Error
 ld.lil ix, (0x123456)          ; Error
 ld.lil ix, 0x123456            ; Error
 ld.lil iy, (0x123456)          ; Error
 ld.lil iy, 0x123456            ; Error
 ld.lil sp, (0x123456)          ; Error
 ld.lil sp, 0x123456            ; Error
 ld.s (bc), a                   ; Error
 ld.s (bc+), a                  ; Error
 ld.s (bc-), a                  ; Error
 ld.s (de), a                   ; Error
 ld.s (de+), a                  ; Error
 ld.s (de-), a                  ; Error
 ld.s (hl), -128                ; Error
 ld.s (hl), 127                 ; Error
 ld.s (hl), 255                 ; Error
 ld.s (hl), a                   ; Error
 ld.s (hl), b                   ; Error
 ld.s (hl), bc                  ; Error
 ld.s (hl), c                   ; Error
 ld.s (hl), d                   ; Error
 ld.s (hl), de                  ; Error
 ld.s (hl), e                   ; Error
 ld.s (hl), h                   ; Error
 ld.s (hl), hl                  ; Error
 ld.s (hl), ix                  ; Error
 ld.s (hl), iy                  ; Error
 ld.s (hl), l                   ; Error
 ld.s (hl+), -128               ; Error
 ld.s (hl+), 127                ; Error
 ld.s (hl+), 255                ; Error
 ld.s (hl+), a                  ; Error
 ld.s (hl+), b                  ; Error
 ld.s (hl+), bc                 ; Error
 ld.s (hl+), c                  ; Error
 ld.s (hl+), d                  ; Error
 ld.s (hl+), de                 ; Error
 ld.s (hl+), e                  ; Error
 ld.s (hl+), h                  ; Error
 ld.s (hl+), hl                 ; Error
 ld.s (hl+), ix                 ; Error
 ld.s (hl+), iy                 ; Error
 ld.s (hl+), l                  ; Error
 ld.s (hl-), -128               ; Error
 ld.s (hl-), 127                ; Error
 ld.s (hl-), 255                ; Error
 ld.s (hl-), a                  ; Error
 ld.s (hl-), b                  ; Error
 ld.s (hl-), c                  ; Error
 ld.s (hl-), d                  ; Error
 ld.s (hl-), e                  ; Error
 ld.s (hl-), h                  ; Error
 ld.s (hl-), l                  ; Error
 ld.s (hld), a                  ; Error
 ld.s (hld), b                  ; Error
 ld.s (hld), c                  ; Error
 ld.s (hld), d                  ; Error
 ld.s (hld), e                  ; Error
 ld.s (hld), h                  ; Error
 ld.s (hld), l                  ; Error
 ld.s (hli), a                  ; Error
 ld.s (hli), b                  ; Error
 ld.s (hli), c                  ; Error
 ld.s (hli), d                  ; Error
 ld.s (hli), e                  ; Error
 ld.s (hli), h                  ; Error
 ld.s (hli), l                  ; Error
 ld.s (ix), -128                ; Error
 ld.s (ix), 127                 ; Error
 ld.s (ix), 255                 ; Error
 ld.s (ix), a                   ; Error
 ld.s (ix), b                   ; Error
 ld.s (ix), bc                  ; Error
 ld.s (ix), c                   ; Error
 ld.s (ix), d                   ; Error
 ld.s (ix), de                  ; Error
 ld.s (ix), e                   ; Error
 ld.s (ix), h                   ; Error
 ld.s (ix), hl                  ; Error
 ld.s (ix), ix                  ; Error
 ld.s (ix), iy                  ; Error
 ld.s (ix), l                   ; Error
 ld.s (ix+127), -128            ; Error
 ld.s (ix+127), 127             ; Error
 ld.s (ix+127), 255             ; Error
 ld.s (ix+127), a               ; Error
 ld.s (ix+127), b               ; Error
 ld.s (ix+127), bc              ; Error
 ld.s (ix+127), c               ; Error
 ld.s (ix+127), d               ; Error
 ld.s (ix+127), de              ; Error
 ld.s (ix+127), e               ; Error
 ld.s (ix+127), h               ; Error
 ld.s (ix+127), hl              ; Error
 ld.s (ix+127), ix              ; Error
 ld.s (ix+127), iy              ; Error
 ld.s (ix+127), l               ; Error
 ld.s (ix-128), -128            ; Error
 ld.s (ix-128), 127             ; Error
 ld.s (ix-128), 255             ; Error
 ld.s (ix-128), a               ; Error
 ld.s (ix-128), b               ; Error
 ld.s (ix-128), bc              ; Error
 ld.s (ix-128), c               ; Error
 ld.s (ix-128), d               ; Error
 ld.s (ix-128), de              ; Error
 ld.s (ix-128), e               ; Error
 ld.s (ix-128), h               ; Error
 ld.s (ix-128), hl              ; Error
 ld.s (ix-128), ix              ; Error
 ld.s (ix-128), iy              ; Error
 ld.s (ix-128), l               ; Error
 ld.s (iy), -128                ; Error
 ld.s (iy), 127                 ; Error
 ld.s (iy), 255                 ; Error
 ld.s (iy), a                   ; Error
 ld.s (iy), b                   ; Error
 ld.s (iy), bc                  ; Error
 ld.s (iy), c                   ; Error
 ld.s (iy), d                   ; Error
 ld.s (iy), de                  ; Error
 ld.s (iy), e                   ; Error
 ld.s (iy), h                   ; Error
 ld.s (iy), hl                  ; Error
 ld.s (iy), ix                  ; Error
 ld.s (iy), iy                  ; Error
 ld.s (iy), l                   ; Error
 ld.s (iy+127), -128            ; Error
 ld.s (iy+127), 127             ; Error
 ld.s (iy+127), 255             ; Error
 ld.s (iy+127), a               ; Error
 ld.s (iy+127), b               ; Error
 ld.s (iy+127), bc              ; Error
 ld.s (iy+127), c               ; Error
 ld.s (iy+127), d               ; Error
 ld.s (iy+127), de              ; Error
 ld.s (iy+127), e               ; Error
 ld.s (iy+127), h               ; Error
 ld.s (iy+127), hl              ; Error
 ld.s (iy+127), ix              ; Error
 ld.s (iy+127), iy              ; Error
 ld.s (iy+127), l               ; Error
 ld.s (iy-128), -128            ; Error
 ld.s (iy-128), 127             ; Error
 ld.s (iy-128), 255             ; Error
 ld.s (iy-128), a               ; Error
 ld.s (iy-128), b               ; Error
 ld.s (iy-128), bc              ; Error
 ld.s (iy-128), c               ; Error
 ld.s (iy-128), d               ; Error
 ld.s (iy-128), de              ; Error
 ld.s (iy-128), e               ; Error
 ld.s (iy-128), h               ; Error
 ld.s (iy-128), hl              ; Error
 ld.s (iy-128), ix              ; Error
 ld.s (iy-128), iy              ; Error
 ld.s (iy-128), l               ; Error
 ld.s a, (bc)                   ; Error
 ld.s a, (bc+)                  ; Error
 ld.s a, (bc-)                  ; Error
 ld.s a, (de)                   ; Error
 ld.s a, (de+)                  ; Error
 ld.s a, (de-)                  ; Error
 ld.s a, (hl)                   ; Error
 ld.s a, (hl+)                  ; Error
 ld.s a, (hl-)                  ; Error
 ld.s a, (hld)                  ; Error
 ld.s a, (hli)                  ; Error
 ld.s a, (ix)                   ; Error
 ld.s a, (ix+127)               ; Error
 ld.s a, (ix-128)               ; Error
 ld.s a, (iy)                   ; Error
 ld.s a, (iy+127)               ; Error
 ld.s a, (iy-128)               ; Error
 ld.s b, (hl)                   ; Error
 ld.s b, (hl+)                  ; Error
 ld.s b, (hl-)                  ; Error
 ld.s b, (hld)                  ; Error
 ld.s b, (hli)                  ; Error
 ld.s b, (ix)                   ; Error
 ld.s b, (ix+127)               ; Error
 ld.s b, (ix-128)               ; Error
 ld.s b, (iy)                   ; Error
 ld.s b, (iy+127)               ; Error
 ld.s b, (iy-128)               ; Error
 ld.s bc, (hl)                  ; Error
 ld.s bc, (hl+)                 ; Error
 ld.s bc, (ix)                  ; Error
 ld.s bc, (ix+127)              ; Error
 ld.s bc, (ix-128)              ; Error
 ld.s bc, (iy)                  ; Error
 ld.s bc, (iy+127)              ; Error
 ld.s bc, (iy-128)              ; Error
 ld.s c, (hl)                   ; Error
 ld.s c, (hl+)                  ; Error
 ld.s c, (hl-)                  ; Error
 ld.s c, (hld)                  ; Error
 ld.s c, (hli)                  ; Error
 ld.s c, (ix)                   ; Error
 ld.s c, (ix+127)               ; Error
 ld.s c, (ix-128)               ; Error
 ld.s c, (iy)                   ; Error
 ld.s c, (iy+127)               ; Error
 ld.s c, (iy-128)               ; Error
 ld.s d, (hl)                   ; Error
 ld.s d, (hl+)                  ; Error
 ld.s d, (hl-)                  ; Error
 ld.s d, (hld)                  ; Error
 ld.s d, (hli)                  ; Error
 ld.s d, (ix)                   ; Error
 ld.s d, (ix+127)               ; Error
 ld.s d, (ix-128)               ; Error
 ld.s d, (iy)                   ; Error
 ld.s d, (iy+127)               ; Error
 ld.s d, (iy-128)               ; Error
 ld.s de, (hl)                  ; Error
 ld.s de, (hl+)                 ; Error
 ld.s de, (ix)                  ; Error
 ld.s de, (ix+127)              ; Error
 ld.s de, (ix-128)              ; Error
 ld.s de, (iy)                  ; Error
 ld.s de, (iy+127)              ; Error
 ld.s de, (iy-128)              ; Error
 ld.s e, (hl)                   ; Error
 ld.s e, (hl+)                  ; Error
 ld.s e, (hl-)                  ; Error
 ld.s e, (hld)                  ; Error
 ld.s e, (hli)                  ; Error
 ld.s e, (ix)                   ; Error
 ld.s e, (ix+127)               ; Error
 ld.s e, (ix-128)               ; Error
 ld.s e, (iy)                   ; Error
 ld.s e, (iy+127)               ; Error
 ld.s e, (iy-128)               ; Error
 ld.s h, (hl)                   ; Error
 ld.s h, (hl+)                  ; Error
 ld.s h, (hl-)                  ; Error
 ld.s h, (hld)                  ; Error
 ld.s h, (hli)                  ; Error
 ld.s h, (ix)                   ; Error
 ld.s h, (ix+127)               ; Error
 ld.s h, (ix-128)               ; Error
 ld.s h, (iy)                   ; Error
 ld.s h, (iy+127)               ; Error
 ld.s h, (iy-128)               ; Error
 ld.s hl, (hl)                  ; Error
 ld.s hl, (hl+)                 ; Error
 ld.s hl, (ix)                  ; Error
 ld.s hl, (ix+127)              ; Error
 ld.s hl, (ix-128)              ; Error
 ld.s hl, (iy)                  ; Error
 ld.s hl, (iy+127)              ; Error
 ld.s hl, (iy-128)              ; Error
 ld.s ix, (hl)                  ; Error
 ld.s ix, (hl+)                 ; Error
 ld.s ix, (ix)                  ; Error
 ld.s ix, (ix+127)              ; Error
 ld.s ix, (ix-128)              ; Error
 ld.s ix, (iy)                  ; Error
 ld.s ix, (iy+127)              ; Error
 ld.s ix, (iy-128)              ; Error
 ld.s iy, (hl)                  ; Error
 ld.s iy, (hl+)                 ; Error
 ld.s iy, (ix)                  ; Error
 ld.s iy, (ix+127)              ; Error
 ld.s iy, (ix-128)              ; Error
 ld.s iy, (iy)                  ; Error
 ld.s iy, (iy+127)              ; Error
 ld.s iy, (iy-128)              ; Error
 ld.s l, (hl)                   ; Error
 ld.s l, (hl+)                  ; Error
 ld.s l, (hl-)                  ; Error
 ld.s l, (hld)                  ; Error
 ld.s l, (hli)                  ; Error
 ld.s l, (ix)                   ; Error
 ld.s l, (ix+127)               ; Error
 ld.s l, (ix-128)               ; Error
 ld.s l, (iy)                   ; Error
 ld.s l, (iy+127)               ; Error
 ld.s l, (iy-128)               ; Error
 ld.s sp, hl                    ; Error
 ld.s sp, ix                    ; Error
 ld.s sp, iy                    ; Error
 ld.sis (-32768), bc            ; Error
 ld.sis (-32768), de            ; Error
 ld.sis (-32768), hl            ; Error
 ld.sis (-32768), ix            ; Error
 ld.sis (-32768), iy            ; Error
 ld.sis (-32768), sp            ; Error
 ld.sis (32767), bc             ; Error
 ld.sis (32767), de             ; Error
 ld.sis (32767), hl             ; Error
 ld.sis (32767), ix             ; Error
 ld.sis (32767), iy             ; Error
 ld.sis (32767), sp             ; Error
 ld.sis (65535), bc             ; Error
 ld.sis (65535), de             ; Error
 ld.sis (65535), hl             ; Error
 ld.sis (65535), ix             ; Error
 ld.sis (65535), iy             ; Error
 ld.sis (65535), sp             ; Error
 ld.sis bc, (-32768)            ; Error
 ld.sis bc, (32767)             ; Error
 ld.sis bc, (65535)             ; Error
 ld.sis bc, -32768              ; Error
 ld.sis bc, 32767               ; Error
 ld.sis bc, 65535               ; Error
 ld.sis de, (-32768)            ; Error
 ld.sis de, (32767)             ; Error
 ld.sis de, (65535)             ; Error
 ld.sis de, -32768              ; Error
 ld.sis de, 32767               ; Error
 ld.sis de, 65535               ; Error
 ld.sis hl, (-32768)            ; Error
 ld.sis hl, (32767)             ; Error
 ld.sis hl, (65535)             ; Error
 ld.sis hl, -32768              ; Error
 ld.sis hl, 32767               ; Error
 ld.sis hl, 65535               ; Error
 ld.sis ix, (-32768)            ; Error
 ld.sis ix, (32767)             ; Error
 ld.sis ix, (65535)             ; Error
 ld.sis ix, -32768              ; Error
 ld.sis ix, 32767               ; Error
 ld.sis ix, 65535               ; Error
 ld.sis iy, (-32768)            ; Error
 ld.sis iy, (32767)             ; Error
 ld.sis iy, (65535)             ; Error
 ld.sis iy, -32768              ; Error
 ld.sis iy, 32767               ; Error
 ld.sis iy, 65535               ; Error
 ld.sis sp, (-32768)            ; Error
 ld.sis sp, (32767)             ; Error
 ld.sis sp, (65535)             ; Error
 ld.sis sp, -32768              ; Error
 ld.sis sp, 32767               ; Error
 ld.sis sp, 65535               ; Error
 ldd.l                          ; Error
 ldd.l (bc), a                  ; Error
 ldd.l (de), a                  ; Error
 ldd.l (hl), -128               ; Error
 ldd.l (hl), 127                ; Error
 ldd.l (hl), 255                ; Error
 ldd.l (hl), a                  ; Error
 ldd.l (hl), b                  ; Error
 ldd.l (hl), c                  ; Error
 ldd.l (hl), d                  ; Error
 ldd.l (hl), e                  ; Error
 ldd.l (hl), h                  ; Error
 ldd.l (hl), l                  ; Error
 ldd.l a, (bc)                  ; Error
 ldd.l a, (de)                  ; Error
 ldd.l a, (hl)                  ; Error
 ldd.l b, (hl)                  ; Error
 ldd.l c, (hl)                  ; Error
 ldd.l d, (hl)                  ; Error
 ldd.l e, (hl)                  ; Error
 ldd.l h, (hl)                  ; Error
 ldd.l l, (hl)                  ; Error
 ldd.s                          ; Error
 ldd.s (bc), a                  ; Error
 ldd.s (de), a                  ; Error
 ldd.s (hl), -128               ; Error
 ldd.s (hl), 127                ; Error
 ldd.s (hl), 255                ; Error
 ldd.s (hl), a                  ; Error
 ldd.s (hl), b                  ; Error
 ldd.s (hl), c                  ; Error
 ldd.s (hl), d                  ; Error
 ldd.s (hl), e                  ; Error
 ldd.s (hl), h                  ; Error
 ldd.s (hl), l                  ; Error
 ldd.s a, (bc)                  ; Error
 ldd.s a, (de)                  ; Error
 ldd.s a, (hl)                  ; Error
 ldd.s b, (hl)                  ; Error
 ldd.s c, (hl)                  ; Error
 ldd.s d, (hl)                  ; Error
 ldd.s e, (hl)                  ; Error
 ldd.s h, (hl)                  ; Error
 ldd.s l, (hl)                  ; Error
 lddr.l                         ; Error
 lddr.s                         ; Error
 lddrx                          ; Error
 lddsr                          ; Error
 lddx                           ; Error
 ldh (0), a                     ; Error
 ldh (127), a                   ; Error
 ldh (255), a                   ; Error
 ldh (c), a                     ; Error
 ldh a, (0)                     ; Error
 ldh a, (127)                   ; Error
 ldh a, (255)                   ; Error
 ldh a, (c)                     ; Error
 ldhi -128                      ; Error
 ldhi 127                       ; Error
 ldhi 255                       ; Error
 ldhl sp, -128                  ; Error
 ldhl sp, 127                   ; Error
 ldi (hl), hl                   ; Error
 ldi hl, (hl)                   ; Error
 ldi.l                          ; Error
 ldi.l (bc), a                  ; Error
 ldi.l (de), a                  ; Error
 ldi.l (hl), -128               ; Error
 ldi.l (hl), 127                ; Error
 ldi.l (hl), 255                ; Error
 ldi.l (hl), a                  ; Error
 ldi.l (hl), b                  ; Error
 ldi.l (hl), bc                 ; Error
 ldi.l (hl), c                  ; Error
 ldi.l (hl), d                  ; Error
 ldi.l (hl), de                 ; Error
 ldi.l (hl), e                  ; Error
 ldi.l (hl), h                  ; Error
 ldi.l (hl), hl                 ; Error
 ldi.l (hl), ix                 ; Error
 ldi.l (hl), iy                 ; Error
 ldi.l (hl), l                  ; Error
 ldi.l a, (bc)                  ; Error
 ldi.l a, (de)                  ; Error
 ldi.l a, (hl)                  ; Error
 ldi.l b, (hl)                  ; Error
 ldi.l bc, (hl)                 ; Error
 ldi.l c, (hl)                  ; Error
 ldi.l d, (hl)                  ; Error
 ldi.l de, (hl)                 ; Error
 ldi.l e, (hl)                  ; Error
 ldi.l h, (hl)                  ; Error
 ldi.l hl, (hl)                 ; Error
 ldi.l ix, (hl)                 ; Error
 ldi.l iy, (hl)                 ; Error
 ldi.l l, (hl)                  ; Error
 ldi.s                          ; Error
 ldi.s (bc), a                  ; Error
 ldi.s (de), a                  ; Error
 ldi.s (hl), -128               ; Error
 ldi.s (hl), 127                ; Error
 ldi.s (hl), 255                ; Error
 ldi.s (hl), a                  ; Error
 ldi.s (hl), b                  ; Error
 ldi.s (hl), bc                 ; Error
 ldi.s (hl), c                  ; Error
 ldi.s (hl), d                  ; Error
 ldi.s (hl), de                 ; Error
 ldi.s (hl), e                  ; Error
 ldi.s (hl), h                  ; Error
 ldi.s (hl), hl                 ; Error
 ldi.s (hl), ix                 ; Error
 ldi.s (hl), iy                 ; Error
 ldi.s (hl), l                  ; Error
 ldi.s a, (bc)                  ; Error
 ldi.s a, (de)                  ; Error
 ldi.s a, (hl)                  ; Error
 ldi.s b, (hl)                  ; Error
 ldi.s bc, (hl)                 ; Error
 ldi.s c, (hl)                  ; Error
 ldi.s d, (hl)                  ; Error
 ldi.s de, (hl)                 ; Error
 ldi.s e, (hl)                  ; Error
 ldi.s h, (hl)                  ; Error
 ldi.s hl, (hl)                 ; Error
 ldi.s ix, (hl)                 ; Error
 ldi.s iy, (hl)                 ; Error
 ldi.s l, (hl)                  ; Error
 ldir.l                         ; Error
 ldir.s                         ; Error
 ldirx                          ; Error
 ldisr                          ; Error
 ldix                           ; Error
 ldpirx                         ; Error
 ldrx                           ; Error
 ldsi -128                      ; Error
 ldsi 127                       ; Error
 ldsi 255                       ; Error
 ldws                           ; Error
 lea bc, ix                     ; Error
 lea bc, ix+127                 ; Error
 lea bc, ix-128                 ; Error
 lea bc, iy                     ; Error
 lea bc, iy+127                 ; Error
 lea bc, iy-128                 ; Error
 lea de, ix                     ; Error
 lea de, ix+127                 ; Error
 lea de, ix-128                 ; Error
 lea de, iy                     ; Error
 lea de, iy+127                 ; Error
 lea de, iy-128                 ; Error
 lea hl, ix                     ; Error
 lea hl, ix+127                 ; Error
 lea hl, ix-128                 ; Error
 lea hl, iy                     ; Error
 lea hl, iy+127                 ; Error
 lea hl, iy-128                 ; Error
 lea ix, ix                     ; Error
 lea ix, ix+127                 ; Error
 lea ix, ix-128                 ; Error
 lea ix, iy                     ; Error
 lea ix, iy+127                 ; Error
 lea ix, iy-128                 ; Error
 lea iy, ix                     ; Error
 lea iy, ix+127                 ; Error
 lea iy, ix-128                 ; Error
 lea iy, iy                     ; Error
 lea iy, iy+127                 ; Error
 lea iy, iy-128                 ; Error
 lea.l bc, ix                   ; Error
 lea.l bc, ix+127               ; Error
 lea.l bc, ix-128               ; Error
 lea.l bc, iy                   ; Error
 lea.l bc, iy+127               ; Error
 lea.l bc, iy-128               ; Error
 lea.l de, ix                   ; Error
 lea.l de, ix+127               ; Error
 lea.l de, ix-128               ; Error
 lea.l de, iy                   ; Error
 lea.l de, iy+127               ; Error
 lea.l de, iy-128               ; Error
 lea.l hl, ix                   ; Error
 lea.l hl, ix+127               ; Error
 lea.l hl, ix-128               ; Error
 lea.l hl, iy                   ; Error
 lea.l hl, iy+127               ; Error
 lea.l hl, iy-128               ; Error
 lea.l ix, ix                   ; Error
 lea.l ix, ix+127               ; Error
 lea.l ix, ix-128               ; Error
 lea.l ix, iy                   ; Error
 lea.l ix, iy+127               ; Error
 lea.l ix, iy-128               ; Error
 lea.l iy, ix                   ; Error
 lea.l iy, ix+127               ; Error
 lea.l iy, ix-128               ; Error
 lea.l iy, iy                   ; Error
 lea.l iy, iy+127               ; Error
 lea.l iy, iy-128               ; Error
 lea.s bc, ix                   ; Error
 lea.s bc, ix+127               ; Error
 lea.s bc, ix-128               ; Error
 lea.s bc, iy                   ; Error
 lea.s bc, iy+127               ; Error
 lea.s bc, iy-128               ; Error
 lea.s de, ix                   ; Error
 lea.s de, ix+127               ; Error
 lea.s de, ix-128               ; Error
 lea.s de, iy                   ; Error
 lea.s de, iy+127               ; Error
 lea.s de, iy-128               ; Error
 lea.s hl, ix                   ; Error
 lea.s hl, ix+127               ; Error
 lea.s hl, ix-128               ; Error
 lea.s hl, iy                   ; Error
 lea.s hl, iy+127               ; Error
 lea.s hl, iy-128               ; Error
 lea.s ix, ix                   ; Error
 lea.s ix, ix+127               ; Error
 lea.s ix, ix-128               ; Error
 lea.s ix, iy                   ; Error
 lea.s ix, iy+127               ; Error
 lea.s ix, iy-128               ; Error
 lea.s iy, ix                   ; Error
 lea.s iy, ix+127               ; Error
 lea.s iy, ix-128               ; Error
 lea.s iy, iy                   ; Error
 lea.s iy, iy+127               ; Error
 lea.s iy, iy-128               ; Error
 lhlde                          ; Error
 lhlx                           ; Error
 lirx                           ; Error
 lprx                           ; Error
 lsddr                          ; Error
 lsdr                           ; Error
 lsidr                          ; Error
 lsir                           ; Error
 mirr a                         ; Error
 mirror a                       ; Error
 mlt bc                         ; Error
 mlt de                         ; Error
 mlt hl                         ; Error
 mlt sp                         ; Error
 mlt.l sp                       ; Error
 mlt.s sp                       ; Error
 mmu -1, -128                   ; Error
 mmu -1, 127                    ; Error
 mmu -1, 255                    ; Error
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
 mmu 8, 127                     ; Error
 mmu 8, 255                     ; Error
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
 mul d, e                       ; Error
 mul de                         ; Error
 nextreg -128, -128             ; Error
 nextreg -128, a                ; Error
 nextreg 127, 127               ; Error
 nextreg 127, a                 ; Error
 nextreg 255, 255               ; Error
 nextreg 255, a                 ; Error
 nreg -128, -128                ; Error
 nreg -128, a                   ; Error
 nreg 127, 127                  ; Error
 nreg 127, a                    ; Error
 nreg 255, 255                  ; Error
 nreg 255, a                    ; Error
 or a, ixh                      ; Error
 or a, ixl                      ; Error
 or a, iyh                      ; Error
 or a, iyl                      ; Error
 or ixh                         ; Error
 or ixl                         ; Error
 or iyh                         ; Error
 or iyl                         ; Error
 or.l (hl)                      ; Error
 or.l (hl+)                     ; Error
 or.l (hl-)                     ; Error
 or.l (ix)                      ; Error
 or.l (ix+127)                  ; Error
 or.l (ix-128)                  ; Error
 or.l (iy)                      ; Error
 or.l (iy+127)                  ; Error
 or.l (iy-128)                  ; Error
 or.l a, (hl)                   ; Error
 or.l a, (hl+)                  ; Error
 or.l a, (hl-)                  ; Error
 or.l a, (ix)                   ; Error
 or.l a, (ix+127)               ; Error
 or.l a, (ix-128)               ; Error
 or.l a, (iy)                   ; Error
 or.l a, (iy+127)               ; Error
 or.l a, (iy-128)               ; Error
 or.s (hl)                      ; Error
 or.s (hl+)                     ; Error
 or.s (hl-)                     ; Error
 or.s (ix)                      ; Error
 or.s (ix+127)                  ; Error
 or.s (ix-128)                  ; Error
 or.s (iy)                      ; Error
 or.s (iy+127)                  ; Error
 or.s (iy-128)                  ; Error
 or.s a, (hl)                   ; Error
 or.s a, (hl+)                  ; Error
 or.s a, (hl-)                  ; Error
 or.s a, (ix)                   ; Error
 or.s a, (ix+127)               ; Error
 or.s a, (ix-128)               ; Error
 or.s a, (iy)                   ; Error
 or.s a, (iy+127)               ; Error
 or.s a, (iy-128)               ; Error
 otd2r                          ; Error
 otd2r.l                        ; Error
 otd2r.s                        ; Error
 otdm                           ; Error
 otdm.l                         ; Error
 otdm.s                         ; Error
 otdmr                          ; Error
 otdmr.l                        ; Error
 otdmr.s                        ; Error
 otdr                           ; Error
 otdr.l                         ; Error
 otdr.s                         ; Error
 otdrx                          ; Error
 otdrx.l                        ; Error
 otdrx.s                        ; Error
 oti2r                          ; Error
 oti2r.l                        ; Error
 oti2r.s                        ; Error
 otib                           ; Error
 otim                           ; Error
 otim.l                         ; Error
 otim.s                         ; Error
 otimr                          ; Error
 otimr.l                        ; Error
 otimr.s                        ; Error
 otir                           ; Error
 otir.l                         ; Error
 otir.s                         ; Error
 otirx                          ; Error
 otirx.l                        ; Error
 otirx.s                        ; Error
 out (-128), a                  ; Error
 out (127), a                   ; Error
 out (255), a                   ; Error
 out (bc), -1                   ; Error
 out (bc), 0                    ; Error
 out (bc), 1                    ; Error
 out (bc), a                    ; Error
 out (bc), b                    ; Error
 out (bc), c                    ; Error
 out (bc), d                    ; Error
 out (bc), e                    ; Error
 out (bc), f                    ; Error
 out (bc), h                    ; Error
 out (bc), l                    ; Error
 out (c), -1                    ; Error
 out (c), 0                     ; Error
 out (c), 1                     ; Error
 out (c), a                     ; Error
 out (c), b                     ; Error
 out (c), c                     ; Error
 out (c), d                     ; Error
 out (c), e                     ; Error
 out (c), f                     ; Error
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
 out0 (-128), f                 ; Error
 out0 (-128), h                 ; Error
 out0 (-128), l                 ; Error
 out0 (127), a                  ; Error
 out0 (127), b                  ; Error
 out0 (127), c                  ; Error
 out0 (127), d                  ; Error
 out0 (127), e                  ; Error
 out0 (127), f                  ; Error
 out0 (127), h                  ; Error
 out0 (127), l                  ; Error
 out0 (255), a                  ; Error
 out0 (255), b                  ; Error
 out0 (255), c                  ; Error
 out0 (255), d                  ; Error
 out0 (255), e                  ; Error
 out0 (255), f                  ; Error
 out0 (255), h                  ; Error
 out0 (255), l                  ; Error
 outd                           ; Error
 outd.l                         ; Error
 outd.s                         ; Error
 outd2                          ; Error
 outd2.l                        ; Error
 outd2.s                        ; Error
 outi                           ; Error
 outi.l                         ; Error
 outi.s                         ; Error
 outi2                          ; Error
 outi2.l                        ; Error
 outi2.s                        ; Error
 outinb                         ; Error
 ovrst8                         ; Error
 pea ix                         ; Error
 pea ix+127                     ; Error
 pea ix-128                     ; Error
 pea iy                         ; Error
 pea iy+127                     ; Error
 pea iy-128                     ; Error
 pea.l ix                       ; Error
 pea.l ix+127                   ; Error
 pea.l ix-128                   ; Error
 pea.l iy                       ; Error
 pea.l iy+127                   ; Error
 pea.l iy-128                   ; Error
 pea.s ix                       ; Error
 pea.s ix+127                   ; Error
 pea.s ix-128                   ; Error
 pea.s iy                       ; Error
 pea.s iy+127                   ; Error
 pea.s iy-128                   ; Error
 pixelad                        ; Error
 pixeldn                        ; Error
 pop su                         ; Error
 pop.l af                       ; Error
 pop.l bc                       ; Error
 pop.l de                       ; Error
 pop.l hl                       ; Error
 pop.l ix                       ; Error
 pop.l iy                       ; Error
 pop.s af                       ; Error
 pop.s bc                       ; Error
 pop.s de                       ; Error
 pop.s hl                       ; Error
 pop.s ix                       ; Error
 pop.s iy                       ; Error
 push -32768                    ; Error
 push 32767                     ; Error
 push 65535                     ; Error
 push su                        ; Error
 push.l af                      ; Error
 push.l bc                      ; Error
 push.l de                      ; Error
 push.l hl                      ; Error
 push.l ix                      ; Error
 push.l iy                      ; Error
 push.s af                      ; Error
 push.s bc                      ; Error
 push.s de                      ; Error
 push.s hl                      ; Error
 push.s ix                      ; Error
 push.s iy                      ; Error
 pxad                           ; Error
 pxdn                           ; Error
 rdmode                         ; Error
 res -1, (hl)                   ; Error
 res -1, (ix)                   ; Error
 res -1, (ix), a                ; Error
 res -1, (ix), b                ; Error
 res -1, (ix), c                ; Error
 res -1, (ix), d                ; Error
 res -1, (ix), e                ; Error
 res -1, (ix), h                ; Error
 res -1, (ix), l                ; Error
 res -1, (ix+127)               ; Error
 res -1, (ix+127), a            ; Error
 res -1, (ix+127), b            ; Error
 res -1, (ix+127), c            ; Error
 res -1, (ix+127), d            ; Error
 res -1, (ix+127), e            ; Error
 res -1, (ix+127), h            ; Error
 res -1, (ix+127), l            ; Error
 res -1, (ix-128)               ; Error
 res -1, (ix-128), a            ; Error
 res -1, (ix-128), b            ; Error
 res -1, (ix-128), c            ; Error
 res -1, (ix-128), d            ; Error
 res -1, (ix-128), e            ; Error
 res -1, (ix-128), h            ; Error
 res -1, (ix-128), l            ; Error
 res -1, (iy)                   ; Error
 res -1, (iy), a                ; Error
 res -1, (iy), b                ; Error
 res -1, (iy), c                ; Error
 res -1, (iy), d                ; Error
 res -1, (iy), e                ; Error
 res -1, (iy), h                ; Error
 res -1, (iy), l                ; Error
 res -1, (iy+127)               ; Error
 res -1, (iy+127), a            ; Error
 res -1, (iy+127), b            ; Error
 res -1, (iy+127), c            ; Error
 res -1, (iy+127), d            ; Error
 res -1, (iy+127), e            ; Error
 res -1, (iy+127), h            ; Error
 res -1, (iy+127), l            ; Error
 res -1, (iy-128)               ; Error
 res -1, (iy-128), a            ; Error
 res -1, (iy-128), b            ; Error
 res -1, (iy-128), c            ; Error
 res -1, (iy-128), d            ; Error
 res -1, (iy-128), e            ; Error
 res -1, (iy-128), h            ; Error
 res -1, (iy-128), l            ; Error
 res -1, a                      ; Error
 res -1, a'                     ; Error
 res -1, b                      ; Error
 res -1, b'                     ; Error
 res -1, c                      ; Error
 res -1, c'                     ; Error
 res -1, d                      ; Error
 res -1, d'                     ; Error
 res -1, e                      ; Error
 res -1, e'                     ; Error
 res -1, h                      ; Error
 res -1, h'                     ; Error
 res -1, l                      ; Error
 res -1, l'                     ; Error
 res 0, (ix), a                 ; Error
 res 0, (ix), b                 ; Error
 res 0, (ix), c                 ; Error
 res 0, (ix), d                 ; Error
 res 0, (ix), e                 ; Error
 res 0, (ix), h                 ; Error
 res 0, (ix), l                 ; Error
 res 0, (ix+127), a             ; Error
 res 0, (ix+127), b             ; Error
 res 0, (ix+127), c             ; Error
 res 0, (ix+127), d             ; Error
 res 0, (ix+127), e             ; Error
 res 0, (ix+127), h             ; Error
 res 0, (ix+127), l             ; Error
 res 0, (ix-128), a             ; Error
 res 0, (ix-128), b             ; Error
 res 0, (ix-128), c             ; Error
 res 0, (ix-128), d             ; Error
 res 0, (ix-128), e             ; Error
 res 0, (ix-128), h             ; Error
 res 0, (ix-128), l             ; Error
 res 0, (iy), a                 ; Error
 res 0, (iy), b                 ; Error
 res 0, (iy), c                 ; Error
 res 0, (iy), d                 ; Error
 res 0, (iy), e                 ; Error
 res 0, (iy), h                 ; Error
 res 0, (iy), l                 ; Error
 res 0, (iy+127), a             ; Error
 res 0, (iy+127), b             ; Error
 res 0, (iy+127), c             ; Error
 res 0, (iy+127), d             ; Error
 res 0, (iy+127), e             ; Error
 res 0, (iy+127), h             ; Error
 res 0, (iy+127), l             ; Error
 res 0, (iy-128), a             ; Error
 res 0, (iy-128), b             ; Error
 res 0, (iy-128), c             ; Error
 res 0, (iy-128), d             ; Error
 res 0, (iy-128), e             ; Error
 res 0, (iy-128), h             ; Error
 res 0, (iy-128), l             ; Error
 res 1, (ix), a                 ; Error
 res 1, (ix), b                 ; Error
 res 1, (ix), c                 ; Error
 res 1, (ix), d                 ; Error
 res 1, (ix), e                 ; Error
 res 1, (ix), h                 ; Error
 res 1, (ix), l                 ; Error
 res 1, (ix+127), a             ; Error
 res 1, (ix+127), b             ; Error
 res 1, (ix+127), c             ; Error
 res 1, (ix+127), d             ; Error
 res 1, (ix+127), e             ; Error
 res 1, (ix+127), h             ; Error
 res 1, (ix+127), l             ; Error
 res 1, (ix-128), a             ; Error
 res 1, (ix-128), b             ; Error
 res 1, (ix-128), c             ; Error
 res 1, (ix-128), d             ; Error
 res 1, (ix-128), e             ; Error
 res 1, (ix-128), h             ; Error
 res 1, (ix-128), l             ; Error
 res 1, (iy), a                 ; Error
 res 1, (iy), b                 ; Error
 res 1, (iy), c                 ; Error
 res 1, (iy), d                 ; Error
 res 1, (iy), e                 ; Error
 res 1, (iy), h                 ; Error
 res 1, (iy), l                 ; Error
 res 1, (iy+127), a             ; Error
 res 1, (iy+127), b             ; Error
 res 1, (iy+127), c             ; Error
 res 1, (iy+127), d             ; Error
 res 1, (iy+127), e             ; Error
 res 1, (iy+127), h             ; Error
 res 1, (iy+127), l             ; Error
 res 1, (iy-128), a             ; Error
 res 1, (iy-128), b             ; Error
 res 1, (iy-128), c             ; Error
 res 1, (iy-128), d             ; Error
 res 1, (iy-128), e             ; Error
 res 1, (iy-128), h             ; Error
 res 1, (iy-128), l             ; Error
 res 2, (ix), a                 ; Error
 res 2, (ix), b                 ; Error
 res 2, (ix), c                 ; Error
 res 2, (ix), d                 ; Error
 res 2, (ix), e                 ; Error
 res 2, (ix), h                 ; Error
 res 2, (ix), l                 ; Error
 res 2, (ix+127), a             ; Error
 res 2, (ix+127), b             ; Error
 res 2, (ix+127), c             ; Error
 res 2, (ix+127), d             ; Error
 res 2, (ix+127), e             ; Error
 res 2, (ix+127), h             ; Error
 res 2, (ix+127), l             ; Error
 res 2, (ix-128), a             ; Error
 res 2, (ix-128), b             ; Error
 res 2, (ix-128), c             ; Error
 res 2, (ix-128), d             ; Error
 res 2, (ix-128), e             ; Error
 res 2, (ix-128), h             ; Error
 res 2, (ix-128), l             ; Error
 res 2, (iy), a                 ; Error
 res 2, (iy), b                 ; Error
 res 2, (iy), c                 ; Error
 res 2, (iy), d                 ; Error
 res 2, (iy), e                 ; Error
 res 2, (iy), h                 ; Error
 res 2, (iy), l                 ; Error
 res 2, (iy+127), a             ; Error
 res 2, (iy+127), b             ; Error
 res 2, (iy+127), c             ; Error
 res 2, (iy+127), d             ; Error
 res 2, (iy+127), e             ; Error
 res 2, (iy+127), h             ; Error
 res 2, (iy+127), l             ; Error
 res 2, (iy-128), a             ; Error
 res 2, (iy-128), b             ; Error
 res 2, (iy-128), c             ; Error
 res 2, (iy-128), d             ; Error
 res 2, (iy-128), e             ; Error
 res 2, (iy-128), h             ; Error
 res 2, (iy-128), l             ; Error
 res 3, (ix), a                 ; Error
 res 3, (ix), b                 ; Error
 res 3, (ix), c                 ; Error
 res 3, (ix), d                 ; Error
 res 3, (ix), e                 ; Error
 res 3, (ix), h                 ; Error
 res 3, (ix), l                 ; Error
 res 3, (ix+127), a             ; Error
 res 3, (ix+127), b             ; Error
 res 3, (ix+127), c             ; Error
 res 3, (ix+127), d             ; Error
 res 3, (ix+127), e             ; Error
 res 3, (ix+127), h             ; Error
 res 3, (ix+127), l             ; Error
 res 3, (ix-128), a             ; Error
 res 3, (ix-128), b             ; Error
 res 3, (ix-128), c             ; Error
 res 3, (ix-128), d             ; Error
 res 3, (ix-128), e             ; Error
 res 3, (ix-128), h             ; Error
 res 3, (ix-128), l             ; Error
 res 3, (iy), a                 ; Error
 res 3, (iy), b                 ; Error
 res 3, (iy), c                 ; Error
 res 3, (iy), d                 ; Error
 res 3, (iy), e                 ; Error
 res 3, (iy), h                 ; Error
 res 3, (iy), l                 ; Error
 res 3, (iy+127), a             ; Error
 res 3, (iy+127), b             ; Error
 res 3, (iy+127), c             ; Error
 res 3, (iy+127), d             ; Error
 res 3, (iy+127), e             ; Error
 res 3, (iy+127), h             ; Error
 res 3, (iy+127), l             ; Error
 res 3, (iy-128), a             ; Error
 res 3, (iy-128), b             ; Error
 res 3, (iy-128), c             ; Error
 res 3, (iy-128), d             ; Error
 res 3, (iy-128), e             ; Error
 res 3, (iy-128), h             ; Error
 res 3, (iy-128), l             ; Error
 res 4, (ix), a                 ; Error
 res 4, (ix), b                 ; Error
 res 4, (ix), c                 ; Error
 res 4, (ix), d                 ; Error
 res 4, (ix), e                 ; Error
 res 4, (ix), h                 ; Error
 res 4, (ix), l                 ; Error
 res 4, (ix+127), a             ; Error
 res 4, (ix+127), b             ; Error
 res 4, (ix+127), c             ; Error
 res 4, (ix+127), d             ; Error
 res 4, (ix+127), e             ; Error
 res 4, (ix+127), h             ; Error
 res 4, (ix+127), l             ; Error
 res 4, (ix-128), a             ; Error
 res 4, (ix-128), b             ; Error
 res 4, (ix-128), c             ; Error
 res 4, (ix-128), d             ; Error
 res 4, (ix-128), e             ; Error
 res 4, (ix-128), h             ; Error
 res 4, (ix-128), l             ; Error
 res 4, (iy), a                 ; Error
 res 4, (iy), b                 ; Error
 res 4, (iy), c                 ; Error
 res 4, (iy), d                 ; Error
 res 4, (iy), e                 ; Error
 res 4, (iy), h                 ; Error
 res 4, (iy), l                 ; Error
 res 4, (iy+127), a             ; Error
 res 4, (iy+127), b             ; Error
 res 4, (iy+127), c             ; Error
 res 4, (iy+127), d             ; Error
 res 4, (iy+127), e             ; Error
 res 4, (iy+127), h             ; Error
 res 4, (iy+127), l             ; Error
 res 4, (iy-128), a             ; Error
 res 4, (iy-128), b             ; Error
 res 4, (iy-128), c             ; Error
 res 4, (iy-128), d             ; Error
 res 4, (iy-128), e             ; Error
 res 4, (iy-128), h             ; Error
 res 4, (iy-128), l             ; Error
 res 5, (ix), a                 ; Error
 res 5, (ix), b                 ; Error
 res 5, (ix), c                 ; Error
 res 5, (ix), d                 ; Error
 res 5, (ix), e                 ; Error
 res 5, (ix), h                 ; Error
 res 5, (ix), l                 ; Error
 res 5, (ix+127), a             ; Error
 res 5, (ix+127), b             ; Error
 res 5, (ix+127), c             ; Error
 res 5, (ix+127), d             ; Error
 res 5, (ix+127), e             ; Error
 res 5, (ix+127), h             ; Error
 res 5, (ix+127), l             ; Error
 res 5, (ix-128), a             ; Error
 res 5, (ix-128), b             ; Error
 res 5, (ix-128), c             ; Error
 res 5, (ix-128), d             ; Error
 res 5, (ix-128), e             ; Error
 res 5, (ix-128), h             ; Error
 res 5, (ix-128), l             ; Error
 res 5, (iy), a                 ; Error
 res 5, (iy), b                 ; Error
 res 5, (iy), c                 ; Error
 res 5, (iy), d                 ; Error
 res 5, (iy), e                 ; Error
 res 5, (iy), h                 ; Error
 res 5, (iy), l                 ; Error
 res 5, (iy+127), a             ; Error
 res 5, (iy+127), b             ; Error
 res 5, (iy+127), c             ; Error
 res 5, (iy+127), d             ; Error
 res 5, (iy+127), e             ; Error
 res 5, (iy+127), h             ; Error
 res 5, (iy+127), l             ; Error
 res 5, (iy-128), a             ; Error
 res 5, (iy-128), b             ; Error
 res 5, (iy-128), c             ; Error
 res 5, (iy-128), d             ; Error
 res 5, (iy-128), e             ; Error
 res 5, (iy-128), h             ; Error
 res 5, (iy-128), l             ; Error
 res 6, (ix), a                 ; Error
 res 6, (ix), b                 ; Error
 res 6, (ix), c                 ; Error
 res 6, (ix), d                 ; Error
 res 6, (ix), e                 ; Error
 res 6, (ix), h                 ; Error
 res 6, (ix), l                 ; Error
 res 6, (ix+127), a             ; Error
 res 6, (ix+127), b             ; Error
 res 6, (ix+127), c             ; Error
 res 6, (ix+127), d             ; Error
 res 6, (ix+127), e             ; Error
 res 6, (ix+127), h             ; Error
 res 6, (ix+127), l             ; Error
 res 6, (ix-128), a             ; Error
 res 6, (ix-128), b             ; Error
 res 6, (ix-128), c             ; Error
 res 6, (ix-128), d             ; Error
 res 6, (ix-128), e             ; Error
 res 6, (ix-128), h             ; Error
 res 6, (ix-128), l             ; Error
 res 6, (iy), a                 ; Error
 res 6, (iy), b                 ; Error
 res 6, (iy), c                 ; Error
 res 6, (iy), d                 ; Error
 res 6, (iy), e                 ; Error
 res 6, (iy), h                 ; Error
 res 6, (iy), l                 ; Error
 res 6, (iy+127), a             ; Error
 res 6, (iy+127), b             ; Error
 res 6, (iy+127), c             ; Error
 res 6, (iy+127), d             ; Error
 res 6, (iy+127), e             ; Error
 res 6, (iy+127), h             ; Error
 res 6, (iy+127), l             ; Error
 res 6, (iy-128), a             ; Error
 res 6, (iy-128), b             ; Error
 res 6, (iy-128), c             ; Error
 res 6, (iy-128), d             ; Error
 res 6, (iy-128), e             ; Error
 res 6, (iy-128), h             ; Error
 res 6, (iy-128), l             ; Error
 res 7, (ix), a                 ; Error
 res 7, (ix), b                 ; Error
 res 7, (ix), c                 ; Error
 res 7, (ix), d                 ; Error
 res 7, (ix), e                 ; Error
 res 7, (ix), h                 ; Error
 res 7, (ix), l                 ; Error
 res 7, (ix+127), a             ; Error
 res 7, (ix+127), b             ; Error
 res 7, (ix+127), c             ; Error
 res 7, (ix+127), d             ; Error
 res 7, (ix+127), e             ; Error
 res 7, (ix+127), h             ; Error
 res 7, (ix+127), l             ; Error
 res 7, (ix-128), a             ; Error
 res 7, (ix-128), b             ; Error
 res 7, (ix-128), c             ; Error
 res 7, (ix-128), d             ; Error
 res 7, (ix-128), e             ; Error
 res 7, (ix-128), h             ; Error
 res 7, (ix-128), l             ; Error
 res 7, (iy), a                 ; Error
 res 7, (iy), b                 ; Error
 res 7, (iy), c                 ; Error
 res 7, (iy), d                 ; Error
 res 7, (iy), e                 ; Error
 res 7, (iy), h                 ; Error
 res 7, (iy), l                 ; Error
 res 7, (iy+127), a             ; Error
 res 7, (iy+127), b             ; Error
 res 7, (iy+127), c             ; Error
 res 7, (iy+127), d             ; Error
 res 7, (iy+127), e             ; Error
 res 7, (iy+127), h             ; Error
 res 7, (iy+127), l             ; Error
 res 7, (iy-128), a             ; Error
 res 7, (iy-128), b             ; Error
 res 7, (iy-128), c             ; Error
 res 7, (iy-128), d             ; Error
 res 7, (iy-128), e             ; Error
 res 7, (iy-128), h             ; Error
 res 7, (iy-128), l             ; Error
 res 8, (hl)                    ; Error
 res 8, (ix)                    ; Error
 res 8, (ix), a                 ; Error
 res 8, (ix), b                 ; Error
 res 8, (ix), c                 ; Error
 res 8, (ix), d                 ; Error
 res 8, (ix), e                 ; Error
 res 8, (ix), h                 ; Error
 res 8, (ix), l                 ; Error
 res 8, (ix+127)                ; Error
 res 8, (ix+127), a             ; Error
 res 8, (ix+127), b             ; Error
 res 8, (ix+127), c             ; Error
 res 8, (ix+127), d             ; Error
 res 8, (ix+127), e             ; Error
 res 8, (ix+127), h             ; Error
 res 8, (ix+127), l             ; Error
 res 8, (ix-128)                ; Error
 res 8, (ix-128), a             ; Error
 res 8, (ix-128), b             ; Error
 res 8, (ix-128), c             ; Error
 res 8, (ix-128), d             ; Error
 res 8, (ix-128), e             ; Error
 res 8, (ix-128), h             ; Error
 res 8, (ix-128), l             ; Error
 res 8, (iy)                    ; Error
 res 8, (iy), a                 ; Error
 res 8, (iy), b                 ; Error
 res 8, (iy), c                 ; Error
 res 8, (iy), d                 ; Error
 res 8, (iy), e                 ; Error
 res 8, (iy), h                 ; Error
 res 8, (iy), l                 ; Error
 res 8, (iy+127)                ; Error
 res 8, (iy+127), a             ; Error
 res 8, (iy+127), b             ; Error
 res 8, (iy+127), c             ; Error
 res 8, (iy+127), d             ; Error
 res 8, (iy+127), e             ; Error
 res 8, (iy+127), h             ; Error
 res 8, (iy+127), l             ; Error
 res 8, (iy-128)                ; Error
 res 8, (iy-128), a             ; Error
 res 8, (iy-128), b             ; Error
 res 8, (iy-128), c             ; Error
 res 8, (iy-128), d             ; Error
 res 8, (iy-128), e             ; Error
 res 8, (iy-128), h             ; Error
 res 8, (iy-128), l             ; Error
 res 8, a                       ; Error
 res 8, a'                      ; Error
 res 8, b                       ; Error
 res 8, b'                      ; Error
 res 8, c                       ; Error
 res 8, c'                      ; Error
 res 8, d                       ; Error
 res 8, d'                      ; Error
 res 8, e                       ; Error
 res 8, e'                      ; Error
 res 8, h                       ; Error
 res 8, h'                      ; Error
 res 8, l                       ; Error
 res 8, l'                      ; Error
 res.l -1, (hl)                 ; Error
 res.l -1, (ix)                 ; Error
 res.l -1, (ix+127)             ; Error
 res.l -1, (ix-128)             ; Error
 res.l -1, (iy)                 ; Error
 res.l -1, (iy+127)             ; Error
 res.l -1, (iy-128)             ; Error
 res.l 0, (hl)                  ; Error
 res.l 0, (ix)                  ; Error
 res.l 0, (ix+127)              ; Error
 res.l 0, (ix-128)              ; Error
 res.l 0, (iy)                  ; Error
 res.l 0, (iy+127)              ; Error
 res.l 0, (iy-128)              ; Error
 res.l 1, (hl)                  ; Error
 res.l 1, (ix)                  ; Error
 res.l 1, (ix+127)              ; Error
 res.l 1, (ix-128)              ; Error
 res.l 1, (iy)                  ; Error
 res.l 1, (iy+127)              ; Error
 res.l 1, (iy-128)              ; Error
 res.l 2, (hl)                  ; Error
 res.l 2, (ix)                  ; Error
 res.l 2, (ix+127)              ; Error
 res.l 2, (ix-128)              ; Error
 res.l 2, (iy)                  ; Error
 res.l 2, (iy+127)              ; Error
 res.l 2, (iy-128)              ; Error
 res.l 3, (hl)                  ; Error
 res.l 3, (ix)                  ; Error
 res.l 3, (ix+127)              ; Error
 res.l 3, (ix-128)              ; Error
 res.l 3, (iy)                  ; Error
 res.l 3, (iy+127)              ; Error
 res.l 3, (iy-128)              ; Error
 res.l 4, (hl)                  ; Error
 res.l 4, (ix)                  ; Error
 res.l 4, (ix+127)              ; Error
 res.l 4, (ix-128)              ; Error
 res.l 4, (iy)                  ; Error
 res.l 4, (iy+127)              ; Error
 res.l 4, (iy-128)              ; Error
 res.l 5, (hl)                  ; Error
 res.l 5, (ix)                  ; Error
 res.l 5, (ix+127)              ; Error
 res.l 5, (ix-128)              ; Error
 res.l 5, (iy)                  ; Error
 res.l 5, (iy+127)              ; Error
 res.l 5, (iy-128)              ; Error
 res.l 6, (hl)                  ; Error
 res.l 6, (ix)                  ; Error
 res.l 6, (ix+127)              ; Error
 res.l 6, (ix-128)              ; Error
 res.l 6, (iy)                  ; Error
 res.l 6, (iy+127)              ; Error
 res.l 6, (iy-128)              ; Error
 res.l 7, (hl)                  ; Error
 res.l 7, (ix)                  ; Error
 res.l 7, (ix+127)              ; Error
 res.l 7, (ix-128)              ; Error
 res.l 7, (iy)                  ; Error
 res.l 7, (iy+127)              ; Error
 res.l 7, (iy-128)              ; Error
 res.l 8, (hl)                  ; Error
 res.l 8, (ix)                  ; Error
 res.l 8, (ix+127)              ; Error
 res.l 8, (ix-128)              ; Error
 res.l 8, (iy)                  ; Error
 res.l 8, (iy+127)              ; Error
 res.l 8, (iy-128)              ; Error
 res.s -1, (hl)                 ; Error
 res.s -1, (ix)                 ; Error
 res.s -1, (ix+127)             ; Error
 res.s -1, (ix-128)             ; Error
 res.s -1, (iy)                 ; Error
 res.s -1, (iy+127)             ; Error
 res.s -1, (iy-128)             ; Error
 res.s 0, (hl)                  ; Error
 res.s 0, (ix)                  ; Error
 res.s 0, (ix+127)              ; Error
 res.s 0, (ix-128)              ; Error
 res.s 0, (iy)                  ; Error
 res.s 0, (iy+127)              ; Error
 res.s 0, (iy-128)              ; Error
 res.s 1, (hl)                  ; Error
 res.s 1, (ix)                  ; Error
 res.s 1, (ix+127)              ; Error
 res.s 1, (ix-128)              ; Error
 res.s 1, (iy)                  ; Error
 res.s 1, (iy+127)              ; Error
 res.s 1, (iy-128)              ; Error
 res.s 2, (hl)                  ; Error
 res.s 2, (ix)                  ; Error
 res.s 2, (ix+127)              ; Error
 res.s 2, (ix-128)              ; Error
 res.s 2, (iy)                  ; Error
 res.s 2, (iy+127)              ; Error
 res.s 2, (iy-128)              ; Error
 res.s 3, (hl)                  ; Error
 res.s 3, (ix)                  ; Error
 res.s 3, (ix+127)              ; Error
 res.s 3, (ix-128)              ; Error
 res.s 3, (iy)                  ; Error
 res.s 3, (iy+127)              ; Error
 res.s 3, (iy-128)              ; Error
 res.s 4, (hl)                  ; Error
 res.s 4, (ix)                  ; Error
 res.s 4, (ix+127)              ; Error
 res.s 4, (ix-128)              ; Error
 res.s 4, (iy)                  ; Error
 res.s 4, (iy+127)              ; Error
 res.s 4, (iy-128)              ; Error
 res.s 5, (hl)                  ; Error
 res.s 5, (ix)                  ; Error
 res.s 5, (ix+127)              ; Error
 res.s 5, (ix-128)              ; Error
 res.s 5, (iy)                  ; Error
 res.s 5, (iy+127)              ; Error
 res.s 5, (iy-128)              ; Error
 res.s 6, (hl)                  ; Error
 res.s 6, (ix)                  ; Error
 res.s 6, (ix+127)              ; Error
 res.s 6, (ix-128)              ; Error
 res.s 6, (iy)                  ; Error
 res.s 6, (iy+127)              ; Error
 res.s 6, (iy-128)              ; Error
 res.s 7, (hl)                  ; Error
 res.s 7, (ix)                  ; Error
 res.s 7, (ix+127)              ; Error
 res.s 7, (ix-128)              ; Error
 res.s 7, (iy)                  ; Error
 res.s 7, (iy+127)              ; Error
 res.s 7, (iy-128)              ; Error
 res.s 8, (hl)                  ; Error
 res.s 8, (ix)                  ; Error
 res.s 8, (ix+127)              ; Error
 res.s 8, (ix-128)              ; Error
 res.s 8, (iy)                  ; Error
 res.s 8, (iy+127)              ; Error
 res.s 8, (iy-128)              ; Error
 ret.l                          ; Error
 ret.l c                        ; Error
 ret.l m                        ; Error
 ret.l nc                       ; Error
 ret.l nv                       ; Error
 ret.l nz                       ; Error
 ret.l p                        ; Error
 ret.l pe                       ; Error
 ret.l po                       ; Error
 ret.l v                        ; Error
 ret.l z                        ; Error
 reti.l                         ; Error
 retn                           ; Error
 retn.l                         ; Error
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
 rl.l (hl)                      ; Error
 rl.l (ix)                      ; Error
 rl.l (ix+127)                  ; Error
 rl.l (ix-128)                  ; Error
 rl.l (iy)                      ; Error
 rl.l (iy+127)                  ; Error
 rl.l (iy-128)                  ; Error
 rl.s (hl)                      ; Error
 rl.s (ix)                      ; Error
 rl.s (ix+127)                  ; Error
 rl.s (ix-128)                  ; Error
 rl.s (iy)                      ; Error
 rl.s (iy+127)                  ; Error
 rl.s (iy-128)                  ; Error
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
 rlc.l (hl)                     ; Error
 rlc.l (ix)                     ; Error
 rlc.l (ix+127)                 ; Error
 rlc.l (ix-128)                 ; Error
 rlc.l (iy)                     ; Error
 rlc.l (iy+127)                 ; Error
 rlc.l (iy-128)                 ; Error
 rlc.s (hl)                     ; Error
 rlc.s (ix)                     ; Error
 rlc.s (ix+127)                 ; Error
 rlc.s (ix-128)                 ; Error
 rlc.s (iy)                     ; Error
 rlc.s (iy+127)                 ; Error
 rlc.s (iy-128)                 ; Error
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
 rr.l (hl)                      ; Error
 rr.l (ix)                      ; Error
 rr.l (ix+127)                  ; Error
 rr.l (ix-128)                  ; Error
 rr.l (iy)                      ; Error
 rr.l (iy+127)                  ; Error
 rr.l (iy-128)                  ; Error
 rr.s (hl)                      ; Error
 rr.s (ix)                      ; Error
 rr.s (ix+127)                  ; Error
 rr.s (ix-128)                  ; Error
 rr.s (iy)                      ; Error
 rr.s (iy+127)                  ; Error
 rr.s (iy-128)                  ; Error
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
 rrc.l (hl)                     ; Error
 rrc.l (ix)                     ; Error
 rrc.l (ix+127)                 ; Error
 rrc.l (ix-128)                 ; Error
 rrc.l (iy)                     ; Error
 rrc.l (iy+127)                 ; Error
 rrc.l (iy-128)                 ; Error
 rrc.s (hl)                     ; Error
 rrc.s (ix)                     ; Error
 rrc.s (ix+127)                 ; Error
 rrc.s (ix-128)                 ; Error
 rrc.s (iy)                     ; Error
 rrc.s (iy+127)                 ; Error
 rrc.s (iy-128)                 ; Error
 rsmix                          ; Error
 rst -1                         ; Error
 rst 10                         ; Error
 rst 11                         ; Error
 rst 12                         ; Error
 rst 13                         ; Error
 rst 14                         ; Error
 rst 15                         ; Error
 rst 17                         ; Error
 rst 18                         ; Error
 rst 19                         ; Error
 rst 20                         ; Error
 rst 21                         ; Error
 rst 22                         ; Error
 rst 23                         ; Error
 rst 25                         ; Error
 rst 26                         ; Error
 rst 27                         ; Error
 rst 28                         ; Error
 rst 29                         ; Error
 rst 30                         ; Error
 rst 31                         ; Error
 rst 33                         ; Error
 rst 34                         ; Error
 rst 35                         ; Error
 rst 36                         ; Error
 rst 37                         ; Error
 rst 38                         ; Error
 rst 39                         ; Error
 rst 41                         ; Error
 rst 42                         ; Error
 rst 43                         ; Error
 rst 44                         ; Error
 rst 45                         ; Error
 rst 46                         ; Error
 rst 47                         ; Error
 rst 49                         ; Error
 rst 50                         ; Error
 rst 51                         ; Error
 rst 52                         ; Error
 rst 53                         ; Error
 rst 54                         ; Error
 rst 55                         ; Error
 rst 57                         ; Error
 rst 58                         ; Error
 rst 59                         ; Error
 rst 60                         ; Error
 rst 61                         ; Error
 rst 62                         ; Error
 rst 63                         ; Error
 rst 64                         ; Error
 rst 9                          ; Error
 rst.l -1                       ; Error
 rst.l 0                        ; Error
 rst.l 1                        ; Error
 rst.l 10                       ; Error
 rst.l 11                       ; Error
 rst.l 12                       ; Error
 rst.l 13                       ; Error
 rst.l 14                       ; Error
 rst.l 15                       ; Error
 rst.l 16                       ; Error
 rst.l 17                       ; Error
 rst.l 18                       ; Error
 rst.l 19                       ; Error
 rst.l 2                        ; Error
 rst.l 20                       ; Error
 rst.l 21                       ; Error
 rst.l 22                       ; Error
 rst.l 23                       ; Error
 rst.l 24                       ; Error
 rst.l 25                       ; Error
 rst.l 26                       ; Error
 rst.l 27                       ; Error
 rst.l 28                       ; Error
 rst.l 29                       ; Error
 rst.l 3                        ; Error
 rst.l 30                       ; Error
 rst.l 31                       ; Error
 rst.l 32                       ; Error
 rst.l 33                       ; Error
 rst.l 34                       ; Error
 rst.l 35                       ; Error
 rst.l 36                       ; Error
 rst.l 37                       ; Error
 rst.l 38                       ; Error
 rst.l 39                       ; Error
 rst.l 4                        ; Error
 rst.l 40                       ; Error
 rst.l 41                       ; Error
 rst.l 42                       ; Error
 rst.l 43                       ; Error
 rst.l 44                       ; Error
 rst.l 45                       ; Error
 rst.l 46                       ; Error
 rst.l 47                       ; Error
 rst.l 48                       ; Error
 rst.l 49                       ; Error
 rst.l 5                        ; Error
 rst.l 50                       ; Error
 rst.l 51                       ; Error
 rst.l 52                       ; Error
 rst.l 53                       ; Error
 rst.l 54                       ; Error
 rst.l 55                       ; Error
 rst.l 56                       ; Error
 rst.l 57                       ; Error
 rst.l 58                       ; Error
 rst.l 59                       ; Error
 rst.l 6                        ; Error
 rst.l 60                       ; Error
 rst.l 61                       ; Error
 rst.l 62                       ; Error
 rst.l 63                       ; Error
 rst.l 64                       ; Error
 rst.l 7                        ; Error
 rst.l 8                        ; Error
 rst.l 9                        ; Error
 rst.s -1                       ; Error
 rst.s 0                        ; Error
 rst.s 1                        ; Error
 rst.s 10                       ; Error
 rst.s 11                       ; Error
 rst.s 12                       ; Error
 rst.s 13                       ; Error
 rst.s 14                       ; Error
 rst.s 15                       ; Error
 rst.s 16                       ; Error
 rst.s 17                       ; Error
 rst.s 18                       ; Error
 rst.s 19                       ; Error
 rst.s 2                        ; Error
 rst.s 20                       ; Error
 rst.s 21                       ; Error
 rst.s 22                       ; Error
 rst.s 23                       ; Error
 rst.s 24                       ; Error
 rst.s 25                       ; Error
 rst.s 26                       ; Error
 rst.s 27                       ; Error
 rst.s 28                       ; Error
 rst.s 29                       ; Error
 rst.s 3                        ; Error
 rst.s 30                       ; Error
 rst.s 31                       ; Error
 rst.s 32                       ; Error
 rst.s 33                       ; Error
 rst.s 34                       ; Error
 rst.s 35                       ; Error
 rst.s 36                       ; Error
 rst.s 37                       ; Error
 rst.s 38                       ; Error
 rst.s 39                       ; Error
 rst.s 4                        ; Error
 rst.s 40                       ; Error
 rst.s 41                       ; Error
 rst.s 42                       ; Error
 rst.s 43                       ; Error
 rst.s 44                       ; Error
 rst.s 45                       ; Error
 rst.s 46                       ; Error
 rst.s 47                       ; Error
 rst.s 48                       ; Error
 rst.s 49                       ; Error
 rst.s 5                        ; Error
 rst.s 50                       ; Error
 rst.s 51                       ; Error
 rst.s 52                       ; Error
 rst.s 53                       ; Error
 rst.s 54                       ; Error
 rst.s 55                       ; Error
 rst.s 56                       ; Error
 rst.s 57                       ; Error
 rst.s 58                       ; Error
 rst.s 59                       ; Error
 rst.s 6                        ; Error
 rst.s 60                       ; Error
 rst.s 61                       ; Error
 rst.s 62                       ; Error
 rst.s 63                       ; Error
 rst.s 64                       ; Error
 rst.s 7                        ; Error
 rst.s 8                        ; Error
 rst.s 9                        ; Error
 rstv                           ; Error
 sbc a, ixh                     ; Error
 sbc a, ixl                     ; Error
 sbc a, iyh                     ; Error
 sbc a, iyl                     ; Error
 sbc ixh                        ; Error
 sbc ixl                        ; Error
 sbc iyh                        ; Error
 sbc iyl                        ; Error
 sbc.l (hl)                     ; Error
 sbc.l (hl+)                    ; Error
 sbc.l (hl-)                    ; Error
 sbc.l (ix)                     ; Error
 sbc.l (ix+127)                 ; Error
 sbc.l (ix-128)                 ; Error
 sbc.l (iy)                     ; Error
 sbc.l (iy+127)                 ; Error
 sbc.l (iy-128)                 ; Error
 sbc.l a, (hl)                  ; Error
 sbc.l a, (hl+)                 ; Error
 sbc.l a, (hl-)                 ; Error
 sbc.l a, (ix)                  ; Error
 sbc.l a, (ix+127)              ; Error
 sbc.l a, (ix-128)              ; Error
 sbc.l a, (iy)                  ; Error
 sbc.l a, (iy+127)              ; Error
 sbc.l a, (iy-128)              ; Error
 sbc.l hl, bc                   ; Error
 sbc.l hl, de                   ; Error
 sbc.l hl, hl                   ; Error
 sbc.l hl, sp                   ; Error
 sbc.s (hl)                     ; Error
 sbc.s (hl+)                    ; Error
 sbc.s (hl-)                    ; Error
 sbc.s (ix)                     ; Error
 sbc.s (ix+127)                 ; Error
 sbc.s (ix-128)                 ; Error
 sbc.s (iy)                     ; Error
 sbc.s (iy+127)                 ; Error
 sbc.s (iy-128)                 ; Error
 sbc.s a, (hl)                  ; Error
 sbc.s a, (hl+)                 ; Error
 sbc.s a, (hl-)                 ; Error
 sbc.s a, (ix)                  ; Error
 sbc.s a, (ix+127)              ; Error
 sbc.s a, (ix-128)              ; Error
 sbc.s a, (iy)                  ; Error
 sbc.s a, (iy+127)              ; Error
 sbc.s a, (iy-128)              ; Error
 sbc.s hl, bc                   ; Error
 sbc.s hl, de                   ; Error
 sbc.s hl, hl                   ; Error
 sbc.s hl, sp                   ; Error
 set -1, (hl)                   ; Error
 set -1, (ix)                   ; Error
 set -1, (ix), a                ; Error
 set -1, (ix), b                ; Error
 set -1, (ix), c                ; Error
 set -1, (ix), d                ; Error
 set -1, (ix), e                ; Error
 set -1, (ix), h                ; Error
 set -1, (ix), l                ; Error
 set -1, (ix+127)               ; Error
 set -1, (ix+127), a            ; Error
 set -1, (ix+127), b            ; Error
 set -1, (ix+127), c            ; Error
 set -1, (ix+127), d            ; Error
 set -1, (ix+127), e            ; Error
 set -1, (ix+127), h            ; Error
 set -1, (ix+127), l            ; Error
 set -1, (ix-128)               ; Error
 set -1, (ix-128), a            ; Error
 set -1, (ix-128), b            ; Error
 set -1, (ix-128), c            ; Error
 set -1, (ix-128), d            ; Error
 set -1, (ix-128), e            ; Error
 set -1, (ix-128), h            ; Error
 set -1, (ix-128), l            ; Error
 set -1, (iy)                   ; Error
 set -1, (iy), a                ; Error
 set -1, (iy), b                ; Error
 set -1, (iy), c                ; Error
 set -1, (iy), d                ; Error
 set -1, (iy), e                ; Error
 set -1, (iy), h                ; Error
 set -1, (iy), l                ; Error
 set -1, (iy+127)               ; Error
 set -1, (iy+127), a            ; Error
 set -1, (iy+127), b            ; Error
 set -1, (iy+127), c            ; Error
 set -1, (iy+127), d            ; Error
 set -1, (iy+127), e            ; Error
 set -1, (iy+127), h            ; Error
 set -1, (iy+127), l            ; Error
 set -1, (iy-128)               ; Error
 set -1, (iy-128), a            ; Error
 set -1, (iy-128), b            ; Error
 set -1, (iy-128), c            ; Error
 set -1, (iy-128), d            ; Error
 set -1, (iy-128), e            ; Error
 set -1, (iy-128), h            ; Error
 set -1, (iy-128), l            ; Error
 set -1, a                      ; Error
 set -1, a'                     ; Error
 set -1, b                      ; Error
 set -1, b'                     ; Error
 set -1, c                      ; Error
 set -1, c'                     ; Error
 set -1, d                      ; Error
 set -1, d'                     ; Error
 set -1, e                      ; Error
 set -1, e'                     ; Error
 set -1, h                      ; Error
 set -1, h'                     ; Error
 set -1, l                      ; Error
 set -1, l'                     ; Error
 set 0, (ix), a                 ; Error
 set 0, (ix), b                 ; Error
 set 0, (ix), c                 ; Error
 set 0, (ix), d                 ; Error
 set 0, (ix), e                 ; Error
 set 0, (ix), h                 ; Error
 set 0, (ix), l                 ; Error
 set 0, (ix+127), a             ; Error
 set 0, (ix+127), b             ; Error
 set 0, (ix+127), c             ; Error
 set 0, (ix+127), d             ; Error
 set 0, (ix+127), e             ; Error
 set 0, (ix+127), h             ; Error
 set 0, (ix+127), l             ; Error
 set 0, (ix-128), a             ; Error
 set 0, (ix-128), b             ; Error
 set 0, (ix-128), c             ; Error
 set 0, (ix-128), d             ; Error
 set 0, (ix-128), e             ; Error
 set 0, (ix-128), h             ; Error
 set 0, (ix-128), l             ; Error
 set 0, (iy), a                 ; Error
 set 0, (iy), b                 ; Error
 set 0, (iy), c                 ; Error
 set 0, (iy), d                 ; Error
 set 0, (iy), e                 ; Error
 set 0, (iy), h                 ; Error
 set 0, (iy), l                 ; Error
 set 0, (iy+127), a             ; Error
 set 0, (iy+127), b             ; Error
 set 0, (iy+127), c             ; Error
 set 0, (iy+127), d             ; Error
 set 0, (iy+127), e             ; Error
 set 0, (iy+127), h             ; Error
 set 0, (iy+127), l             ; Error
 set 0, (iy-128), a             ; Error
 set 0, (iy-128), b             ; Error
 set 0, (iy-128), c             ; Error
 set 0, (iy-128), d             ; Error
 set 0, (iy-128), e             ; Error
 set 0, (iy-128), h             ; Error
 set 0, (iy-128), l             ; Error
 set 1, (ix), a                 ; Error
 set 1, (ix), b                 ; Error
 set 1, (ix), c                 ; Error
 set 1, (ix), d                 ; Error
 set 1, (ix), e                 ; Error
 set 1, (ix), h                 ; Error
 set 1, (ix), l                 ; Error
 set 1, (ix+127), a             ; Error
 set 1, (ix+127), b             ; Error
 set 1, (ix+127), c             ; Error
 set 1, (ix+127), d             ; Error
 set 1, (ix+127), e             ; Error
 set 1, (ix+127), h             ; Error
 set 1, (ix+127), l             ; Error
 set 1, (ix-128), a             ; Error
 set 1, (ix-128), b             ; Error
 set 1, (ix-128), c             ; Error
 set 1, (ix-128), d             ; Error
 set 1, (ix-128), e             ; Error
 set 1, (ix-128), h             ; Error
 set 1, (ix-128), l             ; Error
 set 1, (iy), a                 ; Error
 set 1, (iy), b                 ; Error
 set 1, (iy), c                 ; Error
 set 1, (iy), d                 ; Error
 set 1, (iy), e                 ; Error
 set 1, (iy), h                 ; Error
 set 1, (iy), l                 ; Error
 set 1, (iy+127), a             ; Error
 set 1, (iy+127), b             ; Error
 set 1, (iy+127), c             ; Error
 set 1, (iy+127), d             ; Error
 set 1, (iy+127), e             ; Error
 set 1, (iy+127), h             ; Error
 set 1, (iy+127), l             ; Error
 set 1, (iy-128), a             ; Error
 set 1, (iy-128), b             ; Error
 set 1, (iy-128), c             ; Error
 set 1, (iy-128), d             ; Error
 set 1, (iy-128), e             ; Error
 set 1, (iy-128), h             ; Error
 set 1, (iy-128), l             ; Error
 set 2, (ix), a                 ; Error
 set 2, (ix), b                 ; Error
 set 2, (ix), c                 ; Error
 set 2, (ix), d                 ; Error
 set 2, (ix), e                 ; Error
 set 2, (ix), h                 ; Error
 set 2, (ix), l                 ; Error
 set 2, (ix+127), a             ; Error
 set 2, (ix+127), b             ; Error
 set 2, (ix+127), c             ; Error
 set 2, (ix+127), d             ; Error
 set 2, (ix+127), e             ; Error
 set 2, (ix+127), h             ; Error
 set 2, (ix+127), l             ; Error
 set 2, (ix-128), a             ; Error
 set 2, (ix-128), b             ; Error
 set 2, (ix-128), c             ; Error
 set 2, (ix-128), d             ; Error
 set 2, (ix-128), e             ; Error
 set 2, (ix-128), h             ; Error
 set 2, (ix-128), l             ; Error
 set 2, (iy), a                 ; Error
 set 2, (iy), b                 ; Error
 set 2, (iy), c                 ; Error
 set 2, (iy), d                 ; Error
 set 2, (iy), e                 ; Error
 set 2, (iy), h                 ; Error
 set 2, (iy), l                 ; Error
 set 2, (iy+127), a             ; Error
 set 2, (iy+127), b             ; Error
 set 2, (iy+127), c             ; Error
 set 2, (iy+127), d             ; Error
 set 2, (iy+127), e             ; Error
 set 2, (iy+127), h             ; Error
 set 2, (iy+127), l             ; Error
 set 2, (iy-128), a             ; Error
 set 2, (iy-128), b             ; Error
 set 2, (iy-128), c             ; Error
 set 2, (iy-128), d             ; Error
 set 2, (iy-128), e             ; Error
 set 2, (iy-128), h             ; Error
 set 2, (iy-128), l             ; Error
 set 3, (ix), a                 ; Error
 set 3, (ix), b                 ; Error
 set 3, (ix), c                 ; Error
 set 3, (ix), d                 ; Error
 set 3, (ix), e                 ; Error
 set 3, (ix), h                 ; Error
 set 3, (ix), l                 ; Error
 set 3, (ix+127), a             ; Error
 set 3, (ix+127), b             ; Error
 set 3, (ix+127), c             ; Error
 set 3, (ix+127), d             ; Error
 set 3, (ix+127), e             ; Error
 set 3, (ix+127), h             ; Error
 set 3, (ix+127), l             ; Error
 set 3, (ix-128), a             ; Error
 set 3, (ix-128), b             ; Error
 set 3, (ix-128), c             ; Error
 set 3, (ix-128), d             ; Error
 set 3, (ix-128), e             ; Error
 set 3, (ix-128), h             ; Error
 set 3, (ix-128), l             ; Error
 set 3, (iy), a                 ; Error
 set 3, (iy), b                 ; Error
 set 3, (iy), c                 ; Error
 set 3, (iy), d                 ; Error
 set 3, (iy), e                 ; Error
 set 3, (iy), h                 ; Error
 set 3, (iy), l                 ; Error
 set 3, (iy+127), a             ; Error
 set 3, (iy+127), b             ; Error
 set 3, (iy+127), c             ; Error
 set 3, (iy+127), d             ; Error
 set 3, (iy+127), e             ; Error
 set 3, (iy+127), h             ; Error
 set 3, (iy+127), l             ; Error
 set 3, (iy-128), a             ; Error
 set 3, (iy-128), b             ; Error
 set 3, (iy-128), c             ; Error
 set 3, (iy-128), d             ; Error
 set 3, (iy-128), e             ; Error
 set 3, (iy-128), h             ; Error
 set 3, (iy-128), l             ; Error
 set 4, (ix), a                 ; Error
 set 4, (ix), b                 ; Error
 set 4, (ix), c                 ; Error
 set 4, (ix), d                 ; Error
 set 4, (ix), e                 ; Error
 set 4, (ix), h                 ; Error
 set 4, (ix), l                 ; Error
 set 4, (ix+127), a             ; Error
 set 4, (ix+127), b             ; Error
 set 4, (ix+127), c             ; Error
 set 4, (ix+127), d             ; Error
 set 4, (ix+127), e             ; Error
 set 4, (ix+127), h             ; Error
 set 4, (ix+127), l             ; Error
 set 4, (ix-128), a             ; Error
 set 4, (ix-128), b             ; Error
 set 4, (ix-128), c             ; Error
 set 4, (ix-128), d             ; Error
 set 4, (ix-128), e             ; Error
 set 4, (ix-128), h             ; Error
 set 4, (ix-128), l             ; Error
 set 4, (iy), a                 ; Error
 set 4, (iy), b                 ; Error
 set 4, (iy), c                 ; Error
 set 4, (iy), d                 ; Error
 set 4, (iy), e                 ; Error
 set 4, (iy), h                 ; Error
 set 4, (iy), l                 ; Error
 set 4, (iy+127), a             ; Error
 set 4, (iy+127), b             ; Error
 set 4, (iy+127), c             ; Error
 set 4, (iy+127), d             ; Error
 set 4, (iy+127), e             ; Error
 set 4, (iy+127), h             ; Error
 set 4, (iy+127), l             ; Error
 set 4, (iy-128), a             ; Error
 set 4, (iy-128), b             ; Error
 set 4, (iy-128), c             ; Error
 set 4, (iy-128), d             ; Error
 set 4, (iy-128), e             ; Error
 set 4, (iy-128), h             ; Error
 set 4, (iy-128), l             ; Error
 set 5, (ix), a                 ; Error
 set 5, (ix), b                 ; Error
 set 5, (ix), c                 ; Error
 set 5, (ix), d                 ; Error
 set 5, (ix), e                 ; Error
 set 5, (ix), h                 ; Error
 set 5, (ix), l                 ; Error
 set 5, (ix+127), a             ; Error
 set 5, (ix+127), b             ; Error
 set 5, (ix+127), c             ; Error
 set 5, (ix+127), d             ; Error
 set 5, (ix+127), e             ; Error
 set 5, (ix+127), h             ; Error
 set 5, (ix+127), l             ; Error
 set 5, (ix-128), a             ; Error
 set 5, (ix-128), b             ; Error
 set 5, (ix-128), c             ; Error
 set 5, (ix-128), d             ; Error
 set 5, (ix-128), e             ; Error
 set 5, (ix-128), h             ; Error
 set 5, (ix-128), l             ; Error
 set 5, (iy), a                 ; Error
 set 5, (iy), b                 ; Error
 set 5, (iy), c                 ; Error
 set 5, (iy), d                 ; Error
 set 5, (iy), e                 ; Error
 set 5, (iy), h                 ; Error
 set 5, (iy), l                 ; Error
 set 5, (iy+127), a             ; Error
 set 5, (iy+127), b             ; Error
 set 5, (iy+127), c             ; Error
 set 5, (iy+127), d             ; Error
 set 5, (iy+127), e             ; Error
 set 5, (iy+127), h             ; Error
 set 5, (iy+127), l             ; Error
 set 5, (iy-128), a             ; Error
 set 5, (iy-128), b             ; Error
 set 5, (iy-128), c             ; Error
 set 5, (iy-128), d             ; Error
 set 5, (iy-128), e             ; Error
 set 5, (iy-128), h             ; Error
 set 5, (iy-128), l             ; Error
 set 6, (ix), a                 ; Error
 set 6, (ix), b                 ; Error
 set 6, (ix), c                 ; Error
 set 6, (ix), d                 ; Error
 set 6, (ix), e                 ; Error
 set 6, (ix), h                 ; Error
 set 6, (ix), l                 ; Error
 set 6, (ix+127), a             ; Error
 set 6, (ix+127), b             ; Error
 set 6, (ix+127), c             ; Error
 set 6, (ix+127), d             ; Error
 set 6, (ix+127), e             ; Error
 set 6, (ix+127), h             ; Error
 set 6, (ix+127), l             ; Error
 set 6, (ix-128), a             ; Error
 set 6, (ix-128), b             ; Error
 set 6, (ix-128), c             ; Error
 set 6, (ix-128), d             ; Error
 set 6, (ix-128), e             ; Error
 set 6, (ix-128), h             ; Error
 set 6, (ix-128), l             ; Error
 set 6, (iy), a                 ; Error
 set 6, (iy), b                 ; Error
 set 6, (iy), c                 ; Error
 set 6, (iy), d                 ; Error
 set 6, (iy), e                 ; Error
 set 6, (iy), h                 ; Error
 set 6, (iy), l                 ; Error
 set 6, (iy+127), a             ; Error
 set 6, (iy+127), b             ; Error
 set 6, (iy+127), c             ; Error
 set 6, (iy+127), d             ; Error
 set 6, (iy+127), e             ; Error
 set 6, (iy+127), h             ; Error
 set 6, (iy+127), l             ; Error
 set 6, (iy-128), a             ; Error
 set 6, (iy-128), b             ; Error
 set 6, (iy-128), c             ; Error
 set 6, (iy-128), d             ; Error
 set 6, (iy-128), e             ; Error
 set 6, (iy-128), h             ; Error
 set 6, (iy-128), l             ; Error
 set 7, (ix), a                 ; Error
 set 7, (ix), b                 ; Error
 set 7, (ix), c                 ; Error
 set 7, (ix), d                 ; Error
 set 7, (ix), e                 ; Error
 set 7, (ix), h                 ; Error
 set 7, (ix), l                 ; Error
 set 7, (ix+127), a             ; Error
 set 7, (ix+127), b             ; Error
 set 7, (ix+127), c             ; Error
 set 7, (ix+127), d             ; Error
 set 7, (ix+127), e             ; Error
 set 7, (ix+127), h             ; Error
 set 7, (ix+127), l             ; Error
 set 7, (ix-128), a             ; Error
 set 7, (ix-128), b             ; Error
 set 7, (ix-128), c             ; Error
 set 7, (ix-128), d             ; Error
 set 7, (ix-128), e             ; Error
 set 7, (ix-128), h             ; Error
 set 7, (ix-128), l             ; Error
 set 7, (iy), a                 ; Error
 set 7, (iy), b                 ; Error
 set 7, (iy), c                 ; Error
 set 7, (iy), d                 ; Error
 set 7, (iy), e                 ; Error
 set 7, (iy), h                 ; Error
 set 7, (iy), l                 ; Error
 set 7, (iy+127), a             ; Error
 set 7, (iy+127), b             ; Error
 set 7, (iy+127), c             ; Error
 set 7, (iy+127), d             ; Error
 set 7, (iy+127), e             ; Error
 set 7, (iy+127), h             ; Error
 set 7, (iy+127), l             ; Error
 set 7, (iy-128), a             ; Error
 set 7, (iy-128), b             ; Error
 set 7, (iy-128), c             ; Error
 set 7, (iy-128), d             ; Error
 set 7, (iy-128), e             ; Error
 set 7, (iy-128), h             ; Error
 set 7, (iy-128), l             ; Error
 set 8, (hl)                    ; Error
 set 8, (ix)                    ; Error
 set 8, (ix), a                 ; Error
 set 8, (ix), b                 ; Error
 set 8, (ix), c                 ; Error
 set 8, (ix), d                 ; Error
 set 8, (ix), e                 ; Error
 set 8, (ix), h                 ; Error
 set 8, (ix), l                 ; Error
 set 8, (ix+127)                ; Error
 set 8, (ix+127), a             ; Error
 set 8, (ix+127), b             ; Error
 set 8, (ix+127), c             ; Error
 set 8, (ix+127), d             ; Error
 set 8, (ix+127), e             ; Error
 set 8, (ix+127), h             ; Error
 set 8, (ix+127), l             ; Error
 set 8, (ix-128)                ; Error
 set 8, (ix-128), a             ; Error
 set 8, (ix-128), b             ; Error
 set 8, (ix-128), c             ; Error
 set 8, (ix-128), d             ; Error
 set 8, (ix-128), e             ; Error
 set 8, (ix-128), h             ; Error
 set 8, (ix-128), l             ; Error
 set 8, (iy)                    ; Error
 set 8, (iy), a                 ; Error
 set 8, (iy), b                 ; Error
 set 8, (iy), c                 ; Error
 set 8, (iy), d                 ; Error
 set 8, (iy), e                 ; Error
 set 8, (iy), h                 ; Error
 set 8, (iy), l                 ; Error
 set 8, (iy+127)                ; Error
 set 8, (iy+127), a             ; Error
 set 8, (iy+127), b             ; Error
 set 8, (iy+127), c             ; Error
 set 8, (iy+127), d             ; Error
 set 8, (iy+127), e             ; Error
 set 8, (iy+127), h             ; Error
 set 8, (iy+127), l             ; Error
 set 8, (iy-128)                ; Error
 set 8, (iy-128), a             ; Error
 set 8, (iy-128), b             ; Error
 set 8, (iy-128), c             ; Error
 set 8, (iy-128), d             ; Error
 set 8, (iy-128), e             ; Error
 set 8, (iy-128), h             ; Error
 set 8, (iy-128), l             ; Error
 set 8, a                       ; Error
 set 8, a'                      ; Error
 set 8, b                       ; Error
 set 8, b'                      ; Error
 set 8, c                       ; Error
 set 8, c'                      ; Error
 set 8, d                       ; Error
 set 8, d'                      ; Error
 set 8, e                       ; Error
 set 8, e'                      ; Error
 set 8, h                       ; Error
 set 8, h'                      ; Error
 set 8, l                       ; Error
 set 8, l'                      ; Error
 set.l -1, (hl)                 ; Error
 set.l -1, (ix)                 ; Error
 set.l -1, (ix+127)             ; Error
 set.l -1, (ix-128)             ; Error
 set.l -1, (iy)                 ; Error
 set.l -1, (iy+127)             ; Error
 set.l -1, (iy-128)             ; Error
 set.l 0, (hl)                  ; Error
 set.l 0, (ix)                  ; Error
 set.l 0, (ix+127)              ; Error
 set.l 0, (ix-128)              ; Error
 set.l 0, (iy)                  ; Error
 set.l 0, (iy+127)              ; Error
 set.l 0, (iy-128)              ; Error
 set.l 1, (hl)                  ; Error
 set.l 1, (ix)                  ; Error
 set.l 1, (ix+127)              ; Error
 set.l 1, (ix-128)              ; Error
 set.l 1, (iy)                  ; Error
 set.l 1, (iy+127)              ; Error
 set.l 1, (iy-128)              ; Error
 set.l 2, (hl)                  ; Error
 set.l 2, (ix)                  ; Error
 set.l 2, (ix+127)              ; Error
 set.l 2, (ix-128)              ; Error
 set.l 2, (iy)                  ; Error
 set.l 2, (iy+127)              ; Error
 set.l 2, (iy-128)              ; Error
 set.l 3, (hl)                  ; Error
 set.l 3, (ix)                  ; Error
 set.l 3, (ix+127)              ; Error
 set.l 3, (ix-128)              ; Error
 set.l 3, (iy)                  ; Error
 set.l 3, (iy+127)              ; Error
 set.l 3, (iy-128)              ; Error
 set.l 4, (hl)                  ; Error
 set.l 4, (ix)                  ; Error
 set.l 4, (ix+127)              ; Error
 set.l 4, (ix-128)              ; Error
 set.l 4, (iy)                  ; Error
 set.l 4, (iy+127)              ; Error
 set.l 4, (iy-128)              ; Error
 set.l 5, (hl)                  ; Error
 set.l 5, (ix)                  ; Error
 set.l 5, (ix+127)              ; Error
 set.l 5, (ix-128)              ; Error
 set.l 5, (iy)                  ; Error
 set.l 5, (iy+127)              ; Error
 set.l 5, (iy-128)              ; Error
 set.l 6, (hl)                  ; Error
 set.l 6, (ix)                  ; Error
 set.l 6, (ix+127)              ; Error
 set.l 6, (ix-128)              ; Error
 set.l 6, (iy)                  ; Error
 set.l 6, (iy+127)              ; Error
 set.l 6, (iy-128)              ; Error
 set.l 7, (hl)                  ; Error
 set.l 7, (ix)                  ; Error
 set.l 7, (ix+127)              ; Error
 set.l 7, (ix-128)              ; Error
 set.l 7, (iy)                  ; Error
 set.l 7, (iy+127)              ; Error
 set.l 7, (iy-128)              ; Error
 set.l 8, (hl)                  ; Error
 set.l 8, (ix)                  ; Error
 set.l 8, (ix+127)              ; Error
 set.l 8, (ix-128)              ; Error
 set.l 8, (iy)                  ; Error
 set.l 8, (iy+127)              ; Error
 set.l 8, (iy-128)              ; Error
 set.s -1, (hl)                 ; Error
 set.s -1, (ix)                 ; Error
 set.s -1, (ix+127)             ; Error
 set.s -1, (ix-128)             ; Error
 set.s -1, (iy)                 ; Error
 set.s -1, (iy+127)             ; Error
 set.s -1, (iy-128)             ; Error
 set.s 0, (hl)                  ; Error
 set.s 0, (ix)                  ; Error
 set.s 0, (ix+127)              ; Error
 set.s 0, (ix-128)              ; Error
 set.s 0, (iy)                  ; Error
 set.s 0, (iy+127)              ; Error
 set.s 0, (iy-128)              ; Error
 set.s 1, (hl)                  ; Error
 set.s 1, (ix)                  ; Error
 set.s 1, (ix+127)              ; Error
 set.s 1, (ix-128)              ; Error
 set.s 1, (iy)                  ; Error
 set.s 1, (iy+127)              ; Error
 set.s 1, (iy-128)              ; Error
 set.s 2, (hl)                  ; Error
 set.s 2, (ix)                  ; Error
 set.s 2, (ix+127)              ; Error
 set.s 2, (ix-128)              ; Error
 set.s 2, (iy)                  ; Error
 set.s 2, (iy+127)              ; Error
 set.s 2, (iy-128)              ; Error
 set.s 3, (hl)                  ; Error
 set.s 3, (ix)                  ; Error
 set.s 3, (ix+127)              ; Error
 set.s 3, (ix-128)              ; Error
 set.s 3, (iy)                  ; Error
 set.s 3, (iy+127)              ; Error
 set.s 3, (iy-128)              ; Error
 set.s 4, (hl)                  ; Error
 set.s 4, (ix)                  ; Error
 set.s 4, (ix+127)              ; Error
 set.s 4, (ix-128)              ; Error
 set.s 4, (iy)                  ; Error
 set.s 4, (iy+127)              ; Error
 set.s 4, (iy-128)              ; Error
 set.s 5, (hl)                  ; Error
 set.s 5, (ix)                  ; Error
 set.s 5, (ix+127)              ; Error
 set.s 5, (ix-128)              ; Error
 set.s 5, (iy)                  ; Error
 set.s 5, (iy+127)              ; Error
 set.s 5, (iy-128)              ; Error
 set.s 6, (hl)                  ; Error
 set.s 6, (ix)                  ; Error
 set.s 6, (ix+127)              ; Error
 set.s 6, (ix-128)              ; Error
 set.s 6, (iy)                  ; Error
 set.s 6, (iy+127)              ; Error
 set.s 6, (iy-128)              ; Error
 set.s 7, (hl)                  ; Error
 set.s 7, (ix)                  ; Error
 set.s 7, (ix+127)              ; Error
 set.s 7, (ix-128)              ; Error
 set.s 7, (iy)                  ; Error
 set.s 7, (iy+127)              ; Error
 set.s 7, (iy-128)              ; Error
 set.s 8, (hl)                  ; Error
 set.s 8, (ix)                  ; Error
 set.s 8, (ix+127)              ; Error
 set.s 8, (ix-128)              ; Error
 set.s 8, (iy)                  ; Error
 set.s 8, (iy+127)              ; Error
 set.s 8, (iy-128)              ; Error
 setae                          ; Error
 setusr                         ; Error
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
 sla.l (hl)                     ; Error
 sla.l (ix)                     ; Error
 sla.l (ix+127)                 ; Error
 sla.l (ix-128)                 ; Error
 sla.l (iy)                     ; Error
 sla.l (iy+127)                 ; Error
 sla.l (iy-128)                 ; Error
 sla.s (hl)                     ; Error
 sla.s (ix)                     ; Error
 sla.s (ix+127)                 ; Error
 sla.s (ix-128)                 ; Error
 sla.s (iy)                     ; Error
 sla.s (iy+127)                 ; Error
 sla.s (iy-128)                 ; Error
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
 sll l                          ; Error
 slp                            ; Error
 sls (hl)                       ; Error
 sls (ix)                       ; Error
 sls (ix), a                    ; Error
 sls (ix), b                    ; Error
 sls (ix), c                    ; Error
 sls (ix), d                    ; Error
 sls (ix), e                    ; Error
 sls (ix), h                    ; Error
 sls (ix), l                    ; Error
 sls (ix+127)                   ; Error
 sls (ix+127), a                ; Error
 sls (ix+127), b                ; Error
 sls (ix+127), c                ; Error
 sls (ix+127), d                ; Error
 sls (ix+127), e                ; Error
 sls (ix+127), h                ; Error
 sls (ix+127), l                ; Error
 sls (ix-128)                   ; Error
 sls (ix-128), a                ; Error
 sls (ix-128), b                ; Error
 sls (ix-128), c                ; Error
 sls (ix-128), d                ; Error
 sls (ix-128), e                ; Error
 sls (ix-128), h                ; Error
 sls (ix-128), l                ; Error
 sls (iy)                       ; Error
 sls (iy), a                    ; Error
 sls (iy), b                    ; Error
 sls (iy), c                    ; Error
 sls (iy), d                    ; Error
 sls (iy), e                    ; Error
 sls (iy), h                    ; Error
 sls (iy), l                    ; Error
 sls (iy+127)                   ; Error
 sls (iy+127), a                ; Error
 sls (iy+127), b                ; Error
 sls (iy+127), c                ; Error
 sls (iy+127), d                ; Error
 sls (iy+127), e                ; Error
 sls (iy+127), h                ; Error
 sls (iy+127), l                ; Error
 sls (iy-128)                   ; Error
 sls (iy-128), a                ; Error
 sls (iy-128), b                ; Error
 sls (iy-128), c                ; Error
 sls (iy-128), d                ; Error
 sls (iy-128), e                ; Error
 sls (iy-128), h                ; Error
 sls (iy-128), l                ; Error
 sls a                          ; Error
 sls b                          ; Error
 sls c                          ; Error
 sls d                          ; Error
 sls e                          ; Error
 sls h                          ; Error
 sls l                          ; Error
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
 sra.l (hl)                     ; Error
 sra.l (ix)                     ; Error
 sra.l (ix+127)                 ; Error
 sra.l (ix-128)                 ; Error
 sra.l (iy)                     ; Error
 sra.l (iy+127)                 ; Error
 sra.l (iy-128)                 ; Error
 sra.s (hl)                     ; Error
 sra.s (ix)                     ; Error
 sra.s (ix+127)                 ; Error
 sra.s (ix-128)                 ; Error
 sra.s (iy)                     ; Error
 sra.s (iy+127)                 ; Error
 sra.s (iy-128)                 ; Error
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
 srl.l (hl)                     ; Error
 srl.l (ix)                     ; Error
 srl.l (ix+127)                 ; Error
 srl.l (ix-128)                 ; Error
 srl.l (iy)                     ; Error
 srl.l (iy+127)                 ; Error
 srl.l (iy-128)                 ; Error
 srl.s (hl)                     ; Error
 srl.s (ix)                     ; Error
 srl.s (ix+127)                 ; Error
 srl.s (ix-128)                 ; Error
 srl.s (iy)                     ; Error
 srl.s (iy+127)                 ; Error
 srl.s (iy-128)                 ; Error
 stae                           ; Error
 stmix                          ; Error
 stop                           ; Error
 sub a, ixh                     ; Error
 sub a, ixl                     ; Error
 sub a, iyh                     ; Error
 sub a, iyl                     ; Error
 sub ixh                        ; Error
 sub ixl                        ; Error
 sub iyh                        ; Error
 sub iyl                        ; Error
 sub.l (hl)                     ; Error
 sub.l (hl+)                    ; Error
 sub.l (hl-)                    ; Error
 sub.l (ix)                     ; Error
 sub.l (ix+127)                 ; Error
 sub.l (ix-128)                 ; Error
 sub.l (iy)                     ; Error
 sub.l (iy+127)                 ; Error
 sub.l (iy-128)                 ; Error
 sub.l a, (hl)                  ; Error
 sub.l a, (hl+)                 ; Error
 sub.l a, (hl-)                 ; Error
 sub.l a, (ix)                  ; Error
 sub.l a, (ix+127)              ; Error
 sub.l a, (ix-128)              ; Error
 sub.l a, (iy)                  ; Error
 sub.l a, (iy+127)              ; Error
 sub.l a, (iy-128)              ; Error
 sub.s (hl)                     ; Error
 sub.s (hl+)                    ; Error
 sub.s (hl-)                    ; Error
 sub.s (ix)                     ; Error
 sub.s (ix+127)                 ; Error
 sub.s (ix-128)                 ; Error
 sub.s (iy)                     ; Error
 sub.s (iy+127)                 ; Error
 sub.s (iy-128)                 ; Error
 sub.s a, (hl)                  ; Error
 sub.s a, (hl+)                 ; Error
 sub.s a, (hl-)                 ; Error
 sub.s a, (ix)                  ; Error
 sub.s a, (ix+127)              ; Error
 sub.s a, (ix-128)              ; Error
 sub.s a, (iy)                  ; Error
 sub.s a, (iy+127)              ; Error
 sub.s a, (iy-128)              ; Error
 sures                          ; Error
 swap                           ; Error
 swap (hl)                      ; Error
 swap a                         ; Error
 swap b                         ; Error
 swap c                         ; Error
 swap d                         ; Error
 swap e                         ; Error
 swap h                         ; Error
 swap l                         ; Error
 swapnib                        ; Error
 syscall                        ; Error
 test (hl)                      ; Error
 test -128                      ; Error
 test 127                       ; Error
 test 255                       ; Error
 test a                         ; Error
 test a, (hl)                   ; Error
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
 test.l (hl)                    ; Error
 test.l a, (hl)                 ; Error
 test.s (hl)                    ; Error
 test.s a, (hl)                 ; Error
 tst (hl)                       ; Error
 tst -128                       ; Error
 tst 127                        ; Error
 tst 255                        ; Error
 tst a                          ; Error
 tst a, (hl)                    ; Error
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
 tst.l (hl)                     ; Error
 tst.l a, (hl)                  ; Error
 tst.s (hl)                     ; Error
 tst.s a, (hl)                  ; Error
 tstio -128                     ; Error
 tstio 127                      ; Error
 tstio 255                      ; Error
 uma                            ; Error
 ums                            ; Error
 xor a, ixh                     ; Error
 xor a, ixl                     ; Error
 xor a, iyh                     ; Error
 xor a, iyl                     ; Error
 xor ixh                        ; Error
 xor ixl                        ; Error
 xor iyh                        ; Error
 xor iyl                        ; Error
 xor.l (hl)                     ; Error
 xor.l (hl+)                    ; Error
 xor.l (hl-)                    ; Error
 xor.l (ix)                     ; Error
 xor.l (ix+127)                 ; Error
 xor.l (ix-128)                 ; Error
 xor.l (iy)                     ; Error
 xor.l (iy+127)                 ; Error
 xor.l (iy-128)                 ; Error
 xor.l a, (hl)                  ; Error
 xor.l a, (hl+)                 ; Error
 xor.l a, (hl-)                 ; Error
 xor.l a, (ix)                  ; Error
 xor.l a, (ix+127)              ; Error
 xor.l a, (ix-128)              ; Error
 xor.l a, (iy)                  ; Error
 xor.l a, (iy+127)              ; Error
 xor.l a, (iy-128)              ; Error
 xor.s (hl)                     ; Error
 xor.s (hl+)                    ; Error
 xor.s (hl-)                    ; Error
 xor.s (ix)                     ; Error
 xor.s (ix+127)                 ; Error
 xor.s (ix-128)                 ; Error
 xor.s (iy)                     ; Error
 xor.s (iy+127)                 ; Error
 xor.s (iy-128)                 ; Error
 xor.s a, (hl)                  ; Error
 xor.s a, (hl+)                 ; Error
 xor.s a, (hl-)                 ; Error
 xor.s a, (ix)                  ; Error
 xor.s a, (ix+127)              ; Error
 xor.s a, (ix-128)              ; Error
 xor.s a, (iy)                  ; Error
 xor.s a, (iy+127)              ; Error
 xor.s a, (iy-128)              ; Error
 xthl                           ; Error
