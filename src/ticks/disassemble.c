/* Copyright (C) 2014-2016 Ben Kurtovic <ben.kurtovic@gmail.com>
   Released under the terms of the MIT License. See LICENSE for details. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "disassembler/arguments.h"
#include "disassembler/mnemonics.h"
#include "disassembler/sizes.h"

typedef struct {
    size_t size;
    char *bytestr;
    char *line;
} DisasInstr;

/*
    Format a sequence of bytes of a certain length as a pretty string.

    The result must be freed by the caller.
*/
static char* format_bytestring(const uint8_t *bytes, size_t size)
{
    if (!size)
        return NULL;

    char *str = malloc(sizeof(char) * 16);
    size_t offset = 2, i;
    uint8_t b = bytes[0];

    if (b == 0xCB || b == 0xDD || b == 0xED || b == 0xFD) {
        offset--;
        if ((b == 0xDD || b == 0xFD) && bytes[1] == 0xCB)
            offset--;
    }

    for (i = 0; i < offset; i++) {
        str[3 * i] = str[3 * i + 1] = str[3 * i + 2] = ' ';
    }
    for (i = 0; i < size; i++) {
        snprintf(&str[3 * (i + offset)], 3, "%02X", bytes[i]);
        str[3 * (i + offset) + 2] = ' ';
    }
    str[3 * (size + offset) - 1] = '\0';
    return str;
}

/*
    Free the given DisasInstr struct.
*/
static void disas_instr_free(DisasInstr *instr)
{
    free(instr->bytestr);
    free(instr->line);
    free(instr);
}

/*
    Disassemble a single instruction starting at the given address.

    Return a dynamically allocated structure containing various interesting
    fields. This must be freed by the user with disas_instr_free().
*/
static DisasInstr* disassemble_instruction(const uint8_t *bytes)
{
    size_t size = get_instr_size(bytes);
    char *bytestr = format_bytestring(bytes, size);
    char *mnemonic = decode_mnemonic(bytes);
    char *args = decode_arguments(bytes);
    char *line;

    if (args) {
        line = malloc(strlen(mnemonic) + strlen(args) + 2);
        sprintf(line, "%s\t%s", mnemonic, args);
        free(args);
    } else {
        line = strdup(mnemonic);
    }

    DisasInstr *instr = malloc(sizeof(DisasInstr));
    instr->size = size;
    instr->bytestr = bytestr;
    instr->line = line;
    return instr;
}


void disassemble(const uint8_t *bytes, int pc)
{
    DisasInstr *instr = disassemble_instruction(bytes);
    char padding[16], *split;

    if ((split = strchr(instr->line, '\t'))) {
        size_t tabs = (40 - (instr->line + strlen(instr->line) - split)) / 8;
        padding[tabs] = '\0';
        while (tabs-- > 0)
            padding[tabs] = '\t';
    } else {
        strcpy(padding, "\t\t\t\t\t");
    }

    printf("\t%s%s\t; $%04x: %s\n", instr->line, padding, pc, instr->bytestr);
    disas_instr_free(instr);
}
