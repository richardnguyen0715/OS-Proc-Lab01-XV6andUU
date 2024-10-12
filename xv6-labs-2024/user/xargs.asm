
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
#include "kernel/param.h"



//print to announce the command is going to xargs
int getcmd(char* buf, int nbuf) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
  memset(buf, 0, nbuf);
  10:	862e                	mv	a2,a1
  12:	4581                	li	a1,0
  14:	254000ef          	jal	268 <memset>
  gets(buf, nbuf);
  18:	85ca                	mv	a1,s2
  1a:	8526                	mv	a0,s1
  1c:	292000ef          	jal	2ae <gets>
  //printf("buf: %s\n", buf);
  if (buf[0] == 0) // EOF*
  20:	0004c503          	lbu	a0,0(s1)
  24:	00153513          	seqz	a0,a0
  {
    //printf("WOW!\n");*
    return -1;
  }
  return 0;
}
  28:	40a00533          	neg	a0,a0
  2c:	60e2                	ld	ra,24(sp)
  2e:	6442                	ld	s0,16(sp)
  30:	64a2                	ld	s1,8(sp)
  32:	6902                	ld	s2,0(sp)
  34:	6105                	addi	sp,sp,32
  36:	8082                	ret

0000000000000038 <gettoken>:
char whitespace[] = " \t\r\n\v";

int gettoken(char** ps, char* es, char**
  q, char** eq) {
  38:	7139                	addi	sp,sp,-64
  3a:	fc06                	sd	ra,56(sp)
  3c:	f822                	sd	s0,48(sp)
  3e:	f426                	sd	s1,40(sp)
  40:	f04a                	sd	s2,32(sp)
  42:	ec4e                	sd	s3,24(sp)
  44:	e852                	sd	s4,16(sp)
  46:	e456                	sd	s5,8(sp)
  48:	e05a                	sd	s6,0(sp)
  4a:	0080                	addi	s0,sp,64
  4c:	8a2a                	mv	s4,a0
  4e:	892e                	mv	s2,a1
  50:	8ab2                	mv	s5,a2
  52:	8b36                	mv	s6,a3
  char* s;
  int ret;

  s = *ps;
  54:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
  56:	00001997          	auipc	s3,0x1
  5a:	faa98993          	addi	s3,s3,-86 # 1000 <whitespace>
  5e:	00b4fc63          	bgeu	s1,a1,76 <gettoken+0x3e>
  62:	0004c583          	lbu	a1,0(s1)
  66:	854e                	mv	a0,s3
  68:	222000ef          	jal	28a <strchr>
  6c:	c509                	beqz	a0,76 <gettoken+0x3e>
    s++;
  6e:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
  70:	fe9919e3          	bne	s2,s1,62 <gettoken+0x2a>
  74:	84ca                	mv	s1,s2
  if (q)
  76:	000a8463          	beqz	s5,7e <gettoken+0x46>
    *q = s;
  7a:	009ab023          	sd	s1,0(s5)
  ret = *s;
  switch (*s) {
  7e:	0004c783          	lbu	a5,0(s1)
  82:	cb8d                	beqz	a5,b4 <gettoken+0x7c>
  case 0:
    break;
  default:
    ret = 'a';
    while (s < es && !strchr(whitespace, *s))
  84:	00001997          	auipc	s3,0x1
  88:	f7c98993          	addi	s3,s3,-132 # 1000 <whitespace>
  8c:	0724f963          	bgeu	s1,s2,fe <gettoken+0xc6>
  90:	0004c583          	lbu	a1,0(s1)
  94:	854e                	mv	a0,s3
  96:	1f4000ef          	jal	28a <strchr>
  9a:	e911                	bnez	a0,ae <gettoken+0x76>
      s++;
  9c:	0485                	addi	s1,s1,1
    while (s < es && !strchr(whitespace, *s))
  9e:	fe9919e3          	bne	s2,s1,90 <gettoken+0x58>
    break;
  }
  if (eq)
  a2:	84ca                	mv	s1,s2
    ret = 'a';
  a4:	06100a93          	li	s5,97
  if (eq)
  a8:	000b1963          	bnez	s6,ba <gettoken+0x82>
  ac:	a825                	j	e4 <gettoken+0xac>
    ret = 'a';
  ae:	06100a93          	li	s5,97
  b2:	a011                	j	b6 <gettoken+0x7e>
  ret = *s;
  b4:	4a81                	li	s5,0
  if (eq)
  b6:	000b0463          	beqz	s6,be <gettoken+0x86>
    *eq = s;
  ba:	009b3023          	sd	s1,0(s6)

  while (s < es && strchr(whitespace, *s))
  be:	00001997          	auipc	s3,0x1
  c2:	f4298993          	addi	s3,s3,-190 # 1000 <whitespace>
  c6:	0124fc63          	bgeu	s1,s2,de <gettoken+0xa6>
  ca:	0004c583          	lbu	a1,0(s1)
  ce:	854e                	mv	a0,s3
  d0:	1ba000ef          	jal	28a <strchr>
  d4:	c519                	beqz	a0,e2 <gettoken+0xaa>
    s++;
  d6:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
  d8:	fe9919e3          	bne	s2,s1,ca <gettoken+0x92>
  dc:	a021                	j	e4 <gettoken+0xac>
  de:	8926                	mv	s2,s1
  e0:	a011                	j	e4 <gettoken+0xac>
  e2:	8926                	mv	s2,s1
  *ps = s;
  e4:	012a3023          	sd	s2,0(s4)
  return ret;
}
  e8:	8556                	mv	a0,s5
  ea:	70e2                	ld	ra,56(sp)
  ec:	7442                	ld	s0,48(sp)
  ee:	74a2                	ld	s1,40(sp)
  f0:	7902                	ld	s2,32(sp)
  f2:	69e2                	ld	s3,24(sp)
  f4:	6a42                	ld	s4,16(sp)
  f6:	6aa2                	ld	s5,8(sp)
  f8:	6b02                	ld	s6,0(sp)
  fa:	6121                	addi	sp,sp,64
  fc:	8082                	ret
    ret = 'a';
  fe:	06100a93          	li	s5,97
  if (eq)
 102:	fa0b1ce3          	bnez	s6,ba <gettoken+0x82>
 106:	8926                	mv	s2,s1
 108:	bff1                	j	e4 <gettoken+0xac>

000000000000010a <main>:

int main(int argc, char* argv[]) {
 10a:	7149                	addi	sp,sp,-368
 10c:	f686                	sd	ra,360(sp)
 10e:	f2a2                	sd	s0,352(sp)
 110:	eea6                	sd	s1,344(sp)
 112:	eaca                	sd	s2,336(sp)
 114:	e6ce                	sd	s3,328(sp)
 116:	e2d2                	sd	s4,320(sp)
 118:	fe56                	sd	s5,312(sp)
 11a:	fa5a                	sd	s6,304(sp)
 11c:	f65e                	sd	s7,296(sp)
 11e:	1a80                	addi	s0,sp,368
  char* xargs[MAXARG];
  for (int i = 1; i < argc;i++) {
 120:	4785                	li	a5,1
 122:	02a7d563          	bge	a5,a0,14c <main+0x42>
 126:	00858713          	addi	a4,a1,8
 12a:	eb040793          	addi	a5,s0,-336
 12e:	ffe5061b          	addiw	a2,a0,-2
 132:	02061693          	slli	a3,a2,0x20
 136:	01d6d613          	srli	a2,a3,0x1d
 13a:	eb840693          	addi	a3,s0,-328
 13e:	9636                	add	a2,a2,a3
    // Skip xargs cmd name.*
    xargs[i - 1] = argv[i];
 140:	6314                	ld	a3,0(a4)
 142:	e394                	sd	a3,0(a5)
  for (int i = 1; i < argc;i++) {
 144:	0721                	addi	a4,a4,8
 146:	07a1                	addi	a5,a5,8
 148:	fec79ce3          	bne	a5,a2,140 <main+0x36>
  //   printf("xargs[%d]: %s\n", i, xargs[i]);
  // }

  static char buf[MAXARG][100];
  char* q, * eq;
  int j = argc - 1;
 14c:	fff50a9b          	addiw	s5,a0,-1
  int i = 0;
 150:	4a01                	li	s4,0
  // Split each line into array of args.*
  while (getcmd(buf[i], sizeof(buf[i])) >= 0) {
 152:	06400b13          	li	s6,100
 156:	00001b97          	auipc	s7,0x1
 15a:	ecab8b93          	addi	s7,s7,-310 # 1020 <buf.0>
 15e:	a80d                	j	190 <main+0x86>
    char* s = buf[i];
    char* es = s + strlen(s);
    while (gettoken(&s, es, &q, &eq) != 0) {
      // Set end to 0.*
      xargs[j] = q;
 160:	ea843783          	ld	a5,-344(s0)
 164:	e09c                	sd	a5,0(s1)
      *eq = 0;
 166:	ea043783          	ld	a5,-352(s0)
 16a:	00078023          	sb	zero,0(a5)
      j++;
      i++;
 16e:	2905                	addiw	s2,s2,1
 170:	04a1                	addi	s1,s1,8
    while (gettoken(&s, es, &q, &eq) != 0) {
 172:	ea040693          	addi	a3,s0,-352
 176:	ea840613          	addi	a2,s0,-344
 17a:	85ce                	mv	a1,s3
 17c:	e9840513          	addi	a0,s0,-360
 180:	eb9ff0ef          	jal	38 <gettoken>
 184:	fd71                	bnez	a0,160 <main+0x56>
 186:	414a8a3b          	subw	s4,s5,s4
 18a:	012a0abb          	addw	s5,s4,s2
 18e:	8a4a                	mv	s4,s2
  while (getcmd(buf[i], sizeof(buf[i])) >= 0) {
 190:	036a09b3          	mul	s3,s4,s6
 194:	99de                	add	s3,s3,s7
 196:	85da                	mv	a1,s6
 198:	854e                	mv	a0,s3
 19a:	e67ff0ef          	jal	0 <getcmd>
 19e:	02054163          	bltz	a0,1c0 <main+0xb6>
    char* s = buf[i];
 1a2:	e9343c23          	sd	s3,-360(s0)
    char* es = s + strlen(s);
 1a6:	854e                	mv	a0,s3
 1a8:	096000ef          	jal	23e <strlen>
 1ac:	1502                	slli	a0,a0,0x20
 1ae:	9101                	srli	a0,a0,0x20
 1b0:	99aa                	add	s3,s3,a0
    while (gettoken(&s, es, &q, &eq) != 0) {
 1b2:	003a9493          	slli	s1,s5,0x3
 1b6:	eb040793          	addi	a5,s0,-336
 1ba:	94be                	add	s1,s1,a5
 1bc:	8952                	mv	s2,s4
 1be:	bf55                	j	172 <main+0x68>
    }
  }

  int pid = fork();
 1c0:	286000ef          	jal	446 <fork>
  if (pid == 0) {
 1c4:	e911                	bnez	a0,1d8 <main+0xce>
    //printf("xargs[0]: %s\n", xargs[0]);
    exec(xargs[0], xargs);
 1c6:	eb040593          	addi	a1,s0,-336
 1ca:	eb043503          	ld	a0,-336(s0)
 1ce:	2b8000ef          	jal	486 <exec>
    exit(0);
 1d2:	4501                	li	a0,0
 1d4:	27a000ef          	jal	44e <exit>
  }
  wait(0);
 1d8:	4501                	li	a0,0
 1da:	27c000ef          	jal	456 <wait>
  
  exit(0);
 1de:	4501                	li	a0,0
 1e0:	26e000ef          	jal	44e <exit>

00000000000001e4 <start>:
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e406                	sd	ra,8(sp)
 1e8:	e022                	sd	s0,0(sp)
 1ea:	0800                	addi	s0,sp,16
 1ec:	f1fff0ef          	jal	10a <main>
 1f0:	4501                	li	a0,0
 1f2:	25c000ef          	jal	44e <exit>

00000000000001f6 <strcpy>:
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
 1fc:	87aa                	mv	a5,a0
 1fe:	0585                	addi	a1,a1,1
 200:	0785                	addi	a5,a5,1
 202:	fff5c703          	lbu	a4,-1(a1)
 206:	fee78fa3          	sb	a4,-1(a5)
 20a:	fb75                	bnez	a4,1fe <strcpy+0x8>
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <strcmp>:
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
 218:	00054783          	lbu	a5,0(a0)
 21c:	cb91                	beqz	a5,230 <strcmp+0x1e>
 21e:	0005c703          	lbu	a4,0(a1)
 222:	00f71763          	bne	a4,a5,230 <strcmp+0x1e>
 226:	0505                	addi	a0,a0,1
 228:	0585                	addi	a1,a1,1
 22a:	00054783          	lbu	a5,0(a0)
 22e:	fbe5                	bnez	a5,21e <strcmp+0xc>
 230:	0005c503          	lbu	a0,0(a1)
 234:	40a7853b          	subw	a0,a5,a0
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret

000000000000023e <strlen>:
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
 244:	00054783          	lbu	a5,0(a0)
 248:	cf91                	beqz	a5,264 <strlen+0x26>
 24a:	0505                	addi	a0,a0,1
 24c:	87aa                	mv	a5,a0
 24e:	86be                	mv	a3,a5
 250:	0785                	addi	a5,a5,1
 252:	fff7c703          	lbu	a4,-1(a5)
 256:	ff65                	bnez	a4,24e <strlen+0x10>
 258:	40a6853b          	subw	a0,a3,a0
 25c:	2505                	addiw	a0,a0,1
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
 264:	4501                	li	a0,0
 266:	bfe5                	j	25e <strlen+0x20>

0000000000000268 <memset>:
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
 26e:	ca19                	beqz	a2,284 <memset+0x1c>
 270:	87aa                	mv	a5,a0
 272:	1602                	slli	a2,a2,0x20
 274:	9201                	srli	a2,a2,0x20
 276:	00a60733          	add	a4,a2,a0
 27a:	00b78023          	sb	a1,0(a5)
 27e:	0785                	addi	a5,a5,1
 280:	fee79de3          	bne	a5,a4,27a <memset+0x12>
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <strchr>:
 28a:	1141                	addi	sp,sp,-16
 28c:	e422                	sd	s0,8(sp)
 28e:	0800                	addi	s0,sp,16
 290:	00054783          	lbu	a5,0(a0)
 294:	cb99                	beqz	a5,2aa <strchr+0x20>
 296:	00f58763          	beq	a1,a5,2a4 <strchr+0x1a>
 29a:	0505                	addi	a0,a0,1
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	fbfd                	bnez	a5,296 <strchr+0xc>
 2a2:	4501                	li	a0,0
 2a4:	6422                	ld	s0,8(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
 2aa:	4501                	li	a0,0
 2ac:	bfe5                	j	2a4 <strchr+0x1a>

00000000000002ae <gets>:
 2ae:	711d                	addi	sp,sp,-96
 2b0:	ec86                	sd	ra,88(sp)
 2b2:	e8a2                	sd	s0,80(sp)
 2b4:	e4a6                	sd	s1,72(sp)
 2b6:	e0ca                	sd	s2,64(sp)
 2b8:	fc4e                	sd	s3,56(sp)
 2ba:	f852                	sd	s4,48(sp)
 2bc:	f456                	sd	s5,40(sp)
 2be:	f05a                	sd	s6,32(sp)
 2c0:	ec5e                	sd	s7,24(sp)
 2c2:	1080                	addi	s0,sp,96
 2c4:	8baa                	mv	s7,a0
 2c6:	8a2e                	mv	s4,a1
 2c8:	892a                	mv	s2,a0
 2ca:	4481                	li	s1,0
 2cc:	4aa9                	li	s5,10
 2ce:	4b35                	li	s6,13
 2d0:	89a6                	mv	s3,s1
 2d2:	2485                	addiw	s1,s1,1
 2d4:	0344d663          	bge	s1,s4,300 <gets+0x52>
 2d8:	4605                	li	a2,1
 2da:	faf40593          	addi	a1,s0,-81
 2de:	4501                	li	a0,0
 2e0:	186000ef          	jal	466 <read>
 2e4:	00a05e63          	blez	a0,300 <gets+0x52>
 2e8:	faf44783          	lbu	a5,-81(s0)
 2ec:	00f90023          	sb	a5,0(s2)
 2f0:	01578763          	beq	a5,s5,2fe <gets+0x50>
 2f4:	0905                	addi	s2,s2,1
 2f6:	fd679de3          	bne	a5,s6,2d0 <gets+0x22>
 2fa:	89a6                	mv	s3,s1
 2fc:	a011                	j	300 <gets+0x52>
 2fe:	89a6                	mv	s3,s1
 300:	99de                	add	s3,s3,s7
 302:	00098023          	sb	zero,0(s3)
 306:	855e                	mv	a0,s7
 308:	60e6                	ld	ra,88(sp)
 30a:	6446                	ld	s0,80(sp)
 30c:	64a6                	ld	s1,72(sp)
 30e:	6906                	ld	s2,64(sp)
 310:	79e2                	ld	s3,56(sp)
 312:	7a42                	ld	s4,48(sp)
 314:	7aa2                	ld	s5,40(sp)
 316:	7b02                	ld	s6,32(sp)
 318:	6be2                	ld	s7,24(sp)
 31a:	6125                	addi	sp,sp,96
 31c:	8082                	ret

000000000000031e <stat>:
 31e:	1101                	addi	sp,sp,-32
 320:	ec06                	sd	ra,24(sp)
 322:	e822                	sd	s0,16(sp)
 324:	e04a                	sd	s2,0(sp)
 326:	1000                	addi	s0,sp,32
 328:	892e                	mv	s2,a1
 32a:	4581                	li	a1,0
 32c:	162000ef          	jal	48e <open>
 330:	02054263          	bltz	a0,354 <stat+0x36>
 334:	e426                	sd	s1,8(sp)
 336:	84aa                	mv	s1,a0
 338:	85ca                	mv	a1,s2
 33a:	16c000ef          	jal	4a6 <fstat>
 33e:	892a                	mv	s2,a0
 340:	8526                	mv	a0,s1
 342:	134000ef          	jal	476 <close>
 346:	64a2                	ld	s1,8(sp)
 348:	854a                	mv	a0,s2
 34a:	60e2                	ld	ra,24(sp)
 34c:	6442                	ld	s0,16(sp)
 34e:	6902                	ld	s2,0(sp)
 350:	6105                	addi	sp,sp,32
 352:	8082                	ret
 354:	597d                	li	s2,-1
 356:	bfcd                	j	348 <stat+0x2a>

0000000000000358 <atoi>:
 358:	1141                	addi	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	addi	s0,sp,16
 35e:	00054683          	lbu	a3,0(a0)
 362:	fd06879b          	addiw	a5,a3,-48
 366:	0ff7f793          	zext.b	a5,a5
 36a:	4625                	li	a2,9
 36c:	02f66863          	bltu	a2,a5,39c <atoi+0x44>
 370:	872a                	mv	a4,a0
 372:	4501                	li	a0,0
 374:	0705                	addi	a4,a4,1
 376:	0025179b          	slliw	a5,a0,0x2
 37a:	9fa9                	addw	a5,a5,a0
 37c:	0017979b          	slliw	a5,a5,0x1
 380:	9fb5                	addw	a5,a5,a3
 382:	fd07851b          	addiw	a0,a5,-48
 386:	00074683          	lbu	a3,0(a4)
 38a:	fd06879b          	addiw	a5,a3,-48
 38e:	0ff7f793          	zext.b	a5,a5
 392:	fef671e3          	bgeu	a2,a5,374 <atoi+0x1c>
 396:	6422                	ld	s0,8(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret
 39c:	4501                	li	a0,0
 39e:	bfe5                	j	396 <atoi+0x3e>

00000000000003a0 <memmove>:
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e422                	sd	s0,8(sp)
 3a4:	0800                	addi	s0,sp,16
 3a6:	02b57463          	bgeu	a0,a1,3ce <memmove+0x2e>
 3aa:	00c05f63          	blez	a2,3c8 <memmove+0x28>
 3ae:	1602                	slli	a2,a2,0x20
 3b0:	9201                	srli	a2,a2,0x20
 3b2:	00c507b3          	add	a5,a0,a2
 3b6:	872a                	mv	a4,a0
 3b8:	0585                	addi	a1,a1,1
 3ba:	0705                	addi	a4,a4,1
 3bc:	fff5c683          	lbu	a3,-1(a1)
 3c0:	fed70fa3          	sb	a3,-1(a4)
 3c4:	fef71ae3          	bne	a4,a5,3b8 <memmove+0x18>
 3c8:	6422                	ld	s0,8(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret
 3ce:	00c50733          	add	a4,a0,a2
 3d2:	95b2                	add	a1,a1,a2
 3d4:	fec05ae3          	blez	a2,3c8 <memmove+0x28>
 3d8:	fff6079b          	addiw	a5,a2,-1
 3dc:	1782                	slli	a5,a5,0x20
 3de:	9381                	srli	a5,a5,0x20
 3e0:	fff7c793          	not	a5,a5
 3e4:	97ba                	add	a5,a5,a4
 3e6:	15fd                	addi	a1,a1,-1
 3e8:	177d                	addi	a4,a4,-1
 3ea:	0005c683          	lbu	a3,0(a1)
 3ee:	00d70023          	sb	a3,0(a4)
 3f2:	fee79ae3          	bne	a5,a4,3e6 <memmove+0x46>
 3f6:	bfc9                	j	3c8 <memmove+0x28>

00000000000003f8 <memcmp>:
 3f8:	1141                	addi	sp,sp,-16
 3fa:	e422                	sd	s0,8(sp)
 3fc:	0800                	addi	s0,sp,16
 3fe:	ca05                	beqz	a2,42e <memcmp+0x36>
 400:	fff6069b          	addiw	a3,a2,-1
 404:	1682                	slli	a3,a3,0x20
 406:	9281                	srli	a3,a3,0x20
 408:	0685                	addi	a3,a3,1
 40a:	96aa                	add	a3,a3,a0
 40c:	00054783          	lbu	a5,0(a0)
 410:	0005c703          	lbu	a4,0(a1)
 414:	00e79863          	bne	a5,a4,424 <memcmp+0x2c>
 418:	0505                	addi	a0,a0,1
 41a:	0585                	addi	a1,a1,1
 41c:	fed518e3          	bne	a0,a3,40c <memcmp+0x14>
 420:	4501                	li	a0,0
 422:	a019                	j	428 <memcmp+0x30>
 424:	40e7853b          	subw	a0,a5,a4
 428:	6422                	ld	s0,8(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret
 42e:	4501                	li	a0,0
 430:	bfe5                	j	428 <memcmp+0x30>

0000000000000432 <memcpy>:
 432:	1141                	addi	sp,sp,-16
 434:	e406                	sd	ra,8(sp)
 436:	e022                	sd	s0,0(sp)
 438:	0800                	addi	s0,sp,16
 43a:	f67ff0ef          	jal	3a0 <memmove>
 43e:	60a2                	ld	ra,8(sp)
 440:	6402                	ld	s0,0(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret

0000000000000446 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 446:	4885                	li	a7,1
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <exit>:
.global exit
exit:
 li a7, SYS_exit
 44e:	4889                	li	a7,2
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <wait>:
.global wait
wait:
 li a7, SYS_wait
 456:	488d                	li	a7,3
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 45e:	4891                	li	a7,4
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <read>:
.global read
read:
 li a7, SYS_read
 466:	4895                	li	a7,5
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <write>:
.global write
write:
 li a7, SYS_write
 46e:	48c1                	li	a7,16
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <close>:
.global close
close:
 li a7, SYS_close
 476:	48d5                	li	a7,21
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <kill>:
.global kill
kill:
 li a7, SYS_kill
 47e:	4899                	li	a7,6
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <exec>:
.global exec
exec:
 li a7, SYS_exec
 486:	489d                	li	a7,7
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <open>:
.global open
open:
 li a7, SYS_open
 48e:	48bd                	li	a7,15
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 496:	48c5                	li	a7,17
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 49e:	48c9                	li	a7,18
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a6:	48a1                	li	a7,8
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <link>:
.global link
link:
 li a7, SYS_link
 4ae:	48cd                	li	a7,19
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b6:	48d1                	li	a7,20
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4be:	48a5                	li	a7,9
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c6:	48a9                	li	a7,10
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ce:	48ad                	li	a7,11
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4d6:	48b1                	li	a7,12
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4de:	48b5                	li	a7,13
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e6:	48b9                	li	a7,14
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ee:	1101                	addi	sp,sp,-32
 4f0:	ec06                	sd	ra,24(sp)
 4f2:	e822                	sd	s0,16(sp)
 4f4:	1000                	addi	s0,sp,32
 4f6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4fa:	4605                	li	a2,1
 4fc:	fef40593          	addi	a1,s0,-17
 500:	f6fff0ef          	jal	46e <write>
}
 504:	60e2                	ld	ra,24(sp)
 506:	6442                	ld	s0,16(sp)
 508:	6105                	addi	sp,sp,32
 50a:	8082                	ret

000000000000050c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 50c:	7139                	addi	sp,sp,-64
 50e:	fc06                	sd	ra,56(sp)
 510:	f822                	sd	s0,48(sp)
 512:	f426                	sd	s1,40(sp)
 514:	0080                	addi	s0,sp,64
 516:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 518:	c299                	beqz	a3,51e <printint+0x12>
 51a:	0805c963          	bltz	a1,5ac <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 51e:	2581                	sext.w	a1,a1
  neg = 0;
 520:	4881                	li	a7,0
 522:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 526:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 528:	2601                	sext.w	a2,a2
 52a:	00000517          	auipc	a0,0x0
 52e:	4fe50513          	addi	a0,a0,1278 # a28 <digits>
 532:	883a                	mv	a6,a4
 534:	2705                	addiw	a4,a4,1
 536:	02c5f7bb          	remuw	a5,a1,a2
 53a:	1782                	slli	a5,a5,0x20
 53c:	9381                	srli	a5,a5,0x20
 53e:	97aa                	add	a5,a5,a0
 540:	0007c783          	lbu	a5,0(a5)
 544:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 548:	0005879b          	sext.w	a5,a1
 54c:	02c5d5bb          	divuw	a1,a1,a2
 550:	0685                	addi	a3,a3,1
 552:	fec7f0e3          	bgeu	a5,a2,532 <printint+0x26>
  if(neg)
 556:	00088c63          	beqz	a7,56e <printint+0x62>
    buf[i++] = '-';
 55a:	fd070793          	addi	a5,a4,-48
 55e:	00878733          	add	a4,a5,s0
 562:	02d00793          	li	a5,45
 566:	fef70823          	sb	a5,-16(a4)
 56a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 56e:	02e05a63          	blez	a4,5a2 <printint+0x96>
 572:	f04a                	sd	s2,32(sp)
 574:	ec4e                	sd	s3,24(sp)
 576:	fc040793          	addi	a5,s0,-64
 57a:	00e78933          	add	s2,a5,a4
 57e:	fff78993          	addi	s3,a5,-1
 582:	99ba                	add	s3,s3,a4
 584:	377d                	addiw	a4,a4,-1
 586:	1702                	slli	a4,a4,0x20
 588:	9301                	srli	a4,a4,0x20
 58a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 58e:	fff94583          	lbu	a1,-1(s2)
 592:	8526                	mv	a0,s1
 594:	f5bff0ef          	jal	4ee <putc>
  while(--i >= 0)
 598:	197d                	addi	s2,s2,-1
 59a:	ff391ae3          	bne	s2,s3,58e <printint+0x82>
 59e:	7902                	ld	s2,32(sp)
 5a0:	69e2                	ld	s3,24(sp)
}
 5a2:	70e2                	ld	ra,56(sp)
 5a4:	7442                	ld	s0,48(sp)
 5a6:	74a2                	ld	s1,40(sp)
 5a8:	6121                	addi	sp,sp,64
 5aa:	8082                	ret
    x = -xx;
 5ac:	40b005bb          	negw	a1,a1
    neg = 1;
 5b0:	4885                	li	a7,1
    x = -xx;
 5b2:	bf85                	j	522 <printint+0x16>

00000000000005b4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b4:	711d                	addi	sp,sp,-96
 5b6:	ec86                	sd	ra,88(sp)
 5b8:	e8a2                	sd	s0,80(sp)
 5ba:	e0ca                	sd	s2,64(sp)
 5bc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5be:	0005c903          	lbu	s2,0(a1)
 5c2:	26090863          	beqz	s2,832 <vprintf+0x27e>
 5c6:	e4a6                	sd	s1,72(sp)
 5c8:	fc4e                	sd	s3,56(sp)
 5ca:	f852                	sd	s4,48(sp)
 5cc:	f456                	sd	s5,40(sp)
 5ce:	f05a                	sd	s6,32(sp)
 5d0:	ec5e                	sd	s7,24(sp)
 5d2:	e862                	sd	s8,16(sp)
 5d4:	e466                	sd	s9,8(sp)
 5d6:	8b2a                	mv	s6,a0
 5d8:	8a2e                	mv	s4,a1
 5da:	8bb2                	mv	s7,a2
  state = 0;
 5dc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5de:	4481                	li	s1,0
 5e0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5e2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5e6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ea:	06c00c93          	li	s9,108
 5ee:	a005                	j	60e <vprintf+0x5a>
        putc(fd, c0);
 5f0:	85ca                	mv	a1,s2
 5f2:	855a                	mv	a0,s6
 5f4:	efbff0ef          	jal	4ee <putc>
 5f8:	a019                	j	5fe <vprintf+0x4a>
    } else if(state == '%'){
 5fa:	03598263          	beq	s3,s5,61e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5fe:	2485                	addiw	s1,s1,1
 600:	8726                	mv	a4,s1
 602:	009a07b3          	add	a5,s4,s1
 606:	0007c903          	lbu	s2,0(a5)
 60a:	20090c63          	beqz	s2,822 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 60e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 612:	fe0994e3          	bnez	s3,5fa <vprintf+0x46>
      if(c0 == '%'){
 616:	fd579de3          	bne	a5,s5,5f0 <vprintf+0x3c>
        state = '%';
 61a:	89be                	mv	s3,a5
 61c:	b7cd                	j	5fe <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 61e:	00ea06b3          	add	a3,s4,a4
 622:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 626:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 628:	c681                	beqz	a3,630 <vprintf+0x7c>
 62a:	9752                	add	a4,a4,s4
 62c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 630:	03878f63          	beq	a5,s8,66e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 634:	05978963          	beq	a5,s9,686 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 638:	07500713          	li	a4,117
 63c:	0ee78363          	beq	a5,a4,722 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 640:	07800713          	li	a4,120
 644:	12e78563          	beq	a5,a4,76e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 648:	07000713          	li	a4,112
 64c:	14e78a63          	beq	a5,a4,7a0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 650:	07300713          	li	a4,115
 654:	18e78a63          	beq	a5,a4,7e8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 658:	02500713          	li	a4,37
 65c:	04e79563          	bne	a5,a4,6a6 <vprintf+0xf2>
        putc(fd, '%');
 660:	02500593          	li	a1,37
 664:	855a                	mv	a0,s6
 666:	e89ff0ef          	jal	4ee <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bf49                	j	5fe <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 66e:	008b8913          	addi	s2,s7,8
 672:	4685                	li	a3,1
 674:	4629                	li	a2,10
 676:	000ba583          	lw	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	e91ff0ef          	jal	50c <printint>
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
 684:	bfad                	j	5fe <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 686:	06400793          	li	a5,100
 68a:	02f68963          	beq	a3,a5,6bc <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 68e:	06c00793          	li	a5,108
 692:	04f68263          	beq	a3,a5,6d6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 696:	07500793          	li	a5,117
 69a:	0af68063          	beq	a3,a5,73a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 69e:	07800793          	li	a5,120
 6a2:	0ef68263          	beq	a3,a5,786 <vprintf+0x1d2>
        putc(fd, '%');
 6a6:	02500593          	li	a1,37
 6aa:	855a                	mv	a0,s6
 6ac:	e43ff0ef          	jal	4ee <putc>
        putc(fd, c0);
 6b0:	85ca                	mv	a1,s2
 6b2:	855a                	mv	a0,s6
 6b4:	e3bff0ef          	jal	4ee <putc>
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b791                	j	5fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6bc:	008b8913          	addi	s2,s7,8
 6c0:	4685                	li	a3,1
 6c2:	4629                	li	a2,10
 6c4:	000ba583          	lw	a1,0(s7)
 6c8:	855a                	mv	a0,s6
 6ca:	e43ff0ef          	jal	50c <printint>
        i += 1;
 6ce:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
        i += 1;
 6d4:	b72d                	j	5fe <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d6:	06400793          	li	a5,100
 6da:	02f60763          	beq	a2,a5,708 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6de:	07500793          	li	a5,117
 6e2:	06f60963          	beq	a2,a5,754 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6e6:	07800793          	li	a5,120
 6ea:	faf61ee3          	bne	a2,a5,6a6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ee:	008b8913          	addi	s2,s7,8
 6f2:	4681                	li	a3,0
 6f4:	4641                	li	a2,16
 6f6:	000ba583          	lw	a1,0(s7)
 6fa:	855a                	mv	a0,s6
 6fc:	e11ff0ef          	jal	50c <printint>
        i += 2;
 700:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 702:	8bca                	mv	s7,s2
      state = 0;
 704:	4981                	li	s3,0
        i += 2;
 706:	bde5                	j	5fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 708:	008b8913          	addi	s2,s7,8
 70c:	4685                	li	a3,1
 70e:	4629                	li	a2,10
 710:	000ba583          	lw	a1,0(s7)
 714:	855a                	mv	a0,s6
 716:	df7ff0ef          	jal	50c <printint>
        i += 2;
 71a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 71c:	8bca                	mv	s7,s2
      state = 0;
 71e:	4981                	li	s3,0
        i += 2;
 720:	bdf9                	j	5fe <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 722:	008b8913          	addi	s2,s7,8
 726:	4681                	li	a3,0
 728:	4629                	li	a2,10
 72a:	000ba583          	lw	a1,0(s7)
 72e:	855a                	mv	a0,s6
 730:	dddff0ef          	jal	50c <printint>
 734:	8bca                	mv	s7,s2
      state = 0;
 736:	4981                	li	s3,0
 738:	b5d9                	j	5fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73a:	008b8913          	addi	s2,s7,8
 73e:	4681                	li	a3,0
 740:	4629                	li	a2,10
 742:	000ba583          	lw	a1,0(s7)
 746:	855a                	mv	a0,s6
 748:	dc5ff0ef          	jal	50c <printint>
        i += 1;
 74c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 74e:	8bca                	mv	s7,s2
      state = 0;
 750:	4981                	li	s3,0
        i += 1;
 752:	b575                	j	5fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 754:	008b8913          	addi	s2,s7,8
 758:	4681                	li	a3,0
 75a:	4629                	li	a2,10
 75c:	000ba583          	lw	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	dabff0ef          	jal	50c <printint>
        i += 2;
 766:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 768:	8bca                	mv	s7,s2
      state = 0;
 76a:	4981                	li	s3,0
        i += 2;
 76c:	bd49                	j	5fe <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 76e:	008b8913          	addi	s2,s7,8
 772:	4681                	li	a3,0
 774:	4641                	li	a2,16
 776:	000ba583          	lw	a1,0(s7)
 77a:	855a                	mv	a0,s6
 77c:	d91ff0ef          	jal	50c <printint>
 780:	8bca                	mv	s7,s2
      state = 0;
 782:	4981                	li	s3,0
 784:	bdad                	j	5fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 786:	008b8913          	addi	s2,s7,8
 78a:	4681                	li	a3,0
 78c:	4641                	li	a2,16
 78e:	000ba583          	lw	a1,0(s7)
 792:	855a                	mv	a0,s6
 794:	d79ff0ef          	jal	50c <printint>
        i += 1;
 798:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 79a:	8bca                	mv	s7,s2
      state = 0;
 79c:	4981                	li	s3,0
        i += 1;
 79e:	b585                	j	5fe <vprintf+0x4a>
 7a0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7a2:	008b8d13          	addi	s10,s7,8
 7a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7aa:	03000593          	li	a1,48
 7ae:	855a                	mv	a0,s6
 7b0:	d3fff0ef          	jal	4ee <putc>
  putc(fd, 'x');
 7b4:	07800593          	li	a1,120
 7b8:	855a                	mv	a0,s6
 7ba:	d35ff0ef          	jal	4ee <putc>
 7be:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c0:	00000b97          	auipc	s7,0x0
 7c4:	268b8b93          	addi	s7,s7,616 # a28 <digits>
 7c8:	03c9d793          	srli	a5,s3,0x3c
 7cc:	97de                	add	a5,a5,s7
 7ce:	0007c583          	lbu	a1,0(a5)
 7d2:	855a                	mv	a0,s6
 7d4:	d1bff0ef          	jal	4ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d8:	0992                	slli	s3,s3,0x4
 7da:	397d                	addiw	s2,s2,-1
 7dc:	fe0916e3          	bnez	s2,7c8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7e0:	8bea                	mv	s7,s10
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	6d02                	ld	s10,0(sp)
 7e6:	bd21                	j	5fe <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7e8:	008b8993          	addi	s3,s7,8
 7ec:	000bb903          	ld	s2,0(s7)
 7f0:	00090f63          	beqz	s2,80e <vprintf+0x25a>
        for(; *s; s++)
 7f4:	00094583          	lbu	a1,0(s2)
 7f8:	c195                	beqz	a1,81c <vprintf+0x268>
          putc(fd, *s);
 7fa:	855a                	mv	a0,s6
 7fc:	cf3ff0ef          	jal	4ee <putc>
        for(; *s; s++)
 800:	0905                	addi	s2,s2,1
 802:	00094583          	lbu	a1,0(s2)
 806:	f9f5                	bnez	a1,7fa <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 808:	8bce                	mv	s7,s3
      state = 0;
 80a:	4981                	li	s3,0
 80c:	bbcd                	j	5fe <vprintf+0x4a>
          s = "(null)";
 80e:	00000917          	auipc	s2,0x0
 812:	21290913          	addi	s2,s2,530 # a20 <malloc+0x106>
        for(; *s; s++)
 816:	02800593          	li	a1,40
 81a:	b7c5                	j	7fa <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 81c:	8bce                	mv	s7,s3
      state = 0;
 81e:	4981                	li	s3,0
 820:	bbf9                	j	5fe <vprintf+0x4a>
 822:	64a6                	ld	s1,72(sp)
 824:	79e2                	ld	s3,56(sp)
 826:	7a42                	ld	s4,48(sp)
 828:	7aa2                	ld	s5,40(sp)
 82a:	7b02                	ld	s6,32(sp)
 82c:	6be2                	ld	s7,24(sp)
 82e:	6c42                	ld	s8,16(sp)
 830:	6ca2                	ld	s9,8(sp)
    }
  }
}
 832:	60e6                	ld	ra,88(sp)
 834:	6446                	ld	s0,80(sp)
 836:	6906                	ld	s2,64(sp)
 838:	6125                	addi	sp,sp,96
 83a:	8082                	ret

000000000000083c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 83c:	715d                	addi	sp,sp,-80
 83e:	ec06                	sd	ra,24(sp)
 840:	e822                	sd	s0,16(sp)
 842:	1000                	addi	s0,sp,32
 844:	e010                	sd	a2,0(s0)
 846:	e414                	sd	a3,8(s0)
 848:	e818                	sd	a4,16(s0)
 84a:	ec1c                	sd	a5,24(s0)
 84c:	03043023          	sd	a6,32(s0)
 850:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 854:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 858:	8622                	mv	a2,s0
 85a:	d5bff0ef          	jal	5b4 <vprintf>
}
 85e:	60e2                	ld	ra,24(sp)
 860:	6442                	ld	s0,16(sp)
 862:	6161                	addi	sp,sp,80
 864:	8082                	ret

0000000000000866 <printf>:

void
printf(const char *fmt, ...)
{
 866:	711d                	addi	sp,sp,-96
 868:	ec06                	sd	ra,24(sp)
 86a:	e822                	sd	s0,16(sp)
 86c:	1000                	addi	s0,sp,32
 86e:	e40c                	sd	a1,8(s0)
 870:	e810                	sd	a2,16(s0)
 872:	ec14                	sd	a3,24(s0)
 874:	f018                	sd	a4,32(s0)
 876:	f41c                	sd	a5,40(s0)
 878:	03043823          	sd	a6,48(s0)
 87c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 880:	00840613          	addi	a2,s0,8
 884:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 888:	85aa                	mv	a1,a0
 88a:	4505                	li	a0,1
 88c:	d29ff0ef          	jal	5b4 <vprintf>
}
 890:	60e2                	ld	ra,24(sp)
 892:	6442                	ld	s0,16(sp)
 894:	6125                	addi	sp,sp,96
 896:	8082                	ret

0000000000000898 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 898:	1141                	addi	sp,sp,-16
 89a:	e422                	sd	s0,8(sp)
 89c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 89e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a2:	00000797          	auipc	a5,0x0
 8a6:	76e7b783          	ld	a5,1902(a5) # 1010 <freep>
 8aa:	a02d                	j	8d4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8ac:	4618                	lw	a4,8(a2)
 8ae:	9f2d                	addw	a4,a4,a1
 8b0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b4:	6398                	ld	a4,0(a5)
 8b6:	6310                	ld	a2,0(a4)
 8b8:	a83d                	j	8f6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ba:	ff852703          	lw	a4,-8(a0)
 8be:	9f31                	addw	a4,a4,a2
 8c0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8c2:	ff053683          	ld	a3,-16(a0)
 8c6:	a091                	j	90a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c8:	6398                	ld	a4,0(a5)
 8ca:	00e7e463          	bltu	a5,a4,8d2 <free+0x3a>
 8ce:	00e6ea63          	bltu	a3,a4,8e2 <free+0x4a>
{
 8d2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d4:	fed7fae3          	bgeu	a5,a3,8c8 <free+0x30>
 8d8:	6398                	ld	a4,0(a5)
 8da:	00e6e463          	bltu	a3,a4,8e2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8de:	fee7eae3          	bltu	a5,a4,8d2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8e2:	ff852583          	lw	a1,-8(a0)
 8e6:	6390                	ld	a2,0(a5)
 8e8:	02059813          	slli	a6,a1,0x20
 8ec:	01c85713          	srli	a4,a6,0x1c
 8f0:	9736                	add	a4,a4,a3
 8f2:	fae60de3          	beq	a2,a4,8ac <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8f6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8fa:	4790                	lw	a2,8(a5)
 8fc:	02061593          	slli	a1,a2,0x20
 900:	01c5d713          	srli	a4,a1,0x1c
 904:	973e                	add	a4,a4,a5
 906:	fae68ae3          	beq	a3,a4,8ba <free+0x22>
    p->s.ptr = bp->s.ptr;
 90a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 90c:	00000717          	auipc	a4,0x0
 910:	70f73223          	sd	a5,1796(a4) # 1010 <freep>
}
 914:	6422                	ld	s0,8(sp)
 916:	0141                	addi	sp,sp,16
 918:	8082                	ret

000000000000091a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 91a:	7139                	addi	sp,sp,-64
 91c:	fc06                	sd	ra,56(sp)
 91e:	f822                	sd	s0,48(sp)
 920:	f426                	sd	s1,40(sp)
 922:	ec4e                	sd	s3,24(sp)
 924:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 926:	02051493          	slli	s1,a0,0x20
 92a:	9081                	srli	s1,s1,0x20
 92c:	04bd                	addi	s1,s1,15
 92e:	8091                	srli	s1,s1,0x4
 930:	0014899b          	addiw	s3,s1,1
 934:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 936:	00000517          	auipc	a0,0x0
 93a:	6da53503          	ld	a0,1754(a0) # 1010 <freep>
 93e:	c915                	beqz	a0,972 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 940:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 942:	4798                	lw	a4,8(a5)
 944:	08977a63          	bgeu	a4,s1,9d8 <malloc+0xbe>
 948:	f04a                	sd	s2,32(sp)
 94a:	e852                	sd	s4,16(sp)
 94c:	e456                	sd	s5,8(sp)
 94e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 950:	8a4e                	mv	s4,s3
 952:	0009871b          	sext.w	a4,s3
 956:	6685                	lui	a3,0x1
 958:	00d77363          	bgeu	a4,a3,95e <malloc+0x44>
 95c:	6a05                	lui	s4,0x1
 95e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 962:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 966:	00000917          	auipc	s2,0x0
 96a:	6aa90913          	addi	s2,s2,1706 # 1010 <freep>
  if(p == (char*)-1)
 96e:	5afd                	li	s5,-1
 970:	a081                	j	9b0 <malloc+0x96>
 972:	f04a                	sd	s2,32(sp)
 974:	e852                	sd	s4,16(sp)
 976:	e456                	sd	s5,8(sp)
 978:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 97a:	00001797          	auipc	a5,0x1
 97e:	32678793          	addi	a5,a5,806 # 1ca0 <base>
 982:	00000717          	auipc	a4,0x0
 986:	68f73723          	sd	a5,1678(a4) # 1010 <freep>
 98a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 990:	b7c1                	j	950 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 992:	6398                	ld	a4,0(a5)
 994:	e118                	sd	a4,0(a0)
 996:	a8a9                	j	9f0 <malloc+0xd6>
  hp->s.size = nu;
 998:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 99c:	0541                	addi	a0,a0,16
 99e:	efbff0ef          	jal	898 <free>
  return freep;
 9a2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9a6:	c12d                	beqz	a0,a08 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9aa:	4798                	lw	a4,8(a5)
 9ac:	02977263          	bgeu	a4,s1,9d0 <malloc+0xb6>
    if(p == freep)
 9b0:	00093703          	ld	a4,0(s2)
 9b4:	853e                	mv	a0,a5
 9b6:	fef719e3          	bne	a4,a5,9a8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9ba:	8552                	mv	a0,s4
 9bc:	b1bff0ef          	jal	4d6 <sbrk>
  if(p == (char*)-1)
 9c0:	fd551ce3          	bne	a0,s5,998 <malloc+0x7e>
        return 0;
 9c4:	4501                	li	a0,0
 9c6:	7902                	ld	s2,32(sp)
 9c8:	6a42                	ld	s4,16(sp)
 9ca:	6aa2                	ld	s5,8(sp)
 9cc:	6b02                	ld	s6,0(sp)
 9ce:	a03d                	j	9fc <malloc+0xe2>
 9d0:	7902                	ld	s2,32(sp)
 9d2:	6a42                	ld	s4,16(sp)
 9d4:	6aa2                	ld	s5,8(sp)
 9d6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9d8:	fae48de3          	beq	s1,a4,992 <malloc+0x78>
        p->s.size -= nunits;
 9dc:	4137073b          	subw	a4,a4,s3
 9e0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e2:	02071693          	slli	a3,a4,0x20
 9e6:	01c6d713          	srli	a4,a3,0x1c
 9ea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9f0:	00000717          	auipc	a4,0x0
 9f4:	62a73023          	sd	a0,1568(a4) # 1010 <freep>
      return (void*)(p + 1);
 9f8:	01078513          	addi	a0,a5,16
  }
}
 9fc:	70e2                	ld	ra,56(sp)
 9fe:	7442                	ld	s0,48(sp)
 a00:	74a2                	ld	s1,40(sp)
 a02:	69e2                	ld	s3,24(sp)
 a04:	6121                	addi	sp,sp,64
 a06:	8082                	ret
 a08:	7902                	ld	s2,32(sp)
 a0a:	6a42                	ld	s4,16(sp)
 a0c:	6aa2                	ld	s5,8(sp)
 a0e:	6b02                	ld	s6,0(sp)
 a10:	b7f5                	j	9fc <malloc+0xe2>
