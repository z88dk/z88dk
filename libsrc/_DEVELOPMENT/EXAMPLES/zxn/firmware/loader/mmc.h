/*
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

#ifndef MMC_H
#define MMC_H

#include <arch/zxn.h>

#define CARDTYPE_NONE 0
#define CARDTYPE_MMC  1
#define CARDTYPE_SD   2
#define CARDTYPE_SDHC 3

#define EnableCard()  (IO_SPI_CONTROL = 0xFE)
#define DisableCard() (IO_SPI_CONTROL = 0xFF)

#define SPI_slow() 
#define SPI_fast() 

// MMC commandset

#define     CMD0        0x40        /*Resets the multimedia card*/
#define     CMD1        0x41        /*Activates the card's initialization process*/
#define     CMD2        0x42        /*--*/
#define     CMD3        0x43        /*--*/
#define     CMD4        0x44        /*--*/
#define     CMD5        0x45        /*reseved*/
#define     CMD6        0x46        /*reserved*/
#define     CMD7        0x47        /*--*/
#define     CMD8        0x48        /*reserved*/
#define     CMD9        0x49        /*CSD : Ask the selected card to send its card specific data*/
#define     CMD10       0x4a        /*CID : Ask the selected card to send its card identification*/
#define     CMD11       0x4b        /*--*/
#define     CMD12       0x4c        /*--*/
#define     CMD13       0x4d        /*Ask the selected card to send its status register*/
#define     CMD14       0x4e        /*--*/
#define     CMD15       0x4f        /*--*/
#define     CMD16       0x50        /*Select a block length (in bytes) for all following block commands (Read:between 1-512 and Write:only 512)*/
#define     CMD17       0x51        /*Reads a block of the size selected by the SET_BLOCKLEN command, the start address and block length must be set so that the data transferred will not cross a physical block boundry*/
#define     CMD18       0x52        /*--*/
#define     CMD19       0x53        /*reserved*/
#define     CMD20       0x54        /*--*/
#define     CMD21       0x55        /*reserved*/
#define     CMD22       0x56        /*reserved*/
#define     CMD23       0x57        /*reserved*/
#define     CMD24       0x58        /*Writes a block of the size selected by CMD16, the start address must be alligned on a sector boundry, the block length is always 512 bytes*/
#define     CMD25       0x59        /*--*/
#define     CMD26       0x5a        /*--*/
#define     CMD27       0x5b        /*Programming of the programmable bits of the CSD*/
#define     CMD28       0x5c        /*If the card has write protection features, this command sets the write protection bit of the addressed group. The porperties of the write protection are coded in the card specific data (WP_GRP_SIZE)*/
#define     CMD29       0x5d        /*If the card has write protection features, this command clears the write protection bit of the addressed group*/
#define     CMD30       0x5e        /*If the card has write protection features, this command asks the card to send the status of the write protection bits. 32 write protection bits (representing 32 write protect groups starting at the specific address) followed by 16 CRD bits are transferred in a payload format via the data line*/
#define     CMD31       0x5f        /*reserved*/
#define     CMD32       0x60        /*sets the address of the first sector of the erase group*/
#define     CMD33       0x61        /*Sets the address of the last sector in a cont. range within the selected erase group, or the address of a single sector to be selected for erase*/
#define     CMD34       0x62        /*Removes on previously selected sector from the erase selection*/
#define     CMD35       0x63        /*Sets the address of the first erase group within a range to be selected for erase*/
#define     CMD36       0x64        /*Sets the address of the last erase group within a continuos range to be selected for erase*/
#define     CMD37       0x65        /*Removes one previously selected erase group from the erase selection*/
#define     CMD38       0x66        /*Erases all previously selected sectors*/
#define     CMD39       0x67        /*--*/
#define     CMD40       0x68        /*--*/
#define     CMD41       0x69        /*reserved*/
#define     CMD42       0x6a        /*reserved*/
#define     CMD43       0x6b        /*reserved*/
#define     CMD44       0x6c        /*reserved*/
#define     CMD45       0x6d        /*reserved*/
#define     CMD46       0x6e        /*reserved*/
#define     CMD47       0x6f        /*reserved*/
#define     CMD48       0x70        /*reserved*/
#define     CMD49       0x71        /*reserved*/
#define     CMD50       0x72        /*reserved*/
#define     CMD51       0x73        /*reserved*/
#define     CMD52       0x74        /*reserved*/
#define     CMD53       0x75        /*reserved*/
#define     CMD54       0x76        /*reserved*/
#define     CMD55       0x77        /*reserved*/
#define     CMD56       0x78        /*reserved*/
#define     CMD57       0x79        /*reserved*/
#define     CMD58       0x7a        /*reserved*/
#define     CMD59       0x7b        /*Turns the CRC option ON or OFF. A '1' in the CRC option bit will turn the option ON, a '0' will turn it OFF*/
#define     CMD60       0x7c        /*--*/
#define     CMD61       0x7d        /*--*/
#define     CMD62       0x7e        /*--*/
#define     CMD63       0x7f        /*--*/

unsigned char MMC_Init(void);
unsigned char MMC_Read(unsigned long lba, unsigned char *pReadBuffer) __z88dk_callee;

#endif
