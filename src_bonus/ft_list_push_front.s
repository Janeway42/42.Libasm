; void ft_list_push_front(t_list **begin_list, void *data);
; ft_list_push_front() does not return anything

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
; For ft_list_push_front() this means: 
; RDI   -> char *str
; RSI   -> char *base

; RAX   -> return value = the pointer to dest 
; ---------------------------------------------------------------------------------------

%include "list.inc"

section .text
global  ft_list_push_front

ft_list_push_front:

.done
    ret