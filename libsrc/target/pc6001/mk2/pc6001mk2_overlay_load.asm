; NEC PC-6001mkII: overlays read from the disc into a window.
;
;   int pc6001mk2_overlay_load(uint8_t n) __smallc       0 if it was read, or
;   $FF for a disc error
;   int pc6001mk2_data_track(void)                       the first track after
;   the program and the overlays (the rest of the disc, to track 39, is the
;   program's)
;
; Overlay n is the section OVERLAY_n (n = 0 to 7:
; -pragma-define:CRT_PC6001MK2_OVERLAYS says how many), linked at the window the
; program's memory map gives it, and on the disc from the start of its own
; track(s), after the program (tracks 1 to __pc6001mk2_image_tracks) and the
; overlays before it (appmake +pc6001mk2 writes them so).  The crt's table has
; the window and the size of each.
; Interrupts are held off while the unit is read, and put back as they were.
; Keeps IX.  Only for the mkII disc subtype (pc6001mk2.lib).
; (The variables are in the code's section: the machine is all RAM.)
    SECTION     code_clib
    PUBLIC      _pc6001mk2_overlay_load, pc6001mk2_overlay_load
    PUBLIC      _pc6001mk2_data_track, pc6001mk2_data_track
    EXTERN      _pc6001mk2_disk_read
    EXTERN      __pc6001mk2_overlay_table
    EXTERN      __pc6001mk2_overlay_count
    EXTERN      __pc6001mk2_image_tracks

; ol_walk: skip b overlays of the table: hl = the table entry after them, ol_trk
; = the first track after the program and those overlays (a track holds 4096
; bytes)
ol_walk:
    ld          a, __pc6001mk2_image_tracks+1
    ld          (ol_trk), a
    ld          hl, __pc6001mk2_overlay_table
    inc         b
    jr          olw_test
olw_loop:
    inc         hl
    inc         hl                      ; the window
    ld          e, (hl)
    inc         hl
    ld          d, (hl)                 ; the size
    inc         hl
    push        hl
    ex          de, hl
    ld          de, 4095
    add         hl, de
    ld          a, h                    ; the tracks: (size + 4095) / 4096
    rrca
    rrca
    rrca
    rrca
    and         $0f
    ld          hl, ol_trk
    add         a, (hl)
    ld          (hl), a
    pop         hl
olw_test:
    djnz        olw_loop
    ret

_pc6001mk2_data_track:
pc6001mk2_data_track:
    ld          b, __pc6001mk2_overlay_count
    call        ol_walk
    ld          a, (ol_trk)
    ld          l, a
    ld          h, 0
    ret

_pc6001mk2_overlay_load:
pc6001mk2_overlay_load:
    ld          hl, 2
    add         hl, sp
    ld          b, (hl)                 ; n
    ld          a, i
    push        af                      ; (P/V is the interrupt flag)
    di
        ; hl = overlay n's entry, ol_trk its track
    call        ol_walk
    ld          e, (hl)
    inc         hl
    ld          d, (hl)
    inc         hl
    ld          (ol_dest), de           ; the window
    ld          e, (hl)
    inc         hl
    ld          d, (hl)
    ex          de, hl
    ld          de, 255
    add         hl, de
        ; the sectors: (size + 255) / 256 (under 64 KB)
    ld          a, h
    ld          (ol_left), a
ol_loop:
    ld          a, (ol_left)
    or          a
    jr          z, ol_done
    cp          17
    jr          c, ol_n
    ld          a, 16                   ; (up to the end of a track)
ol_n:
    ld          (ol_cnt), a
    ld          a, (ol_trk)
    ld          h, 0
    ld          l, a
        ; pc6001mk2_disk_read(track, 1, count, dest), smallc: pushed in that
        ; order
    push        hl
    ld          hl, 1
    push        hl
    ld          a, (ol_cnt)
    ld          l, a
    ld          h, 0
    push        hl
    ld          hl, (ol_dest)
    push        hl
    call        _pc6001mk2_disk_read
    pop         bc
    pop         bc
    pop         bc
    pop         bc
    ld          a, l
    or          a
    jr          nz, ol_fail
    ld          a, (ol_cnt)
    ld          d, a
    ld          e, 0
    ld          hl, (ol_dest)
    add         hl, de                  ; dest += count * 256
    ld          (ol_dest), hl
    ld          a, (ol_left)
    sub         d
    ld          (ol_left), a
    ld          hl, ol_trk
    inc         (hl)
    jr          ol_loop
ol_done:
    ld          hl, 0
    jr          ol_exit
ol_fail:
    ld          hl, $00ff
ol_exit:
    pop         af
    ret         po                      ; (interrupts were off)
    ei
    ret

ol_dest:
    defw        0
ol_cnt:
    defb        0
ol_left:
    defb        0
ol_trk:
    defb        0
