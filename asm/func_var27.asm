.global	var27_func


# function:
#	27. Razrabotat' programmu, kotoraya opredelyaet chastotu vstrechaemosti
#	(skol'ko raz vstretilos' v tekste) pyati klyuchevyh slov yazyka
#	programmirovaniya C, v proizvol'noj ASCII–stroke. Klyuchevye slova ne
#	dolzhny yavlyat'sya chast'yu identifikatorov. Pyat' iskomyh klyuchevyh
#	slov vybrat' po svoemu usmotreniyu. Testirovat' mozhno na fajlah programm.
#	Vyvod rezul'tatov organizovat' v fajl (ispol'zuya sootvetstvuyushchie
#	preobrazovaniya chisel v stroki).
# locals area:
.eqv	la_i	+0(sp)	# stack (+00) - int i
.eqv	la_ch	+4(sp)	# stack (+00) - char ch
.eqv	la_j	+8(sp)	# stack (+00) - int j
.eqv	la_size	12
# save area:
.eqv	sa_ra	+0(sp)	# stack (+00) - register ra (return address)
.eqv	sa_s0	+4(sp)	# stack (+04) - register s0
.eqv	sa_s1	+8(sp)	# stack (+08) - register s1
.eqv	sa_s2	+12(sp)	# stack (+12) - register s2
.eqv	sa_s3	+16(sp)	# stack (+16) - register s3
.eqv	sa_s4	+20(sp)	# stack (+20) - register s4
.eqv	sa_s5	+24(sp)	# stack (+24) - register s5
.eqv	sa_s6	+28(sp)	# stack (+28) - register s6
.eqv	sa_size	32
# arguments area:
.eqv	arg1	+0(s0)	# stack (+00) - (i) - work area address
.eqv	arg2	+4(s0)	# stack (+04) - (i) - buffer address
.eqv	arg3	+8(s0)	# stack (+08) - (i) - data length
.eqv	arg4	+12(s0)	# stack (+12) - (i) - words number
.eqv	arg5	+16(s0)	# stack (+16) - (i) - word addresses array address
.eqv	arg6	+20(s0)	# stack (+20) - (i) - word counters array address
# register usage:
#	s0 - on-call stack position (arguments area)
#	s1 - work area address
#	s2 - buffer address
#	s3 - data length
#	s4 - words number
#	s5 - word addresses array address
#	s6 - word counters array address
# work area:
.eqv	waf1	+0(s1)	# +00(s1) - current state (initial 0)
.eqv	waf2	+4(s1)	# +04(s1) - word accumulator size
.eqv	waf3	+8(s1)	# +08(s1) - word accumulator length
.eqv	waf4	+12(s1)	# +12(s1) - word accumulator address
# return:
#	fa0 - function result (register)
.text
var27_func:
	# save registers
	addi	sp, sp, -sa_size		# obtain stack for save area
	sw	ra, sa_ra		# save ra register
	sw	s0, sa_s0		# save s0 register
	sw	s1, sa_s1		# save s1 register
	sw	s2, sa_s2		# save s2 register
	sw	s3, sa_s3		# save s3 register
	sw	s4, sa_s4		# save s4 register
	sw	s5, sa_s5		# save s5 register
	sw	s6, sa_s6		# save s6 register
	addi	s0, sp, sa_size		# set on-call stack position (arguments area)
	# initialize registers usage
	lw	s1, arg1			# load work area address
	lw	s2, arg2			# load buffer address
	lw	s3, arg3			# load data length
	lw	s4, arg4			# load words number
	lw	s5, arg5			# load word addresses array address
	lw	s6, arg6			# load word counters array address
	# initialize locals area
	addi	sp, sp, -la_size		# obtain stack for locals area

	# if (file_buffer_len == 0) return;
	beq	s3, zero, _end		# branch if data length zero
	# for (int i = 0; i < file_buffer_len; ++i) {
	sw	zero, la_i		# int i = 0
_for_1:	lw	t0, la_i			# load "i" value
	bge	t0, s3, _end_1		# branch if i >= file_buffer_len
	#  ch = file_buffer[i];
	lw	t0, la_i			# load "i" value
	add	t0, s2, t0		# calculate "file_buffer[i]" offset
	lbu	t1, (t0)			# load "file_buffer[i]" value
	sw	t1, la_ch		# ch = file_buffer[i];
	#  if (wa.state == 0) {
	lw	t1, waf1			# load work area: current state
	li	t0, 0			# load 0 value
	bne	t0, t1, _s1		# branch to else
_s0a:	#    if (isalnum(ch)) {
	lw	a7, la_ch		# load "ch" value
	jal	iscsymb_func		# call "isalnum(ch)"
	beq	a0, zero, _s0a0		# branch to else if result = 0
	#      wa.act[wa.acl] = ch;
	lw	t0, waf3			# load "wa.acl" value
	lw	t1, waf4			# load "wa.act" address
	add	t0, t0, t1		# calculate "wa.act[wa.acl]" offset
	lw	t1, la_ch		# load "ch" value
	sb	t1, (t0)			# store "ch" value
	#      wa.acl++;
	lw	t0, waf3			# load "wa.acl" value
	addi	t0, t0, 1		# increment "wa.acl" value
	sw	t0, waf3			# store "wa.acl" value
	#      if (wa.acl == wa.acs) {
	lw	t0, waf2			# load "word accumulator size" value
	lw	t1, waf3			# load "word accumulator length" value
	bne	t0, t1, _s0z		# branch if "wa.acl != wa.acs"
	#        wa.acl = 0;
	sw	zero, waf3		# store zero to "word accumulator length" value
	#        wa.state = 2;
	li	t0, 2			# state = 2
	sw	t0, waf1			# store 2 to "current state"
	#      }
	j	_s0z			# bypass else block
_s0a0:	#    } else {
	#      wa.act[wa.acl] = '\0';
	lw	t0, waf3			# load "wa.acl" value
	lw	t1, waf4			# load "wa.act" address
	add	t0, t0, t1		# calculate "wa.act[wa.acl]" offset
	sb	zero, (t0)		# store "ch" value
#	#      std::cout << wa.act << std::endl;
#	li	a7, 4			# load environment code
#	lw	a0, waf4			# load string address
#	ecall				# execute environment call
#	la	a0, lit_nl		# load literal address
#	ecall				# execute environment call
	#      for (int j = 0; j < WORDS_MAX; ++j) {
	sw	zero, la_j		# int j = 0;
_s0a1a:	lw	t0, la_j			# load "j" value
	bge	t0, s4, _s0a1z		# branch if "j >= WORDS_MAX"
	#          if (strcmp(wa.act, words[j]) == 0) {
	lw	a1, waf4			# load "wa.act" address
	lw	a2, (s5)			# load "words[j]" address
	jal	strcmp_func		# "strcmp(wa.act, words[j])"
	bne	a0, zero, _s0a1b		# branch if result "not equal"
	#              words_count[j]++;
	lw	t0, (s6)			# load "words_count[j]" value
	addi	t0, t0, 1		# increment "words_count[j]" value
	sw	t0, (s6)			# store new "words_count[j]" value
_s0a1b:	#          }
	lw	t0, la_j			# load "j" value
	addi	t0, t0, 1		# increment "j" value
	sw	t0, la_j			# store "j" value
	addi	s5, s5, 4		# goto next "word addresses array address"
	addi	s6, s6, 4		# goto next "word counters array address"
	j	_s0a1a			# next iteration
_s0a1z:	#      }
	lw	s5, arg5			# restore word addresses array address
	lw	s6, arg6			# restore word counters array address
	#      wa.state = 1;
	li	t0, 1			# state = 1
	sw	t0, waf1			# store 1 to "current state"
	#    }
	#  }
_s0z:	j	_for_z			# next iteration
_s1:	#  else
	#  if (wa.state == 1) {
	lw	t1, waf1			# load work area: current state
	li	t0, 1			# load 1 value
	bne	t0, t1, _s2		# branch to else
	#    if (isalnum(ch)) {
	lw	a7, la_ch		# load "ch" value
	jal	iscsymb_func		# call "isalnum(ch)"
	beq	a0, zero, _s1z		# branch to else if result = 0
	#      wa.state = 0;
	sw	zero, waf1		# store 0 to "current state"
	#      wa.acl = 0;
	sw	zero, waf3		# store 0 to "word accumulator length"
	#      wa.act[wa.acl] = ch;
	lw	t0, waf3			# load "wa.acl" value
	lw	t1, waf4			# load "wa.act" address
	add	t0, t0, t1		# calculate "wa.act[wa.acl]" offset
	lw	t1, la_ch		# load "ch" value
	sb	t1, (t0)			# store "ch" value
	#      wa.acl++;
	lw	t0, waf3			# load "wa.acl" value
	addi	t0, t0, 1		# increment "wa.acl" value
	sw	t0, waf3			# store "wa.acl" value
	#    }
	#  } 
_s1z:	j	_for_z			# next iteration
_s2:	#  else
	#  if (wa.state == 2) {
	lw	t1, waf1			# load work area: current state
	li	t0, 2			# load 2 value
	bne	t0, t1, _for_z		# branch to else
	#    if (isalnum(ch)) {
	lw	a7, la_ch		# load "ch" value
	jal	iscsymb_func		# call "isalnum(ch)"
	bne	a0, zero, _s2z		# branch to else if result != 0
	#    } else {
	#      wa.state = 0;
	sw	zero, waf1		# store 0 to "current state"
	#      wa.acl = 0;
	sw	zero, waf3		# store 0 to "word accumulator length"
	#    }
_s2z:	#  }
_for_z:	lw	t0, la_i			# load "i" value
	addi	t0, t0, 1		# increment "i" value
	sw	t0, la_i			# store "i" value
	j	_for_1			# next iteration
_end_1:	# }

_end:
	addi	sp, sp, la_size		# free stack for locals area
	lw	ra, sa_ra		# load ra register
	lw	s0, sa_s0		# load s0 register
	lw	s1, sa_s1		# load s1 register
	lw	s2, sa_s2		# load s2 register
	lw	s3, sa_s3		# load s3 register
	lw	s4, sa_s4		# load s4 register
	lw	s5, sa_s5		# load s5 register
	lw	s6, sa_s6		# load s6 register
	addi	sp, sp, sa_size		# free stack for save area
	ret				# return
