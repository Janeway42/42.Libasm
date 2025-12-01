; int ft_list_size(t_list *begin_list);
; ft_list_size() does not return anything

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
; For ft_list_size() this means: 
; RDI   -> t_list *begin_list (head pointer)

; RAX   -> return value = the pointer to dest 
; ---------------------------------------------------------------------------------------

%include "list.inc"

section .text
global  ft_list_size

ft_list_size:
    xor rax, rax			        ; set RAX to 0

.loop
    test rdi, rdi			        ; if NULL test will do "0 AND 0 = 0", and set ZF = 1
    jz .done

    inc rax				            ; increment rax
    mov rdi, [rdi + LIST_NEXT]		; move to the next element of the list
    jmp .loop

.done
    ret     