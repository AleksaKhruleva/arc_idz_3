.global	idz3_func
.include "lib_macros.asm"


# function:
#	Razrabotannaya programma dolzhna chitat' obrabatyvaemyj tekst iz fajla i
#	zagruzhat' poluchennye rezul'taty takzhe v fajl. Vvod imen vhodnogo i
#	vyhodnogo fajlov dolzhen osushchestvlyat'sya s ispol'zovaniem konsoli.
#	Analogichnym obrazom osushchestvlyaet vvod ostal'nyh parametrov,
#	neobhodimyh dlya vypolneniya programmy.
# locals constants:
.eqv	lc_fb_sz	512	# file buffer size
.eqv	lc_wa_sz	32	# word accumulator size
.eqv	lc_ua_sz	16	# utoa buffer size
# locals area:
.eqv	la_wa	+0(sp)	# stack (+00) - work area address
.eqv	la_fb	+4(sp)	# stack (+04) - file buffer address
.eqv	la_dl	+8(sp)	# stack (+08) - data length value
.eqv	la_fd	+12(sp)	# stack (+12) - file descriptor value
.eqv	la_ub	+16(sp)	# stack (+16) - utoa result buffer address
.eqv	la_size	20
# save area:
.eqv	sa_ra	+0(sp)	# stack (+00) - register ra (return address)
.eqv	sa_s0	+4(sp)	# stack (+04) - register s0
.eqv	sa_s1	+8(sp)	# stack (+08) - register s1
.eqv	sa_s2	+12(sp)	# stack (+12) - register s2
.eqv	sa_s3	+16(sp)	# stack (+16) - register s3
.eqv	sa_size	20
# arguments area:
.eqv	arg1	+0(s0)	# stack (+00) - (i) - input file name string address
.eqv	arg2	+4(s0)	# stack (+04) - (i) - output file name string address
.eqv	arg3	+8(s0)	# stack (+08) - (i) - words number
.eqv	arg4	+12(s0)	# stack (+12) - (i) - word addresses array address
.eqv	arg5	+16(s0)	# stack (+16) - (i) - word counters array address
# return:
#	a0 - function result (register)
#	     0 - ok
#	     non-0 - file open/read
# register usage:
#	s0 - on-call stack position (arguments area)
#	s1 - temporary usage
#	s2 - temporary usage
.text
idz3_func:
	# save registers
	addi	sp, sp, -sa_size		# obtain stack for save area
	sw	ra, sa_ra		# save ra register
	sw	s0, sa_s0		# save s0 register
	sw	s1, sa_s1		# save s1 register
	sw	s2, sa_s2		# save s2 register
	sw	s3, sa_s3		# save s3 register
	addi	s0, sp, sa_size		# set on-call stack position (arguments area)
	# initialize locals area
	addi	sp, sp, -la_size		# obtain stack for locals area

	# allocate work area
	li	a1, 4			# work area: current state
	addi	a1, a1, 4		# work area: word accumulator size
	addi	a1, a1, 4		# work area: word accumulator length
	addi	a1, a1, 4		# work area: word accumulator address
	addi	a1, a1, lc_wa_sz		# work area: word accumulator area
	li	a2, 1			# load item size [sizeof(byte)]
	alloc_A	(a1, a2)			# allocate words array
	sw	a0, la_wa		# store allocated addresss

	# allocate file buffer
	li	a1, lc_fb_sz		# load file buffer size value
	li	a2, 1			# load item size [sizeof(byte)] value
	alloc_A	(a1, a2)			# allocate buffer
	sw	a0, la_fb		# store allocated address

	# allocate utoa result buffer address
	li	a1, lc_ua_sz		# load utoa buffer size value
	li	a2, 1			# load item size [sizeof(byte)] value
	alloc_A	(a1, a2)			# allocate buffer
	sw	a0, la_ub		# store allocated address

	# initialize work area
	lw	a1, la_wa		# load work area address
	li	t0, lc_wa_sz		# load "work area: word accumulator size" value
	sw	t0, +4(a1)		# initialize "work area: word accumulator size"
	addi	t0, a1, 16		# calculate "work area: word accumulator area" address
	sw	t0, +12(a1)		# store address to "work area: word accumulator address"

_oif:	lw	t0, arg1			# load file name address
	li	t1, 0			# flags - read only
	fopen	(t0, t1)			# open file
	sw	a0, la_fd		# store file descriptor
	lw	a0, la_fd		# load file descriptor
	blt	a0, zero, _break		# break if fopen error

_iread:	# read file
	lw	a0, la_fd		# load file descriptor value
	lw	a1, la_fb		# load buffer address
	li	a2, lc_fb_sz		# load buffer size value
	fread	(a0, a1, a2)		# read from file
	sw	a0, la_dl		# store readed data length
	lw	a0, la_dl		# load data_leng value
	blt	a0, zero, _break		# break if fread error
	beq	a0, zero, _iclose		# branch if end of file

	# do variant 27
	lw	a1, la_wa		# work area address
	lw	a2, la_fb		# file buffer data
	lw	a3, la_dl		# readed data length
	lw	a4, arg3			# default words number
	lw	a5, arg4			# words array address
	lw	a6, arg5			# word counters array address
	var27	(a1, a2, a3, a4, a5, a6)	# work current file part
	
	j	_iread			# next iteration

_iclose:	# close input file
	lw	t0, la_fd		# load file descriptor value
	fclose	(t0)			# close file

_ofopen:	lw	a1, arg2			# load output file name address
	li	a2, 1			# flag "write-only"
	fopen	(a1, a2)			# create output file
	sw	a0, la_fd		# store file descriptor
	lw	a0, la_fd		# load file descriptor
	blt	a0, zero, _break		# break if fopen error

	# write result to output file
	li	s1, 0			# words index
	lw	s2, arg4			# load "word addresses array address"
	lw	s3, arg5			# load "word counters array address"
	
_owrite:	lw	t0, arg3			# load wrods number value
	bge	s1, t0, _oclose		# branch if end of array
	# write current word
	lw	a1, (s2)			# load current word address
	jal	strlen_func		# calculate current word length
	lw	t0, la_fd		# load file descriptor
	lw	t1, (s2)			# load current word address
	fwrite	(t0, t1, a0)		# write current word to file
	# write lit_cs
	la	a1, lit_cs		# load litteral address
	jal	strlen_func		# calculate current word length
	lw	t0, la_fd		# load file descriptor
	la	t1, lit_cs		# load litteral address
	fwrite	(t0, t1, a0)		# write current word to file

	# write word number
	lw	t0, (s3)			# load current word number
	lw	t1, la_ub		# load utoa result buffer address
	utoa	(t0, t1)			# do utoa
	lw	a1, la_ub		# load utoa result buffer address
	jal	strlen_func		# calculate current word length
	lw	t0, la_fd		# load file descriptor
	lw	t1, la_ub		# load utoa result buffer address
	fwrite	(t0, t1, a0)		# write current word to file

	# write lit_nl
	la	a1, lit_nl		# load litteral address
	jal	strlen_func		# calculate current word length
	lw	t0, la_fd		# load file descriptor
	la	t1, lit_nl		# load litteral address
	fwrite	(t0, t1, a0)		# write current word to file
	# next iteration
	addi	s1, s1, 1		# increment words index
	addi	s2, s2, 4		# goto next word address
	addi	s3, s3, 4		# goto next word counter
	j	_owrite			# next iteration

_oclose:	# close output file
	lw	t0, la_fd		# load file descriptor value
	fclose	(t0)			# close file

	# return
_end:	li	a0, 0			# ok - return code

_break:	# this we must free heap, but no evironment call exist
	addi	sp, sp, la_size		# free stack for locals area
	lw	ra, sa_ra		# load ra register
	lw	s0, sa_s0		# load s0 register
	lw	s1, sa_s1		# load s1 register
	lw	s2, sa_s2		# load s2 register
	lw	s3, sa_s3		# load s3 register
	addi	sp, sp, sa_size		# free stack for save area
	ret				# return
