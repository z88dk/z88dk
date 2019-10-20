

#include <drivers/flash.h>
#include <ATJ2085_Ports.h>
#include <drivers/flash/flash_defs.h>



/*!******************************************************************************/
static void FlashWrite2Bytes( void )
/*!
** \brief   Write command held in register b 
**
** \param   reg hl - address of first command to write to flash
**
** \return  
**
** \author  Aaron Blanchard
** \date    26/01/2006
**
*********************************************************************************/
{
#asm
    ld      d,0x80                                          ; 0x80XX - where to write
    ld      a,FLASH_COMMAND_READ_STATUS_REGISTER
    out     (NAND_CMD_REG),a
    xor     a
    out     (EM_PAGE_LO_REG),a
    inc     a
    out     (EM_PAGE_LO_REG),a
    ld      a,b
    ld      (de),a
    ld      a,2
    out     (EM_PAGE_LO_REG),a
    ldi                                                     ; Load and Increment   |[DE]=[HL],HL=HL+1,# 
    ldi
#endasm
}


/*!******************************************************************************/
static void WriteColumnRowAddress_5Bytes( void )
/*!
** \brief   Write to flash row * column address
**
** \param   hl - address of first byte to write
**
** \return  
**
** \author  Aaron Blanchard
** \date    26/01/2006
**
*********************************************************************************/
{
#asm
    call    _FlashWrite2Bytes
    ldi
    ldi
    ldi
    xor     a
    out     (EM_PAGE_LO_REG),a
#endasm
}



/*!******************************************************************************/
void FLASH_PageRead( void )
/*!
** \brief   Read one page.  Setup column and row addresses (Data to be strobed 
**          out on completion?)
**
** \param   reg hl - start of 5 bytes command to write to flash
**
** \return  reg hl - 
**
** \author  Aaron Blanchard
** \date    26/01/2006
**
*********************************************************************************/
{
#asm
    push        bc
    push        de
    ld          b,FLASH_COMMAND1_READ1
    call        _WriteColumnRowAddress_5Bytes
    ld          a,FLASH_COMMAND2_READ1
    out         (NAND_CMD_REG),a
    ld          b,40h
FlashPageRead_Delay:        
    djnz        FlashPageRead_Delay
    ld          hl,(0x8123)
    pop         de
    pop         bc
    xor         a
#endasm
}


