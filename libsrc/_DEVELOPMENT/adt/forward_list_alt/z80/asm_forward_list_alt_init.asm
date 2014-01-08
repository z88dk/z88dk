
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void forward_list_alt_init(void *p)
;
; Create an empty forward_list_ext in the four bytes of memory
; provided.
;
; ===============================================================

XLIB asm_forward_list_alt_init
XDEF asm_forward_list_alt_clear

LIB asm_forward_list_init

asm_forward_list_alt_init:
asm_forward_list_alt_clear:

   ; enter : hl = void *p
   ;
   ; exit  : hl = void *p + 4
   ;         de = void *p = forward_list_alt *list
   ;
   ; uses  : af, de, hl
   
   call asm_forward_list_init
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; forward_list_alt->tail = & forward_list_alt->head
   inc hl
   
   ret
