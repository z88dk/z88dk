
; void p_forward_list_push_front(p_forward_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_push_front

EXTERN p_forward_list_insert_after

defc p_forward_list_push_front = p_forward_list_insert_after

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_push_front
defc _p_forward_list_push_front = p_forward_list_push_front
ENDIF

