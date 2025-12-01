; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));
; ft_list_remove_if() does not return anything 

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
; RSI   -> void *data_ref
; RDX   -> int (*cmp)()
; RCX   -> void (*free_fct)(void *)

; RAX   -> return value = the pointer to dest 
; ---------------------------------------------------------------------------------------

%include "list.inc"

section .text
global  ft_list_remove_if:


.done 
    ret