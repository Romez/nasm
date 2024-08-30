global _start

extern print_number
extern print_char

SECTION .bss
    curtime resq 1

SECTION .data
    sys_exit equ 60
    sys_write equ 1
    sys_time equ 0xc9

    stdout equ 1

SECTION .text
_start:
    ; get current epoch time
    mov rax, sys_time
    mov rdi, curtime
    syscall

    mov rdi, qword [curtime]
    call print_number

    mov dil, 10
    call print_char

    ; exit
    mov rax, sys_exit
    mov rdi, 0
    syscall