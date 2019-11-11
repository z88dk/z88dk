#pragma once

void init_backend(const char* output_filename);
void emit(int b);
void emitw(int w);
int get_pc(void);
