FZX_GLOBS := "$(NEWLIB_DIRECTORY)/font/fzx/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/z80/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/fonts/**/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/zx/z80/*.asm"
FZX_GLOBS_ex := $(NEWLIB_DIRECTORY)/font/fzx/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/font/fzx/z80/*.asm $(NEWLIB_DIRECTORY)/font/fzx/fonts/*/*/*.asm $(NEWLIB_DIRECTORY)/font/fzx/fonts/*/*.asm $(NEWLIB_DIRECTORY)/font/fzx/zx/z80/*.asm

FZX_TARGETS := _DEVELOPMENT/font/fzx/obj/newlib-z80-font-fzx _DEVELOPMENT/font/fzx/obj/newlib-z80n-font-fzx 


OBJS += $(FZX_TARGETS)
CLEAN += fzx-clean

fzx: $(FZX_TARGETS)

.PHONY: fzx fzx-clean

$(eval $(call buildnew,_DEVELOPMENT/font/fzx,z80,-mz80 -I$(NEWLIB_DIRECTORY),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/fzx,r2ka,-mr2ka -I$(NEWLIB_DIRECTORY),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/fzx,r4k,-mr4k -I$(NEWLIB_DIRECTORY),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/fzx,z80n,-mz80n -I$(NEWLIB_DIRECTORY),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/fzx,ixiy,-mz80 -IXIY -I$(NEWLIB_DIRECTORY),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/fzx,8080,-m8080 -I$(NEWLIB_DIRECTORY),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/fzx,8085,-m8085 -I$(NEWLIB_DIRECTORY),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/fzx,gbz80,-mgbz80 -I$(NEWLIB_DIRECTORY),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/fzx,z180,-mz180 -I$(NEWLIB_DIRECTORY),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/fzx,ez80_z80,-mez80_z80 -I$(NEWLIB_DIRECTORY),$(FZX_GLOBS),$(FZX_GLOBS_ex)))
$(eval $(call buildnew,_DEVELOPMENT/font/fzx,kc160,-mkc160 -I$(NEWLIB_DIRECTORY),$(FZX_GLOBS),$(FZX_GLOBS_ex)))


fzx-clean:
	$(RM) -fr _DEVELOPMENT/font/fzx/obj
