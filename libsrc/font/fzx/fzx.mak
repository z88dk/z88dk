FZX_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/font/fzx/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/z80/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/fonts/**/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/zx/z80/*.asm"
FZX_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/font/fzx/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/font/fzx/z80/*.asm $(NEWLIB_DIRECTORY)/font/fzx/fonts/*/*/*.asm $(NEWLIB_DIRECTORY)/font/fzx/fonts/*/*/*/*.asm $(NEWLIB_DIRECTORY)/font/fzx/zx/z80/*.asm

FZX_NEWLIB_TARGETS := font/fzx/obj/newlib-z80-fzx font/fzx/obj/newlib-z80n-fzx 


OBJS += $(FZX_NEWLIB_TARGETS)
CLEAN += fzx-clean

fzx: $(FZX_NEWLIB_TARGETS)

.PHONY: fzx fzx-clean

font/fzx/obj/newlib-z80-fzx: $(FZX_NEWLIBGLOBS_ex)
	@mkdir -p font/fzx/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/fzx/obj/z80/x -I$(NEWLIB_DIRECTORY) -mz80 -D__CLASSIC $(FZX_NEWLIBGLOBS)

font/fzx/obj/newlib-z80n-fzx: $(FZX_NEWLIBGLOBS_ex)
	@mkdir -p font/fzx/obj
	$(Q)touch $@
	$(Q)$(ASSEMBLER) -d -O=font/fzx/obj/z80n/x -I$(NEWLIB_DIRECTORY) -mz80n -D__CLASSIC $(FZX_NEWLIBGLOBS)


fzx-clean:
	$(RM) -fr font/fzx/obj
