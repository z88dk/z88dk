
   ; write to bit device

   IF __SOUND_BIT_METHOD = 1
   
      out (__SOUND_BIT_PORT),a
   
   ENDIF
   
   IF __SOUND_BIT_METHOD = 2

      exx
      out (c),a
      exx
   
   ENDIF
   
   IF __SOUND_BIT_METHOD = 3
   
      ld (__SOUND_BIT_PORT),a
   
   ENDIF
