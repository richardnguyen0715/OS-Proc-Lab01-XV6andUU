
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
  14:	270000ef          	jal	284 <memset>
  gets(buf, nbuf);
  18:	85ca                	mv	a1,s2
  1a:	8526                	mv	a0,s1
  1c:	2ae000ef          	jal	2ca <gets>
  //printf("buf: %s\n", buf);
  if (buf[0] == 0) // EOF*
  20:	0004c503          	lbu	a0,0(s1)
  24:	00153513          	seqz	a0,a0
  {
    //printf("WOW!\n");
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
  //printf("s: %s\n", s);
  while (s < es && strchr(whitespace, *s))
  56:	00001997          	auipc	s3,0x1
  5a:	faa98993          	addi	s3,s3,-86 # 1000 <whitespace>
  5e:	00b4fc63          	bgeu	s1,a1,76 <gettoken+0x3e>
  62:	0004c583          	lbu	a1,0(s1)
  66:	854e                	mv	a0,s3
  68:	23e000ef          	jal	2a6 <strchr>
  6c:	c509                	beqz	a0,76 <gettoken+0x3e>
    s++;
  6e:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
  70:	fe9919e3          	bne	s2,s1,62 <gettoken+0x2a>
  74:	84ca                	mv	s1,s2
  //printf("s: %s\n", s);
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
  96:	210000ef          	jal	2a6 <strchr>
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
  d0:	1d6000ef          	jal	2a6 <strchr>
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
 10a:	7109                	addi	sp,sp,-384
 10c:	fe86                	sd	ra,376(sp)
 10e:	faa2                	sd	s0,368(sp)
 110:	f6a6                	sd	s1,360(sp)
 112:	f2ca                	sd	s2,352(sp)
 114:	eece                	sd	s3,344(sp)
 116:	ead2                	sd	s4,336(sp)
 118:	e6d6                	sd	s5,328(sp)
 11a:	e2da                	sd	s6,320(sp)
 11c:	fe5e                	sd	s7,312(sp)
 11e:	fa62                	sd	s8,304(sp)
 120:	f666                	sd	s9,296(sp)
 122:	0300                	addi	s0,sp,384
  char* xargs[MAXARG];
  int argstart = 0;
  for (int i = 1; i < argc;i++) {
 124:	4785                	li	a5,1
 126:	04a7d763          	bge	a5,a0,174 <main+0x6a>
 12a:	00858713          	addi	a4,a1,8
 12e:	ea040793          	addi	a5,s0,-352
 132:	00050b1b          	sext.w	s6,a0
 136:	ffe5069b          	addiw	a3,a0,-2
 13a:	02069613          	slli	a2,a3,0x20
 13e:	01d65693          	srli	a3,a2,0x1d
 142:	ea840613          	addi	a2,s0,-344
 146:	96b2                	add	a3,a3,a2
    // Skip xargs cmd name.*
    xargs[argstart++] = argv[i];
 148:	6310                	ld	a2,0(a4)
 14a:	e390                	sd	a2,0(a5)
  for (int i = 1; i < argc;i++) {
 14c:	0721                	addi	a4,a4,8
 14e:	07a1                	addi	a5,a5,8
 150:	fed79ce3          	bne	a5,a3,148 <main+0x3e>
 154:	3b7d                	addiw	s6,s6,-1
 156:	003b1793          	slli	a5,s6,0x3
 15a:	ea040713          	addi	a4,s0,-352
 15e:	00f70bb3          	add	s7,a4,a5
  }

  static char buf[MAXARG][100];
  char* q, * eq;
  int j=argstart;
  int i=0;
 162:	4a01                	li	s4,0
  // Split each line into array of args.*
  while (getcmd(buf[i], sizeof(buf[i])) >= 0) {
 164:	06400a93          	li	s5,100
 168:	00001c17          	auipc	s8,0x1
 16c:	eb8c0c13          	addi	s8,s8,-328 # 1020 <buf.0>
    char* s = buf[i];
    char* es = s + strlen(s);
    while (gettoken(&s, es, &q, &eq) != 0) {
 170:	8cda                	mv	s9,s6
 172:	a0b9                	j	1c0 <main+0xb6>
  int argstart = 0;
 174:	4b01                	li	s6,0
 176:	b7c5                	j	156 <main+0x4c>
      xargs[j] = q;
 178:	e9843783          	ld	a5,-360(s0)
 17c:	e09c                	sd	a5,0(s1)
      *eq = 0;
 17e:	e9043783          	ld	a5,-368(s0)
 182:	00078023          	sb	zero,0(a5)
      j++;
 186:	2905                	addiw	s2,s2,1
      i++;
 188:	04a1                	addi	s1,s1,8
    while (gettoken(&s, es, &q, &eq) != 0) {
 18a:	e9040693          	addi	a3,s0,-368
 18e:	e9840613          	addi	a2,s0,-360
 192:	85ce                	mv	a1,s3
 194:	e8840513          	addi	a0,s0,-376
 198:	ea1ff0ef          	jal	38 <gettoken>
 19c:	fd71                	bnez	a0,178 <main+0x6e>
    }
  xargs[j] = 0;
 19e:	00391793          	slli	a5,s2,0x3
 1a2:	fa078793          	addi	a5,a5,-96
 1a6:	97a2                	add	a5,a5,s0
 1a8:	f007b023          	sd	zero,-256(a5)
  int pid = fork();
 1ac:	2b6000ef          	jal	462 <fork>
  if (pid == 0) {
 1b0:	cd05                	beqz	a0,1e8 <main+0xde>
 1b2:	416a0a3b          	subw	s4,s4,s6
 1b6:	012a0a3b          	addw	s4,s4,s2
    exec(xargs[0], xargs);
    exit(0);
  }
  wait(0);
 1ba:	4501                	li	a0,0
 1bc:	2b6000ef          	jal	472 <wait>
  while (getcmd(buf[i], sizeof(buf[i])) >= 0) {
 1c0:	035a09b3          	mul	s3,s4,s5
 1c4:	99e2                	add	s3,s3,s8
 1c6:	85d6                	mv	a1,s5
 1c8:	854e                	mv	a0,s3
 1ca:	e37ff0ef          	jal	0 <getcmd>
 1ce:	02054663          	bltz	a0,1fa <main+0xf0>
    char* s = buf[i];
 1d2:	e9343423          	sd	s3,-376(s0)
    char* es = s + strlen(s);
 1d6:	854e                	mv	a0,s3
 1d8:	082000ef          	jal	25a <strlen>
 1dc:	1502                	slli	a0,a0,0x20
 1de:	9101                	srli	a0,a0,0x20
 1e0:	99aa                	add	s3,s3,a0
    while (gettoken(&s, es, &q, &eq) != 0) {
 1e2:	84de                	mv	s1,s7
 1e4:	8966                	mv	s2,s9
 1e6:	b755                	j	18a <main+0x80>
    exec(xargs[0], xargs);
 1e8:	ea040593          	addi	a1,s0,-352
 1ec:	ea043503          	ld	a0,-352(s0)
 1f0:	2b2000ef          	jal	4a2 <exec>
    exit(0);
 1f4:	4501                	li	a0,0
 1f6:	274000ef          	jal	46a <exit>
  j=argstart;
  }
  exit(0);
 1fa:	4501                	li	a0,0
 1fc:	26e000ef          	jal	46a <exit>

0000000000000200 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 200:	1141                	addi	sp,sp,-16
 202:	e406                	sd	ra,8(sp)
 204:	e022                	sd	s0,0(sp)
 206:	0800                	addi	s0,sp,16
  extern int main();
  main();
 208:	f03ff0ef          	jal	10a <main>
  exit(0);
 20c:	4501                	li	a0,0
 20e:	25c000ef          	jal	46a <exit>

0000000000000212 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 218:	87aa                	mv	a5,a0
 21a:	0585                	addi	a1,a1,1
 21c:	0785                	addi	a5,a5,1
 21e:	fff5c703          	lbu	a4,-1(a1)
 222:	fee78fa3          	sb	a4,-1(a5)
 226:	fb75                	bnez	a4,21a <strcpy+0x8>
    ;
  return os;
}
 228:	6422                	ld	s0,8(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret

000000000000022e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 234:	00054783          	lbu	a5,0(a0)
 238:	cb91                	beqz	a5,24c <strcmp+0x1e>
 23a:	0005c703          	lbu	a4,0(a1)
 23e:	00f71763          	bne	a4,a5,24c <strcmp+0x1e>
    p++, q++;
 242:	0505                	addi	a0,a0,1
 244:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 246:	00054783          	lbu	a5,0(a0)
 24a:	fbe5                	bnez	a5,23a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 24c:	0005c503          	lbu	a0,0(a1)
}
 250:	40a7853b          	subw	a0,a5,a0
 254:	6422                	ld	s0,8(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret

000000000000025a <strlen>:

uint
strlen(const char *s)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e422                	sd	s0,8(sp)
 25e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 260:	00054783          	lbu	a5,0(a0)
 264:	cf91                	beqz	a5,280 <strlen+0x26>
 266:	0505                	addi	a0,a0,1
 268:	87aa                	mv	a5,a0
 26a:	86be                	mv	a3,a5
 26c:	0785                	addi	a5,a5,1
 26e:	fff7c703          	lbu	a4,-1(a5)
 272:	ff65                	bnez	a4,26a <strlen+0x10>
 274:	40a6853b          	subw	a0,a3,a0
 278:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 27a:	6422                	ld	s0,8(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
  for(n = 0; s[n]; n++)
 280:	4501                	li	a0,0
 282:	bfe5                	j	27a <strlen+0x20>

0000000000000284 <memset>:

void*
memset(void *dst, int c, uint n)
{
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 28a:	ca19                	beqz	a2,2a0 <memset+0x1c>
 28c:	87aa                	mv	a5,a0
 28e:	1602                	slli	a2,a2,0x20
 290:	9201                	srli	a2,a2,0x20
 292:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 296:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 29a:	0785                	addi	a5,a5,1
 29c:	fee79de3          	bne	a5,a4,296 <memset+0x12>
  }
  return dst;
}
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret

00000000000002a6 <strchr>:

char*
strchr(const char *s, char c)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	cb99                	beqz	a5,2c6 <strchr+0x20>
    if(*s == c)
 2b2:	00f58763          	beq	a1,a5,2c0 <strchr+0x1a>
  for(; *s; s++)
 2b6:	0505                	addi	a0,a0,1
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	fbfd                	bnez	a5,2b2 <strchr+0xc>
      return (char*)s;
  return 0;
 2be:	4501                	li	a0,0
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <strchr+0x1a>

00000000000002ca <gets>:

char*
gets(char *buf, int max)
{
 2ca:	711d                	addi	sp,sp,-96
 2cc:	ec86                	sd	ra,88(sp)
 2ce:	e8a2                	sd	s0,80(sp)
 2d0:	e4a6                	sd	s1,72(sp)
 2d2:	e0ca                	sd	s2,64(sp)
 2d4:	fc4e                	sd	s3,56(sp)
 2d6:	f852                	sd	s4,48(sp)
 2d8:	f456                	sd	s5,40(sp)
 2da:	f05a                	sd	s6,32(sp)
 2dc:	ec5e                	sd	s7,24(sp)
 2de:	1080                	addi	s0,sp,96
 2e0:	8baa                	mv	s7,a0
 2e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e4:	892a                	mv	s2,a0
 2e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2e8:	4aa9                	li	s5,10
 2ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2ec:	89a6                	mv	s3,s1
 2ee:	2485                	addiw	s1,s1,1
 2f0:	0344d663          	bge	s1,s4,31c <gets+0x52>
    cc = read(0, &c, 1);
 2f4:	4605                	li	a2,1
 2f6:	faf40593          	addi	a1,s0,-81
 2fa:	4501                	li	a0,0
 2fc:	186000ef          	jal	482 <read>
    if(cc < 1)
 300:	00a05e63          	blez	a0,31c <gets+0x52>
    buf[i++] = c;
 304:	faf44783          	lbu	a5,-81(s0)
 308:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 30c:	01578763          	beq	a5,s5,31a <gets+0x50>
 310:	0905                	addi	s2,s2,1
 312:	fd679de3          	bne	a5,s6,2ec <gets+0x22>
    buf[i++] = c;
 316:	89a6                	mv	s3,s1
 318:	a011                	j	31c <gets+0x52>
 31a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 31c:	99de                	add	s3,s3,s7
 31e:	00098023          	sb	zero,0(s3)
  return buf;
}
 322:	855e                	mv	a0,s7
 324:	60e6                	ld	ra,88(sp)
 326:	6446                	ld	s0,80(sp)
 328:	64a6                	ld	s1,72(sp)
 32a:	6906                	ld	s2,64(sp)
 32c:	79e2                	ld	s3,56(sp)
 32e:	7a42                	ld	s4,48(sp)
 330:	7aa2                	ld	s5,40(sp)
 332:	7b02                	ld	s6,32(sp)
 334:	6be2                	ld	s7,24(sp)
 336:	6125                	addi	sp,sp,96
 338:	8082                	ret

000000000000033a <stat>:

int
stat(const char *n, struct stat *st)
{
 33a:	1101                	addi	sp,sp,-32
 33c:	ec06                	sd	ra,24(sp)
 33e:	e822                	sd	s0,16(sp)
 340:	e04a                	sd	s2,0(sp)
 342:	1000                	addi	s0,sp,32
 344:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 346:	4581                	li	a1,0
 348:	162000ef          	jal	4aa <open>
  if(fd < 0)
 34c:	02054263          	bltz	a0,370 <stat+0x36>
 350:	e426                	sd	s1,8(sp)
 352:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 354:	85ca                	mv	a1,s2
 356:	16c000ef          	jal	4c2 <fstat>
 35a:	892a                	mv	s2,a0
  close(fd);
 35c:	8526                	mv	a0,s1
 35e:	134000ef          	jal	492 <close>
  return r;
 362:	64a2                	ld	s1,8(sp)
}
 364:	854a                	mv	a0,s2
 366:	60e2                	ld	ra,24(sp)
 368:	6442                	ld	s0,16(sp)
 36a:	6902                	ld	s2,0(sp)
 36c:	6105                	addi	sp,sp,32
 36e:	8082                	ret
    return -1;
 370:	597d                	li	s2,-1
 372:	bfcd                	j	364 <stat+0x2a>

0000000000000374 <atoi>:

int
atoi(const char *s)
{
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 37a:	00054683          	lbu	a3,0(a0)
 37e:	fd06879b          	addiw	a5,a3,-48
 382:	0ff7f793          	zext.b	a5,a5
 386:	4625                	li	a2,9
 388:	02f66863          	bltu	a2,a5,3b8 <atoi+0x44>
 38c:	872a                	mv	a4,a0
  n = 0;
 38e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 390:	0705                	addi	a4,a4,1
 392:	0025179b          	slliw	a5,a0,0x2
 396:	9fa9                	addw	a5,a5,a0
 398:	0017979b          	slliw	a5,a5,0x1
 39c:	9fb5                	addw	a5,a5,a3
 39e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3a2:	00074683          	lbu	a3,0(a4)
 3a6:	fd06879b          	addiw	a5,a3,-48
 3aa:	0ff7f793          	zext.b	a5,a5
 3ae:	fef671e3          	bgeu	a2,a5,390 <atoi+0x1c>
  return n;
}
 3b2:	6422                	ld	s0,8(sp)
 3b4:	0141                	addi	sp,sp,16
 3b6:	8082                	ret
  n = 0;
 3b8:	4501                	li	a0,0
 3ba:	bfe5                	j	3b2 <atoi+0x3e>

00000000000003bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e422                	sd	s0,8(sp)
 3c0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c2:	02b57463          	bgeu	a0,a1,3ea <memmove+0x2e>
    while(n-- > 0)
 3c6:	00c05f63          	blez	a2,3e4 <memmove+0x28>
 3ca:	1602                	slli	a2,a2,0x20
 3cc:	9201                	srli	a2,a2,0x20
 3ce:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d2:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d4:	0585                	addi	a1,a1,1
 3d6:	0705                	addi	a4,a4,1
 3d8:	fff5c683          	lbu	a3,-1(a1)
 3dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3e0:	fef71ae3          	bne	a4,a5,3d4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e4:	6422                	ld	s0,8(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret
    dst += n;
 3ea:	00c50733          	add	a4,a0,a2
    src += n;
 3ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3f0:	fec05ae3          	blez	a2,3e4 <memmove+0x28>
 3f4:	fff6079b          	addiw	a5,a2,-1
 3f8:	1782                	slli	a5,a5,0x20
 3fa:	9381                	srli	a5,a5,0x20
 3fc:	fff7c793          	not	a5,a5
 400:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 402:	15fd                	addi	a1,a1,-1
 404:	177d                	addi	a4,a4,-1
 406:	0005c683          	lbu	a3,0(a1)
 40a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 40e:	fee79ae3          	bne	a5,a4,402 <memmove+0x46>
 412:	bfc9                	j	3e4 <memmove+0x28>

0000000000000414 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 41a:	ca05                	beqz	a2,44a <memcmp+0x36>
 41c:	fff6069b          	addiw	a3,a2,-1
 420:	1682                	slli	a3,a3,0x20
 422:	9281                	srli	a3,a3,0x20
 424:	0685                	addi	a3,a3,1
 426:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 428:	00054783          	lbu	a5,0(a0)
 42c:	0005c703          	lbu	a4,0(a1)
 430:	00e79863          	bne	a5,a4,440 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 434:	0505                	addi	a0,a0,1
    p2++;
 436:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 438:	fed518e3          	bne	a0,a3,428 <memcmp+0x14>
  }
  return 0;
 43c:	4501                	li	a0,0
 43e:	a019                	j	444 <memcmp+0x30>
      return *p1 - *p2;
 440:	40e7853b          	subw	a0,a5,a4
}
 444:	6422                	ld	s0,8(sp)
 446:	0141                	addi	sp,sp,16
 448:	8082                	ret
  return 0;
 44a:	4501                	li	a0,0
 44c:	bfe5                	j	444 <memcmp+0x30>

000000000000044e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 44e:	1141                	addi	sp,sp,-16
 450:	e406                	sd	ra,8(sp)
 452:	e022                	sd	s0,0(sp)
 454:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 456:	f67ff0ef          	jal	3bc <memmove>
}
 45a:	60a2                	ld	ra,8(sp)
 45c:	6402                	ld	s0,0(sp)
 45e:	0141                	addi	sp,sp,16
 460:	8082                	ret

<<<<<<< HEAD
0000000000000462 <fork>:
=======
00000000000004d0 <fork>:
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
<<<<<<< HEAD
 462:	4885                	li	a7,1
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <exit>:
.global exit
exit:
 li a7, SYS_exit
 46a:	4889                	li	a7,2
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <wait>:
.global wait
wait:
 li a7, SYS_wait
 472:	488d                	li	a7,3
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 47a:	4891                	li	a7,4
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <read>:
.global read
read:
 li a7, SYS_read
 482:	4895                	li	a7,5
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <write>:
.global write
write:
 li a7, SYS_write
 48a:	48c1                	li	a7,16
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <close>:
.global close
close:
 li a7, SYS_close
 492:	48d5                	li	a7,21
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <kill>:
.global kill
kill:
 li a7, SYS_kill
 49a:	4899                	li	a7,6
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a2:	489d                	li	a7,7
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <open>:
.global open
open:
 li a7, SYS_open
 4aa:	48bd                	li	a7,15
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b2:	48c5                	li	a7,17
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ba:	48c9                	li	a7,18
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c2:	48a1                	li	a7,8
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <link>:
.global link
link:
 li a7, SYS_link
 4ca:	48cd                	li	a7,19
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d2:	48d1                	li	a7,20
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4da:	48a5                	li	a7,9
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e2:	48a9                	li	a7,10
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ea:	48ad                	li	a7,11
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f2:	48b1                	li	a7,12
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4fa:	48b5                	li	a7,13
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 502:	48b9                	li	a7,14
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 50a:	1101                	addi	sp,sp,-32
 50c:	ec06                	sd	ra,24(sp)
 50e:	e822                	sd	s0,16(sp)
 510:	1000                	addi	s0,sp,32
 512:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 516:	4605                	li	a2,1
 518:	fef40593          	addi	a1,s0,-17
 51c:	f6fff0ef          	jal	48a <write>
}
 520:	60e2                	ld	ra,24(sp)
 522:	6442                	ld	s0,16(sp)
 524:	6105                	addi	sp,sp,32
 526:	8082                	ret

0000000000000528 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 528:	7139                	addi	sp,sp,-64
 52a:	fc06                	sd	ra,56(sp)
 52c:	f822                	sd	s0,48(sp)
 52e:	f426                	sd	s1,40(sp)
 530:	0080                	addi	s0,sp,64
 532:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 534:	c299                	beqz	a3,53a <printint+0x12>
 536:	0805c963          	bltz	a1,5c8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 53a:	2581                	sext.w	a1,a1
  neg = 0;
 53c:	4881                	li	a7,0
 53e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 542:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 544:	2601                	sext.w	a2,a2
 546:	00000517          	auipc	a0,0x0
 54a:	4f250513          	addi	a0,a0,1266 # a38 <digits>
 54e:	883a                	mv	a6,a4
 550:	2705                	addiw	a4,a4,1
 552:	02c5f7bb          	remuw	a5,a1,a2
 556:	1782                	slli	a5,a5,0x20
 558:	9381                	srli	a5,a5,0x20
 55a:	97aa                	add	a5,a5,a0
 55c:	0007c783          	lbu	a5,0(a5)
 560:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 564:	0005879b          	sext.w	a5,a1
 568:	02c5d5bb          	divuw	a1,a1,a2
 56c:	0685                	addi	a3,a3,1
 56e:	fec7f0e3          	bgeu	a5,a2,54e <printint+0x26>
  if(neg)
 572:	00088c63          	beqz	a7,58a <printint+0x62>
    buf[i++] = '-';
 576:	fd070793          	addi	a5,a4,-48
 57a:	00878733          	add	a4,a5,s0
 57e:	02d00793          	li	a5,45
 582:	fef70823          	sb	a5,-16(a4)
 586:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 58a:	02e05a63          	blez	a4,5be <printint+0x96>
 58e:	f04a                	sd	s2,32(sp)
 590:	ec4e                	sd	s3,24(sp)
 592:	fc040793          	addi	a5,s0,-64
 596:	00e78933          	add	s2,a5,a4
 59a:	fff78993          	addi	s3,a5,-1
 59e:	99ba                	add	s3,s3,a4
 5a0:	377d                	addiw	a4,a4,-1
 5a2:	1702                	slli	a4,a4,0x20
 5a4:	9301                	srli	a4,a4,0x20
 5a6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5aa:	fff94583          	lbu	a1,-1(s2)
 5ae:	8526                	mv	a0,s1
 5b0:	f5bff0ef          	jal	50a <putc>
  while(--i >= 0)
 5b4:	197d                	addi	s2,s2,-1
 5b6:	ff391ae3          	bne	s2,s3,5aa <printint+0x82>
 5ba:	7902                	ld	s2,32(sp)
 5bc:	69e2                	ld	s3,24(sp)
}
 5be:	70e2                	ld	ra,56(sp)
 5c0:	7442                	ld	s0,48(sp)
 5c2:	74a2                	ld	s1,40(sp)
 5c4:	6121                	addi	sp,sp,64
 5c6:	8082                	ret
    x = -xx;
 5c8:	40b005bb          	negw	a1,a1
    neg = 1;
 5cc:	4885                	li	a7,1
    x = -xx;
 5ce:	bf85                	j	53e <printint+0x16>

00000000000005d0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d0:	711d                	addi	sp,sp,-96
 5d2:	ec86                	sd	ra,88(sp)
 5d4:	e8a2                	sd	s0,80(sp)
 5d6:	e0ca                	sd	s2,64(sp)
 5d8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5da:	0005c903          	lbu	s2,0(a1)
 5de:	26090863          	beqz	s2,84e <vprintf+0x27e>
 5e2:	e4a6                	sd	s1,72(sp)
 5e4:	fc4e                	sd	s3,56(sp)
 5e6:	f852                	sd	s4,48(sp)
 5e8:	f456                	sd	s5,40(sp)
 5ea:	f05a                	sd	s6,32(sp)
 5ec:	ec5e                	sd	s7,24(sp)
 5ee:	e862                	sd	s8,16(sp)
 5f0:	e466                	sd	s9,8(sp)
 5f2:	8b2a                	mv	s6,a0
 5f4:	8a2e                	mv	s4,a1
 5f6:	8bb2                	mv	s7,a2
  state = 0;
 5f8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5fa:	4481                	li	s1,0
 5fc:	4701                	li	a4,0
=======
 4d0:	4885                	li	a7,1
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d8:	4889                	li	a7,2
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4e0:	488d                	li	a7,3
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e8:	4891                	li	a7,4
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <read>:
.global read
read:
 li a7, SYS_read
 4f0:	4895                	li	a7,5
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <write>:
.global write
write:
 li a7, SYS_write
 4f8:	48c1                	li	a7,16
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <close>:
.global close
close:
 li a7, SYS_close
 500:	48d5                	li	a7,21
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <kill>:
.global kill
kill:
 li a7, SYS_kill
 508:	4899                	li	a7,6
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <exec>:
.global exec
exec:
 li a7, SYS_exec
 510:	489d                	li	a7,7
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <open>:
.global open
open:
 li a7, SYS_open
 518:	48bd                	li	a7,15
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 520:	48c5                	li	a7,17
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 528:	48c9                	li	a7,18
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 530:	48a1                	li	a7,8
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <link>:
.global link
link:
 li a7, SYS_link
 538:	48cd                	li	a7,19
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 540:	48d1                	li	a7,20
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 548:	48a5                	li	a7,9
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <dup>:
.global dup
dup:
 li a7, SYS_dup
 550:	48a9                	li	a7,10
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 558:	48ad                	li	a7,11
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 560:	48b1                	li	a7,12
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 568:	48b5                	li	a7,13
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 570:	48b9                	li	a7,14
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 578:	1101                	addi	sp,sp,-32
 57a:	ec06                	sd	ra,24(sp)
 57c:	e822                	sd	s0,16(sp)
 57e:	1000                	addi	s0,sp,32
 580:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 584:	4605                	li	a2,1
 586:	fef40593          	addi	a1,s0,-17
 58a:	f6fff0ef          	jal	4f8 <write>
}
 58e:	60e2                	ld	ra,24(sp)
 590:	6442                	ld	s0,16(sp)
 592:	6105                	addi	sp,sp,32
 594:	8082                	ret

0000000000000596 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 596:	7139                	addi	sp,sp,-64
 598:	fc06                	sd	ra,56(sp)
 59a:	f822                	sd	s0,48(sp)
 59c:	f426                	sd	s1,40(sp)
 59e:	0080                	addi	s0,sp,64
 5a0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a2:	c299                	beqz	a3,5a8 <printint+0x12>
 5a4:	0805c963          	bltz	a1,636 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a8:	2581                	sext.w	a1,a1
  neg = 0;
 5aa:	4881                	li	a7,0
 5ac:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5b0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b2:	2601                	sext.w	a2,a2
 5b4:	00000517          	auipc	a0,0x0
 5b8:	4fc50513          	addi	a0,a0,1276 # ab0 <digits>
 5bc:	883a                	mv	a6,a4
 5be:	2705                	addiw	a4,a4,1
 5c0:	02c5f7bb          	remuw	a5,a1,a2
 5c4:	1782                	slli	a5,a5,0x20
 5c6:	9381                	srli	a5,a5,0x20
 5c8:	97aa                	add	a5,a5,a0
 5ca:	0007c783          	lbu	a5,0(a5)
 5ce:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5d2:	0005879b          	sext.w	a5,a1
 5d6:	02c5d5bb          	divuw	a1,a1,a2
 5da:	0685                	addi	a3,a3,1
 5dc:	fec7f0e3          	bgeu	a5,a2,5bc <printint+0x26>
  if(neg)
 5e0:	00088c63          	beqz	a7,5f8 <printint+0x62>
    buf[i++] = '-';
 5e4:	fd070793          	addi	a5,a4,-48
 5e8:	00878733          	add	a4,a5,s0
 5ec:	02d00793          	li	a5,45
 5f0:	fef70823          	sb	a5,-16(a4)
 5f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5f8:	02e05a63          	blez	a4,62c <printint+0x96>
 5fc:	f04a                	sd	s2,32(sp)
 5fe:	ec4e                	sd	s3,24(sp)
 600:	fc040793          	addi	a5,s0,-64
 604:	00e78933          	add	s2,a5,a4
 608:	fff78993          	addi	s3,a5,-1
 60c:	99ba                	add	s3,s3,a4
 60e:	377d                	addiw	a4,a4,-1
 610:	1702                	slli	a4,a4,0x20
 612:	9301                	srli	a4,a4,0x20
 614:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 618:	fff94583          	lbu	a1,-1(s2)
 61c:	8526                	mv	a0,s1
 61e:	f5bff0ef          	jal	578 <putc>
  while(--i >= 0)
 622:	197d                	addi	s2,s2,-1
 624:	ff391ae3          	bne	s2,s3,618 <printint+0x82>
 628:	7902                	ld	s2,32(sp)
 62a:	69e2                	ld	s3,24(sp)
}
 62c:	70e2                	ld	ra,56(sp)
 62e:	7442                	ld	s0,48(sp)
 630:	74a2                	ld	s1,40(sp)
 632:	6121                	addi	sp,sp,64
 634:	8082                	ret
    x = -xx;
 636:	40b005bb          	negw	a1,a1
    neg = 1;
 63a:	4885                	li	a7,1
    x = -xx;
 63c:	bf85                	j	5ac <printint+0x16>

000000000000063e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 63e:	711d                	addi	sp,sp,-96
 640:	ec86                	sd	ra,88(sp)
 642:	e8a2                	sd	s0,80(sp)
 644:	e0ca                	sd	s2,64(sp)
 646:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 648:	0005c903          	lbu	s2,0(a1)
 64c:	26090863          	beqz	s2,8bc <vprintf+0x27e>
 650:	e4a6                	sd	s1,72(sp)
 652:	fc4e                	sd	s3,56(sp)
 654:	f852                	sd	s4,48(sp)
 656:	f456                	sd	s5,40(sp)
 658:	f05a                	sd	s6,32(sp)
 65a:	ec5e                	sd	s7,24(sp)
 65c:	e862                	sd	s8,16(sp)
 65e:	e466                	sd	s9,8(sp)
 660:	8b2a                	mv	s6,a0
 662:	8a2e                	mv	s4,a1
 664:	8bb2                	mv	s7,a2
  state = 0;
 666:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 668:	4481                	li	s1,0
 66a:	4701                	li	a4,0
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
<<<<<<< HEAD
 5fe:	02500a93          	li	s5,37
=======
 66c:	02500a93          	li	s5,37
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
<<<<<<< HEAD
 602:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 606:	06c00c93          	li	s9,108
 60a:	a005                	j	62a <vprintf+0x5a>
        putc(fd, c0);
 60c:	85ca                	mv	a1,s2
 60e:	855a                	mv	a0,s6
 610:	efbff0ef          	jal	50a <putc>
 614:	a019                	j	61a <vprintf+0x4a>
    } else if(state == '%'){
 616:	03598263          	beq	s3,s5,63a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 61a:	2485                	addiw	s1,s1,1
 61c:	8726                	mv	a4,s1
 61e:	009a07b3          	add	a5,s4,s1
 622:	0007c903          	lbu	s2,0(a5)
 626:	20090c63          	beqz	s2,83e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 62a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 62e:	fe0994e3          	bnez	s3,616 <vprintf+0x46>
      if(c0 == '%'){
 632:	fd579de3          	bne	a5,s5,60c <vprintf+0x3c>
        state = '%';
 636:	89be                	mv	s3,a5
 638:	b7cd                	j	61a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 63a:	00ea06b3          	add	a3,s4,a4
 63e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 642:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 644:	c681                	beqz	a3,64c <vprintf+0x7c>
 646:	9752                	add	a4,a4,s4
 648:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 64c:	03878f63          	beq	a5,s8,68a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 650:	05978963          	beq	a5,s9,6a2 <vprintf+0xd2>
=======
 670:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 674:	06c00c93          	li	s9,108
 678:	a005                	j	698 <vprintf+0x5a>
        putc(fd, c0);
 67a:	85ca                	mv	a1,s2
 67c:	855a                	mv	a0,s6
 67e:	efbff0ef          	jal	578 <putc>
 682:	a019                	j	688 <vprintf+0x4a>
    } else if(state == '%'){
 684:	03598263          	beq	s3,s5,6a8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 688:	2485                	addiw	s1,s1,1
 68a:	8726                	mv	a4,s1
 68c:	009a07b3          	add	a5,s4,s1
 690:	0007c903          	lbu	s2,0(a5)
 694:	20090c63          	beqz	s2,8ac <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 698:	0009079b          	sext.w	a5,s2
    if(state == 0){
 69c:	fe0994e3          	bnez	s3,684 <vprintf+0x46>
      if(c0 == '%'){
 6a0:	fd579de3          	bne	a5,s5,67a <vprintf+0x3c>
        state = '%';
 6a4:	89be                	mv	s3,a5
 6a6:	b7cd                	j	688 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6a8:	00ea06b3          	add	a3,s4,a4
 6ac:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6b0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6b2:	c681                	beqz	a3,6ba <vprintf+0x7c>
 6b4:	9752                	add	a4,a4,s4
 6b6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6ba:	03878f63          	beq	a5,s8,6f8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6be:	05978963          	beq	a5,s9,710 <vprintf+0xd2>
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
<<<<<<< HEAD
 654:	07500713          	li	a4,117
 658:	0ee78363          	beq	a5,a4,73e <vprintf+0x16e>
=======
 6c2:	07500713          	li	a4,117
 6c6:	0ee78363          	beq	a5,a4,7ac <vprintf+0x16e>
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
<<<<<<< HEAD
 65c:	07800713          	li	a4,120
 660:	12e78563          	beq	a5,a4,78a <vprintf+0x1ba>
=======
 6ca:	07800713          	li	a4,120
 6ce:	12e78563          	beq	a5,a4,7f8 <vprintf+0x1ba>
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
<<<<<<< HEAD
 664:	07000713          	li	a4,112
 668:	14e78a63          	beq	a5,a4,7bc <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 66c:	07300713          	li	a4,115
 670:	18e78a63          	beq	a5,a4,804 <vprintf+0x234>
=======
 6d2:	07000713          	li	a4,112
 6d6:	14e78a63          	beq	a5,a4,82a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6da:	07300713          	li	a4,115
 6de:	18e78a63          	beq	a5,a4,872 <vprintf+0x234>
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
<<<<<<< HEAD
 674:	02500713          	li	a4,37
 678:	04e79563          	bne	a5,a4,6c2 <vprintf+0xf2>
        putc(fd, '%');
 67c:	02500593          	li	a1,37
 680:	855a                	mv	a0,s6
 682:	e89ff0ef          	jal	50a <putc>
=======
 6e2:	02500713          	li	a4,37
 6e6:	04e79563          	bne	a5,a4,730 <vprintf+0xf2>
        putc(fd, '%');
 6ea:	02500593          	li	a1,37
 6ee:	855a                	mv	a0,s6
 6f0:	e89ff0ef          	jal	578 <putc>
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
<<<<<<< HEAD
 686:	4981                	li	s3,0
 688:	bf49                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 68a:	008b8913          	addi	s2,s7,8
 68e:	4685                	li	a3,1
 690:	4629                	li	a2,10
 692:	000ba583          	lw	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	e91ff0ef          	jal	528 <printint>
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	bfad                	j	61a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6a2:	06400793          	li	a5,100
 6a6:	02f68963          	beq	a3,a5,6d8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6aa:	06c00793          	li	a5,108
 6ae:	04f68263          	beq	a3,a5,6f2 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6b2:	07500793          	li	a5,117
 6b6:	0af68063          	beq	a3,a5,756 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6ba:	07800793          	li	a5,120
 6be:	0ef68263          	beq	a3,a5,7a2 <vprintf+0x1d2>
        putc(fd, '%');
 6c2:	02500593          	li	a1,37
 6c6:	855a                	mv	a0,s6
 6c8:	e43ff0ef          	jal	50a <putc>
        putc(fd, c0);
 6cc:	85ca                	mv	a1,s2
 6ce:	855a                	mv	a0,s6
 6d0:	e3bff0ef          	jal	50a <putc>
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b791                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4685                	li	a3,1
 6de:	4629                	li	a2,10
 6e0:	000ba583          	lw	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	e43ff0ef          	jal	528 <printint>
        i += 1;
 6ea:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
        i += 1;
 6f0:	b72d                	j	61a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f2:	06400793          	li	a5,100
 6f6:	02f60763          	beq	a2,a5,724 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6fa:	07500793          	li	a5,117
 6fe:	06f60963          	beq	a2,a5,770 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 702:	07800793          	li	a5,120
 706:	faf61ee3          	bne	a2,a5,6c2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 70a:	008b8913          	addi	s2,s7,8
 70e:	4681                	li	a3,0
 710:	4641                	li	a2,16
 712:	000ba583          	lw	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	e11ff0ef          	jal	528 <printint>
        i += 2;
 71c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
        i += 2;
 722:	bde5                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 724:	008b8913          	addi	s2,s7,8
 728:	4685                	li	a3,1
 72a:	4629                	li	a2,10
 72c:	000ba583          	lw	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	df7ff0ef          	jal	528 <printint>
        i += 2;
 736:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
        i += 2;
 73c:	bdf9                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 73e:	008b8913          	addi	s2,s7,8
 742:	4681                	li	a3,0
 744:	4629                	li	a2,10
 746:	000ba583          	lw	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	dddff0ef          	jal	528 <printint>
 750:	8bca                	mv	s7,s2
      state = 0;
 752:	4981                	li	s3,0
 754:	b5d9                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 756:	008b8913          	addi	s2,s7,8
 75a:	4681                	li	a3,0
 75c:	4629                	li	a2,10
 75e:	000ba583          	lw	a1,0(s7)
 762:	855a                	mv	a0,s6
 764:	dc5ff0ef          	jal	528 <printint>
        i += 1;
 768:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 76a:	8bca                	mv	s7,s2
      state = 0;
 76c:	4981                	li	s3,0
        i += 1;
 76e:	b575                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 770:	008b8913          	addi	s2,s7,8
 774:	4681                	li	a3,0
 776:	4629                	li	a2,10
 778:	000ba583          	lw	a1,0(s7)
 77c:	855a                	mv	a0,s6
 77e:	dabff0ef          	jal	528 <printint>
        i += 2;
 782:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 784:	8bca                	mv	s7,s2
      state = 0;
 786:	4981                	li	s3,0
        i += 2;
 788:	bd49                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 78a:	008b8913          	addi	s2,s7,8
 78e:	4681                	li	a3,0
 790:	4641                	li	a2,16
 792:	000ba583          	lw	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	d91ff0ef          	jal	528 <printint>
 79c:	8bca                	mv	s7,s2
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bdad                	j	61a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a2:	008b8913          	addi	s2,s7,8
 7a6:	4681                	li	a3,0
 7a8:	4641                	li	a2,16
 7aa:	000ba583          	lw	a1,0(s7)
 7ae:	855a                	mv	a0,s6
 7b0:	d79ff0ef          	jal	528 <printint>
        i += 1;
 7b4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b6:	8bca                	mv	s7,s2
      state = 0;
 7b8:	4981                	li	s3,0
        i += 1;
 7ba:	b585                	j	61a <vprintf+0x4a>
 7bc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7be:	008b8d13          	addi	s10,s7,8
 7c2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7c6:	03000593          	li	a1,48
 7ca:	855a                	mv	a0,s6
 7cc:	d3fff0ef          	jal	50a <putc>
  putc(fd, 'x');
 7d0:	07800593          	li	a1,120
 7d4:	855a                	mv	a0,s6
 7d6:	d35ff0ef          	jal	50a <putc>
 7da:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7dc:	00000b97          	auipc	s7,0x0
 7e0:	25cb8b93          	addi	s7,s7,604 # a38 <digits>
 7e4:	03c9d793          	srli	a5,s3,0x3c
 7e8:	97de                	add	a5,a5,s7
 7ea:	0007c583          	lbu	a1,0(a5)
 7ee:	855a                	mv	a0,s6
 7f0:	d1bff0ef          	jal	50a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7f4:	0992                	slli	s3,s3,0x4
 7f6:	397d                	addiw	s2,s2,-1
 7f8:	fe0916e3          	bnez	s2,7e4 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7fc:	8bea                	mv	s7,s10
      state = 0;
 7fe:	4981                	li	s3,0
 800:	6d02                	ld	s10,0(sp)
 802:	bd21                	j	61a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 804:	008b8993          	addi	s3,s7,8
 808:	000bb903          	ld	s2,0(s7)
 80c:	00090f63          	beqz	s2,82a <vprintf+0x25a>
        for(; *s; s++)
 810:	00094583          	lbu	a1,0(s2)
 814:	c195                	beqz	a1,838 <vprintf+0x268>
          putc(fd, *s);
 816:	855a                	mv	a0,s6
 818:	cf3ff0ef          	jal	50a <putc>
        for(; *s; s++)
 81c:	0905                	addi	s2,s2,1
 81e:	00094583          	lbu	a1,0(s2)
 822:	f9f5                	bnez	a1,816 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 824:	8bce                	mv	s7,s3
      state = 0;
 826:	4981                	li	s3,0
 828:	bbcd                	j	61a <vprintf+0x4a>
          s = "(null)";
 82a:	00000917          	auipc	s2,0x0
 82e:	20690913          	addi	s2,s2,518 # a30 <malloc+0xfa>
        for(; *s; s++)
 832:	02800593          	li	a1,40
 836:	b7c5                	j	816 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 838:	8bce                	mv	s7,s3
      state = 0;
 83a:	4981                	li	s3,0
 83c:	bbf9                	j	61a <vprintf+0x4a>
 83e:	64a6                	ld	s1,72(sp)
 840:	79e2                	ld	s3,56(sp)
 842:	7a42                	ld	s4,48(sp)
 844:	7aa2                	ld	s5,40(sp)
 846:	7b02                	ld	s6,32(sp)
 848:	6be2                	ld	s7,24(sp)
 84a:	6c42                	ld	s8,16(sp)
 84c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 84e:	60e6                	ld	ra,88(sp)
 850:	6446                	ld	s0,80(sp)
 852:	6906                	ld	s2,64(sp)
 854:	6125                	addi	sp,sp,96
 856:	8082                	ret

0000000000000858 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 858:	715d                	addi	sp,sp,-80
 85a:	ec06                	sd	ra,24(sp)
 85c:	e822                	sd	s0,16(sp)
 85e:	1000                	addi	s0,sp,32
 860:	e010                	sd	a2,0(s0)
 862:	e414                	sd	a3,8(s0)
 864:	e818                	sd	a4,16(s0)
 866:	ec1c                	sd	a5,24(s0)
 868:	03043023          	sd	a6,32(s0)
 86c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 870:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 874:	8622                	mv	a2,s0
 876:	d5bff0ef          	jal	5d0 <vprintf>
}
 87a:	60e2                	ld	ra,24(sp)
 87c:	6442                	ld	s0,16(sp)
 87e:	6161                	addi	sp,sp,80
 880:	8082                	ret

0000000000000882 <printf>:

void
printf(const char *fmt, ...)
{
 882:	711d                	addi	sp,sp,-96
 884:	ec06                	sd	ra,24(sp)
 886:	e822                	sd	s0,16(sp)
 888:	1000                	addi	s0,sp,32
 88a:	e40c                	sd	a1,8(s0)
 88c:	e810                	sd	a2,16(s0)
 88e:	ec14                	sd	a3,24(s0)
 890:	f018                	sd	a4,32(s0)
 892:	f41c                	sd	a5,40(s0)
 894:	03043823          	sd	a6,48(s0)
 898:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 89c:	00840613          	addi	a2,s0,8
 8a0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8a4:	85aa                	mv	a1,a0
 8a6:	4505                	li	a0,1
 8a8:	d29ff0ef          	jal	5d0 <vprintf>
}
 8ac:	60e2                	ld	ra,24(sp)
 8ae:	6442                	ld	s0,16(sp)
 8b0:	6125                	addi	sp,sp,96
 8b2:	8082                	ret

00000000000008b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b4:	1141                	addi	sp,sp,-16
 8b6:	e422                	sd	s0,8(sp)
 8b8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ba:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8be:	00000797          	auipc	a5,0x0
 8c2:	7527b783          	ld	a5,1874(a5) # 1010 <freep>
 8c6:	a02d                	j	8f0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c8:	4618                	lw	a4,8(a2)
 8ca:	9f2d                	addw	a4,a4,a1
 8cc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d0:	6398                	ld	a4,0(a5)
 8d2:	6310                	ld	a2,0(a4)
 8d4:	a83d                	j	912 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8d6:	ff852703          	lw	a4,-8(a0)
 8da:	9f31                	addw	a4,a4,a2
 8dc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8de:	ff053683          	ld	a3,-16(a0)
 8e2:	a091                	j	926 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e4:	6398                	ld	a4,0(a5)
 8e6:	00e7e463          	bltu	a5,a4,8ee <free+0x3a>
 8ea:	00e6ea63          	bltu	a3,a4,8fe <free+0x4a>
{
 8ee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f0:	fed7fae3          	bgeu	a5,a3,8e4 <free+0x30>
 8f4:	6398                	ld	a4,0(a5)
 8f6:	00e6e463          	bltu	a3,a4,8fe <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fa:	fee7eae3          	bltu	a5,a4,8ee <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8fe:	ff852583          	lw	a1,-8(a0)
 902:	6390                	ld	a2,0(a5)
 904:	02059813          	slli	a6,a1,0x20
 908:	01c85713          	srli	a4,a6,0x1c
 90c:	9736                	add	a4,a4,a3
 90e:	fae60de3          	beq	a2,a4,8c8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 912:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 916:	4790                	lw	a2,8(a5)
 918:	02061593          	slli	a1,a2,0x20
 91c:	01c5d713          	srli	a4,a1,0x1c
 920:	973e                	add	a4,a4,a5
 922:	fae68ae3          	beq	a3,a4,8d6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 926:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 928:	00000717          	auipc	a4,0x0
 92c:	6ef73423          	sd	a5,1768(a4) # 1010 <freep>
}
 930:	6422                	ld	s0,8(sp)
 932:	0141                	addi	sp,sp,16
 934:	8082                	ret

0000000000000936 <malloc>:
=======
 6f4:	4981                	li	s3,0
 6f6:	bf49                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6f8:	008b8913          	addi	s2,s7,8
 6fc:	4685                	li	a3,1
 6fe:	4629                	li	a2,10
 700:	000ba583          	lw	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e91ff0ef          	jal	596 <printint>
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bfad                	j	688 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 710:	06400793          	li	a5,100
 714:	02f68963          	beq	a3,a5,746 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 718:	06c00793          	li	a5,108
 71c:	04f68263          	beq	a3,a5,760 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 720:	07500793          	li	a5,117
 724:	0af68063          	beq	a3,a5,7c4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 728:	07800793          	li	a5,120
 72c:	0ef68263          	beq	a3,a5,810 <vprintf+0x1d2>
        putc(fd, '%');
 730:	02500593          	li	a1,37
 734:	855a                	mv	a0,s6
 736:	e43ff0ef          	jal	578 <putc>
        putc(fd, c0);
 73a:	85ca                	mv	a1,s2
 73c:	855a                	mv	a0,s6
 73e:	e3bff0ef          	jal	578 <putc>
      state = 0;
 742:	4981                	li	s3,0
 744:	b791                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 746:	008b8913          	addi	s2,s7,8
 74a:	4685                	li	a3,1
 74c:	4629                	li	a2,10
 74e:	000ba583          	lw	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	e43ff0ef          	jal	596 <printint>
        i += 1;
 758:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 75a:	8bca                	mv	s7,s2
      state = 0;
 75c:	4981                	li	s3,0
        i += 1;
 75e:	b72d                	j	688 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 760:	06400793          	li	a5,100
 764:	02f60763          	beq	a2,a5,792 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 768:	07500793          	li	a5,117
 76c:	06f60963          	beq	a2,a5,7de <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 770:	07800793          	li	a5,120
 774:	faf61ee3          	bne	a2,a5,730 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 778:	008b8913          	addi	s2,s7,8
 77c:	4681                	li	a3,0
 77e:	4641                	li	a2,16
 780:	000ba583          	lw	a1,0(s7)
 784:	855a                	mv	a0,s6
 786:	e11ff0ef          	jal	596 <printint>
        i += 2;
 78a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 78c:	8bca                	mv	s7,s2
      state = 0;
 78e:	4981                	li	s3,0
        i += 2;
 790:	bde5                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 792:	008b8913          	addi	s2,s7,8
 796:	4685                	li	a3,1
 798:	4629                	li	a2,10
 79a:	000ba583          	lw	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	df7ff0ef          	jal	596 <printint>
        i += 2;
 7a4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a6:	8bca                	mv	s7,s2
      state = 0;
 7a8:	4981                	li	s3,0
        i += 2;
 7aa:	bdf9                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7ac:	008b8913          	addi	s2,s7,8
 7b0:	4681                	li	a3,0
 7b2:	4629                	li	a2,10
 7b4:	000ba583          	lw	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	dddff0ef          	jal	596 <printint>
 7be:	8bca                	mv	s7,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b5d9                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c4:	008b8913          	addi	s2,s7,8
 7c8:	4681                	li	a3,0
 7ca:	4629                	li	a2,10
 7cc:	000ba583          	lw	a1,0(s7)
 7d0:	855a                	mv	a0,s6
 7d2:	dc5ff0ef          	jal	596 <printint>
        i += 1;
 7d6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d8:	8bca                	mv	s7,s2
      state = 0;
 7da:	4981                	li	s3,0
        i += 1;
 7dc:	b575                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7de:	008b8913          	addi	s2,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4629                	li	a2,10
 7e6:	000ba583          	lw	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	dabff0ef          	jal	596 <printint>
        i += 2;
 7f0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f2:	8bca                	mv	s7,s2
      state = 0;
 7f4:	4981                	li	s3,0
        i += 2;
 7f6:	bd49                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7f8:	008b8913          	addi	s2,s7,8
 7fc:	4681                	li	a3,0
 7fe:	4641                	li	a2,16
 800:	000ba583          	lw	a1,0(s7)
 804:	855a                	mv	a0,s6
 806:	d91ff0ef          	jal	596 <printint>
 80a:	8bca                	mv	s7,s2
      state = 0;
 80c:	4981                	li	s3,0
 80e:	bdad                	j	688 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 810:	008b8913          	addi	s2,s7,8
 814:	4681                	li	a3,0
 816:	4641                	li	a2,16
 818:	000ba583          	lw	a1,0(s7)
 81c:	855a                	mv	a0,s6
 81e:	d79ff0ef          	jal	596 <printint>
        i += 1;
 822:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 824:	8bca                	mv	s7,s2
      state = 0;
 826:	4981                	li	s3,0
        i += 1;
 828:	b585                	j	688 <vprintf+0x4a>
 82a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 82c:	008b8d13          	addi	s10,s7,8
 830:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 834:	03000593          	li	a1,48
 838:	855a                	mv	a0,s6
 83a:	d3fff0ef          	jal	578 <putc>
  putc(fd, 'x');
 83e:	07800593          	li	a1,120
 842:	855a                	mv	a0,s6
 844:	d35ff0ef          	jal	578 <putc>
 848:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 84a:	00000b97          	auipc	s7,0x0
 84e:	266b8b93          	addi	s7,s7,614 # ab0 <digits>
 852:	03c9d793          	srli	a5,s3,0x3c
 856:	97de                	add	a5,a5,s7
 858:	0007c583          	lbu	a1,0(a5)
 85c:	855a                	mv	a0,s6
 85e:	d1bff0ef          	jal	578 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 862:	0992                	slli	s3,s3,0x4
 864:	397d                	addiw	s2,s2,-1
 866:	fe0916e3          	bnez	s2,852 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 86a:	8bea                	mv	s7,s10
      state = 0;
 86c:	4981                	li	s3,0
 86e:	6d02                	ld	s10,0(sp)
 870:	bd21                	j	688 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 872:	008b8993          	addi	s3,s7,8
 876:	000bb903          	ld	s2,0(s7)
 87a:	00090f63          	beqz	s2,898 <vprintf+0x25a>
        for(; *s; s++)
 87e:	00094583          	lbu	a1,0(s2)
 882:	c195                	beqz	a1,8a6 <vprintf+0x268>
          putc(fd, *s);
 884:	855a                	mv	a0,s6
 886:	cf3ff0ef          	jal	578 <putc>
        for(; *s; s++)
 88a:	0905                	addi	s2,s2,1
 88c:	00094583          	lbu	a1,0(s2)
 890:	f9f5                	bnez	a1,884 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 892:	8bce                	mv	s7,s3
      state = 0;
 894:	4981                	li	s3,0
 896:	bbcd                	j	688 <vprintf+0x4a>
          s = "(null)";
 898:	00000917          	auipc	s2,0x0
 89c:	21090913          	addi	s2,s2,528 # aa8 <malloc+0x104>
        for(; *s; s++)
 8a0:	02800593          	li	a1,40
 8a4:	b7c5                	j	884 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8a6:	8bce                	mv	s7,s3
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	bbf9                	j	688 <vprintf+0x4a>
 8ac:	64a6                	ld	s1,72(sp)
 8ae:	79e2                	ld	s3,56(sp)
 8b0:	7a42                	ld	s4,48(sp)
 8b2:	7aa2                	ld	s5,40(sp)
 8b4:	7b02                	ld	s6,32(sp)
 8b6:	6be2                	ld	s7,24(sp)
 8b8:	6c42                	ld	s8,16(sp)
 8ba:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8bc:	60e6                	ld	ra,88(sp)
 8be:	6446                	ld	s0,80(sp)
 8c0:	6906                	ld	s2,64(sp)
 8c2:	6125                	addi	sp,sp,96
 8c4:	8082                	ret

00000000000008c6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8c6:	715d                	addi	sp,sp,-80
 8c8:	ec06                	sd	ra,24(sp)
 8ca:	e822                	sd	s0,16(sp)
 8cc:	1000                	addi	s0,sp,32
 8ce:	e010                	sd	a2,0(s0)
 8d0:	e414                	sd	a3,8(s0)
 8d2:	e818                	sd	a4,16(s0)
 8d4:	ec1c                	sd	a5,24(s0)
 8d6:	03043023          	sd	a6,32(s0)
 8da:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e2:	8622                	mv	a2,s0
 8e4:	d5bff0ef          	jal	63e <vprintf>
}
 8e8:	60e2                	ld	ra,24(sp)
 8ea:	6442                	ld	s0,16(sp)
 8ec:	6161                	addi	sp,sp,80
 8ee:	8082                	ret

00000000000008f0 <printf>:

void
printf(const char *fmt, ...)
{
 8f0:	711d                	addi	sp,sp,-96
 8f2:	ec06                	sd	ra,24(sp)
 8f4:	e822                	sd	s0,16(sp)
 8f6:	1000                	addi	s0,sp,32
 8f8:	e40c                	sd	a1,8(s0)
 8fa:	e810                	sd	a2,16(s0)
 8fc:	ec14                	sd	a3,24(s0)
 8fe:	f018                	sd	a4,32(s0)
 900:	f41c                	sd	a5,40(s0)
 902:	03043823          	sd	a6,48(s0)
 906:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 90a:	00840613          	addi	a2,s0,8
 90e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 912:	85aa                	mv	a1,a0
 914:	4505                	li	a0,1
 916:	d29ff0ef          	jal	63e <vprintf>
}
 91a:	60e2                	ld	ra,24(sp)
 91c:	6442                	ld	s0,16(sp)
 91e:	6125                	addi	sp,sp,96
 920:	8082                	ret

0000000000000922 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 922:	1141                	addi	sp,sp,-16
 924:	e422                	sd	s0,8(sp)
 926:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 928:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92c:	00000797          	auipc	a5,0x0
 930:	6e47b783          	ld	a5,1764(a5) # 1010 <freep>
 934:	a02d                	j	95e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 936:	4618                	lw	a4,8(a2)
 938:	9f2d                	addw	a4,a4,a1
 93a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 93e:	6398                	ld	a4,0(a5)
 940:	6310                	ld	a2,0(a4)
 942:	a83d                	j	980 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 944:	ff852703          	lw	a4,-8(a0)
 948:	9f31                	addw	a4,a4,a2
 94a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 94c:	ff053683          	ld	a3,-16(a0)
 950:	a091                	j	994 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 952:	6398                	ld	a4,0(a5)
 954:	00e7e463          	bltu	a5,a4,95c <free+0x3a>
 958:	00e6ea63          	bltu	a3,a4,96c <free+0x4a>
{
 95c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95e:	fed7fae3          	bgeu	a5,a3,952 <free+0x30>
 962:	6398                	ld	a4,0(a5)
 964:	00e6e463          	bltu	a3,a4,96c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 968:	fee7eae3          	bltu	a5,a4,95c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 96c:	ff852583          	lw	a1,-8(a0)
 970:	6390                	ld	a2,0(a5)
 972:	02059813          	slli	a6,a1,0x20
 976:	01c85713          	srli	a4,a6,0x1c
 97a:	9736                	add	a4,a4,a3
 97c:	fae60de3          	beq	a2,a4,936 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 980:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 984:	4790                	lw	a2,8(a5)
 986:	02061593          	slli	a1,a2,0x20
 98a:	01c5d713          	srli	a4,a1,0x1c
 98e:	973e                	add	a4,a4,a5
 990:	fae68ae3          	beq	a3,a4,944 <free+0x22>
    p->s.ptr = bp->s.ptr;
 994:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 996:	00000717          	auipc	a4,0x0
 99a:	66f73d23          	sd	a5,1658(a4) # 1010 <freep>
}
 99e:	6422                	ld	s0,8(sp)
 9a0:	0141                	addi	sp,sp,16
 9a2:	8082                	ret

00000000000009a4 <malloc>:
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
  return freep;
}

void*
malloc(uint nbytes)
{
<<<<<<< HEAD
 936:	7139                	addi	sp,sp,-64
 938:	fc06                	sd	ra,56(sp)
 93a:	f822                	sd	s0,48(sp)
 93c:	f426                	sd	s1,40(sp)
 93e:	ec4e                	sd	s3,24(sp)
 940:	0080                	addi	s0,sp,64
=======
 9a4:	7139                	addi	sp,sp,-64
 9a6:	fc06                	sd	ra,56(sp)
 9a8:	f822                	sd	s0,48(sp)
 9aa:	f426                	sd	s1,40(sp)
 9ac:	ec4e                	sd	s3,24(sp)
 9ae:	0080                	addi	s0,sp,64
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
<<<<<<< HEAD
 942:	02051493          	slli	s1,a0,0x20
 946:	9081                	srli	s1,s1,0x20
 948:	04bd                	addi	s1,s1,15
 94a:	8091                	srli	s1,s1,0x4
 94c:	0014899b          	addiw	s3,s1,1
 950:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 952:	00000517          	auipc	a0,0x0
 956:	6be53503          	ld	a0,1726(a0) # 1010 <freep>
 95a:	c915                	beqz	a0,98e <malloc+0x58>
=======
 9b0:	02051493          	slli	s1,a0,0x20
 9b4:	9081                	srli	s1,s1,0x20
 9b6:	04bd                	addi	s1,s1,15
 9b8:	8091                	srli	s1,s1,0x4
 9ba:	0014899b          	addiw	s3,s1,1
 9be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9c0:	00000517          	auipc	a0,0x0
 9c4:	65053503          	ld	a0,1616(a0) # 1010 <freep>
 9c8:	c915                	beqz	a0,9fc <malloc+0x58>
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
<<<<<<< HEAD
 95c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 95e:	4798                	lw	a4,8(a5)
 960:	08977a63          	bgeu	a4,s1,9f4 <malloc+0xbe>
 964:	f04a                	sd	s2,32(sp)
 966:	e852                	sd	s4,16(sp)
 968:	e456                	sd	s5,8(sp)
 96a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 96c:	8a4e                	mv	s4,s3
 96e:	0009871b          	sext.w	a4,s3
 972:	6685                	lui	a3,0x1
 974:	00d77363          	bgeu	a4,a3,97a <malloc+0x44>
 978:	6a05                	lui	s4,0x1
 97a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 97e:	004a1a1b          	slliw	s4,s4,0x4
=======
 9ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9cc:	4798                	lw	a4,8(a5)
 9ce:	08977a63          	bgeu	a4,s1,a62 <malloc+0xbe>
 9d2:	f04a                	sd	s2,32(sp)
 9d4:	e852                	sd	s4,16(sp)
 9d6:	e456                	sd	s5,8(sp)
 9d8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9da:	8a4e                	mv	s4,s3
 9dc:	0009871b          	sext.w	a4,s3
 9e0:	6685                	lui	a3,0x1
 9e2:	00d77363          	bgeu	a4,a3,9e8 <malloc+0x44>
 9e6:	6a05                	lui	s4,0x1
 9e8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ec:	004a1a1b          	slliw	s4,s4,0x4
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
<<<<<<< HEAD
 982:	00000917          	auipc	s2,0x0
 986:	68e90913          	addi	s2,s2,1678 # 1010 <freep>
  if(p == (char*)-1)
 98a:	5afd                	li	s5,-1
 98c:	a081                	j	9cc <malloc+0x96>
 98e:	f04a                	sd	s2,32(sp)
 990:	e852                	sd	s4,16(sp)
 992:	e456                	sd	s5,8(sp)
 994:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 996:	00001797          	auipc	a5,0x1
 99a:	30a78793          	addi	a5,a5,778 # 1ca0 <base>
 99e:	00000717          	auipc	a4,0x0
 9a2:	66f73923          	sd	a5,1650(a4) # 1010 <freep>
 9a6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9a8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ac:	b7c1                	j	96c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9ae:	6398                	ld	a4,0(a5)
 9b0:	e118                	sd	a4,0(a0)
 9b2:	a8a9                	j	a0c <malloc+0xd6>
  hp->s.size = nu;
 9b4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9b8:	0541                	addi	a0,a0,16
 9ba:	efbff0ef          	jal	8b4 <free>
  return freep;
 9be:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9c2:	c12d                	beqz	a0,a24 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c6:	4798                	lw	a4,8(a5)
 9c8:	02977263          	bgeu	a4,s1,9ec <malloc+0xb6>
    if(p == freep)
 9cc:	00093703          	ld	a4,0(s2)
 9d0:	853e                	mv	a0,a5
 9d2:	fef719e3          	bne	a4,a5,9c4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9d6:	8552                	mv	a0,s4
 9d8:	b1bff0ef          	jal	4f2 <sbrk>
  if(p == (char*)-1)
 9dc:	fd551ce3          	bne	a0,s5,9b4 <malloc+0x7e>
        return 0;
 9e0:	4501                	li	a0,0
 9e2:	7902                	ld	s2,32(sp)
 9e4:	6a42                	ld	s4,16(sp)
 9e6:	6aa2                	ld	s5,8(sp)
 9e8:	6b02                	ld	s6,0(sp)
 9ea:	a03d                	j	a18 <malloc+0xe2>
 9ec:	7902                	ld	s2,32(sp)
 9ee:	6a42                	ld	s4,16(sp)
 9f0:	6aa2                	ld	s5,8(sp)
 9f2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9f4:	fae48de3          	beq	s1,a4,9ae <malloc+0x78>
        p->s.size -= nunits;
 9f8:	4137073b          	subw	a4,a4,s3
 9fc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9fe:	02071693          	slli	a3,a4,0x20
 a02:	01c6d713          	srli	a4,a3,0x1c
 a06:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a08:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a0c:	00000717          	auipc	a4,0x0
 a10:	60a73223          	sd	a0,1540(a4) # 1010 <freep>
      return (void*)(p + 1);
 a14:	01078513          	addi	a0,a5,16
  }
}
 a18:	70e2                	ld	ra,56(sp)
 a1a:	7442                	ld	s0,48(sp)
 a1c:	74a2                	ld	s1,40(sp)
 a1e:	69e2                	ld	s3,24(sp)
 a20:	6121                	addi	sp,sp,64
 a22:	8082                	ret
 a24:	7902                	ld	s2,32(sp)
 a26:	6a42                	ld	s4,16(sp)
 a28:	6aa2                	ld	s5,8(sp)
 a2a:	6b02                	ld	s6,0(sp)
 a2c:	b7f5                	j	a18 <malloc+0xe2>
=======
 9f0:	00000917          	auipc	s2,0x0
 9f4:	62090913          	addi	s2,s2,1568 # 1010 <freep>
  if(p == (char*)-1)
 9f8:	5afd                	li	s5,-1
 9fa:	a081                	j	a3a <malloc+0x96>
 9fc:	f04a                	sd	s2,32(sp)
 9fe:	e852                	sd	s4,16(sp)
 a00:	e456                	sd	s5,8(sp)
 a02:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a04:	00004797          	auipc	a5,0x4
 a08:	61c78793          	addi	a5,a5,1564 # 5020 <base>
 a0c:	00000717          	auipc	a4,0x0
 a10:	60f73223          	sd	a5,1540(a4) # 1010 <freep>
 a14:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a16:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a1a:	b7c1                	j	9da <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a1c:	6398                	ld	a4,0(a5)
 a1e:	e118                	sd	a4,0(a0)
 a20:	a8a9                	j	a7a <malloc+0xd6>
  hp->s.size = nu;
 a22:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a26:	0541                	addi	a0,a0,16
 a28:	efbff0ef          	jal	922 <free>
  return freep;
 a2c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a30:	c12d                	beqz	a0,a92 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a32:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a34:	4798                	lw	a4,8(a5)
 a36:	02977263          	bgeu	a4,s1,a5a <malloc+0xb6>
    if(p == freep)
 a3a:	00093703          	ld	a4,0(s2)
 a3e:	853e                	mv	a0,a5
 a40:	fef719e3          	bne	a4,a5,a32 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a44:	8552                	mv	a0,s4
 a46:	b1bff0ef          	jal	560 <sbrk>
  if(p == (char*)-1)
 a4a:	fd551ce3          	bne	a0,s5,a22 <malloc+0x7e>
        return 0;
 a4e:	4501                	li	a0,0
 a50:	7902                	ld	s2,32(sp)
 a52:	6a42                	ld	s4,16(sp)
 a54:	6aa2                	ld	s5,8(sp)
 a56:	6b02                	ld	s6,0(sp)
 a58:	a03d                	j	a86 <malloc+0xe2>
 a5a:	7902                	ld	s2,32(sp)
 a5c:	6a42                	ld	s4,16(sp)
 a5e:	6aa2                	ld	s5,8(sp)
 a60:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a62:	fae48de3          	beq	s1,a4,a1c <malloc+0x78>
        p->s.size -= nunits;
 a66:	4137073b          	subw	a4,a4,s3
 a6a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a6c:	02071693          	slli	a3,a4,0x20
 a70:	01c6d713          	srli	a4,a3,0x1c
 a74:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a76:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a7a:	00000717          	auipc	a4,0x0
 a7e:	58a73b23          	sd	a0,1430(a4) # 1010 <freep>
      return (void*)(p + 1);
 a82:	01078513          	addi	a0,a5,16
  }
}
 a86:	70e2                	ld	ra,56(sp)
 a88:	7442                	ld	s0,48(sp)
 a8a:	74a2                	ld	s1,40(sp)
 a8c:	69e2                	ld	s3,24(sp)
 a8e:	6121                	addi	sp,sp,64
 a90:	8082                	ret
 a92:	7902                	ld	s2,32(sp)
 a94:	6a42                	ld	s4,16(sp)
 a96:	6aa2                	ld	s5,8(sp)
 a98:	6b02                	ld	s6,0(sp)
 a9a:	b7f5                	j	a86 <malloc+0xe2>
>>>>>>> d8ef786cf7adf02927e1f8892492bb9a315e3fc3
