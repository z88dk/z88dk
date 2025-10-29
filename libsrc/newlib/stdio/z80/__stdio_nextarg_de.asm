
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_nextarg_de

__stdio_nextarg_de:

   ; return next 16-bit parameter from parameter list
   ;
   ; enter : hl = void *stack_param
   ;
   ; exit  : de = 16-bit parameter
   ;         hl = hl - 2
   ;
   ; uses  : de, hl

;******************************
IF __SDCC | __SDCC_IX | __SDCC_IY
;******************************

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl

;******************************
ELSE
;******************************

   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl

;******************************
ENDIF
;******************************
   
   ret
