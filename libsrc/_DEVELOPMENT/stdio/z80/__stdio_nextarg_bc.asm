
XLIB __stdio_nextarg_bc

__stdio_nextarg_bc:

   ; return next 16-bit parameter from parameter list
   ;
   ; enter : hl = void *stack_param
   ;
   ; exit  : bc = 16-bit parameter
   ;         hl = hl - 2
   ;
   ; uses  : bc, hl

;******************************
IF __PARAM_ORDER_RL
;******************************

   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl

;******************************
ELSE
;******************************

   ld b,(hl)
   dec hl
   ld c,(hl)
   dec hl

;******************************
ENDIF
;******************************
   
   ret
