#ifndef DEBUGGER_MI2_H
#define DEBUGGER_MI2_H

void mi2_printf_log(const char *fmt, ...);

#define mi2_printf_prompt() do { mi2_printf_log("(gdb)\n"); } while (0)
#define mi2_printf_async(format, ...) do { mi2_printf_log("*" format "\n", ##__VA_ARGS__); } while (0)
#define mi2_printf_thread(format, ...) do { mi2_printf_log("=" format "\n", ##__VA_ARGS__); } while (0)
#define mi2_printf_error(flow, format, ...) do { mi2_printf_log("%s^error,msg=\"" format "\\n\"\n", flow, ##__VA_ARGS__); } while (0)
#define mi2_printf_response(flow, format, ...) do { mi2_printf_log("%s^" format "\n", flow, ##__VA_ARGS__); } while (0)

void debugger_mi2_init();

#endif
