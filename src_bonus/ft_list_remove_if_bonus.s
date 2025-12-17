; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));
; ft_list_remove_if() does not return anything

; The functions pointed to by cmp and free_fct will be used as:
; (*cmp)(list_ptr->data, data_ref);
; (*free_fct)(list_ptr->data);

; Registers
; As per the System V AMD64 ABI convention: 
; the first six interger/pointer arguments are passed in the following registers:
; RDI -> first argument
; RSI -> second argument
; RDX -> third argument
; RCX -> fourth argument
; R8 -> fifth argument
; R9 ->  sixth argument
; 
; RAX -> designated return register 
; ---------------------------------------------------------------------------------------
; For ft_list_remove_if() this means: 
; RDI   -> t_list **begin_list = &begin_list -> deferenced pointer = the address of the head pointer 
; RSI   -> void *data_ref
; RDX	-> int (*cmp)()
; RCX	-> void (*free_fct)(void *)

; RAX   -> default return value 
; ---------------------------------------------------------------------------------------

%define NODE_DATA 0
%define NODE_NEXT 8
%define NODE_SIZE 16

section .data 
msg db "Incorrect input!\n", 10, 0

section .text
global  ft_list_remove_if
extern free
extern printf

ft_list_remove_if:
    test    rdi, rdi       ; test if input is NULL
    je      .error_input
    test    rsi, rsi       ; test if input is NULL
    je      .error_input
    test    rdx, rdx       ; test if input is NULL
    je      .error_input
    test    rcx, rcx       ; test if input is NULL
    je      .error_input

    ; save callee saved registers 
    push    rbp
    push    rbx 
    push    r12
    push    r13
    push    r14
    push    r15
    sub     rsp, 8          ; align the stack (6 push * 8 byte) + the function call (which is 8 byte)
                            ; the stack needs to be 16 yte aligned before any call (ABI requirement)

    mov     r12, rdi        ; save *begin_list
    mov     r13, rsi        ; save data_ref
    mov     r14, rdx        ; save compare function 
    mov     r15, rcx        ; save free function
	
    xor     rbp, rbp        ; previous -> NULL
    mov     rbx, [r12]      ; current node -> load head 
    test    rbx, rbx        ; test if NULL
    jz      .done
	
.loop_first:
    mov     rdi, [rbx + NODE_DATA]  ; move head data in RDI to be used by compare function
    mov     rsi, r13                ; move data_ref to RSI to be used by compare function 
    call    r14                     ; call compare function
    cmp     eax, 0                  ; compare function result to 0
	je      .remove_first

    mov     rbp, rbx                ; load previous
    mov     rbx, [rbp + NODE_NEXT]  ; load next node -> current 
    test    rbx, rbx                ; test if NULL
    jz      .done
	jmp     .loop
	
.remove_first:
    mov     rax, [rbx + NODE_NEXT]  ; temp storage RAX to move the second node as new head
    mov     [r12], rax              ; *begin_list = next
 
    mov     rdi, rbx                ; move head data in RDI to be used by free function
    call    r15                     ; call free function 
    ; call    free wrt ..plt
    
    mov     rbx, [r12]              ; update current
    test    rbx, rbx                ; test if NULL
    jz      .done
    jmp     .loop_first
	
.loop:
    mov     rdi, [rbx + NODE_DATA]  ; move node to be tested to RDI for cmp function 
    mov     rsi, r13                ; move data_ref to RSI to be used by cmp function 
    call    r14                     ; call compare function
    cmp     eax, 0                  ; compare result to 0 to see if items are the same
    je      .remove
    jmp     .move_to_next_node

.move_to_next_node:
    mov     rbp, [rbp + NODE_NEXT]  ; move to previous the node that was just compared
    mov     rbx, [rbp + NODE_NEXT]  ; set the new current
    test    rbx, rbx                ; test if NULL
    jz      .done
    jmp     .loop
	
.remove:
    ; rbp -> previous | rbx -> current 
    mov     rax, [rbx + NODE_NEXT]  ; temp storage RAX to move the second node as new head
    mov     [rbp + NODE_NEXT], rax  ; connected to the next node jumping over the node to erase

    mov     rdi, rbx                ; move node data in RDI to be used by free function
    call    r15                   ; call free function 
    ; call    free wrt ..plt
    
    mov     rbx, [rbp + NODE_NEXT]  ; update current
    test    rbx, rbx                ; test if NULL
    jz      .done
    jmp     .loop

.error_input:
    mov     rdi, msg
    xor     rax, rax
    call    printf wrt ..plt
    jmp     .done

.done:
    ; restore stack
    add     rsp, 8
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
	ret