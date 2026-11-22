
#include <arch/nabu/hcca.h>
#include <stdint.h>

uint16_t hcca_readUInt16() {

  return (uint16_t)hcca_readByte() +
    ((uint16_t)hcca_readByte() << 8);
}

int16_t hcca_readInt16() {

  return (int16_t)hcca_readByte() +
    ((int16_t)hcca_readByte() << 8);
}

uint32_t hcca_readUInt32() {

  return (uint32_t)hcca_readByte() +
    ((uint32_t)hcca_readByte() << 8) +
    ((uint32_t)hcca_readByte() << 16) +
    ((uint32_t)hcca_readByte() << 24);
}

int32_t hcca_readInt32() {

  return (int32_t)hcca_readByte() +
    ((int32_t)hcca_readByte() << 8) +
    ((int32_t)hcca_readByte() << 16) +
    ((int32_t)hcca_readByte() << 24);
}

void hcca_readBytes(uint8_t offset, uint8_t bufferLen, void *buffer) {
  uint8_t *buf = buffer;

  for (uint8_t i = 0; i < bufferLen; i++)
    buf[offset + i] = hcca_readByte();
}


void hcca_writeUInt32(uint32_t val) {

  hcca_writeByte((uint8_t)(val & 0xff));
  hcca_writeByte((uint8_t)((val >> 8) & 0xff));
  hcca_writeByte(((uint8_t)(val >> 16) & 0xff));
  hcca_writeByte((uint8_t)((val >> 24) & 0xff));
}

void hcca_writeInt32(int32_t val) {

  hcca_writeByte((uint8_t)(val & 0xff));
  hcca_writeByte((uint8_t)((val >> 8) & 0xff));
  hcca_writeByte((uint8_t)((val >> 16) & 0xff));
  hcca_writeByte((uint8_t)((val >> 24) & 0xff));
}

void hcca_writeUInt16(uint16_t val) {

  hcca_writeByte((uint8_t)(val & 0xff));
  hcca_writeByte((uint8_t)((val >> 8) & 0xff));
}

void hcca_writeInt16(int16_t val) {

  hcca_writeByte((uint8_t)(val & 0xff));
  hcca_writeByte((uint8_t)((val >> 8) & 0xff));
}

void hcca_writeString(uint8_t* str) {

  for (unsigned int i = 0; str[i] != 0x00; i++)
    hcca_writeByte(str[i]);
}

void hcca_writeBytes(uint16_t offset, uint16_t length, void *bytes) {
  uint8_t *buf = bytes; 
  for (uint16_t i = 0; i < length; i++)
    hcca_writeByte(buf[offset + i]);
}

