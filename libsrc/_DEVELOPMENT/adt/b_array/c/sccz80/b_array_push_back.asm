
; size_t b_array_push_back(b_array_t *a, int c)

PUBLIC b_array_push_back

EXTERN b_array_append

;defc b_array_push_back = b_array_append

b_array_push_back:

   jp b_array_append
