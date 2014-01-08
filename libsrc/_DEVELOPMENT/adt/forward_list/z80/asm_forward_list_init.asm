
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void forward_list_init(void *p)
;
; Create an empty forward_list in the two bytes of memory
; provided.
;
; ===============================================================

XLIB asm_forward_list_init
XDEF asm_forward_list_clear

LIB l_setmem_hl

asm_forward_list_init:
asm_forward_list_clear:

   ; enter : hl = void *p
   ;
   ; exit  : hl = void *p + 2
   ;         de = void *p = forward_list *list
   ;
   ; uses  : af, de, hl

   ld e,l
   ld d,h
   
   xor a
   jp l_setmem_hl - 4          ; forward_list->next = 0
