	.file	"fix_matrix.c"
	.text
	.globl	fix_prod_ele
	.type	fix_prod_ele, @function
fix_prod_ele:
.LFB0:
	.cfi_startproc
	movl	$0, %eax
	movl	$0, %r8d
	salq	$6, %rdx
	addq	%rdx, %rdi
	jmp	.L2
.L3:
	movq	%r8, %r9
	salq	$6, %r9
	addq	%rsi, %r9
	movl	(%r9,%rcx,4), %r9d
	imull	(%rdi,%r8,4), %r9d
	addl	%r9d, %eax
	addq	$1, %r8
.L2:
	cmpq	$15, %r8
	jle	.L3
	rep ret
	.cfi_endproc
.LFE0:
	.size	fix_prod_ele, .-fix_prod_ele
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-16)"
	.section	.note.GNU-stack,"",@progbits
