
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TARGET BSS SEGMENT - ATTACHED ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;--------------------------------------------------------------
;--  input ----------------------------------------------------
;--------------------------------------------------------------

; amx mouse coordinate will be initialized to (0,0)

PUBLIC __input_amx_mouse_x, __input_amx_mouse_y

__input_amx_mouse_x:           defs 2
__input_amx_mouse_y:           defs 2


; kempston mouse coordinate will be initialized to (0,0)

PUBLIC __input_kempston_mouse_x, __input_kempston_mouse_y
PUBLIC __input_kempston_mouse_rawx, __input_kempston_mouse_rawy

__input_kempston_mouse_x:      defs 2
__input_kempston_mouse_y:      defs 2
__input_kempston_mouse_rawx:   defs 1
__input_kempston_mouse_rawy:   defs 1

