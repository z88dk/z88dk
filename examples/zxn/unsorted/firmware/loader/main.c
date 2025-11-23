/*
TBBlue / ZX Spectrum Next project

Copyright (c) 2015 Fabio Belavenuto & Victor Trucco

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <arch/zxn.h>
#include <stdlib.h>
#include <string.h>
#include <input.h>
#include <z80.h>

#include "mmc.h"
#include "fat.h"
#include "init.h"
#include "vdp.h"

////////////
// DEBUGGING
////////////

// #define DEBUG(x) ZXN_NEXTREGA(REG_DEBUG, x);
#define DEBUG(x) 

////////////////////////////
// FIRMWARE MODULES BY INDEX
////////////////////////////

#define MODULE_BOOT_INDEX     0
#define MODULE_EDITOR_INDEX   1
#define MODULE_UPDATER_INDEX  2
#define MODULE_CORES_INDEX    3

////////////
// FILENAMES
////////////

#define FN_UPDATE    "TBBLUE  TBU"
#define FN_FIRMWARE  "TBBLUE  FW "

////////////
// VARIABLES
////////////

unsigned char buffer[512];

struct machine_s
{
   unsigned char id;
   unsigned char version;
   unsigned char sub;
};

struct machine_s machine;

unsigned char reset_power_on;
unsigned char buttons;

unsigned char module;

unsigned char have_tbu;
unsigned char want_update;

/////////
// ERRORS
/////////

void error(unsigned char *s)
{
   IO_FE = INK_RED;
   
   vdp_gotoxy(16 - strlen(s)/2, 12);
   vdp_prints(s);

   DisableCard();
   exit(1);   // crt performs infinite loop on exit
}

///////
// MAIN
///////

void main(void)
{
   static fileTYPE file;
   
   DEBUG(1);
   
   // clear screen
   
   IO_FE = INK_BLACK;
   
   memset((void *)0x4000, 0, 6144);
   memset((void *)0x5800, INK_WHITE | PAPER_BLACK | BRIGHT, 768);
   
   // hardware id
   
   machine.id = ZXN_READ_REG(REG_MACHINE_ID);
   
   machine.version = ZXN_READ_REG(REG_VERSION);
   machine.sub = ZXN_READ_REG(REG_SUB_VERSION);
   
   // button state
   
   reset_power_on = ZXN_READ_REG(REG_RESET) & RR_POWER_ON_RESET;
   buttons = ZXN_READ_REG(REG_ANTI_BRICK) & (RAB_BUTTON_DIVMMC | RAB_BUTTON_MULTIFACE);
   
   DEBUG(2);

   // speed up if this is a zx next
   
   if ((machine.id == RMI_ZXNEXT) || (machine.id == RMI_ZXNEXT_AB))
      ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);

   // initialize hw
   
   init();
   
   DEBUG(3);
   
   // initialize sd card
   
   {
      unsigned char i;

      for (i = 10; i; --i)
      {
         if (MMC_Init() && FindDrive())
            break;
      
         z80_delay_ms(10);
      }
   
      if (i == 0)
         error("error 0: sd card initialization");
   }
   
   DEBUG(4);
   
   // tbu file present ?

   if (FileOpen(&file, FN_UPDATE))
      have_tbu = 1;
   
   DEBUG(5);
   
   // anti-brick reboots as normal if both buttons not pressed
   
   if (machine.id == RMI_ZXNEXT_AB)
   {
      if (buttons == (RAB_BUTTON_DIVMMC | RAB_BUTTON_MULTIFACE))
         want_update = 1;
      else
      {
         ZXN_NEXTREG(REG_ANTI_BRICK, RAB_COMMAND_NORMALCORE);   // load normal core
         exit(1);                                               // never gets here
      }
   }
   
   DEBUG(6);
   
   // firmware file
   
   if (!FileOpen(&file, FN_FIRMWARE))
      error("error 1: opening TBBLUE.FW file");
   
   if (!FileRead(&file, buffer))
      error("error 2: reading TBBLUE.FW file");
   
   DEBUG(7);
   
   // what are we doing ?
   
   module = MODULE_BOOT_INDEX;
   
   if (in_key_pressed(IN_KEY_SCANCODE_SPACE))
      module = MODULE_EDITOR_INDEX;
   
   if (have_tbu && (want_update || in_key_pressed(IN_KEY_SCANCODE_u)))
      module = MODULE_UPDATER_INDEX;
   
   if (in_key_pressed(IN_KEY_SCANCODE_c))
      module = MODULE_CORES_INDEX;

   // skip forward through firmware file to correct module and load it
   
   {
      unsigned int block_offset;
      unsigned int block_length;
      
      DEBUG(8);
      
      // determine offset and length of selected module
      
      block_offset = *(unsigned int *)(&buffer[module*4]);
      block_length = *(unsigned int *)(&buffer[module*4+2]);
      
      // move past offset
      
      while (block_offset--)
         if (!FileRead(&file, buffer))
            error("error 3: seeking TBBLUE.FW file");
      
      DEBUG(9);
      
      // read module into memory
      
      for (unsigned int mem = 0x6000; block_length--; mem += 512)
         if (!FileRead(&file, (void *)mem))
            error("error 4: loading TBBLUE.FW file");
   }
   
   DEBUG(10);
   
   DisableCard();
   
   // return to 3.5MHz
   
   if ((machine.id == RMI_ZXNEXT) || (machine.id == RMI_ZXNEXT_AB))
      ZXN_NEXTREG(REG_TURBO_MODE, RTM_3MHZ);
   
   // run the module just loaded
   
   __asm
      jp 0x6000      
   __endasm;

}
