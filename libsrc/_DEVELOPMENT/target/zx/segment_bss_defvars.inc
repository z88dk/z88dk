
; target bss segment externally supplied

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; amx mouse coordinate will be initialized to (0,0)

PUBLIC __input_amx_mouse_x, __input_amx_mouse_y

defvars -1
{
   __input_amx_mouse_x         ds.b 2
   __input_amx_mouse_y         ds.b 2
}

; kempston mouse coordinate will be initialized to (0,0)

PUBLIC __input_kempston_mouse_x, __input_kempston_mouse_y
PUBLIC __input_kempston_mouse_rawx, __input_kempston_mouse_rawy

defvars -1
{
   __input_kempston_mouse_x      ds.b 2
   __input_kempston_mouse_y      ds.b 2
   __input_kempston_mouse_rawx   ds.b 1
   __input_kempston_mouse_rawy   ds.b 1
}

