
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FWRITE

asm_fwrite_unlocked:

   ; enter : ix = FILE *
   ;         hl = char *ptr
   ;         bc = size
   ;         de = nmemb
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = number of records successfully transmitted
   ;            de = char *p = ptr following all records
   ;            bc = size
   ;            carry reset
   ;
   ;         fail
   ;
   ;            de = char *p (ptr to current record not transmitted completely)
   ;            bc = number of bytes in last incomplete record transmitted
   ;            hl = number of records successfully transmitted
   ;            carry set, errno set
   ;
   ; uses  : all except ix
