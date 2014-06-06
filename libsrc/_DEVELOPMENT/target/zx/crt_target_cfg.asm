
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FEATURE ENABLE / DISABLE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF DEFINED_ZX_ENABLE_AMX_MOUSE

   defc __enable_amx_mouse = 1

ELSE

   defc __enable_amx_mouse = 0

ENDIF

IF DEFINED_ZX_ENABLE_KEMPSTON_MOUSE

   defc __enable_kempston_mouse = 1

ELSE

   defc __enable_kempston_mouse = 0

ENDIF

IF DEFINED_ZX_ENABLE_FZX

   defc __enable_fzx = 1

ELSE

   defc __enable_fzx = 0

ENDIF
