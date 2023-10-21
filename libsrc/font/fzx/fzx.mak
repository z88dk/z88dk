FZX_NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/font/fzx/c/sccz80/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/z80/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/fonts/**/*.asm" "$(NEWLIB_DIRECTORY)/font/fzx/zx/z80/*.asm"
FZX_NEWLIBGLOBS_ex := $(NEWLIB_DIRECTORY)/font/fzx/c/sccz80/*.asm $(NEWLIB_DIRECTORY)/font/fzx/z80/*.asm $(NEWLIB_DIRECTORY)/font/fzx/fonts/*/*/*.asm $(NEWLIB_DIRECTORY)/font/fzx/fonts/*/*.asm $(NEWLIB_DIRECTORY)/font/fzx/zx/z80/*.asm

FZX_NEWLIB_TARGETS := font/fzx/obj/newlib-z80-font-fzx font/fzx/obj/newlib-z80n-font-fzx 


OBJS += $(FZX_NEWLIB_TARGETS)
CLEAN += fzx-clean

fzx: $(FZX_NEWLIB_TARGETS)

.PHONY: fzx fzx-clean

$(eval $(call buildnew,font/fzx,z80,-mz80 -I$(NEWLIB_DIRECTORY),$(FZX_NEWLIBGLOBS),$(FZX_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/fzx,r2ka,-mr2ka -I$(NEWLIB_DIRECTORY),$(FZX_NEWLIBGLOBS),$(FZX_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/fzx,r4k,-mr4k -I$(NEWLIB_DIRECTORY),$(FZX_NEWLIBGLOBS),$(FZX_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/fzx,z80n,-mz80n -I$(NEWLIB_DIRECTORY),$(FZX_NEWLIBGLOBS),$(FZX_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/fzx,ixiy,-mz80 -IXIY -I$(NEWLIB_DIRECTORY),$(FZX_NEWLIBGLOBS),$(FZX_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/fzx,8080,-m8080 -I$(NEWLIB_DIRECTORY),$(FZX_NEWLIBGLOBS),$(FZX_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/fzx,gbz80,-mgbz80 -I$(NEWLIB_DIRECTORY),$(FZX_NEWLIBGLOBS),$(FZX_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/fzx,z180,-mz180 -I$(NEWLIB_DIRECTORY),$(FZX_NEWLIBGLOBS),$(FZX_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/fzx,ez80_z80,-mez80_z80 -I$(NEWLIB_DIRECTORY),$(FZX_NEWLIBGLOBS),$(FZX_NEWLIBGLOBS_ex)))
$(eval $(call buildnew,font/fzx,kc160,-mkc160 -I$(NEWLIB_DIRECTORY),$(FZX_NEWLIBGLOBS),$(FZX_NEWLIBGLOBS_ex)))


fzx-clean:
	$(RM) -fr font/fzx/obj
