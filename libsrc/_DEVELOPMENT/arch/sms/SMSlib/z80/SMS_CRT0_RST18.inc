IF __SMSLIB_ISRST_SMSCRT0RST18 = 0

   EXTERN _SMS_crt0_RST18_call
   call   _SMS_crt0_RST18_call

ELSE

   rst 0x18

ENDIF
