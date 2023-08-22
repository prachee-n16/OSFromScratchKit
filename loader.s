// Not present in resulting output binary file
// Compiler variable only
.set MAGIC, 0x1BADB002
// Set flags for the boot loader
.set FLAGS, (1<<0 | 1<<1)
.set CHECKSUM, -(MAGIC + FLAGS)

// allocate space for a 32-bit value 
.section .multiboot
    .long MAGIC
    .long FLAGS
    .long CHECKSUM

// indicates section of code with executable instructions
.section .text
// Assembler to jump into main function, 
.extern main
// Program entrypoint
.global loader

loader:
    // %esp is the stack pointer register, kernel_stack is internal
    mov $kernel_stack, %esp
    // pushes the contents of register onto the stack
    push %eax
    push %ebx
    call main
    // It should never exit main, but for safety, an extra while loop

_stop:
    // Disable interrupts
    cli
    // Probably something on not halting processor
    hlt
    // Jump back to _stop label
    jmp _stop

// Section in memory called block started by symbol (memory space for uninitialized data)
.section .bss
// Assign about 2MB space to prevent stack overwriting - moving SP left
.space 2*1024*1024
kernel_stack:
