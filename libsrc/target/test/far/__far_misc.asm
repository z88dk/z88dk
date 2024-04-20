


PUBLIC __far_init
PUBLIC __far_reset


; Get the initial banking setting
; Exit: a = current bank (or entry value for __far_reset)
; Uses; none
__far_init:
    in a,($fe)
    ret

; Get the initial banking setting
; Entry: a = bank to page in
; Uses: none
__far_reset:
    out ($fe),a
    ret
