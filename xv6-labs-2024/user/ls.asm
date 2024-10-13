
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
   c:	2b6000ef          	jal	2c2 <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
  2e:	00178493          	addi	s1,a5,1
  32:	8526                	mv	a0,s1
  34:	28e000ef          	jal	2c2 <strlen>
  38:	2501                	sext.w	a0,a0
  3a:	47b5                	li	a5,13
  3c:	00a7f863          	bgeu	a5,a0,4c <fmtname+0x4c>
  40:	8526                	mv	a0,s1
  42:	70a2                	ld	ra,40(sp)
  44:	7402                	ld	s0,32(sp)
  46:	64e2                	ld	s1,24(sp)
  48:	6145                	addi	sp,sp,48
  4a:	8082                	ret
  4c:	e84a                	sd	s2,16(sp)
  4e:	e44e                	sd	s3,8(sp)
  50:	8526                	mv	a0,s1
  52:	270000ef          	jal	2c2 <strlen>
  56:	00001997          	auipc	s3,0x1
  5a:	fba98993          	addi	s3,s3,-70 # 1010 <buf.0>
  5e:	0005061b          	sext.w	a2,a0
  62:	85a6                	mv	a1,s1
  64:	854e                	mv	a0,s3
  66:	3be000ef          	jal	424 <memmove>
  6a:	8526                	mv	a0,s1
  6c:	256000ef          	jal	2c2 <strlen>
  70:	0005091b          	sext.w	s2,a0
  74:	8526                	mv	a0,s1
  76:	24c000ef          	jal	2c2 <strlen>
  7a:	1902                	slli	s2,s2,0x20
  7c:	02095913          	srli	s2,s2,0x20
  80:	4639                	li	a2,14
  82:	9e09                	subw	a2,a2,a0
  84:	02000593          	li	a1,32
  88:	01298533          	add	a0,s3,s2
  8c:	260000ef          	jal	2ec <memset>
  90:	84ce                	mv	s1,s3
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	b76d                	j	40 <fmtname+0x40>

0000000000000098 <ls>:
  98:	d9010113          	addi	sp,sp,-624
  9c:	26113423          	sd	ra,616(sp)
  a0:	26813023          	sd	s0,608(sp)
  a4:	25213823          	sd	s2,592(sp)
  a8:	1c80                	addi	s0,sp,624
  aa:	892a                	mv	s2,a0
  ac:	4581                	li	a1,0
  ae:	464000ef          	jal	512 <open>
  b2:	06054363          	bltz	a0,118 <ls+0x80>
  b6:	24913c23          	sd	s1,600(sp)
  ba:	84aa                	mv	s1,a0
  bc:	d9840593          	addi	a1,s0,-616
  c0:	46a000ef          	jal	52a <fstat>
  c4:	06054363          	bltz	a0,12a <ls+0x92>
  c8:	da041783          	lh	a5,-608(s0)
  cc:	4705                	li	a4,1
  ce:	06e78c63          	beq	a5,a4,146 <ls+0xae>
  d2:	37f9                	addiw	a5,a5,-2
  d4:	17c2                	slli	a5,a5,0x30
  d6:	93c1                	srli	a5,a5,0x30
  d8:	02f76263          	bltu	a4,a5,fc <ls+0x64>
  dc:	854a                	mv	a0,s2
  de:	f23ff0ef          	jal	0 <fmtname>
  e2:	85aa                	mv	a1,a0
  e4:	da842703          	lw	a4,-600(s0)
  e8:	d9c42683          	lw	a3,-612(s0)
  ec:	da041603          	lh	a2,-608(s0)
  f0:	00001517          	auipc	a0,0x1
  f4:	9e050513          	addi	a0,a0,-1568 # ad0 <malloc+0x132>
  f8:	7f2000ef          	jal	8ea <printf>
  fc:	8526                	mv	a0,s1
  fe:	3fc000ef          	jal	4fa <close>
 102:	25813483          	ld	s1,600(sp)
 106:	26813083          	ld	ra,616(sp)
 10a:	26013403          	ld	s0,608(sp)
 10e:	25013903          	ld	s2,592(sp)
 112:	27010113          	addi	sp,sp,624
 116:	8082                	ret
 118:	864a                	mv	a2,s2
 11a:	00001597          	auipc	a1,0x1
 11e:	98658593          	addi	a1,a1,-1658 # aa0 <malloc+0x102>
 122:	4509                	li	a0,2
 124:	79c000ef          	jal	8c0 <fprintf>
 128:	bff9                	j	106 <ls+0x6e>
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	98c58593          	addi	a1,a1,-1652 # ab8 <malloc+0x11a>
 134:	4509                	li	a0,2
 136:	78a000ef          	jal	8c0 <fprintf>
 13a:	8526                	mv	a0,s1
 13c:	3be000ef          	jal	4fa <close>
 140:	25813483          	ld	s1,600(sp)
 144:	b7c9                	j	106 <ls+0x6e>
 146:	854a                	mv	a0,s2
 148:	17a000ef          	jal	2c2 <strlen>
 14c:	2541                	addiw	a0,a0,16
 14e:	20000793          	li	a5,512
 152:	00a7f963          	bgeu	a5,a0,164 <ls+0xcc>
 156:	00001517          	auipc	a0,0x1
 15a:	98a50513          	addi	a0,a0,-1654 # ae0 <malloc+0x142>
 15e:	78c000ef          	jal	8ea <printf>
 162:	bf69                	j	fc <ls+0x64>
 164:	25313423          	sd	s3,584(sp)
 168:	25413023          	sd	s4,576(sp)
 16c:	23513c23          	sd	s5,568(sp)
 170:	85ca                	mv	a1,s2
 172:	dc040513          	addi	a0,s0,-576
 176:	104000ef          	jal	27a <strcpy>
 17a:	dc040513          	addi	a0,s0,-576
 17e:	144000ef          	jal	2c2 <strlen>
 182:	1502                	slli	a0,a0,0x20
 184:	9101                	srli	a0,a0,0x20
 186:	dc040793          	addi	a5,s0,-576
 18a:	00a78933          	add	s2,a5,a0
 18e:	00190993          	addi	s3,s2,1
 192:	02f00793          	li	a5,47
 196:	00f90023          	sb	a5,0(s2)
 19a:	00001a17          	auipc	s4,0x1
 19e:	936a0a13          	addi	s4,s4,-1738 # ad0 <malloc+0x132>
 1a2:	00001a97          	auipc	s5,0x1
 1a6:	916a8a93          	addi	s5,s5,-1770 # ab8 <malloc+0x11a>
 1aa:	a031                	j	1b6 <ls+0x11e>
 1ac:	dc040593          	addi	a1,s0,-576
 1b0:	8556                	mv	a0,s5
 1b2:	738000ef          	jal	8ea <printf>
 1b6:	4641                	li	a2,16
 1b8:	db040593          	addi	a1,s0,-592
 1bc:	8526                	mv	a0,s1
 1be:	32c000ef          	jal	4ea <read>
 1c2:	47c1                	li	a5,16
 1c4:	04f51463          	bne	a0,a5,20c <ls+0x174>
 1c8:	db045783          	lhu	a5,-592(s0)
 1cc:	d7ed                	beqz	a5,1b6 <ls+0x11e>
 1ce:	4639                	li	a2,14
 1d0:	db240593          	addi	a1,s0,-590
 1d4:	854e                	mv	a0,s3
 1d6:	24e000ef          	jal	424 <memmove>
 1da:	000907a3          	sb	zero,15(s2)
 1de:	d9840593          	addi	a1,s0,-616
 1e2:	dc040513          	addi	a0,s0,-576
 1e6:	1bc000ef          	jal	3a2 <stat>
 1ea:	fc0541e3          	bltz	a0,1ac <ls+0x114>
 1ee:	dc040513          	addi	a0,s0,-576
 1f2:	e0fff0ef          	jal	0 <fmtname>
 1f6:	85aa                	mv	a1,a0
 1f8:	da842703          	lw	a4,-600(s0)
 1fc:	d9c42683          	lw	a3,-612(s0)
 200:	da041603          	lh	a2,-608(s0)
 204:	8552                	mv	a0,s4
 206:	6e4000ef          	jal	8ea <printf>
 20a:	b775                	j	1b6 <ls+0x11e>
 20c:	24813983          	ld	s3,584(sp)
 210:	24013a03          	ld	s4,576(sp)
 214:	23813a83          	ld	s5,568(sp)
 218:	b5d5                	j	fc <ls+0x64>

000000000000021a <main>:
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	1000                	addi	s0,sp,32
 222:	4785                	li	a5,1
 224:	02a7d763          	bge	a5,a0,252 <main+0x38>
 228:	e426                	sd	s1,8(sp)
 22a:	e04a                	sd	s2,0(sp)
 22c:	00858493          	addi	s1,a1,8
 230:	ffe5091b          	addiw	s2,a0,-2
 234:	02091793          	slli	a5,s2,0x20
 238:	01d7d913          	srli	s2,a5,0x1d
 23c:	05c1                	addi	a1,a1,16
 23e:	992e                	add	s2,s2,a1
 240:	6088                	ld	a0,0(s1)
 242:	e57ff0ef          	jal	98 <ls>
 246:	04a1                	addi	s1,s1,8
 248:	ff249ce3          	bne	s1,s2,240 <main+0x26>
 24c:	4501                	li	a0,0
 24e:	284000ef          	jal	4d2 <exit>
 252:	e426                	sd	s1,8(sp)
 254:	e04a                	sd	s2,0(sp)
 256:	00001517          	auipc	a0,0x1
 25a:	8a250513          	addi	a0,a0,-1886 # af8 <malloc+0x15a>
 25e:	e3bff0ef          	jal	98 <ls>
 262:	4501                	li	a0,0
 264:	26e000ef          	jal	4d2 <exit>

0000000000000268 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 270:	fabff0ef          	jal	21a <main>
  exit(0);
 274:	4501                	li	a0,0
 276:	25c000ef          	jal	4d2 <exit>

000000000000027a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 280:	87aa                	mv	a5,a0
 282:	0585                	addi	a1,a1,1
 284:	0785                	addi	a5,a5,1
 286:	fff5c703          	lbu	a4,-1(a1)
 28a:	fee78fa3          	sb	a4,-1(a5)
 28e:	fb75                	bnez	a4,282 <strcpy+0x8>
    ;
  return os;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	cb91                	beqz	a5,2b4 <strcmp+0x1e>
 2a2:	0005c703          	lbu	a4,0(a1)
 2a6:	00f71763          	bne	a4,a5,2b4 <strcmp+0x1e>
    p++, q++;
 2aa:	0505                	addi	a0,a0,1
 2ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	fbe5                	bnez	a5,2a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b4:	0005c503          	lbu	a0,0(a1)
}
 2b8:	40a7853b          	subw	a0,a5,a0
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strlen>:

uint
strlen(const char *s)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	cf91                	beqz	a5,2e8 <strlen+0x26>
 2ce:	0505                	addi	a0,a0,1
 2d0:	87aa                	mv	a5,a0
 2d2:	86be                	mv	a3,a5
 2d4:	0785                	addi	a5,a5,1
 2d6:	fff7c703          	lbu	a4,-1(a5)
 2da:	ff65                	bnez	a4,2d2 <strlen+0x10>
 2dc:	40a6853b          	subw	a0,a3,a0
 2e0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
  for(n = 0; s[n]; n++)
 2e8:	4501                	li	a0,0
 2ea:	bfe5                	j	2e2 <strlen+0x20>

00000000000002ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f2:	ca19                	beqz	a2,308 <memset+0x1c>
 2f4:	87aa                	mv	a5,a0
 2f6:	1602                	slli	a2,a2,0x20
 2f8:	9201                	srli	a2,a2,0x20
 2fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 302:	0785                	addi	a5,a5,1
 304:	fee79de3          	bne	a5,a4,2fe <memset+0x12>
  }
  return dst;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <strchr>:

char*
strchr(const char *s, char c)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	addi	s0,sp,16
  for(; *s; s++)
 314:	00054783          	lbu	a5,0(a0)
 318:	cb99                	beqz	a5,32e <strchr+0x20>
    if(*s == c)
 31a:	00f58763          	beq	a1,a5,328 <strchr+0x1a>
  for(; *s; s++)
 31e:	0505                	addi	a0,a0,1
 320:	00054783          	lbu	a5,0(a0)
 324:	fbfd                	bnez	a5,31a <strchr+0xc>
      return (char*)s;
  return 0;
 326:	4501                	li	a0,0
}
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
  return 0;
 32e:	4501                	li	a0,0
 330:	bfe5                	j	328 <strchr+0x1a>

0000000000000332 <gets>:

char*
gets(char *buf, int max)
{
 332:	711d                	addi	sp,sp,-96
 334:	ec86                	sd	ra,88(sp)
 336:	e8a2                	sd	s0,80(sp)
 338:	e4a6                	sd	s1,72(sp)
 33a:	e0ca                	sd	s2,64(sp)
 33c:	fc4e                	sd	s3,56(sp)
 33e:	f852                	sd	s4,48(sp)
 340:	f456                	sd	s5,40(sp)
 342:	f05a                	sd	s6,32(sp)
 344:	ec5e                	sd	s7,24(sp)
 346:	1080                	addi	s0,sp,96
 348:	8baa                	mv	s7,a0
 34a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34c:	892a                	mv	s2,a0
 34e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 350:	4aa9                	li	s5,10
 352:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 354:	89a6                	mv	s3,s1
 356:	2485                	addiw	s1,s1,1
 358:	0344d663          	bge	s1,s4,384 <gets+0x52>
    cc = read(0, &c, 1);
 35c:	4605                	li	a2,1
 35e:	faf40593          	addi	a1,s0,-81
 362:	4501                	li	a0,0
 364:	186000ef          	jal	4ea <read>
    if(cc < 1)
 368:	00a05e63          	blez	a0,384 <gets+0x52>
    buf[i++] = c;
 36c:	faf44783          	lbu	a5,-81(s0)
 370:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 374:	01578763          	beq	a5,s5,382 <gets+0x50>
 378:	0905                	addi	s2,s2,1
 37a:	fd679de3          	bne	a5,s6,354 <gets+0x22>
    buf[i++] = c;
 37e:	89a6                	mv	s3,s1
 380:	a011                	j	384 <gets+0x52>
 382:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 384:	99de                	add	s3,s3,s7
 386:	00098023          	sb	zero,0(s3)
  return buf;
}
 38a:	855e                	mv	a0,s7
 38c:	60e6                	ld	ra,88(sp)
 38e:	6446                	ld	s0,80(sp)
 390:	64a6                	ld	s1,72(sp)
 392:	6906                	ld	s2,64(sp)
 394:	79e2                	ld	s3,56(sp)
 396:	7a42                	ld	s4,48(sp)
 398:	7aa2                	ld	s5,40(sp)
 39a:	7b02                	ld	s6,32(sp)
 39c:	6be2                	ld	s7,24(sp)
 39e:	6125                	addi	sp,sp,96
 3a0:	8082                	ret

00000000000003a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a2:	1101                	addi	sp,sp,-32
 3a4:	ec06                	sd	ra,24(sp)
 3a6:	e822                	sd	s0,16(sp)
 3a8:	e04a                	sd	s2,0(sp)
 3aa:	1000                	addi	s0,sp,32
 3ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ae:	4581                	li	a1,0
 3b0:	162000ef          	jal	512 <open>
  if(fd < 0)
 3b4:	02054263          	bltz	a0,3d8 <stat+0x36>
 3b8:	e426                	sd	s1,8(sp)
 3ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3bc:	85ca                	mv	a1,s2
 3be:	16c000ef          	jal	52a <fstat>
 3c2:	892a                	mv	s2,a0
  close(fd);
 3c4:	8526                	mv	a0,s1
 3c6:	134000ef          	jal	4fa <close>
  return r;
 3ca:	64a2                	ld	s1,8(sp)
}
 3cc:	854a                	mv	a0,s2
 3ce:	60e2                	ld	ra,24(sp)
 3d0:	6442                	ld	s0,16(sp)
 3d2:	6902                	ld	s2,0(sp)
 3d4:	6105                	addi	sp,sp,32
 3d6:	8082                	ret
    return -1;
 3d8:	597d                	li	s2,-1
 3da:	bfcd                	j	3cc <stat+0x2a>

00000000000003dc <atoi>:

int
atoi(const char *s)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e2:	00054683          	lbu	a3,0(a0)
 3e6:	fd06879b          	addiw	a5,a3,-48
 3ea:	0ff7f793          	zext.b	a5,a5
 3ee:	4625                	li	a2,9
 3f0:	02f66863          	bltu	a2,a5,420 <atoi+0x44>
 3f4:	872a                	mv	a4,a0
  n = 0;
 3f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3f8:	0705                	addi	a4,a4,1
 3fa:	0025179b          	slliw	a5,a0,0x2
 3fe:	9fa9                	addw	a5,a5,a0
 400:	0017979b          	slliw	a5,a5,0x1
 404:	9fb5                	addw	a5,a5,a3
 406:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 40a:	00074683          	lbu	a3,0(a4)
 40e:	fd06879b          	addiw	a5,a3,-48
 412:	0ff7f793          	zext.b	a5,a5
 416:	fef671e3          	bgeu	a2,a5,3f8 <atoi+0x1c>
  return n;
}
 41a:	6422                	ld	s0,8(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret
  n = 0;
 420:	4501                	li	a0,0
 422:	bfe5                	j	41a <atoi+0x3e>

0000000000000424 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 424:	1141                	addi	sp,sp,-16
 426:	e422                	sd	s0,8(sp)
 428:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 42a:	02b57463          	bgeu	a0,a1,452 <memmove+0x2e>
    while(n-- > 0)
 42e:	00c05f63          	blez	a2,44c <memmove+0x28>
 432:	1602                	slli	a2,a2,0x20
 434:	9201                	srli	a2,a2,0x20
 436:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 43a:	872a                	mv	a4,a0
      *dst++ = *src++;
 43c:	0585                	addi	a1,a1,1
 43e:	0705                	addi	a4,a4,1
 440:	fff5c683          	lbu	a3,-1(a1)
 444:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 448:	fef71ae3          	bne	a4,a5,43c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44c:	6422                	ld	s0,8(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret
    dst += n;
 452:	00c50733          	add	a4,a0,a2
    src += n;
 456:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 458:	fec05ae3          	blez	a2,44c <memmove+0x28>
 45c:	fff6079b          	addiw	a5,a2,-1
 460:	1782                	slli	a5,a5,0x20
 462:	9381                	srli	a5,a5,0x20
 464:	fff7c793          	not	a5,a5
 468:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 46a:	15fd                	addi	a1,a1,-1
 46c:	177d                	addi	a4,a4,-1
 46e:	0005c683          	lbu	a3,0(a1)
 472:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 476:	fee79ae3          	bne	a5,a4,46a <memmove+0x46>
 47a:	bfc9                	j	44c <memmove+0x28>

000000000000047c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 47c:	1141                	addi	sp,sp,-16
 47e:	e422                	sd	s0,8(sp)
 480:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 482:	ca05                	beqz	a2,4b2 <memcmp+0x36>
 484:	fff6069b          	addiw	a3,a2,-1
 488:	1682                	slli	a3,a3,0x20
 48a:	9281                	srli	a3,a3,0x20
 48c:	0685                	addi	a3,a3,1
 48e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 490:	00054783          	lbu	a5,0(a0)
 494:	0005c703          	lbu	a4,0(a1)
 498:	00e79863          	bne	a5,a4,4a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 49c:	0505                	addi	a0,a0,1
    p2++;
 49e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a0:	fed518e3          	bne	a0,a3,490 <memcmp+0x14>
  }
  return 0;
 4a4:	4501                	li	a0,0
 4a6:	a019                	j	4ac <memcmp+0x30>
      return *p1 - *p2;
 4a8:	40e7853b          	subw	a0,a5,a4
}
 4ac:	6422                	ld	s0,8(sp)
 4ae:	0141                	addi	sp,sp,16
 4b0:	8082                	ret
  return 0;
 4b2:	4501                	li	a0,0
 4b4:	bfe5                	j	4ac <memcmp+0x30>

00000000000004b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b6:	1141                	addi	sp,sp,-16
 4b8:	e406                	sd	ra,8(sp)
 4ba:	e022                	sd	s0,0(sp)
 4bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4be:	f67ff0ef          	jal	424 <memmove>
}
 4c2:	60a2                	ld	ra,8(sp)
 4c4:	6402                	ld	s0,0(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret

00000000000004ca <fork>:
 4ca:	4885                	li	a7,1
 4cc:	00000073          	ecall
 4d0:	8082                	ret

00000000000004d2 <exit>:
 4d2:	4889                	li	a7,2
 4d4:	00000073          	ecall
 4d8:	8082                	ret

00000000000004da <wait>:
 4da:	488d                	li	a7,3
 4dc:	00000073          	ecall
 4e0:	8082                	ret

00000000000004e2 <pipe>:
 4e2:	4891                	li	a7,4
 4e4:	00000073          	ecall
 4e8:	8082                	ret

00000000000004ea <read>:
 4ea:	4895                	li	a7,5
 4ec:	00000073          	ecall
 4f0:	8082                	ret

00000000000004f2 <write>:
 4f2:	48c1                	li	a7,16
 4f4:	00000073          	ecall
 4f8:	8082                	ret

00000000000004fa <close>:
 4fa:	48d5                	li	a7,21
 4fc:	00000073          	ecall
 500:	8082                	ret

0000000000000502 <kill>:
 502:	4899                	li	a7,6
 504:	00000073          	ecall
 508:	8082                	ret

000000000000050a <exec>:
 50a:	489d                	li	a7,7
 50c:	00000073          	ecall
 510:	8082                	ret

0000000000000512 <open>:
 512:	48bd                	li	a7,15
 514:	00000073          	ecall
 518:	8082                	ret

000000000000051a <mknod>:
 51a:	48c5                	li	a7,17
 51c:	00000073          	ecall
 520:	8082                	ret

0000000000000522 <unlink>:
 522:	48c9                	li	a7,18
 524:	00000073          	ecall
 528:	8082                	ret

000000000000052a <fstat>:
 52a:	48a1                	li	a7,8
 52c:	00000073          	ecall
 530:	8082                	ret

0000000000000532 <link>:
 532:	48cd                	li	a7,19
 534:	00000073          	ecall
 538:	8082                	ret

000000000000053a <mkdir>:
 53a:	48d1                	li	a7,20
 53c:	00000073          	ecall
 540:	8082                	ret

0000000000000542 <chdir>:
 542:	48a5                	li	a7,9
 544:	00000073          	ecall
 548:	8082                	ret

000000000000054a <dup>:
 54a:	48a9                	li	a7,10
 54c:	00000073          	ecall
 550:	8082                	ret

0000000000000552 <getpid>:
 552:	48ad                	li	a7,11
 554:	00000073          	ecall
 558:	8082                	ret

000000000000055a <sbrk>:
 55a:	48b1                	li	a7,12
 55c:	00000073          	ecall
 560:	8082                	ret

0000000000000562 <sleep>:
 562:	48b5                	li	a7,13
 564:	00000073          	ecall
 568:	8082                	ret

000000000000056a <uptime>:
 56a:	48b9                	li	a7,14
 56c:	00000073          	ecall
 570:	8082                	ret

0000000000000572 <putc>:
 572:	1101                	addi	sp,sp,-32
 574:	ec06                	sd	ra,24(sp)
 576:	e822                	sd	s0,16(sp)
 578:	1000                	addi	s0,sp,32
 57a:	feb407a3          	sb	a1,-17(s0)
 57e:	4605                	li	a2,1
 580:	fef40593          	addi	a1,s0,-17
 584:	f6fff0ef          	jal	4f2 <write>
 588:	60e2                	ld	ra,24(sp)
 58a:	6442                	ld	s0,16(sp)
 58c:	6105                	addi	sp,sp,32
 58e:	8082                	ret

0000000000000590 <printint>:
 590:	7139                	addi	sp,sp,-64
 592:	fc06                	sd	ra,56(sp)
 594:	f822                	sd	s0,48(sp)
 596:	f426                	sd	s1,40(sp)
 598:	0080                	addi	s0,sp,64
 59a:	84aa                	mv	s1,a0
 59c:	c299                	beqz	a3,5a2 <printint+0x12>
 59e:	0805c963          	bltz	a1,630 <printint+0xa0>
 5a2:	2581                	sext.w	a1,a1
 5a4:	4881                	li	a7,0
 5a6:	fc040693          	addi	a3,s0,-64
 5aa:	4701                	li	a4,0
 5ac:	2601                	sext.w	a2,a2
 5ae:	00000517          	auipc	a0,0x0
 5b2:	55a50513          	addi	a0,a0,1370 # b08 <digits>
 5b6:	883a                	mv	a6,a4
 5b8:	2705                	addiw	a4,a4,1
 5ba:	02c5f7bb          	remuw	a5,a1,a2
 5be:	1782                	slli	a5,a5,0x20
 5c0:	9381                	srli	a5,a5,0x20
 5c2:	97aa                	add	a5,a5,a0
 5c4:	0007c783          	lbu	a5,0(a5)
 5c8:	00f68023          	sb	a5,0(a3)
 5cc:	0005879b          	sext.w	a5,a1
 5d0:	02c5d5bb          	divuw	a1,a1,a2
 5d4:	0685                	addi	a3,a3,1
 5d6:	fec7f0e3          	bgeu	a5,a2,5b6 <printint+0x26>
 5da:	00088c63          	beqz	a7,5f2 <printint+0x62>
 5de:	fd070793          	addi	a5,a4,-48
 5e2:	00878733          	add	a4,a5,s0
 5e6:	02d00793          	li	a5,45
 5ea:	fef70823          	sb	a5,-16(a4)
 5ee:	0028071b          	addiw	a4,a6,2
 5f2:	02e05a63          	blez	a4,626 <printint+0x96>
 5f6:	f04a                	sd	s2,32(sp)
 5f8:	ec4e                	sd	s3,24(sp)
 5fa:	fc040793          	addi	a5,s0,-64
 5fe:	00e78933          	add	s2,a5,a4
 602:	fff78993          	addi	s3,a5,-1
 606:	99ba                	add	s3,s3,a4
 608:	377d                	addiw	a4,a4,-1
 60a:	1702                	slli	a4,a4,0x20
 60c:	9301                	srli	a4,a4,0x20
 60e:	40e989b3          	sub	s3,s3,a4
 612:	fff94583          	lbu	a1,-1(s2)
 616:	8526                	mv	a0,s1
 618:	f5bff0ef          	jal	572 <putc>
 61c:	197d                	addi	s2,s2,-1
 61e:	ff391ae3          	bne	s2,s3,612 <printint+0x82>
 622:	7902                	ld	s2,32(sp)
 624:	69e2                	ld	s3,24(sp)
 626:	70e2                	ld	ra,56(sp)
 628:	7442                	ld	s0,48(sp)
 62a:	74a2                	ld	s1,40(sp)
 62c:	6121                	addi	sp,sp,64
 62e:	8082                	ret
 630:	40b005bb          	negw	a1,a1
 634:	4885                	li	a7,1
 636:	bf85                	j	5a6 <printint+0x16>

0000000000000638 <vprintf>:
 638:	711d                	addi	sp,sp,-96
 63a:	ec86                	sd	ra,88(sp)
 63c:	e8a2                	sd	s0,80(sp)
 63e:	e0ca                	sd	s2,64(sp)
 640:	1080                	addi	s0,sp,96
 642:	0005c903          	lbu	s2,0(a1)
 646:	26090863          	beqz	s2,8b6 <vprintf+0x27e>
 64a:	e4a6                	sd	s1,72(sp)
 64c:	fc4e                	sd	s3,56(sp)
 64e:	f852                	sd	s4,48(sp)
 650:	f456                	sd	s5,40(sp)
 652:	f05a                	sd	s6,32(sp)
 654:	ec5e                	sd	s7,24(sp)
 656:	e862                	sd	s8,16(sp)
 658:	e466                	sd	s9,8(sp)
 65a:	8b2a                	mv	s6,a0
 65c:	8a2e                	mv	s4,a1
 65e:	8bb2                	mv	s7,a2
 660:	4981                	li	s3,0
 662:	4481                	li	s1,0
 664:	4701                	li	a4,0
 666:	02500a93          	li	s5,37
 66a:	06400c13          	li	s8,100
 66e:	06c00c93          	li	s9,108
 672:	a005                	j	692 <vprintf+0x5a>
 674:	85ca                	mv	a1,s2
 676:	855a                	mv	a0,s6
 678:	efbff0ef          	jal	572 <putc>
 67c:	a019                	j	682 <vprintf+0x4a>
 67e:	03598263          	beq	s3,s5,6a2 <vprintf+0x6a>
 682:	2485                	addiw	s1,s1,1
 684:	8726                	mv	a4,s1
 686:	009a07b3          	add	a5,s4,s1
 68a:	0007c903          	lbu	s2,0(a5)
 68e:	20090c63          	beqz	s2,8a6 <vprintf+0x26e>
 692:	0009079b          	sext.w	a5,s2
 696:	fe0994e3          	bnez	s3,67e <vprintf+0x46>
 69a:	fd579de3          	bne	a5,s5,674 <vprintf+0x3c>
 69e:	89be                	mv	s3,a5
 6a0:	b7cd                	j	682 <vprintf+0x4a>
 6a2:	00ea06b3          	add	a3,s4,a4
 6a6:	0016c683          	lbu	a3,1(a3)
 6aa:	8636                	mv	a2,a3
 6ac:	c681                	beqz	a3,6b4 <vprintf+0x7c>
 6ae:	9752                	add	a4,a4,s4
 6b0:	00274603          	lbu	a2,2(a4)
 6b4:	03878f63          	beq	a5,s8,6f2 <vprintf+0xba>
 6b8:	05978963          	beq	a5,s9,70a <vprintf+0xd2>
 6bc:	07500713          	li	a4,117
 6c0:	0ee78363          	beq	a5,a4,7a6 <vprintf+0x16e>
 6c4:	07800713          	li	a4,120
 6c8:	12e78563          	beq	a5,a4,7f2 <vprintf+0x1ba>
 6cc:	07000713          	li	a4,112
 6d0:	14e78a63          	beq	a5,a4,824 <vprintf+0x1ec>
 6d4:	07300713          	li	a4,115
 6d8:	18e78a63          	beq	a5,a4,86c <vprintf+0x234>
 6dc:	02500713          	li	a4,37
 6e0:	04e79563          	bne	a5,a4,72a <vprintf+0xf2>
 6e4:	02500593          	li	a1,37
 6e8:	855a                	mv	a0,s6
 6ea:	e89ff0ef          	jal	572 <putc>
 6ee:	4981                	li	s3,0
 6f0:	bf49                	j	682 <vprintf+0x4a>
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4685                	li	a3,1
 6f8:	4629                	li	a2,10
 6fa:	000ba583          	lw	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	e91ff0ef          	jal	590 <printint>
 704:	8bca                	mv	s7,s2
 706:	4981                	li	s3,0
 708:	bfad                	j	682 <vprintf+0x4a>
 70a:	06400793          	li	a5,100
 70e:	02f68963          	beq	a3,a5,740 <vprintf+0x108>
 712:	06c00793          	li	a5,108
 716:	04f68263          	beq	a3,a5,75a <vprintf+0x122>
 71a:	07500793          	li	a5,117
 71e:	0af68063          	beq	a3,a5,7be <vprintf+0x186>
 722:	07800793          	li	a5,120
 726:	0ef68263          	beq	a3,a5,80a <vprintf+0x1d2>
 72a:	02500593          	li	a1,37
 72e:	855a                	mv	a0,s6
 730:	e43ff0ef          	jal	572 <putc>
 734:	85ca                	mv	a1,s2
 736:	855a                	mv	a0,s6
 738:	e3bff0ef          	jal	572 <putc>
 73c:	4981                	li	s3,0
 73e:	b791                	j	682 <vprintf+0x4a>
 740:	008b8913          	addi	s2,s7,8
 744:	4685                	li	a3,1
 746:	4629                	li	a2,10
 748:	000ba583          	lw	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	e43ff0ef          	jal	590 <printint>
 752:	2485                	addiw	s1,s1,1
 754:	8bca                	mv	s7,s2
 756:	4981                	li	s3,0
 758:	b72d                	j	682 <vprintf+0x4a>
 75a:	06400793          	li	a5,100
 75e:	02f60763          	beq	a2,a5,78c <vprintf+0x154>
 762:	07500793          	li	a5,117
 766:	06f60963          	beq	a2,a5,7d8 <vprintf+0x1a0>
 76a:	07800793          	li	a5,120
 76e:	faf61ee3          	bne	a2,a5,72a <vprintf+0xf2>
 772:	008b8913          	addi	s2,s7,8
 776:	4681                	li	a3,0
 778:	4641                	li	a2,16
 77a:	000ba583          	lw	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	e11ff0ef          	jal	590 <printint>
 784:	2489                	addiw	s1,s1,2
 786:	8bca                	mv	s7,s2
 788:	4981                	li	s3,0
 78a:	bde5                	j	682 <vprintf+0x4a>
 78c:	008b8913          	addi	s2,s7,8
 790:	4685                	li	a3,1
 792:	4629                	li	a2,10
 794:	000ba583          	lw	a1,0(s7)
 798:	855a                	mv	a0,s6
 79a:	df7ff0ef          	jal	590 <printint>
 79e:	2489                	addiw	s1,s1,2
 7a0:	8bca                	mv	s7,s2
 7a2:	4981                	li	s3,0
 7a4:	bdf9                	j	682 <vprintf+0x4a>
 7a6:	008b8913          	addi	s2,s7,8
 7aa:	4681                	li	a3,0
 7ac:	4629                	li	a2,10
 7ae:	000ba583          	lw	a1,0(s7)
 7b2:	855a                	mv	a0,s6
 7b4:	dddff0ef          	jal	590 <printint>
 7b8:	8bca                	mv	s7,s2
 7ba:	4981                	li	s3,0
 7bc:	b5d9                	j	682 <vprintf+0x4a>
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4681                	li	a3,0
 7c4:	4629                	li	a2,10
 7c6:	000ba583          	lw	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	dc5ff0ef          	jal	590 <printint>
 7d0:	2485                	addiw	s1,s1,1
 7d2:	8bca                	mv	s7,s2
 7d4:	4981                	li	s3,0
 7d6:	b575                	j	682 <vprintf+0x4a>
 7d8:	008b8913          	addi	s2,s7,8
 7dc:	4681                	li	a3,0
 7de:	4629                	li	a2,10
 7e0:	000ba583          	lw	a1,0(s7)
 7e4:	855a                	mv	a0,s6
 7e6:	dabff0ef          	jal	590 <printint>
 7ea:	2489                	addiw	s1,s1,2
 7ec:	8bca                	mv	s7,s2
 7ee:	4981                	li	s3,0
 7f0:	bd49                	j	682 <vprintf+0x4a>
 7f2:	008b8913          	addi	s2,s7,8
 7f6:	4681                	li	a3,0
 7f8:	4641                	li	a2,16
 7fa:	000ba583          	lw	a1,0(s7)
 7fe:	855a                	mv	a0,s6
 800:	d91ff0ef          	jal	590 <printint>
 804:	8bca                	mv	s7,s2
 806:	4981                	li	s3,0
 808:	bdad                	j	682 <vprintf+0x4a>
 80a:	008b8913          	addi	s2,s7,8
 80e:	4681                	li	a3,0
 810:	4641                	li	a2,16
 812:	000ba583          	lw	a1,0(s7)
 816:	855a                	mv	a0,s6
 818:	d79ff0ef          	jal	590 <printint>
 81c:	2485                	addiw	s1,s1,1
 81e:	8bca                	mv	s7,s2
 820:	4981                	li	s3,0
 822:	b585                	j	682 <vprintf+0x4a>
 824:	e06a                	sd	s10,0(sp)
 826:	008b8d13          	addi	s10,s7,8
 82a:	000bb983          	ld	s3,0(s7)
 82e:	03000593          	li	a1,48
 832:	855a                	mv	a0,s6
 834:	d3fff0ef          	jal	572 <putc>
 838:	07800593          	li	a1,120
 83c:	855a                	mv	a0,s6
 83e:	d35ff0ef          	jal	572 <putc>
 842:	4941                	li	s2,16
 844:	00000b97          	auipc	s7,0x0
 848:	2c4b8b93          	addi	s7,s7,708 # b08 <digits>
 84c:	03c9d793          	srli	a5,s3,0x3c
 850:	97de                	add	a5,a5,s7
 852:	0007c583          	lbu	a1,0(a5)
 856:	855a                	mv	a0,s6
 858:	d1bff0ef          	jal	572 <putc>
 85c:	0992                	slli	s3,s3,0x4
 85e:	397d                	addiw	s2,s2,-1
 860:	fe0916e3          	bnez	s2,84c <vprintf+0x214>
 864:	8bea                	mv	s7,s10
 866:	4981                	li	s3,0
 868:	6d02                	ld	s10,0(sp)
 86a:	bd21                	j	682 <vprintf+0x4a>
 86c:	008b8993          	addi	s3,s7,8
 870:	000bb903          	ld	s2,0(s7)
 874:	00090f63          	beqz	s2,892 <vprintf+0x25a>
 878:	00094583          	lbu	a1,0(s2)
 87c:	c195                	beqz	a1,8a0 <vprintf+0x268>
 87e:	855a                	mv	a0,s6
 880:	cf3ff0ef          	jal	572 <putc>
 884:	0905                	addi	s2,s2,1
 886:	00094583          	lbu	a1,0(s2)
 88a:	f9f5                	bnez	a1,87e <vprintf+0x246>
 88c:	8bce                	mv	s7,s3
 88e:	4981                	li	s3,0
 890:	bbcd                	j	682 <vprintf+0x4a>
 892:	00000917          	auipc	s2,0x0
 896:	26e90913          	addi	s2,s2,622 # b00 <malloc+0x162>
 89a:	02800593          	li	a1,40
 89e:	b7c5                	j	87e <vprintf+0x246>
 8a0:	8bce                	mv	s7,s3
 8a2:	4981                	li	s3,0
 8a4:	bbf9                	j	682 <vprintf+0x4a>
 8a6:	64a6                	ld	s1,72(sp)
 8a8:	79e2                	ld	s3,56(sp)
 8aa:	7a42                	ld	s4,48(sp)
 8ac:	7aa2                	ld	s5,40(sp)
 8ae:	7b02                	ld	s6,32(sp)
 8b0:	6be2                	ld	s7,24(sp)
 8b2:	6c42                	ld	s8,16(sp)
 8b4:	6ca2                	ld	s9,8(sp)
 8b6:	60e6                	ld	ra,88(sp)
 8b8:	6446                	ld	s0,80(sp)
 8ba:	6906                	ld	s2,64(sp)
 8bc:	6125                	addi	sp,sp,96
 8be:	8082                	ret

00000000000008c0 <fprintf>:
 8c0:	715d                	addi	sp,sp,-80
 8c2:	ec06                	sd	ra,24(sp)
 8c4:	e822                	sd	s0,16(sp)
 8c6:	1000                	addi	s0,sp,32
 8c8:	e010                	sd	a2,0(s0)
 8ca:	e414                	sd	a3,8(s0)
 8cc:	e818                	sd	a4,16(s0)
 8ce:	ec1c                	sd	a5,24(s0)
 8d0:	03043023          	sd	a6,32(s0)
 8d4:	03143423          	sd	a7,40(s0)
 8d8:	fe843423          	sd	s0,-24(s0)
 8dc:	8622                	mv	a2,s0
 8de:	d5bff0ef          	jal	638 <vprintf>
 8e2:	60e2                	ld	ra,24(sp)
 8e4:	6442                	ld	s0,16(sp)
 8e6:	6161                	addi	sp,sp,80
 8e8:	8082                	ret

00000000000008ea <printf>:
 8ea:	711d                	addi	sp,sp,-96
 8ec:	ec06                	sd	ra,24(sp)
 8ee:	e822                	sd	s0,16(sp)
 8f0:	1000                	addi	s0,sp,32
 8f2:	e40c                	sd	a1,8(s0)
 8f4:	e810                	sd	a2,16(s0)
 8f6:	ec14                	sd	a3,24(s0)
 8f8:	f018                	sd	a4,32(s0)
 8fa:	f41c                	sd	a5,40(s0)
 8fc:	03043823          	sd	a6,48(s0)
 900:	03143c23          	sd	a7,56(s0)
 904:	00840613          	addi	a2,s0,8
 908:	fec43423          	sd	a2,-24(s0)
 90c:	85aa                	mv	a1,a0
 90e:	4505                	li	a0,1
 910:	d29ff0ef          	jal	638 <vprintf>
 914:	60e2                	ld	ra,24(sp)
 916:	6442                	ld	s0,16(sp)
 918:	6125                	addi	sp,sp,96
 91a:	8082                	ret

000000000000091c <free>:
 91c:	1141                	addi	sp,sp,-16
 91e:	e422                	sd	s0,8(sp)
 920:	0800                	addi	s0,sp,16
 922:	ff050693          	addi	a3,a0,-16
 926:	00000797          	auipc	a5,0x0
 92a:	6da7b783          	ld	a5,1754(a5) # 1000 <freep>
 92e:	a02d                	j	958 <free+0x3c>
 930:	4618                	lw	a4,8(a2)
 932:	9f2d                	addw	a4,a4,a1
 934:	fee52c23          	sw	a4,-8(a0)
 938:	6398                	ld	a4,0(a5)
 93a:	6310                	ld	a2,0(a4)
 93c:	a83d                	j	97a <free+0x5e>
 93e:	ff852703          	lw	a4,-8(a0)
 942:	9f31                	addw	a4,a4,a2
 944:	c798                	sw	a4,8(a5)
 946:	ff053683          	ld	a3,-16(a0)
 94a:	a091                	j	98e <free+0x72>
 94c:	6398                	ld	a4,0(a5)
 94e:	00e7e463          	bltu	a5,a4,956 <free+0x3a>
 952:	00e6ea63          	bltu	a3,a4,966 <free+0x4a>
 956:	87ba                	mv	a5,a4
 958:	fed7fae3          	bgeu	a5,a3,94c <free+0x30>
 95c:	6398                	ld	a4,0(a5)
 95e:	00e6e463          	bltu	a3,a4,966 <free+0x4a>
 962:	fee7eae3          	bltu	a5,a4,956 <free+0x3a>
 966:	ff852583          	lw	a1,-8(a0)
 96a:	6390                	ld	a2,0(a5)
 96c:	02059813          	slli	a6,a1,0x20
 970:	01c85713          	srli	a4,a6,0x1c
 974:	9736                	add	a4,a4,a3
 976:	fae60de3          	beq	a2,a4,930 <free+0x14>
 97a:	fec53823          	sd	a2,-16(a0)
 97e:	4790                	lw	a2,8(a5)
 980:	02061593          	slli	a1,a2,0x20
 984:	01c5d713          	srli	a4,a1,0x1c
 988:	973e                	add	a4,a4,a5
 98a:	fae68ae3          	beq	a3,a4,93e <free+0x22>
 98e:	e394                	sd	a3,0(a5)
 990:	00000717          	auipc	a4,0x0
 994:	66f73823          	sd	a5,1648(a4) # 1000 <freep>
 998:	6422                	ld	s0,8(sp)
 99a:	0141                	addi	sp,sp,16
 99c:	8082                	ret

000000000000099e <malloc>:
 99e:	7139                	addi	sp,sp,-64
 9a0:	fc06                	sd	ra,56(sp)
 9a2:	f822                	sd	s0,48(sp)
 9a4:	f426                	sd	s1,40(sp)
 9a6:	ec4e                	sd	s3,24(sp)
 9a8:	0080                	addi	s0,sp,64
 9aa:	02051493          	slli	s1,a0,0x20
 9ae:	9081                	srli	s1,s1,0x20
 9b0:	04bd                	addi	s1,s1,15
 9b2:	8091                	srli	s1,s1,0x4
 9b4:	0014899b          	addiw	s3,s1,1
 9b8:	0485                	addi	s1,s1,1
 9ba:	00000517          	auipc	a0,0x0
 9be:	64653503          	ld	a0,1606(a0) # 1000 <freep>
 9c2:	c915                	beqz	a0,9f6 <malloc+0x58>
 9c4:	611c                	ld	a5,0(a0)
 9c6:	4798                	lw	a4,8(a5)
 9c8:	08977a63          	bgeu	a4,s1,a5c <malloc+0xbe>
 9cc:	f04a                	sd	s2,32(sp)
 9ce:	e852                	sd	s4,16(sp)
 9d0:	e456                	sd	s5,8(sp)
 9d2:	e05a                	sd	s6,0(sp)
 9d4:	8a4e                	mv	s4,s3
 9d6:	0009871b          	sext.w	a4,s3
 9da:	6685                	lui	a3,0x1
 9dc:	00d77363          	bgeu	a4,a3,9e2 <malloc+0x44>
 9e0:	6a05                	lui	s4,0x1
 9e2:	000a0b1b          	sext.w	s6,s4
 9e6:	004a1a1b          	slliw	s4,s4,0x4
 9ea:	00000917          	auipc	s2,0x0
 9ee:	61690913          	addi	s2,s2,1558 # 1000 <freep>
 9f2:	5afd                	li	s5,-1
 9f4:	a081                	j	a34 <malloc+0x96>
 9f6:	f04a                	sd	s2,32(sp)
 9f8:	e852                	sd	s4,16(sp)
 9fa:	e456                	sd	s5,8(sp)
 9fc:	e05a                	sd	s6,0(sp)
 9fe:	00000797          	auipc	a5,0x0
 a02:	62278793          	addi	a5,a5,1570 # 1020 <base>
 a06:	00000717          	auipc	a4,0x0
 a0a:	5ef73d23          	sd	a5,1530(a4) # 1000 <freep>
 a0e:	e39c                	sd	a5,0(a5)
 a10:	0007a423          	sw	zero,8(a5)
 a14:	b7c1                	j	9d4 <malloc+0x36>
 a16:	6398                	ld	a4,0(a5)
 a18:	e118                	sd	a4,0(a0)
 a1a:	a8a9                	j	a74 <malloc+0xd6>
 a1c:	01652423          	sw	s6,8(a0)
 a20:	0541                	addi	a0,a0,16
 a22:	efbff0ef          	jal	91c <free>
 a26:	00093503          	ld	a0,0(s2)
 a2a:	c12d                	beqz	a0,a8c <malloc+0xee>
 a2c:	611c                	ld	a5,0(a0)
 a2e:	4798                	lw	a4,8(a5)
 a30:	02977263          	bgeu	a4,s1,a54 <malloc+0xb6>
 a34:	00093703          	ld	a4,0(s2)
 a38:	853e                	mv	a0,a5
 a3a:	fef719e3          	bne	a4,a5,a2c <malloc+0x8e>
 a3e:	8552                	mv	a0,s4
 a40:	b1bff0ef          	jal	55a <sbrk>
 a44:	fd551ce3          	bne	a0,s5,a1c <malloc+0x7e>
 a48:	4501                	li	a0,0
 a4a:	7902                	ld	s2,32(sp)
 a4c:	6a42                	ld	s4,16(sp)
 a4e:	6aa2                	ld	s5,8(sp)
 a50:	6b02                	ld	s6,0(sp)
 a52:	a03d                	j	a80 <malloc+0xe2>
 a54:	7902                	ld	s2,32(sp)
 a56:	6a42                	ld	s4,16(sp)
 a58:	6aa2                	ld	s5,8(sp)
 a5a:	6b02                	ld	s6,0(sp)
 a5c:	fae48de3          	beq	s1,a4,a16 <malloc+0x78>
 a60:	4137073b          	subw	a4,a4,s3
 a64:	c798                	sw	a4,8(a5)
 a66:	02071693          	slli	a3,a4,0x20
 a6a:	01c6d713          	srli	a4,a3,0x1c
 a6e:	97ba                	add	a5,a5,a4
 a70:	0137a423          	sw	s3,8(a5)
 a74:	00000717          	auipc	a4,0x0
 a78:	58a73623          	sd	a0,1420(a4) # 1000 <freep>
 a7c:	01078513          	addi	a0,a5,16
 a80:	70e2                	ld	ra,56(sp)
 a82:	7442                	ld	s0,48(sp)
 a84:	74a2                	ld	s1,40(sp)
 a86:	69e2                	ld	s3,24(sp)
 a88:	6121                	addi	sp,sp,64
 a8a:	8082                	ret
 a8c:	7902                	ld	s2,32(sp)
 a8e:	6a42                	ld	s4,16(sp)
 a90:	6aa2                	ld	s5,8(sp)
 a92:	6b02                	ld	s6,0(sp)
 a94:	b7f5                	j	a80 <malloc+0xe2>
