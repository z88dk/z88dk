

SECTION code_l_sccz80_far
PUBLIC __far_start
PUBLIC __far_end


; Get the initial banking setting
; Exit: a = current bank (or entry value for __far_end)
; Uses; none
__far_start:
    in a,($fe)
    ret

; Get the initial banking setting
; Entry: a = bank to page in
; Uses: none
__far_end:
    out ($fe),a
    ret
