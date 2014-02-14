
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int atexit(void (*func)(void))
;
; Register the function to run when exit() is called.
; Return 0 if successful.
;
; ===============================================================

XLIB asm_atexit
XDEF asm0_atexit

LIB error_mc, error_znc

asm_atexit:

   ; enter : hl = func
   ;
   ; exit  : hl = 0 and carry reset if successful
   ;         hl = nonzero and carry set if unsuccessful
   ;
   ; uses  : af, bc, de, hl

   ex de,hl                    ; de = func
   
   ld hl,__exit_stack
   ld a,__EXITSTACK_SZ

asm0_atexit:

   cp (hl)                     ; space for another function?
   jp z, error_mc
   jp c, error_mc
   inc (hl)
   
   ld c,(hl)
   ld b,0
   inc hl
   add hl,bc
   add hl,bc
   
   ld (hl),e
   inc hl
   ld (hl),d
   
   jp error_znc                ; success
