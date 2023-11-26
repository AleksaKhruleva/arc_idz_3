.global	main
.include "lib_macros.asm"

# defines
.eqv	f_n_sz	128			# file name buffer size

# main program
.text
main:
	# allocate words addresses array
	lw	a1, word_snum		# load default words number
	li	a2, 4			# load pointer item size [sizeof(int)]
	alloc_A	(a1, a2)			# allocate words array
	sw	a0, word_tptr, t0		# store allocated address

	# allocate word counters array
	lw	a1, word_snum		# load default words number
	li	a2, 4			# load pointer item size [sizeof(int)]
	alloc_A	(a1, a2)			# allocate counters array
	sw	a0, word_cptr, t0		# store allocated address

	# initialize words addresses array
	lw	t0, word_tptr		# load words array address
	la	t1, word01		# load word1 address
	sw	t1, (t0)			# store word1 address to array
	addi	t0, t0, 4		# goto next array item
	la	t1, word02		# load word2 address
	sw	t1, (t0)			# store word2 address to array
	addi	t0, t0, 4		# goto next array item
	la	t1, word03		# load word3 address
	sw	t1, (t0)			# store word3 address to array
	addi	t0, t0, 4		# goto next array item
	la	t1, word04		# load word4 address
	sw	t1, (t0)			# store word4 address to array
	addi	t0, t0, 4		# goto next array item
	la	t1, word05		# load word5 address
	sw	t1, (t0)			# store word5 address to array

_main_loop:
	# input input-file name
	la	t1, lit_iifn		# load welcome text address
	li	t2, f_n_sz		# load file name buffer size value
	la	t3, if_name		# load file name buffer address
	DinT	(t1, t2, t3)		# show dialog
	bne	a1, zero, _end		# branch if not OK
	la	a1, if_name		# load file name buffer address
	jal	killnl_func		# kill new-line character

_iofn:	# input output-file name
	la	t1, lit_iofn		# load welcome text address
	li	t2, f_n_sz		# load file name buffer size value
	la	t3, of_name		# load file name buffer address
	DinT	(t1, t2, t3)		# show dialog
	bne	a1, zero, _end		# branch if not OK
	la	a1, of_name		# load file name buffer address
	jal	killnl_func		# kill new-line character

	# ask user "Output result to console?"
	la	a0, lit_orc		# load string address
	DcmT	(a0)			# show dialog
	sw	a0, cout_cons, t0		# save user choice
	addi	a0, a0, -2		# try arrange to zero from -2
	beq	a0, zero, _end		# branch if CANCEL choice

	# print Input file name
	coutT	(lit_ifn)		# print welcome text
	la	a0, if_name		# load input file name address
	coutT0				# print text
	coutT	(lit_nl)			# print new-line

	# print Output file name
	coutT	(lit_ofn)		# print welcome text
	la	a0, of_name		# load output file name address
	coutT0				# print text
	coutT	(lit_nl)			# print new-line

	# initialize word counters array
	lw	t0, word_cptr		# load word counters array address
	lw	t1, word_snum		# load words number value
_iwca0:	beq	t1, zero, _iwca9		# branch if end of array
	sw	zero, (t0)		# initialize current counter
	addi	t0, t0, 4		# goto next counter number
	addi	t1, t1, -1		# decrement counter
	j	_iwca0			# next iteration
_iwca9:	# end of "_iwca"

	# do idz 3
	la	a1, if_name		# input file name
	la	a2, of_name		# output file name
	lw	a3, word_snum		# words number value
	lw	a4, word_tptr		# words addresses array address
	lw	a5, word_cptr		# words counters array address
	idz3	(a1, a2, a3, a4, a5)	# do idz3
	beq	a0, zero, _prf2c		# branch if result code - OK

	DmdT	(lit_ifore, 0)		# display error message
	j	_auanf			# jump to next iteration

	# print result file to console
_prf2c:	coutT	(lit_res)		# print welcome text
	lw	t0, cout_cons		# load "output result to console" flag
	bne	t0, zero, _auanf		# branch if flag is not YES
	la	a1, of_name		# load output file name address
	cat	(a1)			# print file context

_auanf:	# ask user about next file
	la	a0, lit_anf		# load welcome text address
	DcmT	(a0)			# show dialog
	beq	a0, zero, _main_loop	# branch if YES choice

_end:	done

.data
	word_snum:	.word	5			# default words number
	word_tptr:	.word	-1			# words array address
	word_cptr:	.word	-1			# word counters array address
	cout_cons:	.word	-1			# print result to console
			.align	2
	if_name:		.space	f_n_sz			# input file name buffer
	of_name:		.space	f_n_sz			# output file name buffer
			.align	2
	word01:		.asciz	"pragma"
	word02:		.asciz	"include"
	word03:		.asciz	"define"
	word04:		.asciz	"char"
	word05:		.asciz	"int"
	i_test_name:	.asciz	"./idz3/test9.cpp"	# test input file name
	o_test_name:	.asciz	"./idz3/test9.txt"	# test output file name
