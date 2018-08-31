

#include <stdint.h>

struct esx_drvapi
{
   union
   {
      uint16_t bc;
      struct
      {
         uint8_t driver;
         uint8_t function;
      }
      call;
   };

   uint16_t de;
   uint16_t hl;
};

struct esx_drvapi rtc = { {1}, 2, 3 };

struct esx_drvapi2
{
   struct
   {
      uint16_t bc;
      struct
      {
         uint8_t driver;
         uint8_t function;
      }
      call;
   };

   uint16_t de;
   uint16_t hl;
};

struct esx_drvapi2 rtc2 = { {1, {2, 3}}, 4, 5 };

