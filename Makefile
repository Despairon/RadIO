GCC = arm-none-eabi-gcc
CPP = arm-none-eabi-g++
AS  = arm-none-eabi-as
LD  = arm-none-eabi-ld
BIN = arm-none-eabi-objcopy

ifeq ($(words $(MAKECMDGOALS)), 2)
    PLATFORM := $(firstword $(MAKECMDGOALS))
    ifneq ($(shell find . -wholename ./platforms/$(PLATFORM)), ./platforms/$(PLATFORM))
        $(error "Platform $(PLATFORM) doesn't exist.")
    endif
else
    $(error CMD goals number aren't 2, only 2 are supported <platform> and <cmd>, where platform could be e.g. stm32f401cc and cmd could be either build or clean.)
endif

BUILD_DIR        := ./build
PLATFORM_DIR      = ./platforms/$(PLATFORM)
SRCDIR           := ./src
OUTDIR            = $(BUILD_DIR)/$(PLATFORM)
TARGET_NAME      := RadIO
TARGET_PATH       = $(OUTDIR)/$(TARGET_NAME)
PLATFORM_INCLUDE  = $(PLATFORM_DIR)/include.mk

include $(PLATFORM_DIR)/include.mk

.PHONY: $(firstword $(MAKECMDGOALS)) clean build $(OUTDIR)

$(firstword $(MAKECMDGOALS)): ;

clean:
	rm -rf $(OUTDIR)

build: $(OUTDIR) $(TARGET_PATH).bin

$(OUTDIR):
	@if [ ! -d ./$@ ]; then mkdir -p $@; fi

$(OUTDIR)/main.o: $(SRCDIR)/main.cpp
	$(CPP) $(CXXFLAGS) -c $< -o $@

$(TARGET_PATH).elf: $(PLATFORM_DIR)/linker.ld $(OUTDIR)/main.o
	$(LD) -T $(PLATFORM_DIR)/linker.ld -o $@ $(OUTDIR)/main.o

$(TARGET_PATH).bin: $(TARGET_PATH).elf
	$(BIN) -O binary $(TARGET_PATH).elf $(TARGET_PATH).bin
