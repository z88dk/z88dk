/*
 * (c) Copyright 2015 by Einar Saukas. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * The name of its author may not be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 16384  /* must be > MAX_OFFSET */

FILE *ifp;
FILE *ofp;
char *input_name;
char *output_name;
unsigned char *input_data;
unsigned char *output_data;
size_t input_index;
size_t output_index;
size_t input_size;
size_t output_size;
size_t partial_counter;
int bit_mask;
int bit_value;

int read_byte() {
    if (input_index == partial_counter) {
        input_index = 0;
        partial_counter = fread(input_data, sizeof(char), BUFFER_SIZE, ifp);
        input_size += partial_counter;
        if (partial_counter == 0) {
            fprintf(stderr, (input_size ? "Error: Truncated input file %s\n" : "Error: Empty input file %s\n"), input_name);
            exit(1);
        }
    }
    return input_data[input_index++];
}

int read_bit() {
    bit_mask >>= 1;
    if (bit_mask == 0) {
        bit_mask = 128;
        bit_value = read_byte();
    }
    return bit_value & bit_mask ? 1 : 0;
}

int read_elias_gamma() {
    int i;
    int value;

    i = 0;
    while (!read_bit()) {
        i++;
    }
    if (i > 15) {
        return -1;
    }
    value = 1;
    while (i--) {
        value = value << 1 | read_bit();
    }
    return value;
}

int read_offset() {
    int value;
    int i;

    value = read_byte();
    if (value < 128) {
        return value;
    } else {
        i = read_bit();
        i = i << 1 | read_bit();
        i = i << 1 | read_bit();
        i = i << 1 | read_bit();
        return (value & 127 | i << 7) + 128;
    }
}

void save_output() {
    if (output_index != 0) {
        if (fwrite(output_data, sizeof(char), output_index, ofp) != output_index) {
            fprintf(stderr, "Error: Cannot write output file %s\n", output_name);
            exit(1);
        }
        output_size += output_index;
        output_index = 0;
    }
}

void write_byte(int value) {
    output_data[output_index++] = value;
    if (output_index == BUFFER_SIZE) {
        save_output();
    }
}

void write_bytes(int offset, int length) {
    int i;
    if (offset > output_size+output_index) {
        fprintf(stderr, "Error: Invalid data in input file %s\n", input_name);
        exit(1);
    }
    while (length-- > 0) {
        i = output_index-offset;
        write_byte(output_data[i >= 0 ? i : BUFFER_SIZE+i]);
    }
}

void decompress() {
    int length;

    input_data = (unsigned char *)malloc(BUFFER_SIZE);
    output_data = (unsigned char *)malloc(BUFFER_SIZE);
    if (!input_data || !output_data) {
        fprintf(stderr, "Error: Insufficient memory\n");
        exit(1);
    }

    input_size = 0;
    input_index = 0;
    partial_counter = 0;
    output_index = 0;
    output_size = 0;
    bit_mask = 0;

    write_byte(read_byte());
    while (1) {
        if (!read_bit()) {
            write_byte(read_byte());
        } else {
            length = read_elias_gamma()+1;
            if (length == 0) {
                save_output();
                if (input_index != partial_counter) {
                    fprintf(stderr, "Error: Input file %s too long\n", input_name);
                    exit(1);
                }
                return;
            }
            write_bytes(read_offset()+1, length);
        }
    }
}

int main(int argc, char *argv[]) {
    int forced_mode = 0;
    int i;

    printf("DZX7: LZ77/LZSS decompression by Einar Saukas\n");

    /* process hidden optional parameters */
    for (i = 1; i < argc && *argv[i] == '-'; i++) {
        if (!strcmp(argv[i], "-f")) {
            forced_mode = 1;
        } else {
            fprintf(stderr, "Error: Invalid parameter %s\n", argv[i]);
            exit(1);
        }
    }

    /* determine output filename */
    if (argc == i+1) {
        input_name = argv[i];
        input_size = strlen(input_name);
        if (input_size > 4 && !strcmp(input_name+input_size-4, ".zx7")) {
            output_name = (char *)malloc(input_size);
            strcpy(output_name, input_name);
            output_name[input_size-4] = '\0';
        } else {
            fprintf(stderr, "Error: Cannot infer output filename\n");
            exit(1);
        }
    } else if (argc == i+2) {
        input_name = argv[i];
        output_name = argv[i+1];
    } else {
        fprintf(stderr, "Usage: %s [-f] input.zx7 [output]\n"
                        "  -f      Force overwrite of output file\n", argv[0]);
        exit(1);
    }

    /* open input file */
    ifp = fopen(input_name, "rb");
    if (!ifp) {
        fprintf(stderr, "Error: Cannot access input file %s\n", input_name);
        exit(1);
    }

    /* check output file */
    if (!forced_mode && fopen(output_name, "rb") != NULL) {
        fprintf(stderr, "Error: Already existing output file %s\n", output_name);
        exit(1);
    }

    /* create output file */
    ofp = fopen(output_name, "wb");
    if (!ofp) {
        fprintf(stderr, "Error: Cannot create output file %s\n", output_name);
        exit(1);
    }

    /* generate output file */
    decompress();

    /* close input file */
    fclose(ifp);

    /* close output file */
    fclose(ofp);

    /* done! */
    printf("File converted from %lu to %lu bytes!\n", (unsigned long)input_size, (unsigned long)output_size);

    return 0;
}
