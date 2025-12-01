; void ft_list_sort(t_list **begin_list, int (*cmp)());
; ft_list_sort() does not return anything 

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
; For ft_list_sort() this means: 
; RDI   -> t_list **begin_list
; RSI   -> int (*cmp)()

; RAX   -> return value = the pointer to dest 
; ---------------------------------------------------------------------------------------

%include "list.inc"

section .text
global  ft_list_sort:


.done 
    ret