global _start

extern int_to_ascii

SECTION .bss
    curtime resq 1
    buffer resb 64

SECTION .data
    sys_exit equ 60
    sys_write equ 1
    sys_time equ 0xc9

    stdout equ 1

SECTION .text
_start:
    ;; get current epoch time
    mov rax, sys_time
    mov rdi, curtime
    syscall

    push qword [curtime]
    push qword buffer
    call int_to_ascii
    ;; rax = len

    mov byte [buffer + rax], 10
    inc rax

    ; print time
    mov rdi, stdout
    mov rsi, buffer
    mov rdx, rax
    mov rax, sys_write
    syscall

    ; exit
    mov rax, sys_exit
    mov rdi, 0
    syscall