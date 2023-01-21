
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>

void rn_fileHandleDetails(int8_t fileHandle, FileDetailsStruct* s) {

    // 0xb4

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FH_DETAILS);
    hcca_writeByte(fileHandle);
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


