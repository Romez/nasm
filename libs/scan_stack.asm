global scan_stack

; param 1 ; rdi ; number ; 8 bytes
scan_stack:
    mov rcx, rsp ; store rsp
    mov rdx, rbp ; store rbp

.go:
    cmp qword [rcx], rdi
    je .found

    cmp rcx, rdx
    je .rbp_match

    add rcx, 8
    jmp .go

.rbp_match:
    cmp qword [rdx], 0
    je .not_found

    mov rdx, qword [rdx]
    add rcx, 16
    jmp .go

.found:
    mov rax, 1
    ret

.not_found:
    mov rax, 0
    ret