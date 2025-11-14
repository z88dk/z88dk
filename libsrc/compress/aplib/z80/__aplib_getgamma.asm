SECTION code_clib
SECTION code_compress_aplib

PUBLIC __aplib_getgamma

EXTERN __aplib_getbit, __aplib_getbitbc

__aplib_getgamma:

   ld bc,1
   
l0:

   call __aplib_getbitbc
   call __aplib_getbit
   jr nz, l0
   ret
