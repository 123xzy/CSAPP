	.file	"call_proc.c"
	.text
	.globl	call_proc
	.type	call_proc, @function
call_proc:
.LFB0:
	.cfi_startproc
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movq	$1, 24(%rsp)
	movl	$2, 20(%rsp)
	movw	$3, 18(%rsp)
	movb	$4, 17(%rsp)
	leaq	17(%rsp), %rax
	movq	%rax, 8(%rsp)
	movl	$4, (%rsp)
	leaq	18(%rsp), %r9
	movl	$3, %r8d
	leaq	20(%rsp), %rcx
	movl	$2, %edx
	leaq	24(%rsp), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	proc
	movslq	20(%rsp), %rdx
	addq	24(%rsp), %rdx
	movswl	18(%rsp), %eax
	movsbl	17(%rsp), %ecx
	subl	%ecx, %eax
	cltq
	imulq	%rdx, %rax
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE0:
	.size	call_proc, .-call_proc
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-16)"
	.section	.note.GNU-stack,"",@progbits
