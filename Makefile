# Automate compilation process for loader.s, kernel.cpp to *.o files and passed to linker.ld

#Parameters: 32-bit mode
GPPPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore
# This parameter does not exist for macOS (originally --32)
ASPARAMS = -target i686-elf
# Executable and Linkable Format 32-bit Intel 386 architecture
# MacOS doesn't support this
LDPARAMS = -melf_i386

objects = loader.o kernel.o

# Rule for building files *.o from C++ files *.cpp
# : signifies dependencies, follow bottom steps
%.o : %.cpp
#	Need to edit this to work with MacOS (gcc)
	g++ $(GPPPARAMS) -o $@ -c $<

# Rule for building files *.s from C++ files *.cpp
%.o : %.s
	as $(ASPARAMS) -o $@ $<

# Build target mykernel.bin using linker
mykernel.bin: linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o $@ $(objects)

# Copy this to following directory
install: mykernel.bin
	sudo cp $< /boot/mykernel.bin