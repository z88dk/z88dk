SECTION code_string

PUBLIC __lg_return_dot

__lg_return_dot:

   ld hl,dot_s
   ret

dot_s:

   defm ".", 0
