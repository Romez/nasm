global _start

extern print_number


SECTION .text
    sys_write equ 1
    stdout equ 1
_start:
    mov rdi, 0x35
    call print_number
    ; rax

    mov rdi, 0
    mov rax, 60
    syscall