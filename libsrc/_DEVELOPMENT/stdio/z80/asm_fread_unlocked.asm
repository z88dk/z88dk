
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_FREAD

asm_fread_unlocked:

   ; enter : ix = FILE *
   ;         de = char *ptr
   ;         bc = size
   ;         hl = nmemb
   ;
   ; exit  : ix = FILE *
   ;         hl = number of records successfully read
   ;
   ;         success
   ;
   ;            de = char *p = ptr following all records
   ;            bc = size
   ;            carry reset
   ;
   ;         fail
   ;
   ;            de = char *p (ptr to current record not read completely)
   ;            bc = number of bytes of incomplete record read
   ;            carry set, errno set
   ;
   ; uses  : all except ix
