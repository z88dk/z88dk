#include "backend.h"
#include "utils.h"

#include <stdio.h>

static FILE* output_file = NULL;

void init_backend(const char* output_filename) {
	if (output_file) fclose(output_file);
	output_file = safe_fopen(output_filename, "wb");
}

void emit(int b) {
	fputc(b & 0xFF, output_file);
}

void emitw(int w) {
	emit(w);
	emit(w >> 8);
}

int get_pc(void) {
	return (int)ftell(output_file);
}
