#ifndef PACKETS_H
#define PACKETS_H

#include <stdint.h>

#define PACKET_BUF_SIZE 0x4000

static const char INTERRUPT_CHAR = '\x03';

uint8_t *inbuf_get();
int inbuf_end();
void inbuf_reset();
void inbuf_erase_head(ssize_t end);
void write_flush(int sockfd);
void write_packet(const char *data);
void write_packet_bytes(const uint8_t *data, size_t num_bytes);
void write_data_raw(const uint8_t *data, ssize_t len);
void write_binary_packet(const char *pfx, const uint8_t *data, ssize_t num_bytes);
int read_packet(int sockfd);

#endif /* PACKETS_H */
