/* Placeholder since we have a different printf implementation */

static void wrapper() __naked
{
#asm
        PUBLIC __printf_get_flags_impl
        PUBLIC __printf_get_flags_noop
	PUBLIC	__printf_handle_s
	PUBLIC	__printf_handle_c
	PUBLIC	__printf_handle_d
	PUBLIC	__printf_handle_u
	PUBLIC	__printf_handle_x
	PUBLIC	__printf_handle_o
	PUBLIC	__printf_handle_p
	PUBLIC	__printf_handle_X
	PUBLIC	__printf_handle_B
	PUBLIC	__printf_handle_n
	PUBLIC	__printf_handle_ll

__printf_get_flags_impl:
__printf_get_flags_noop:
__printf_handle_s:
__printf_handle_c:
__printf_handle_d:
__printf_handle_u:
__printf_handle_x:
__printf_handle_o:
__printf_handle_p:
__printf_handle_X:
__printf_handle_B:
__printf_handle_n:
__printf_handle_ll:

#endasm
}

