
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>


void rn_fileListItem(uint16_t fileItemIndex, FileDetailsStruct* s) {

    // 0xb2
    // 
    // The response is 83 bytes and structured like so...
    // 
    // Bytes       Type      Description
    // ----------  --------  ------------------------------------
    // 0, 1, 2, 3  int32_t   Filesize (or -1 for a folder)
    // 4, 5        uint16_t  Created Year
    // 6           uint8_t   Created Month
    // 7           uint8_t   Created Day
    // 8           uint8_t   Created Hour (24 hour)
    // 9           uint8_t   Created Minute
    // 10          uint8_t   Created Second
    // 11, 12      uint16_t  Modified Year
    // 13          uint8_t   Modified Month
    // 14          uint8_t   Modified Day
    // 15          uint8_t   Modified Hour (24 hour)
    // 16          uint8_t   Modified Minute
    // 17          uint8_t   Modified Second
    // 18          uint8_t   Length of filename (max 64)
    // 19..82                The remaining bytes is the filename

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILEIDX_STAT);

    hcca_writeUInt16(fileItemIndex);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    s->FileSize = hcca_readInt32(); // 0, 1, 2, 3

    s->CreatedYear = hcca_readUInt16(); // 4, 5
    s->CreatedMonth = hcca_readByte(); // 6
    s->CreatedDay = hcca_readByte(); // 7
    s->CreatedHour = hcca_readByte(); // 8
    s->CreatedMinute = hcca_readByte(); // 9
    s->CreatedSecond = hcca_readByte(); // 10

    s->ModifiedYear = hcca_readUInt16(); // 11, 12
    s->ModifiedMonth = hcca_readByte(); // 13
    s->ModifiedDay = hcca_readByte(); // 14
    s->ModifiedHour = hcca_readByte(); // 15
    s->ModifiedMinute = hcca_readByte(); // 16
    s->ModifiedSecond = hcca_readByte(); // 17

    s->FilenameLen = hcca_readByte(); // 18

    hcca_readBytes(0, 64, (uint8_t*)s->Filename); // 19-64

    s->IsFile = (s->FileSize >= 0);
    s->Exists = (s->FileSize != -2);
}


