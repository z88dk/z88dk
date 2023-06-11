; Interrupt handling using firmware

INCLUDE "target/cpc/def/cpcfirm.def"

SECTION code_clib

PUBLIC __fw_add_vsync_isr
PUBLIC __fw_add_fast_isr
PUBLIC __fw_del_vsync_isr
PUBLIC __fw_del_fast_isr

; CRT reserves a bit of memory for event blocks - firmware needs 10 bytes, so we'll use 16
EXTERN CRT_EVENT_BLOCKS
EXTERN CRT_EVENT_BLOCKS_NUM


EXTERN firmware


DEFVARS 0 {
    evt_func	ds.w 1
    evt_event   ds.b 10
    padding     ds.b 4
}

; Entry: hl = function to run
__fw_add_vsync_isr:
    push    hl
    call    find_free_slot
    pop     de
    jr      c, failure
    push    hl
    call    initialise_slot
    pop     hl
    call    firmware
    defw    kl_add_framefly
    ld      hl,1
    ret

; Entry: hl = function to run
__fw_del_vsync_isr:
    ex      de,hl
    call    find_by_isr
    ld      a,h
    or      l
    ret     z
    inc     hl
    inc     hl
    call    firmware
    defw    kl_del_framefly
    ret

failure:
    ld      hl,0
    ret


__fw_add_fast_isr:
    push    hl
    call    find_free_slot
    pop     de
    jr      c, failure
    push    hl
    call    initialise_slot
    pop     hl
    call    firmware
    defw    kl_add_fast_ticker
    ld      hl,1
    ret

; Entry: hl = function to run
__fw_del_fast_isr:
    ex      de,hl
    call    find_by_isr
    ld      a,h
    or      l
    ret     z
    inc     hl
    inc     hl
    call    firmware
    defw    kl_del_fast_ticker
    ret


; Entry: hl = start of block
;        de = function
initialise_slot:
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      c,$80    ; ROM select address??
    ld      b,@10000010   ;Async event, called in path
    call    firmware
    defw    kl_init_event
    ret
   
; Entry: de = isr to delete
; Exit:  hl = start of our block or 0 if not found
find_by_isr:
    ld      b, CRT_EVENT_BLOCKS_NUM
    ld      hl, CRT_EVENT_BLOCKS
loop2:
    ld      a,(hl)
    cp      e
    jr      nz,next
    inc     hl
    ld      a,(hl)
    dec     hl
    cp      d
    ret     z
next:
    push    bc
    ld      bc,16
    add     hl,bc
    pop     bc
    djnz    loop2
    ld      hl,0
    ret


; Find a free event slot
;
; Success: hl = slot, carry reet
; Failure: hl = 0, carry set
;
; Uses: a b de hl
find_free_slot:
    ld      b, CRT_EVENT_BLOCKS_NUM
    ld      hl, CRT_EVENT_BLOCKS
loop:
    ld      a,(hl)
    inc     hl
    or      (hl)
    dec     hl
    ret     z
    ld      de,16
    add     hl,de
    djnz    loop
    ld      hl,0
    scf
    ret
    


