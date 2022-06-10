#ifndef DEBUGGER_MI2_H
#define DEBUGGER_MI2_H

#define mi2_printf_prompt() printf("(gdb)\n")
#define mi2_printf_async(format, ...) printf("*" format "\n", ##__VA_ARGS__);
#define mi2_printf_thread(format, ...) printf("=" format "\n", ##__VA_ARGS__);
#define mi2_printf_error(flow, format, ...) printf("%s^error,msg=\"" format "\\n\"\n", flow, ##__VA_ARGS__);
#define mi2_printf_response(flow, format, ...) printf("%s^" format "\n", flow, ##__VA_ARGS__);

void debugger_mi2_init();

#endif