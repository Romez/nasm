global _start

section .bss
    buffer resb 128

section .data
    name_question db 'What is your name?', 10
    name_question_len equ $ - name_question

    greet_msg db 'Hello '
    greet_msg_len equ $ - greet_msg

section .text
    sys_exit  equ 60
    sys_read  equ 0
    sys_write equ 1
    stdin  equ 0
    stdout equ 1
_start:
    call print_name_question

    ; read input
    mov rax, sys_read
    mov rdi, stdin
    mov rsi, buffer
    mov rdx, 128
    syscall
    
    call print_greeting

    ; ----
    mov rax, sys_exit
    mov rdi, 0
    syscall

print_name_question:
    mov rdi, stdout
    mov rsi, name_question
    mov rdx, name_question_len
    mov rax, 1
    syscall
    
    ret

print_greeting:
    mov rdi, stdout
    mov rsi, greet_msg
    mov rdx, greet_msg_len
    mov rax, 1
    syscall

    mov rdi, stdout
    mov rsi, buffer
    mov rdx, 128
    mov rax, 1
    syscall

    ret