/*! \addtogroup Flash **/
/*@{*/

/**

  \file flash_initialise.c
  \name Flash Initialise

**/

#include <drivers/flash.h>
#include <ATJ2085_Ports.h>
#include <drivers/flash/flash_defs.h>

unsigned char FLASH_NandFlashTypeCE1 = 0;
unsigned char FLASH_FlashBank_low;
unsigned char FLASH_FlashBank_high;

unsigned char FLASH_ManufacturerID = 0;
unsigned char FLASH_DeviceID = 0;
unsigned char FLASH_PageSize = 0;


/*!******************************************************************************/
void ReadStatusNANDFlash( void )
/*!
** \brief
**
** \param
**
** \return  in a
**           FLASH_STATUS_OK               (0x00) Flash OK
**           FLASH_STATUS_WRITE_PROTECTED  (0x02) Write Protected
**           FLASH_STATUS_ERROR            (0x03) Error
**
** \author  Aaron Blanchard
** \date    26/01/2006
**
*********************************************************************************/
{
#asm
    push    de
    ld      a, 0x60
ReadStatusNANDFlash_Delay:
    dec     a
    jr      nz, ReadStatusNANDFlash_Delay

    ld      a, FLASH_COMMAND_READ_STATUS_REGISTER
    out     (NAND_CMD_REG),a
    ld      d, a
ReadStatusNANDFlash_BusyWait:
    ld      a, (0x8002)
    bit     FLASH_STATUS_BLOCK_READ_READY, a
    jr      nz, ReadStatusNANDFlash_Ready
    dec     de
    ld      a, d
    or      e
    jr      nz, ReadStatusNANDFlash_BusyWait
ReadStatusNANDFlash_Error:
    ld      a, FLASH_COMMAND_RESET
    out     (NAND_CMD_REG), a
    ld      a, FLASH_STATUS_ERROR
    jr      ReadStatusNANDFlash_Exit

ReadStatusNANDFlash_WriteProtected:
    ld      a, FLASH_STATUS_WRITE_PROTECTED
    jr      ReadStatusNANDFlash_Exit

ReadStatusNANDFlash_Ready:
    ld      a, (0x8123)
    bit     0, a
    jr      nz, ReadStatusNANDFlash_Error
    rla                                                     ; If bit7 == 0 then write protected
    jr      nc, ReadStatusNANDFlash_WriteProtected
    xor     a
ReadStatusNANDFlash_Exit:
    pop     de
#endasm
}


/*!******************************************************************************/
void ResetNANDFlash( void )
/*!
** \brief   Reset the NAND Flash
**
** \param
**
** \return  in a
**           FLASH_STATUS_OK               (0x00) Flash OK
**           FLASH_STATUS_WRITE_PROTECTED  (0x02) Write Protected
**           FLASH_STATUS_ERROR            (0x03) Error
**
** \author  Aaron Blanchard
** \date    26/01/2006
**
*********************************************************************************/
{
#asm
    ld      a, FLASH_COMMAND_RESET
    out     (NAND_CMD_REG), a
    call    _ReadStatusNANDFlash
    push    af
    ld      a, FLASH_COMMAND_DISABLE
    out     (NAND_CMD_REG), a
    pop     af
#endasm
}


/*!******************************************************************************/
void DisableNANDFlash( void )
/*!
** \brief   Disable the NAND Flash
**
** \param
**
** \return
**
** \author  Aaron Blanchard
** \date    26/01/2006
**
*********************************************************************************/
{
#asm
    push    af
    ld      a, FLASH_COMMAND_DISABLE
    out     (NAND_CMD_REG),a
    xor     a
    out     (NAND_ENABLE_REG), a
    out     (NAND_CEMODE_REG), a
    ld      a, (_FLASH_FlashBank_low)
    out     (EM_PAGE_LO_REG), a
    ld      a, (_FLASH_FlashBank_high)
    out     (EM_PAGE_HI_REG), a
    ei
    pop     af
#endasm
}


/*!******************************************************************************/
void EnableNANDFlashBank( void )
/*!
** \brief   Enable the NAND Flash
**
** \param   reg b - which flash bank to enable
**
** \return
**
** \author  Aaron Blanchard
** \date    26/01/2006
**
*********************************************************************************/
{
#asm
    di
    in      a, (EM_PAGE_LO_REG)
    ld      (_FLASH_FlashBank_low), a
    in      a, (EM_PAGE_HI_REG)
    ld      (_FLASH_FlashBank_high), a
    xor     a
    out     (EM_PAGE_LO_REG), a
    ld      a, b
    add     a, a
    add     a, a
    add     a, a
    out     (EM_PAGE_HI_REG), a
    ld      a, NAND_CEMODE_FLASH_TYPE
    out     (NAND_CEMODE_REG), a
EnableNANDFlashBank_Loop:
    add     a, a
    djnz    EnableNANDFlashBank_Loop
    out     (NAND_ENABLE_REG), a
#endasm
}


/*!******************************************************************************/
void ReadFlashID ( void )
/*!
** \brief   Read the Flash ID of the specified bank
**
** \param   None
**
** \return  reg b - Manufacturer Code
**              c - Device ID
**              d - Don't care Register
**              e - Page size, Block size etc.
**
** \author  Aaron Blanchard
** \date    26/01/2006
**
*********************************************************************************/
{
#asm
    ld      a,FLASH_COMMAND_READID
    jr      ReadFlashID_Start

ReadFlashID_ToshibaExtended:
    ld      a,FLASH_COMMAND_READID_TOSHIBA_EXTENDED
ReadFlashID_Start:                                  
    push    hl
    ld      h,80h                                       ; 0x8000 is where to read the ID from
    out     (NAND_CMD_REG),a
    ld      b,60h                                       ; Small delay
ReadFlashID_Delay:                                  
    djnz    ReadFlashID_Delay
    ld      a,(hl)
    ld      b,a                                         ; Manufacturer Code
    ld      (_FLASH_ManufacturerID),a
    ld      a,(hl)
    ld      c,a                                         ; Device ID
    ld      (_FLASH_DeviceID),a
    ld      a,(hl)
    ld      d,a                                         ; Do not Care
    ld      a,(hl)
    ld      e,a                                         ; Page size, Block size,
    ld      (_FLASH_PageSize),a
    pop     hl
#endasm
}


/*!******************************************************************************/
void DetermineFlashType ( void )
/*!
** \brief   Determine the flash type in the specified bank
**
** \param   reg b - which flash bank to enable
**
** \return  reg a -
**              FLASH_TYPE_ERROR (0xff) Unknown Flash Type or error
**              0x00  Single density flash
**              0x01
**              0x02  Dual density flash, double the amount of blocks in hl
**          ret hl -
**              Number of Blocks?
**
** \author  Aaron Blanchard
** \date    26/01/2006
**
*********************************************************************************/
{
#asm
    push    bc
    push    de
    call    _EnableNANDFlashBank
    call    _ResetNANDFlash
    cp      FLASH_STATUS_ERROR
    jp      z, DetermineFlashType_Exit
    call    _ReadFlashID
    ld      a, b
    cp      FLASH_TYPE_TOSHIBA
    jr      z, DetermineFlashType_ToshibaCheck
    cp      FLASH_TYPE_SAMSUNG
    jr      z, DetermineFlashType_Generic_Check
    cp      FLASH_TYPE_HYNIX
    jr      z, DetermineFlashType_Generic_Check
    cp      FLASH_TYPE_STMICRO
    jr      z, DetermineFlashType_Generic_Check
    jp      DetermineFlashType_ErrorUnknownFlash

DetermineFlashType_ToshibaCheck:
    ld      a, c
    cp      FLASH_TYPE_32Mbyte
    jp      z, DetermineFlashType_Toshiba32MByte
    cp      FLASH_TYPE_64Mbyte
    jp      z, DetermineFlashType_Toshiba64MByte
    cp      FLASH_TYPE_128Mbyte
    jp      z, DetermineFlashType_Tosh128MB
    cp      FLASH_TYPE_128Mbyte2
    jp      z, DetermineFlashType_Tosh128MB2
    cp      FLASH_TYPE_256Mbyte2
    jp      z, DetermineFlashType_Toshiba256MByte
    jp      DetermineFlashType_ErrorUnknownFlash
;
DetermineFlashType_Toshiba32MByte:
    ld      hl, FLASH_SECTORSIZE_0x00FC
    ld      a, FLASH_DENSITY_SINGLE
    jp      DetermineFlashType_Exit
;
DetermineFlashType_Toshiba64MByte:
    ld      hl, FLASH_SECTORSIZE_0x01F8
    ld      a, FLASH_DENSITY_SINGLE
    jp      DetermineFlashType_Exit
;
DetermineFlashType_Tosh128MB:
    ld      hl, FLASH_SECTORSIZE_0x03F0
    call    ReadFlashID_ToshibaExtended
    ld      a,b
    cp      0x24
    ld      a, FLASH_DENSITY_SINGLE
    jp      nz, DetermineFlashType_Exit
    ld      a, FLASH_DENSITY_SPECIAL_TOSHIBA
    jp      DetermineFlashType_Exit
;
DetermineFlashType_Tosh128MB2:
    ld      hl, FLASH_SECTORSIZE_0x03F0
    ld      a, FLASH_DENSITY_DUAL
    jp      DetermineFlashType_Exit
;
DetermineFlashType_Toshiba256MByte:
    ld      hl, FLASH_SECTORSIZE_0x07E0
    ld      a, FLASH_DENSITY_DUAL
    jp      DetermineFlashType_Exit
;
DetermineFlashType_Generic_Check:
    ld  a,c
    cp  FLASH_TYPE_32Mbyte
    jp  z,DetermineFlashType_32MByte
    cp  FLASH_TYPE_64Mbyte
    jp  z,DetermineFlashType_64MByte
    cp  FLASH_TYPE_128Mbyte
    jp  z,DetermineFlashType_128MByte
    cp  FLASH_TYPE_128Mbyte2
    jp  z,DetermineFlashType_128MByte
    cp  FLASH_TYPE_256Mbyte
    jp  z,DetermineFlashType_256MByte
    cp  FLASH_TYPE_256Mbyte2
    jp  z,DetermineFlashType_256MByte
    cp  FLASH_TYPE_512Mbyte
    jp  z,DetermineFlashType_512MByte
    cp  FLASH_TYPE_1024Mbyte
    jp  z,DetermineFlashType_1024MByte
    cp  FLASH_TYPE_2048Mbyte
    jp  z,DetermineFlashType_2048MByte
    jp  DetermineFlashType_ErrorUnknownFlash
;
DetermineFlashType_32MByte:
    ld  hl,FLASH_SECTORSIZE_0x00FC
    ld  a,FLASH_DENSITY_SINGLE
    jp  DetermineFlashType_Exit
;
DetermineFlashType_64MByte:
    ld  hl,FLASH_SECTORSIZE_0x01F8
    ld  a,FLASH_DENSITY_SINGLE
    jp  DetermineFlashType_Exit
;
DetermineFlashType_128MByte:
    cp  79h
    jp  nz,DetermineFlashType_128MByte_X2
    ld  hl,FLASH_SECTORSIZE_0x03F0
    ld  a,FLASH_DENSITY_SINGLE
    jp  DetermineFlashType_Exit
;
DetermineFlashType_128MByte_X2:
    ld      hl, FLASH_SECTORSIZE_0x03F0
    ld      a, FLASH_DENSITY_DUAL
    jp      DetermineFlashType_Exit
;
DetermineFlashType_256MByte:
    ld      hl, FLASH_SECTORSIZE_0x07E0
    cp      71h
    jp      nz, DetermineFlashType_256MByte_X2
    ld      a, FLASH_DENSITY_SINGLE
    jp      DetermineFlashType_Exit

DetermineFlashType_256MByte_X2:
    ld      a, FLASH_DENSITY_DUAL
    jp      DetermineFlashType_Exit

DetermineFlashType_512MByte:
    ld      hl, FLASH_SECTORSIZE_0x0FC0
    ld      a, e
    cp      0x15
    ld      a, FLASH_DENSITY_DUAL
    jp      z, DetermineFlashType_Exit
    ld      a, FLASH_DENSITY_SINGLE
    jp      DetermineFlashType_Exit

DetermineFlashType_1024MByte:
    ld      hl, FLASH_SECTORSIZE_0x1080
    ld      a, FLASH_DENSITY_DUAL
    jp      DetermineFlashType_Exit

DetermineFlashType_2048MByte:
    ld      hl, FLASH_SECTORSIZE_0x2100
    ld      a, FLASH_DENSITY_DUAL
    jp      DetermineFlashType_Exit

DetermineFlashType_ErrorUnknownFlash:
    ld      a, FLASH_TYPE_ERROR

DetermineFlashType_Exit:
    call    _DisableNANDFlash
    pop     de
    pop     bc
#endasm
}

/*!******************************************************************************/
void DetectNANDDevices( void )
/*!
** \brief   Check CE1, CE6, CE5, CE2 for valid NAND Flash devices
**          CE1 is master, if this not present then assume no flash whatsoever
**
** \param
**
** \return  reg a -
**              0 Success
**              FLASH_TYPE_ERROR    (0ffh)  Error
**              FLASH_TYPE_ERROR2   (003h)  Error**
**
** \author  Aaron Blanchard
** \date    26/01/2006
**
*********************************************************************************/
{
#asm
    push    bc
    push    de
    push    hl
    push    ix

    xor     a
    ld      (_FLASH_NandFlashTypeCE1),a
    ld      b, NAND_ENABLE_CE1
    call    _DetermineFlashType
    cp      FLASH_TYPE_ERROR
    jr      z,DetectNANDDevices_Exit    ; No Device in CE1 - instant failure
    cp      FLASH_TYPE_ERROR2
    jr      z, DetectNANDDevices_Exit   ; No Device in CE1 - instant failure
    ld      (_FLASH_NandFlashTypeCE1),a     ; Set CE1 NAND Flash type
DetectNANDDevices_Exit:

    pop     ix
    pop     hl
    pop     de
    pop     bc
#endasm
}


/*!******************************************************************************/
void FLASH_Initialise( void )
/*!
** \brief   Initialise flash
**
** \param
**
** \return
**
** \author  Aaron Blanchard
** \date    26/01/2006
**
*********************************************************************************/
{
    DetectNANDDevices();
}
