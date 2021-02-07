/*
 * (c) Copyright 2021 by Einar Saukas. All rights reserved.
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

#include "zx0.h"

#define QTY_BLOCKS 10000

BLOCK *ghost_root = NULL;
BLOCK *dead_array = NULL;
int dead_array_size = 0;

BLOCK *allocate(int bits, int index, int offset, int length, BLOCK *chain) {
    BLOCK *ptr;

    if (ghost_root) {
        ptr = ghost_root;
        ghost_root = ptr->ghost_chain;
        if (ptr->chain) {
            if (!--ptr->chain->references) {
                ptr->chain->ghost_chain = ghost_root;
                ghost_root = ptr->chain;
            }
        }
    } else {
        if (!dead_array_size) {
            dead_array = (BLOCK *)malloc(QTY_BLOCKS*sizeof(BLOCK));
            if (!dead_array) {
                fprintf(stderr, "Error: Insufficient memory\n");
                exit(1);
            }
            dead_array_size = QTY_BLOCKS;
        }
        ptr = &dead_array[--dead_array_size];
    }
    ptr->bits = bits;
    ptr->index = index;
    ptr->offset = offset;
    ptr->length = length;
    if (chain)
        chain->references++;
    ptr->chain = chain;
    ptr->references = 0;
    return ptr;
}

void assign(BLOCK **ptr, BLOCK *chain) {
    chain->references++;
    if (*ptr) {
        if (!--(*ptr)->references) {
            (*ptr)->ghost_chain = ghost_root;
            ghost_root = *ptr;
        }
    }
    *ptr = chain;
}
