#ifndef __ARCH_ATTACHE_H__
#define __ARCH_ATTACHE_H__

#include <sys/compiler.h>
#include <cpm.h>



//////////////////////////////////////////////////////////////////
//    OTRONA ATTACHE' BIOS functions
//////////////////////////////////////////////////////////////////


// Use '0' to disable the keyboard click, otherwise specify a tone
extern void __LIB__  kbd_click(char *sound) __z88dk_fastcall;

// several keyboard tones
#define KBD_CLICK   "\x01\x04\x00\x00\x0F\x0F\x0F\x00\x80\x47\x1D\x20\xF6\xAF\xED"
#define KBD_BEEP_HI "\x02\x02\x00\x00\x0F\x0F\x0F\x32\x54\x20\x32\x56\x20\x3E\x25"
#define KBD_BEEP_LO "\x02\x00\x00\x00\x0F\x0F\x0F\xF8\x1F\x00\xFE\x00\x00\x00\x00"
// New non_standard sounds
#define KBD_SND_LO  "\x03\x02\x00\x00\x0F\x0F\x0F\x32\x80\x47\x1D\x20\xF6\xAF\xED"

// 'VALET' (pop-up configuration and hardcopy tool), usually opens by pressing CTRL-ESC
#define valet_enable() asm("ld\thl,0xDA81\nld\t(hl),0\n");
#define valet_disable() asm("ld\thl,0xDA81\nld\t(hl),0xFF\n");
#define enter_valet() asm("ld\thl,0xDA81\nld\t(hl),0\nld\thl,0xDA83\nld\t(hl),0xFF\n");


//////////////////////////////////////////////////////////////////
//    OTRONA ATTACHE' CMOS settings (valid after reboot only)
//////////////////////////////////////////////////////////////////

// Set the sound volume level
#define cmos_volume(a)  {bios(BIOS_CONOUT,27,0);bios(BIOS_CONOUT,64,0);bios(BIOS_CONOUT,6,0);bios(BIOS_CONOUT,a,0);}

// Set the keyboard click
#define cmos_kbclick(a)  {bios(BIOS_CONOUT,27,0);bios(BIOS_CONOUT,64,0);bios(BIOS_CONOUT,9,0);bios(BIOS_CONOUT,a,0);}

// Enable/disable BELL
#define cmos_bell(a)  {bios(BIOS_CONOUT,27,0);bios(BIOS_CONOUT,64,0);bios(BIOS_CONOUT,5,0);bios(BIOS_CONOUT,a,0);}

// 50/60 Hz flag
#define cmos_50hz(a)  {bios(BIOS_CONOUT,27,0);bios(BIOS_CONOUT,64,0);bios(BIOS_CONOUT,2,0);bios(BIOS_CONOUT,a,9);}
#define cmos_60hz(a)  {bios(BIOS_CONOUT,27,0);bios(BIOS_CONOUT,64,0);bios(BIOS_CONOUT,2,0);bios(BIOS_CONOUT,a,0);}

// Shift lock status at startup
#define cmos_sh_lock_on(a)  {bios(BIOS_CONOUT,27,0);bios(BIOS_CONOUT,64,0);bios(BIOS_CONOUT,0x0e,0);bios(BIOS_CONOUT,a,15);}
#define cmos_sh_lock_off(a)  {bios(BIOS_CONOUT,27,0);bios(BIOS_CONOUT,64,0);bios(BIOS_CONOUT,0x0e,0);bios(BIOS_CONOUT,a,0);}



#endif
