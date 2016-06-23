/*
 * (c) Copyright 2012-2016 by Einar Saukas. All rights reserved.
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

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

#include "zx7.h"

long parse_long(char *str) {
    long value;

    errno = 0;
    value = strtol(str, NULL, 10);
    return !errno ? value : LONG_MIN;
}

void reverse(unsigned char *first, unsigned char *last) {
    unsigned char c;

    while (first < last) {
        c = *first;
        *first++ = *last;
        *last-- = c;
    }
}

int main(int argc, char *argv[]) {
    long skip = 0;
    int forced_mode = 0;
    int backwards_mode = 0;
    char *output_name;
    unsigned char *input_data;
    unsigned char *output_data;
    FILE *ifp;
    FILE *ofp;
    size_t input_size;
    size_t output_size;
    size_t partial_counter;
    size_t total_counter;
    long delta;
    int i;

    printf("ZX7: Optimal LZ77/LZSS compression by Einar Saukas\n");

    /* process hidden optional parameters */
    for (i = 1; i < argc && (*argv[i] == '-' || *argv[i] == '+'); i++) {
        if (!strcmp(argv[i], "-f")) {
            forced_mode = 1;
        } else if (!strcmp(argv[i], "-b")) {
            backwards_mode = 1;
        } else if ((skip = parse_long(argv[i])) <= 0) {
            fprintf(stderr, "Error: Invalid parameter %s\n", argv[i]);
            exit(1);
        }
    }

    /* determine output filename */
    if (argc == i+1) {
        output_name = (char *)malloc(strlen(argv[i])+5);
        strcpy(output_name, argv[i]);
        strcat(output_name, ".zx7");
    } else if (argc == i+2) {
        output_name = argv[i+1];
    } else {
        fprintf(stderr, "Usage: %s [-f] [-b] input [output.zx7]\n"
                        "  -f      Force overwrite of output file\n"
                        "  -b      Compress backwards\n", argv[0]);

        exit(1);
    }

    /* open input file */
    ifp = fopen(argv[i], "rb");
    if (!ifp) {
        fprintf(stderr, "Error: Cannot access input file %s\n", argv[i]);
        exit(1);
    }

    /* determine input size */
    fseek(ifp, 0L, SEEK_END);
    input_size = ftell(ifp);
    fseek(ifp, 0L, SEEK_SET);
    if (!input_size) {
        fprintf(stderr, "Error: Empty input file %s\n", argv[i]);
        exit(1);
    }

    /* validate skip against input size */
    if (skip >= input_size) {
        fprintf(stderr, "Error: Skipping entire input file %s\n", argv[i]);
        exit(1);
    }

    /* allocate input buffer */
    input_data = (unsigned char *)malloc(input_size);
    if (!input_data) {
        fprintf(stderr, "Error: Insufficient memory\n");
        exit(1);
    }

    /* read input file */
    total_counter = 0;
    do {
        partial_counter = fread(input_data+total_counter, sizeof(char), input_size-total_counter, ifp);
        total_counter += partial_counter;
    } while (partial_counter > 0);

    if (total_counter != input_size) {
        fprintf(stderr, "Error: Cannot read input file %s\n", argv[i]);
        exit(1);
    }

    /* close input file */
    fclose(ifp);

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

    /* conditionally reverse input file */
    if (backwards_mode) {
        reverse(input_data, input_data+input_size-1);
    }

    /* generate output file */
    output_data = compress(optimize(input_data, input_size, skip), input_data, input_size, skip, &output_size, &delta);

    /* conditionally reverse output file */
    if (backwards_mode) {
        reverse(output_data, output_data+output_size-1);
    }

    /* write output file */
    if (fwrite(output_data, sizeof(char), output_size, ofp) != output_size) {
        fprintf(stderr, "Error: Cannot write output file %s\n", output_name);
        exit(1);
    }

    /* close output file */
    fclose(ofp);

    /* done! */
    printf("File%s converted%s from %lu to %lu bytes! (delta %ld)\n", (skip ? " partially" : ""), (backwards_mode ? " backwards" : ""), 
        (unsigned long)(input_size-skip), (unsigned long)output_size, delta);

    return 0;
}
