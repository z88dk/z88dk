


PUBLIC __far_start
PUBLIC __far_end

EXTERN GET_P2
EXTERN PUT_P2

; Get the initial banking setting
; Exit: a = current bank (or entry value for __far_end)
; Uses; none
defc __far_start = GET_P2


; Get the initial banking setting
; Entry: a = bank to page in
; Uses: none
defc __far_end = PUT_P2
