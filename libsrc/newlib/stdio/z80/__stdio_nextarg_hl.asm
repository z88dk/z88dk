
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_nextarg_hl

__stdio_nextarg_hl:

   ; return next 16-bit parameter from parameter list
   ;
   ; enter : hl = void *stack_param
   ;
   ; exit  : hl = 16-bit parameter
   ;          a = l
   ;
   ; uses  : a, hl

;******************************
IF __SDCC | __SDCC_IX | __SDCC_IY
;******************************

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

;******************************
ELSE
;******************************

   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   
   ld a,l

;******************************
ENDIF
;******************************

   ret
