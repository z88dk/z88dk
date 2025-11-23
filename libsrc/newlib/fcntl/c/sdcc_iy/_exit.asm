
; _Noreturn void _exit(int status)

SECTION code_clib
SECTION code_fcntl

PUBLIC __exit

EXTERN __exit_fastcall

__exit:

   pop hl
   pop hl
   
   jp __exit_fastcall
