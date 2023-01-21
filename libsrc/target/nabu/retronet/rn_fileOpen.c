
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>



uint8_t rn_fileOpen(uint8_t filenameLen, char *filename, uint16_t fileFlag, uint8_t fileHandle) {

    //0xa3
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_OPEN);
    hcca_writeByte(filenameLen);
    hcca_writeBytes(0, filenameLen, filename);
    hcca_writeUInt16(fileFlag);
    hcca_writeByte(fileHandle);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    return hcca_readByte();
}
