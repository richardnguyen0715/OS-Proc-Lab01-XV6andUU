
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  16:	02e00a13          	li	s4,46
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	addi	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
  38:	4505                	li	a0,1
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  58:	87aa                	mv	a5,a0
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  6e:	0005c683          	lbu	a3,0(a1)
  72:	4501                	li	a0,0
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  7e:	4501                	li	a0,0
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret
  8c:	862e                	mv	a2,a1
  8e:	00250593          	addi	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
  b0:	0585                	addi	a1,a1,1
  b2:	00178513          	addi	a0,a5,1
  b6:	f95ff0ef          	jal	4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
  bc:	4505                	li	a0,1
  be:	8082                	ret

00000000000000c0 <match>:
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	addi	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  e6:	0485                	addi	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
  f0:	0505                	addi	a0,a0,1
  f2:	f59ff0ef          	jal	4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
  f8:	4505                	li	a0,1
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	addi	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
 106:	715d                	addi	sp,sp,-80
 108:	e486                	sd	ra,72(sp)
 10a:	e0a2                	sd	s0,64(sp)
 10c:	fc26                	sd	s1,56(sp)
 10e:	f84a                	sd	s2,48(sp)
 110:	f44e                	sd	s3,40(sp)
 112:	f052                	sd	s4,32(sp)
 114:	ec56                	sd	s5,24(sp)
 116:	e85a                	sd	s6,16(sp)
 118:	e45e                	sd	s7,8(sp)
 11a:	e062                	sd	s8,0(sp)
 11c:	0880                	addi	s0,sp,80
 11e:	89aa                	mv	s3,a0
 120:	8b2e                	mv	s6,a1
 122:	4a01                	li	s4,0
 124:	3ff00b93          	li	s7,1023
 128:	00001a97          	auipc	s5,0x1
 12c:	ee8a8a93          	addi	s5,s5,-280 # 1010 <buf>
 130:	a835                	j	16c <grep+0x66>
 132:	00148913          	addi	s2,s1,1
 136:	45a9                	li	a1,10
 138:	854a                	mv	a0,s2
 13a:	1c6000ef          	jal	300 <strchr>
 13e:	84aa                	mv	s1,a0
 140:	c505                	beqz	a0,168 <grep+0x62>
 142:	00048023          	sb	zero,0(s1)
 146:	85ca                	mv	a1,s2
 148:	854e                	mv	a0,s3
 14a:	f77ff0ef          	jal	c0 <match>
 14e:	d175                	beqz	a0,132 <grep+0x2c>
 150:	47a9                	li	a5,10
 152:	00f48023          	sb	a5,0(s1)
 156:	00148613          	addi	a2,s1,1
 15a:	4126063b          	subw	a2,a2,s2
 15e:	85ca                	mv	a1,s2
 160:	4505                	li	a0,1
 162:	382000ef          	jal	4e4 <write>
 166:	b7f1                	j	132 <grep+0x2c>
 168:	03404563          	bgtz	s4,192 <grep+0x8c>
 16c:	414b863b          	subw	a2,s7,s4
 170:	014a85b3          	add	a1,s5,s4
 174:	855a                	mv	a0,s6
 176:	366000ef          	jal	4dc <read>
 17a:	02a05963          	blez	a0,1ac <grep+0xa6>
 17e:	00aa0c3b          	addw	s8,s4,a0
 182:	000c0a1b          	sext.w	s4,s8
 186:	014a87b3          	add	a5,s5,s4
 18a:	00078023          	sb	zero,0(a5)
 18e:	8956                	mv	s2,s5
 190:	b75d                	j	136 <grep+0x30>
 192:	00001517          	auipc	a0,0x1
 196:	e7e50513          	addi	a0,a0,-386 # 1010 <buf>
 19a:	40a90a33          	sub	s4,s2,a0
 19e:	414c0a3b          	subw	s4,s8,s4
 1a2:	8652                	mv	a2,s4
 1a4:	85ca                	mv	a1,s2
 1a6:	270000ef          	jal	416 <memmove>
 1aa:	b7c9                	j	16c <grep+0x66>
 1ac:	60a6                	ld	ra,72(sp)
 1ae:	6406                	ld	s0,64(sp)
 1b0:	74e2                	ld	s1,56(sp)
 1b2:	7942                	ld	s2,48(sp)
 1b4:	79a2                	ld	s3,40(sp)
 1b6:	7a02                	ld	s4,32(sp)
 1b8:	6ae2                	ld	s5,24(sp)
 1ba:	6b42                	ld	s6,16(sp)
 1bc:	6ba2                	ld	s7,8(sp)
 1be:	6c02                	ld	s8,0(sp)
 1c0:	6161                	addi	sp,sp,80
 1c2:	8082                	ret

00000000000001c4 <main>:
 1c4:	7179                	addi	sp,sp,-48
 1c6:	f406                	sd	ra,40(sp)
 1c8:	f022                	sd	s0,32(sp)
 1ca:	ec26                	sd	s1,24(sp)
 1cc:	e84a                	sd	s2,16(sp)
 1ce:	e44e                	sd	s3,8(sp)
 1d0:	e052                	sd	s4,0(sp)
 1d2:	1800                	addi	s0,sp,48
 1d4:	4785                	li	a5,1
 1d6:	04a7d663          	bge	a5,a0,222 <main+0x5e>
 1da:	0085ba03          	ld	s4,8(a1)
 1de:	4789                	li	a5,2
 1e0:	04a7db63          	bge	a5,a0,236 <main+0x72>
 1e4:	01058913          	addi	s2,a1,16
 1e8:	ffd5099b          	addiw	s3,a0,-3
 1ec:	02099793          	slli	a5,s3,0x20
 1f0:	01d7d993          	srli	s3,a5,0x1d
 1f4:	05e1                	addi	a1,a1,24
 1f6:	99ae                	add	s3,s3,a1
 1f8:	4581                	li	a1,0
 1fa:	00093503          	ld	a0,0(s2)
 1fe:	306000ef          	jal	504 <open>
 202:	84aa                	mv	s1,a0
 204:	04054063          	bltz	a0,244 <main+0x80>
 208:	85aa                	mv	a1,a0
 20a:	8552                	mv	a0,s4
 20c:	efbff0ef          	jal	106 <grep>
 210:	8526                	mv	a0,s1
 212:	2da000ef          	jal	4ec <close>
 216:	0921                	addi	s2,s2,8
 218:	ff3910e3          	bne	s2,s3,1f8 <main+0x34>
 21c:	4501                	li	a0,0
 21e:	2a6000ef          	jal	4c4 <exit>
 222:	00001597          	auipc	a1,0x1
 226:	86e58593          	addi	a1,a1,-1938 # a90 <malloc+0x100>
 22a:	4509                	li	a0,2
 22c:	686000ef          	jal	8b2 <fprintf>
 230:	4505                	li	a0,1
 232:	292000ef          	jal	4c4 <exit>
 236:	4581                	li	a1,0
 238:	8552                	mv	a0,s4
 23a:	ecdff0ef          	jal	106 <grep>
 23e:	4501                	li	a0,0
 240:	284000ef          	jal	4c4 <exit>
 244:	00093583          	ld	a1,0(s2)
 248:	00001517          	auipc	a0,0x1
 24c:	86850513          	addi	a0,a0,-1944 # ab0 <malloc+0x120>
 250:	68c000ef          	jal	8dc <printf>
 254:	4505                	li	a0,1
 256:	26e000ef          	jal	4c4 <exit>

000000000000025a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  extern int main();
  main();
 262:	f63ff0ef          	jal	1c4 <main>
  exit(0);
 266:	4501                	li	a0,0
 268:	25c000ef          	jal	4c4 <exit>

000000000000026c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 272:	87aa                	mv	a5,a0
 274:	0585                	addi	a1,a1,1
 276:	0785                	addi	a5,a5,1
 278:	fff5c703          	lbu	a4,-1(a1)
 27c:	fee78fa3          	sb	a4,-1(a5)
 280:	fb75                	bnez	a4,274 <strcpy+0x8>
    ;
  return os;
}
 282:	6422                	ld	s0,8(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 28e:	00054783          	lbu	a5,0(a0)
 292:	cb91                	beqz	a5,2a6 <strcmp+0x1e>
 294:	0005c703          	lbu	a4,0(a1)
 298:	00f71763          	bne	a4,a5,2a6 <strcmp+0x1e>
    p++, q++;
 29c:	0505                	addi	a0,a0,1
 29e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	fbe5                	bnez	a5,294 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2a6:	0005c503          	lbu	a0,0(a1)
}
 2aa:	40a7853b          	subw	a0,a5,a0
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <strlen>:

uint
strlen(const char *s)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	cf91                	beqz	a5,2da <strlen+0x26>
 2c0:	0505                	addi	a0,a0,1
 2c2:	87aa                	mv	a5,a0
 2c4:	86be                	mv	a3,a5
 2c6:	0785                	addi	a5,a5,1
 2c8:	fff7c703          	lbu	a4,-1(a5)
 2cc:	ff65                	bnez	a4,2c4 <strlen+0x10>
 2ce:	40a6853b          	subw	a0,a3,a0
 2d2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  for(n = 0; s[n]; n++)
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <strlen+0x20>

00000000000002de <memset>:

void*
memset(void *dst, int c, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e4:	ca19                	beqz	a2,2fa <memset+0x1c>
 2e6:	87aa                	mv	a5,a0
 2e8:	1602                	slli	a2,a2,0x20
 2ea:	9201                	srli	a2,a2,0x20
 2ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2f4:	0785                	addi	a5,a5,1
 2f6:	fee79de3          	bne	a5,a4,2f0 <memset+0x12>
  }
  return dst;
}
 2fa:	6422                	ld	s0,8(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <strchr>:

char*
strchr(const char *s, char c)
{
 300:	1141                	addi	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	addi	s0,sp,16
  for(; *s; s++)
 306:	00054783          	lbu	a5,0(a0)
 30a:	cb99                	beqz	a5,320 <strchr+0x20>
    if(*s == c)
 30c:	00f58763          	beq	a1,a5,31a <strchr+0x1a>
  for(; *s; s++)
 310:	0505                	addi	a0,a0,1
 312:	00054783          	lbu	a5,0(a0)
 316:	fbfd                	bnez	a5,30c <strchr+0xc>
      return (char*)s;
  return 0;
 318:	4501                	li	a0,0
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  return 0;
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <strchr+0x1a>

0000000000000324 <gets>:

char*
gets(char *buf, int max)
{
 324:	711d                	addi	sp,sp,-96
 326:	ec86                	sd	ra,88(sp)
 328:	e8a2                	sd	s0,80(sp)
 32a:	e4a6                	sd	s1,72(sp)
 32c:	e0ca                	sd	s2,64(sp)
 32e:	fc4e                	sd	s3,56(sp)
 330:	f852                	sd	s4,48(sp)
 332:	f456                	sd	s5,40(sp)
 334:	f05a                	sd	s6,32(sp)
 336:	ec5e                	sd	s7,24(sp)
 338:	1080                	addi	s0,sp,96
 33a:	8baa                	mv	s7,a0
 33c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33e:	892a                	mv	s2,a0
 340:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 342:	4aa9                	li	s5,10
 344:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 346:	89a6                	mv	s3,s1
 348:	2485                	addiw	s1,s1,1
 34a:	0344d663          	bge	s1,s4,376 <gets+0x52>
    cc = read(0, &c, 1);
 34e:	4605                	li	a2,1
 350:	faf40593          	addi	a1,s0,-81
 354:	4501                	li	a0,0
 356:	186000ef          	jal	4dc <read>
    if(cc < 1)
 35a:	00a05e63          	blez	a0,376 <gets+0x52>
    buf[i++] = c;
 35e:	faf44783          	lbu	a5,-81(s0)
 362:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 366:	01578763          	beq	a5,s5,374 <gets+0x50>
 36a:	0905                	addi	s2,s2,1
 36c:	fd679de3          	bne	a5,s6,346 <gets+0x22>
    buf[i++] = c;
 370:	89a6                	mv	s3,s1
 372:	a011                	j	376 <gets+0x52>
 374:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 376:	99de                	add	s3,s3,s7
 378:	00098023          	sb	zero,0(s3)
  return buf;
}
 37c:	855e                	mv	a0,s7
 37e:	60e6                	ld	ra,88(sp)
 380:	6446                	ld	s0,80(sp)
 382:	64a6                	ld	s1,72(sp)
 384:	6906                	ld	s2,64(sp)
 386:	79e2                	ld	s3,56(sp)
 388:	7a42                	ld	s4,48(sp)
 38a:	7aa2                	ld	s5,40(sp)
 38c:	7b02                	ld	s6,32(sp)
 38e:	6be2                	ld	s7,24(sp)
 390:	6125                	addi	sp,sp,96
 392:	8082                	ret

0000000000000394 <stat>:

int
stat(const char *n, struct stat *st)
{
 394:	1101                	addi	sp,sp,-32
 396:	ec06                	sd	ra,24(sp)
 398:	e822                	sd	s0,16(sp)
 39a:	e04a                	sd	s2,0(sp)
 39c:	1000                	addi	s0,sp,32
 39e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a0:	4581                	li	a1,0
 3a2:	162000ef          	jal	504 <open>
  if(fd < 0)
 3a6:	02054263          	bltz	a0,3ca <stat+0x36>
 3aa:	e426                	sd	s1,8(sp)
 3ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ae:	85ca                	mv	a1,s2
 3b0:	16c000ef          	jal	51c <fstat>
 3b4:	892a                	mv	s2,a0
  close(fd);
 3b6:	8526                	mv	a0,s1
 3b8:	134000ef          	jal	4ec <close>
  return r;
 3bc:	64a2                	ld	s1,8(sp)
}
 3be:	854a                	mv	a0,s2
 3c0:	60e2                	ld	ra,24(sp)
 3c2:	6442                	ld	s0,16(sp)
 3c4:	6902                	ld	s2,0(sp)
 3c6:	6105                	addi	sp,sp,32
 3c8:	8082                	ret
    return -1;
 3ca:	597d                	li	s2,-1
 3cc:	bfcd                	j	3be <stat+0x2a>

00000000000003ce <atoi>:

int
atoi(const char *s)
{
 3ce:	1141                	addi	sp,sp,-16
 3d0:	e422                	sd	s0,8(sp)
 3d2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d4:	00054683          	lbu	a3,0(a0)
 3d8:	fd06879b          	addiw	a5,a3,-48
 3dc:	0ff7f793          	zext.b	a5,a5
 3e0:	4625                	li	a2,9
 3e2:	02f66863          	bltu	a2,a5,412 <atoi+0x44>
 3e6:	872a                	mv	a4,a0
  n = 0;
 3e8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3ea:	0705                	addi	a4,a4,1
 3ec:	0025179b          	slliw	a5,a0,0x2
 3f0:	9fa9                	addw	a5,a5,a0
 3f2:	0017979b          	slliw	a5,a5,0x1
 3f6:	9fb5                	addw	a5,a5,a3
 3f8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3fc:	00074683          	lbu	a3,0(a4)
 400:	fd06879b          	addiw	a5,a3,-48
 404:	0ff7f793          	zext.b	a5,a5
 408:	fef671e3          	bgeu	a2,a5,3ea <atoi+0x1c>
  return n;
}
 40c:	6422                	ld	s0,8(sp)
 40e:	0141                	addi	sp,sp,16
 410:	8082                	ret
  n = 0;
 412:	4501                	li	a0,0
 414:	bfe5                	j	40c <atoi+0x3e>

0000000000000416 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 416:	1141                	addi	sp,sp,-16
 418:	e422                	sd	s0,8(sp)
 41a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 41c:	02b57463          	bgeu	a0,a1,444 <memmove+0x2e>
    while(n-- > 0)
 420:	00c05f63          	blez	a2,43e <memmove+0x28>
 424:	1602                	slli	a2,a2,0x20
 426:	9201                	srli	a2,a2,0x20
 428:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 42c:	872a                	mv	a4,a0
      *dst++ = *src++;
 42e:	0585                	addi	a1,a1,1
 430:	0705                	addi	a4,a4,1
 432:	fff5c683          	lbu	a3,-1(a1)
 436:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 43a:	fef71ae3          	bne	a4,a5,42e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 43e:	6422                	ld	s0,8(sp)
 440:	0141                	addi	sp,sp,16
 442:	8082                	ret
    dst += n;
 444:	00c50733          	add	a4,a0,a2
    src += n;
 448:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 44a:	fec05ae3          	blez	a2,43e <memmove+0x28>
 44e:	fff6079b          	addiw	a5,a2,-1
 452:	1782                	slli	a5,a5,0x20
 454:	9381                	srli	a5,a5,0x20
 456:	fff7c793          	not	a5,a5
 45a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 45c:	15fd                	addi	a1,a1,-1
 45e:	177d                	addi	a4,a4,-1
 460:	0005c683          	lbu	a3,0(a1)
 464:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 468:	fee79ae3          	bne	a5,a4,45c <memmove+0x46>
 46c:	bfc9                	j	43e <memmove+0x28>

000000000000046e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 46e:	1141                	addi	sp,sp,-16
 470:	e422                	sd	s0,8(sp)
 472:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 474:	ca05                	beqz	a2,4a4 <memcmp+0x36>
 476:	fff6069b          	addiw	a3,a2,-1
 47a:	1682                	slli	a3,a3,0x20
 47c:	9281                	srli	a3,a3,0x20
 47e:	0685                	addi	a3,a3,1
 480:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 482:	00054783          	lbu	a5,0(a0)
 486:	0005c703          	lbu	a4,0(a1)
 48a:	00e79863          	bne	a5,a4,49a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 48e:	0505                	addi	a0,a0,1
    p2++;
 490:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 492:	fed518e3          	bne	a0,a3,482 <memcmp+0x14>
  }
  return 0;
 496:	4501                	li	a0,0
 498:	a019                	j	49e <memcmp+0x30>
      return *p1 - *p2;
 49a:	40e7853b          	subw	a0,a5,a4
}
 49e:	6422                	ld	s0,8(sp)
 4a0:	0141                	addi	sp,sp,16
 4a2:	8082                	ret
  return 0;
 4a4:	4501                	li	a0,0
 4a6:	bfe5                	j	49e <memcmp+0x30>

00000000000004a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a8:	1141                	addi	sp,sp,-16
 4aa:	e406                	sd	ra,8(sp)
 4ac:	e022                	sd	s0,0(sp)
 4ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4b0:	f67ff0ef          	jal	416 <memmove>
}
 4b4:	60a2                	ld	ra,8(sp)
 4b6:	6402                	ld	s0,0(sp)
 4b8:	0141                	addi	sp,sp,16
 4ba:	8082                	ret

00000000000004bc <fork>:
 4bc:	4885                	li	a7,1
 4be:	00000073          	ecall
 4c2:	8082                	ret

00000000000004c4 <exit>:
 4c4:	4889                	li	a7,2
 4c6:	00000073          	ecall
 4ca:	8082                	ret

00000000000004cc <wait>:
 4cc:	488d                	li	a7,3
 4ce:	00000073          	ecall
 4d2:	8082                	ret

00000000000004d4 <pipe>:
 4d4:	4891                	li	a7,4
 4d6:	00000073          	ecall
 4da:	8082                	ret

00000000000004dc <read>:
 4dc:	4895                	li	a7,5
 4de:	00000073          	ecall
 4e2:	8082                	ret

00000000000004e4 <write>:
 4e4:	48c1                	li	a7,16
 4e6:	00000073          	ecall
 4ea:	8082                	ret

00000000000004ec <close>:
 4ec:	48d5                	li	a7,21
 4ee:	00000073          	ecall
 4f2:	8082                	ret

00000000000004f4 <kill>:
 4f4:	4899                	li	a7,6
 4f6:	00000073          	ecall
 4fa:	8082                	ret

00000000000004fc <exec>:
 4fc:	489d                	li	a7,7
 4fe:	00000073          	ecall
 502:	8082                	ret

0000000000000504 <open>:
 504:	48bd                	li	a7,15
 506:	00000073          	ecall
 50a:	8082                	ret

000000000000050c <mknod>:
 50c:	48c5                	li	a7,17
 50e:	00000073          	ecall
 512:	8082                	ret

0000000000000514 <unlink>:
 514:	48c9                	li	a7,18
 516:	00000073          	ecall
 51a:	8082                	ret

000000000000051c <fstat>:
 51c:	48a1                	li	a7,8
 51e:	00000073          	ecall
 522:	8082                	ret

0000000000000524 <link>:
 524:	48cd                	li	a7,19
 526:	00000073          	ecall
 52a:	8082                	ret

000000000000052c <mkdir>:
 52c:	48d1                	li	a7,20
 52e:	00000073          	ecall
 532:	8082                	ret

0000000000000534 <chdir>:
 534:	48a5                	li	a7,9
 536:	00000073          	ecall
 53a:	8082                	ret

000000000000053c <dup>:
 53c:	48a9                	li	a7,10
 53e:	00000073          	ecall
 542:	8082                	ret

0000000000000544 <getpid>:
 544:	48ad                	li	a7,11
 546:	00000073          	ecall
 54a:	8082                	ret

000000000000054c <sbrk>:
 54c:	48b1                	li	a7,12
 54e:	00000073          	ecall
 552:	8082                	ret

0000000000000554 <sleep>:
 554:	48b5                	li	a7,13
 556:	00000073          	ecall
 55a:	8082                	ret

000000000000055c <uptime>:
 55c:	48b9                	li	a7,14
 55e:	00000073          	ecall
 562:	8082                	ret

0000000000000564 <putc>:
 564:	1101                	addi	sp,sp,-32
 566:	ec06                	sd	ra,24(sp)
 568:	e822                	sd	s0,16(sp)
 56a:	1000                	addi	s0,sp,32
 56c:	feb407a3          	sb	a1,-17(s0)
 570:	4605                	li	a2,1
 572:	fef40593          	addi	a1,s0,-17
 576:	f6fff0ef          	jal	4e4 <write>
 57a:	60e2                	ld	ra,24(sp)
 57c:	6442                	ld	s0,16(sp)
 57e:	6105                	addi	sp,sp,32
 580:	8082                	ret

0000000000000582 <printint>:
 582:	7139                	addi	sp,sp,-64
 584:	fc06                	sd	ra,56(sp)
 586:	f822                	sd	s0,48(sp)
 588:	f426                	sd	s1,40(sp)
 58a:	0080                	addi	s0,sp,64
 58c:	84aa                	mv	s1,a0
 58e:	c299                	beqz	a3,594 <printint+0x12>
 590:	0805c963          	bltz	a1,622 <printint+0xa0>
 594:	2581                	sext.w	a1,a1
 596:	4881                	li	a7,0
 598:	fc040693          	addi	a3,s0,-64
 59c:	4701                	li	a4,0
 59e:	2601                	sext.w	a2,a2
 5a0:	00000517          	auipc	a0,0x0
 5a4:	53050513          	addi	a0,a0,1328 # ad0 <digits>
 5a8:	883a                	mv	a6,a4
 5aa:	2705                	addiw	a4,a4,1
 5ac:	02c5f7bb          	remuw	a5,a1,a2
 5b0:	1782                	slli	a5,a5,0x20
 5b2:	9381                	srli	a5,a5,0x20
 5b4:	97aa                	add	a5,a5,a0
 5b6:	0007c783          	lbu	a5,0(a5)
 5ba:	00f68023          	sb	a5,0(a3)
 5be:	0005879b          	sext.w	a5,a1
 5c2:	02c5d5bb          	divuw	a1,a1,a2
 5c6:	0685                	addi	a3,a3,1
 5c8:	fec7f0e3          	bgeu	a5,a2,5a8 <printint+0x26>
 5cc:	00088c63          	beqz	a7,5e4 <printint+0x62>
 5d0:	fd070793          	addi	a5,a4,-48
 5d4:	00878733          	add	a4,a5,s0
 5d8:	02d00793          	li	a5,45
 5dc:	fef70823          	sb	a5,-16(a4)
 5e0:	0028071b          	addiw	a4,a6,2
 5e4:	02e05a63          	blez	a4,618 <printint+0x96>
 5e8:	f04a                	sd	s2,32(sp)
 5ea:	ec4e                	sd	s3,24(sp)
 5ec:	fc040793          	addi	a5,s0,-64
 5f0:	00e78933          	add	s2,a5,a4
 5f4:	fff78993          	addi	s3,a5,-1
 5f8:	99ba                	add	s3,s3,a4
 5fa:	377d                	addiw	a4,a4,-1
 5fc:	1702                	slli	a4,a4,0x20
 5fe:	9301                	srli	a4,a4,0x20
 600:	40e989b3          	sub	s3,s3,a4
 604:	fff94583          	lbu	a1,-1(s2)
 608:	8526                	mv	a0,s1
 60a:	f5bff0ef          	jal	564 <putc>
 60e:	197d                	addi	s2,s2,-1
 610:	ff391ae3          	bne	s2,s3,604 <printint+0x82>
 614:	7902                	ld	s2,32(sp)
 616:	69e2                	ld	s3,24(sp)
 618:	70e2                	ld	ra,56(sp)
 61a:	7442                	ld	s0,48(sp)
 61c:	74a2                	ld	s1,40(sp)
 61e:	6121                	addi	sp,sp,64
 620:	8082                	ret
 622:	40b005bb          	negw	a1,a1
 626:	4885                	li	a7,1
 628:	bf85                	j	598 <printint+0x16>

000000000000062a <vprintf>:
 62a:	711d                	addi	sp,sp,-96
 62c:	ec86                	sd	ra,88(sp)
 62e:	e8a2                	sd	s0,80(sp)
 630:	e0ca                	sd	s2,64(sp)
 632:	1080                	addi	s0,sp,96
 634:	0005c903          	lbu	s2,0(a1)
 638:	26090863          	beqz	s2,8a8 <vprintf+0x27e>
 63c:	e4a6                	sd	s1,72(sp)
 63e:	fc4e                	sd	s3,56(sp)
 640:	f852                	sd	s4,48(sp)
 642:	f456                	sd	s5,40(sp)
 644:	f05a                	sd	s6,32(sp)
 646:	ec5e                	sd	s7,24(sp)
 648:	e862                	sd	s8,16(sp)
 64a:	e466                	sd	s9,8(sp)
 64c:	8b2a                	mv	s6,a0
 64e:	8a2e                	mv	s4,a1
 650:	8bb2                	mv	s7,a2
 652:	4981                	li	s3,0
 654:	4481                	li	s1,0
 656:	4701                	li	a4,0
 658:	02500a93          	li	s5,37
 65c:	06400c13          	li	s8,100
 660:	06c00c93          	li	s9,108
 664:	a005                	j	684 <vprintf+0x5a>
 666:	85ca                	mv	a1,s2
 668:	855a                	mv	a0,s6
 66a:	efbff0ef          	jal	564 <putc>
 66e:	a019                	j	674 <vprintf+0x4a>
 670:	03598263          	beq	s3,s5,694 <vprintf+0x6a>
 674:	2485                	addiw	s1,s1,1
 676:	8726                	mv	a4,s1
 678:	009a07b3          	add	a5,s4,s1
 67c:	0007c903          	lbu	s2,0(a5)
 680:	20090c63          	beqz	s2,898 <vprintf+0x26e>
 684:	0009079b          	sext.w	a5,s2
 688:	fe0994e3          	bnez	s3,670 <vprintf+0x46>
 68c:	fd579de3          	bne	a5,s5,666 <vprintf+0x3c>
 690:	89be                	mv	s3,a5
 692:	b7cd                	j	674 <vprintf+0x4a>
 694:	00ea06b3          	add	a3,s4,a4
 698:	0016c683          	lbu	a3,1(a3)
 69c:	8636                	mv	a2,a3
 69e:	c681                	beqz	a3,6a6 <vprintf+0x7c>
 6a0:	9752                	add	a4,a4,s4
 6a2:	00274603          	lbu	a2,2(a4)
 6a6:	03878f63          	beq	a5,s8,6e4 <vprintf+0xba>
 6aa:	05978963          	beq	a5,s9,6fc <vprintf+0xd2>
 6ae:	07500713          	li	a4,117
 6b2:	0ee78363          	beq	a5,a4,798 <vprintf+0x16e>
 6b6:	07800713          	li	a4,120
 6ba:	12e78563          	beq	a5,a4,7e4 <vprintf+0x1ba>
 6be:	07000713          	li	a4,112
 6c2:	14e78a63          	beq	a5,a4,816 <vprintf+0x1ec>
 6c6:	07300713          	li	a4,115
 6ca:	18e78a63          	beq	a5,a4,85e <vprintf+0x234>
 6ce:	02500713          	li	a4,37
 6d2:	04e79563          	bne	a5,a4,71c <vprintf+0xf2>
 6d6:	02500593          	li	a1,37
 6da:	855a                	mv	a0,s6
 6dc:	e89ff0ef          	jal	564 <putc>
 6e0:	4981                	li	s3,0
 6e2:	bf49                	j	674 <vprintf+0x4a>
 6e4:	008b8913          	addi	s2,s7,8
 6e8:	4685                	li	a3,1
 6ea:	4629                	li	a2,10
 6ec:	000ba583          	lw	a1,0(s7)
 6f0:	855a                	mv	a0,s6
 6f2:	e91ff0ef          	jal	582 <printint>
 6f6:	8bca                	mv	s7,s2
 6f8:	4981                	li	s3,0
 6fa:	bfad                	j	674 <vprintf+0x4a>
 6fc:	06400793          	li	a5,100
 700:	02f68963          	beq	a3,a5,732 <vprintf+0x108>
 704:	06c00793          	li	a5,108
 708:	04f68263          	beq	a3,a5,74c <vprintf+0x122>
 70c:	07500793          	li	a5,117
 710:	0af68063          	beq	a3,a5,7b0 <vprintf+0x186>
 714:	07800793          	li	a5,120
 718:	0ef68263          	beq	a3,a5,7fc <vprintf+0x1d2>
 71c:	02500593          	li	a1,37
 720:	855a                	mv	a0,s6
 722:	e43ff0ef          	jal	564 <putc>
 726:	85ca                	mv	a1,s2
 728:	855a                	mv	a0,s6
 72a:	e3bff0ef          	jal	564 <putc>
 72e:	4981                	li	s3,0
 730:	b791                	j	674 <vprintf+0x4a>
 732:	008b8913          	addi	s2,s7,8
 736:	4685                	li	a3,1
 738:	4629                	li	a2,10
 73a:	000ba583          	lw	a1,0(s7)
 73e:	855a                	mv	a0,s6
 740:	e43ff0ef          	jal	582 <printint>
 744:	2485                	addiw	s1,s1,1
 746:	8bca                	mv	s7,s2
 748:	4981                	li	s3,0
 74a:	b72d                	j	674 <vprintf+0x4a>
 74c:	06400793          	li	a5,100
 750:	02f60763          	beq	a2,a5,77e <vprintf+0x154>
 754:	07500793          	li	a5,117
 758:	06f60963          	beq	a2,a5,7ca <vprintf+0x1a0>
 75c:	07800793          	li	a5,120
 760:	faf61ee3          	bne	a2,a5,71c <vprintf+0xf2>
 764:	008b8913          	addi	s2,s7,8
 768:	4681                	li	a3,0
 76a:	4641                	li	a2,16
 76c:	000ba583          	lw	a1,0(s7)
 770:	855a                	mv	a0,s6
 772:	e11ff0ef          	jal	582 <printint>
 776:	2489                	addiw	s1,s1,2
 778:	8bca                	mv	s7,s2
 77a:	4981                	li	s3,0
 77c:	bde5                	j	674 <vprintf+0x4a>
 77e:	008b8913          	addi	s2,s7,8
 782:	4685                	li	a3,1
 784:	4629                	li	a2,10
 786:	000ba583          	lw	a1,0(s7)
 78a:	855a                	mv	a0,s6
 78c:	df7ff0ef          	jal	582 <printint>
 790:	2489                	addiw	s1,s1,2
 792:	8bca                	mv	s7,s2
 794:	4981                	li	s3,0
 796:	bdf9                	j	674 <vprintf+0x4a>
 798:	008b8913          	addi	s2,s7,8
 79c:	4681                	li	a3,0
 79e:	4629                	li	a2,10
 7a0:	000ba583          	lw	a1,0(s7)
 7a4:	855a                	mv	a0,s6
 7a6:	dddff0ef          	jal	582 <printint>
 7aa:	8bca                	mv	s7,s2
 7ac:	4981                	li	s3,0
 7ae:	b5d9                	j	674 <vprintf+0x4a>
 7b0:	008b8913          	addi	s2,s7,8
 7b4:	4681                	li	a3,0
 7b6:	4629                	li	a2,10
 7b8:	000ba583          	lw	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	dc5ff0ef          	jal	582 <printint>
 7c2:	2485                	addiw	s1,s1,1
 7c4:	8bca                	mv	s7,s2
 7c6:	4981                	li	s3,0
 7c8:	b575                	j	674 <vprintf+0x4a>
 7ca:	008b8913          	addi	s2,s7,8
 7ce:	4681                	li	a3,0
 7d0:	4629                	li	a2,10
 7d2:	000ba583          	lw	a1,0(s7)
 7d6:	855a                	mv	a0,s6
 7d8:	dabff0ef          	jal	582 <printint>
 7dc:	2489                	addiw	s1,s1,2
 7de:	8bca                	mv	s7,s2
 7e0:	4981                	li	s3,0
 7e2:	bd49                	j	674 <vprintf+0x4a>
 7e4:	008b8913          	addi	s2,s7,8
 7e8:	4681                	li	a3,0
 7ea:	4641                	li	a2,16
 7ec:	000ba583          	lw	a1,0(s7)
 7f0:	855a                	mv	a0,s6
 7f2:	d91ff0ef          	jal	582 <printint>
 7f6:	8bca                	mv	s7,s2
 7f8:	4981                	li	s3,0
 7fa:	bdad                	j	674 <vprintf+0x4a>
 7fc:	008b8913          	addi	s2,s7,8
 800:	4681                	li	a3,0
 802:	4641                	li	a2,16
 804:	000ba583          	lw	a1,0(s7)
 808:	855a                	mv	a0,s6
 80a:	d79ff0ef          	jal	582 <printint>
 80e:	2485                	addiw	s1,s1,1
 810:	8bca                	mv	s7,s2
 812:	4981                	li	s3,0
 814:	b585                	j	674 <vprintf+0x4a>
 816:	e06a                	sd	s10,0(sp)
 818:	008b8d13          	addi	s10,s7,8
 81c:	000bb983          	ld	s3,0(s7)
 820:	03000593          	li	a1,48
 824:	855a                	mv	a0,s6
 826:	d3fff0ef          	jal	564 <putc>
 82a:	07800593          	li	a1,120
 82e:	855a                	mv	a0,s6
 830:	d35ff0ef          	jal	564 <putc>
 834:	4941                	li	s2,16
 836:	00000b97          	auipc	s7,0x0
 83a:	29ab8b93          	addi	s7,s7,666 # ad0 <digits>
 83e:	03c9d793          	srli	a5,s3,0x3c
 842:	97de                	add	a5,a5,s7
 844:	0007c583          	lbu	a1,0(a5)
 848:	855a                	mv	a0,s6
 84a:	d1bff0ef          	jal	564 <putc>
 84e:	0992                	slli	s3,s3,0x4
 850:	397d                	addiw	s2,s2,-1
 852:	fe0916e3          	bnez	s2,83e <vprintf+0x214>
 856:	8bea                	mv	s7,s10
 858:	4981                	li	s3,0
 85a:	6d02                	ld	s10,0(sp)
 85c:	bd21                	j	674 <vprintf+0x4a>
 85e:	008b8993          	addi	s3,s7,8
 862:	000bb903          	ld	s2,0(s7)
 866:	00090f63          	beqz	s2,884 <vprintf+0x25a>
 86a:	00094583          	lbu	a1,0(s2)
 86e:	c195                	beqz	a1,892 <vprintf+0x268>
 870:	855a                	mv	a0,s6
 872:	cf3ff0ef          	jal	564 <putc>
 876:	0905                	addi	s2,s2,1
 878:	00094583          	lbu	a1,0(s2)
 87c:	f9f5                	bnez	a1,870 <vprintf+0x246>
 87e:	8bce                	mv	s7,s3
 880:	4981                	li	s3,0
 882:	bbcd                	j	674 <vprintf+0x4a>
 884:	00000917          	auipc	s2,0x0
 888:	24490913          	addi	s2,s2,580 # ac8 <malloc+0x138>
 88c:	02800593          	li	a1,40
 890:	b7c5                	j	870 <vprintf+0x246>
 892:	8bce                	mv	s7,s3
 894:	4981                	li	s3,0
 896:	bbf9                	j	674 <vprintf+0x4a>
 898:	64a6                	ld	s1,72(sp)
 89a:	79e2                	ld	s3,56(sp)
 89c:	7a42                	ld	s4,48(sp)
 89e:	7aa2                	ld	s5,40(sp)
 8a0:	7b02                	ld	s6,32(sp)
 8a2:	6be2                	ld	s7,24(sp)
 8a4:	6c42                	ld	s8,16(sp)
 8a6:	6ca2                	ld	s9,8(sp)
 8a8:	60e6                	ld	ra,88(sp)
 8aa:	6446                	ld	s0,80(sp)
 8ac:	6906                	ld	s2,64(sp)
 8ae:	6125                	addi	sp,sp,96
 8b0:	8082                	ret

00000000000008b2 <fprintf>:
 8b2:	715d                	addi	sp,sp,-80
 8b4:	ec06                	sd	ra,24(sp)
 8b6:	e822                	sd	s0,16(sp)
 8b8:	1000                	addi	s0,sp,32
 8ba:	e010                	sd	a2,0(s0)
 8bc:	e414                	sd	a3,8(s0)
 8be:	e818                	sd	a4,16(s0)
 8c0:	ec1c                	sd	a5,24(s0)
 8c2:	03043023          	sd	a6,32(s0)
 8c6:	03143423          	sd	a7,40(s0)
 8ca:	fe843423          	sd	s0,-24(s0)
 8ce:	8622                	mv	a2,s0
 8d0:	d5bff0ef          	jal	62a <vprintf>
 8d4:	60e2                	ld	ra,24(sp)
 8d6:	6442                	ld	s0,16(sp)
 8d8:	6161                	addi	sp,sp,80
 8da:	8082                	ret

00000000000008dc <printf>:
 8dc:	711d                	addi	sp,sp,-96
 8de:	ec06                	sd	ra,24(sp)
 8e0:	e822                	sd	s0,16(sp)
 8e2:	1000                	addi	s0,sp,32
 8e4:	e40c                	sd	a1,8(s0)
 8e6:	e810                	sd	a2,16(s0)
 8e8:	ec14                	sd	a3,24(s0)
 8ea:	f018                	sd	a4,32(s0)
 8ec:	f41c                	sd	a5,40(s0)
 8ee:	03043823          	sd	a6,48(s0)
 8f2:	03143c23          	sd	a7,56(s0)
 8f6:	00840613          	addi	a2,s0,8
 8fa:	fec43423          	sd	a2,-24(s0)
 8fe:	85aa                	mv	a1,a0
 900:	4505                	li	a0,1
 902:	d29ff0ef          	jal	62a <vprintf>
 906:	60e2                	ld	ra,24(sp)
 908:	6442                	ld	s0,16(sp)
 90a:	6125                	addi	sp,sp,96
 90c:	8082                	ret

000000000000090e <free>:
 90e:	1141                	addi	sp,sp,-16
 910:	e422                	sd	s0,8(sp)
 912:	0800                	addi	s0,sp,16
 914:	ff050693          	addi	a3,a0,-16
 918:	00000797          	auipc	a5,0x0
 91c:	6e87b783          	ld	a5,1768(a5) # 1000 <freep>
 920:	a02d                	j	94a <free+0x3c>
 922:	4618                	lw	a4,8(a2)
 924:	9f2d                	addw	a4,a4,a1
 926:	fee52c23          	sw	a4,-8(a0)
 92a:	6398                	ld	a4,0(a5)
 92c:	6310                	ld	a2,0(a4)
 92e:	a83d                	j	96c <free+0x5e>
 930:	ff852703          	lw	a4,-8(a0)
 934:	9f31                	addw	a4,a4,a2
 936:	c798                	sw	a4,8(a5)
 938:	ff053683          	ld	a3,-16(a0)
 93c:	a091                	j	980 <free+0x72>
 93e:	6398                	ld	a4,0(a5)
 940:	00e7e463          	bltu	a5,a4,948 <free+0x3a>
 944:	00e6ea63          	bltu	a3,a4,958 <free+0x4a>
 948:	87ba                	mv	a5,a4
 94a:	fed7fae3          	bgeu	a5,a3,93e <free+0x30>
 94e:	6398                	ld	a4,0(a5)
 950:	00e6e463          	bltu	a3,a4,958 <free+0x4a>
 954:	fee7eae3          	bltu	a5,a4,948 <free+0x3a>
 958:	ff852583          	lw	a1,-8(a0)
 95c:	6390                	ld	a2,0(a5)
 95e:	02059813          	slli	a6,a1,0x20
 962:	01c85713          	srli	a4,a6,0x1c
 966:	9736                	add	a4,a4,a3
 968:	fae60de3          	beq	a2,a4,922 <free+0x14>
 96c:	fec53823          	sd	a2,-16(a0)
 970:	4790                	lw	a2,8(a5)
 972:	02061593          	slli	a1,a2,0x20
 976:	01c5d713          	srli	a4,a1,0x1c
 97a:	973e                	add	a4,a4,a5
 97c:	fae68ae3          	beq	a3,a4,930 <free+0x22>
 980:	e394                	sd	a3,0(a5)
 982:	00000717          	auipc	a4,0x0
 986:	66f73f23          	sd	a5,1662(a4) # 1000 <freep>
 98a:	6422                	ld	s0,8(sp)
 98c:	0141                	addi	sp,sp,16
 98e:	8082                	ret

0000000000000990 <malloc>:
 990:	7139                	addi	sp,sp,-64
 992:	fc06                	sd	ra,56(sp)
 994:	f822                	sd	s0,48(sp)
 996:	f426                	sd	s1,40(sp)
 998:	ec4e                	sd	s3,24(sp)
 99a:	0080                	addi	s0,sp,64
 99c:	02051493          	slli	s1,a0,0x20
 9a0:	9081                	srli	s1,s1,0x20
 9a2:	04bd                	addi	s1,s1,15
 9a4:	8091                	srli	s1,s1,0x4
 9a6:	0014899b          	addiw	s3,s1,1
 9aa:	0485                	addi	s1,s1,1
 9ac:	00000517          	auipc	a0,0x0
 9b0:	65453503          	ld	a0,1620(a0) # 1000 <freep>
 9b4:	c915                	beqz	a0,9e8 <malloc+0x58>
 9b6:	611c                	ld	a5,0(a0)
 9b8:	4798                	lw	a4,8(a5)
 9ba:	08977a63          	bgeu	a4,s1,a4e <malloc+0xbe>
 9be:	f04a                	sd	s2,32(sp)
 9c0:	e852                	sd	s4,16(sp)
 9c2:	e456                	sd	s5,8(sp)
 9c4:	e05a                	sd	s6,0(sp)
 9c6:	8a4e                	mv	s4,s3
 9c8:	0009871b          	sext.w	a4,s3
 9cc:	6685                	lui	a3,0x1
 9ce:	00d77363          	bgeu	a4,a3,9d4 <malloc+0x44>
 9d2:	6a05                	lui	s4,0x1
 9d4:	000a0b1b          	sext.w	s6,s4
 9d8:	004a1a1b          	slliw	s4,s4,0x4
 9dc:	00000917          	auipc	s2,0x0
 9e0:	62490913          	addi	s2,s2,1572 # 1000 <freep>
 9e4:	5afd                	li	s5,-1
 9e6:	a081                	j	a26 <malloc+0x96>
 9e8:	f04a                	sd	s2,32(sp)
 9ea:	e852                	sd	s4,16(sp)
 9ec:	e456                	sd	s5,8(sp)
 9ee:	e05a                	sd	s6,0(sp)
 9f0:	00001797          	auipc	a5,0x1
 9f4:	a2078793          	addi	a5,a5,-1504 # 1410 <base>
 9f8:	00000717          	auipc	a4,0x0
 9fc:	60f73423          	sd	a5,1544(a4) # 1000 <freep>
 a00:	e39c                	sd	a5,0(a5)
 a02:	0007a423          	sw	zero,8(a5)
 a06:	b7c1                	j	9c6 <malloc+0x36>
 a08:	6398                	ld	a4,0(a5)
 a0a:	e118                	sd	a4,0(a0)
 a0c:	a8a9                	j	a66 <malloc+0xd6>
 a0e:	01652423          	sw	s6,8(a0)
 a12:	0541                	addi	a0,a0,16
 a14:	efbff0ef          	jal	90e <free>
 a18:	00093503          	ld	a0,0(s2)
 a1c:	c12d                	beqz	a0,a7e <malloc+0xee>
 a1e:	611c                	ld	a5,0(a0)
 a20:	4798                	lw	a4,8(a5)
 a22:	02977263          	bgeu	a4,s1,a46 <malloc+0xb6>
 a26:	00093703          	ld	a4,0(s2)
 a2a:	853e                	mv	a0,a5
 a2c:	fef719e3          	bne	a4,a5,a1e <malloc+0x8e>
 a30:	8552                	mv	a0,s4
 a32:	b1bff0ef          	jal	54c <sbrk>
 a36:	fd551ce3          	bne	a0,s5,a0e <malloc+0x7e>
 a3a:	4501                	li	a0,0
 a3c:	7902                	ld	s2,32(sp)
 a3e:	6a42                	ld	s4,16(sp)
 a40:	6aa2                	ld	s5,8(sp)
 a42:	6b02                	ld	s6,0(sp)
 a44:	a03d                	j	a72 <malloc+0xe2>
 a46:	7902                	ld	s2,32(sp)
 a48:	6a42                	ld	s4,16(sp)
 a4a:	6aa2                	ld	s5,8(sp)
 a4c:	6b02                	ld	s6,0(sp)
 a4e:	fae48de3          	beq	s1,a4,a08 <malloc+0x78>
 a52:	4137073b          	subw	a4,a4,s3
 a56:	c798                	sw	a4,8(a5)
 a58:	02071693          	slli	a3,a4,0x20
 a5c:	01c6d713          	srli	a4,a3,0x1c
 a60:	97ba                	add	a5,a5,a4
 a62:	0137a423          	sw	s3,8(a5)
 a66:	00000717          	auipc	a4,0x0
 a6a:	58a73d23          	sd	a0,1434(a4) # 1000 <freep>
 a6e:	01078513          	addi	a0,a5,16
 a72:	70e2                	ld	ra,56(sp)
 a74:	7442                	ld	s0,48(sp)
 a76:	74a2                	ld	s1,40(sp)
 a78:	69e2                	ld	s3,24(sp)
 a7a:	6121                	addi	sp,sp,64
 a7c:	8082                	ret
 a7e:	7902                	ld	s2,32(sp)
 a80:	6a42                	ld	s4,16(sp)
 a82:	6aa2                	ld	s5,8(sp)
 a84:	6b02                	ld	s6,0(sp)
 a86:	b7f5                	j	a72 <malloc+0xe2>
