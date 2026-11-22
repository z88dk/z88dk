SECTION code_clib
SECTION code_compress_aplib

PUBLIC __aplib_getbitbc

EXTERN __aplib_getbit

__aplib_getbitbc:

   sla c
   rl b
   call __aplib_getbit
   ret z
   inc bc
   ret
