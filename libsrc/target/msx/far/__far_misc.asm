


PUBLIC __far_init
PUBLIC __far_reset

EXTERN GET_P2
EXTERN PUT_P2

; Get the initial banking setting
; Exit: a = current bank (or entry value for __far_reset)
; Uses; none
defc __far_init = GET_P2


; Get the initial banking setting
; Entry: a = bank to page in
; Uses: none
defc __far_reset = PUT_P2
