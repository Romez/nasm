global _start

extern print_number
extern print_char
extern strcmp
extern str_to_int

section .bss
    token_len equ 64
    token resb token_len

section .data

section .text
    sys_exit  equ 60
    sys_read  equ 0
    sys_write equ 1
    stdin  equ 0
    stdout equ 1

    add_t db '+', 0
    sub_t db '-', 0
    mul_t db '*', 0
    div_t db '/', 0

_start:

.read:
    call read_token

    cmp byte [token], 0
    jz .exit

    ; add
    mov rdi, token
    mov rsi, add_t
    call strcmp

    cmp rax, 0
    jz .add_up

    ; sub
    mov rdi, token
    mov rsi, sub_t
    call strcmp

    cmp rax, 0
    jz .subtract

    ; mul
    mov rdi, token
    mov rsi, mul_t
    call strcmp

    cmp rax, 0
    jz .multiply

    ; div
    mov rdi, token
    mov rsi, div_t
    call strcmp

    cmp rax, 0
    jz .divide

    ; digit
    mov rdi, token
    call str_to_int

    push rax

    jmp .read

.add_up:
    pop rdx
    pop rax
    
    add rax, rdx

    push rax

    jmp .read

.subtract:
    pop rdx
    pop rax
    
    sub rax, rdx

    push rax

    jmp .read

.multiply:
    pop rdi
    pop rax
    
    xor rdx, rdx
    mul rdi

    push rax

    jmp .read

.divide:
    pop rdi
    pop rax
    
    xor rdx, rdx
    div rdi

    push rax

    jmp .read

.exit:
    pop rdi
    call print_number

    mov rdi, 10
    call print_char

    ; ----
    mov rax, sys_exit
    mov rdi, 0
    syscall

.invalid_char_exit:
    mov rax, sys_exit
    mov rdi, 1
    syscall

read_token:    
    mov rax, sys_read
    mov rdi, stdin
    mov rsi, token
    mov rdx, token_len
    syscall

    mov byte [token + rax - 1], 0

    ret
