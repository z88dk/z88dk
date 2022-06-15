#ifndef PROFILER_H
#define PROFILER_H

#include <stdint.h>

extern int profiler_enabled;
extern void profiler_start(const char* function, int iterations_limit);
extern uint8_t profiler_check(uint16_t pc);
extern void profiler_stop();

#endif