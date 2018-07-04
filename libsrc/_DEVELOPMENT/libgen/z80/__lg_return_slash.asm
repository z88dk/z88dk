SECTION code_string

PUBLIC __lg_return_slash

__lg_return_slash:

   ld hl,slash_s
   ret

slash_s:

   defm "/", 0
