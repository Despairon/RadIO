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
    $(error CMD goals number aren't 2, only 2 are supported <platform> and <target>, where platform could be e.g. stm32f401cc and target could be either build or clean or some other.)
endif

BUILD_DIR           := ./build
PLATFORM_DIR         = ./platforms/$(PLATFORM)
SRCDIR              := ./src
OUTDIR               = $(BUILD_DIR)/$(PLATFORM)
TARGET_NAME         := RadIO
TARGET_PATHNAME      = $(OUTDIR)/$(TARGET_NAME)
PLATFORM_INCLUDE     = $(PLATFORM_DIR)/include.mk
PLATFORM_LDSCRIPT    = $(PLATFORM_DIR)/linker.ld
PLATFORM_STARTUPCODE = $(wildcard $(PLATFORM_DIR)/startup.*)

ifneq ($(PLATFORM_STARTUPCODE),)
    STARTUPCODE_OBJ    = $(OUTDIR)/startup.o
    STARTUPCODE_TARGET = $(STARTUPCODE_OBJ)$(suffix $(PLATFORM_STARTUPCODE))
else
    $(error "Platform startup code cannot be found!")
endif

include $(PLATFORM_INCLUDE)

.PHONY: $(PLATFORM) clean build $(OUTDIR) $(STARTUPCODE_TARGET)

$(PLATFORM): $(OUTDIR)

clean:
	rm -rf $(OUTDIR)

build: $(TARGET_PATHNAME).bin

$(OUTDIR):
	@if [ ! -d ./$@ ]; then mkdir -p $@; fi

$(STARTUPCODE_OBJ): $(PLATFORM_STARTUPCODE) $(STARTUPCODE_TARGET)

$(STARTUPCODE_OBJ).s: $(PLATFORM_STARTUPCODE)
	$(AS) -o $(STARTUPCODE_OBJ) $<

$(STARTUPCODE_OBJ).c: $(PLATFORM_STARTUPCODE)
	$(CPP) $(CXXFLAGS) -c $< -o $(STARTUPCODE_OBJ)

$(OUTDIR)/main.o: $(SRCDIR)/main.cpp
	$(CPP) $(CXXFLAGS) -c $< -o $@

$(TARGET_PATHNAME).elf: $(PLATFORM_LDSCRIPT) $(OUTDIR)/main.o
	$(LD) -T $(PLATFORM_LDSCRIPT) -o $@ $(OUTDIR)/main.o $(STARTUPCODE_OBJ)

$(TARGET_PATHNAME).bin: $(STARTUPCODE_OBJ) $(TARGET_PATHNAME).elf
	$(BIN) -O binary $(TARGET_PATHNAME).elf $(TARGET_PATHNAME).bin
