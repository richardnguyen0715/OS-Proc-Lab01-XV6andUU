
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primes>:
#include "kernel/stat.h"
#include "user/user.h"

void primes(int cur_pipe)__attribute__((noreturn));

void primes(int cur_pipe) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
    int val;
    int c_read = read(cur_pipe, &val, sizeof(val));
   c:	4611                	li	a2,4
   e:	fdc40593          	addi	a1,s0,-36
  12:	3a4000ef          	jal	3b6 <read>
    if (c_read == 0) {
  16:	c129                	beqz	a0,58 <primes+0x58>
        close(cur_pipe);
        exit(0);
    } else if (c_read < 0) {
  18:	04054663          	bltz	a0,64 <primes+0x64>
        printf("Error reading initial value from pipe\n");
        close(cur_pipe);
        exit(1);
    }

    printf("prime: %d\n", val);
  1c:	fdc42583          	lw	a1,-36(s0)
  20:	00001517          	auipc	a0,0x1
  24:	98050513          	addi	a0,a0,-1664 # 9a0 <malloc+0x136>
  28:	78e000ef          	jal	7b6 <printf>

    int check_prime;
    while (read(cur_pipe, &check_prime, sizeof(check_prime)) > 0) {
  2c:	4611                	li	a2,4
  2e:	fd840593          	addi	a1,s0,-40
  32:	8526                	mv	a0,s1
  34:	382000ef          	jal	3b6 <read>
  38:	04a05263          	blez	a0,7c <primes+0x7c>
        if (check_prime % val != 0) {
  3c:	fd842583          	lw	a1,-40(s0)
  40:	fdc42783          	lw	a5,-36(s0)
  44:	02f5e7bb          	remw	a5,a1,a5
  48:	d3f5                	beqz	a5,2c <primes+0x2c>
            printf("prime: %d\n", check_prime); // Print prime directly
  4a:	00001517          	auipc	a0,0x1
  4e:	95650513          	addi	a0,a0,-1706 # 9a0 <malloc+0x136>
  52:	764000ef          	jal	7b6 <printf>
  56:	bfd9                	j	2c <primes+0x2c>
        close(cur_pipe);
  58:	8526                	mv	a0,s1
  5a:	36c000ef          	jal	3c6 <close>
        exit(0);
  5e:	4501                	li	a0,0
  60:	33e000ef          	jal	39e <exit>
        printf("Error reading initial value from pipe\n");
  64:	00001517          	auipc	a0,0x1
  68:	90c50513          	addi	a0,a0,-1780 # 970 <malloc+0x106>
  6c:	74a000ef          	jal	7b6 <printf>
        close(cur_pipe);
  70:	8526                	mv	a0,s1
  72:	354000ef          	jal	3c6 <close>
        exit(1);
  76:	4505                	li	a0,1
  78:	326000ef          	jal	39e <exit>
        }
    }

    close(cur_pipe);
  7c:	8526                	mv	a0,s1
  7e:	348000ef          	jal	3c6 <close>
    exit(0);
  82:	4501                	li	a0,0
  84:	31a000ef          	jal	39e <exit>

0000000000000088 <main>:
}

int main() {
  88:	7179                	addi	sp,sp,-48
  8a:	f406                	sd	ra,40(sp)
  8c:	f022                	sd	s0,32(sp)
  8e:	ec26                	sd	s1,24(sp)
  90:	1800                	addi	s0,sp,48
    int fd[2];
    if (pipe(fd) < 0) {
  92:	fd840513          	addi	a0,s0,-40
  96:	318000ef          	jal	3ae <pipe>
  9a:	00054f63          	bltz	a0,b8 <main+0x30>
        printf("Cannot create pipe! - Error: pipe() function failed!\n");
        exit(1);
    }

    int pid = fork();
  9e:	2f8000ef          	jal	396 <fork>
    if (pid < 0) {
  a2:	02054463          	bltz	a0,ca <main+0x42>
        printf("RaiseError: Cannot create process!\n");
        exit(1);
    } else if (pid == 0) {
  a6:	e91d                	bnez	a0,dc <main+0x54>
        // This is the child process
        close(fd[1]); // Close write end of pipe in the child
  a8:	fdc42503          	lw	a0,-36(s0)
  ac:	31a000ef          	jal	3c6 <close>
        primes(fd[0]); // Start the prime number filtering
  b0:	fd842503          	lw	a0,-40(s0)
  b4:	f4dff0ef          	jal	0 <primes>
        printf("Cannot create pipe! - Error: pipe() function failed!\n");
  b8:	00001517          	auipc	a0,0x1
  bc:	8f850513          	addi	a0,a0,-1800 # 9b0 <malloc+0x146>
  c0:	6f6000ef          	jal	7b6 <printf>
        exit(1);
  c4:	4505                	li	a0,1
  c6:	2d8000ef          	jal	39e <exit>
        printf("RaiseError: Cannot create process!\n");
  ca:	00001517          	auipc	a0,0x1
  ce:	91e50513          	addi	a0,a0,-1762 # 9e8 <malloc+0x17e>
  d2:	6e4000ef          	jal	7b6 <printf>
        exit(1);
  d6:	4505                	li	a0,1
  d8:	2c6000ef          	jal	39e <exit>
    } else {
        // This is the parent process
        close(fd[0]); // Close read end of pipe in the parent
  dc:	fd842503          	lw	a0,-40(s0)
  e0:	2e6000ef          	jal	3c6 <close>

        for (int i = 2; i <= 280; i++) {
  e4:	4789                	li	a5,2
  e6:	fcf42a23          	sw	a5,-44(s0)
  ea:	11800493          	li	s1,280
            if (write(fd[1], &i, sizeof(i)) < 0) {
  ee:	4611                	li	a2,4
  f0:	fd440593          	addi	a1,s0,-44
  f4:	fdc42503          	lw	a0,-36(s0)
  f8:	2c6000ef          	jal	3be <write>
  fc:	00054c63          	bltz	a0,114 <main+0x8c>
        for (int i = 2; i <= 280; i++) {
 100:	fd442783          	lw	a5,-44(s0)
 104:	2785                	addiw	a5,a5,1
 106:	0007871b          	sext.w	a4,a5
 10a:	fcf42a23          	sw	a5,-44(s0)
 10e:	fee4d0e3          	bge	s1,a4,ee <main+0x66>
 112:	a039                	j	120 <main+0x98>
                printf("Error writing to pipe\n");
 114:	00001517          	auipc	a0,0x1
 118:	8fc50513          	addi	a0,a0,-1796 # a10 <malloc+0x1a6>
 11c:	69a000ef          	jal	7b6 <printf>
                break;
            }
        }

        close(fd[1]); // Close write end after sending all numbers
 120:	fdc42503          	lw	a0,-36(s0)
 124:	2a2000ef          	jal	3c6 <close>
        wait(0); // Wait for the child process to finish
 128:	4501                	li	a0,0
 12a:	27c000ef          	jal	3a6 <wait>
    }

    exit(0);
 12e:	4501                	li	a0,0
 130:	26e000ef          	jal	39e <exit>

0000000000000134 <start>:
 134:	1141                	addi	sp,sp,-16
 136:	e406                	sd	ra,8(sp)
 138:	e022                	sd	s0,0(sp)
 13a:	0800                	addi	s0,sp,16
 13c:	f4dff0ef          	jal	88 <main>
 140:	4501                	li	a0,0
 142:	25c000ef          	jal	39e <exit>

0000000000000146 <strcpy>:
 146:	1141                	addi	sp,sp,-16
 148:	e422                	sd	s0,8(sp)
 14a:	0800                	addi	s0,sp,16
 14c:	87aa                	mv	a5,a0
 14e:	0585                	addi	a1,a1,1
 150:	0785                	addi	a5,a5,1
 152:	fff5c703          	lbu	a4,-1(a1)
 156:	fee78fa3          	sb	a4,-1(a5)
 15a:	fb75                	bnez	a4,14e <strcpy+0x8>
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strcmp>:
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
 168:	00054783          	lbu	a5,0(a0)
 16c:	cb91                	beqz	a5,180 <strcmp+0x1e>
 16e:	0005c703          	lbu	a4,0(a1)
 172:	00f71763          	bne	a4,a5,180 <strcmp+0x1e>
 176:	0505                	addi	a0,a0,1
 178:	0585                	addi	a1,a1,1
 17a:	00054783          	lbu	a5,0(a0)
 17e:	fbe5                	bnez	a5,16e <strcmp+0xc>
 180:	0005c503          	lbu	a0,0(a1)
 184:	40a7853b          	subw	a0,a5,a0
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret

000000000000018e <strlen>:
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
 194:	00054783          	lbu	a5,0(a0)
 198:	cf91                	beqz	a5,1b4 <strlen+0x26>
 19a:	0505                	addi	a0,a0,1
 19c:	87aa                	mv	a5,a0
 19e:	86be                	mv	a3,a5
 1a0:	0785                	addi	a5,a5,1
 1a2:	fff7c703          	lbu	a4,-1(a5)
 1a6:	ff65                	bnez	a4,19e <strlen+0x10>
 1a8:	40a6853b          	subw	a0,a3,a0
 1ac:	2505                	addiw	a0,a0,1
 1ae:	6422                	ld	s0,8(sp)
 1b0:	0141                	addi	sp,sp,16
 1b2:	8082                	ret
 1b4:	4501                	li	a0,0
 1b6:	bfe5                	j	1ae <strlen+0x20>

00000000000001b8 <memset>:
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	addi	s0,sp,16
 1be:	ca19                	beqz	a2,1d4 <memset+0x1c>
 1c0:	87aa                	mv	a5,a0
 1c2:	1602                	slli	a2,a2,0x20
 1c4:	9201                	srli	a2,a2,0x20
 1c6:	00a60733          	add	a4,a2,a0
 1ca:	00b78023          	sb	a1,0(a5)
 1ce:	0785                	addi	a5,a5,1
 1d0:	fee79de3          	bne	a5,a4,1ca <memset+0x12>
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret

00000000000001da <strchr>:
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
 1e0:	00054783          	lbu	a5,0(a0)
 1e4:	cb99                	beqz	a5,1fa <strchr+0x20>
 1e6:	00f58763          	beq	a1,a5,1f4 <strchr+0x1a>
 1ea:	0505                	addi	a0,a0,1
 1ec:	00054783          	lbu	a5,0(a0)
 1f0:	fbfd                	bnez	a5,1e6 <strchr+0xc>
 1f2:	4501                	li	a0,0
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <strchr+0x1a>

00000000000001fe <gets>:
 1fe:	711d                	addi	sp,sp,-96
 200:	ec86                	sd	ra,88(sp)
 202:	e8a2                	sd	s0,80(sp)
 204:	e4a6                	sd	s1,72(sp)
 206:	e0ca                	sd	s2,64(sp)
 208:	fc4e                	sd	s3,56(sp)
 20a:	f852                	sd	s4,48(sp)
 20c:	f456                	sd	s5,40(sp)
 20e:	f05a                	sd	s6,32(sp)
 210:	ec5e                	sd	s7,24(sp)
 212:	1080                	addi	s0,sp,96
 214:	8baa                	mv	s7,a0
 216:	8a2e                	mv	s4,a1
 218:	892a                	mv	s2,a0
 21a:	4481                	li	s1,0
 21c:	4aa9                	li	s5,10
 21e:	4b35                	li	s6,13
 220:	89a6                	mv	s3,s1
 222:	2485                	addiw	s1,s1,1
 224:	0344d663          	bge	s1,s4,250 <gets+0x52>
 228:	4605                	li	a2,1
 22a:	faf40593          	addi	a1,s0,-81
 22e:	4501                	li	a0,0
 230:	186000ef          	jal	3b6 <read>
 234:	00a05e63          	blez	a0,250 <gets+0x52>
 238:	faf44783          	lbu	a5,-81(s0)
 23c:	00f90023          	sb	a5,0(s2)
 240:	01578763          	beq	a5,s5,24e <gets+0x50>
 244:	0905                	addi	s2,s2,1
 246:	fd679de3          	bne	a5,s6,220 <gets+0x22>
 24a:	89a6                	mv	s3,s1
 24c:	a011                	j	250 <gets+0x52>
 24e:	89a6                	mv	s3,s1
 250:	99de                	add	s3,s3,s7
 252:	00098023          	sb	zero,0(s3)
 256:	855e                	mv	a0,s7
 258:	60e6                	ld	ra,88(sp)
 25a:	6446                	ld	s0,80(sp)
 25c:	64a6                	ld	s1,72(sp)
 25e:	6906                	ld	s2,64(sp)
 260:	79e2                	ld	s3,56(sp)
 262:	7a42                	ld	s4,48(sp)
 264:	7aa2                	ld	s5,40(sp)
 266:	7b02                	ld	s6,32(sp)
 268:	6be2                	ld	s7,24(sp)
 26a:	6125                	addi	sp,sp,96
 26c:	8082                	ret

000000000000026e <stat>:
 26e:	1101                	addi	sp,sp,-32
 270:	ec06                	sd	ra,24(sp)
 272:	e822                	sd	s0,16(sp)
 274:	e04a                	sd	s2,0(sp)
 276:	1000                	addi	s0,sp,32
 278:	892e                	mv	s2,a1
 27a:	4581                	li	a1,0
 27c:	162000ef          	jal	3de <open>
 280:	02054263          	bltz	a0,2a4 <stat+0x36>
 284:	e426                	sd	s1,8(sp)
 286:	84aa                	mv	s1,a0
 288:	85ca                	mv	a1,s2
 28a:	16c000ef          	jal	3f6 <fstat>
 28e:	892a                	mv	s2,a0
 290:	8526                	mv	a0,s1
 292:	134000ef          	jal	3c6 <close>
 296:	64a2                	ld	s1,8(sp)
 298:	854a                	mv	a0,s2
 29a:	60e2                	ld	ra,24(sp)
 29c:	6442                	ld	s0,16(sp)
 29e:	6902                	ld	s2,0(sp)
 2a0:	6105                	addi	sp,sp,32
 2a2:	8082                	ret
 2a4:	597d                	li	s2,-1
 2a6:	bfcd                	j	298 <stat+0x2a>

00000000000002a8 <atoi>:
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
 2ae:	00054683          	lbu	a3,0(a0)
 2b2:	fd06879b          	addiw	a5,a3,-48
 2b6:	0ff7f793          	zext.b	a5,a5
 2ba:	4625                	li	a2,9
 2bc:	02f66863          	bltu	a2,a5,2ec <atoi+0x44>
 2c0:	872a                	mv	a4,a0
 2c2:	4501                	li	a0,0
 2c4:	0705                	addi	a4,a4,1
 2c6:	0025179b          	slliw	a5,a0,0x2
 2ca:	9fa9                	addw	a5,a5,a0
 2cc:	0017979b          	slliw	a5,a5,0x1
 2d0:	9fb5                	addw	a5,a5,a3
 2d2:	fd07851b          	addiw	a0,a5,-48
 2d6:	00074683          	lbu	a3,0(a4)
 2da:	fd06879b          	addiw	a5,a3,-48
 2de:	0ff7f793          	zext.b	a5,a5
 2e2:	fef671e3          	bgeu	a2,a5,2c4 <atoi+0x1c>
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
 2ec:	4501                	li	a0,0
 2ee:	bfe5                	j	2e6 <atoi+0x3e>

00000000000002f0 <memmove>:
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
 2f6:	02b57463          	bgeu	a0,a1,31e <memmove+0x2e>
 2fa:	00c05f63          	blez	a2,318 <memmove+0x28>
 2fe:	1602                	slli	a2,a2,0x20
 300:	9201                	srli	a2,a2,0x20
 302:	00c507b3          	add	a5,a0,a2
 306:	872a                	mv	a4,a0
 308:	0585                	addi	a1,a1,1
 30a:	0705                	addi	a4,a4,1
 30c:	fff5c683          	lbu	a3,-1(a1)
 310:	fed70fa3          	sb	a3,-1(a4)
 314:	fef71ae3          	bne	a4,a5,308 <memmove+0x18>
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
 31e:	00c50733          	add	a4,a0,a2
 322:	95b2                	add	a1,a1,a2
 324:	fec05ae3          	blez	a2,318 <memmove+0x28>
 328:	fff6079b          	addiw	a5,a2,-1
 32c:	1782                	slli	a5,a5,0x20
 32e:	9381                	srli	a5,a5,0x20
 330:	fff7c793          	not	a5,a5
 334:	97ba                	add	a5,a5,a4
 336:	15fd                	addi	a1,a1,-1
 338:	177d                	addi	a4,a4,-1
 33a:	0005c683          	lbu	a3,0(a1)
 33e:	00d70023          	sb	a3,0(a4)
 342:	fee79ae3          	bne	a5,a4,336 <memmove+0x46>
 346:	bfc9                	j	318 <memmove+0x28>

0000000000000348 <memcmp>:
 348:	1141                	addi	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	addi	s0,sp,16
 34e:	ca05                	beqz	a2,37e <memcmp+0x36>
 350:	fff6069b          	addiw	a3,a2,-1
 354:	1682                	slli	a3,a3,0x20
 356:	9281                	srli	a3,a3,0x20
 358:	0685                	addi	a3,a3,1
 35a:	96aa                	add	a3,a3,a0
 35c:	00054783          	lbu	a5,0(a0)
 360:	0005c703          	lbu	a4,0(a1)
 364:	00e79863          	bne	a5,a4,374 <memcmp+0x2c>
 368:	0505                	addi	a0,a0,1
 36a:	0585                	addi	a1,a1,1
 36c:	fed518e3          	bne	a0,a3,35c <memcmp+0x14>
 370:	4501                	li	a0,0
 372:	a019                	j	378 <memcmp+0x30>
 374:	40e7853b          	subw	a0,a5,a4
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
 37e:	4501                	li	a0,0
 380:	bfe5                	j	378 <memcmp+0x30>

0000000000000382 <memcpy>:
 382:	1141                	addi	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	addi	s0,sp,16
 38a:	f67ff0ef          	jal	2f0 <memmove>
 38e:	60a2                	ld	ra,8(sp)
 390:	6402                	ld	s0,0(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret

0000000000000396 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 396:	4885                	li	a7,1
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <exit>:
.global exit
exit:
 li a7, SYS_exit
 39e:	4889                	li	a7,2
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a6:	488d                	li	a7,3
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ae:	4891                	li	a7,4
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <read>:
.global read
read:
 li a7, SYS_read
 3b6:	4895                	li	a7,5
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <write>:
.global write
write:
 li a7, SYS_write
 3be:	48c1                	li	a7,16
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <close>:
.global close
close:
 li a7, SYS_close
 3c6:	48d5                	li	a7,21
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ce:	4899                	li	a7,6
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d6:	489d                	li	a7,7
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <open>:
.global open
open:
 li a7, SYS_open
 3de:	48bd                	li	a7,15
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e6:	48c5                	li	a7,17
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ee:	48c9                	li	a7,18
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f6:	48a1                	li	a7,8
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <link>:
.global link
link:
 li a7, SYS_link
 3fe:	48cd                	li	a7,19
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 406:	48d1                	li	a7,20
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40e:	48a5                	li	a7,9
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <dup>:
.global dup
dup:
 li a7, SYS_dup
 416:	48a9                	li	a7,10
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41e:	48ad                	li	a7,11
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 426:	48b1                	li	a7,12
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 42e:	48b5                	li	a7,13
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 436:	48b9                	li	a7,14
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43e:	1101                	addi	sp,sp,-32
 440:	ec06                	sd	ra,24(sp)
 442:	e822                	sd	s0,16(sp)
 444:	1000                	addi	s0,sp,32
 446:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44a:	4605                	li	a2,1
 44c:	fef40593          	addi	a1,s0,-17
 450:	f6fff0ef          	jal	3be <write>
}
 454:	60e2                	ld	ra,24(sp)
 456:	6442                	ld	s0,16(sp)
 458:	6105                	addi	sp,sp,32
 45a:	8082                	ret

000000000000045c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45c:	7139                	addi	sp,sp,-64
 45e:	fc06                	sd	ra,56(sp)
 460:	f822                	sd	s0,48(sp)
 462:	f426                	sd	s1,40(sp)
 464:	0080                	addi	s0,sp,64
 466:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 468:	c299                	beqz	a3,46e <printint+0x12>
 46a:	0805c963          	bltz	a1,4fc <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 46e:	2581                	sext.w	a1,a1
  neg = 0;
 470:	4881                	li	a7,0
 472:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 476:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 478:	2601                	sext.w	a2,a2
 47a:	00000517          	auipc	a0,0x0
 47e:	5b650513          	addi	a0,a0,1462 # a30 <digits>
 482:	883a                	mv	a6,a4
 484:	2705                	addiw	a4,a4,1
 486:	02c5f7bb          	remuw	a5,a1,a2
 48a:	1782                	slli	a5,a5,0x20
 48c:	9381                	srli	a5,a5,0x20
 48e:	97aa                	add	a5,a5,a0
 490:	0007c783          	lbu	a5,0(a5)
 494:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 498:	0005879b          	sext.w	a5,a1
 49c:	02c5d5bb          	divuw	a1,a1,a2
 4a0:	0685                	addi	a3,a3,1
 4a2:	fec7f0e3          	bgeu	a5,a2,482 <printint+0x26>
  if(neg)
 4a6:	00088c63          	beqz	a7,4be <printint+0x62>
    buf[i++] = '-';
 4aa:	fd070793          	addi	a5,a4,-48
 4ae:	00878733          	add	a4,a5,s0
 4b2:	02d00793          	li	a5,45
 4b6:	fef70823          	sb	a5,-16(a4)
 4ba:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4be:	02e05a63          	blez	a4,4f2 <printint+0x96>
 4c2:	f04a                	sd	s2,32(sp)
 4c4:	ec4e                	sd	s3,24(sp)
 4c6:	fc040793          	addi	a5,s0,-64
 4ca:	00e78933          	add	s2,a5,a4
 4ce:	fff78993          	addi	s3,a5,-1
 4d2:	99ba                	add	s3,s3,a4
 4d4:	377d                	addiw	a4,a4,-1
 4d6:	1702                	slli	a4,a4,0x20
 4d8:	9301                	srli	a4,a4,0x20
 4da:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4de:	fff94583          	lbu	a1,-1(s2)
 4e2:	8526                	mv	a0,s1
 4e4:	f5bff0ef          	jal	43e <putc>
  while(--i >= 0)
 4e8:	197d                	addi	s2,s2,-1
 4ea:	ff391ae3          	bne	s2,s3,4de <printint+0x82>
 4ee:	7902                	ld	s2,32(sp)
 4f0:	69e2                	ld	s3,24(sp)
}
 4f2:	70e2                	ld	ra,56(sp)
 4f4:	7442                	ld	s0,48(sp)
 4f6:	74a2                	ld	s1,40(sp)
 4f8:	6121                	addi	sp,sp,64
 4fa:	8082                	ret
    x = -xx;
 4fc:	40b005bb          	negw	a1,a1
    neg = 1;
 500:	4885                	li	a7,1
    x = -xx;
 502:	bf85                	j	472 <printint+0x16>

0000000000000504 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 504:	711d                	addi	sp,sp,-96
 506:	ec86                	sd	ra,88(sp)
 508:	e8a2                	sd	s0,80(sp)
 50a:	e0ca                	sd	s2,64(sp)
 50c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 50e:	0005c903          	lbu	s2,0(a1)
 512:	26090863          	beqz	s2,782 <vprintf+0x27e>
 516:	e4a6                	sd	s1,72(sp)
 518:	fc4e                	sd	s3,56(sp)
 51a:	f852                	sd	s4,48(sp)
 51c:	f456                	sd	s5,40(sp)
 51e:	f05a                	sd	s6,32(sp)
 520:	ec5e                	sd	s7,24(sp)
 522:	e862                	sd	s8,16(sp)
 524:	e466                	sd	s9,8(sp)
 526:	8b2a                	mv	s6,a0
 528:	8a2e                	mv	s4,a1
 52a:	8bb2                	mv	s7,a2
  state = 0;
 52c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 52e:	4481                	li	s1,0
 530:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 532:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 536:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 53a:	06c00c93          	li	s9,108
 53e:	a005                	j	55e <vprintf+0x5a>
        putc(fd, c0);
 540:	85ca                	mv	a1,s2
 542:	855a                	mv	a0,s6
 544:	efbff0ef          	jal	43e <putc>
 548:	a019                	j	54e <vprintf+0x4a>
    } else if(state == '%'){
 54a:	03598263          	beq	s3,s5,56e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 54e:	2485                	addiw	s1,s1,1
 550:	8726                	mv	a4,s1
 552:	009a07b3          	add	a5,s4,s1
 556:	0007c903          	lbu	s2,0(a5)
 55a:	20090c63          	beqz	s2,772 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 55e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 562:	fe0994e3          	bnez	s3,54a <vprintf+0x46>
      if(c0 == '%'){
 566:	fd579de3          	bne	a5,s5,540 <vprintf+0x3c>
        state = '%';
 56a:	89be                	mv	s3,a5
 56c:	b7cd                	j	54e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 56e:	00ea06b3          	add	a3,s4,a4
 572:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 576:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 578:	c681                	beqz	a3,580 <vprintf+0x7c>
 57a:	9752                	add	a4,a4,s4
 57c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 580:	03878f63          	beq	a5,s8,5be <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 584:	05978963          	beq	a5,s9,5d6 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 588:	07500713          	li	a4,117
 58c:	0ee78363          	beq	a5,a4,672 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 590:	07800713          	li	a4,120
 594:	12e78563          	beq	a5,a4,6be <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 598:	07000713          	li	a4,112
 59c:	14e78a63          	beq	a5,a4,6f0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5a0:	07300713          	li	a4,115
 5a4:	18e78a63          	beq	a5,a4,738 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5a8:	02500713          	li	a4,37
 5ac:	04e79563          	bne	a5,a4,5f6 <vprintf+0xf2>
        putc(fd, '%');
 5b0:	02500593          	li	a1,37
 5b4:	855a                	mv	a0,s6
 5b6:	e89ff0ef          	jal	43e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bf49                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5be:	008b8913          	addi	s2,s7,8
 5c2:	4685                	li	a3,1
 5c4:	4629                	li	a2,10
 5c6:	000ba583          	lw	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	e91ff0ef          	jal	45c <printint>
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	bfad                	j	54e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5d6:	06400793          	li	a5,100
 5da:	02f68963          	beq	a3,a5,60c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5de:	06c00793          	li	a5,108
 5e2:	04f68263          	beq	a3,a5,626 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5e6:	07500793          	li	a5,117
 5ea:	0af68063          	beq	a3,a5,68a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5ee:	07800793          	li	a5,120
 5f2:	0ef68263          	beq	a3,a5,6d6 <vprintf+0x1d2>
        putc(fd, '%');
 5f6:	02500593          	li	a1,37
 5fa:	855a                	mv	a0,s6
 5fc:	e43ff0ef          	jal	43e <putc>
        putc(fd, c0);
 600:	85ca                	mv	a1,s2
 602:	855a                	mv	a0,s6
 604:	e3bff0ef          	jal	43e <putc>
      state = 0;
 608:	4981                	li	s3,0
 60a:	b791                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	008b8913          	addi	s2,s7,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000ba583          	lw	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	e43ff0ef          	jal	45c <printint>
        i += 1;
 61e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 620:	8bca                	mv	s7,s2
      state = 0;
 622:	4981                	li	s3,0
        i += 1;
 624:	b72d                	j	54e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 626:	06400793          	li	a5,100
 62a:	02f60763          	beq	a2,a5,658 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 62e:	07500793          	li	a5,117
 632:	06f60963          	beq	a2,a5,6a4 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 636:	07800793          	li	a5,120
 63a:	faf61ee3          	bne	a2,a5,5f6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63e:	008b8913          	addi	s2,s7,8
 642:	4681                	li	a3,0
 644:	4641                	li	a2,16
 646:	000ba583          	lw	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	e11ff0ef          	jal	45c <printint>
        i += 2;
 650:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
        i += 2;
 656:	bde5                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 658:	008b8913          	addi	s2,s7,8
 65c:	4685                	li	a3,1
 65e:	4629                	li	a2,10
 660:	000ba583          	lw	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	df7ff0ef          	jal	45c <printint>
        i += 2;
 66a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 66c:	8bca                	mv	s7,s2
      state = 0;
 66e:	4981                	li	s3,0
        i += 2;
 670:	bdf9                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 672:	008b8913          	addi	s2,s7,8
 676:	4681                	li	a3,0
 678:	4629                	li	a2,10
 67a:	000ba583          	lw	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	dddff0ef          	jal	45c <printint>
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
 688:	b5d9                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	008b8913          	addi	s2,s7,8
 68e:	4681                	li	a3,0
 690:	4629                	li	a2,10
 692:	000ba583          	lw	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	dc5ff0ef          	jal	45c <printint>
        i += 1;
 69c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
        i += 1;
 6a2:	b575                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a4:	008b8913          	addi	s2,s7,8
 6a8:	4681                	li	a3,0
 6aa:	4629                	li	a2,10
 6ac:	000ba583          	lw	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	dabff0ef          	jal	45c <printint>
        i += 2;
 6b6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
        i += 2;
 6bc:	bd49                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6be:	008b8913          	addi	s2,s7,8
 6c2:	4681                	li	a3,0
 6c4:	4641                	li	a2,16
 6c6:	000ba583          	lw	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	d91ff0ef          	jal	45c <printint>
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bdad                	j	54e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d6:	008b8913          	addi	s2,s7,8
 6da:	4681                	li	a3,0
 6dc:	4641                	li	a2,16
 6de:	000ba583          	lw	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	d79ff0ef          	jal	45c <printint>
        i += 1;
 6e8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	8bca                	mv	s7,s2
      state = 0;
 6ec:	4981                	li	s3,0
        i += 1;
 6ee:	b585                	j	54e <vprintf+0x4a>
 6f0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6f2:	008b8d13          	addi	s10,s7,8
 6f6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6fa:	03000593          	li	a1,48
 6fe:	855a                	mv	a0,s6
 700:	d3fff0ef          	jal	43e <putc>
  putc(fd, 'x');
 704:	07800593          	li	a1,120
 708:	855a                	mv	a0,s6
 70a:	d35ff0ef          	jal	43e <putc>
 70e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 710:	00000b97          	auipc	s7,0x0
 714:	320b8b93          	addi	s7,s7,800 # a30 <digits>
 718:	03c9d793          	srli	a5,s3,0x3c
 71c:	97de                	add	a5,a5,s7
 71e:	0007c583          	lbu	a1,0(a5)
 722:	855a                	mv	a0,s6
 724:	d1bff0ef          	jal	43e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 728:	0992                	slli	s3,s3,0x4
 72a:	397d                	addiw	s2,s2,-1
 72c:	fe0916e3          	bnez	s2,718 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 730:	8bea                	mv	s7,s10
      state = 0;
 732:	4981                	li	s3,0
 734:	6d02                	ld	s10,0(sp)
 736:	bd21                	j	54e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 738:	008b8993          	addi	s3,s7,8
 73c:	000bb903          	ld	s2,0(s7)
 740:	00090f63          	beqz	s2,75e <vprintf+0x25a>
        for(; *s; s++)
 744:	00094583          	lbu	a1,0(s2)
 748:	c195                	beqz	a1,76c <vprintf+0x268>
          putc(fd, *s);
 74a:	855a                	mv	a0,s6
 74c:	cf3ff0ef          	jal	43e <putc>
        for(; *s; s++)
 750:	0905                	addi	s2,s2,1
 752:	00094583          	lbu	a1,0(s2)
 756:	f9f5                	bnez	a1,74a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 758:	8bce                	mv	s7,s3
      state = 0;
 75a:	4981                	li	s3,0
 75c:	bbcd                	j	54e <vprintf+0x4a>
          s = "(null)";
 75e:	00000917          	auipc	s2,0x0
 762:	2ca90913          	addi	s2,s2,714 # a28 <malloc+0x1be>
        for(; *s; s++)
 766:	02800593          	li	a1,40
 76a:	b7c5                	j	74a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 76c:	8bce                	mv	s7,s3
      state = 0;
 76e:	4981                	li	s3,0
 770:	bbf9                	j	54e <vprintf+0x4a>
 772:	64a6                	ld	s1,72(sp)
 774:	79e2                	ld	s3,56(sp)
 776:	7a42                	ld	s4,48(sp)
 778:	7aa2                	ld	s5,40(sp)
 77a:	7b02                	ld	s6,32(sp)
 77c:	6be2                	ld	s7,24(sp)
 77e:	6c42                	ld	s8,16(sp)
 780:	6ca2                	ld	s9,8(sp)
    }
  }
}
 782:	60e6                	ld	ra,88(sp)
 784:	6446                	ld	s0,80(sp)
 786:	6906                	ld	s2,64(sp)
 788:	6125                	addi	sp,sp,96
 78a:	8082                	ret

000000000000078c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 78c:	715d                	addi	sp,sp,-80
 78e:	ec06                	sd	ra,24(sp)
 790:	e822                	sd	s0,16(sp)
 792:	1000                	addi	s0,sp,32
 794:	e010                	sd	a2,0(s0)
 796:	e414                	sd	a3,8(s0)
 798:	e818                	sd	a4,16(s0)
 79a:	ec1c                	sd	a5,24(s0)
 79c:	03043023          	sd	a6,32(s0)
 7a0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a8:	8622                	mv	a2,s0
 7aa:	d5bff0ef          	jal	504 <vprintf>
}
 7ae:	60e2                	ld	ra,24(sp)
 7b0:	6442                	ld	s0,16(sp)
 7b2:	6161                	addi	sp,sp,80
 7b4:	8082                	ret

00000000000007b6 <printf>:

void
printf(const char *fmt, ...)
{
 7b6:	711d                	addi	sp,sp,-96
 7b8:	ec06                	sd	ra,24(sp)
 7ba:	e822                	sd	s0,16(sp)
 7bc:	1000                	addi	s0,sp,32
 7be:	e40c                	sd	a1,8(s0)
 7c0:	e810                	sd	a2,16(s0)
 7c2:	ec14                	sd	a3,24(s0)
 7c4:	f018                	sd	a4,32(s0)
 7c6:	f41c                	sd	a5,40(s0)
 7c8:	03043823          	sd	a6,48(s0)
 7cc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d0:	00840613          	addi	a2,s0,8
 7d4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d8:	85aa                	mv	a1,a0
 7da:	4505                	li	a0,1
 7dc:	d29ff0ef          	jal	504 <vprintf>
}
 7e0:	60e2                	ld	ra,24(sp)
 7e2:	6442                	ld	s0,16(sp)
 7e4:	6125                	addi	sp,sp,96
 7e6:	8082                	ret

00000000000007e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e8:	1141                	addi	sp,sp,-16
 7ea:	e422                	sd	s0,8(sp)
 7ec:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ee:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f2:	00001797          	auipc	a5,0x1
 7f6:	80e7b783          	ld	a5,-2034(a5) # 1000 <freep>
 7fa:	a02d                	j	824 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fc:	4618                	lw	a4,8(a2)
 7fe:	9f2d                	addw	a4,a4,a1
 800:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 804:	6398                	ld	a4,0(a5)
 806:	6310                	ld	a2,0(a4)
 808:	a83d                	j	846 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 80a:	ff852703          	lw	a4,-8(a0)
 80e:	9f31                	addw	a4,a4,a2
 810:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 812:	ff053683          	ld	a3,-16(a0)
 816:	a091                	j	85a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 818:	6398                	ld	a4,0(a5)
 81a:	00e7e463          	bltu	a5,a4,822 <free+0x3a>
 81e:	00e6ea63          	bltu	a3,a4,832 <free+0x4a>
{
 822:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 824:	fed7fae3          	bgeu	a5,a3,818 <free+0x30>
 828:	6398                	ld	a4,0(a5)
 82a:	00e6e463          	bltu	a3,a4,832 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82e:	fee7eae3          	bltu	a5,a4,822 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 832:	ff852583          	lw	a1,-8(a0)
 836:	6390                	ld	a2,0(a5)
 838:	02059813          	slli	a6,a1,0x20
 83c:	01c85713          	srli	a4,a6,0x1c
 840:	9736                	add	a4,a4,a3
 842:	fae60de3          	beq	a2,a4,7fc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 84a:	4790                	lw	a2,8(a5)
 84c:	02061593          	slli	a1,a2,0x20
 850:	01c5d713          	srli	a4,a1,0x1c
 854:	973e                	add	a4,a4,a5
 856:	fae68ae3          	beq	a3,a4,80a <free+0x22>
    p->s.ptr = bp->s.ptr;
 85a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 85c:	00000717          	auipc	a4,0x0
 860:	7af73223          	sd	a5,1956(a4) # 1000 <freep>
}
 864:	6422                	ld	s0,8(sp)
 866:	0141                	addi	sp,sp,16
 868:	8082                	ret

000000000000086a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 86a:	7139                	addi	sp,sp,-64
 86c:	fc06                	sd	ra,56(sp)
 86e:	f822                	sd	s0,48(sp)
 870:	f426                	sd	s1,40(sp)
 872:	ec4e                	sd	s3,24(sp)
 874:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 876:	02051493          	slli	s1,a0,0x20
 87a:	9081                	srli	s1,s1,0x20
 87c:	04bd                	addi	s1,s1,15
 87e:	8091                	srli	s1,s1,0x4
 880:	0014899b          	addiw	s3,s1,1
 884:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 886:	00000517          	auipc	a0,0x0
 88a:	77a53503          	ld	a0,1914(a0) # 1000 <freep>
 88e:	c915                	beqz	a0,8c2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 892:	4798                	lw	a4,8(a5)
 894:	08977a63          	bgeu	a4,s1,928 <malloc+0xbe>
 898:	f04a                	sd	s2,32(sp)
 89a:	e852                	sd	s4,16(sp)
 89c:	e456                	sd	s5,8(sp)
 89e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8a0:	8a4e                	mv	s4,s3
 8a2:	0009871b          	sext.w	a4,s3
 8a6:	6685                	lui	a3,0x1
 8a8:	00d77363          	bgeu	a4,a3,8ae <malloc+0x44>
 8ac:	6a05                	lui	s4,0x1
 8ae:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b6:	00000917          	auipc	s2,0x0
 8ba:	74a90913          	addi	s2,s2,1866 # 1000 <freep>
  if(p == (char*)-1)
 8be:	5afd                	li	s5,-1
 8c0:	a081                	j	900 <malloc+0x96>
 8c2:	f04a                	sd	s2,32(sp)
 8c4:	e852                	sd	s4,16(sp)
 8c6:	e456                	sd	s5,8(sp)
 8c8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8ca:	00000797          	auipc	a5,0x0
 8ce:	74678793          	addi	a5,a5,1862 # 1010 <base>
 8d2:	00000717          	auipc	a4,0x0
 8d6:	72f73723          	sd	a5,1838(a4) # 1000 <freep>
 8da:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8dc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e0:	b7c1                	j	8a0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8e2:	6398                	ld	a4,0(a5)
 8e4:	e118                	sd	a4,0(a0)
 8e6:	a8a9                	j	940 <malloc+0xd6>
  hp->s.size = nu;
 8e8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ec:	0541                	addi	a0,a0,16
 8ee:	efbff0ef          	jal	7e8 <free>
  return freep;
 8f2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f6:	c12d                	beqz	a0,958 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fa:	4798                	lw	a4,8(a5)
 8fc:	02977263          	bgeu	a4,s1,920 <malloc+0xb6>
    if(p == freep)
 900:	00093703          	ld	a4,0(s2)
 904:	853e                	mv	a0,a5
 906:	fef719e3          	bne	a4,a5,8f8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 90a:	8552                	mv	a0,s4
 90c:	b1bff0ef          	jal	426 <sbrk>
  if(p == (char*)-1)
 910:	fd551ce3          	bne	a0,s5,8e8 <malloc+0x7e>
        return 0;
 914:	4501                	li	a0,0
 916:	7902                	ld	s2,32(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
 91e:	a03d                	j	94c <malloc+0xe2>
 920:	7902                	ld	s2,32(sp)
 922:	6a42                	ld	s4,16(sp)
 924:	6aa2                	ld	s5,8(sp)
 926:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 928:	fae48de3          	beq	s1,a4,8e2 <malloc+0x78>
        p->s.size -= nunits;
 92c:	4137073b          	subw	a4,a4,s3
 930:	c798                	sw	a4,8(a5)
        p += p->s.size;
 932:	02071693          	slli	a3,a4,0x20
 936:	01c6d713          	srli	a4,a3,0x1c
 93a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 940:	00000717          	auipc	a4,0x0
 944:	6ca73023          	sd	a0,1728(a4) # 1000 <freep>
      return (void*)(p + 1);
 948:	01078513          	addi	a0,a5,16
  }
}
 94c:	70e2                	ld	ra,56(sp)
 94e:	7442                	ld	s0,48(sp)
 950:	74a2                	ld	s1,40(sp)
 952:	69e2                	ld	s3,24(sp)
 954:	6121                	addi	sp,sp,64
 956:	8082                	ret
 958:	7902                	ld	s2,32(sp)
 95a:	6a42                	ld	s4,16(sp)
 95c:	6aa2                	ld	s5,8(sp)
 95e:	6b02                	ld	s6,0(sp)
 960:	b7f5                	j	94c <malloc+0xe2>
