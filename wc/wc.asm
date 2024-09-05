global _start

extern print_number
extern print_char

section .bss
    buffer_len equ 4096
    buffer resb buffer_len
    
section .data

section .text
    sys_exit  equ 60
    sys_read  equ 0
    sys_write equ 1
    stdin  equ 0
    stdout equ 1
_start:
    mov r8, 0
    mov r9, 0
    mov r10, 0 ; word counter

.space:
    call get_char
    cmp rax, 0
    je .exit

    cmp rax, 0x20 ; space
    je .space

    cmp rax, 10 ; \n
    je .space

    inc r10
    jmp .char

.char:
    call get_char
    cmp rax, 0
    je .exit

    cmp rax, 0x20 ; space
    je .space

    cmp rax, 10
    je .space

    jmp .char

.exit:
    mov rdi, r10
    call print_number

    ; ----
    mov rax, sys_exit
    mov rdi, 0
    syscall

; engine
; make syscall to fill up the buffer
; track position r8
; read bytes r9
get_char:
    cmp r8, r9
    jl .read
    
    mov rax, sys_read
    mov rdi, stdin
    mov rsi, buffer
    mov rdx, buffer_len
    syscall

    mov r9, rax
    mov r8, 0
    ; handle pipe end
    cmp rax, 0
    jle .exit
.read:
    movzx rax, byte [buffer + r8]
    inc r8
.exit:
    ret