/* **************************************************
   SMSlib - C programming library for the SMS/GG
   ( part of devkitSMS - github.com/sverx/devkitSMS )
   ************************************************** */

#define HI(x)                 (((x)>>8))
#define LO(x)                 ((unsigned char)(x))

#define DISABLE_INTERRUPTS    __asm di __endasm
#define ENABLE_INTERRUPTS     __asm ei __endasm

#define WAIT_VRAM             __asm nop \
                                    nop \
                                    nop __endasm

#define SMS_SATAddress    ((unsigned int)0x7F00)

#ifndef MAXSPRITES
#define MAXSPRITES        64
#endif

/* declare various I/O ports in SDCC z80 syntax */
/* define VDPControlPort */
__sfr __at 0xBF VDPControlPort;
/* define VDPStatusPort */
__sfr __at 0xBF VDPStatusPort;
/* define VDPDataPort */
__sfr __at 0xBE VDPDataPort;
/* define VDPVcounter */
__sfr __at 0x7E VDPVCounterPort;
/* define VDPHcounter */
__sfr __at 0x7F VDPHCounterPort;

inline void SMS_write_to_VDPRegister (unsigned char VDPReg, unsigned char value) {
  // INTERNAL FUNCTION
  unsigned char v=value;
  DISABLE_INTERRUPTS;
  VDPControlPort=v;
  VDPControlPort=VDPReg|0x80;
  ENABLE_INTERRUPTS;
}

inline void SMS_byte_to_VDP_data (unsigned char data) {
  // INTERNAL FUNCTION
  VDPDataPort=data;
}

inline void SMS_byte_array_to_VDP_data (const unsigned char *data, unsigned int size) {
  // INTERNAL FUNCTION
  do {
    VDPDataPort=*(data++);
  } while (--size);
}

inline void SMS_byte_brief_array_to_VDP_data (const unsigned char *data, unsigned char size) {
  // INTERNAL FUNCTION
  do {
    VDPDataPort=*(data++);
  } while (--size);
}

#define ASM_DE_TO_VDP_CONTROL  \
  __asm                        \
    ld c,#_VDPControlPort      \
    di                         \
    out (c),e                  \
    out (c),d                  \
    ei                         \
  __endasm
  // writes a control word to VDP
  // it's INTerrupt safe (DI/EI around control port writes)
  // controlword in DE

#define ASM_L_TO_VDP_DATA                                 \
  __asm                                                   \
    ld a,l                                                \
    out (_VDPDataPort),a      ; 11                        \
  __endasm
  // writes one byte to VDP
  // it's VRAM safe since it's used by SMS_setColor which adds enough overhead (call/ret)
  // byte will be passed in L

#define ASM_SHORT_XFER_TO_VDP_DATA                                \
  __asm                                                           \
    ld c,#_VDPDataPort                                            \
1$: outi                       ; 16                               \
    jr nz,1$                   ; 12 = 28 *VRAM SAFE*              \
  __endasm
  // writes B bytes from (HL) on to VDP
  // it's VRAM safe (at least 26 cycles between writes)

#define ASM_LD_DE_IMM(imm)            \
  __asm                               \
    ld de,imm                         \
  __endasm

#define ASM_LD_B_IMM(imm)             \
  __asm                               \
    ld b,imm                          \
  __endasm
