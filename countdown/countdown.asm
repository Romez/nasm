global _start

extern print_number
extern str_to_int

section .bss
    buffer resb 64

section .data
    ts:
        dq 1 ; seconds
        dq 0 ; nanoseconds

    move_left db 27, '[1D', 0
    move_left_len equ $ - move_left

    clear_line db 27, '[2K', 0   
    clear_line_len equ $ - clear_line
    
section .text
    sys_exit  equ 60
    sys_write equ 1
    stdout equ 1
_start:
    push rbp
    mov rbp, rsp
    ; prolog

    mov rdi, qword [rbp + 24] ; cmd params
    call str_to_int

    mov rcx, rax

.loop:
    cmp rcx, 0
    je .exit

    push rcx

    mov rdi, rcx
    call print_number

    ; wait a second
    mov rax, 35              ; syscall number for nanosleep (sys_nanosleep)
    lea rdi, [ts]            ; pointer to timespec structure
    xor rsi, rsi             ; NULL for remaining time (no need to track it)
    syscall

    ; Move cursor left one line
    mov rax, sys_write
    mov rdi, stdout
    mov rsi, move_left
    mov rdx, move_left_len
    syscall

    ; Clear the line
    mov rax, sys_write
    mov rdi, stdout
    mov rsi, clear_line
    mov rdx, clear_line_len
    syscall

    pop rcx
    dec rcx

    jmp .loop
    
.exit:
    mov rax, sys_exit
    mov rdi, 0
    syscall