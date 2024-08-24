global _start

extern int_to_ascii
extern str_to_int

section .bss
    buffer resb 64

section .data
    sys_exit  equ 60
    sys_write equ 1

    stdout equ 1

    ts:
        dq 1 ; seconds
        dq 0 ; nanoseconds

    next_line db 10

    print_str db '0'
    print_str_len equ $ - print_str

    move_up db 27, '[1A', 0
    move_up_len equ $ - move_up

    clear_line db 27, '[2K', 0   
    clear_line_len equ $ - clear_line

    i dq 0
    
section .text
_start:
    push rbp
    mov rbp, rsp

    sub rsp, 8
    mov qword [rbp - 8], 0 ; number

    push qword [rbp + 24] ; cmd params
    call str_to_int
    ; rax

    mov qword [rbp - 8], rax
.mainloop:
    push qword [rbp - 8]
    push buffer
    call int_to_ascii

    ; rax - len

    mov byte [buffer + rax], 10
    inc rax

    ; print time
    mov rdi, stdout
    mov rsi, buffer
    mov rdx, rax
    mov rax, sys_write
    syscall

    ; wait a second
    mov eax, 35              ; syscall number for nanosleep (sys_nanosleep)
    lea rdi, [ts]        ; pointer to timespec structure
    xor rsi, rsi             ; NULL for remaining time (no need to track it)
    syscall

    ; Move cursor up one line
    mov rax, 1                  ; syscall number for write (sys_write)
    mov rdi, 1                  ; file descriptor 1 is stdout
    mov rsi, move_up
    mov rdx, move_up_len
    syscall

    ; Clear the line
    mov rax, 1                  ; syscall number for write (sys_write)
    mov rdi, 1                  ; file descriptor 1 is stdout
    mov rsi, clear_line
    mov rdx, clear_line_len
    syscall

        ; ----
    dec qword [rbp - 8]
    cmp qword [rbp - 8], -1
    jnz .mainloop
    jmp .exit
    
    ; -------
.exit:
    mov rax, sys_exit
    mov rdi, 0
    syscall