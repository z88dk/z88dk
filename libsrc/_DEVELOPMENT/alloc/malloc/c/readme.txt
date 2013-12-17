
These are C entry points that collect stack parameters into appropriate registers and then jump to the asm library function.

The following linking stubs are supplied:

== lr_c ===========

The caller is responsible for cleaning up the stack.
Function parameters are passed in left-to-right order.

== lr_callee_ =====

The target function is responsible for cleaning up the stack.
Function parameters are passed in left-to-right order.

== rl_c ===========

The caller is responsible for cleaning up the stack.
Function parameters are passed in right-to-left order.
