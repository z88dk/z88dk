#ifndef DEBUGGER_MI2_H
#define DEBUGGER_MI2_H

#define mi2_printf_prompt() printf("(gdb)\n")
#define mi2_printf_async(format, ...) printf("*" format "\n" __VA_OPT__(,) __VA_ARGS__);
#define mi2_printf_thread(format, ...) printf("=" format "\n" __VA_OPT__(,) __VA_ARGS__);
#define mi2_printf_error(format, ...) printf("^error,msg=\"" format "\\n\"\n" __VA_OPT__(,) __VA_ARGS__);
#define mi2_printf_response(format, ...) printf("^" format "\n" __VA_OPT__(,) __VA_ARGS__);

void debugger_mi2_init();

#endif