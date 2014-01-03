
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void forward_list_init(void *p)
;
; Create an empty forward_list_ext in the four bytes of memory
; provided.
;
; ===============================================================

XLIB asm_forward_list_ext_init

LIB asm_forward_list_init

asm_forward_list_ext_init:

   ; enter : hl = void *p
   ;
   ; exit  : hl = void *p + 4
   ;         de = void *p = forward_list_ext *list
   ;
   ; uses  : af, de, hl

   call asm_forward_list_init

   ld (hl),e
   inc hl
   ld (hl),d                   ; forward_list_ext->tail = & forward_list_ext->head
   inc hl
   
   ret
