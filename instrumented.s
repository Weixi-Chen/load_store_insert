	.text
	.file	"test.c"
	.globl	main                            // -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   // @main
	.cfi_startproc
// %bb.0:
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, #16]             // 16-byte Folded Spill
	str	x19, [sp, #32]                  // 8-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 32
	.cfi_offset w19, -16
	.cfi_offset w30, -24
	.cfi_offset w29, -32
	adrp	x0, .L__unnamed_1
	add	x0, x0, :lo12:.L__unnamed_1
	bl	printf
	adrp	x0, .L__unnamed_2
	add	x0, x0, :lo12:.L__unnamed_2
	str	wzr, [x29, #28]
	bl	printf
	mov	w8, #10                         // =0xa
	adrp	x0, .L__unnamed_3
	add	x0, x0, :lo12:.L__unnamed_3
	str	w8, [x29, #24]
	bl	printf
	ldr	w8, [x29, #24]
	adrp	x0, .L__unnamed_4
	add	x0, x0, :lo12:.L__unnamed_4
	add	w19, w8, #5
	bl	printf
	adrp	x0, .L__unnamed_5
	add	x0, x0, :lo12:.L__unnamed_5
	stur	w19, [x29, #-4]
	bl	printf
	ldur	w1, [x29, #-4]
	adrp	x0, .L.str
	add	x0, x0, :lo12:.L.str
	bl	printf
	mov	w0, wzr
	.cfi_def_cfa wsp, 48
	ldp	x29, x30, [sp, #16]             // 16-byte Folded Reload
	ldr	x19, [sp, #32]                  // 8-byte Folded Reload
	add	sp, sp, #48
	.cfi_def_cfa_offset 0
	.cfi_restore w19
	.cfi_restore w30
	.cfi_restore w29
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        // -- End function
	.type	.L.str,@object                  // @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Result: %d\n"
	.size	.L.str, 12

	.type	.L__unnamed_1,@object           // @0
.L__unnamed_1:
	.asciz	"Store Detected\n"
	.size	.L__unnamed_1, 16

	.type	.L__unnamed_2,@object           // @1
.L__unnamed_2:
	.asciz	"Store Detected\n"
	.size	.L__unnamed_2, 16

	.type	.L__unnamed_3,@object           // @2
.L__unnamed_3:
	.asciz	"Load Detected\n"
	.size	.L__unnamed_3, 15

	.type	.L__unnamed_4,@object           // @3
.L__unnamed_4:
	.asciz	"Store Detected\n"
	.size	.L__unnamed_4, 16

	.type	.L__unnamed_5,@object           // @4
.L__unnamed_5:
	.asciz	"Load Detected\n"
	.size	.L__unnamed_5, 15

	.ident	"Ubuntu clang version 18.1.3 (1ubuntu1)"
	.section	".note.GNU-stack","",@progbits
