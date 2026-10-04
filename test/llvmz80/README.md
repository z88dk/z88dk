# LLVM-Z80 integration

The `llvmz80` compiler selects `z80-unknown-none-z88dk` and sdcccall(0).
Set `LLVMZ80EXE` to the clang executable.
The compiler must support `-fdefault-calling-conv=sdcccall0`.
User `-Cg` options follow the default options.
The driver preprocesses in gnu23 mode.
Changing only `-Cg-std` can make header selection differ from compilation.

The upstream `__ZPROTO*` definitions remain unchanged.
The clang branch reverses arguments for existing classic library aliases.
LLVM-Z80 attributes describe explicit smallc, fastcall and callee entries.
Clang builtins implement varargs.

Compile all program translation units with the same calling convention.
An sdcccall(1) override requires compatible declarations and library callbacks.
The override does not change the library ABI.

Run the tests with an isolated library build:

```sh
export PATH="$PWD/bin:$PATH"
export ZCC="$PWD/bin/zcc"
export ZCCCFG="$PWD/lib/config"
export LLVMZ80EXE=/path/to/clang
export NTVCM=/path/to/ntvcm
export TMPDIR=/path/to/workspace/scratch/tmp
make -C test llvmz80
```

The runtime tests check C23 at O0, O2 and Os.
They use independent expected values and repeat calls to check stack cleanup.
The tests require classic CP/M and an initialised heap.
They do not use `-fno-builtin`.

Use a compiler that applies default0 to implicit library declarations.
Otherwise unannotated `puts` and `vsnprintf` can retain the register ABI.
The compiler regression is `clang/test/CodeGen/z80-default-calling-conv-builtins.c`.

The TMPDIR change is separate from the compiler integration.
Run its test with `make -C test/llvmz80 tmpdir`.
This change set does not include the math32 archive-dependency fix.

Fresh upstream math32 at `e67ef86a93` returns negative zero for `4.0f - 4.0f`.
The existing arithmetic fixture expects positive zero and fails that check.
A direct `cm32_sdcc_fssub` call returns the same `0x80000000` result.
The reference integration headers also produce that failure with the fresh archive.
This change set does not modify math32.
