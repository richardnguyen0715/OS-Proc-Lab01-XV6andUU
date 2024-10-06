
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	1c013103          	ld	sp,448(sp) # 8000a1c0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	4b9040ef          	jal	80004cce <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00031797          	auipc	a5,0x31
    80000034:	7e078793          	addi	a5,a5,2016 # 80031810 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	1c490913          	addi	s2,s2,452 # 8000a210 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	6da050ef          	jal	80005730 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	762050ef          	jal	800057c8 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	384050ef          	jal	80005402 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	13650513          	addi	a0,a0,310 # 8000a210 <kmem>
    800000e2:	5ce050ef          	jal	800056b0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00031517          	auipc	a0,0x31
    800000ee:	72650513          	addi	a0,a0,1830 # 80031810 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	10848493          	addi	s1,s1,264 # 8000a210 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	61e050ef          	jal	80005730 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	0f450513          	addi	a0,a0,244 # 8000a210 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	6a2050ef          	jal	800057c8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	0d050513          	addi	a0,a0,208 # 8000a210 <kmem>
    80000148:	680050ef          	jal	800057c8 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffcd7f1>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	feb79ae3          	bne	a5,a1,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fef71ae3          	bne	a4,a5,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a801                	j	8000024a <strncmp+0x30>
    8000023c:	4501                	li	a0,0
    8000023e:	a031                	j	8000024a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000256:	87aa                	mv	a5,a0
    80000258:	86b2                	mv	a3,a2
    8000025a:	367d                	addiw	a2,a2,-1
    8000025c:	02d05563          	blez	a3,80000286 <strncpy+0x36>
    80000260:	0785                	addi	a5,a5,1
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	fee78fa3          	sb	a4,-1(a5)
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	f775                	bnez	a4,80000258 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000026e:	873e                	mv	a4,a5
    80000270:	9fb5                	addw	a5,a5,a3
    80000272:	37fd                	addiw	a5,a5,-1
    80000274:	00c05963          	blez	a2,80000286 <strncpy+0x36>
    *s++ = 0;
    80000278:	0705                	addi	a4,a4,1
    8000027a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000027e:	40e786bb          	subw	a3,a5,a4
    80000282:	fed04be3          	bgtz	a3,80000278 <strncpy+0x28>
  return os;
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret

000000008000028c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000292:	02c05363          	blez	a2,800002b8 <safestrcpy+0x2c>
    80000296:	fff6069b          	addiw	a3,a2,-1
    8000029a:	1682                	slli	a3,a3,0x20
    8000029c:	9281                	srli	a3,a3,0x20
    8000029e:	96ae                	add	a3,a3,a1
    800002a0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a2:	00d58963          	beq	a1,a3,800002b4 <safestrcpy+0x28>
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	0785                	addi	a5,a5,1
    800002aa:	fff5c703          	lbu	a4,-1(a1)
    800002ae:	fee78fa3          	sb	a4,-1(a5)
    800002b2:	fb65                	bnez	a4,800002a2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002b4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <strlen>:

int
strlen(const char *s)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf91                	beqz	a5,800002e4 <strlen+0x26>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x10>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e4:	4501                	li	a0,0
    800002e6:	bfe5                	j	800002de <strlen+0x20>

00000000800002e8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f0:	24b000ef          	jal	80000d3a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f4:	0000a717          	auipc	a4,0xa
    800002f8:	eec70713          	addi	a4,a4,-276 # 8000a1e0 <started>
  if(cpuid() == 0){
    800002fc:	c51d                	beqz	a0,8000032a <main+0x42>
    while(started == 0)
    800002fe:	431c                	lw	a5,0(a4)
    80000300:	2781                	sext.w	a5,a5
    80000302:	dff5                	beqz	a5,800002fe <main+0x16>
      ;
    __sync_synchronize();
    80000304:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000308:	233000ef          	jal	80000d3a <cpuid>
    8000030c:	85aa                	mv	a1,a0
    8000030e:	00007517          	auipc	a0,0x7
    80000312:	d2a50513          	addi	a0,a0,-726 # 80007038 <etext+0x38>
    80000316:	61b040ef          	jal	80005130 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	538010ef          	jal	80001856 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	3c6040ef          	jal	800046e8 <plicinithart>
  }

  scheduler();        
    80000326:	675000ef          	jal	8000119a <scheduler>
    consoleinit();
    8000032a:	531040ef          	jal	8000505a <consoleinit>
    printfinit();
    8000032e:	10e050ef          	jal	8000543c <printfinit>
    printf("\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	ce650513          	addi	a0,a0,-794 # 80007018 <etext+0x18>
    8000033a:	5f7040ef          	jal	80005130 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	ce250513          	addi	a0,a0,-798 # 80007020 <etext+0x20>
    80000346:	5eb040ef          	jal	80005130 <printf>
    printf("\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cce50513          	addi	a0,a0,-818 # 80007018 <etext+0x18>
    80000352:	5df040ef          	jal	80005130 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2ca000ef          	jal	80000624 <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	123000ef          	jal	80000c84 <procinit>
    trapinit();      // trap vectors
    80000366:	4cc010ef          	jal	80001832 <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	4ec010ef          	jal	80001856 <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	360040ef          	jal	800046ce <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	376040ef          	jal	800046e8 <plicinithart>
    binit();         // buffer cache
    80000376:	313010ef          	jal	80001e88 <binit>
    iinit();         // inode table
    8000037a:	104020ef          	jal	8000247e <iinit>
    fileinit();      // file table
    8000037e:	6b5020ef          	jal	80003232 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	456040ef          	jal	800047d8 <virtio_disk_init>
    userinit();      // first user process
    80000386:	449000ef          	jal	80000fce <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000a717          	auipc	a4,0xa
    80000394:	e4f72823          	sw	a5,-432(a4) # 8000a1e0 <started>
    80000398:	b779                	j	80000326 <main+0x3e>

000000008000039a <kvminithart>:
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
    800003a0:	12000073          	sfence.vma
    800003a4:	0000a797          	auipc	a5,0xa
    800003a8:	e447b783          	ld	a5,-444(a5) # 8000a1e8 <kernel_pagetable>
    800003ac:	83b1                	srli	a5,a5,0xc
    800003ae:	577d                	li	a4,-1
    800003b0:	177e                	slli	a4,a4,0x3f
    800003b2:	8fd9                	or	a5,a5,a4
    800003b4:	18079073          	csrw	satp,a5
    800003b8:	12000073          	sfence.vma
    800003bc:	6422                	ld	s0,8(sp)
    800003be:	0141                	addi	sp,sp,16
    800003c0:	8082                	ret

00000000800003c2 <walk>:
    800003c2:	7139                	addi	sp,sp,-64
    800003c4:	fc06                	sd	ra,56(sp)
    800003c6:	f822                	sd	s0,48(sp)
    800003c8:	f426                	sd	s1,40(sp)
    800003ca:	f04a                	sd	s2,32(sp)
    800003cc:	ec4e                	sd	s3,24(sp)
    800003ce:	e852                	sd	s4,16(sp)
    800003d0:	e456                	sd	s5,8(sp)
    800003d2:	e05a                	sd	s6,0(sp)
    800003d4:	0080                	addi	s0,sp,64
    800003d6:	84aa                	mv	s1,a0
    800003d8:	89ae                	mv	s3,a1
    800003da:	8ab2                	mv	s5,a2
    800003dc:	57fd                	li	a5,-1
    800003de:	83e9                	srli	a5,a5,0x1a
    800003e0:	4a79                	li	s4,30
    800003e2:	4b31                	li	s6,12
    800003e4:	02b7fc63          	bgeu	a5,a1,8000041c <walk+0x5a>
    800003e8:	00007517          	auipc	a0,0x7
    800003ec:	c6850513          	addi	a0,a0,-920 # 80007050 <etext+0x50>
    800003f0:	012050ef          	jal	80005402 <panic>
    800003f4:	060a8263          	beqz	s5,80000458 <walk+0x96>
    800003f8:	d07ff0ef          	jal	800000fe <kalloc>
    800003fc:	84aa                	mv	s1,a0
    800003fe:	c139                	beqz	a0,80000444 <walk+0x82>
    80000400:	6605                	lui	a2,0x1
    80000402:	4581                	li	a1,0
    80000404:	d4bff0ef          	jal	8000014e <memset>
    80000408:	00c4d793          	srli	a5,s1,0xc
    8000040c:	07aa                	slli	a5,a5,0xa
    8000040e:	0017e793          	ori	a5,a5,1
    80000412:	00f93023          	sd	a5,0(s2)
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffcd7e7>
    80000418:	036a0063          	beq	s4,s6,80000438 <walk+0x76>
    8000041c:	0149d933          	srl	s2,s3,s4
    80000420:	1ff97913          	andi	s2,s2,511
    80000424:	090e                	slli	s2,s2,0x3
    80000426:	9926                	add	s2,s2,s1
    80000428:	00093483          	ld	s1,0(s2)
    8000042c:	0014f793          	andi	a5,s1,1
    80000430:	d3f1                	beqz	a5,800003f4 <walk+0x32>
    80000432:	80a9                	srli	s1,s1,0xa
    80000434:	04b2                	slli	s1,s1,0xc
    80000436:	b7c5                	j	80000416 <walk+0x54>
    80000438:	00c9d513          	srli	a0,s3,0xc
    8000043c:	1ff57513          	andi	a0,a0,511
    80000440:	050e                	slli	a0,a0,0x3
    80000442:	9526                	add	a0,a0,s1
    80000444:	70e2                	ld	ra,56(sp)
    80000446:	7442                	ld	s0,48(sp)
    80000448:	74a2                	ld	s1,40(sp)
    8000044a:	7902                	ld	s2,32(sp)
    8000044c:	69e2                	ld	s3,24(sp)
    8000044e:	6a42                	ld	s4,16(sp)
    80000450:	6aa2                	ld	s5,8(sp)
    80000452:	6b02                	ld	s6,0(sp)
    80000454:	6121                	addi	sp,sp,64
    80000456:	8082                	ret
    80000458:	4501                	li	a0,0
    8000045a:	b7ed                	j	80000444 <walk+0x82>

000000008000045c <walkaddr>:
    8000045c:	57fd                	li	a5,-1
    8000045e:	83e9                	srli	a5,a5,0x1a
    80000460:	00b7f463          	bgeu	a5,a1,80000468 <walkaddr+0xc>
    80000464:	4501                	li	a0,0
    80000466:	8082                	ret
    80000468:	1141                	addi	sp,sp,-16
    8000046a:	e406                	sd	ra,8(sp)
    8000046c:	e022                	sd	s0,0(sp)
    8000046e:	0800                	addi	s0,sp,16
    80000470:	4601                	li	a2,0
    80000472:	f51ff0ef          	jal	800003c2 <walk>
    80000476:	c105                	beqz	a0,80000496 <walkaddr+0x3a>
    80000478:	611c                	ld	a5,0(a0)
    8000047a:	0117f693          	andi	a3,a5,17
    8000047e:	4745                	li	a4,17
    80000480:	4501                	li	a0,0
    80000482:	00e68663          	beq	a3,a4,8000048e <walkaddr+0x32>
    80000486:	60a2                	ld	ra,8(sp)
    80000488:	6402                	ld	s0,0(sp)
    8000048a:	0141                	addi	sp,sp,16
    8000048c:	8082                	ret
    8000048e:	83a9                	srli	a5,a5,0xa
    80000490:	00c79513          	slli	a0,a5,0xc
    80000494:	bfcd                	j	80000486 <walkaddr+0x2a>
    80000496:	4501                	li	a0,0
    80000498:	b7fd                	j	80000486 <walkaddr+0x2a>

000000008000049a <mappages>:
    8000049a:	715d                	addi	sp,sp,-80
    8000049c:	e486                	sd	ra,72(sp)
    8000049e:	e0a2                	sd	s0,64(sp)
    800004a0:	fc26                	sd	s1,56(sp)
    800004a2:	f84a                	sd	s2,48(sp)
    800004a4:	f44e                	sd	s3,40(sp)
    800004a6:	f052                	sd	s4,32(sp)
    800004a8:	ec56                	sd	s5,24(sp)
    800004aa:	e85a                	sd	s6,16(sp)
    800004ac:	e45e                	sd	s7,8(sp)
    800004ae:	0880                	addi	s0,sp,80
    800004b0:	03459793          	slli	a5,a1,0x34
    800004b4:	e7a9                	bnez	a5,800004fe <mappages+0x64>
    800004b6:	8aaa                	mv	s5,a0
    800004b8:	8b3a                	mv	s6,a4
    800004ba:	03461793          	slli	a5,a2,0x34
    800004be:	e7b1                	bnez	a5,8000050a <mappages+0x70>
    800004c0:	ca39                	beqz	a2,80000516 <mappages+0x7c>
    800004c2:	77fd                	lui	a5,0xfffff
    800004c4:	963e                	add	a2,a2,a5
    800004c6:	00b609b3          	add	s3,a2,a1
    800004ca:	892e                	mv	s2,a1
    800004cc:	40b68a33          	sub	s4,a3,a1
    800004d0:	6b85                	lui	s7,0x1
    800004d2:	014904b3          	add	s1,s2,s4
    800004d6:	4605                	li	a2,1
    800004d8:	85ca                	mv	a1,s2
    800004da:	8556                	mv	a0,s5
    800004dc:	ee7ff0ef          	jal	800003c2 <walk>
    800004e0:	c539                	beqz	a0,8000052e <mappages+0x94>
    800004e2:	611c                	ld	a5,0(a0)
    800004e4:	8b85                	andi	a5,a5,1
    800004e6:	ef95                	bnez	a5,80000522 <mappages+0x88>
    800004e8:	80b1                	srli	s1,s1,0xc
    800004ea:	04aa                	slli	s1,s1,0xa
    800004ec:	0164e4b3          	or	s1,s1,s6
    800004f0:	0014e493          	ori	s1,s1,1
    800004f4:	e104                	sd	s1,0(a0)
    800004f6:	05390863          	beq	s2,s3,80000546 <mappages+0xac>
    800004fa:	995e                	add	s2,s2,s7
    800004fc:	bfd9                	j	800004d2 <mappages+0x38>
    800004fe:	00007517          	auipc	a0,0x7
    80000502:	b5a50513          	addi	a0,a0,-1190 # 80007058 <etext+0x58>
    80000506:	6fd040ef          	jal	80005402 <panic>
    8000050a:	00007517          	auipc	a0,0x7
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80007078 <etext+0x78>
    80000512:	6f1040ef          	jal	80005402 <panic>
    80000516:	00007517          	auipc	a0,0x7
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80007098 <etext+0x98>
    8000051e:	6e5040ef          	jal	80005402 <panic>
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b8650513          	addi	a0,a0,-1146 # 800070a8 <etext+0xa8>
    8000052a:	6d9040ef          	jal	80005402 <panic>
    8000052e:	557d                	li	a0,-1
    80000530:	60a6                	ld	ra,72(sp)
    80000532:	6406                	ld	s0,64(sp)
    80000534:	74e2                	ld	s1,56(sp)
    80000536:	7942                	ld	s2,48(sp)
    80000538:	79a2                	ld	s3,40(sp)
    8000053a:	7a02                	ld	s4,32(sp)
    8000053c:	6ae2                	ld	s5,24(sp)
    8000053e:	6b42                	ld	s6,16(sp)
    80000540:	6ba2                	ld	s7,8(sp)
    80000542:	6161                	addi	sp,sp,80
    80000544:	8082                	ret
    80000546:	4501                	li	a0,0
    80000548:	b7e5                	j	80000530 <mappages+0x96>

000000008000054a <kvmmap>:
    8000054a:	1141                	addi	sp,sp,-16
    8000054c:	e406                	sd	ra,8(sp)
    8000054e:	e022                	sd	s0,0(sp)
    80000550:	0800                	addi	s0,sp,16
    80000552:	87b6                	mv	a5,a3
    80000554:	86b2                	mv	a3,a2
    80000556:	863e                	mv	a2,a5
    80000558:	f43ff0ef          	jal	8000049a <mappages>
    8000055c:	e509                	bnez	a0,80000566 <kvmmap+0x1c>
    8000055e:	60a2                	ld	ra,8(sp)
    80000560:	6402                	ld	s0,0(sp)
    80000562:	0141                	addi	sp,sp,16
    80000564:	8082                	ret
    80000566:	00007517          	auipc	a0,0x7
    8000056a:	b5250513          	addi	a0,a0,-1198 # 800070b8 <etext+0xb8>
    8000056e:	695040ef          	jal	80005402 <panic>

0000000080000572 <kvmmake>:
    80000572:	1101                	addi	sp,sp,-32
    80000574:	ec06                	sd	ra,24(sp)
    80000576:	e822                	sd	s0,16(sp)
    80000578:	e426                	sd	s1,8(sp)
    8000057a:	e04a                	sd	s2,0(sp)
    8000057c:	1000                	addi	s0,sp,32
    8000057e:	b81ff0ef          	jal	800000fe <kalloc>
    80000582:	84aa                	mv	s1,a0
    80000584:	6605                	lui	a2,0x1
    80000586:	4581                	li	a1,0
    80000588:	bc7ff0ef          	jal	8000014e <memset>
    8000058c:	4719                	li	a4,6
    8000058e:	6685                	lui	a3,0x1
    80000590:	10000637          	lui	a2,0x10000
    80000594:	100005b7          	lui	a1,0x10000
    80000598:	8526                	mv	a0,s1
    8000059a:	fb1ff0ef          	jal	8000054a <kvmmap>
    8000059e:	4719                	li	a4,6
    800005a0:	6685                	lui	a3,0x1
    800005a2:	10001637          	lui	a2,0x10001
    800005a6:	100015b7          	lui	a1,0x10001
    800005aa:	8526                	mv	a0,s1
    800005ac:	f9fff0ef          	jal	8000054a <kvmmap>
    800005b0:	4719                	li	a4,6
    800005b2:	040006b7          	lui	a3,0x4000
    800005b6:	0c000637          	lui	a2,0xc000
    800005ba:	0c0005b7          	lui	a1,0xc000
    800005be:	8526                	mv	a0,s1
    800005c0:	f8bff0ef          	jal	8000054a <kvmmap>
    800005c4:	00007917          	auipc	s2,0x7
    800005c8:	a3c90913          	addi	s2,s2,-1476 # 80007000 <etext>
    800005cc:	4729                	li	a4,10
    800005ce:	80007697          	auipc	a3,0x80007
    800005d2:	a3268693          	addi	a3,a3,-1486 # 7000 <_entry-0x7fff9000>
    800005d6:	4605                	li	a2,1
    800005d8:	067e                	slli	a2,a2,0x1f
    800005da:	85b2                	mv	a1,a2
    800005dc:	8526                	mv	a0,s1
    800005de:	f6dff0ef          	jal	8000054a <kvmmap>
    800005e2:	46c5                	li	a3,17
    800005e4:	06ee                	slli	a3,a3,0x1b
    800005e6:	4719                	li	a4,6
    800005e8:	412686b3          	sub	a3,a3,s2
    800005ec:	864a                	mv	a2,s2
    800005ee:	85ca                	mv	a1,s2
    800005f0:	8526                	mv	a0,s1
    800005f2:	f59ff0ef          	jal	8000054a <kvmmap>
    800005f6:	4729                	li	a4,10
    800005f8:	6685                	lui	a3,0x1
    800005fa:	00006617          	auipc	a2,0x6
    800005fe:	a0660613          	addi	a2,a2,-1530 # 80006000 <_trampoline>
    80000602:	040005b7          	lui	a1,0x4000
    80000606:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000608:	05b2                	slli	a1,a1,0xc
    8000060a:	8526                	mv	a0,s1
    8000060c:	f3fff0ef          	jal	8000054a <kvmmap>
    80000610:	8526                	mv	a0,s1
    80000612:	5da000ef          	jal	80000bec <proc_mapstacks>
    80000616:	8526                	mv	a0,s1
    80000618:	60e2                	ld	ra,24(sp)
    8000061a:	6442                	ld	s0,16(sp)
    8000061c:	64a2                	ld	s1,8(sp)
    8000061e:	6902                	ld	s2,0(sp)
    80000620:	6105                	addi	sp,sp,32
    80000622:	8082                	ret

0000000080000624 <kvminit>:
    80000624:	1141                	addi	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	addi	s0,sp,16
    8000062c:	f47ff0ef          	jal	80000572 <kvmmake>
    80000630:	0000a797          	auipc	a5,0xa
    80000634:	baa7bc23          	sd	a0,-1096(a5) # 8000a1e8 <kernel_pagetable>
    80000638:	60a2                	ld	ra,8(sp)
    8000063a:	6402                	ld	s0,0(sp)
    8000063c:	0141                	addi	sp,sp,16
    8000063e:	8082                	ret

0000000080000640 <uvmunmap>:
    80000640:	715d                	addi	sp,sp,-80
    80000642:	e486                	sd	ra,72(sp)
    80000644:	e0a2                	sd	s0,64(sp)
    80000646:	0880                	addi	s0,sp,80
    80000648:	03459793          	slli	a5,a1,0x34
    8000064c:	e39d                	bnez	a5,80000672 <uvmunmap+0x32>
    8000064e:	f84a                	sd	s2,48(sp)
    80000650:	f44e                	sd	s3,40(sp)
    80000652:	f052                	sd	s4,32(sp)
    80000654:	ec56                	sd	s5,24(sp)
    80000656:	e85a                	sd	s6,16(sp)
    80000658:	e45e                	sd	s7,8(sp)
    8000065a:	8a2a                	mv	s4,a0
    8000065c:	892e                	mv	s2,a1
    8000065e:	8ab6                	mv	s5,a3
    80000660:	0632                	slli	a2,a2,0xc
    80000662:	00b609b3          	add	s3,a2,a1
    80000666:	4b85                	li	s7,1
    80000668:	6b05                	lui	s6,0x1
    8000066a:	0735ff63          	bgeu	a1,s3,800006e8 <uvmunmap+0xa8>
    8000066e:	fc26                	sd	s1,56(sp)
    80000670:	a0a9                	j	800006ba <uvmunmap+0x7a>
    80000672:	fc26                	sd	s1,56(sp)
    80000674:	f84a                	sd	s2,48(sp)
    80000676:	f44e                	sd	s3,40(sp)
    80000678:	f052                	sd	s4,32(sp)
    8000067a:	ec56                	sd	s5,24(sp)
    8000067c:	e85a                	sd	s6,16(sp)
    8000067e:	e45e                	sd	s7,8(sp)
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a4050513          	addi	a0,a0,-1472 # 800070c0 <etext+0xc0>
    80000688:	57b040ef          	jal	80005402 <panic>
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a4c50513          	addi	a0,a0,-1460 # 800070d8 <etext+0xd8>
    80000694:	56f040ef          	jal	80005402 <panic>
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a5050513          	addi	a0,a0,-1456 # 800070e8 <etext+0xe8>
    800006a0:	563040ef          	jal	80005402 <panic>
    800006a4:	00007517          	auipc	a0,0x7
    800006a8:	a5c50513          	addi	a0,a0,-1444 # 80007100 <etext+0x100>
    800006ac:	557040ef          	jal	80005402 <panic>
    800006b0:	0004b023          	sd	zero,0(s1)
    800006b4:	995a                	add	s2,s2,s6
    800006b6:	03397863          	bgeu	s2,s3,800006e6 <uvmunmap+0xa6>
    800006ba:	4601                	li	a2,0
    800006bc:	85ca                	mv	a1,s2
    800006be:	8552                	mv	a0,s4
    800006c0:	d03ff0ef          	jal	800003c2 <walk>
    800006c4:	84aa                	mv	s1,a0
    800006c6:	d179                	beqz	a0,8000068c <uvmunmap+0x4c>
    800006c8:	6108                	ld	a0,0(a0)
    800006ca:	00157793          	andi	a5,a0,1
    800006ce:	d7e9                	beqz	a5,80000698 <uvmunmap+0x58>
    800006d0:	3ff57793          	andi	a5,a0,1023
    800006d4:	fd7788e3          	beq	a5,s7,800006a4 <uvmunmap+0x64>
    800006d8:	fc0a8ce3          	beqz	s5,800006b0 <uvmunmap+0x70>
    800006dc:	8129                	srli	a0,a0,0xa
    800006de:	0532                	slli	a0,a0,0xc
    800006e0:	93dff0ef          	jal	8000001c <kfree>
    800006e4:	b7f1                	j	800006b0 <uvmunmap+0x70>
    800006e6:	74e2                	ld	s1,56(sp)
    800006e8:	7942                	ld	s2,48(sp)
    800006ea:	79a2                	ld	s3,40(sp)
    800006ec:	7a02                	ld	s4,32(sp)
    800006ee:	6ae2                	ld	s5,24(sp)
    800006f0:	6b42                	ld	s6,16(sp)
    800006f2:	6ba2                	ld	s7,8(sp)
    800006f4:	60a6                	ld	ra,72(sp)
    800006f6:	6406                	ld	s0,64(sp)
    800006f8:	6161                	addi	sp,sp,80
    800006fa:	8082                	ret

00000000800006fc <uvmcreate>:
    800006fc:	1101                	addi	sp,sp,-32
    800006fe:	ec06                	sd	ra,24(sp)
    80000700:	e822                	sd	s0,16(sp)
    80000702:	e426                	sd	s1,8(sp)
    80000704:	1000                	addi	s0,sp,32
    80000706:	9f9ff0ef          	jal	800000fe <kalloc>
    8000070a:	84aa                	mv	s1,a0
    8000070c:	c509                	beqz	a0,80000716 <uvmcreate+0x1a>
    8000070e:	6605                	lui	a2,0x1
    80000710:	4581                	li	a1,0
    80000712:	a3dff0ef          	jal	8000014e <memset>
    80000716:	8526                	mv	a0,s1
    80000718:	60e2                	ld	ra,24(sp)
    8000071a:	6442                	ld	s0,16(sp)
    8000071c:	64a2                	ld	s1,8(sp)
    8000071e:	6105                	addi	sp,sp,32
    80000720:	8082                	ret

0000000080000722 <uvmfirst>:
    80000722:	7179                	addi	sp,sp,-48
    80000724:	f406                	sd	ra,40(sp)
    80000726:	f022                	sd	s0,32(sp)
    80000728:	ec26                	sd	s1,24(sp)
    8000072a:	e84a                	sd	s2,16(sp)
    8000072c:	e44e                	sd	s3,8(sp)
    8000072e:	e052                	sd	s4,0(sp)
    80000730:	1800                	addi	s0,sp,48
    80000732:	6785                	lui	a5,0x1
    80000734:	04f67063          	bgeu	a2,a5,80000774 <uvmfirst+0x52>
    80000738:	8a2a                	mv	s4,a0
    8000073a:	89ae                	mv	s3,a1
    8000073c:	84b2                	mv	s1,a2
    8000073e:	9c1ff0ef          	jal	800000fe <kalloc>
    80000742:	892a                	mv	s2,a0
    80000744:	6605                	lui	a2,0x1
    80000746:	4581                	li	a1,0
    80000748:	a07ff0ef          	jal	8000014e <memset>
    8000074c:	4779                	li	a4,30
    8000074e:	86ca                	mv	a3,s2
    80000750:	6605                	lui	a2,0x1
    80000752:	4581                	li	a1,0
    80000754:	8552                	mv	a0,s4
    80000756:	d45ff0ef          	jal	8000049a <mappages>
    8000075a:	8626                	mv	a2,s1
    8000075c:	85ce                	mv	a1,s3
    8000075e:	854a                	mv	a0,s2
    80000760:	a4bff0ef          	jal	800001aa <memmove>
    80000764:	70a2                	ld	ra,40(sp)
    80000766:	7402                	ld	s0,32(sp)
    80000768:	64e2                	ld	s1,24(sp)
    8000076a:	6942                	ld	s2,16(sp)
    8000076c:	69a2                	ld	s3,8(sp)
    8000076e:	6a02                	ld	s4,0(sp)
    80000770:	6145                	addi	sp,sp,48
    80000772:	8082                	ret
    80000774:	00007517          	auipc	a0,0x7
    80000778:	9a450513          	addi	a0,a0,-1628 # 80007118 <etext+0x118>
    8000077c:	487040ef          	jal	80005402 <panic>

0000000080000780 <uvmdealloc>:
    80000780:	1101                	addi	sp,sp,-32
    80000782:	ec06                	sd	ra,24(sp)
    80000784:	e822                	sd	s0,16(sp)
    80000786:	e426                	sd	s1,8(sp)
    80000788:	1000                	addi	s0,sp,32
    8000078a:	84ae                	mv	s1,a1
    8000078c:	00b67d63          	bgeu	a2,a1,800007a6 <uvmdealloc+0x26>
    80000790:	84b2                	mv	s1,a2
    80000792:	6785                	lui	a5,0x1
    80000794:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000796:	00f60733          	add	a4,a2,a5
    8000079a:	76fd                	lui	a3,0xfffff
    8000079c:	8f75                	and	a4,a4,a3
    8000079e:	97ae                	add	a5,a5,a1
    800007a0:	8ff5                	and	a5,a5,a3
    800007a2:	00f76863          	bltu	a4,a5,800007b2 <uvmdealloc+0x32>
    800007a6:	8526                	mv	a0,s1
    800007a8:	60e2                	ld	ra,24(sp)
    800007aa:	6442                	ld	s0,16(sp)
    800007ac:	64a2                	ld	s1,8(sp)
    800007ae:	6105                	addi	sp,sp,32
    800007b0:	8082                	ret
    800007b2:	8f99                	sub	a5,a5,a4
    800007b4:	83b1                	srli	a5,a5,0xc
    800007b6:	4685                	li	a3,1
    800007b8:	0007861b          	sext.w	a2,a5
    800007bc:	85ba                	mv	a1,a4
    800007be:	e83ff0ef          	jal	80000640 <uvmunmap>
    800007c2:	b7d5                	j	800007a6 <uvmdealloc+0x26>

00000000800007c4 <uvmalloc>:
    800007c4:	08b66f63          	bltu	a2,a1,80000862 <uvmalloc+0x9e>
    800007c8:	7139                	addi	sp,sp,-64
    800007ca:	fc06                	sd	ra,56(sp)
    800007cc:	f822                	sd	s0,48(sp)
    800007ce:	ec4e                	sd	s3,24(sp)
    800007d0:	e852                	sd	s4,16(sp)
    800007d2:	e456                	sd	s5,8(sp)
    800007d4:	0080                	addi	s0,sp,64
    800007d6:	8aaa                	mv	s5,a0
    800007d8:	8a32                	mv	s4,a2
    800007da:	6785                	lui	a5,0x1
    800007dc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007de:	95be                	add	a1,a1,a5
    800007e0:	77fd                	lui	a5,0xfffff
    800007e2:	00f5f9b3          	and	s3,a1,a5
    800007e6:	08c9f063          	bgeu	s3,a2,80000866 <uvmalloc+0xa2>
    800007ea:	f426                	sd	s1,40(sp)
    800007ec:	f04a                	sd	s2,32(sp)
    800007ee:	e05a                	sd	s6,0(sp)
    800007f0:	894e                	mv	s2,s3
    800007f2:	0126eb13          	ori	s6,a3,18
    800007f6:	909ff0ef          	jal	800000fe <kalloc>
    800007fa:	84aa                	mv	s1,a0
    800007fc:	c515                	beqz	a0,80000828 <uvmalloc+0x64>
    800007fe:	6605                	lui	a2,0x1
    80000800:	4581                	li	a1,0
    80000802:	94dff0ef          	jal	8000014e <memset>
    80000806:	875a                	mv	a4,s6
    80000808:	86a6                	mv	a3,s1
    8000080a:	6605                	lui	a2,0x1
    8000080c:	85ca                	mv	a1,s2
    8000080e:	8556                	mv	a0,s5
    80000810:	c8bff0ef          	jal	8000049a <mappages>
    80000814:	e915                	bnez	a0,80000848 <uvmalloc+0x84>
    80000816:	6785                	lui	a5,0x1
    80000818:	993e                	add	s2,s2,a5
    8000081a:	fd496ee3          	bltu	s2,s4,800007f6 <uvmalloc+0x32>
    8000081e:	8552                	mv	a0,s4
    80000820:	74a2                	ld	s1,40(sp)
    80000822:	7902                	ld	s2,32(sp)
    80000824:	6b02                	ld	s6,0(sp)
    80000826:	a811                	j	8000083a <uvmalloc+0x76>
    80000828:	864e                	mv	a2,s3
    8000082a:	85ca                	mv	a1,s2
    8000082c:	8556                	mv	a0,s5
    8000082e:	f53ff0ef          	jal	80000780 <uvmdealloc>
    80000832:	4501                	li	a0,0
    80000834:	74a2                	ld	s1,40(sp)
    80000836:	7902                	ld	s2,32(sp)
    80000838:	6b02                	ld	s6,0(sp)
    8000083a:	70e2                	ld	ra,56(sp)
    8000083c:	7442                	ld	s0,48(sp)
    8000083e:	69e2                	ld	s3,24(sp)
    80000840:	6a42                	ld	s4,16(sp)
    80000842:	6aa2                	ld	s5,8(sp)
    80000844:	6121                	addi	sp,sp,64
    80000846:	8082                	ret
    80000848:	8526                	mv	a0,s1
    8000084a:	fd2ff0ef          	jal	8000001c <kfree>
    8000084e:	864e                	mv	a2,s3
    80000850:	85ca                	mv	a1,s2
    80000852:	8556                	mv	a0,s5
    80000854:	f2dff0ef          	jal	80000780 <uvmdealloc>
    80000858:	4501                	li	a0,0
    8000085a:	74a2                	ld	s1,40(sp)
    8000085c:	7902                	ld	s2,32(sp)
    8000085e:	6b02                	ld	s6,0(sp)
    80000860:	bfe9                	j	8000083a <uvmalloc+0x76>
    80000862:	852e                	mv	a0,a1
    80000864:	8082                	ret
    80000866:	8532                	mv	a0,a2
    80000868:	bfc9                	j	8000083a <uvmalloc+0x76>

000000008000086a <freewalk>:
    8000086a:	7179                	addi	sp,sp,-48
    8000086c:	f406                	sd	ra,40(sp)
    8000086e:	f022                	sd	s0,32(sp)
    80000870:	ec26                	sd	s1,24(sp)
    80000872:	e84a                	sd	s2,16(sp)
    80000874:	e44e                	sd	s3,8(sp)
    80000876:	e052                	sd	s4,0(sp)
    80000878:	1800                	addi	s0,sp,48
    8000087a:	8a2a                	mv	s4,a0
    8000087c:	84aa                	mv	s1,a0
    8000087e:	6905                	lui	s2,0x1
    80000880:	992a                	add	s2,s2,a0
    80000882:	4985                	li	s3,1
    80000884:	a819                	j	8000089a <freewalk+0x30>
    80000886:	83a9                	srli	a5,a5,0xa
    80000888:	00c79513          	slli	a0,a5,0xc
    8000088c:	fdfff0ef          	jal	8000086a <freewalk>
    80000890:	0004b023          	sd	zero,0(s1)
    80000894:	04a1                	addi	s1,s1,8
    80000896:	01248f63          	beq	s1,s2,800008b4 <freewalk+0x4a>
    8000089a:	609c                	ld	a5,0(s1)
    8000089c:	00f7f713          	andi	a4,a5,15
    800008a0:	ff3703e3          	beq	a4,s3,80000886 <freewalk+0x1c>
    800008a4:	8b85                	andi	a5,a5,1
    800008a6:	d7fd                	beqz	a5,80000894 <freewalk+0x2a>
    800008a8:	00007517          	auipc	a0,0x7
    800008ac:	89050513          	addi	a0,a0,-1904 # 80007138 <etext+0x138>
    800008b0:	353040ef          	jal	80005402 <panic>
    800008b4:	8552                	mv	a0,s4
    800008b6:	f66ff0ef          	jal	8000001c <kfree>
    800008ba:	70a2                	ld	ra,40(sp)
    800008bc:	7402                	ld	s0,32(sp)
    800008be:	64e2                	ld	s1,24(sp)
    800008c0:	6942                	ld	s2,16(sp)
    800008c2:	69a2                	ld	s3,8(sp)
    800008c4:	6a02                	ld	s4,0(sp)
    800008c6:	6145                	addi	sp,sp,48
    800008c8:	8082                	ret

00000000800008ca <uvmfree>:
    800008ca:	1101                	addi	sp,sp,-32
    800008cc:	ec06                	sd	ra,24(sp)
    800008ce:	e822                	sd	s0,16(sp)
    800008d0:	e426                	sd	s1,8(sp)
    800008d2:	1000                	addi	s0,sp,32
    800008d4:	84aa                	mv	s1,a0
    800008d6:	e989                	bnez	a1,800008e8 <uvmfree+0x1e>
    800008d8:	8526                	mv	a0,s1
    800008da:	f91ff0ef          	jal	8000086a <freewalk>
    800008de:	60e2                	ld	ra,24(sp)
    800008e0:	6442                	ld	s0,16(sp)
    800008e2:	64a2                	ld	s1,8(sp)
    800008e4:	6105                	addi	sp,sp,32
    800008e6:	8082                	ret
    800008e8:	6785                	lui	a5,0x1
    800008ea:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008ec:	95be                	add	a1,a1,a5
    800008ee:	4685                	li	a3,1
    800008f0:	00c5d613          	srli	a2,a1,0xc
    800008f4:	4581                	li	a1,0
    800008f6:	d4bff0ef          	jal	80000640 <uvmunmap>
    800008fa:	bff9                	j	800008d8 <uvmfree+0xe>

00000000800008fc <uvmcopy>:
    800008fc:	c65d                	beqz	a2,800009aa <uvmcopy+0xae>
    800008fe:	715d                	addi	sp,sp,-80
    80000900:	e486                	sd	ra,72(sp)
    80000902:	e0a2                	sd	s0,64(sp)
    80000904:	fc26                	sd	s1,56(sp)
    80000906:	f84a                	sd	s2,48(sp)
    80000908:	f44e                	sd	s3,40(sp)
    8000090a:	f052                	sd	s4,32(sp)
    8000090c:	ec56                	sd	s5,24(sp)
    8000090e:	e85a                	sd	s6,16(sp)
    80000910:	e45e                	sd	s7,8(sp)
    80000912:	0880                	addi	s0,sp,80
    80000914:	8b2a                	mv	s6,a0
    80000916:	8aae                	mv	s5,a1
    80000918:	8a32                	mv	s4,a2
    8000091a:	4981                	li	s3,0
    8000091c:	4601                	li	a2,0
    8000091e:	85ce                	mv	a1,s3
    80000920:	855a                	mv	a0,s6
    80000922:	aa1ff0ef          	jal	800003c2 <walk>
    80000926:	c121                	beqz	a0,80000966 <uvmcopy+0x6a>
    80000928:	6118                	ld	a4,0(a0)
    8000092a:	00177793          	andi	a5,a4,1
    8000092e:	c3b1                	beqz	a5,80000972 <uvmcopy+0x76>
    80000930:	00a75593          	srli	a1,a4,0xa
    80000934:	00c59b93          	slli	s7,a1,0xc
    80000938:	3ff77493          	andi	s1,a4,1023
    8000093c:	fc2ff0ef          	jal	800000fe <kalloc>
    80000940:	892a                	mv	s2,a0
    80000942:	c129                	beqz	a0,80000984 <uvmcopy+0x88>
    80000944:	6605                	lui	a2,0x1
    80000946:	85de                	mv	a1,s7
    80000948:	863ff0ef          	jal	800001aa <memmove>
    8000094c:	8726                	mv	a4,s1
    8000094e:	86ca                	mv	a3,s2
    80000950:	6605                	lui	a2,0x1
    80000952:	85ce                	mv	a1,s3
    80000954:	8556                	mv	a0,s5
    80000956:	b45ff0ef          	jal	8000049a <mappages>
    8000095a:	e115                	bnez	a0,8000097e <uvmcopy+0x82>
    8000095c:	6785                	lui	a5,0x1
    8000095e:	99be                	add	s3,s3,a5
    80000960:	fb49eee3          	bltu	s3,s4,8000091c <uvmcopy+0x20>
    80000964:	a805                	j	80000994 <uvmcopy+0x98>
    80000966:	00006517          	auipc	a0,0x6
    8000096a:	7e250513          	addi	a0,a0,2018 # 80007148 <etext+0x148>
    8000096e:	295040ef          	jal	80005402 <panic>
    80000972:	00006517          	auipc	a0,0x6
    80000976:	7f650513          	addi	a0,a0,2038 # 80007168 <etext+0x168>
    8000097a:	289040ef          	jal	80005402 <panic>
    8000097e:	854a                	mv	a0,s2
    80000980:	e9cff0ef          	jal	8000001c <kfree>
    80000984:	4685                	li	a3,1
    80000986:	00c9d613          	srli	a2,s3,0xc
    8000098a:	4581                	li	a1,0
    8000098c:	8556                	mv	a0,s5
    8000098e:	cb3ff0ef          	jal	80000640 <uvmunmap>
    80000992:	557d                	li	a0,-1
    80000994:	60a6                	ld	ra,72(sp)
    80000996:	6406                	ld	s0,64(sp)
    80000998:	74e2                	ld	s1,56(sp)
    8000099a:	7942                	ld	s2,48(sp)
    8000099c:	79a2                	ld	s3,40(sp)
    8000099e:	7a02                	ld	s4,32(sp)
    800009a0:	6ae2                	ld	s5,24(sp)
    800009a2:	6b42                	ld	s6,16(sp)
    800009a4:	6ba2                	ld	s7,8(sp)
    800009a6:	6161                	addi	sp,sp,80
    800009a8:	8082                	ret
    800009aa:	4501                	li	a0,0
    800009ac:	8082                	ret

00000000800009ae <uvmclear>:
    800009ae:	1141                	addi	sp,sp,-16
    800009b0:	e406                	sd	ra,8(sp)
    800009b2:	e022                	sd	s0,0(sp)
    800009b4:	0800                	addi	s0,sp,16
    800009b6:	4601                	li	a2,0
    800009b8:	a0bff0ef          	jal	800003c2 <walk>
    800009bc:	c901                	beqz	a0,800009cc <uvmclear+0x1e>
    800009be:	611c                	ld	a5,0(a0)
    800009c0:	9bbd                	andi	a5,a5,-17
    800009c2:	e11c                	sd	a5,0(a0)
    800009c4:	60a2                	ld	ra,8(sp)
    800009c6:	6402                	ld	s0,0(sp)
    800009c8:	0141                	addi	sp,sp,16
    800009ca:	8082                	ret
    800009cc:	00006517          	auipc	a0,0x6
    800009d0:	7bc50513          	addi	a0,a0,1980 # 80007188 <etext+0x188>
    800009d4:	22f040ef          	jal	80005402 <panic>

00000000800009d8 <copyout>:
    800009d8:	cad1                	beqz	a3,80000a6c <copyout+0x94>
    800009da:	711d                	addi	sp,sp,-96
    800009dc:	ec86                	sd	ra,88(sp)
    800009de:	e8a2                	sd	s0,80(sp)
    800009e0:	e4a6                	sd	s1,72(sp)
    800009e2:	fc4e                	sd	s3,56(sp)
    800009e4:	f456                	sd	s5,40(sp)
    800009e6:	f05a                	sd	s6,32(sp)
    800009e8:	ec5e                	sd	s7,24(sp)
    800009ea:	1080                	addi	s0,sp,96
    800009ec:	8baa                	mv	s7,a0
    800009ee:	8aae                	mv	s5,a1
    800009f0:	8b32                	mv	s6,a2
    800009f2:	89b6                	mv	s3,a3
    800009f4:	74fd                	lui	s1,0xfffff
    800009f6:	8ced                	and	s1,s1,a1
    800009f8:	57fd                	li	a5,-1
    800009fa:	83e9                	srli	a5,a5,0x1a
    800009fc:	0697ea63          	bltu	a5,s1,80000a70 <copyout+0x98>
    80000a00:	e0ca                	sd	s2,64(sp)
    80000a02:	f852                	sd	s4,48(sp)
    80000a04:	e862                	sd	s8,16(sp)
    80000a06:	e466                	sd	s9,8(sp)
    80000a08:	e06a                	sd	s10,0(sp)
    80000a0a:	4cd5                	li	s9,21
    80000a0c:	6d05                	lui	s10,0x1
    80000a0e:	8c3e                	mv	s8,a5
    80000a10:	a025                	j	80000a38 <copyout+0x60>
    80000a12:	83a9                	srli	a5,a5,0xa
    80000a14:	07b2                	slli	a5,a5,0xc
    80000a16:	409a8533          	sub	a0,s5,s1
    80000a1a:	0009061b          	sext.w	a2,s2
    80000a1e:	85da                	mv	a1,s6
    80000a20:	953e                	add	a0,a0,a5
    80000a22:	f88ff0ef          	jal	800001aa <memmove>
    80000a26:	412989b3          	sub	s3,s3,s2
    80000a2a:	9b4a                	add	s6,s6,s2
    80000a2c:	02098963          	beqz	s3,80000a5e <copyout+0x86>
    80000a30:	054c6263          	bltu	s8,s4,80000a74 <copyout+0x9c>
    80000a34:	84d2                	mv	s1,s4
    80000a36:	8ad2                	mv	s5,s4
    80000a38:	4601                	li	a2,0
    80000a3a:	85a6                	mv	a1,s1
    80000a3c:	855e                	mv	a0,s7
    80000a3e:	985ff0ef          	jal	800003c2 <walk>
    80000a42:	c121                	beqz	a0,80000a82 <copyout+0xaa>
    80000a44:	611c                	ld	a5,0(a0)
    80000a46:	0157f713          	andi	a4,a5,21
    80000a4a:	05971b63          	bne	a4,s9,80000aa0 <copyout+0xc8>
    80000a4e:	01a48a33          	add	s4,s1,s10
    80000a52:	415a0933          	sub	s2,s4,s5
    80000a56:	fb29fee3          	bgeu	s3,s2,80000a12 <copyout+0x3a>
    80000a5a:	894e                	mv	s2,s3
    80000a5c:	bf5d                	j	80000a12 <copyout+0x3a>
    80000a5e:	4501                	li	a0,0
    80000a60:	6906                	ld	s2,64(sp)
    80000a62:	7a42                	ld	s4,48(sp)
    80000a64:	6c42                	ld	s8,16(sp)
    80000a66:	6ca2                	ld	s9,8(sp)
    80000a68:	6d02                	ld	s10,0(sp)
    80000a6a:	a015                	j	80000a8e <copyout+0xb6>
    80000a6c:	4501                	li	a0,0
    80000a6e:	8082                	ret
    80000a70:	557d                	li	a0,-1
    80000a72:	a831                	j	80000a8e <copyout+0xb6>
    80000a74:	557d                	li	a0,-1
    80000a76:	6906                	ld	s2,64(sp)
    80000a78:	7a42                	ld	s4,48(sp)
    80000a7a:	6c42                	ld	s8,16(sp)
    80000a7c:	6ca2                	ld	s9,8(sp)
    80000a7e:	6d02                	ld	s10,0(sp)
    80000a80:	a039                	j	80000a8e <copyout+0xb6>
    80000a82:	557d                	li	a0,-1
    80000a84:	6906                	ld	s2,64(sp)
    80000a86:	7a42                	ld	s4,48(sp)
    80000a88:	6c42                	ld	s8,16(sp)
    80000a8a:	6ca2                	ld	s9,8(sp)
    80000a8c:	6d02                	ld	s10,0(sp)
    80000a8e:	60e6                	ld	ra,88(sp)
    80000a90:	6446                	ld	s0,80(sp)
    80000a92:	64a6                	ld	s1,72(sp)
    80000a94:	79e2                	ld	s3,56(sp)
    80000a96:	7aa2                	ld	s5,40(sp)
    80000a98:	7b02                	ld	s6,32(sp)
    80000a9a:	6be2                	ld	s7,24(sp)
    80000a9c:	6125                	addi	sp,sp,96
    80000a9e:	8082                	ret
    80000aa0:	557d                	li	a0,-1
    80000aa2:	6906                	ld	s2,64(sp)
    80000aa4:	7a42                	ld	s4,48(sp)
    80000aa6:	6c42                	ld	s8,16(sp)
    80000aa8:	6ca2                	ld	s9,8(sp)
    80000aaa:	6d02                	ld	s10,0(sp)
    80000aac:	b7cd                	j	80000a8e <copyout+0xb6>

0000000080000aae <copyin>:
    80000aae:	c6a5                	beqz	a3,80000b16 <copyin+0x68>
    80000ab0:	715d                	addi	sp,sp,-80
    80000ab2:	e486                	sd	ra,72(sp)
    80000ab4:	e0a2                	sd	s0,64(sp)
    80000ab6:	fc26                	sd	s1,56(sp)
    80000ab8:	f84a                	sd	s2,48(sp)
    80000aba:	f44e                	sd	s3,40(sp)
    80000abc:	f052                	sd	s4,32(sp)
    80000abe:	ec56                	sd	s5,24(sp)
    80000ac0:	e85a                	sd	s6,16(sp)
    80000ac2:	e45e                	sd	s7,8(sp)
    80000ac4:	e062                	sd	s8,0(sp)
    80000ac6:	0880                	addi	s0,sp,80
    80000ac8:	8b2a                	mv	s6,a0
    80000aca:	8a2e                	mv	s4,a1
    80000acc:	8c32                	mv	s8,a2
    80000ace:	89b6                	mv	s3,a3
    80000ad0:	7bfd                	lui	s7,0xfffff
    80000ad2:	6a85                	lui	s5,0x1
    80000ad4:	a00d                	j	80000af6 <copyin+0x48>
    80000ad6:	018505b3          	add	a1,a0,s8
    80000ada:	0004861b          	sext.w	a2,s1
    80000ade:	412585b3          	sub	a1,a1,s2
    80000ae2:	8552                	mv	a0,s4
    80000ae4:	ec6ff0ef          	jal	800001aa <memmove>
    80000ae8:	409989b3          	sub	s3,s3,s1
    80000aec:	9a26                	add	s4,s4,s1
    80000aee:	01590c33          	add	s8,s2,s5
    80000af2:	02098063          	beqz	s3,80000b12 <copyin+0x64>
    80000af6:	017c7933          	and	s2,s8,s7
    80000afa:	85ca                	mv	a1,s2
    80000afc:	855a                	mv	a0,s6
    80000afe:	95fff0ef          	jal	8000045c <walkaddr>
    80000b02:	cd01                	beqz	a0,80000b1a <copyin+0x6c>
    80000b04:	418904b3          	sub	s1,s2,s8
    80000b08:	94d6                	add	s1,s1,s5
    80000b0a:	fc99f6e3          	bgeu	s3,s1,80000ad6 <copyin+0x28>
    80000b0e:	84ce                	mv	s1,s3
    80000b10:	b7d9                	j	80000ad6 <copyin+0x28>
    80000b12:	4501                	li	a0,0
    80000b14:	a021                	j	80000b1c <copyin+0x6e>
    80000b16:	4501                	li	a0,0
    80000b18:	8082                	ret
    80000b1a:	557d                	li	a0,-1
    80000b1c:	60a6                	ld	ra,72(sp)
    80000b1e:	6406                	ld	s0,64(sp)
    80000b20:	74e2                	ld	s1,56(sp)
    80000b22:	7942                	ld	s2,48(sp)
    80000b24:	79a2                	ld	s3,40(sp)
    80000b26:	7a02                	ld	s4,32(sp)
    80000b28:	6ae2                	ld	s5,24(sp)
    80000b2a:	6b42                	ld	s6,16(sp)
    80000b2c:	6ba2                	ld	s7,8(sp)
    80000b2e:	6c02                	ld	s8,0(sp)
    80000b30:	6161                	addi	sp,sp,80
    80000b32:	8082                	ret

0000000080000b34 <copyinstr>:
    80000b34:	c6dd                	beqz	a3,80000be2 <copyinstr+0xae>
    80000b36:	715d                	addi	sp,sp,-80
    80000b38:	e486                	sd	ra,72(sp)
    80000b3a:	e0a2                	sd	s0,64(sp)
    80000b3c:	fc26                	sd	s1,56(sp)
    80000b3e:	f84a                	sd	s2,48(sp)
    80000b40:	f44e                	sd	s3,40(sp)
    80000b42:	f052                	sd	s4,32(sp)
    80000b44:	ec56                	sd	s5,24(sp)
    80000b46:	e85a                	sd	s6,16(sp)
    80000b48:	e45e                	sd	s7,8(sp)
    80000b4a:	0880                	addi	s0,sp,80
    80000b4c:	8a2a                	mv	s4,a0
    80000b4e:	8b2e                	mv	s6,a1
    80000b50:	8bb2                	mv	s7,a2
    80000b52:	8936                	mv	s2,a3
    80000b54:	7afd                	lui	s5,0xfffff
    80000b56:	6985                	lui	s3,0x1
    80000b58:	a825                	j	80000b90 <copyinstr+0x5c>
    80000b5a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b5e:	4785                	li	a5,1
    80000b60:	37fd                	addiw	a5,a5,-1
    80000b62:	0007851b          	sext.w	a0,a5
    80000b66:	60a6                	ld	ra,72(sp)
    80000b68:	6406                	ld	s0,64(sp)
    80000b6a:	74e2                	ld	s1,56(sp)
    80000b6c:	7942                	ld	s2,48(sp)
    80000b6e:	79a2                	ld	s3,40(sp)
    80000b70:	7a02                	ld	s4,32(sp)
    80000b72:	6ae2                	ld	s5,24(sp)
    80000b74:	6b42                	ld	s6,16(sp)
    80000b76:	6ba2                	ld	s7,8(sp)
    80000b78:	6161                	addi	sp,sp,80
    80000b7a:	8082                	ret
    80000b7c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000b80:	9742                	add	a4,a4,a6
    80000b82:	40b70933          	sub	s2,a4,a1
    80000b86:	01348bb3          	add	s7,s1,s3
    80000b8a:	04e58463          	beq	a1,a4,80000bd2 <copyinstr+0x9e>
    80000b8e:	8b3e                	mv	s6,a5
    80000b90:	015bf4b3          	and	s1,s7,s5
    80000b94:	85a6                	mv	a1,s1
    80000b96:	8552                	mv	a0,s4
    80000b98:	8c5ff0ef          	jal	8000045c <walkaddr>
    80000b9c:	cd0d                	beqz	a0,80000bd6 <copyinstr+0xa2>
    80000b9e:	417486b3          	sub	a3,s1,s7
    80000ba2:	96ce                	add	a3,a3,s3
    80000ba4:	00d97363          	bgeu	s2,a3,80000baa <copyinstr+0x76>
    80000ba8:	86ca                	mv	a3,s2
    80000baa:	955e                	add	a0,a0,s7
    80000bac:	8d05                	sub	a0,a0,s1
    80000bae:	c695                	beqz	a3,80000bda <copyinstr+0xa6>
    80000bb0:	87da                	mv	a5,s6
    80000bb2:	885a                	mv	a6,s6
    80000bb4:	41650633          	sub	a2,a0,s6
    80000bb8:	96da                	add	a3,a3,s6
    80000bba:	85be                	mv	a1,a5
    80000bbc:	00f60733          	add	a4,a2,a5
    80000bc0:	00074703          	lbu	a4,0(a4)
    80000bc4:	db59                	beqz	a4,80000b5a <copyinstr+0x26>
    80000bc6:	00e78023          	sb	a4,0(a5)
    80000bca:	0785                	addi	a5,a5,1
    80000bcc:	fed797e3          	bne	a5,a3,80000bba <copyinstr+0x86>
    80000bd0:	b775                	j	80000b7c <copyinstr+0x48>
    80000bd2:	4781                	li	a5,0
    80000bd4:	b771                	j	80000b60 <copyinstr+0x2c>
    80000bd6:	557d                	li	a0,-1
    80000bd8:	b779                	j	80000b66 <copyinstr+0x32>
    80000bda:	6b85                	lui	s7,0x1
    80000bdc:	9ba6                	add	s7,s7,s1
    80000bde:	87da                	mv	a5,s6
    80000be0:	b77d                	j	80000b8e <copyinstr+0x5a>
    80000be2:	4781                	li	a5,0
    80000be4:	37fd                	addiw	a5,a5,-1
    80000be6:	0007851b          	sext.w	a0,a5
    80000bea:	8082                	ret

0000000080000bec <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bec:	7139                	addi	sp,sp,-64
    80000bee:	fc06                	sd	ra,56(sp)
    80000bf0:	f822                	sd	s0,48(sp)
    80000bf2:	f426                	sd	s1,40(sp)
    80000bf4:	f04a                	sd	s2,32(sp)
    80000bf6:	ec4e                	sd	s3,24(sp)
    80000bf8:	e852                	sd	s4,16(sp)
    80000bfa:	e456                	sd	s5,8(sp)
    80000bfc:	e05a                	sd	s6,0(sp)
    80000bfe:	0080                	addi	s0,sp,64
    80000c00:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c02:	0000a497          	auipc	s1,0xa
    80000c06:	a5e48493          	addi	s1,s1,-1442 # 8000a660 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c0a:	8b26                	mv	s6,s1
    80000c0c:	004fd937          	lui	s2,0x4fd
    80000c10:	3f590913          	addi	s2,s2,1013 # 4fd3f5 <_entry-0x7fb02c0b>
    80000c14:	0942                	slli	s2,s2,0x10
    80000c16:	d3f90913          	addi	s2,s2,-705
    80000c1a:	0932                	slli	s2,s2,0xc
    80000c1c:	4fd90913          	addi	s2,s2,1277
    80000c20:	0932                	slli	s2,s2,0xc
    80000c22:	3f590913          	addi	s2,s2,1013
    80000c26:	040009b7          	lui	s3,0x4000
    80000c2a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c2c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c2e:	00015a97          	auipc	s5,0x15
    80000c32:	432a8a93          	addi	s5,s5,1074 # 80016060 <tickslock>
    char *pa = kalloc();
    80000c36:	cc8ff0ef          	jal	800000fe <kalloc>
    80000c3a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c3c:	cd15                	beqz	a0,80000c78 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c3e:	416485b3          	sub	a1,s1,s6
    80000c42:	858d                	srai	a1,a1,0x3
    80000c44:	032585b3          	mul	a1,a1,s2
    80000c48:	2585                	addiw	a1,a1,1
    80000c4a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c4e:	4719                	li	a4,6
    80000c50:	6685                	lui	a3,0x1
    80000c52:	40b985b3          	sub	a1,s3,a1
    80000c56:	8552                	mv	a0,s4
    80000c58:	8f3ff0ef          	jal	8000054a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c5c:	2e848493          	addi	s1,s1,744
    80000c60:	fd549be3          	bne	s1,s5,80000c36 <proc_mapstacks+0x4a>
  }
}
    80000c64:	70e2                	ld	ra,56(sp)
    80000c66:	7442                	ld	s0,48(sp)
    80000c68:	74a2                	ld	s1,40(sp)
    80000c6a:	7902                	ld	s2,32(sp)
    80000c6c:	69e2                	ld	s3,24(sp)
    80000c6e:	6a42                	ld	s4,16(sp)
    80000c70:	6aa2                	ld	s5,8(sp)
    80000c72:	6b02                	ld	s6,0(sp)
    80000c74:	6121                	addi	sp,sp,64
    80000c76:	8082                	ret
      panic("kalloc");
    80000c78:	00006517          	auipc	a0,0x6
    80000c7c:	52050513          	addi	a0,a0,1312 # 80007198 <etext+0x198>
    80000c80:	782040ef          	jal	80005402 <panic>

0000000080000c84 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c84:	7139                	addi	sp,sp,-64
    80000c86:	fc06                	sd	ra,56(sp)
    80000c88:	f822                	sd	s0,48(sp)
    80000c8a:	f426                	sd	s1,40(sp)
    80000c8c:	f04a                	sd	s2,32(sp)
    80000c8e:	ec4e                	sd	s3,24(sp)
    80000c90:	e852                	sd	s4,16(sp)
    80000c92:	e456                	sd	s5,8(sp)
    80000c94:	e05a                	sd	s6,0(sp)
    80000c96:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c98:	00006597          	auipc	a1,0x6
    80000c9c:	50858593          	addi	a1,a1,1288 # 800071a0 <etext+0x1a0>
    80000ca0:	00009517          	auipc	a0,0x9
    80000ca4:	59050513          	addi	a0,a0,1424 # 8000a230 <pid_lock>
    80000ca8:	209040ef          	jal	800056b0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cac:	00006597          	auipc	a1,0x6
    80000cb0:	4fc58593          	addi	a1,a1,1276 # 800071a8 <etext+0x1a8>
    80000cb4:	00009517          	auipc	a0,0x9
    80000cb8:	59450513          	addi	a0,a0,1428 # 8000a248 <wait_lock>
    80000cbc:	1f5040ef          	jal	800056b0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cc0:	0000a497          	auipc	s1,0xa
    80000cc4:	9a048493          	addi	s1,s1,-1632 # 8000a660 <proc>
      initlock(&p->lock, "proc");
    80000cc8:	00006b17          	auipc	s6,0x6
    80000ccc:	4f0b0b13          	addi	s6,s6,1264 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cd0:	8aa6                	mv	s5,s1
    80000cd2:	004fd937          	lui	s2,0x4fd
    80000cd6:	3f590913          	addi	s2,s2,1013 # 4fd3f5 <_entry-0x7fb02c0b>
    80000cda:	0942                	slli	s2,s2,0x10
    80000cdc:	d3f90913          	addi	s2,s2,-705
    80000ce0:	0932                	slli	s2,s2,0xc
    80000ce2:	4fd90913          	addi	s2,s2,1277
    80000ce6:	0932                	slli	s2,s2,0xc
    80000ce8:	3f590913          	addi	s2,s2,1013
    80000cec:	040009b7          	lui	s3,0x4000
    80000cf0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000cf2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	00015a17          	auipc	s4,0x15
    80000cf8:	36ca0a13          	addi	s4,s4,876 # 80016060 <tickslock>
      initlock(&p->lock, "proc");
    80000cfc:	85da                	mv	a1,s6
    80000cfe:	8526                	mv	a0,s1
    80000d00:	1b1040ef          	jal	800056b0 <initlock>
      p->state = UNUSED;
    80000d04:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d08:	415487b3          	sub	a5,s1,s5
    80000d0c:	878d                	srai	a5,a5,0x3
    80000d0e:	032787b3          	mul	a5,a5,s2
    80000d12:	2785                	addiw	a5,a5,1
    80000d14:	00d7979b          	slliw	a5,a5,0xd
    80000d18:	40f987b3          	sub	a5,s3,a5
    80000d1c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d1e:	2e848493          	addi	s1,s1,744
    80000d22:	fd449de3          	bne	s1,s4,80000cfc <procinit+0x78>
  }
}
    80000d26:	70e2                	ld	ra,56(sp)
    80000d28:	7442                	ld	s0,48(sp)
    80000d2a:	74a2                	ld	s1,40(sp)
    80000d2c:	7902                	ld	s2,32(sp)
    80000d2e:	69e2                	ld	s3,24(sp)
    80000d30:	6a42                	ld	s4,16(sp)
    80000d32:	6aa2                	ld	s5,8(sp)
    80000d34:	6b02                	ld	s6,0(sp)
    80000d36:	6121                	addi	sp,sp,64
    80000d38:	8082                	ret

0000000080000d3a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d3a:	1141                	addi	sp,sp,-16
    80000d3c:	e422                	sd	s0,8(sp)
    80000d3e:	0800                	addi	s0,sp,16
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d40:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d42:	2501                	sext.w	a0,a0
    80000d44:	6422                	ld	s0,8(sp)
    80000d46:	0141                	addi	sp,sp,16
    80000d48:	8082                	ret

0000000080000d4a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d4a:	1141                	addi	sp,sp,-16
    80000d4c:	e422                	sd	s0,8(sp)
    80000d4e:	0800                	addi	s0,sp,16
    80000d50:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d52:	2781                	sext.w	a5,a5
    80000d54:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d56:	00009517          	auipc	a0,0x9
    80000d5a:	50a50513          	addi	a0,a0,1290 # 8000a260 <cpus>
    80000d5e:	953e                	add	a0,a0,a5
    80000d60:	6422                	ld	s0,8(sp)
    80000d62:	0141                	addi	sp,sp,16
    80000d64:	8082                	ret

0000000080000d66 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d66:	1101                	addi	sp,sp,-32
    80000d68:	ec06                	sd	ra,24(sp)
    80000d6a:	e822                	sd	s0,16(sp)
    80000d6c:	e426                	sd	s1,8(sp)
    80000d6e:	1000                	addi	s0,sp,32
  push_off();
    80000d70:	181040ef          	jal	800056f0 <push_off>
    80000d74:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d76:	2781                	sext.w	a5,a5
    80000d78:	079e                	slli	a5,a5,0x7
    80000d7a:	00009717          	auipc	a4,0x9
    80000d7e:	4b670713          	addi	a4,a4,1206 # 8000a230 <pid_lock>
    80000d82:	97ba                	add	a5,a5,a4
    80000d84:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d86:	1ef040ef          	jal	80005774 <pop_off>
  return p;
}
    80000d8a:	8526                	mv	a0,s1
    80000d8c:	60e2                	ld	ra,24(sp)
    80000d8e:	6442                	ld	s0,16(sp)
    80000d90:	64a2                	ld	s1,8(sp)
    80000d92:	6105                	addi	sp,sp,32
    80000d94:	8082                	ret

0000000080000d96 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d96:	1141                	addi	sp,sp,-16
    80000d98:	e406                	sd	ra,8(sp)
    80000d9a:	e022                	sd	s0,0(sp)
    80000d9c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d9e:	fc9ff0ef          	jal	80000d66 <myproc>
    80000da2:	227040ef          	jal	800057c8 <release>

  if (first) {
    80000da6:	00009797          	auipc	a5,0x9
    80000daa:	3ca7a783          	lw	a5,970(a5) # 8000a170 <first.1>
    80000dae:	e799                	bnez	a5,80000dbc <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000db0:	2bf000ef          	jal	8000186e <usertrapret>
}
    80000db4:	60a2                	ld	ra,8(sp)
    80000db6:	6402                	ld	s0,0(sp)
    80000db8:	0141                	addi	sp,sp,16
    80000dba:	8082                	ret
    fsinit(ROOTDEV);
    80000dbc:	4505                	li	a0,1
    80000dbe:	654010ef          	jal	80002412 <fsinit>
    first = 0;
    80000dc2:	00009797          	auipc	a5,0x9
    80000dc6:	3a07a723          	sw	zero,942(a5) # 8000a170 <first.1>
    __sync_synchronize();
    80000dca:	0330000f          	fence	rw,rw
    80000dce:	b7cd                	j	80000db0 <forkret+0x1a>

0000000080000dd0 <allocpid>:
{
    80000dd0:	1101                	addi	sp,sp,-32
    80000dd2:	ec06                	sd	ra,24(sp)
    80000dd4:	e822                	sd	s0,16(sp)
    80000dd6:	e426                	sd	s1,8(sp)
    80000dd8:	e04a                	sd	s2,0(sp)
    80000dda:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ddc:	00009917          	auipc	s2,0x9
    80000de0:	45490913          	addi	s2,s2,1108 # 8000a230 <pid_lock>
    80000de4:	854a                	mv	a0,s2
    80000de6:	14b040ef          	jal	80005730 <acquire>
  pid = nextpid;
    80000dea:	00009797          	auipc	a5,0x9
    80000dee:	38a78793          	addi	a5,a5,906 # 8000a174 <nextpid>
    80000df2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000df4:	0014871b          	addiw	a4,s1,1
    80000df8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dfa:	854a                	mv	a0,s2
    80000dfc:	1cd040ef          	jal	800057c8 <release>
}
    80000e00:	8526                	mv	a0,s1
    80000e02:	60e2                	ld	ra,24(sp)
    80000e04:	6442                	ld	s0,16(sp)
    80000e06:	64a2                	ld	s1,8(sp)
    80000e08:	6902                	ld	s2,0(sp)
    80000e0a:	6105                	addi	sp,sp,32
    80000e0c:	8082                	ret

0000000080000e0e <proc_pagetable>:
{
    80000e0e:	1101                	addi	sp,sp,-32
    80000e10:	ec06                	sd	ra,24(sp)
    80000e12:	e822                	sd	s0,16(sp)
    80000e14:	e426                	sd	s1,8(sp)
    80000e16:	e04a                	sd	s2,0(sp)
    80000e18:	1000                	addi	s0,sp,32
    80000e1a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e1c:	8e1ff0ef          	jal	800006fc <uvmcreate>
    80000e20:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e22:	cd05                	beqz	a0,80000e5a <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e24:	4729                	li	a4,10
    80000e26:	00005697          	auipc	a3,0x5
    80000e2a:	1da68693          	addi	a3,a3,474 # 80006000 <_trampoline>
    80000e2e:	6605                	lui	a2,0x1
    80000e30:	040005b7          	lui	a1,0x4000
    80000e34:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e36:	05b2                	slli	a1,a1,0xc
    80000e38:	e62ff0ef          	jal	8000049a <mappages>
    80000e3c:	02054663          	bltz	a0,80000e68 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e40:	4719                	li	a4,6
    80000e42:	05893683          	ld	a3,88(s2)
    80000e46:	6605                	lui	a2,0x1
    80000e48:	020005b7          	lui	a1,0x2000
    80000e4c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e4e:	05b6                	slli	a1,a1,0xd
    80000e50:	8526                	mv	a0,s1
    80000e52:	e48ff0ef          	jal	8000049a <mappages>
    80000e56:	00054f63          	bltz	a0,80000e74 <proc_pagetable+0x66>
}
    80000e5a:	8526                	mv	a0,s1
    80000e5c:	60e2                	ld	ra,24(sp)
    80000e5e:	6442                	ld	s0,16(sp)
    80000e60:	64a2                	ld	s1,8(sp)
    80000e62:	6902                	ld	s2,0(sp)
    80000e64:	6105                	addi	sp,sp,32
    80000e66:	8082                	ret
    uvmfree(pagetable, 0);
    80000e68:	4581                	li	a1,0
    80000e6a:	8526                	mv	a0,s1
    80000e6c:	a5fff0ef          	jal	800008ca <uvmfree>
    return 0;
    80000e70:	4481                	li	s1,0
    80000e72:	b7e5                	j	80000e5a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e74:	4681                	li	a3,0
    80000e76:	4605                	li	a2,1
    80000e78:	040005b7          	lui	a1,0x4000
    80000e7c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e7e:	05b2                	slli	a1,a1,0xc
    80000e80:	8526                	mv	a0,s1
    80000e82:	fbeff0ef          	jal	80000640 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e86:	4581                	li	a1,0
    80000e88:	8526                	mv	a0,s1
    80000e8a:	a41ff0ef          	jal	800008ca <uvmfree>
    return 0;
    80000e8e:	4481                	li	s1,0
    80000e90:	b7e9                	j	80000e5a <proc_pagetable+0x4c>

0000000080000e92 <proc_freepagetable>:
{
    80000e92:	1101                	addi	sp,sp,-32
    80000e94:	ec06                	sd	ra,24(sp)
    80000e96:	e822                	sd	s0,16(sp)
    80000e98:	e426                	sd	s1,8(sp)
    80000e9a:	e04a                	sd	s2,0(sp)
    80000e9c:	1000                	addi	s0,sp,32
    80000e9e:	84aa                	mv	s1,a0
    80000ea0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ea2:	4681                	li	a3,0
    80000ea4:	4605                	li	a2,1
    80000ea6:	040005b7          	lui	a1,0x4000
    80000eaa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eac:	05b2                	slli	a1,a1,0xc
    80000eae:	f92ff0ef          	jal	80000640 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000eb2:	4681                	li	a3,0
    80000eb4:	4605                	li	a2,1
    80000eb6:	020005b7          	lui	a1,0x2000
    80000eba:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ebc:	05b6                	slli	a1,a1,0xd
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	f80ff0ef          	jal	80000640 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ec4:	85ca                	mv	a1,s2
    80000ec6:	8526                	mv	a0,s1
    80000ec8:	a03ff0ef          	jal	800008ca <uvmfree>
}
    80000ecc:	60e2                	ld	ra,24(sp)
    80000ece:	6442                	ld	s0,16(sp)
    80000ed0:	64a2                	ld	s1,8(sp)
    80000ed2:	6902                	ld	s2,0(sp)
    80000ed4:	6105                	addi	sp,sp,32
    80000ed6:	8082                	ret

0000000080000ed8 <freeproc>:
{
    80000ed8:	1101                	addi	sp,sp,-32
    80000eda:	ec06                	sd	ra,24(sp)
    80000edc:	e822                	sd	s0,16(sp)
    80000ede:	e426                	sd	s1,8(sp)
    80000ee0:	1000                	addi	s0,sp,32
    80000ee2:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ee4:	6d28                	ld	a0,88(a0)
    80000ee6:	c119                	beqz	a0,80000eec <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000ee8:	934ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000eec:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ef0:	68a8                	ld	a0,80(s1)
    80000ef2:	c501                	beqz	a0,80000efa <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000ef4:	64ac                	ld	a1,72(s1)
    80000ef6:	f9dff0ef          	jal	80000e92 <proc_freepagetable>
  p->pagetable = 0;
    80000efa:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000efe:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f02:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f06:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f0a:	2c048c23          	sb	zero,728(s1)
  p->chan = 0;
    80000f0e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f12:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f16:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f1a:	0004ac23          	sw	zero,24(s1)
}
    80000f1e:	60e2                	ld	ra,24(sp)
    80000f20:	6442                	ld	s0,16(sp)
    80000f22:	64a2                	ld	s1,8(sp)
    80000f24:	6105                	addi	sp,sp,32
    80000f26:	8082                	ret

0000000080000f28 <allocproc>:
{
    80000f28:	1101                	addi	sp,sp,-32
    80000f2a:	ec06                	sd	ra,24(sp)
    80000f2c:	e822                	sd	s0,16(sp)
    80000f2e:	e426                	sd	s1,8(sp)
    80000f30:	e04a                	sd	s2,0(sp)
    80000f32:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f34:	00009497          	auipc	s1,0x9
    80000f38:	72c48493          	addi	s1,s1,1836 # 8000a660 <proc>
    80000f3c:	00015917          	auipc	s2,0x15
    80000f40:	12490913          	addi	s2,s2,292 # 80016060 <tickslock>
    acquire(&p->lock);
    80000f44:	8526                	mv	a0,s1
    80000f46:	7ea040ef          	jal	80005730 <acquire>
    if(p->state == UNUSED) {
    80000f4a:	4c9c                	lw	a5,24(s1)
    80000f4c:	cb91                	beqz	a5,80000f60 <allocproc+0x38>
      release(&p->lock);
    80000f4e:	8526                	mv	a0,s1
    80000f50:	079040ef          	jal	800057c8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f54:	2e848493          	addi	s1,s1,744
    80000f58:	ff2496e3          	bne	s1,s2,80000f44 <allocproc+0x1c>
  return 0;
    80000f5c:	4481                	li	s1,0
    80000f5e:	a089                	j	80000fa0 <allocproc+0x78>
  p->pid = allocpid();
    80000f60:	e71ff0ef          	jal	80000dd0 <allocpid>
    80000f64:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f66:	4785                	li	a5,1
    80000f68:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f6a:	994ff0ef          	jal	800000fe <kalloc>
    80000f6e:	892a                	mv	s2,a0
    80000f70:	eca8                	sd	a0,88(s1)
    80000f72:	cd15                	beqz	a0,80000fae <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f74:	8526                	mv	a0,s1
    80000f76:	e99ff0ef          	jal	80000e0e <proc_pagetable>
    80000f7a:	892a                	mv	s2,a0
    80000f7c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f7e:	c121                	beqz	a0,80000fbe <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000f80:	07000613          	li	a2,112
    80000f84:	4581                	li	a1,0
    80000f86:	06048513          	addi	a0,s1,96
    80000f8a:	9c4ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80000f8e:	00000797          	auipc	a5,0x0
    80000f92:	e0878793          	addi	a5,a5,-504 # 80000d96 <forkret>
    80000f96:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f98:	60bc                	ld	a5,64(s1)
    80000f9a:	6705                	lui	a4,0x1
    80000f9c:	97ba                	add	a5,a5,a4
    80000f9e:	f4bc                	sd	a5,104(s1)
}
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	60e2                	ld	ra,24(sp)
    80000fa4:	6442                	ld	s0,16(sp)
    80000fa6:	64a2                	ld	s1,8(sp)
    80000fa8:	6902                	ld	s2,0(sp)
    80000faa:	6105                	addi	sp,sp,32
    80000fac:	8082                	ret
    freeproc(p);
    80000fae:	8526                	mv	a0,s1
    80000fb0:	f29ff0ef          	jal	80000ed8 <freeproc>
    release(&p->lock);
    80000fb4:	8526                	mv	a0,s1
    80000fb6:	013040ef          	jal	800057c8 <release>
    return 0;
    80000fba:	84ca                	mv	s1,s2
    80000fbc:	b7d5                	j	80000fa0 <allocproc+0x78>
    freeproc(p);
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	f19ff0ef          	jal	80000ed8 <freeproc>
    release(&p->lock);
    80000fc4:	8526                	mv	a0,s1
    80000fc6:	003040ef          	jal	800057c8 <release>
    return 0;
    80000fca:	84ca                	mv	s1,s2
    80000fcc:	bfd1                	j	80000fa0 <allocproc+0x78>

0000000080000fce <userinit>:
{
    80000fce:	1101                	addi	sp,sp,-32
    80000fd0:	ec06                	sd	ra,24(sp)
    80000fd2:	e822                	sd	s0,16(sp)
    80000fd4:	e426                	sd	s1,8(sp)
    80000fd6:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fd8:	f51ff0ef          	jal	80000f28 <allocproc>
    80000fdc:	84aa                	mv	s1,a0
  initproc = p;
    80000fde:	00009797          	auipc	a5,0x9
    80000fe2:	20a7b923          	sd	a0,530(a5) # 8000a1f0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fe6:	03400613          	li	a2,52
    80000fea:	00009597          	auipc	a1,0x9
    80000fee:	19658593          	addi	a1,a1,406 # 8000a180 <initcode>
    80000ff2:	6928                	ld	a0,80(a0)
    80000ff4:	f2eff0ef          	jal	80000722 <uvmfirst>
  p->sz = PGSIZE;
    80000ff8:	6785                	lui	a5,0x1
    80000ffa:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000ffc:	6cb8                	ld	a4,88(s1)
    80000ffe:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001002:	6cb8                	ld	a4,88(s1)
    80001004:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001006:	4641                	li	a2,16
    80001008:	00006597          	auipc	a1,0x6
    8000100c:	1b858593          	addi	a1,a1,440 # 800071c0 <etext+0x1c0>
    80001010:	2d848513          	addi	a0,s1,728
    80001014:	a78ff0ef          	jal	8000028c <safestrcpy>
  p->cwd = namei("/");
    80001018:	00006517          	auipc	a0,0x6
    8000101c:	1b850513          	addi	a0,a0,440 # 800071d0 <etext+0x1d0>
    80001020:	501010ef          	jal	80002d20 <namei>
    80001024:	2ca4b823          	sd	a0,720(s1)
  p->state = RUNNABLE;
    80001028:	478d                	li	a5,3
    8000102a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000102c:	8526                	mv	a0,s1
    8000102e:	79a040ef          	jal	800057c8 <release>
}
    80001032:	60e2                	ld	ra,24(sp)
    80001034:	6442                	ld	s0,16(sp)
    80001036:	64a2                	ld	s1,8(sp)
    80001038:	6105                	addi	sp,sp,32
    8000103a:	8082                	ret

000000008000103c <growproc>:
{
    8000103c:	1101                	addi	sp,sp,-32
    8000103e:	ec06                	sd	ra,24(sp)
    80001040:	e822                	sd	s0,16(sp)
    80001042:	e426                	sd	s1,8(sp)
    80001044:	e04a                	sd	s2,0(sp)
    80001046:	1000                	addi	s0,sp,32
    80001048:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000104a:	d1dff0ef          	jal	80000d66 <myproc>
    8000104e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001050:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001052:	01204c63          	bgtz	s2,8000106a <growproc+0x2e>
  } else if(n < 0){
    80001056:	02094463          	bltz	s2,8000107e <growproc+0x42>
  p->sz = sz;
    8000105a:	e4ac                	sd	a1,72(s1)
  return 0;
    8000105c:	4501                	li	a0,0
}
    8000105e:	60e2                	ld	ra,24(sp)
    80001060:	6442                	ld	s0,16(sp)
    80001062:	64a2                	ld	s1,8(sp)
    80001064:	6902                	ld	s2,0(sp)
    80001066:	6105                	addi	sp,sp,32
    80001068:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000106a:	4691                	li	a3,4
    8000106c:	00b90633          	add	a2,s2,a1
    80001070:	6928                	ld	a0,80(a0)
    80001072:	f52ff0ef          	jal	800007c4 <uvmalloc>
    80001076:	85aa                	mv	a1,a0
    80001078:	f16d                	bnez	a0,8000105a <growproc+0x1e>
      return -1;
    8000107a:	557d                	li	a0,-1
    8000107c:	b7cd                	j	8000105e <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000107e:	00b90633          	add	a2,s2,a1
    80001082:	6928                	ld	a0,80(a0)
    80001084:	efcff0ef          	jal	80000780 <uvmdealloc>
    80001088:	85aa                	mv	a1,a0
    8000108a:	bfc1                	j	8000105a <growproc+0x1e>

000000008000108c <fork>:
{
    8000108c:	7139                	addi	sp,sp,-64
    8000108e:	fc06                	sd	ra,56(sp)
    80001090:	f822                	sd	s0,48(sp)
    80001092:	f04a                	sd	s2,32(sp)
    80001094:	e456                	sd	s5,8(sp)
    80001096:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001098:	ccfff0ef          	jal	80000d66 <myproc>
    8000109c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000109e:	e8bff0ef          	jal	80000f28 <allocproc>
    800010a2:	0e050a63          	beqz	a0,80001196 <fork+0x10a>
    800010a6:	e852                	sd	s4,16(sp)
    800010a8:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010aa:	048ab603          	ld	a2,72(s5)
    800010ae:	692c                	ld	a1,80(a0)
    800010b0:	050ab503          	ld	a0,80(s5)
    800010b4:	849ff0ef          	jal	800008fc <uvmcopy>
    800010b8:	04054a63          	bltz	a0,8000110c <fork+0x80>
    800010bc:	f426                	sd	s1,40(sp)
    800010be:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800010c0:	048ab783          	ld	a5,72(s5)
    800010c4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010c8:	058ab683          	ld	a3,88(s5)
    800010cc:	87b6                	mv	a5,a3
    800010ce:	058a3703          	ld	a4,88(s4)
    800010d2:	12068693          	addi	a3,a3,288
    800010d6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010da:	6788                	ld	a0,8(a5)
    800010dc:	6b8c                	ld	a1,16(a5)
    800010de:	6f90                	ld	a2,24(a5)
    800010e0:	01073023          	sd	a6,0(a4)
    800010e4:	e708                	sd	a0,8(a4)
    800010e6:	eb0c                	sd	a1,16(a4)
    800010e8:	ef10                	sd	a2,24(a4)
    800010ea:	02078793          	addi	a5,a5,32
    800010ee:	02070713          	addi	a4,a4,32
    800010f2:	fed792e3          	bne	a5,a3,800010d6 <fork+0x4a>
  np->trapframe->a0 = 0;
    800010f6:	058a3783          	ld	a5,88(s4)
    800010fa:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800010fe:	0d0a8493          	addi	s1,s5,208
    80001102:	0d0a0913          	addi	s2,s4,208
    80001106:	2d0a8993          	addi	s3,s5,720
    8000110a:	a015                	j	8000112e <fork+0xa2>
    freeproc(np);
    8000110c:	8552                	mv	a0,s4
    8000110e:	dcbff0ef          	jal	80000ed8 <freeproc>
    release(&np->lock);
    80001112:	8552                	mv	a0,s4
    80001114:	6b4040ef          	jal	800057c8 <release>
    return -1;
    80001118:	597d                	li	s2,-1
    8000111a:	6a42                	ld	s4,16(sp)
    8000111c:	a0b5                	j	80001188 <fork+0xfc>
      np->ofile[i] = filedup(p->ofile[i]);
    8000111e:	196020ef          	jal	800032b4 <filedup>
    80001122:	00a93023          	sd	a0,0(s2)
  for(i = 0; i < NOFILE; i++)
    80001126:	04a1                	addi	s1,s1,8
    80001128:	0921                	addi	s2,s2,8
    8000112a:	01348563          	beq	s1,s3,80001134 <fork+0xa8>
    if(p->ofile[i])
    8000112e:	6088                	ld	a0,0(s1)
    80001130:	f57d                	bnez	a0,8000111e <fork+0x92>
    80001132:	bfd5                	j	80001126 <fork+0x9a>
  np->cwd = idup(p->cwd);
    80001134:	2d0ab503          	ld	a0,720(s5)
    80001138:	4d8010ef          	jal	80002610 <idup>
    8000113c:	2caa3823          	sd	a0,720(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001140:	4641                	li	a2,16
    80001142:	2d8a8593          	addi	a1,s5,728
    80001146:	2d8a0513          	addi	a0,s4,728
    8000114a:	942ff0ef          	jal	8000028c <safestrcpy>
  pid = np->pid;
    8000114e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001152:	8552                	mv	a0,s4
    80001154:	674040ef          	jal	800057c8 <release>
  acquire(&wait_lock);
    80001158:	00009497          	auipc	s1,0x9
    8000115c:	0f048493          	addi	s1,s1,240 # 8000a248 <wait_lock>
    80001160:	8526                	mv	a0,s1
    80001162:	5ce040ef          	jal	80005730 <acquire>
  np->parent = p;
    80001166:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000116a:	8526                	mv	a0,s1
    8000116c:	65c040ef          	jal	800057c8 <release>
  acquire(&np->lock);
    80001170:	8552                	mv	a0,s4
    80001172:	5be040ef          	jal	80005730 <acquire>
  np->state = RUNNABLE;
    80001176:	478d                	li	a5,3
    80001178:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000117c:	8552                	mv	a0,s4
    8000117e:	64a040ef          	jal	800057c8 <release>
  return pid;
    80001182:	74a2                	ld	s1,40(sp)
    80001184:	69e2                	ld	s3,24(sp)
    80001186:	6a42                	ld	s4,16(sp)
}
    80001188:	854a                	mv	a0,s2
    8000118a:	70e2                	ld	ra,56(sp)
    8000118c:	7442                	ld	s0,48(sp)
    8000118e:	7902                	ld	s2,32(sp)
    80001190:	6aa2                	ld	s5,8(sp)
    80001192:	6121                	addi	sp,sp,64
    80001194:	8082                	ret
    return -1;
    80001196:	597d                	li	s2,-1
    80001198:	bfc5                	j	80001188 <fork+0xfc>

000000008000119a <scheduler>:
{
    8000119a:	715d                	addi	sp,sp,-80
    8000119c:	e486                	sd	ra,72(sp)
    8000119e:	e0a2                	sd	s0,64(sp)
    800011a0:	fc26                	sd	s1,56(sp)
    800011a2:	f84a                	sd	s2,48(sp)
    800011a4:	f44e                	sd	s3,40(sp)
    800011a6:	f052                	sd	s4,32(sp)
    800011a8:	ec56                	sd	s5,24(sp)
    800011aa:	e85a                	sd	s6,16(sp)
    800011ac:	e45e                	sd	s7,8(sp)
    800011ae:	e062                	sd	s8,0(sp)
    800011b0:	0880                	addi	s0,sp,80
    800011b2:	8792                	mv	a5,tp
  int id = r_tp();
    800011b4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011b6:	00779b13          	slli	s6,a5,0x7
    800011ba:	00009717          	auipc	a4,0x9
    800011be:	07670713          	addi	a4,a4,118 # 8000a230 <pid_lock>
    800011c2:	975a                	add	a4,a4,s6
    800011c4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011c8:	00009717          	auipc	a4,0x9
    800011cc:	0a070713          	addi	a4,a4,160 # 8000a268 <cpus+0x8>
    800011d0:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011d2:	4c11                	li	s8,4
        c->proc = p;
    800011d4:	079e                	slli	a5,a5,0x7
    800011d6:	00009a17          	auipc	s4,0x9
    800011da:	05aa0a13          	addi	s4,s4,90 # 8000a230 <pid_lock>
    800011de:	9a3e                	add	s4,s4,a5
        found = 1;
    800011e0:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800011e2:	00015997          	auipc	s3,0x15
    800011e6:	e7e98993          	addi	s3,s3,-386 # 80016060 <tickslock>
    800011ea:	a0a9                	j	80001234 <scheduler+0x9a>
      release(&p->lock);
    800011ec:	8526                	mv	a0,s1
    800011ee:	5da040ef          	jal	800057c8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011f2:	2e848493          	addi	s1,s1,744
    800011f6:	03348563          	beq	s1,s3,80001220 <scheduler+0x86>
      acquire(&p->lock);
    800011fa:	8526                	mv	a0,s1
    800011fc:	534040ef          	jal	80005730 <acquire>
      if(p->state == RUNNABLE) {
    80001200:	4c9c                	lw	a5,24(s1)
    80001202:	ff2795e3          	bne	a5,s2,800011ec <scheduler+0x52>
        p->state = RUNNING;
    80001206:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    8000120a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000120e:	06048593          	addi	a1,s1,96
    80001212:	855a                	mv	a0,s6
    80001214:	5b4000ef          	jal	800017c8 <swtch>
        c->proc = 0;
    80001218:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000121c:	8ade                	mv	s5,s7
    8000121e:	b7f9                	j	800011ec <scheduler+0x52>
    if(found == 0) {
    80001220:	000a9a63          	bnez	s5,80001234 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001224:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001228:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000122c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001230:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001234:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001238:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000123c:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001240:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001242:	00009497          	auipc	s1,0x9
    80001246:	41e48493          	addi	s1,s1,1054 # 8000a660 <proc>
      if(p->state == RUNNABLE) {
    8000124a:	490d                	li	s2,3
    8000124c:	b77d                	j	800011fa <scheduler+0x60>

000000008000124e <sched>:
{
    8000124e:	7179                	addi	sp,sp,-48
    80001250:	f406                	sd	ra,40(sp)
    80001252:	f022                	sd	s0,32(sp)
    80001254:	ec26                	sd	s1,24(sp)
    80001256:	e84a                	sd	s2,16(sp)
    80001258:	e44e                	sd	s3,8(sp)
    8000125a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000125c:	b0bff0ef          	jal	80000d66 <myproc>
    80001260:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001262:	464040ef          	jal	800056c6 <holding>
    80001266:	c92d                	beqz	a0,800012d8 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001268:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000126a:	2781                	sext.w	a5,a5
    8000126c:	079e                	slli	a5,a5,0x7
    8000126e:	00009717          	auipc	a4,0x9
    80001272:	fc270713          	addi	a4,a4,-62 # 8000a230 <pid_lock>
    80001276:	97ba                	add	a5,a5,a4
    80001278:	0a87a703          	lw	a4,168(a5)
    8000127c:	4785                	li	a5,1
    8000127e:	06f71363          	bne	a4,a5,800012e4 <sched+0x96>
  if(p->state == RUNNING)
    80001282:	4c98                	lw	a4,24(s1)
    80001284:	4791                	li	a5,4
    80001286:	06f70563          	beq	a4,a5,800012f0 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000128a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000128e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001290:	e7b5                	bnez	a5,800012fc <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001292:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001294:	00009917          	auipc	s2,0x9
    80001298:	f9c90913          	addi	s2,s2,-100 # 8000a230 <pid_lock>
    8000129c:	2781                	sext.w	a5,a5
    8000129e:	079e                	slli	a5,a5,0x7
    800012a0:	97ca                	add	a5,a5,s2
    800012a2:	0ac7a983          	lw	s3,172(a5)
    800012a6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012a8:	2781                	sext.w	a5,a5
    800012aa:	079e                	slli	a5,a5,0x7
    800012ac:	00009597          	auipc	a1,0x9
    800012b0:	fbc58593          	addi	a1,a1,-68 # 8000a268 <cpus+0x8>
    800012b4:	95be                	add	a1,a1,a5
    800012b6:	06048513          	addi	a0,s1,96
    800012ba:	50e000ef          	jal	800017c8 <swtch>
    800012be:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012c0:	2781                	sext.w	a5,a5
    800012c2:	079e                	slli	a5,a5,0x7
    800012c4:	993e                	add	s2,s2,a5
    800012c6:	0b392623          	sw	s3,172(s2)
}
    800012ca:	70a2                	ld	ra,40(sp)
    800012cc:	7402                	ld	s0,32(sp)
    800012ce:	64e2                	ld	s1,24(sp)
    800012d0:	6942                	ld	s2,16(sp)
    800012d2:	69a2                	ld	s3,8(sp)
    800012d4:	6145                	addi	sp,sp,48
    800012d6:	8082                	ret
    panic("sched p->lock");
    800012d8:	00006517          	auipc	a0,0x6
    800012dc:	f0050513          	addi	a0,a0,-256 # 800071d8 <etext+0x1d8>
    800012e0:	122040ef          	jal	80005402 <panic>
    panic("sched locks");
    800012e4:	00006517          	auipc	a0,0x6
    800012e8:	f0450513          	addi	a0,a0,-252 # 800071e8 <etext+0x1e8>
    800012ec:	116040ef          	jal	80005402 <panic>
    panic("sched running");
    800012f0:	00006517          	auipc	a0,0x6
    800012f4:	f0850513          	addi	a0,a0,-248 # 800071f8 <etext+0x1f8>
    800012f8:	10a040ef          	jal	80005402 <panic>
    panic("sched interruptible");
    800012fc:	00006517          	auipc	a0,0x6
    80001300:	f0c50513          	addi	a0,a0,-244 # 80007208 <etext+0x208>
    80001304:	0fe040ef          	jal	80005402 <panic>

0000000080001308 <yield>:
{
    80001308:	1101                	addi	sp,sp,-32
    8000130a:	ec06                	sd	ra,24(sp)
    8000130c:	e822                	sd	s0,16(sp)
    8000130e:	e426                	sd	s1,8(sp)
    80001310:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001312:	a55ff0ef          	jal	80000d66 <myproc>
    80001316:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001318:	418040ef          	jal	80005730 <acquire>
  p->state = RUNNABLE;
    8000131c:	478d                	li	a5,3
    8000131e:	cc9c                	sw	a5,24(s1)
  sched();
    80001320:	f2fff0ef          	jal	8000124e <sched>
  release(&p->lock);
    80001324:	8526                	mv	a0,s1
    80001326:	4a2040ef          	jal	800057c8 <release>
}
    8000132a:	60e2                	ld	ra,24(sp)
    8000132c:	6442                	ld	s0,16(sp)
    8000132e:	64a2                	ld	s1,8(sp)
    80001330:	6105                	addi	sp,sp,32
    80001332:	8082                	ret

0000000080001334 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001334:	7179                	addi	sp,sp,-48
    80001336:	f406                	sd	ra,40(sp)
    80001338:	f022                	sd	s0,32(sp)
    8000133a:	ec26                	sd	s1,24(sp)
    8000133c:	e84a                	sd	s2,16(sp)
    8000133e:	e44e                	sd	s3,8(sp)
    80001340:	1800                	addi	s0,sp,48
    80001342:	89aa                	mv	s3,a0
    80001344:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001346:	a21ff0ef          	jal	80000d66 <myproc>
    8000134a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000134c:	3e4040ef          	jal	80005730 <acquire>
  release(lk);
    80001350:	854a                	mv	a0,s2
    80001352:	476040ef          	jal	800057c8 <release>

  // Go to sleep.
  p->chan = chan;
    80001356:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000135a:	4789                	li	a5,2
    8000135c:	cc9c                	sw	a5,24(s1)

  sched();
    8000135e:	ef1ff0ef          	jal	8000124e <sched>

  // Tidy up.
  p->chan = 0;
    80001362:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001366:	8526                	mv	a0,s1
    80001368:	460040ef          	jal	800057c8 <release>
  acquire(lk);
    8000136c:	854a                	mv	a0,s2
    8000136e:	3c2040ef          	jal	80005730 <acquire>
}
    80001372:	70a2                	ld	ra,40(sp)
    80001374:	7402                	ld	s0,32(sp)
    80001376:	64e2                	ld	s1,24(sp)
    80001378:	6942                	ld	s2,16(sp)
    8000137a:	69a2                	ld	s3,8(sp)
    8000137c:	6145                	addi	sp,sp,48
    8000137e:	8082                	ret

0000000080001380 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001380:	7139                	addi	sp,sp,-64
    80001382:	fc06                	sd	ra,56(sp)
    80001384:	f822                	sd	s0,48(sp)
    80001386:	f426                	sd	s1,40(sp)
    80001388:	f04a                	sd	s2,32(sp)
    8000138a:	ec4e                	sd	s3,24(sp)
    8000138c:	e852                	sd	s4,16(sp)
    8000138e:	e456                	sd	s5,8(sp)
    80001390:	0080                	addi	s0,sp,64
    80001392:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001394:	00009497          	auipc	s1,0x9
    80001398:	2cc48493          	addi	s1,s1,716 # 8000a660 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000139c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000139e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013a0:	00015917          	auipc	s2,0x15
    800013a4:	cc090913          	addi	s2,s2,-832 # 80016060 <tickslock>
    800013a8:	a801                	j	800013b8 <wakeup+0x38>
      }
      release(&p->lock);
    800013aa:	8526                	mv	a0,s1
    800013ac:	41c040ef          	jal	800057c8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013b0:	2e848493          	addi	s1,s1,744
    800013b4:	03248263          	beq	s1,s2,800013d8 <wakeup+0x58>
    if(p != myproc()){
    800013b8:	9afff0ef          	jal	80000d66 <myproc>
    800013bc:	fea48ae3          	beq	s1,a0,800013b0 <wakeup+0x30>
      acquire(&p->lock);
    800013c0:	8526                	mv	a0,s1
    800013c2:	36e040ef          	jal	80005730 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013c6:	4c9c                	lw	a5,24(s1)
    800013c8:	ff3791e3          	bne	a5,s3,800013aa <wakeup+0x2a>
    800013cc:	709c                	ld	a5,32(s1)
    800013ce:	fd479ee3          	bne	a5,s4,800013aa <wakeup+0x2a>
        p->state = RUNNABLE;
    800013d2:	0154ac23          	sw	s5,24(s1)
    800013d6:	bfd1                	j	800013aa <wakeup+0x2a>
    }
  }
}
    800013d8:	70e2                	ld	ra,56(sp)
    800013da:	7442                	ld	s0,48(sp)
    800013dc:	74a2                	ld	s1,40(sp)
    800013de:	7902                	ld	s2,32(sp)
    800013e0:	69e2                	ld	s3,24(sp)
    800013e2:	6a42                	ld	s4,16(sp)
    800013e4:	6aa2                	ld	s5,8(sp)
    800013e6:	6121                	addi	sp,sp,64
    800013e8:	8082                	ret

00000000800013ea <reparent>:
{
    800013ea:	7179                	addi	sp,sp,-48
    800013ec:	f406                	sd	ra,40(sp)
    800013ee:	f022                	sd	s0,32(sp)
    800013f0:	ec26                	sd	s1,24(sp)
    800013f2:	e84a                	sd	s2,16(sp)
    800013f4:	e44e                	sd	s3,8(sp)
    800013f6:	e052                	sd	s4,0(sp)
    800013f8:	1800                	addi	s0,sp,48
    800013fa:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013fc:	00009497          	auipc	s1,0x9
    80001400:	26448493          	addi	s1,s1,612 # 8000a660 <proc>
      pp->parent = initproc;
    80001404:	00009a17          	auipc	s4,0x9
    80001408:	deca0a13          	addi	s4,s4,-532 # 8000a1f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000140c:	00015997          	auipc	s3,0x15
    80001410:	c5498993          	addi	s3,s3,-940 # 80016060 <tickslock>
    80001414:	a029                	j	8000141e <reparent+0x34>
    80001416:	2e848493          	addi	s1,s1,744
    8000141a:	01348b63          	beq	s1,s3,80001430 <reparent+0x46>
    if(pp->parent == p){
    8000141e:	7c9c                	ld	a5,56(s1)
    80001420:	ff279be3          	bne	a5,s2,80001416 <reparent+0x2c>
      pp->parent = initproc;
    80001424:	000a3503          	ld	a0,0(s4)
    80001428:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000142a:	f57ff0ef          	jal	80001380 <wakeup>
    8000142e:	b7e5                	j	80001416 <reparent+0x2c>
}
    80001430:	70a2                	ld	ra,40(sp)
    80001432:	7402                	ld	s0,32(sp)
    80001434:	64e2                	ld	s1,24(sp)
    80001436:	6942                	ld	s2,16(sp)
    80001438:	69a2                	ld	s3,8(sp)
    8000143a:	6a02                	ld	s4,0(sp)
    8000143c:	6145                	addi	sp,sp,48
    8000143e:	8082                	ret

0000000080001440 <exit>:
{
    80001440:	7179                	addi	sp,sp,-48
    80001442:	f406                	sd	ra,40(sp)
    80001444:	f022                	sd	s0,32(sp)
    80001446:	ec26                	sd	s1,24(sp)
    80001448:	e84a                	sd	s2,16(sp)
    8000144a:	e44e                	sd	s3,8(sp)
    8000144c:	e052                	sd	s4,0(sp)
    8000144e:	1800                	addi	s0,sp,48
    80001450:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001452:	915ff0ef          	jal	80000d66 <myproc>
    80001456:	89aa                	mv	s3,a0
  if(p == initproc)
    80001458:	00009797          	auipc	a5,0x9
    8000145c:	d987b783          	ld	a5,-616(a5) # 8000a1f0 <initproc>
    80001460:	0d050493          	addi	s1,a0,208
    80001464:	2d050913          	addi	s2,a0,720
    80001468:	00a79f63          	bne	a5,a0,80001486 <exit+0x46>
    panic("init exiting");
    8000146c:	00006517          	auipc	a0,0x6
    80001470:	db450513          	addi	a0,a0,-588 # 80007220 <etext+0x220>
    80001474:	78f030ef          	jal	80005402 <panic>
      fileclose(f);
    80001478:	683010ef          	jal	800032fa <fileclose>
      p->ofile[fd] = 0;
    8000147c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001480:	04a1                	addi	s1,s1,8
    80001482:	01248563          	beq	s1,s2,8000148c <exit+0x4c>
    if(p->ofile[fd]){
    80001486:	6088                	ld	a0,0(s1)
    80001488:	f965                	bnez	a0,80001478 <exit+0x38>
    8000148a:	bfdd                	j	80001480 <exit+0x40>
  begin_op();
    8000148c:	251010ef          	jal	80002edc <begin_op>
  iput(p->cwd);
    80001490:	2d09b503          	ld	a0,720(s3)
    80001494:	334010ef          	jal	800027c8 <iput>
  end_op();
    80001498:	2b1010ef          	jal	80002f48 <end_op>
  p->cwd = 0;
    8000149c:	2c09b823          	sd	zero,720(s3)
  acquire(&wait_lock);
    800014a0:	00009497          	auipc	s1,0x9
    800014a4:	da848493          	addi	s1,s1,-600 # 8000a248 <wait_lock>
    800014a8:	8526                	mv	a0,s1
    800014aa:	286040ef          	jal	80005730 <acquire>
  reparent(p);
    800014ae:	854e                	mv	a0,s3
    800014b0:	f3bff0ef          	jal	800013ea <reparent>
  wakeup(p->parent);
    800014b4:	0389b503          	ld	a0,56(s3)
    800014b8:	ec9ff0ef          	jal	80001380 <wakeup>
  acquire(&p->lock);
    800014bc:	854e                	mv	a0,s3
    800014be:	272040ef          	jal	80005730 <acquire>
  p->xstate = status;
    800014c2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014c6:	4795                	li	a5,5
    800014c8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014cc:	8526                	mv	a0,s1
    800014ce:	2fa040ef          	jal	800057c8 <release>
  sched();
    800014d2:	d7dff0ef          	jal	8000124e <sched>
  panic("zombie exit");
    800014d6:	00006517          	auipc	a0,0x6
    800014da:	d5a50513          	addi	a0,a0,-678 # 80007230 <etext+0x230>
    800014de:	725030ef          	jal	80005402 <panic>

00000000800014e2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014e2:	7179                	addi	sp,sp,-48
    800014e4:	f406                	sd	ra,40(sp)
    800014e6:	f022                	sd	s0,32(sp)
    800014e8:	ec26                	sd	s1,24(sp)
    800014ea:	e84a                	sd	s2,16(sp)
    800014ec:	e44e                	sd	s3,8(sp)
    800014ee:	1800                	addi	s0,sp,48
    800014f0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014f2:	00009497          	auipc	s1,0x9
    800014f6:	16e48493          	addi	s1,s1,366 # 8000a660 <proc>
    800014fa:	00015997          	auipc	s3,0x15
    800014fe:	b6698993          	addi	s3,s3,-1178 # 80016060 <tickslock>
    acquire(&p->lock);
    80001502:	8526                	mv	a0,s1
    80001504:	22c040ef          	jal	80005730 <acquire>
    if(p->pid == pid){
    80001508:	589c                	lw	a5,48(s1)
    8000150a:	01278b63          	beq	a5,s2,80001520 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000150e:	8526                	mv	a0,s1
    80001510:	2b8040ef          	jal	800057c8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001514:	2e848493          	addi	s1,s1,744
    80001518:	ff3495e3          	bne	s1,s3,80001502 <kill+0x20>
  }
  return -1;
    8000151c:	557d                	li	a0,-1
    8000151e:	a819                	j	80001534 <kill+0x52>
      p->killed = 1;
    80001520:	4785                	li	a5,1
    80001522:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001524:	4c98                	lw	a4,24(s1)
    80001526:	4789                	li	a5,2
    80001528:	00f70d63          	beq	a4,a5,80001542 <kill+0x60>
      release(&p->lock);
    8000152c:	8526                	mv	a0,s1
    8000152e:	29a040ef          	jal	800057c8 <release>
      return 0;
    80001532:	4501                	li	a0,0
}
    80001534:	70a2                	ld	ra,40(sp)
    80001536:	7402                	ld	s0,32(sp)
    80001538:	64e2                	ld	s1,24(sp)
    8000153a:	6942                	ld	s2,16(sp)
    8000153c:	69a2                	ld	s3,8(sp)
    8000153e:	6145                	addi	sp,sp,48
    80001540:	8082                	ret
        p->state = RUNNABLE;
    80001542:	478d                	li	a5,3
    80001544:	cc9c                	sw	a5,24(s1)
    80001546:	b7dd                	j	8000152c <kill+0x4a>

0000000080001548 <setkilled>:

void
setkilled(struct proc *p)
{
    80001548:	1101                	addi	sp,sp,-32
    8000154a:	ec06                	sd	ra,24(sp)
    8000154c:	e822                	sd	s0,16(sp)
    8000154e:	e426                	sd	s1,8(sp)
    80001550:	1000                	addi	s0,sp,32
    80001552:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001554:	1dc040ef          	jal	80005730 <acquire>
  p->killed = 1;
    80001558:	4785                	li	a5,1
    8000155a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000155c:	8526                	mv	a0,s1
    8000155e:	26a040ef          	jal	800057c8 <release>
}
    80001562:	60e2                	ld	ra,24(sp)
    80001564:	6442                	ld	s0,16(sp)
    80001566:	64a2                	ld	s1,8(sp)
    80001568:	6105                	addi	sp,sp,32
    8000156a:	8082                	ret

000000008000156c <killed>:

int
killed(struct proc *p)
{
    8000156c:	1101                	addi	sp,sp,-32
    8000156e:	ec06                	sd	ra,24(sp)
    80001570:	e822                	sd	s0,16(sp)
    80001572:	e426                	sd	s1,8(sp)
    80001574:	e04a                	sd	s2,0(sp)
    80001576:	1000                	addi	s0,sp,32
    80001578:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000157a:	1b6040ef          	jal	80005730 <acquire>
  k = p->killed;
    8000157e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001582:	8526                	mv	a0,s1
    80001584:	244040ef          	jal	800057c8 <release>
  return k;
}
    80001588:	854a                	mv	a0,s2
    8000158a:	60e2                	ld	ra,24(sp)
    8000158c:	6442                	ld	s0,16(sp)
    8000158e:	64a2                	ld	s1,8(sp)
    80001590:	6902                	ld	s2,0(sp)
    80001592:	6105                	addi	sp,sp,32
    80001594:	8082                	ret

0000000080001596 <wait>:
{
    80001596:	715d                	addi	sp,sp,-80
    80001598:	e486                	sd	ra,72(sp)
    8000159a:	e0a2                	sd	s0,64(sp)
    8000159c:	fc26                	sd	s1,56(sp)
    8000159e:	f84a                	sd	s2,48(sp)
    800015a0:	f44e                	sd	s3,40(sp)
    800015a2:	f052                	sd	s4,32(sp)
    800015a4:	ec56                	sd	s5,24(sp)
    800015a6:	e85a                	sd	s6,16(sp)
    800015a8:	e45e                	sd	s7,8(sp)
    800015aa:	e062                	sd	s8,0(sp)
    800015ac:	0880                	addi	s0,sp,80
    800015ae:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015b0:	fb6ff0ef          	jal	80000d66 <myproc>
    800015b4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015b6:	00009517          	auipc	a0,0x9
    800015ba:	c9250513          	addi	a0,a0,-878 # 8000a248 <wait_lock>
    800015be:	172040ef          	jal	80005730 <acquire>
    havekids = 0;
    800015c2:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015c4:	4a15                	li	s4,5
        havekids = 1;
    800015c6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015c8:	00015997          	auipc	s3,0x15
    800015cc:	a9898993          	addi	s3,s3,-1384 # 80016060 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015d0:	00009c17          	auipc	s8,0x9
    800015d4:	c78c0c13          	addi	s8,s8,-904 # 8000a248 <wait_lock>
    800015d8:	a871                	j	80001674 <wait+0xde>
          pid = pp->pid;
    800015da:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015de:	000b0c63          	beqz	s6,800015f6 <wait+0x60>
    800015e2:	4691                	li	a3,4
    800015e4:	02c48613          	addi	a2,s1,44
    800015e8:	85da                	mv	a1,s6
    800015ea:	05093503          	ld	a0,80(s2)
    800015ee:	beaff0ef          	jal	800009d8 <copyout>
    800015f2:	02054b63          	bltz	a0,80001628 <wait+0x92>
          freeproc(pp);
    800015f6:	8526                	mv	a0,s1
    800015f8:	8e1ff0ef          	jal	80000ed8 <freeproc>
          release(&pp->lock);
    800015fc:	8526                	mv	a0,s1
    800015fe:	1ca040ef          	jal	800057c8 <release>
          release(&wait_lock);
    80001602:	00009517          	auipc	a0,0x9
    80001606:	c4650513          	addi	a0,a0,-954 # 8000a248 <wait_lock>
    8000160a:	1be040ef          	jal	800057c8 <release>
}
    8000160e:	854e                	mv	a0,s3
    80001610:	60a6                	ld	ra,72(sp)
    80001612:	6406                	ld	s0,64(sp)
    80001614:	74e2                	ld	s1,56(sp)
    80001616:	7942                	ld	s2,48(sp)
    80001618:	79a2                	ld	s3,40(sp)
    8000161a:	7a02                	ld	s4,32(sp)
    8000161c:	6ae2                	ld	s5,24(sp)
    8000161e:	6b42                	ld	s6,16(sp)
    80001620:	6ba2                	ld	s7,8(sp)
    80001622:	6c02                	ld	s8,0(sp)
    80001624:	6161                	addi	sp,sp,80
    80001626:	8082                	ret
            release(&pp->lock);
    80001628:	8526                	mv	a0,s1
    8000162a:	19e040ef          	jal	800057c8 <release>
            release(&wait_lock);
    8000162e:	00009517          	auipc	a0,0x9
    80001632:	c1a50513          	addi	a0,a0,-998 # 8000a248 <wait_lock>
    80001636:	192040ef          	jal	800057c8 <release>
            return -1;
    8000163a:	59fd                	li	s3,-1
    8000163c:	bfc9                	j	8000160e <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000163e:	2e848493          	addi	s1,s1,744
    80001642:	03348063          	beq	s1,s3,80001662 <wait+0xcc>
      if(pp->parent == p){
    80001646:	7c9c                	ld	a5,56(s1)
    80001648:	ff279be3          	bne	a5,s2,8000163e <wait+0xa8>
        acquire(&pp->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	0e2040ef          	jal	80005730 <acquire>
        if(pp->state == ZOMBIE){
    80001652:	4c9c                	lw	a5,24(s1)
    80001654:	f94783e3          	beq	a5,s4,800015da <wait+0x44>
        release(&pp->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	16e040ef          	jal	800057c8 <release>
        havekids = 1;
    8000165e:	8756                	mv	a4,s5
    80001660:	bff9                	j	8000163e <wait+0xa8>
    if(!havekids || killed(p)){
    80001662:	cf19                	beqz	a4,80001680 <wait+0xea>
    80001664:	854a                	mv	a0,s2
    80001666:	f07ff0ef          	jal	8000156c <killed>
    8000166a:	e919                	bnez	a0,80001680 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000166c:	85e2                	mv	a1,s8
    8000166e:	854a                	mv	a0,s2
    80001670:	cc5ff0ef          	jal	80001334 <sleep>
    havekids = 0;
    80001674:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001676:	00009497          	auipc	s1,0x9
    8000167a:	fea48493          	addi	s1,s1,-22 # 8000a660 <proc>
    8000167e:	b7e1                	j	80001646 <wait+0xb0>
      release(&wait_lock);
    80001680:	00009517          	auipc	a0,0x9
    80001684:	bc850513          	addi	a0,a0,-1080 # 8000a248 <wait_lock>
    80001688:	140040ef          	jal	800057c8 <release>
      return -1;
    8000168c:	59fd                	li	s3,-1
    8000168e:	b741                	j	8000160e <wait+0x78>

0000000080001690 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001690:	7179                	addi	sp,sp,-48
    80001692:	f406                	sd	ra,40(sp)
    80001694:	f022                	sd	s0,32(sp)
    80001696:	ec26                	sd	s1,24(sp)
    80001698:	e84a                	sd	s2,16(sp)
    8000169a:	e44e                	sd	s3,8(sp)
    8000169c:	e052                	sd	s4,0(sp)
    8000169e:	1800                	addi	s0,sp,48
    800016a0:	84aa                	mv	s1,a0
    800016a2:	892e                	mv	s2,a1
    800016a4:	89b2                	mv	s3,a2
    800016a6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016a8:	ebeff0ef          	jal	80000d66 <myproc>
  if(user_dst){
    800016ac:	cc99                	beqz	s1,800016ca <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016ae:	86d2                	mv	a3,s4
    800016b0:	864e                	mv	a2,s3
    800016b2:	85ca                	mv	a1,s2
    800016b4:	6928                	ld	a0,80(a0)
    800016b6:	b22ff0ef          	jal	800009d8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016ba:	70a2                	ld	ra,40(sp)
    800016bc:	7402                	ld	s0,32(sp)
    800016be:	64e2                	ld	s1,24(sp)
    800016c0:	6942                	ld	s2,16(sp)
    800016c2:	69a2                	ld	s3,8(sp)
    800016c4:	6a02                	ld	s4,0(sp)
    800016c6:	6145                	addi	sp,sp,48
    800016c8:	8082                	ret
    memmove((char *)dst, src, len);
    800016ca:	000a061b          	sext.w	a2,s4
    800016ce:	85ce                	mv	a1,s3
    800016d0:	854a                	mv	a0,s2
    800016d2:	ad9fe0ef          	jal	800001aa <memmove>
    return 0;
    800016d6:	8526                	mv	a0,s1
    800016d8:	b7cd                	j	800016ba <either_copyout+0x2a>

00000000800016da <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016da:	7179                	addi	sp,sp,-48
    800016dc:	f406                	sd	ra,40(sp)
    800016de:	f022                	sd	s0,32(sp)
    800016e0:	ec26                	sd	s1,24(sp)
    800016e2:	e84a                	sd	s2,16(sp)
    800016e4:	e44e                	sd	s3,8(sp)
    800016e6:	e052                	sd	s4,0(sp)
    800016e8:	1800                	addi	s0,sp,48
    800016ea:	892a                	mv	s2,a0
    800016ec:	84ae                	mv	s1,a1
    800016ee:	89b2                	mv	s3,a2
    800016f0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016f2:	e74ff0ef          	jal	80000d66 <myproc>
  if(user_src){
    800016f6:	cc99                	beqz	s1,80001714 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016f8:	86d2                	mv	a3,s4
    800016fa:	864e                	mv	a2,s3
    800016fc:	85ca                	mv	a1,s2
    800016fe:	6928                	ld	a0,80(a0)
    80001700:	baeff0ef          	jal	80000aae <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001704:	70a2                	ld	ra,40(sp)
    80001706:	7402                	ld	s0,32(sp)
    80001708:	64e2                	ld	s1,24(sp)
    8000170a:	6942                	ld	s2,16(sp)
    8000170c:	69a2                	ld	s3,8(sp)
    8000170e:	6a02                	ld	s4,0(sp)
    80001710:	6145                	addi	sp,sp,48
    80001712:	8082                	ret
    memmove(dst, (char*)src, len);
    80001714:	000a061b          	sext.w	a2,s4
    80001718:	85ce                	mv	a1,s3
    8000171a:	854a                	mv	a0,s2
    8000171c:	a8ffe0ef          	jal	800001aa <memmove>
    return 0;
    80001720:	8526                	mv	a0,s1
    80001722:	b7cd                	j	80001704 <either_copyin+0x2a>

0000000080001724 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001724:	715d                	addi	sp,sp,-80
    80001726:	e486                	sd	ra,72(sp)
    80001728:	e0a2                	sd	s0,64(sp)
    8000172a:	fc26                	sd	s1,56(sp)
    8000172c:	f84a                	sd	s2,48(sp)
    8000172e:	f44e                	sd	s3,40(sp)
    80001730:	f052                	sd	s4,32(sp)
    80001732:	ec56                	sd	s5,24(sp)
    80001734:	e85a                	sd	s6,16(sp)
    80001736:	e45e                	sd	s7,8(sp)
    80001738:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000173a:	00006517          	auipc	a0,0x6
    8000173e:	8de50513          	addi	a0,a0,-1826 # 80007018 <etext+0x18>
    80001742:	1ef030ef          	jal	80005130 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001746:	00009497          	auipc	s1,0x9
    8000174a:	1f248493          	addi	s1,s1,498 # 8000a938 <proc+0x2d8>
    8000174e:	00015917          	auipc	s2,0x15
    80001752:	bea90913          	addi	s2,s2,-1046 # 80016338 <bcache+0x2c0>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001756:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001758:	00006997          	auipc	s3,0x6
    8000175c:	ae898993          	addi	s3,s3,-1304 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001760:	00006a97          	auipc	s5,0x6
    80001764:	ae8a8a93          	addi	s5,s5,-1304 # 80007248 <etext+0x248>
    printf("\n");
    80001768:	00006a17          	auipc	s4,0x6
    8000176c:	8b0a0a13          	addi	s4,s4,-1872 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001770:	00006b97          	auipc	s7,0x6
    80001774:	000b8b93          	mv	s7,s7
    80001778:	a829                	j	80001792 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000177a:	d586a583          	lw	a1,-680(a3)
    8000177e:	8556                	mv	a0,s5
    80001780:	1b1030ef          	jal	80005130 <printf>
    printf("\n");
    80001784:	8552                	mv	a0,s4
    80001786:	1ab030ef          	jal	80005130 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000178a:	2e848493          	addi	s1,s1,744
    8000178e:	03248263          	beq	s1,s2,800017b2 <procdump+0x8e>
    if(p->state == UNUSED)
    80001792:	86a6                	mv	a3,s1
    80001794:	d404a783          	lw	a5,-704(s1)
    80001798:	dbed                	beqz	a5,8000178a <procdump+0x66>
      state = "???";
    8000179a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000179c:	fcfb6fe3          	bltu	s6,a5,8000177a <procdump+0x56>
    800017a0:	02079713          	slli	a4,a5,0x20
    800017a4:	01d75793          	srli	a5,a4,0x1d
    800017a8:	97de                	add	a5,a5,s7
    800017aa:	6390                	ld	a2,0(a5)
    800017ac:	f679                	bnez	a2,8000177a <procdump+0x56>
      state = "???";
    800017ae:	864e                	mv	a2,s3
    800017b0:	b7e9                	j	8000177a <procdump+0x56>
  }
}
    800017b2:	60a6                	ld	ra,72(sp)
    800017b4:	6406                	ld	s0,64(sp)
    800017b6:	74e2                	ld	s1,56(sp)
    800017b8:	7942                	ld	s2,48(sp)
    800017ba:	79a2                	ld	s3,40(sp)
    800017bc:	7a02                	ld	s4,32(sp)
    800017be:	6ae2                	ld	s5,24(sp)
    800017c0:	6b42                	ld	s6,16(sp)
    800017c2:	6ba2                	ld	s7,8(sp)
    800017c4:	6161                	addi	sp,sp,80
    800017c6:	8082                	ret

00000000800017c8 <swtch>:
    800017c8:	00153023          	sd	ra,0(a0)
    800017cc:	00253423          	sd	sp,8(a0)
    800017d0:	e900                	sd	s0,16(a0)
    800017d2:	ed04                	sd	s1,24(a0)
    800017d4:	03253023          	sd	s2,32(a0)
    800017d8:	03353423          	sd	s3,40(a0)
    800017dc:	03453823          	sd	s4,48(a0)
    800017e0:	03553c23          	sd	s5,56(a0)
    800017e4:	05653023          	sd	s6,64(a0)
    800017e8:	05753423          	sd	s7,72(a0)
    800017ec:	05853823          	sd	s8,80(a0)
    800017f0:	05953c23          	sd	s9,88(a0)
    800017f4:	07a53023          	sd	s10,96(a0)
    800017f8:	07b53423          	sd	s11,104(a0)
    800017fc:	0005b083          	ld	ra,0(a1)
    80001800:	0085b103          	ld	sp,8(a1)
    80001804:	6980                	ld	s0,16(a1)
    80001806:	6d84                	ld	s1,24(a1)
    80001808:	0205b903          	ld	s2,32(a1)
    8000180c:	0285b983          	ld	s3,40(a1)
    80001810:	0305ba03          	ld	s4,48(a1)
    80001814:	0385ba83          	ld	s5,56(a1)
    80001818:	0405bb03          	ld	s6,64(a1)
    8000181c:	0485bb83          	ld	s7,72(a1)
    80001820:	0505bc03          	ld	s8,80(a1)
    80001824:	0585bc83          	ld	s9,88(a1)
    80001828:	0605bd03          	ld	s10,96(a1)
    8000182c:	0685bd83          	ld	s11,104(a1)
    80001830:	8082                	ret

0000000080001832 <trapinit>:
    80001832:	1141                	addi	sp,sp,-16
    80001834:	e406                	sd	ra,8(sp)
    80001836:	e022                	sd	s0,0(sp)
    80001838:	0800                	addi	s0,sp,16
    8000183a:	00006597          	auipc	a1,0x6
    8000183e:	a4e58593          	addi	a1,a1,-1458 # 80007288 <etext+0x288>
    80001842:	00015517          	auipc	a0,0x15
    80001846:	81e50513          	addi	a0,a0,-2018 # 80016060 <tickslock>
    8000184a:	667030ef          	jal	800056b0 <initlock>
    8000184e:	60a2                	ld	ra,8(sp)
    80001850:	6402                	ld	s0,0(sp)
    80001852:	0141                	addi	sp,sp,16
    80001854:	8082                	ret

0000000080001856 <trapinithart>:
    80001856:	1141                	addi	sp,sp,-16
    80001858:	e422                	sd	s0,8(sp)
    8000185a:	0800                	addi	s0,sp,16
    8000185c:	00003797          	auipc	a5,0x3
    80001860:	e1478793          	addi	a5,a5,-492 # 80004670 <kernelvec>
    80001864:	10579073          	csrw	stvec,a5
    80001868:	6422                	ld	s0,8(sp)
    8000186a:	0141                	addi	sp,sp,16
    8000186c:	8082                	ret

000000008000186e <usertrapret>:
    8000186e:	1141                	addi	sp,sp,-16
    80001870:	e406                	sd	ra,8(sp)
    80001872:	e022                	sd	s0,0(sp)
    80001874:	0800                	addi	s0,sp,16
    80001876:	cf0ff0ef          	jal	80000d66 <myproc>
    8000187a:	100027f3          	csrr	a5,sstatus
    8000187e:	9bf5                	andi	a5,a5,-3
    80001880:	10079073          	csrw	sstatus,a5
    80001884:	00004697          	auipc	a3,0x4
    80001888:	77c68693          	addi	a3,a3,1916 # 80006000 <_trampoline>
    8000188c:	00004717          	auipc	a4,0x4
    80001890:	77470713          	addi	a4,a4,1908 # 80006000 <_trampoline>
    80001894:	8f15                	sub	a4,a4,a3
    80001896:	040007b7          	lui	a5,0x4000
    8000189a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000189c:	07b2                	slli	a5,a5,0xc
    8000189e:	973e                	add	a4,a4,a5
    800018a0:	10571073          	csrw	stvec,a4
    800018a4:	6d38                	ld	a4,88(a0)
    800018a6:	18002673          	csrr	a2,satp
    800018aa:	e310                	sd	a2,0(a4)
    800018ac:	6d30                	ld	a2,88(a0)
    800018ae:	6138                	ld	a4,64(a0)
    800018b0:	6585                	lui	a1,0x1
    800018b2:	972e                	add	a4,a4,a1
    800018b4:	e618                	sd	a4,8(a2)
    800018b6:	6d38                	ld	a4,88(a0)
    800018b8:	00000617          	auipc	a2,0x0
    800018bc:	11060613          	addi	a2,a2,272 # 800019c8 <usertrap>
    800018c0:	eb10                	sd	a2,16(a4)
    800018c2:	6d38                	ld	a4,88(a0)
    800018c4:	8612                	mv	a2,tp
    800018c6:	f310                	sd	a2,32(a4)
    800018c8:	10002773          	csrr	a4,sstatus
    800018cc:	eff77713          	andi	a4,a4,-257
    800018d0:	02076713          	ori	a4,a4,32
    800018d4:	10071073          	csrw	sstatus,a4
    800018d8:	6d38                	ld	a4,88(a0)
    800018da:	6f18                	ld	a4,24(a4)
    800018dc:	14171073          	csrw	sepc,a4
    800018e0:	6928                	ld	a0,80(a0)
    800018e2:	8131                	srli	a0,a0,0xc
    800018e4:	00004717          	auipc	a4,0x4
    800018e8:	7b870713          	addi	a4,a4,1976 # 8000609c <userret>
    800018ec:	8f15                	sub	a4,a4,a3
    800018ee:	97ba                	add	a5,a5,a4
    800018f0:	577d                	li	a4,-1
    800018f2:	177e                	slli	a4,a4,0x3f
    800018f4:	8d59                	or	a0,a0,a4
    800018f6:	9782                	jalr	a5
    800018f8:	60a2                	ld	ra,8(sp)
    800018fa:	6402                	ld	s0,0(sp)
    800018fc:	0141                	addi	sp,sp,16
    800018fe:	8082                	ret

0000000080001900 <clockintr>:
    80001900:	1101                	addi	sp,sp,-32
    80001902:	ec06                	sd	ra,24(sp)
    80001904:	e822                	sd	s0,16(sp)
    80001906:	1000                	addi	s0,sp,32
    80001908:	c32ff0ef          	jal	80000d3a <cpuid>
    8000190c:	cd11                	beqz	a0,80001928 <clockintr+0x28>
    8000190e:	c01027f3          	rdtime	a5
    80001912:	000f4737          	lui	a4,0xf4
    80001916:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000191a:	97ba                	add	a5,a5,a4
    8000191c:	14d79073          	csrw	stimecmp,a5
    80001920:	60e2                	ld	ra,24(sp)
    80001922:	6442                	ld	s0,16(sp)
    80001924:	6105                	addi	sp,sp,32
    80001926:	8082                	ret
    80001928:	e426                	sd	s1,8(sp)
    8000192a:	00014497          	auipc	s1,0x14
    8000192e:	73648493          	addi	s1,s1,1846 # 80016060 <tickslock>
    80001932:	8526                	mv	a0,s1
    80001934:	5fd030ef          	jal	80005730 <acquire>
    80001938:	00009517          	auipc	a0,0x9
    8000193c:	8c050513          	addi	a0,a0,-1856 # 8000a1f8 <ticks>
    80001940:	411c                	lw	a5,0(a0)
    80001942:	2785                	addiw	a5,a5,1
    80001944:	c11c                	sw	a5,0(a0)
    80001946:	a3bff0ef          	jal	80001380 <wakeup>
    8000194a:	8526                	mv	a0,s1
    8000194c:	67d030ef          	jal	800057c8 <release>
    80001950:	64a2                	ld	s1,8(sp)
    80001952:	bf75                	j	8000190e <clockintr+0xe>

0000000080001954 <devintr>:
    80001954:	1101                	addi	sp,sp,-32
    80001956:	ec06                	sd	ra,24(sp)
    80001958:	e822                	sd	s0,16(sp)
    8000195a:	1000                	addi	s0,sp,32
    8000195c:	14202773          	csrr	a4,scause
    80001960:	57fd                	li	a5,-1
    80001962:	17fe                	slli	a5,a5,0x3f
    80001964:	07a5                	addi	a5,a5,9
    80001966:	00f70c63          	beq	a4,a5,8000197e <devintr+0x2a>
    8000196a:	57fd                	li	a5,-1
    8000196c:	17fe                	slli	a5,a5,0x3f
    8000196e:	0795                	addi	a5,a5,5
    80001970:	4501                	li	a0,0
    80001972:	04f70763          	beq	a4,a5,800019c0 <devintr+0x6c>
    80001976:	60e2                	ld	ra,24(sp)
    80001978:	6442                	ld	s0,16(sp)
    8000197a:	6105                	addi	sp,sp,32
    8000197c:	8082                	ret
    8000197e:	e426                	sd	s1,8(sp)
    80001980:	59d020ef          	jal	8000471c <plic_claim>
    80001984:	84aa                	mv	s1,a0
    80001986:	47a9                	li	a5,10
    80001988:	00f50963          	beq	a0,a5,8000199a <devintr+0x46>
    8000198c:	4785                	li	a5,1
    8000198e:	00f50963          	beq	a0,a5,800019a0 <devintr+0x4c>
    80001992:	4505                	li	a0,1
    80001994:	e889                	bnez	s1,800019a6 <devintr+0x52>
    80001996:	64a2                	ld	s1,8(sp)
    80001998:	bff9                	j	80001976 <devintr+0x22>
    8000199a:	4db030ef          	jal	80005674 <uartintr>
    8000199e:	a819                	j	800019b4 <devintr+0x60>
    800019a0:	242030ef          	jal	80004be2 <virtio_disk_intr>
    800019a4:	a801                	j	800019b4 <devintr+0x60>
    800019a6:	85a6                	mv	a1,s1
    800019a8:	00006517          	auipc	a0,0x6
    800019ac:	8e850513          	addi	a0,a0,-1816 # 80007290 <etext+0x290>
    800019b0:	780030ef          	jal	80005130 <printf>
    800019b4:	8526                	mv	a0,s1
    800019b6:	587020ef          	jal	8000473c <plic_complete>
    800019ba:	4505                	li	a0,1
    800019bc:	64a2                	ld	s1,8(sp)
    800019be:	bf65                	j	80001976 <devintr+0x22>
    800019c0:	f41ff0ef          	jal	80001900 <clockintr>
    800019c4:	4509                	li	a0,2
    800019c6:	bf45                	j	80001976 <devintr+0x22>

00000000800019c8 <usertrap>:
    800019c8:	1101                	addi	sp,sp,-32
    800019ca:	ec06                	sd	ra,24(sp)
    800019cc:	e822                	sd	s0,16(sp)
    800019ce:	e426                	sd	s1,8(sp)
    800019d0:	e04a                	sd	s2,0(sp)
    800019d2:	1000                	addi	s0,sp,32
    800019d4:	100027f3          	csrr	a5,sstatus
    800019d8:	1007f793          	andi	a5,a5,256
    800019dc:	ef85                	bnez	a5,80001a14 <usertrap+0x4c>
    800019de:	00003797          	auipc	a5,0x3
    800019e2:	c9278793          	addi	a5,a5,-878 # 80004670 <kernelvec>
    800019e6:	10579073          	csrw	stvec,a5
    800019ea:	b7cff0ef          	jal	80000d66 <myproc>
    800019ee:	84aa                	mv	s1,a0
    800019f0:	6d3c                	ld	a5,88(a0)
    800019f2:	14102773          	csrr	a4,sepc
    800019f6:	ef98                	sd	a4,24(a5)
    800019f8:	14202773          	csrr	a4,scause
    800019fc:	47a1                	li	a5,8
    800019fe:	02f70163          	beq	a4,a5,80001a20 <usertrap+0x58>
    80001a02:	f53ff0ef          	jal	80001954 <devintr>
    80001a06:	892a                	mv	s2,a0
    80001a08:	c135                	beqz	a0,80001a6c <usertrap+0xa4>
    80001a0a:	8526                	mv	a0,s1
    80001a0c:	b61ff0ef          	jal	8000156c <killed>
    80001a10:	cd1d                	beqz	a0,80001a4e <usertrap+0x86>
    80001a12:	a81d                	j	80001a48 <usertrap+0x80>
    80001a14:	00006517          	auipc	a0,0x6
    80001a18:	89c50513          	addi	a0,a0,-1892 # 800072b0 <etext+0x2b0>
    80001a1c:	1e7030ef          	jal	80005402 <panic>
    80001a20:	b4dff0ef          	jal	8000156c <killed>
    80001a24:	e121                	bnez	a0,80001a64 <usertrap+0x9c>
    80001a26:	6cb8                	ld	a4,88(s1)
    80001a28:	6f1c                	ld	a5,24(a4)
    80001a2a:	0791                	addi	a5,a5,4
    80001a2c:	ef1c                	sd	a5,24(a4)
    80001a2e:	100027f3          	csrr	a5,sstatus
    80001a32:	0027e793          	ori	a5,a5,2
    80001a36:	10079073          	csrw	sstatus,a5
    80001a3a:	248000ef          	jal	80001c82 <syscall>
    80001a3e:	8526                	mv	a0,s1
    80001a40:	b2dff0ef          	jal	8000156c <killed>
    80001a44:	c901                	beqz	a0,80001a54 <usertrap+0x8c>
    80001a46:	4901                	li	s2,0
    80001a48:	557d                	li	a0,-1
    80001a4a:	9f7ff0ef          	jal	80001440 <exit>
    80001a4e:	4789                	li	a5,2
    80001a50:	04f90563          	beq	s2,a5,80001a9a <usertrap+0xd2>
    80001a54:	e1bff0ef          	jal	8000186e <usertrapret>
    80001a58:	60e2                	ld	ra,24(sp)
    80001a5a:	6442                	ld	s0,16(sp)
    80001a5c:	64a2                	ld	s1,8(sp)
    80001a5e:	6902                	ld	s2,0(sp)
    80001a60:	6105                	addi	sp,sp,32
    80001a62:	8082                	ret
    80001a64:	557d                	li	a0,-1
    80001a66:	9dbff0ef          	jal	80001440 <exit>
    80001a6a:	bf75                	j	80001a26 <usertrap+0x5e>
    80001a6c:	142025f3          	csrr	a1,scause
    80001a70:	5890                	lw	a2,48(s1)
    80001a72:	00006517          	auipc	a0,0x6
    80001a76:	85e50513          	addi	a0,a0,-1954 # 800072d0 <etext+0x2d0>
    80001a7a:	6b6030ef          	jal	80005130 <printf>
    80001a7e:	141025f3          	csrr	a1,sepc
    80001a82:	14302673          	csrr	a2,stval
    80001a86:	00006517          	auipc	a0,0x6
    80001a8a:	87a50513          	addi	a0,a0,-1926 # 80007300 <etext+0x300>
    80001a8e:	6a2030ef          	jal	80005130 <printf>
    80001a92:	8526                	mv	a0,s1
    80001a94:	ab5ff0ef          	jal	80001548 <setkilled>
    80001a98:	b75d                	j	80001a3e <usertrap+0x76>
    80001a9a:	86fff0ef          	jal	80001308 <yield>
    80001a9e:	bf5d                	j	80001a54 <usertrap+0x8c>

0000000080001aa0 <kerneltrap>:
    80001aa0:	7179                	addi	sp,sp,-48
    80001aa2:	f406                	sd	ra,40(sp)
    80001aa4:	f022                	sd	s0,32(sp)
    80001aa6:	ec26                	sd	s1,24(sp)
    80001aa8:	e84a                	sd	s2,16(sp)
    80001aaa:	e44e                	sd	s3,8(sp)
    80001aac:	1800                	addi	s0,sp,48
    80001aae:	14102973          	csrr	s2,sepc
    80001ab2:	100024f3          	csrr	s1,sstatus
    80001ab6:	142029f3          	csrr	s3,scause
    80001aba:	1004f793          	andi	a5,s1,256
    80001abe:	c795                	beqz	a5,80001aea <kerneltrap+0x4a>
    80001ac0:	100027f3          	csrr	a5,sstatus
    80001ac4:	8b89                	andi	a5,a5,2
    80001ac6:	eb85                	bnez	a5,80001af6 <kerneltrap+0x56>
    80001ac8:	e8dff0ef          	jal	80001954 <devintr>
    80001acc:	c91d                	beqz	a0,80001b02 <kerneltrap+0x62>
    80001ace:	4789                	li	a5,2
    80001ad0:	04f50a63          	beq	a0,a5,80001b24 <kerneltrap+0x84>
    80001ad4:	14191073          	csrw	sepc,s2
    80001ad8:	10049073          	csrw	sstatus,s1
    80001adc:	70a2                	ld	ra,40(sp)
    80001ade:	7402                	ld	s0,32(sp)
    80001ae0:	64e2                	ld	s1,24(sp)
    80001ae2:	6942                	ld	s2,16(sp)
    80001ae4:	69a2                	ld	s3,8(sp)
    80001ae6:	6145                	addi	sp,sp,48
    80001ae8:	8082                	ret
    80001aea:	00006517          	auipc	a0,0x6
    80001aee:	83e50513          	addi	a0,a0,-1986 # 80007328 <etext+0x328>
    80001af2:	111030ef          	jal	80005402 <panic>
    80001af6:	00006517          	auipc	a0,0x6
    80001afa:	85a50513          	addi	a0,a0,-1958 # 80007350 <etext+0x350>
    80001afe:	105030ef          	jal	80005402 <panic>
    80001b02:	14102673          	csrr	a2,sepc
    80001b06:	143026f3          	csrr	a3,stval
    80001b0a:	85ce                	mv	a1,s3
    80001b0c:	00006517          	auipc	a0,0x6
    80001b10:	86450513          	addi	a0,a0,-1948 # 80007370 <etext+0x370>
    80001b14:	61c030ef          	jal	80005130 <printf>
    80001b18:	00006517          	auipc	a0,0x6
    80001b1c:	88050513          	addi	a0,a0,-1920 # 80007398 <etext+0x398>
    80001b20:	0e3030ef          	jal	80005402 <panic>
    80001b24:	a42ff0ef          	jal	80000d66 <myproc>
    80001b28:	d555                	beqz	a0,80001ad4 <kerneltrap+0x34>
    80001b2a:	fdeff0ef          	jal	80001308 <yield>
    80001b2e:	b75d                	j	80001ad4 <kerneltrap+0x34>

0000000080001b30 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b30:	1101                	addi	sp,sp,-32
    80001b32:	ec06                	sd	ra,24(sp)
    80001b34:	e822                	sd	s0,16(sp)
    80001b36:	e426                	sd	s1,8(sp)
    80001b38:	1000                	addi	s0,sp,32
    80001b3a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b3c:	a2aff0ef          	jal	80000d66 <myproc>
  switch (n) {
    80001b40:	4795                	li	a5,5
    80001b42:	0497e163          	bltu	a5,s1,80001b84 <argraw+0x54>
    80001b46:	048a                	slli	s1,s1,0x2
    80001b48:	00006717          	auipc	a4,0x6
    80001b4c:	c5870713          	addi	a4,a4,-936 # 800077a0 <states.0+0x30>
    80001b50:	94ba                	add	s1,s1,a4
    80001b52:	409c                	lw	a5,0(s1)
    80001b54:	97ba                	add	a5,a5,a4
    80001b56:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b58:	6d3c                	ld	a5,88(a0)
    80001b5a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b5c:	60e2                	ld	ra,24(sp)
    80001b5e:	6442                	ld	s0,16(sp)
    80001b60:	64a2                	ld	s1,8(sp)
    80001b62:	6105                	addi	sp,sp,32
    80001b64:	8082                	ret
    return p->trapframe->a1;
    80001b66:	6d3c                	ld	a5,88(a0)
    80001b68:	7fa8                	ld	a0,120(a5)
    80001b6a:	bfcd                	j	80001b5c <argraw+0x2c>
    return p->trapframe->a2;
    80001b6c:	6d3c                	ld	a5,88(a0)
    80001b6e:	63c8                	ld	a0,128(a5)
    80001b70:	b7f5                	j	80001b5c <argraw+0x2c>
    return p->trapframe->a3;
    80001b72:	6d3c                	ld	a5,88(a0)
    80001b74:	67c8                	ld	a0,136(a5)
    80001b76:	b7dd                	j	80001b5c <argraw+0x2c>
    return p->trapframe->a4;
    80001b78:	6d3c                	ld	a5,88(a0)
    80001b7a:	6bc8                	ld	a0,144(a5)
    80001b7c:	b7c5                	j	80001b5c <argraw+0x2c>
    return p->trapframe->a5;
    80001b7e:	6d3c                	ld	a5,88(a0)
    80001b80:	6fc8                	ld	a0,152(a5)
    80001b82:	bfe9                	j	80001b5c <argraw+0x2c>
  panic("argraw");
    80001b84:	00006517          	auipc	a0,0x6
    80001b88:	82450513          	addi	a0,a0,-2012 # 800073a8 <etext+0x3a8>
    80001b8c:	077030ef          	jal	80005402 <panic>

0000000080001b90 <fetchaddr>:
{
    80001b90:	1101                	addi	sp,sp,-32
    80001b92:	ec06                	sd	ra,24(sp)
    80001b94:	e822                	sd	s0,16(sp)
    80001b96:	e426                	sd	s1,8(sp)
    80001b98:	e04a                	sd	s2,0(sp)
    80001b9a:	1000                	addi	s0,sp,32
    80001b9c:	84aa                	mv	s1,a0
    80001b9e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ba0:	9c6ff0ef          	jal	80000d66 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ba4:	653c                	ld	a5,72(a0)
    80001ba6:	02f4f663          	bgeu	s1,a5,80001bd2 <fetchaddr+0x42>
    80001baa:	00848713          	addi	a4,s1,8
    80001bae:	02e7e463          	bltu	a5,a4,80001bd6 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001bb2:	46a1                	li	a3,8
    80001bb4:	8626                	mv	a2,s1
    80001bb6:	85ca                	mv	a1,s2
    80001bb8:	6928                	ld	a0,80(a0)
    80001bba:	ef5fe0ef          	jal	80000aae <copyin>
    80001bbe:	00a03533          	snez	a0,a0
    80001bc2:	40a00533          	neg	a0,a0
}
    80001bc6:	60e2                	ld	ra,24(sp)
    80001bc8:	6442                	ld	s0,16(sp)
    80001bca:	64a2                	ld	s1,8(sp)
    80001bcc:	6902                	ld	s2,0(sp)
    80001bce:	6105                	addi	sp,sp,32
    80001bd0:	8082                	ret
    return -1;
    80001bd2:	557d                	li	a0,-1
    80001bd4:	bfcd                	j	80001bc6 <fetchaddr+0x36>
    80001bd6:	557d                	li	a0,-1
    80001bd8:	b7fd                	j	80001bc6 <fetchaddr+0x36>

0000000080001bda <fetchstr>:
{
    80001bda:	7179                	addi	sp,sp,-48
    80001bdc:	f406                	sd	ra,40(sp)
    80001bde:	f022                	sd	s0,32(sp)
    80001be0:	ec26                	sd	s1,24(sp)
    80001be2:	e84a                	sd	s2,16(sp)
    80001be4:	e44e                	sd	s3,8(sp)
    80001be6:	1800                	addi	s0,sp,48
    80001be8:	892a                	mv	s2,a0
    80001bea:	84ae                	mv	s1,a1
    80001bec:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001bee:	978ff0ef          	jal	80000d66 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001bf2:	86ce                	mv	a3,s3
    80001bf4:	864a                	mv	a2,s2
    80001bf6:	85a6                	mv	a1,s1
    80001bf8:	6928                	ld	a0,80(a0)
    80001bfa:	f3bfe0ef          	jal	80000b34 <copyinstr>
    80001bfe:	00054c63          	bltz	a0,80001c16 <fetchstr+0x3c>
  return strlen(buf);
    80001c02:	8526                	mv	a0,s1
    80001c04:	ebafe0ef          	jal	800002be <strlen>
}
    80001c08:	70a2                	ld	ra,40(sp)
    80001c0a:	7402                	ld	s0,32(sp)
    80001c0c:	64e2                	ld	s1,24(sp)
    80001c0e:	6942                	ld	s2,16(sp)
    80001c10:	69a2                	ld	s3,8(sp)
    80001c12:	6145                	addi	sp,sp,48
    80001c14:	8082                	ret
    return -1;
    80001c16:	557d                	li	a0,-1
    80001c18:	bfc5                	j	80001c08 <fetchstr+0x2e>

0000000080001c1a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c1a:	1101                	addi	sp,sp,-32
    80001c1c:	ec06                	sd	ra,24(sp)
    80001c1e:	e822                	sd	s0,16(sp)
    80001c20:	e426                	sd	s1,8(sp)
    80001c22:	1000                	addi	s0,sp,32
    80001c24:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c26:	f0bff0ef          	jal	80001b30 <argraw>
    80001c2a:	c088                	sw	a0,0(s1)
}
    80001c2c:	60e2                	ld	ra,24(sp)
    80001c2e:	6442                	ld	s0,16(sp)
    80001c30:	64a2                	ld	s1,8(sp)
    80001c32:	6105                	addi	sp,sp,32
    80001c34:	8082                	ret

0000000080001c36 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c36:	1101                	addi	sp,sp,-32
    80001c38:	ec06                	sd	ra,24(sp)
    80001c3a:	e822                	sd	s0,16(sp)
    80001c3c:	e426                	sd	s1,8(sp)
    80001c3e:	1000                	addi	s0,sp,32
    80001c40:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c42:	eefff0ef          	jal	80001b30 <argraw>
    80001c46:	e088                	sd	a0,0(s1)
}
    80001c48:	60e2                	ld	ra,24(sp)
    80001c4a:	6442                	ld	s0,16(sp)
    80001c4c:	64a2                	ld	s1,8(sp)
    80001c4e:	6105                	addi	sp,sp,32
    80001c50:	8082                	ret

0000000080001c52 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c52:	7179                	addi	sp,sp,-48
    80001c54:	f406                	sd	ra,40(sp)
    80001c56:	f022                	sd	s0,32(sp)
    80001c58:	ec26                	sd	s1,24(sp)
    80001c5a:	e84a                	sd	s2,16(sp)
    80001c5c:	1800                	addi	s0,sp,48
    80001c5e:	84ae                	mv	s1,a1
    80001c60:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001c62:	fd840593          	addi	a1,s0,-40
    80001c66:	fd1ff0ef          	jal	80001c36 <argaddr>
  return fetchstr(addr, buf, max);
    80001c6a:	864a                	mv	a2,s2
    80001c6c:	85a6                	mv	a1,s1
    80001c6e:	fd843503          	ld	a0,-40(s0)
    80001c72:	f69ff0ef          	jal	80001bda <fetchstr>
}
    80001c76:	70a2                	ld	ra,40(sp)
    80001c78:	7402                	ld	s0,32(sp)
    80001c7a:	64e2                	ld	s1,24(sp)
    80001c7c:	6942                	ld	s2,16(sp)
    80001c7e:	6145                	addi	sp,sp,48
    80001c80:	8082                	ret

0000000080001c82 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001c82:	1101                	addi	sp,sp,-32
    80001c84:	ec06                	sd	ra,24(sp)
    80001c86:	e822                	sd	s0,16(sp)
    80001c88:	e426                	sd	s1,8(sp)
    80001c8a:	e04a                	sd	s2,0(sp)
    80001c8c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001c8e:	8d8ff0ef          	jal	80000d66 <myproc>
    80001c92:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c94:	05853903          	ld	s2,88(a0)
    80001c98:	0a893783          	ld	a5,168(s2)
    80001c9c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001ca0:	37fd                	addiw	a5,a5,-1
    80001ca2:	4751                	li	a4,20
    80001ca4:	00f76f63          	bltu	a4,a5,80001cc2 <syscall+0x40>
    80001ca8:	00369713          	slli	a4,a3,0x3
    80001cac:	00006797          	auipc	a5,0x6
    80001cb0:	b0c78793          	addi	a5,a5,-1268 # 800077b8 <syscalls>
    80001cb4:	97ba                	add	a5,a5,a4
    80001cb6:	639c                	ld	a5,0(a5)
    80001cb8:	c789                	beqz	a5,80001cc2 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001cba:	9782                	jalr	a5
    80001cbc:	06a93823          	sd	a0,112(s2)
    80001cc0:	a829                	j	80001cda <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001cc2:	2d848613          	addi	a2,s1,728
    80001cc6:	588c                	lw	a1,48(s1)
    80001cc8:	00005517          	auipc	a0,0x5
    80001ccc:	6e850513          	addi	a0,a0,1768 # 800073b0 <etext+0x3b0>
    80001cd0:	460030ef          	jal	80005130 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001cd4:	6cbc                	ld	a5,88(s1)
    80001cd6:	577d                	li	a4,-1
    80001cd8:	fbb8                	sd	a4,112(a5)
  }
}
    80001cda:	60e2                	ld	ra,24(sp)
    80001cdc:	6442                	ld	s0,16(sp)
    80001cde:	64a2                	ld	s1,8(sp)
    80001ce0:	6902                	ld	s2,0(sp)
    80001ce2:	6105                	addi	sp,sp,32
    80001ce4:	8082                	ret

0000000080001ce6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001ce6:	1101                	addi	sp,sp,-32
    80001ce8:	ec06                	sd	ra,24(sp)
    80001cea:	e822                	sd	s0,16(sp)
    80001cec:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001cee:	fec40593          	addi	a1,s0,-20
    80001cf2:	4501                	li	a0,0
    80001cf4:	f27ff0ef          	jal	80001c1a <argint>
  exit(n);
    80001cf8:	fec42503          	lw	a0,-20(s0)
    80001cfc:	f44ff0ef          	jal	80001440 <exit>
  return 0;  // not reached
}
    80001d00:	4501                	li	a0,0
    80001d02:	60e2                	ld	ra,24(sp)
    80001d04:	6442                	ld	s0,16(sp)
    80001d06:	6105                	addi	sp,sp,32
    80001d08:	8082                	ret

0000000080001d0a <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d0a:	1141                	addi	sp,sp,-16
    80001d0c:	e406                	sd	ra,8(sp)
    80001d0e:	e022                	sd	s0,0(sp)
    80001d10:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d12:	854ff0ef          	jal	80000d66 <myproc>
}
    80001d16:	5908                	lw	a0,48(a0)
    80001d18:	60a2                	ld	ra,8(sp)
    80001d1a:	6402                	ld	s0,0(sp)
    80001d1c:	0141                	addi	sp,sp,16
    80001d1e:	8082                	ret

0000000080001d20 <sys_fork>:

uint64
sys_fork(void)
{
    80001d20:	1141                	addi	sp,sp,-16
    80001d22:	e406                	sd	ra,8(sp)
    80001d24:	e022                	sd	s0,0(sp)
    80001d26:	0800                	addi	s0,sp,16
  return fork();
    80001d28:	b64ff0ef          	jal	8000108c <fork>
}
    80001d2c:	60a2                	ld	ra,8(sp)
    80001d2e:	6402                	ld	s0,0(sp)
    80001d30:	0141                	addi	sp,sp,16
    80001d32:	8082                	ret

0000000080001d34 <sys_wait>:

uint64
sys_wait(void)
{
    80001d34:	1101                	addi	sp,sp,-32
    80001d36:	ec06                	sd	ra,24(sp)
    80001d38:	e822                	sd	s0,16(sp)
    80001d3a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d3c:	fe840593          	addi	a1,s0,-24
    80001d40:	4501                	li	a0,0
    80001d42:	ef5ff0ef          	jal	80001c36 <argaddr>
  return wait(p);
    80001d46:	fe843503          	ld	a0,-24(s0)
    80001d4a:	84dff0ef          	jal	80001596 <wait>
}
    80001d4e:	60e2                	ld	ra,24(sp)
    80001d50:	6442                	ld	s0,16(sp)
    80001d52:	6105                	addi	sp,sp,32
    80001d54:	8082                	ret

0000000080001d56 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d56:	7179                	addi	sp,sp,-48
    80001d58:	f406                	sd	ra,40(sp)
    80001d5a:	f022                	sd	s0,32(sp)
    80001d5c:	ec26                	sd	s1,24(sp)
    80001d5e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d60:	fdc40593          	addi	a1,s0,-36
    80001d64:	4501                	li	a0,0
    80001d66:	eb5ff0ef          	jal	80001c1a <argint>
  addr = myproc()->sz;
    80001d6a:	ffdfe0ef          	jal	80000d66 <myproc>
    80001d6e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d70:	fdc42503          	lw	a0,-36(s0)
    80001d74:	ac8ff0ef          	jal	8000103c <growproc>
    80001d78:	00054863          	bltz	a0,80001d88 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001d7c:	8526                	mv	a0,s1
    80001d7e:	70a2                	ld	ra,40(sp)
    80001d80:	7402                	ld	s0,32(sp)
    80001d82:	64e2                	ld	s1,24(sp)
    80001d84:	6145                	addi	sp,sp,48
    80001d86:	8082                	ret
    return -1;
    80001d88:	54fd                	li	s1,-1
    80001d8a:	bfcd                	j	80001d7c <sys_sbrk+0x26>

0000000080001d8c <sys_sleep>:

uint64
sys_sleep(void)
{
    80001d8c:	7139                	addi	sp,sp,-64
    80001d8e:	fc06                	sd	ra,56(sp)
    80001d90:	f822                	sd	s0,48(sp)
    80001d92:	f04a                	sd	s2,32(sp)
    80001d94:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001d96:	fcc40593          	addi	a1,s0,-52
    80001d9a:	4501                	li	a0,0
    80001d9c:	e7fff0ef          	jal	80001c1a <argint>
  if(n < 0)
    80001da0:	fcc42783          	lw	a5,-52(s0)
    80001da4:	0607c763          	bltz	a5,80001e12 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001da8:	00014517          	auipc	a0,0x14
    80001dac:	2b850513          	addi	a0,a0,696 # 80016060 <tickslock>
    80001db0:	181030ef          	jal	80005730 <acquire>
  ticks0 = ticks;
    80001db4:	00008917          	auipc	s2,0x8
    80001db8:	44492903          	lw	s2,1092(s2) # 8000a1f8 <ticks>
  while(ticks - ticks0 < n){
    80001dbc:	fcc42783          	lw	a5,-52(s0)
    80001dc0:	cf8d                	beqz	a5,80001dfa <sys_sleep+0x6e>
    80001dc2:	f426                	sd	s1,40(sp)
    80001dc4:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001dc6:	00014997          	auipc	s3,0x14
    80001dca:	29a98993          	addi	s3,s3,666 # 80016060 <tickslock>
    80001dce:	00008497          	auipc	s1,0x8
    80001dd2:	42a48493          	addi	s1,s1,1066 # 8000a1f8 <ticks>
    if(killed(myproc())){
    80001dd6:	f91fe0ef          	jal	80000d66 <myproc>
    80001dda:	f92ff0ef          	jal	8000156c <killed>
    80001dde:	ed0d                	bnez	a0,80001e18 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001de0:	85ce                	mv	a1,s3
    80001de2:	8526                	mv	a0,s1
    80001de4:	d50ff0ef          	jal	80001334 <sleep>
  while(ticks - ticks0 < n){
    80001de8:	409c                	lw	a5,0(s1)
    80001dea:	412787bb          	subw	a5,a5,s2
    80001dee:	fcc42703          	lw	a4,-52(s0)
    80001df2:	fee7e2e3          	bltu	a5,a4,80001dd6 <sys_sleep+0x4a>
    80001df6:	74a2                	ld	s1,40(sp)
    80001df8:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001dfa:	00014517          	auipc	a0,0x14
    80001dfe:	26650513          	addi	a0,a0,614 # 80016060 <tickslock>
    80001e02:	1c7030ef          	jal	800057c8 <release>
  return 0;
    80001e06:	4501                	li	a0,0
}
    80001e08:	70e2                	ld	ra,56(sp)
    80001e0a:	7442                	ld	s0,48(sp)
    80001e0c:	7902                	ld	s2,32(sp)
    80001e0e:	6121                	addi	sp,sp,64
    80001e10:	8082                	ret
    n = 0;
    80001e12:	fc042623          	sw	zero,-52(s0)
    80001e16:	bf49                	j	80001da8 <sys_sleep+0x1c>
      release(&tickslock);
    80001e18:	00014517          	auipc	a0,0x14
    80001e1c:	24850513          	addi	a0,a0,584 # 80016060 <tickslock>
    80001e20:	1a9030ef          	jal	800057c8 <release>
      return -1;
    80001e24:	557d                	li	a0,-1
    80001e26:	74a2                	ld	s1,40(sp)
    80001e28:	69e2                	ld	s3,24(sp)
    80001e2a:	bff9                	j	80001e08 <sys_sleep+0x7c>

0000000080001e2c <sys_kill>:

uint64
sys_kill(void)
{
    80001e2c:	1101                	addi	sp,sp,-32
    80001e2e:	ec06                	sd	ra,24(sp)
    80001e30:	e822                	sd	s0,16(sp)
    80001e32:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e34:	fec40593          	addi	a1,s0,-20
    80001e38:	4501                	li	a0,0
    80001e3a:	de1ff0ef          	jal	80001c1a <argint>
  return kill(pid);
    80001e3e:	fec42503          	lw	a0,-20(s0)
    80001e42:	ea0ff0ef          	jal	800014e2 <kill>
}
    80001e46:	60e2                	ld	ra,24(sp)
    80001e48:	6442                	ld	s0,16(sp)
    80001e4a:	6105                	addi	sp,sp,32
    80001e4c:	8082                	ret

0000000080001e4e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e4e:	1101                	addi	sp,sp,-32
    80001e50:	ec06                	sd	ra,24(sp)
    80001e52:	e822                	sd	s0,16(sp)
    80001e54:	e426                	sd	s1,8(sp)
    80001e56:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e58:	00014517          	auipc	a0,0x14
    80001e5c:	20850513          	addi	a0,a0,520 # 80016060 <tickslock>
    80001e60:	0d1030ef          	jal	80005730 <acquire>
  xticks = ticks;
    80001e64:	00008497          	auipc	s1,0x8
    80001e68:	3944a483          	lw	s1,916(s1) # 8000a1f8 <ticks>
  release(&tickslock);
    80001e6c:	00014517          	auipc	a0,0x14
    80001e70:	1f450513          	addi	a0,a0,500 # 80016060 <tickslock>
    80001e74:	155030ef          	jal	800057c8 <release>
  return xticks;
}
    80001e78:	02049513          	slli	a0,s1,0x20
    80001e7c:	9101                	srli	a0,a0,0x20
    80001e7e:	60e2                	ld	ra,24(sp)
    80001e80:	6442                	ld	s0,16(sp)
    80001e82:	64a2                	ld	s1,8(sp)
    80001e84:	6105                	addi	sp,sp,32
    80001e86:	8082                	ret

0000000080001e88 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001e88:	7179                	addi	sp,sp,-48
    80001e8a:	f406                	sd	ra,40(sp)
    80001e8c:	f022                	sd	s0,32(sp)
    80001e8e:	ec26                	sd	s1,24(sp)
    80001e90:	e84a                	sd	s2,16(sp)
    80001e92:	e44e                	sd	s3,8(sp)
    80001e94:	e052                	sd	s4,0(sp)
    80001e96:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001e98:	00005597          	auipc	a1,0x5
    80001e9c:	53858593          	addi	a1,a1,1336 # 800073d0 <etext+0x3d0>
    80001ea0:	00014517          	auipc	a0,0x14
    80001ea4:	1d850513          	addi	a0,a0,472 # 80016078 <bcache>
    80001ea8:	009030ef          	jal	800056b0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001eac:	00024797          	auipc	a5,0x24
    80001eb0:	1cc78793          	addi	a5,a5,460 # 80026078 <bcache+0x10000>
    80001eb4:	00024717          	auipc	a4,0x24
    80001eb8:	67c70713          	addi	a4,a4,1660 # 80026530 <bcache+0x104b8>
    80001ebc:	50e7b023          	sd	a4,1280(a5)
  bcache.head.next = &bcache.head;
    80001ec0:	50e7b423          	sd	a4,1288(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ec4:	00014497          	auipc	s1,0x14
    80001ec8:	1cc48493          	addi	s1,s1,460 # 80016090 <bcache+0x18>
    b->next = bcache.head.next;
    80001ecc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001ece:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001ed0:	00005a17          	auipc	s4,0x5
    80001ed4:	508a0a13          	addi	s4,s4,1288 # 800073d8 <etext+0x3d8>
    b->next = bcache.head.next;
    80001ed8:	50893783          	ld	a5,1288(s2)
    80001edc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001ede:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001ee2:	85d2                	mv	a1,s4
    80001ee4:	01048513          	addi	a0,s1,16
    80001ee8:	24c010ef          	jal	80003134 <initsleeplock>
    bcache.head.next->prev = b;
    80001eec:	50893783          	ld	a5,1288(s2)
    80001ef0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001ef2:	50993423          	sd	s1,1288(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ef6:	45848493          	addi	s1,s1,1112
    80001efa:	fd349fe3          	bne	s1,s3,80001ed8 <binit+0x50>
  }
}
    80001efe:	70a2                	ld	ra,40(sp)
    80001f00:	7402                	ld	s0,32(sp)
    80001f02:	64e2                	ld	s1,24(sp)
    80001f04:	6942                	ld	s2,16(sp)
    80001f06:	69a2                	ld	s3,8(sp)
    80001f08:	6a02                	ld	s4,0(sp)
    80001f0a:	6145                	addi	sp,sp,48
    80001f0c:	8082                	ret

0000000080001f0e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001f0e:	7179                	addi	sp,sp,-48
    80001f10:	f406                	sd	ra,40(sp)
    80001f12:	f022                	sd	s0,32(sp)
    80001f14:	ec26                	sd	s1,24(sp)
    80001f16:	e84a                	sd	s2,16(sp)
    80001f18:	e44e                	sd	s3,8(sp)
    80001f1a:	1800                	addi	s0,sp,48
    80001f1c:	892a                	mv	s2,a0
    80001f1e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001f20:	00014517          	auipc	a0,0x14
    80001f24:	15850513          	addi	a0,a0,344 # 80016078 <bcache>
    80001f28:	009030ef          	jal	80005730 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001f2c:	00024497          	auipc	s1,0x24
    80001f30:	6544b483          	ld	s1,1620(s1) # 80026580 <bcache+0x10508>
    80001f34:	00024797          	auipc	a5,0x24
    80001f38:	5fc78793          	addi	a5,a5,1532 # 80026530 <bcache+0x104b8>
    80001f3c:	02f48b63          	beq	s1,a5,80001f72 <bread+0x64>
    80001f40:	873e                	mv	a4,a5
    80001f42:	a021                	j	80001f4a <bread+0x3c>
    80001f44:	68a4                	ld	s1,80(s1)
    80001f46:	02e48663          	beq	s1,a4,80001f72 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001f4a:	449c                	lw	a5,8(s1)
    80001f4c:	ff279ce3          	bne	a5,s2,80001f44 <bread+0x36>
    80001f50:	44dc                	lw	a5,12(s1)
    80001f52:	ff3799e3          	bne	a5,s3,80001f44 <bread+0x36>
      b->refcnt++;
    80001f56:	40bc                	lw	a5,64(s1)
    80001f58:	2785                	addiw	a5,a5,1
    80001f5a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f5c:	00014517          	auipc	a0,0x14
    80001f60:	11c50513          	addi	a0,a0,284 # 80016078 <bcache>
    80001f64:	065030ef          	jal	800057c8 <release>
      acquiresleep(&b->lock);
    80001f68:	01048513          	addi	a0,s1,16
    80001f6c:	1fe010ef          	jal	8000316a <acquiresleep>
      return b;
    80001f70:	a889                	j	80001fc2 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f72:	00024497          	auipc	s1,0x24
    80001f76:	6064b483          	ld	s1,1542(s1) # 80026578 <bcache+0x10500>
    80001f7a:	00024797          	auipc	a5,0x24
    80001f7e:	5b678793          	addi	a5,a5,1462 # 80026530 <bcache+0x104b8>
    80001f82:	00f48863          	beq	s1,a5,80001f92 <bread+0x84>
    80001f86:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80001f88:	40bc                	lw	a5,64(s1)
    80001f8a:	cb91                	beqz	a5,80001f9e <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f8c:	64a4                	ld	s1,72(s1)
    80001f8e:	fee49de3          	bne	s1,a4,80001f88 <bread+0x7a>
  panic("bget: no buffers");
    80001f92:	00005517          	auipc	a0,0x5
    80001f96:	44e50513          	addi	a0,a0,1102 # 800073e0 <etext+0x3e0>
    80001f9a:	468030ef          	jal	80005402 <panic>
      b->dev = dev;
    80001f9e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80001fa2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80001fa6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80001faa:	4785                	li	a5,1
    80001fac:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001fae:	00014517          	auipc	a0,0x14
    80001fb2:	0ca50513          	addi	a0,a0,202 # 80016078 <bcache>
    80001fb6:	013030ef          	jal	800057c8 <release>
      acquiresleep(&b->lock);
    80001fba:	01048513          	addi	a0,s1,16
    80001fbe:	1ac010ef          	jal	8000316a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80001fc2:	409c                	lw	a5,0(s1)
    80001fc4:	cb89                	beqz	a5,80001fd6 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80001fc6:	8526                	mv	a0,s1
    80001fc8:	70a2                	ld	ra,40(sp)
    80001fca:	7402                	ld	s0,32(sp)
    80001fcc:	64e2                	ld	s1,24(sp)
    80001fce:	6942                	ld	s2,16(sp)
    80001fd0:	69a2                	ld	s3,8(sp)
    80001fd2:	6145                	addi	sp,sp,48
    80001fd4:	8082                	ret
    virtio_disk_rw(b, 0);
    80001fd6:	4581                	li	a1,0
    80001fd8:	8526                	mv	a0,s1
    80001fda:	1f7020ef          	jal	800049d0 <virtio_disk_rw>
    b->valid = 1;
    80001fde:	4785                	li	a5,1
    80001fe0:	c09c                	sw	a5,0(s1)
  return b;
    80001fe2:	b7d5                	j	80001fc6 <bread+0xb8>

0000000080001fe4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80001fe4:	1101                	addi	sp,sp,-32
    80001fe6:	ec06                	sd	ra,24(sp)
    80001fe8:	e822                	sd	s0,16(sp)
    80001fea:	e426                	sd	s1,8(sp)
    80001fec:	1000                	addi	s0,sp,32
    80001fee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001ff0:	0541                	addi	a0,a0,16
    80001ff2:	1f6010ef          	jal	800031e8 <holdingsleep>
    80001ff6:	c911                	beqz	a0,8000200a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80001ff8:	4585                	li	a1,1
    80001ffa:	8526                	mv	a0,s1
    80001ffc:	1d5020ef          	jal	800049d0 <virtio_disk_rw>
}
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	64a2                	ld	s1,8(sp)
    80002006:	6105                	addi	sp,sp,32
    80002008:	8082                	ret
    panic("bwrite");
    8000200a:	00005517          	auipc	a0,0x5
    8000200e:	3ee50513          	addi	a0,a0,1006 # 800073f8 <etext+0x3f8>
    80002012:	3f0030ef          	jal	80005402 <panic>

0000000080002016 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	e426                	sd	s1,8(sp)
    8000201e:	e04a                	sd	s2,0(sp)
    80002020:	1000                	addi	s0,sp,32
    80002022:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002024:	01050913          	addi	s2,a0,16
    80002028:	854a                	mv	a0,s2
    8000202a:	1be010ef          	jal	800031e8 <holdingsleep>
    8000202e:	c135                	beqz	a0,80002092 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002030:	854a                	mv	a0,s2
    80002032:	17e010ef          	jal	800031b0 <releasesleep>

  acquire(&bcache.lock);
    80002036:	00014517          	auipc	a0,0x14
    8000203a:	04250513          	addi	a0,a0,66 # 80016078 <bcache>
    8000203e:	6f2030ef          	jal	80005730 <acquire>
  b->refcnt--;
    80002042:	40bc                	lw	a5,64(s1)
    80002044:	37fd                	addiw	a5,a5,-1
    80002046:	0007871b          	sext.w	a4,a5
    8000204a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000204c:	e71d                	bnez	a4,8000207a <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000204e:	68b8                	ld	a4,80(s1)
    80002050:	64bc                	ld	a5,72(s1)
    80002052:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002054:	68b8                	ld	a4,80(s1)
    80002056:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002058:	00024797          	auipc	a5,0x24
    8000205c:	02078793          	addi	a5,a5,32 # 80026078 <bcache+0x10000>
    80002060:	5087b703          	ld	a4,1288(a5)
    80002064:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002066:	00024717          	auipc	a4,0x24
    8000206a:	4ca70713          	addi	a4,a4,1226 # 80026530 <bcache+0x104b8>
    8000206e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002070:	5087b703          	ld	a4,1288(a5)
    80002074:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002076:	5097b423          	sd	s1,1288(a5)
  }
  
  release(&bcache.lock);
    8000207a:	00014517          	auipc	a0,0x14
    8000207e:	ffe50513          	addi	a0,a0,-2 # 80016078 <bcache>
    80002082:	746030ef          	jal	800057c8 <release>
}
    80002086:	60e2                	ld	ra,24(sp)
    80002088:	6442                	ld	s0,16(sp)
    8000208a:	64a2                	ld	s1,8(sp)
    8000208c:	6902                	ld	s2,0(sp)
    8000208e:	6105                	addi	sp,sp,32
    80002090:	8082                	ret
    panic("brelse");
    80002092:	00005517          	auipc	a0,0x5
    80002096:	36e50513          	addi	a0,a0,878 # 80007400 <etext+0x400>
    8000209a:	368030ef          	jal	80005402 <panic>

000000008000209e <bpin>:

void
bpin(struct buf *b) {
    8000209e:	1101                	addi	sp,sp,-32
    800020a0:	ec06                	sd	ra,24(sp)
    800020a2:	e822                	sd	s0,16(sp)
    800020a4:	e426                	sd	s1,8(sp)
    800020a6:	1000                	addi	s0,sp,32
    800020a8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020aa:	00014517          	auipc	a0,0x14
    800020ae:	fce50513          	addi	a0,a0,-50 # 80016078 <bcache>
    800020b2:	67e030ef          	jal	80005730 <acquire>
  b->refcnt++;
    800020b6:	40bc                	lw	a5,64(s1)
    800020b8:	2785                	addiw	a5,a5,1
    800020ba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020bc:	00014517          	auipc	a0,0x14
    800020c0:	fbc50513          	addi	a0,a0,-68 # 80016078 <bcache>
    800020c4:	704030ef          	jal	800057c8 <release>
}
    800020c8:	60e2                	ld	ra,24(sp)
    800020ca:	6442                	ld	s0,16(sp)
    800020cc:	64a2                	ld	s1,8(sp)
    800020ce:	6105                	addi	sp,sp,32
    800020d0:	8082                	ret

00000000800020d2 <bunpin>:

void
bunpin(struct buf *b) {
    800020d2:	1101                	addi	sp,sp,-32
    800020d4:	ec06                	sd	ra,24(sp)
    800020d6:	e822                	sd	s0,16(sp)
    800020d8:	e426                	sd	s1,8(sp)
    800020da:	1000                	addi	s0,sp,32
    800020dc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020de:	00014517          	auipc	a0,0x14
    800020e2:	f9a50513          	addi	a0,a0,-102 # 80016078 <bcache>
    800020e6:	64a030ef          	jal	80005730 <acquire>
  b->refcnt--;
    800020ea:	40bc                	lw	a5,64(s1)
    800020ec:	37fd                	addiw	a5,a5,-1
    800020ee:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020f0:	00014517          	auipc	a0,0x14
    800020f4:	f8850513          	addi	a0,a0,-120 # 80016078 <bcache>
    800020f8:	6d0030ef          	jal	800057c8 <release>
}
    800020fc:	60e2                	ld	ra,24(sp)
    800020fe:	6442                	ld	s0,16(sp)
    80002100:	64a2                	ld	s1,8(sp)
    80002102:	6105                	addi	sp,sp,32
    80002104:	8082                	ret

0000000080002106 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002106:	1101                	addi	sp,sp,-32
    80002108:	ec06                	sd	ra,24(sp)
    8000210a:	e822                	sd	s0,16(sp)
    8000210c:	e426                	sd	s1,8(sp)
    8000210e:	e04a                	sd	s2,0(sp)
    80002110:	1000                	addi	s0,sp,32
    80002112:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002114:	00d5d59b          	srliw	a1,a1,0xd
    80002118:	00025797          	auipc	a5,0x25
    8000211c:	88c7a783          	lw	a5,-1908(a5) # 800269a4 <sb+0x1c>
    80002120:	9dbd                	addw	a1,a1,a5
    80002122:	dedff0ef          	jal	80001f0e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002126:	0074f713          	andi	a4,s1,7
    8000212a:	4785                	li	a5,1
    8000212c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002130:	14ce                	slli	s1,s1,0x33
    80002132:	90d9                	srli	s1,s1,0x36
    80002134:	00950733          	add	a4,a0,s1
    80002138:	05874703          	lbu	a4,88(a4)
    8000213c:	00e7f6b3          	and	a3,a5,a4
    80002140:	c29d                	beqz	a3,80002166 <bfree+0x60>
    80002142:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002144:	94aa                	add	s1,s1,a0
    80002146:	fff7c793          	not	a5,a5
    8000214a:	8f7d                	and	a4,a4,a5
    8000214c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002150:	713000ef          	jal	80003062 <log_write>
  brelse(bp);
    80002154:	854a                	mv	a0,s2
    80002156:	ec1ff0ef          	jal	80002016 <brelse>
}
    8000215a:	60e2                	ld	ra,24(sp)
    8000215c:	6442                	ld	s0,16(sp)
    8000215e:	64a2                	ld	s1,8(sp)
    80002160:	6902                	ld	s2,0(sp)
    80002162:	6105                	addi	sp,sp,32
    80002164:	8082                	ret
    panic("freeing free block");
    80002166:	00005517          	auipc	a0,0x5
    8000216a:	2a250513          	addi	a0,a0,674 # 80007408 <etext+0x408>
    8000216e:	294030ef          	jal	80005402 <panic>

0000000080002172 <balloc>:
{
    80002172:	711d                	addi	sp,sp,-96
    80002174:	ec86                	sd	ra,88(sp)
    80002176:	e8a2                	sd	s0,80(sp)
    80002178:	e4a6                	sd	s1,72(sp)
    8000217a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000217c:	00025797          	auipc	a5,0x25
    80002180:	8107a783          	lw	a5,-2032(a5) # 8002698c <sb+0x4>
    80002184:	0e078f63          	beqz	a5,80002282 <balloc+0x110>
    80002188:	e0ca                	sd	s2,64(sp)
    8000218a:	fc4e                	sd	s3,56(sp)
    8000218c:	f852                	sd	s4,48(sp)
    8000218e:	f456                	sd	s5,40(sp)
    80002190:	f05a                	sd	s6,32(sp)
    80002192:	ec5e                	sd	s7,24(sp)
    80002194:	e862                	sd	s8,16(sp)
    80002196:	e466                	sd	s9,8(sp)
    80002198:	8baa                	mv	s7,a0
    8000219a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000219c:	00024b17          	auipc	s6,0x24
    800021a0:	7ecb0b13          	addi	s6,s6,2028 # 80026988 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800021a4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800021a6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800021a8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800021aa:	6c89                	lui	s9,0x2
    800021ac:	a0b5                	j	80002218 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800021ae:	97ca                	add	a5,a5,s2
    800021b0:	8e55                	or	a2,a2,a3
    800021b2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800021b6:	854a                	mv	a0,s2
    800021b8:	6ab000ef          	jal	80003062 <log_write>
        brelse(bp);
    800021bc:	854a                	mv	a0,s2
    800021be:	e59ff0ef          	jal	80002016 <brelse>
  bp = bread(dev, bno);
    800021c2:	85a6                	mv	a1,s1
    800021c4:	855e                	mv	a0,s7
    800021c6:	d49ff0ef          	jal	80001f0e <bread>
    800021ca:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800021cc:	40000613          	li	a2,1024
    800021d0:	4581                	li	a1,0
    800021d2:	05850513          	addi	a0,a0,88
    800021d6:	f79fd0ef          	jal	8000014e <memset>
  log_write(bp);
    800021da:	854a                	mv	a0,s2
    800021dc:	687000ef          	jal	80003062 <log_write>
  brelse(bp);
    800021e0:	854a                	mv	a0,s2
    800021e2:	e35ff0ef          	jal	80002016 <brelse>
}
    800021e6:	6906                	ld	s2,64(sp)
    800021e8:	79e2                	ld	s3,56(sp)
    800021ea:	7a42                	ld	s4,48(sp)
    800021ec:	7aa2                	ld	s5,40(sp)
    800021ee:	7b02                	ld	s6,32(sp)
    800021f0:	6be2                	ld	s7,24(sp)
    800021f2:	6c42                	ld	s8,16(sp)
    800021f4:	6ca2                	ld	s9,8(sp)
}
    800021f6:	8526                	mv	a0,s1
    800021f8:	60e6                	ld	ra,88(sp)
    800021fa:	6446                	ld	s0,80(sp)
    800021fc:	64a6                	ld	s1,72(sp)
    800021fe:	6125                	addi	sp,sp,96
    80002200:	8082                	ret
    brelse(bp);
    80002202:	854a                	mv	a0,s2
    80002204:	e13ff0ef          	jal	80002016 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002208:	015c87bb          	addw	a5,s9,s5
    8000220c:	00078a9b          	sext.w	s5,a5
    80002210:	004b2703          	lw	a4,4(s6)
    80002214:	04eaff63          	bgeu	s5,a4,80002272 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002218:	41fad79b          	sraiw	a5,s5,0x1f
    8000221c:	0137d79b          	srliw	a5,a5,0x13
    80002220:	015787bb          	addw	a5,a5,s5
    80002224:	40d7d79b          	sraiw	a5,a5,0xd
    80002228:	01cb2583          	lw	a1,28(s6)
    8000222c:	9dbd                	addw	a1,a1,a5
    8000222e:	855e                	mv	a0,s7
    80002230:	cdfff0ef          	jal	80001f0e <bread>
    80002234:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002236:	004b2503          	lw	a0,4(s6)
    8000223a:	000a849b          	sext.w	s1,s5
    8000223e:	8762                	mv	a4,s8
    80002240:	fca4f1e3          	bgeu	s1,a0,80002202 <balloc+0x90>
      m = 1 << (bi % 8);
    80002244:	00777693          	andi	a3,a4,7
    80002248:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000224c:	41f7579b          	sraiw	a5,a4,0x1f
    80002250:	01d7d79b          	srliw	a5,a5,0x1d
    80002254:	9fb9                	addw	a5,a5,a4
    80002256:	4037d79b          	sraiw	a5,a5,0x3
    8000225a:	00f90633          	add	a2,s2,a5
    8000225e:	05864603          	lbu	a2,88(a2)
    80002262:	00c6f5b3          	and	a1,a3,a2
    80002266:	d5a1                	beqz	a1,800021ae <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002268:	2705                	addiw	a4,a4,1
    8000226a:	2485                	addiw	s1,s1,1
    8000226c:	fd471ae3          	bne	a4,s4,80002240 <balloc+0xce>
    80002270:	bf49                	j	80002202 <balloc+0x90>
    80002272:	6906                	ld	s2,64(sp)
    80002274:	79e2                	ld	s3,56(sp)
    80002276:	7a42                	ld	s4,48(sp)
    80002278:	7aa2                	ld	s5,40(sp)
    8000227a:	7b02                	ld	s6,32(sp)
    8000227c:	6be2                	ld	s7,24(sp)
    8000227e:	6c42                	ld	s8,16(sp)
    80002280:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002282:	00005517          	auipc	a0,0x5
    80002286:	19e50513          	addi	a0,a0,414 # 80007420 <etext+0x420>
    8000228a:	6a7020ef          	jal	80005130 <printf>
  return 0;
    8000228e:	4481                	li	s1,0
    80002290:	b79d                	j	800021f6 <balloc+0x84>

0000000080002292 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002292:	7179                	addi	sp,sp,-48
    80002294:	f406                	sd	ra,40(sp)
    80002296:	f022                	sd	s0,32(sp)
    80002298:	ec26                	sd	s1,24(sp)
    8000229a:	e84a                	sd	s2,16(sp)
    8000229c:	e44e                	sd	s3,8(sp)
    8000229e:	1800                	addi	s0,sp,48
    800022a0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800022a2:	47ad                	li	a5,11
    800022a4:	02b7e663          	bltu	a5,a1,800022d0 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800022a8:	02059793          	slli	a5,a1,0x20
    800022ac:	01e7d593          	srli	a1,a5,0x1e
    800022b0:	00b504b3          	add	s1,a0,a1
    800022b4:	0504a903          	lw	s2,80(s1)
    800022b8:	06091a63          	bnez	s2,8000232c <bmap+0x9a>
      addr = balloc(ip->dev);
    800022bc:	4108                	lw	a0,0(a0)
    800022be:	eb5ff0ef          	jal	80002172 <balloc>
    800022c2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800022c6:	06090363          	beqz	s2,8000232c <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800022ca:	0524a823          	sw	s2,80(s1)
    800022ce:	a8b9                	j	8000232c <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800022d0:	ff45849b          	addiw	s1,a1,-12
    800022d4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800022d8:	0ff00793          	li	a5,255
    800022dc:	06e7ee63          	bltu	a5,a4,80002358 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800022e0:	08052903          	lw	s2,128(a0)
    800022e4:	00091d63          	bnez	s2,800022fe <bmap+0x6c>
      addr = balloc(ip->dev);
    800022e8:	4108                	lw	a0,0(a0)
    800022ea:	e89ff0ef          	jal	80002172 <balloc>
    800022ee:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800022f2:	02090d63          	beqz	s2,8000232c <bmap+0x9a>
    800022f6:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800022f8:	0929a023          	sw	s2,128(s3)
    800022fc:	a011                	j	80002300 <bmap+0x6e>
    800022fe:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002300:	85ca                	mv	a1,s2
    80002302:	0009a503          	lw	a0,0(s3)
    80002306:	c09ff0ef          	jal	80001f0e <bread>
    8000230a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000230c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002310:	02049713          	slli	a4,s1,0x20
    80002314:	01e75593          	srli	a1,a4,0x1e
    80002318:	00b784b3          	add	s1,a5,a1
    8000231c:	0004a903          	lw	s2,0(s1)
    80002320:	00090e63          	beqz	s2,8000233c <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002324:	8552                	mv	a0,s4
    80002326:	cf1ff0ef          	jal	80002016 <brelse>
    return addr;
    8000232a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000232c:	854a                	mv	a0,s2
    8000232e:	70a2                	ld	ra,40(sp)
    80002330:	7402                	ld	s0,32(sp)
    80002332:	64e2                	ld	s1,24(sp)
    80002334:	6942                	ld	s2,16(sp)
    80002336:	69a2                	ld	s3,8(sp)
    80002338:	6145                	addi	sp,sp,48
    8000233a:	8082                	ret
      addr = balloc(ip->dev);
    8000233c:	0009a503          	lw	a0,0(s3)
    80002340:	e33ff0ef          	jal	80002172 <balloc>
    80002344:	0005091b          	sext.w	s2,a0
      if(addr){
    80002348:	fc090ee3          	beqz	s2,80002324 <bmap+0x92>
        a[bn] = addr;
    8000234c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002350:	8552                	mv	a0,s4
    80002352:	511000ef          	jal	80003062 <log_write>
    80002356:	b7f9                	j	80002324 <bmap+0x92>
    80002358:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000235a:	00005517          	auipc	a0,0x5
    8000235e:	0de50513          	addi	a0,a0,222 # 80007438 <etext+0x438>
    80002362:	0a0030ef          	jal	80005402 <panic>

0000000080002366 <iget>:
{
    80002366:	7179                	addi	sp,sp,-48
    80002368:	f406                	sd	ra,40(sp)
    8000236a:	f022                	sd	s0,32(sp)
    8000236c:	ec26                	sd	s1,24(sp)
    8000236e:	e84a                	sd	s2,16(sp)
    80002370:	e44e                	sd	s3,8(sp)
    80002372:	e052                	sd	s4,0(sp)
    80002374:	1800                	addi	s0,sp,48
    80002376:	89aa                	mv	s3,a0
    80002378:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000237a:	00024517          	auipc	a0,0x24
    8000237e:	62e50513          	addi	a0,a0,1582 # 800269a8 <itable>
    80002382:	3ae030ef          	jal	80005730 <acquire>
  empty = 0;
    80002386:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002388:	00024497          	auipc	s1,0x24
    8000238c:	63848493          	addi	s1,s1,1592 # 800269c0 <itable+0x18>
    80002390:	00026697          	auipc	a3,0x26
    80002394:	0c068693          	addi	a3,a3,192 # 80028450 <log>
    80002398:	a039                	j	800023a6 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000239a:	02090963          	beqz	s2,800023cc <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000239e:	08848493          	addi	s1,s1,136
    800023a2:	02d48863          	beq	s1,a3,800023d2 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800023a6:	449c                	lw	a5,8(s1)
    800023a8:	fef059e3          	blez	a5,8000239a <iget+0x34>
    800023ac:	4098                	lw	a4,0(s1)
    800023ae:	ff3716e3          	bne	a4,s3,8000239a <iget+0x34>
    800023b2:	40d8                	lw	a4,4(s1)
    800023b4:	ff4713e3          	bne	a4,s4,8000239a <iget+0x34>
      ip->ref++;
    800023b8:	2785                	addiw	a5,a5,1
    800023ba:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800023bc:	00024517          	auipc	a0,0x24
    800023c0:	5ec50513          	addi	a0,a0,1516 # 800269a8 <itable>
    800023c4:	404030ef          	jal	800057c8 <release>
      return ip;
    800023c8:	8926                	mv	s2,s1
    800023ca:	a02d                	j	800023f4 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800023cc:	fbe9                	bnez	a5,8000239e <iget+0x38>
      empty = ip;
    800023ce:	8926                	mv	s2,s1
    800023d0:	b7f9                	j	8000239e <iget+0x38>
  if(empty == 0)
    800023d2:	02090a63          	beqz	s2,80002406 <iget+0xa0>
  ip->dev = dev;
    800023d6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800023da:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800023de:	4785                	li	a5,1
    800023e0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800023e4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800023e8:	00024517          	auipc	a0,0x24
    800023ec:	5c050513          	addi	a0,a0,1472 # 800269a8 <itable>
    800023f0:	3d8030ef          	jal	800057c8 <release>
}
    800023f4:	854a                	mv	a0,s2
    800023f6:	70a2                	ld	ra,40(sp)
    800023f8:	7402                	ld	s0,32(sp)
    800023fa:	64e2                	ld	s1,24(sp)
    800023fc:	6942                	ld	s2,16(sp)
    800023fe:	69a2                	ld	s3,8(sp)
    80002400:	6a02                	ld	s4,0(sp)
    80002402:	6145                	addi	sp,sp,48
    80002404:	8082                	ret
    panic("iget: no inodes");
    80002406:	00005517          	auipc	a0,0x5
    8000240a:	04a50513          	addi	a0,a0,74 # 80007450 <etext+0x450>
    8000240e:	7f5020ef          	jal	80005402 <panic>

0000000080002412 <fsinit>:
fsinit(int dev) {
    80002412:	7179                	addi	sp,sp,-48
    80002414:	f406                	sd	ra,40(sp)
    80002416:	f022                	sd	s0,32(sp)
    80002418:	ec26                	sd	s1,24(sp)
    8000241a:	e84a                	sd	s2,16(sp)
    8000241c:	e44e                	sd	s3,8(sp)
    8000241e:	1800                	addi	s0,sp,48
    80002420:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002422:	4585                	li	a1,1
    80002424:	aebff0ef          	jal	80001f0e <bread>
    80002428:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000242a:	00024997          	auipc	s3,0x24
    8000242e:	55e98993          	addi	s3,s3,1374 # 80026988 <sb>
    80002432:	02000613          	li	a2,32
    80002436:	05850593          	addi	a1,a0,88
    8000243a:	854e                	mv	a0,s3
    8000243c:	d6ffd0ef          	jal	800001aa <memmove>
  brelse(bp);
    80002440:	8526                	mv	a0,s1
    80002442:	bd5ff0ef          	jal	80002016 <brelse>
  if(sb.magic != FSMAGIC)
    80002446:	0009a703          	lw	a4,0(s3)
    8000244a:	102037b7          	lui	a5,0x10203
    8000244e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002452:	02f71063          	bne	a4,a5,80002472 <fsinit+0x60>
  initlog(dev, &sb);
    80002456:	00024597          	auipc	a1,0x24
    8000245a:	53258593          	addi	a1,a1,1330 # 80026988 <sb>
    8000245e:	854a                	mv	a0,s2
    80002460:	1f9000ef          	jal	80002e58 <initlog>
}
    80002464:	70a2                	ld	ra,40(sp)
    80002466:	7402                	ld	s0,32(sp)
    80002468:	64e2                	ld	s1,24(sp)
    8000246a:	6942                	ld	s2,16(sp)
    8000246c:	69a2                	ld	s3,8(sp)
    8000246e:	6145                	addi	sp,sp,48
    80002470:	8082                	ret
    panic("invalid file system");
    80002472:	00005517          	auipc	a0,0x5
    80002476:	fee50513          	addi	a0,a0,-18 # 80007460 <etext+0x460>
    8000247a:	789020ef          	jal	80005402 <panic>

000000008000247e <iinit>:
{
    8000247e:	7179                	addi	sp,sp,-48
    80002480:	f406                	sd	ra,40(sp)
    80002482:	f022                	sd	s0,32(sp)
    80002484:	ec26                	sd	s1,24(sp)
    80002486:	e84a                	sd	s2,16(sp)
    80002488:	e44e                	sd	s3,8(sp)
    8000248a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000248c:	00005597          	auipc	a1,0x5
    80002490:	fec58593          	addi	a1,a1,-20 # 80007478 <etext+0x478>
    80002494:	00024517          	auipc	a0,0x24
    80002498:	51450513          	addi	a0,a0,1300 # 800269a8 <itable>
    8000249c:	214030ef          	jal	800056b0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800024a0:	00024497          	auipc	s1,0x24
    800024a4:	53048493          	addi	s1,s1,1328 # 800269d0 <itable+0x28>
    800024a8:	00026997          	auipc	s3,0x26
    800024ac:	fb898993          	addi	s3,s3,-72 # 80028460 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800024b0:	00005917          	auipc	s2,0x5
    800024b4:	fd090913          	addi	s2,s2,-48 # 80007480 <etext+0x480>
    800024b8:	85ca                	mv	a1,s2
    800024ba:	8526                	mv	a0,s1
    800024bc:	479000ef          	jal	80003134 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800024c0:	08848493          	addi	s1,s1,136
    800024c4:	ff349ae3          	bne	s1,s3,800024b8 <iinit+0x3a>
}
    800024c8:	70a2                	ld	ra,40(sp)
    800024ca:	7402                	ld	s0,32(sp)
    800024cc:	64e2                	ld	s1,24(sp)
    800024ce:	6942                	ld	s2,16(sp)
    800024d0:	69a2                	ld	s3,8(sp)
    800024d2:	6145                	addi	sp,sp,48
    800024d4:	8082                	ret

00000000800024d6 <ialloc>:
{
    800024d6:	7139                	addi	sp,sp,-64
    800024d8:	fc06                	sd	ra,56(sp)
    800024da:	f822                	sd	s0,48(sp)
    800024dc:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800024de:	00024717          	auipc	a4,0x24
    800024e2:	4b672703          	lw	a4,1206(a4) # 80026994 <sb+0xc>
    800024e6:	4785                	li	a5,1
    800024e8:	06e7f063          	bgeu	a5,a4,80002548 <ialloc+0x72>
    800024ec:	f426                	sd	s1,40(sp)
    800024ee:	f04a                	sd	s2,32(sp)
    800024f0:	ec4e                	sd	s3,24(sp)
    800024f2:	e852                	sd	s4,16(sp)
    800024f4:	e456                	sd	s5,8(sp)
    800024f6:	e05a                	sd	s6,0(sp)
    800024f8:	8aaa                	mv	s5,a0
    800024fa:	8b2e                	mv	s6,a1
    800024fc:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800024fe:	00024a17          	auipc	s4,0x24
    80002502:	48aa0a13          	addi	s4,s4,1162 # 80026988 <sb>
    80002506:	00495593          	srli	a1,s2,0x4
    8000250a:	018a2783          	lw	a5,24(s4)
    8000250e:	9dbd                	addw	a1,a1,a5
    80002510:	8556                	mv	a0,s5
    80002512:	9fdff0ef          	jal	80001f0e <bread>
    80002516:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002518:	05850993          	addi	s3,a0,88
    8000251c:	00f97793          	andi	a5,s2,15
    80002520:	079a                	slli	a5,a5,0x6
    80002522:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002524:	00099783          	lh	a5,0(s3)
    80002528:	cb9d                	beqz	a5,8000255e <ialloc+0x88>
    brelse(bp);
    8000252a:	aedff0ef          	jal	80002016 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000252e:	0905                	addi	s2,s2,1
    80002530:	00ca2703          	lw	a4,12(s4)
    80002534:	0009079b          	sext.w	a5,s2
    80002538:	fce7e7e3          	bltu	a5,a4,80002506 <ialloc+0x30>
    8000253c:	74a2                	ld	s1,40(sp)
    8000253e:	7902                	ld	s2,32(sp)
    80002540:	69e2                	ld	s3,24(sp)
    80002542:	6a42                	ld	s4,16(sp)
    80002544:	6aa2                	ld	s5,8(sp)
    80002546:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002548:	00005517          	auipc	a0,0x5
    8000254c:	f4050513          	addi	a0,a0,-192 # 80007488 <etext+0x488>
    80002550:	3e1020ef          	jal	80005130 <printf>
  return 0;
    80002554:	4501                	li	a0,0
}
    80002556:	70e2                	ld	ra,56(sp)
    80002558:	7442                	ld	s0,48(sp)
    8000255a:	6121                	addi	sp,sp,64
    8000255c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000255e:	04000613          	li	a2,64
    80002562:	4581                	li	a1,0
    80002564:	854e                	mv	a0,s3
    80002566:	be9fd0ef          	jal	8000014e <memset>
      dip->type = type;
    8000256a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000256e:	8526                	mv	a0,s1
    80002570:	2f3000ef          	jal	80003062 <log_write>
      brelse(bp);
    80002574:	8526                	mv	a0,s1
    80002576:	aa1ff0ef          	jal	80002016 <brelse>
      return iget(dev, inum);
    8000257a:	0009059b          	sext.w	a1,s2
    8000257e:	8556                	mv	a0,s5
    80002580:	de7ff0ef          	jal	80002366 <iget>
    80002584:	74a2                	ld	s1,40(sp)
    80002586:	7902                	ld	s2,32(sp)
    80002588:	69e2                	ld	s3,24(sp)
    8000258a:	6a42                	ld	s4,16(sp)
    8000258c:	6aa2                	ld	s5,8(sp)
    8000258e:	6b02                	ld	s6,0(sp)
    80002590:	b7d9                	j	80002556 <ialloc+0x80>

0000000080002592 <iupdate>:
{
    80002592:	1101                	addi	sp,sp,-32
    80002594:	ec06                	sd	ra,24(sp)
    80002596:	e822                	sd	s0,16(sp)
    80002598:	e426                	sd	s1,8(sp)
    8000259a:	e04a                	sd	s2,0(sp)
    8000259c:	1000                	addi	s0,sp,32
    8000259e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800025a0:	415c                	lw	a5,4(a0)
    800025a2:	0047d79b          	srliw	a5,a5,0x4
    800025a6:	00024597          	auipc	a1,0x24
    800025aa:	3fa5a583          	lw	a1,1018(a1) # 800269a0 <sb+0x18>
    800025ae:	9dbd                	addw	a1,a1,a5
    800025b0:	4108                	lw	a0,0(a0)
    800025b2:	95dff0ef          	jal	80001f0e <bread>
    800025b6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800025b8:	05850793          	addi	a5,a0,88
    800025bc:	40d8                	lw	a4,4(s1)
    800025be:	8b3d                	andi	a4,a4,15
    800025c0:	071a                	slli	a4,a4,0x6
    800025c2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800025c4:	04449703          	lh	a4,68(s1)
    800025c8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800025cc:	04649703          	lh	a4,70(s1)
    800025d0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800025d4:	04849703          	lh	a4,72(s1)
    800025d8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800025dc:	04a49703          	lh	a4,74(s1)
    800025e0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800025e4:	44f8                	lw	a4,76(s1)
    800025e6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800025e8:	03400613          	li	a2,52
    800025ec:	05048593          	addi	a1,s1,80
    800025f0:	00c78513          	addi	a0,a5,12
    800025f4:	bb7fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    800025f8:	854a                	mv	a0,s2
    800025fa:	269000ef          	jal	80003062 <log_write>
  brelse(bp);
    800025fe:	854a                	mv	a0,s2
    80002600:	a17ff0ef          	jal	80002016 <brelse>
}
    80002604:	60e2                	ld	ra,24(sp)
    80002606:	6442                	ld	s0,16(sp)
    80002608:	64a2                	ld	s1,8(sp)
    8000260a:	6902                	ld	s2,0(sp)
    8000260c:	6105                	addi	sp,sp,32
    8000260e:	8082                	ret

0000000080002610 <idup>:
{
    80002610:	1101                	addi	sp,sp,-32
    80002612:	ec06                	sd	ra,24(sp)
    80002614:	e822                	sd	s0,16(sp)
    80002616:	e426                	sd	s1,8(sp)
    80002618:	1000                	addi	s0,sp,32
    8000261a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000261c:	00024517          	auipc	a0,0x24
    80002620:	38c50513          	addi	a0,a0,908 # 800269a8 <itable>
    80002624:	10c030ef          	jal	80005730 <acquire>
  ip->ref++;
    80002628:	449c                	lw	a5,8(s1)
    8000262a:	2785                	addiw	a5,a5,1
    8000262c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000262e:	00024517          	auipc	a0,0x24
    80002632:	37a50513          	addi	a0,a0,890 # 800269a8 <itable>
    80002636:	192030ef          	jal	800057c8 <release>
}
    8000263a:	8526                	mv	a0,s1
    8000263c:	60e2                	ld	ra,24(sp)
    8000263e:	6442                	ld	s0,16(sp)
    80002640:	64a2                	ld	s1,8(sp)
    80002642:	6105                	addi	sp,sp,32
    80002644:	8082                	ret

0000000080002646 <ilock>:
{
    80002646:	1101                	addi	sp,sp,-32
    80002648:	ec06                	sd	ra,24(sp)
    8000264a:	e822                	sd	s0,16(sp)
    8000264c:	e426                	sd	s1,8(sp)
    8000264e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002650:	cd19                	beqz	a0,8000266e <ilock+0x28>
    80002652:	84aa                	mv	s1,a0
    80002654:	451c                	lw	a5,8(a0)
    80002656:	00f05c63          	blez	a5,8000266e <ilock+0x28>
  acquiresleep(&ip->lock);
    8000265a:	0541                	addi	a0,a0,16
    8000265c:	30f000ef          	jal	8000316a <acquiresleep>
  if(ip->valid == 0){
    80002660:	40bc                	lw	a5,64(s1)
    80002662:	cf89                	beqz	a5,8000267c <ilock+0x36>
}
    80002664:	60e2                	ld	ra,24(sp)
    80002666:	6442                	ld	s0,16(sp)
    80002668:	64a2                	ld	s1,8(sp)
    8000266a:	6105                	addi	sp,sp,32
    8000266c:	8082                	ret
    8000266e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002670:	00005517          	auipc	a0,0x5
    80002674:	e3050513          	addi	a0,a0,-464 # 800074a0 <etext+0x4a0>
    80002678:	58b020ef          	jal	80005402 <panic>
    8000267c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000267e:	40dc                	lw	a5,4(s1)
    80002680:	0047d79b          	srliw	a5,a5,0x4
    80002684:	00024597          	auipc	a1,0x24
    80002688:	31c5a583          	lw	a1,796(a1) # 800269a0 <sb+0x18>
    8000268c:	9dbd                	addw	a1,a1,a5
    8000268e:	4088                	lw	a0,0(s1)
    80002690:	87fff0ef          	jal	80001f0e <bread>
    80002694:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002696:	05850593          	addi	a1,a0,88
    8000269a:	40dc                	lw	a5,4(s1)
    8000269c:	8bbd                	andi	a5,a5,15
    8000269e:	079a                	slli	a5,a5,0x6
    800026a0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800026a2:	00059783          	lh	a5,0(a1)
    800026a6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800026aa:	00259783          	lh	a5,2(a1)
    800026ae:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800026b2:	00459783          	lh	a5,4(a1)
    800026b6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800026ba:	00659783          	lh	a5,6(a1)
    800026be:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800026c2:	459c                	lw	a5,8(a1)
    800026c4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800026c6:	03400613          	li	a2,52
    800026ca:	05b1                	addi	a1,a1,12
    800026cc:	05048513          	addi	a0,s1,80
    800026d0:	adbfd0ef          	jal	800001aa <memmove>
    brelse(bp);
    800026d4:	854a                	mv	a0,s2
    800026d6:	941ff0ef          	jal	80002016 <brelse>
    ip->valid = 1;
    800026da:	4785                	li	a5,1
    800026dc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800026de:	04449783          	lh	a5,68(s1)
    800026e2:	c399                	beqz	a5,800026e8 <ilock+0xa2>
    800026e4:	6902                	ld	s2,0(sp)
    800026e6:	bfbd                	j	80002664 <ilock+0x1e>
      panic("ilock: no type");
    800026e8:	00005517          	auipc	a0,0x5
    800026ec:	dc050513          	addi	a0,a0,-576 # 800074a8 <etext+0x4a8>
    800026f0:	513020ef          	jal	80005402 <panic>

00000000800026f4 <iunlock>:
{
    800026f4:	1101                	addi	sp,sp,-32
    800026f6:	ec06                	sd	ra,24(sp)
    800026f8:	e822                	sd	s0,16(sp)
    800026fa:	e426                	sd	s1,8(sp)
    800026fc:	e04a                	sd	s2,0(sp)
    800026fe:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002700:	c505                	beqz	a0,80002728 <iunlock+0x34>
    80002702:	84aa                	mv	s1,a0
    80002704:	01050913          	addi	s2,a0,16
    80002708:	854a                	mv	a0,s2
    8000270a:	2df000ef          	jal	800031e8 <holdingsleep>
    8000270e:	cd09                	beqz	a0,80002728 <iunlock+0x34>
    80002710:	449c                	lw	a5,8(s1)
    80002712:	00f05b63          	blez	a5,80002728 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002716:	854a                	mv	a0,s2
    80002718:	299000ef          	jal	800031b0 <releasesleep>
}
    8000271c:	60e2                	ld	ra,24(sp)
    8000271e:	6442                	ld	s0,16(sp)
    80002720:	64a2                	ld	s1,8(sp)
    80002722:	6902                	ld	s2,0(sp)
    80002724:	6105                	addi	sp,sp,32
    80002726:	8082                	ret
    panic("iunlock");
    80002728:	00005517          	auipc	a0,0x5
    8000272c:	d9050513          	addi	a0,a0,-624 # 800074b8 <etext+0x4b8>
    80002730:	4d3020ef          	jal	80005402 <panic>

0000000080002734 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002734:	7179                	addi	sp,sp,-48
    80002736:	f406                	sd	ra,40(sp)
    80002738:	f022                	sd	s0,32(sp)
    8000273a:	ec26                	sd	s1,24(sp)
    8000273c:	e84a                	sd	s2,16(sp)
    8000273e:	e44e                	sd	s3,8(sp)
    80002740:	1800                	addi	s0,sp,48
    80002742:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002744:	05050493          	addi	s1,a0,80
    80002748:	08050913          	addi	s2,a0,128
    8000274c:	a021                	j	80002754 <itrunc+0x20>
    8000274e:	0491                	addi	s1,s1,4
    80002750:	01248b63          	beq	s1,s2,80002766 <itrunc+0x32>
    if(ip->addrs[i]){
    80002754:	408c                	lw	a1,0(s1)
    80002756:	dde5                	beqz	a1,8000274e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002758:	0009a503          	lw	a0,0(s3)
    8000275c:	9abff0ef          	jal	80002106 <bfree>
      ip->addrs[i] = 0;
    80002760:	0004a023          	sw	zero,0(s1)
    80002764:	b7ed                	j	8000274e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002766:	0809a583          	lw	a1,128(s3)
    8000276a:	ed89                	bnez	a1,80002784 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000276c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002770:	854e                	mv	a0,s3
    80002772:	e21ff0ef          	jal	80002592 <iupdate>
}
    80002776:	70a2                	ld	ra,40(sp)
    80002778:	7402                	ld	s0,32(sp)
    8000277a:	64e2                	ld	s1,24(sp)
    8000277c:	6942                	ld	s2,16(sp)
    8000277e:	69a2                	ld	s3,8(sp)
    80002780:	6145                	addi	sp,sp,48
    80002782:	8082                	ret
    80002784:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002786:	0009a503          	lw	a0,0(s3)
    8000278a:	f84ff0ef          	jal	80001f0e <bread>
    8000278e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002790:	05850493          	addi	s1,a0,88
    80002794:	45850913          	addi	s2,a0,1112
    80002798:	a021                	j	800027a0 <itrunc+0x6c>
    8000279a:	0491                	addi	s1,s1,4
    8000279c:	01248963          	beq	s1,s2,800027ae <itrunc+0x7a>
      if(a[j])
    800027a0:	408c                	lw	a1,0(s1)
    800027a2:	dde5                	beqz	a1,8000279a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800027a4:	0009a503          	lw	a0,0(s3)
    800027a8:	95fff0ef          	jal	80002106 <bfree>
    800027ac:	b7fd                	j	8000279a <itrunc+0x66>
    brelse(bp);
    800027ae:	8552                	mv	a0,s4
    800027b0:	867ff0ef          	jal	80002016 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800027b4:	0809a583          	lw	a1,128(s3)
    800027b8:	0009a503          	lw	a0,0(s3)
    800027bc:	94bff0ef          	jal	80002106 <bfree>
    ip->addrs[NDIRECT] = 0;
    800027c0:	0809a023          	sw	zero,128(s3)
    800027c4:	6a02                	ld	s4,0(sp)
    800027c6:	b75d                	j	8000276c <itrunc+0x38>

00000000800027c8 <iput>:
{
    800027c8:	1101                	addi	sp,sp,-32
    800027ca:	ec06                	sd	ra,24(sp)
    800027cc:	e822                	sd	s0,16(sp)
    800027ce:	e426                	sd	s1,8(sp)
    800027d0:	1000                	addi	s0,sp,32
    800027d2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800027d4:	00024517          	auipc	a0,0x24
    800027d8:	1d450513          	addi	a0,a0,468 # 800269a8 <itable>
    800027dc:	755020ef          	jal	80005730 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800027e0:	4498                	lw	a4,8(s1)
    800027e2:	4785                	li	a5,1
    800027e4:	02f70063          	beq	a4,a5,80002804 <iput+0x3c>
  ip->ref--;
    800027e8:	449c                	lw	a5,8(s1)
    800027ea:	37fd                	addiw	a5,a5,-1
    800027ec:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800027ee:	00024517          	auipc	a0,0x24
    800027f2:	1ba50513          	addi	a0,a0,442 # 800269a8 <itable>
    800027f6:	7d3020ef          	jal	800057c8 <release>
}
    800027fa:	60e2                	ld	ra,24(sp)
    800027fc:	6442                	ld	s0,16(sp)
    800027fe:	64a2                	ld	s1,8(sp)
    80002800:	6105                	addi	sp,sp,32
    80002802:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002804:	40bc                	lw	a5,64(s1)
    80002806:	d3ed                	beqz	a5,800027e8 <iput+0x20>
    80002808:	04a49783          	lh	a5,74(s1)
    8000280c:	fff1                	bnez	a5,800027e8 <iput+0x20>
    8000280e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002810:	01048913          	addi	s2,s1,16
    80002814:	854a                	mv	a0,s2
    80002816:	155000ef          	jal	8000316a <acquiresleep>
    release(&itable.lock);
    8000281a:	00024517          	auipc	a0,0x24
    8000281e:	18e50513          	addi	a0,a0,398 # 800269a8 <itable>
    80002822:	7a7020ef          	jal	800057c8 <release>
    itrunc(ip);
    80002826:	8526                	mv	a0,s1
    80002828:	f0dff0ef          	jal	80002734 <itrunc>
    ip->type = 0;
    8000282c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002830:	8526                	mv	a0,s1
    80002832:	d61ff0ef          	jal	80002592 <iupdate>
    ip->valid = 0;
    80002836:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000283a:	854a                	mv	a0,s2
    8000283c:	175000ef          	jal	800031b0 <releasesleep>
    acquire(&itable.lock);
    80002840:	00024517          	auipc	a0,0x24
    80002844:	16850513          	addi	a0,a0,360 # 800269a8 <itable>
    80002848:	6e9020ef          	jal	80005730 <acquire>
    8000284c:	6902                	ld	s2,0(sp)
    8000284e:	bf69                	j	800027e8 <iput+0x20>

0000000080002850 <iunlockput>:
{
    80002850:	1101                	addi	sp,sp,-32
    80002852:	ec06                	sd	ra,24(sp)
    80002854:	e822                	sd	s0,16(sp)
    80002856:	e426                	sd	s1,8(sp)
    80002858:	1000                	addi	s0,sp,32
    8000285a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000285c:	e99ff0ef          	jal	800026f4 <iunlock>
  iput(ip);
    80002860:	8526                	mv	a0,s1
    80002862:	f67ff0ef          	jal	800027c8 <iput>
}
    80002866:	60e2                	ld	ra,24(sp)
    80002868:	6442                	ld	s0,16(sp)
    8000286a:	64a2                	ld	s1,8(sp)
    8000286c:	6105                	addi	sp,sp,32
    8000286e:	8082                	ret

0000000080002870 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002870:	1141                	addi	sp,sp,-16
    80002872:	e422                	sd	s0,8(sp)
    80002874:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002876:	411c                	lw	a5,0(a0)
    80002878:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000287a:	415c                	lw	a5,4(a0)
    8000287c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000287e:	04451783          	lh	a5,68(a0)
    80002882:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002886:	04a51783          	lh	a5,74(a0)
    8000288a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000288e:	04c56783          	lwu	a5,76(a0)
    80002892:	e99c                	sd	a5,16(a1)
}
    80002894:	6422                	ld	s0,8(sp)
    80002896:	0141                	addi	sp,sp,16
    80002898:	8082                	ret

000000008000289a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000289a:	457c                	lw	a5,76(a0)
    8000289c:	0ed7eb63          	bltu	a5,a3,80002992 <readi+0xf8>
{
    800028a0:	7159                	addi	sp,sp,-112
    800028a2:	f486                	sd	ra,104(sp)
    800028a4:	f0a2                	sd	s0,96(sp)
    800028a6:	eca6                	sd	s1,88(sp)
    800028a8:	e0d2                	sd	s4,64(sp)
    800028aa:	fc56                	sd	s5,56(sp)
    800028ac:	f85a                	sd	s6,48(sp)
    800028ae:	f45e                	sd	s7,40(sp)
    800028b0:	1880                	addi	s0,sp,112
    800028b2:	8b2a                	mv	s6,a0
    800028b4:	8bae                	mv	s7,a1
    800028b6:	8a32                	mv	s4,a2
    800028b8:	84b6                	mv	s1,a3
    800028ba:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800028bc:	9f35                	addw	a4,a4,a3
    return 0;
    800028be:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800028c0:	0cd76063          	bltu	a4,a3,80002980 <readi+0xe6>
    800028c4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800028c6:	00e7f463          	bgeu	a5,a4,800028ce <readi+0x34>
    n = ip->size - off;
    800028ca:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800028ce:	080a8f63          	beqz	s5,8000296c <readi+0xd2>
    800028d2:	e8ca                	sd	s2,80(sp)
    800028d4:	f062                	sd	s8,32(sp)
    800028d6:	ec66                	sd	s9,24(sp)
    800028d8:	e86a                	sd	s10,16(sp)
    800028da:	e46e                	sd	s11,8(sp)
    800028dc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800028de:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800028e2:	5c7d                	li	s8,-1
    800028e4:	a80d                	j	80002916 <readi+0x7c>
    800028e6:	020d1d93          	slli	s11,s10,0x20
    800028ea:	020ddd93          	srli	s11,s11,0x20
    800028ee:	05890613          	addi	a2,s2,88
    800028f2:	86ee                	mv	a3,s11
    800028f4:	963a                	add	a2,a2,a4
    800028f6:	85d2                	mv	a1,s4
    800028f8:	855e                	mv	a0,s7
    800028fa:	d97fe0ef          	jal	80001690 <either_copyout>
    800028fe:	05850763          	beq	a0,s8,8000294c <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002902:	854a                	mv	a0,s2
    80002904:	f12ff0ef          	jal	80002016 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002908:	013d09bb          	addw	s3,s10,s3
    8000290c:	009d04bb          	addw	s1,s10,s1
    80002910:	9a6e                	add	s4,s4,s11
    80002912:	0559f763          	bgeu	s3,s5,80002960 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002916:	00a4d59b          	srliw	a1,s1,0xa
    8000291a:	855a                	mv	a0,s6
    8000291c:	977ff0ef          	jal	80002292 <bmap>
    80002920:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002924:	c5b1                	beqz	a1,80002970 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002926:	000b2503          	lw	a0,0(s6)
    8000292a:	de4ff0ef          	jal	80001f0e <bread>
    8000292e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002930:	3ff4f713          	andi	a4,s1,1023
    80002934:	40ec87bb          	subw	a5,s9,a4
    80002938:	413a86bb          	subw	a3,s5,s3
    8000293c:	8d3e                	mv	s10,a5
    8000293e:	2781                	sext.w	a5,a5
    80002940:	0006861b          	sext.w	a2,a3
    80002944:	faf671e3          	bgeu	a2,a5,800028e6 <readi+0x4c>
    80002948:	8d36                	mv	s10,a3
    8000294a:	bf71                	j	800028e6 <readi+0x4c>
      brelse(bp);
    8000294c:	854a                	mv	a0,s2
    8000294e:	ec8ff0ef          	jal	80002016 <brelse>
      tot = -1;
    80002952:	59fd                	li	s3,-1
      break;
    80002954:	6946                	ld	s2,80(sp)
    80002956:	7c02                	ld	s8,32(sp)
    80002958:	6ce2                	ld	s9,24(sp)
    8000295a:	6d42                	ld	s10,16(sp)
    8000295c:	6da2                	ld	s11,8(sp)
    8000295e:	a831                	j	8000297a <readi+0xe0>
    80002960:	6946                	ld	s2,80(sp)
    80002962:	7c02                	ld	s8,32(sp)
    80002964:	6ce2                	ld	s9,24(sp)
    80002966:	6d42                	ld	s10,16(sp)
    80002968:	6da2                	ld	s11,8(sp)
    8000296a:	a801                	j	8000297a <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000296c:	89d6                	mv	s3,s5
    8000296e:	a031                	j	8000297a <readi+0xe0>
    80002970:	6946                	ld	s2,80(sp)
    80002972:	7c02                	ld	s8,32(sp)
    80002974:	6ce2                	ld	s9,24(sp)
    80002976:	6d42                	ld	s10,16(sp)
    80002978:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000297a:	0009851b          	sext.w	a0,s3
    8000297e:	69a6                	ld	s3,72(sp)
}
    80002980:	70a6                	ld	ra,104(sp)
    80002982:	7406                	ld	s0,96(sp)
    80002984:	64e6                	ld	s1,88(sp)
    80002986:	6a06                	ld	s4,64(sp)
    80002988:	7ae2                	ld	s5,56(sp)
    8000298a:	7b42                	ld	s6,48(sp)
    8000298c:	7ba2                	ld	s7,40(sp)
    8000298e:	6165                	addi	sp,sp,112
    80002990:	8082                	ret
    return 0;
    80002992:	4501                	li	a0,0
}
    80002994:	8082                	ret

0000000080002996 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002996:	457c                	lw	a5,76(a0)
    80002998:	10d7e063          	bltu	a5,a3,80002a98 <writei+0x102>
{
    8000299c:	7159                	addi	sp,sp,-112
    8000299e:	f486                	sd	ra,104(sp)
    800029a0:	f0a2                	sd	s0,96(sp)
    800029a2:	e8ca                	sd	s2,80(sp)
    800029a4:	e0d2                	sd	s4,64(sp)
    800029a6:	fc56                	sd	s5,56(sp)
    800029a8:	f85a                	sd	s6,48(sp)
    800029aa:	f45e                	sd	s7,40(sp)
    800029ac:	1880                	addi	s0,sp,112
    800029ae:	8aaa                	mv	s5,a0
    800029b0:	8bae                	mv	s7,a1
    800029b2:	8a32                	mv	s4,a2
    800029b4:	8936                	mv	s2,a3
    800029b6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800029b8:	00e687bb          	addw	a5,a3,a4
    800029bc:	0ed7e063          	bltu	a5,a3,80002a9c <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800029c0:	00043737          	lui	a4,0x43
    800029c4:	0cf76e63          	bltu	a4,a5,80002aa0 <writei+0x10a>
    800029c8:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800029ca:	0a0b0f63          	beqz	s6,80002a88 <writei+0xf2>
    800029ce:	eca6                	sd	s1,88(sp)
    800029d0:	f062                	sd	s8,32(sp)
    800029d2:	ec66                	sd	s9,24(sp)
    800029d4:	e86a                	sd	s10,16(sp)
    800029d6:	e46e                	sd	s11,8(sp)
    800029d8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029da:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800029de:	5c7d                	li	s8,-1
    800029e0:	a825                	j	80002a18 <writei+0x82>
    800029e2:	020d1d93          	slli	s11,s10,0x20
    800029e6:	020ddd93          	srli	s11,s11,0x20
    800029ea:	05848513          	addi	a0,s1,88
    800029ee:	86ee                	mv	a3,s11
    800029f0:	8652                	mv	a2,s4
    800029f2:	85de                	mv	a1,s7
    800029f4:	953a                	add	a0,a0,a4
    800029f6:	ce5fe0ef          	jal	800016da <either_copyin>
    800029fa:	05850a63          	beq	a0,s8,80002a4e <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800029fe:	8526                	mv	a0,s1
    80002a00:	662000ef          	jal	80003062 <log_write>
    brelse(bp);
    80002a04:	8526                	mv	a0,s1
    80002a06:	e10ff0ef          	jal	80002016 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a0a:	013d09bb          	addw	s3,s10,s3
    80002a0e:	012d093b          	addw	s2,s10,s2
    80002a12:	9a6e                	add	s4,s4,s11
    80002a14:	0569f063          	bgeu	s3,s6,80002a54 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002a18:	00a9559b          	srliw	a1,s2,0xa
    80002a1c:	8556                	mv	a0,s5
    80002a1e:	875ff0ef          	jal	80002292 <bmap>
    80002a22:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a26:	c59d                	beqz	a1,80002a54 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002a28:	000aa503          	lw	a0,0(s5)
    80002a2c:	ce2ff0ef          	jal	80001f0e <bread>
    80002a30:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a32:	3ff97713          	andi	a4,s2,1023
    80002a36:	40ec87bb          	subw	a5,s9,a4
    80002a3a:	413b06bb          	subw	a3,s6,s3
    80002a3e:	8d3e                	mv	s10,a5
    80002a40:	2781                	sext.w	a5,a5
    80002a42:	0006861b          	sext.w	a2,a3
    80002a46:	f8f67ee3          	bgeu	a2,a5,800029e2 <writei+0x4c>
    80002a4a:	8d36                	mv	s10,a3
    80002a4c:	bf59                	j	800029e2 <writei+0x4c>
      brelse(bp);
    80002a4e:	8526                	mv	a0,s1
    80002a50:	dc6ff0ef          	jal	80002016 <brelse>
  }

  if(off > ip->size)
    80002a54:	04caa783          	lw	a5,76(s5)
    80002a58:	0327fa63          	bgeu	a5,s2,80002a8c <writei+0xf6>
    ip->size = off;
    80002a5c:	052aa623          	sw	s2,76(s5)
    80002a60:	64e6                	ld	s1,88(sp)
    80002a62:	7c02                	ld	s8,32(sp)
    80002a64:	6ce2                	ld	s9,24(sp)
    80002a66:	6d42                	ld	s10,16(sp)
    80002a68:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002a6a:	8556                	mv	a0,s5
    80002a6c:	b27ff0ef          	jal	80002592 <iupdate>

  return tot;
    80002a70:	0009851b          	sext.w	a0,s3
    80002a74:	69a6                	ld	s3,72(sp)
}
    80002a76:	70a6                	ld	ra,104(sp)
    80002a78:	7406                	ld	s0,96(sp)
    80002a7a:	6946                	ld	s2,80(sp)
    80002a7c:	6a06                	ld	s4,64(sp)
    80002a7e:	7ae2                	ld	s5,56(sp)
    80002a80:	7b42                	ld	s6,48(sp)
    80002a82:	7ba2                	ld	s7,40(sp)
    80002a84:	6165                	addi	sp,sp,112
    80002a86:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a88:	89da                	mv	s3,s6
    80002a8a:	b7c5                	j	80002a6a <writei+0xd4>
    80002a8c:	64e6                	ld	s1,88(sp)
    80002a8e:	7c02                	ld	s8,32(sp)
    80002a90:	6ce2                	ld	s9,24(sp)
    80002a92:	6d42                	ld	s10,16(sp)
    80002a94:	6da2                	ld	s11,8(sp)
    80002a96:	bfd1                	j	80002a6a <writei+0xd4>
    return -1;
    80002a98:	557d                	li	a0,-1
}
    80002a9a:	8082                	ret
    return -1;
    80002a9c:	557d                	li	a0,-1
    80002a9e:	bfe1                	j	80002a76 <writei+0xe0>
    return -1;
    80002aa0:	557d                	li	a0,-1
    80002aa2:	bfd1                	j	80002a76 <writei+0xe0>

0000000080002aa4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002aa4:	1141                	addi	sp,sp,-16
    80002aa6:	e406                	sd	ra,8(sp)
    80002aa8:	e022                	sd	s0,0(sp)
    80002aaa:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002aac:	4639                	li	a2,14
    80002aae:	f6cfd0ef          	jal	8000021a <strncmp>
}
    80002ab2:	60a2                	ld	ra,8(sp)
    80002ab4:	6402                	ld	s0,0(sp)
    80002ab6:	0141                	addi	sp,sp,16
    80002ab8:	8082                	ret

0000000080002aba <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002aba:	7139                	addi	sp,sp,-64
    80002abc:	fc06                	sd	ra,56(sp)
    80002abe:	f822                	sd	s0,48(sp)
    80002ac0:	f426                	sd	s1,40(sp)
    80002ac2:	f04a                	sd	s2,32(sp)
    80002ac4:	ec4e                	sd	s3,24(sp)
    80002ac6:	e852                	sd	s4,16(sp)
    80002ac8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002aca:	04451703          	lh	a4,68(a0)
    80002ace:	4785                	li	a5,1
    80002ad0:	00f71a63          	bne	a4,a5,80002ae4 <dirlookup+0x2a>
    80002ad4:	892a                	mv	s2,a0
    80002ad6:	89ae                	mv	s3,a1
    80002ad8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ada:	457c                	lw	a5,76(a0)
    80002adc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ade:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ae0:	e39d                	bnez	a5,80002b06 <dirlookup+0x4c>
    80002ae2:	a095                	j	80002b46 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002ae4:	00005517          	auipc	a0,0x5
    80002ae8:	9dc50513          	addi	a0,a0,-1572 # 800074c0 <etext+0x4c0>
    80002aec:	117020ef          	jal	80005402 <panic>
      panic("dirlookup read");
    80002af0:	00005517          	auipc	a0,0x5
    80002af4:	9e850513          	addi	a0,a0,-1560 # 800074d8 <etext+0x4d8>
    80002af8:	10b020ef          	jal	80005402 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002afc:	24c1                	addiw	s1,s1,16
    80002afe:	04c92783          	lw	a5,76(s2)
    80002b02:	04f4f163          	bgeu	s1,a5,80002b44 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002b06:	4741                	li	a4,16
    80002b08:	86a6                	mv	a3,s1
    80002b0a:	fc040613          	addi	a2,s0,-64
    80002b0e:	4581                	li	a1,0
    80002b10:	854a                	mv	a0,s2
    80002b12:	d89ff0ef          	jal	8000289a <readi>
    80002b16:	47c1                	li	a5,16
    80002b18:	fcf51ce3          	bne	a0,a5,80002af0 <dirlookup+0x36>
    if(de.inum == 0)
    80002b1c:	fc045783          	lhu	a5,-64(s0)
    80002b20:	dff1                	beqz	a5,80002afc <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002b22:	fc240593          	addi	a1,s0,-62
    80002b26:	854e                	mv	a0,s3
    80002b28:	f7dff0ef          	jal	80002aa4 <namecmp>
    80002b2c:	f961                	bnez	a0,80002afc <dirlookup+0x42>
      if(poff)
    80002b2e:	000a0463          	beqz	s4,80002b36 <dirlookup+0x7c>
        *poff = off;
    80002b32:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002b36:	fc045583          	lhu	a1,-64(s0)
    80002b3a:	00092503          	lw	a0,0(s2)
    80002b3e:	829ff0ef          	jal	80002366 <iget>
    80002b42:	a011                	j	80002b46 <dirlookup+0x8c>
  return 0;
    80002b44:	4501                	li	a0,0
}
    80002b46:	70e2                	ld	ra,56(sp)
    80002b48:	7442                	ld	s0,48(sp)
    80002b4a:	74a2                	ld	s1,40(sp)
    80002b4c:	7902                	ld	s2,32(sp)
    80002b4e:	69e2                	ld	s3,24(sp)
    80002b50:	6a42                	ld	s4,16(sp)
    80002b52:	6121                	addi	sp,sp,64
    80002b54:	8082                	ret

0000000080002b56 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002b56:	711d                	addi	sp,sp,-96
    80002b58:	ec86                	sd	ra,88(sp)
    80002b5a:	e8a2                	sd	s0,80(sp)
    80002b5c:	e4a6                	sd	s1,72(sp)
    80002b5e:	e0ca                	sd	s2,64(sp)
    80002b60:	fc4e                	sd	s3,56(sp)
    80002b62:	f852                	sd	s4,48(sp)
    80002b64:	f456                	sd	s5,40(sp)
    80002b66:	f05a                	sd	s6,32(sp)
    80002b68:	ec5e                	sd	s7,24(sp)
    80002b6a:	e862                	sd	s8,16(sp)
    80002b6c:	e466                	sd	s9,8(sp)
    80002b6e:	1080                	addi	s0,sp,96
    80002b70:	84aa                	mv	s1,a0
    80002b72:	8b2e                	mv	s6,a1
    80002b74:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002b76:	00054703          	lbu	a4,0(a0)
    80002b7a:	02f00793          	li	a5,47
    80002b7e:	00f70e63          	beq	a4,a5,80002b9a <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002b82:	9e4fe0ef          	jal	80000d66 <myproc>
    80002b86:	2d053503          	ld	a0,720(a0)
    80002b8a:	a87ff0ef          	jal	80002610 <idup>
    80002b8e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002b90:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002b94:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002b96:	4b85                	li	s7,1
    80002b98:	a871                	j	80002c34 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002b9a:	4585                	li	a1,1
    80002b9c:	4505                	li	a0,1
    80002b9e:	fc8ff0ef          	jal	80002366 <iget>
    80002ba2:	8a2a                	mv	s4,a0
    80002ba4:	b7f5                	j	80002b90 <namex+0x3a>
      iunlockput(ip);
    80002ba6:	8552                	mv	a0,s4
    80002ba8:	ca9ff0ef          	jal	80002850 <iunlockput>
      return 0;
    80002bac:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002bae:	8552                	mv	a0,s4
    80002bb0:	60e6                	ld	ra,88(sp)
    80002bb2:	6446                	ld	s0,80(sp)
    80002bb4:	64a6                	ld	s1,72(sp)
    80002bb6:	6906                	ld	s2,64(sp)
    80002bb8:	79e2                	ld	s3,56(sp)
    80002bba:	7a42                	ld	s4,48(sp)
    80002bbc:	7aa2                	ld	s5,40(sp)
    80002bbe:	7b02                	ld	s6,32(sp)
    80002bc0:	6be2                	ld	s7,24(sp)
    80002bc2:	6c42                	ld	s8,16(sp)
    80002bc4:	6ca2                	ld	s9,8(sp)
    80002bc6:	6125                	addi	sp,sp,96
    80002bc8:	8082                	ret
      iunlock(ip);
    80002bca:	8552                	mv	a0,s4
    80002bcc:	b29ff0ef          	jal	800026f4 <iunlock>
      return ip;
    80002bd0:	bff9                	j	80002bae <namex+0x58>
      iunlockput(ip);
    80002bd2:	8552                	mv	a0,s4
    80002bd4:	c7dff0ef          	jal	80002850 <iunlockput>
      return 0;
    80002bd8:	8a4e                	mv	s4,s3
    80002bda:	bfd1                	j	80002bae <namex+0x58>
  len = path - s;
    80002bdc:	40998633          	sub	a2,s3,s1
    80002be0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002be4:	099c5063          	bge	s8,s9,80002c64 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002be8:	4639                	li	a2,14
    80002bea:	85a6                	mv	a1,s1
    80002bec:	8556                	mv	a0,s5
    80002bee:	dbcfd0ef          	jal	800001aa <memmove>
    80002bf2:	84ce                	mv	s1,s3
  while(*path == '/')
    80002bf4:	0004c783          	lbu	a5,0(s1)
    80002bf8:	01279763          	bne	a5,s2,80002c06 <namex+0xb0>
    path++;
    80002bfc:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002bfe:	0004c783          	lbu	a5,0(s1)
    80002c02:	ff278de3          	beq	a5,s2,80002bfc <namex+0xa6>
    ilock(ip);
    80002c06:	8552                	mv	a0,s4
    80002c08:	a3fff0ef          	jal	80002646 <ilock>
    if(ip->type != T_DIR){
    80002c0c:	044a1783          	lh	a5,68(s4)
    80002c10:	f9779be3          	bne	a5,s7,80002ba6 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002c14:	000b0563          	beqz	s6,80002c1e <namex+0xc8>
    80002c18:	0004c783          	lbu	a5,0(s1)
    80002c1c:	d7dd                	beqz	a5,80002bca <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002c1e:	4601                	li	a2,0
    80002c20:	85d6                	mv	a1,s5
    80002c22:	8552                	mv	a0,s4
    80002c24:	e97ff0ef          	jal	80002aba <dirlookup>
    80002c28:	89aa                	mv	s3,a0
    80002c2a:	d545                	beqz	a0,80002bd2 <namex+0x7c>
    iunlockput(ip);
    80002c2c:	8552                	mv	a0,s4
    80002c2e:	c23ff0ef          	jal	80002850 <iunlockput>
    ip = next;
    80002c32:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002c34:	0004c783          	lbu	a5,0(s1)
    80002c38:	01279763          	bne	a5,s2,80002c46 <namex+0xf0>
    path++;
    80002c3c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002c3e:	0004c783          	lbu	a5,0(s1)
    80002c42:	ff278de3          	beq	a5,s2,80002c3c <namex+0xe6>
  if(*path == 0)
    80002c46:	cb8d                	beqz	a5,80002c78 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002c48:	0004c783          	lbu	a5,0(s1)
    80002c4c:	89a6                	mv	s3,s1
  len = path - s;
    80002c4e:	4c81                	li	s9,0
    80002c50:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002c52:	01278963          	beq	a5,s2,80002c64 <namex+0x10e>
    80002c56:	d3d9                	beqz	a5,80002bdc <namex+0x86>
    path++;
    80002c58:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002c5a:	0009c783          	lbu	a5,0(s3)
    80002c5e:	ff279ce3          	bne	a5,s2,80002c56 <namex+0x100>
    80002c62:	bfad                	j	80002bdc <namex+0x86>
    memmove(name, s, len);
    80002c64:	2601                	sext.w	a2,a2
    80002c66:	85a6                	mv	a1,s1
    80002c68:	8556                	mv	a0,s5
    80002c6a:	d40fd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002c6e:	9cd6                	add	s9,s9,s5
    80002c70:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002c74:	84ce                	mv	s1,s3
    80002c76:	bfbd                	j	80002bf4 <namex+0x9e>
  if(nameiparent){
    80002c78:	f20b0be3          	beqz	s6,80002bae <namex+0x58>
    iput(ip);
    80002c7c:	8552                	mv	a0,s4
    80002c7e:	b4bff0ef          	jal	800027c8 <iput>
    return 0;
    80002c82:	4a01                	li	s4,0
    80002c84:	b72d                	j	80002bae <namex+0x58>

0000000080002c86 <dirlink>:
{
    80002c86:	7139                	addi	sp,sp,-64
    80002c88:	fc06                	sd	ra,56(sp)
    80002c8a:	f822                	sd	s0,48(sp)
    80002c8c:	f04a                	sd	s2,32(sp)
    80002c8e:	ec4e                	sd	s3,24(sp)
    80002c90:	e852                	sd	s4,16(sp)
    80002c92:	0080                	addi	s0,sp,64
    80002c94:	892a                	mv	s2,a0
    80002c96:	8a2e                	mv	s4,a1
    80002c98:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002c9a:	4601                	li	a2,0
    80002c9c:	e1fff0ef          	jal	80002aba <dirlookup>
    80002ca0:	e535                	bnez	a0,80002d0c <dirlink+0x86>
    80002ca2:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ca4:	04c92483          	lw	s1,76(s2)
    80002ca8:	c48d                	beqz	s1,80002cd2 <dirlink+0x4c>
    80002caa:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cac:	4741                	li	a4,16
    80002cae:	86a6                	mv	a3,s1
    80002cb0:	fc040613          	addi	a2,s0,-64
    80002cb4:	4581                	li	a1,0
    80002cb6:	854a                	mv	a0,s2
    80002cb8:	be3ff0ef          	jal	8000289a <readi>
    80002cbc:	47c1                	li	a5,16
    80002cbe:	04f51b63          	bne	a0,a5,80002d14 <dirlink+0x8e>
    if(de.inum == 0)
    80002cc2:	fc045783          	lhu	a5,-64(s0)
    80002cc6:	c791                	beqz	a5,80002cd2 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cc8:	24c1                	addiw	s1,s1,16
    80002cca:	04c92783          	lw	a5,76(s2)
    80002cce:	fcf4efe3          	bltu	s1,a5,80002cac <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002cd2:	4639                	li	a2,14
    80002cd4:	85d2                	mv	a1,s4
    80002cd6:	fc240513          	addi	a0,s0,-62
    80002cda:	d76fd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80002cde:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ce2:	4741                	li	a4,16
    80002ce4:	86a6                	mv	a3,s1
    80002ce6:	fc040613          	addi	a2,s0,-64
    80002cea:	4581                	li	a1,0
    80002cec:	854a                	mv	a0,s2
    80002cee:	ca9ff0ef          	jal	80002996 <writei>
    80002cf2:	1541                	addi	a0,a0,-16
    80002cf4:	00a03533          	snez	a0,a0
    80002cf8:	40a00533          	neg	a0,a0
    80002cfc:	74a2                	ld	s1,40(sp)
}
    80002cfe:	70e2                	ld	ra,56(sp)
    80002d00:	7442                	ld	s0,48(sp)
    80002d02:	7902                	ld	s2,32(sp)
    80002d04:	69e2                	ld	s3,24(sp)
    80002d06:	6a42                	ld	s4,16(sp)
    80002d08:	6121                	addi	sp,sp,64
    80002d0a:	8082                	ret
    iput(ip);
    80002d0c:	abdff0ef          	jal	800027c8 <iput>
    return -1;
    80002d10:	557d                	li	a0,-1
    80002d12:	b7f5                	j	80002cfe <dirlink+0x78>
      panic("dirlink read");
    80002d14:	00004517          	auipc	a0,0x4
    80002d18:	7d450513          	addi	a0,a0,2004 # 800074e8 <etext+0x4e8>
    80002d1c:	6e6020ef          	jal	80005402 <panic>

0000000080002d20 <namei>:

struct inode*
namei(char *path)
{
    80002d20:	1101                	addi	sp,sp,-32
    80002d22:	ec06                	sd	ra,24(sp)
    80002d24:	e822                	sd	s0,16(sp)
    80002d26:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002d28:	fe040613          	addi	a2,s0,-32
    80002d2c:	4581                	li	a1,0
    80002d2e:	e29ff0ef          	jal	80002b56 <namex>
}
    80002d32:	60e2                	ld	ra,24(sp)
    80002d34:	6442                	ld	s0,16(sp)
    80002d36:	6105                	addi	sp,sp,32
    80002d38:	8082                	ret

0000000080002d3a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002d3a:	1141                	addi	sp,sp,-16
    80002d3c:	e406                	sd	ra,8(sp)
    80002d3e:	e022                	sd	s0,0(sp)
    80002d40:	0800                	addi	s0,sp,16
    80002d42:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002d44:	4585                	li	a1,1
    80002d46:	e11ff0ef          	jal	80002b56 <namex>
}
    80002d4a:	60a2                	ld	ra,8(sp)
    80002d4c:	6402                	ld	s0,0(sp)
    80002d4e:	0141                	addi	sp,sp,16
    80002d50:	8082                	ret

0000000080002d52 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002d52:	1101                	addi	sp,sp,-32
    80002d54:	ec06                	sd	ra,24(sp)
    80002d56:	e822                	sd	s0,16(sp)
    80002d58:	e426                	sd	s1,8(sp)
    80002d5a:	e04a                	sd	s2,0(sp)
    80002d5c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002d5e:	00025917          	auipc	s2,0x25
    80002d62:	6f290913          	addi	s2,s2,1778 # 80028450 <log>
    80002d66:	01892583          	lw	a1,24(s2)
    80002d6a:	02892503          	lw	a0,40(s2)
    80002d6e:	9a0ff0ef          	jal	80001f0e <bread>
    80002d72:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002d74:	02c92603          	lw	a2,44(s2)
    80002d78:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002d7a:	00c05f63          	blez	a2,80002d98 <write_head+0x46>
    80002d7e:	00025717          	auipc	a4,0x25
    80002d82:	70270713          	addi	a4,a4,1794 # 80028480 <log+0x30>
    80002d86:	87aa                	mv	a5,a0
    80002d88:	060a                	slli	a2,a2,0x2
    80002d8a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002d8c:	4314                	lw	a3,0(a4)
    80002d8e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002d90:	0711                	addi	a4,a4,4
    80002d92:	0791                	addi	a5,a5,4
    80002d94:	fec79ce3          	bne	a5,a2,80002d8c <write_head+0x3a>
  }
  bwrite(buf);
    80002d98:	8526                	mv	a0,s1
    80002d9a:	a4aff0ef          	jal	80001fe4 <bwrite>
  brelse(buf);
    80002d9e:	8526                	mv	a0,s1
    80002da0:	a76ff0ef          	jal	80002016 <brelse>
}
    80002da4:	60e2                	ld	ra,24(sp)
    80002da6:	6442                	ld	s0,16(sp)
    80002da8:	64a2                	ld	s1,8(sp)
    80002daa:	6902                	ld	s2,0(sp)
    80002dac:	6105                	addi	sp,sp,32
    80002dae:	8082                	ret

0000000080002db0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002db0:	00025797          	auipc	a5,0x25
    80002db4:	6cc7a783          	lw	a5,1740(a5) # 8002847c <log+0x2c>
    80002db8:	08f05f63          	blez	a5,80002e56 <install_trans+0xa6>
{
    80002dbc:	7139                	addi	sp,sp,-64
    80002dbe:	fc06                	sd	ra,56(sp)
    80002dc0:	f822                	sd	s0,48(sp)
    80002dc2:	f426                	sd	s1,40(sp)
    80002dc4:	f04a                	sd	s2,32(sp)
    80002dc6:	ec4e                	sd	s3,24(sp)
    80002dc8:	e852                	sd	s4,16(sp)
    80002dca:	e456                	sd	s5,8(sp)
    80002dcc:	e05a                	sd	s6,0(sp)
    80002dce:	0080                	addi	s0,sp,64
    80002dd0:	8b2a                	mv	s6,a0
    80002dd2:	00025a97          	auipc	s5,0x25
    80002dd6:	6aea8a93          	addi	s5,s5,1710 # 80028480 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002dda:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ddc:	00025997          	auipc	s3,0x25
    80002de0:	67498993          	addi	s3,s3,1652 # 80028450 <log>
    80002de4:	a829                	j	80002dfe <install_trans+0x4e>
    brelse(lbuf);
    80002de6:	854a                	mv	a0,s2
    80002de8:	a2eff0ef          	jal	80002016 <brelse>
    brelse(dbuf);
    80002dec:	8526                	mv	a0,s1
    80002dee:	a28ff0ef          	jal	80002016 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002df2:	2a05                	addiw	s4,s4,1
    80002df4:	0a91                	addi	s5,s5,4
    80002df6:	02c9a783          	lw	a5,44(s3)
    80002dfa:	04fa5463          	bge	s4,a5,80002e42 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002dfe:	0189a583          	lw	a1,24(s3)
    80002e02:	014585bb          	addw	a1,a1,s4
    80002e06:	2585                	addiw	a1,a1,1
    80002e08:	0289a503          	lw	a0,40(s3)
    80002e0c:	902ff0ef          	jal	80001f0e <bread>
    80002e10:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002e12:	000aa583          	lw	a1,0(s5)
    80002e16:	0289a503          	lw	a0,40(s3)
    80002e1a:	8f4ff0ef          	jal	80001f0e <bread>
    80002e1e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002e20:	40000613          	li	a2,1024
    80002e24:	05890593          	addi	a1,s2,88
    80002e28:	05850513          	addi	a0,a0,88
    80002e2c:	b7efd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80002e30:	8526                	mv	a0,s1
    80002e32:	9b2ff0ef          	jal	80001fe4 <bwrite>
    if(recovering == 0)
    80002e36:	fa0b18e3          	bnez	s6,80002de6 <install_trans+0x36>
      bunpin(dbuf);
    80002e3a:	8526                	mv	a0,s1
    80002e3c:	a96ff0ef          	jal	800020d2 <bunpin>
    80002e40:	b75d                	j	80002de6 <install_trans+0x36>
}
    80002e42:	70e2                	ld	ra,56(sp)
    80002e44:	7442                	ld	s0,48(sp)
    80002e46:	74a2                	ld	s1,40(sp)
    80002e48:	7902                	ld	s2,32(sp)
    80002e4a:	69e2                	ld	s3,24(sp)
    80002e4c:	6a42                	ld	s4,16(sp)
    80002e4e:	6aa2                	ld	s5,8(sp)
    80002e50:	6b02                	ld	s6,0(sp)
    80002e52:	6121                	addi	sp,sp,64
    80002e54:	8082                	ret
    80002e56:	8082                	ret

0000000080002e58 <initlog>:
{
    80002e58:	7179                	addi	sp,sp,-48
    80002e5a:	f406                	sd	ra,40(sp)
    80002e5c:	f022                	sd	s0,32(sp)
    80002e5e:	ec26                	sd	s1,24(sp)
    80002e60:	e84a                	sd	s2,16(sp)
    80002e62:	e44e                	sd	s3,8(sp)
    80002e64:	1800                	addi	s0,sp,48
    80002e66:	892a                	mv	s2,a0
    80002e68:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002e6a:	00025497          	auipc	s1,0x25
    80002e6e:	5e648493          	addi	s1,s1,1510 # 80028450 <log>
    80002e72:	00004597          	auipc	a1,0x4
    80002e76:	68658593          	addi	a1,a1,1670 # 800074f8 <etext+0x4f8>
    80002e7a:	8526                	mv	a0,s1
    80002e7c:	035020ef          	jal	800056b0 <initlock>
  log.start = sb->logstart;
    80002e80:	0149a583          	lw	a1,20(s3)
    80002e84:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002e86:	0109a783          	lw	a5,16(s3)
    80002e8a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002e8c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002e90:	854a                	mv	a0,s2
    80002e92:	87cff0ef          	jal	80001f0e <bread>
  log.lh.n = lh->n;
    80002e96:	4d30                	lw	a2,88(a0)
    80002e98:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002e9a:	00c05f63          	blez	a2,80002eb8 <initlog+0x60>
    80002e9e:	87aa                	mv	a5,a0
    80002ea0:	00025717          	auipc	a4,0x25
    80002ea4:	5e070713          	addi	a4,a4,1504 # 80028480 <log+0x30>
    80002ea8:	060a                	slli	a2,a2,0x2
    80002eaa:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002eac:	4ff4                	lw	a3,92(a5)
    80002eae:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002eb0:	0791                	addi	a5,a5,4
    80002eb2:	0711                	addi	a4,a4,4
    80002eb4:	fec79ce3          	bne	a5,a2,80002eac <initlog+0x54>
  brelse(buf);
    80002eb8:	95eff0ef          	jal	80002016 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002ebc:	4505                	li	a0,1
    80002ebe:	ef3ff0ef          	jal	80002db0 <install_trans>
  log.lh.n = 0;
    80002ec2:	00025797          	auipc	a5,0x25
    80002ec6:	5a07ad23          	sw	zero,1466(a5) # 8002847c <log+0x2c>
  write_head(); // clear the log
    80002eca:	e89ff0ef          	jal	80002d52 <write_head>
}
    80002ece:	70a2                	ld	ra,40(sp)
    80002ed0:	7402                	ld	s0,32(sp)
    80002ed2:	64e2                	ld	s1,24(sp)
    80002ed4:	6942                	ld	s2,16(sp)
    80002ed6:	69a2                	ld	s3,8(sp)
    80002ed8:	6145                	addi	sp,sp,48
    80002eda:	8082                	ret

0000000080002edc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002edc:	1101                	addi	sp,sp,-32
    80002ede:	ec06                	sd	ra,24(sp)
    80002ee0:	e822                	sd	s0,16(sp)
    80002ee2:	e426                	sd	s1,8(sp)
    80002ee4:	e04a                	sd	s2,0(sp)
    80002ee6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002ee8:	00025517          	auipc	a0,0x25
    80002eec:	56850513          	addi	a0,a0,1384 # 80028450 <log>
    80002ef0:	041020ef          	jal	80005730 <acquire>
  while(1){
    if(log.committing){
    80002ef4:	00025497          	auipc	s1,0x25
    80002ef8:	55c48493          	addi	s1,s1,1372 # 80028450 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002efc:	03c00913          	li	s2,60
    80002f00:	a029                	j	80002f0a <begin_op+0x2e>
      sleep(&log, &log.lock);
    80002f02:	85a6                	mv	a1,s1
    80002f04:	8526                	mv	a0,s1
    80002f06:	c2efe0ef          	jal	80001334 <sleep>
    if(log.committing){
    80002f0a:	50dc                	lw	a5,36(s1)
    80002f0c:	fbfd                	bnez	a5,80002f02 <begin_op+0x26>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002f0e:	5098                	lw	a4,32(s1)
    80002f10:	2705                	addiw	a4,a4,1
    80002f12:	0027179b          	slliw	a5,a4,0x2
    80002f16:	9fb9                	addw	a5,a5,a4
    80002f18:	0017979b          	slliw	a5,a5,0x1
    80002f1c:	54d4                	lw	a3,44(s1)
    80002f1e:	9fb5                	addw	a5,a5,a3
    80002f20:	00f95763          	bge	s2,a5,80002f2e <begin_op+0x52>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002f24:	85a6                	mv	a1,s1
    80002f26:	8526                	mv	a0,s1
    80002f28:	c0cfe0ef          	jal	80001334 <sleep>
    80002f2c:	bff9                	j	80002f0a <begin_op+0x2e>
    } else {
      log.outstanding += 1;
    80002f2e:	00025517          	auipc	a0,0x25
    80002f32:	52250513          	addi	a0,a0,1314 # 80028450 <log>
    80002f36:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80002f38:	091020ef          	jal	800057c8 <release>
      break;
    }
  }
}
    80002f3c:	60e2                	ld	ra,24(sp)
    80002f3e:	6442                	ld	s0,16(sp)
    80002f40:	64a2                	ld	s1,8(sp)
    80002f42:	6902                	ld	s2,0(sp)
    80002f44:	6105                	addi	sp,sp,32
    80002f46:	8082                	ret

0000000080002f48 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80002f48:	7139                	addi	sp,sp,-64
    80002f4a:	fc06                	sd	ra,56(sp)
    80002f4c:	f822                	sd	s0,48(sp)
    80002f4e:	f426                	sd	s1,40(sp)
    80002f50:	f04a                	sd	s2,32(sp)
    80002f52:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80002f54:	00025497          	auipc	s1,0x25
    80002f58:	4fc48493          	addi	s1,s1,1276 # 80028450 <log>
    80002f5c:	8526                	mv	a0,s1
    80002f5e:	7d2020ef          	jal	80005730 <acquire>
  log.outstanding -= 1;
    80002f62:	509c                	lw	a5,32(s1)
    80002f64:	37fd                	addiw	a5,a5,-1
    80002f66:	0007891b          	sext.w	s2,a5
    80002f6a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80002f6c:	50dc                	lw	a5,36(s1)
    80002f6e:	ef9d                	bnez	a5,80002fac <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80002f70:	04091763          	bnez	s2,80002fbe <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80002f74:	00025497          	auipc	s1,0x25
    80002f78:	4dc48493          	addi	s1,s1,1244 # 80028450 <log>
    80002f7c:	4785                	li	a5,1
    80002f7e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80002f80:	8526                	mv	a0,s1
    80002f82:	047020ef          	jal	800057c8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80002f86:	54dc                	lw	a5,44(s1)
    80002f88:	04f04b63          	bgtz	a5,80002fde <end_op+0x96>
    acquire(&log.lock);
    80002f8c:	00025497          	auipc	s1,0x25
    80002f90:	4c448493          	addi	s1,s1,1220 # 80028450 <log>
    80002f94:	8526                	mv	a0,s1
    80002f96:	79a020ef          	jal	80005730 <acquire>
    log.committing = 0;
    80002f9a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80002f9e:	8526                	mv	a0,s1
    80002fa0:	be0fe0ef          	jal	80001380 <wakeup>
    release(&log.lock);
    80002fa4:	8526                	mv	a0,s1
    80002fa6:	023020ef          	jal	800057c8 <release>
}
    80002faa:	a025                	j	80002fd2 <end_op+0x8a>
    80002fac:	ec4e                	sd	s3,24(sp)
    80002fae:	e852                	sd	s4,16(sp)
    80002fb0:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80002fb2:	00004517          	auipc	a0,0x4
    80002fb6:	54e50513          	addi	a0,a0,1358 # 80007500 <etext+0x500>
    80002fba:	448020ef          	jal	80005402 <panic>
    wakeup(&log);
    80002fbe:	00025497          	auipc	s1,0x25
    80002fc2:	49248493          	addi	s1,s1,1170 # 80028450 <log>
    80002fc6:	8526                	mv	a0,s1
    80002fc8:	bb8fe0ef          	jal	80001380 <wakeup>
  release(&log.lock);
    80002fcc:	8526                	mv	a0,s1
    80002fce:	7fa020ef          	jal	800057c8 <release>
}
    80002fd2:	70e2                	ld	ra,56(sp)
    80002fd4:	7442                	ld	s0,48(sp)
    80002fd6:	74a2                	ld	s1,40(sp)
    80002fd8:	7902                	ld	s2,32(sp)
    80002fda:	6121                	addi	sp,sp,64
    80002fdc:	8082                	ret
    80002fde:	ec4e                	sd	s3,24(sp)
    80002fe0:	e852                	sd	s4,16(sp)
    80002fe2:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fe4:	00025a97          	auipc	s5,0x25
    80002fe8:	49ca8a93          	addi	s5,s5,1180 # 80028480 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80002fec:	00025a17          	auipc	s4,0x25
    80002ff0:	464a0a13          	addi	s4,s4,1124 # 80028450 <log>
    80002ff4:	018a2583          	lw	a1,24(s4)
    80002ff8:	012585bb          	addw	a1,a1,s2
    80002ffc:	2585                	addiw	a1,a1,1
    80002ffe:	028a2503          	lw	a0,40(s4)
    80003002:	f0dfe0ef          	jal	80001f0e <bread>
    80003006:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003008:	000aa583          	lw	a1,0(s5)
    8000300c:	028a2503          	lw	a0,40(s4)
    80003010:	efffe0ef          	jal	80001f0e <bread>
    80003014:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003016:	40000613          	li	a2,1024
    8000301a:	05850593          	addi	a1,a0,88
    8000301e:	05848513          	addi	a0,s1,88
    80003022:	988fd0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    80003026:	8526                	mv	a0,s1
    80003028:	fbdfe0ef          	jal	80001fe4 <bwrite>
    brelse(from);
    8000302c:	854e                	mv	a0,s3
    8000302e:	fe9fe0ef          	jal	80002016 <brelse>
    brelse(to);
    80003032:	8526                	mv	a0,s1
    80003034:	fe3fe0ef          	jal	80002016 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003038:	2905                	addiw	s2,s2,1
    8000303a:	0a91                	addi	s5,s5,4
    8000303c:	02ca2783          	lw	a5,44(s4)
    80003040:	faf94ae3          	blt	s2,a5,80002ff4 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003044:	d0fff0ef          	jal	80002d52 <write_head>
    install_trans(0); // Now install writes to home locations
    80003048:	4501                	li	a0,0
    8000304a:	d67ff0ef          	jal	80002db0 <install_trans>
    log.lh.n = 0;
    8000304e:	00025797          	auipc	a5,0x25
    80003052:	4207a723          	sw	zero,1070(a5) # 8002847c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003056:	cfdff0ef          	jal	80002d52 <write_head>
    8000305a:	69e2                	ld	s3,24(sp)
    8000305c:	6a42                	ld	s4,16(sp)
    8000305e:	6aa2                	ld	s5,8(sp)
    80003060:	b735                	j	80002f8c <end_op+0x44>

0000000080003062 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003062:	1101                	addi	sp,sp,-32
    80003064:	ec06                	sd	ra,24(sp)
    80003066:	e822                	sd	s0,16(sp)
    80003068:	e426                	sd	s1,8(sp)
    8000306a:	e04a                	sd	s2,0(sp)
    8000306c:	1000                	addi	s0,sp,32
    8000306e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003070:	00025917          	auipc	s2,0x25
    80003074:	3e090913          	addi	s2,s2,992 # 80028450 <log>
    80003078:	854a                	mv	a0,s2
    8000307a:	6b6020ef          	jal	80005730 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000307e:	02c92603          	lw	a2,44(s2)
    80003082:	03b00793          	li	a5,59
    80003086:	06c7c363          	blt	a5,a2,800030ec <log_write+0x8a>
    8000308a:	00025797          	auipc	a5,0x25
    8000308e:	3e27a783          	lw	a5,994(a5) # 8002846c <log+0x1c>
    80003092:	37fd                	addiw	a5,a5,-1
    80003094:	04f65c63          	bge	a2,a5,800030ec <log_write+0x8a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003098:	00025797          	auipc	a5,0x25
    8000309c:	3d87a783          	lw	a5,984(a5) # 80028470 <log+0x20>
    800030a0:	04f05c63          	blez	a5,800030f8 <log_write+0x96>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800030a4:	4781                	li	a5,0
    800030a6:	04c05f63          	blez	a2,80003104 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800030aa:	44cc                	lw	a1,12(s1)
    800030ac:	00025717          	auipc	a4,0x25
    800030b0:	3d470713          	addi	a4,a4,980 # 80028480 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800030b4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800030b6:	4314                	lw	a3,0(a4)
    800030b8:	04b68663          	beq	a3,a1,80003104 <log_write+0xa2>
  for (i = 0; i < log.lh.n; i++) {
    800030bc:	2785                	addiw	a5,a5,1
    800030be:	0711                	addi	a4,a4,4
    800030c0:	fef61be3          	bne	a2,a5,800030b6 <log_write+0x54>
      break;
  }
  log.lh.block[i] = b->blockno;
    800030c4:	0621                	addi	a2,a2,8
    800030c6:	060a                	slli	a2,a2,0x2
    800030c8:	00025797          	auipc	a5,0x25
    800030cc:	38878793          	addi	a5,a5,904 # 80028450 <log>
    800030d0:	97b2                	add	a5,a5,a2
    800030d2:	44d8                	lw	a4,12(s1)
    800030d4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800030d6:	8526                	mv	a0,s1
    800030d8:	fc7fe0ef          	jal	8000209e <bpin>
    log.lh.n++;
    800030dc:	00025717          	auipc	a4,0x25
    800030e0:	37470713          	addi	a4,a4,884 # 80028450 <log>
    800030e4:	575c                	lw	a5,44(a4)
    800030e6:	2785                	addiw	a5,a5,1
    800030e8:	d75c                	sw	a5,44(a4)
    800030ea:	a80d                	j	8000311c <log_write+0xba>
    panic("too big a transaction");
    800030ec:	00004517          	auipc	a0,0x4
    800030f0:	42450513          	addi	a0,a0,1060 # 80007510 <etext+0x510>
    800030f4:	30e020ef          	jal	80005402 <panic>
    panic("log_write outside of trans");
    800030f8:	00004517          	auipc	a0,0x4
    800030fc:	43050513          	addi	a0,a0,1072 # 80007528 <etext+0x528>
    80003100:	302020ef          	jal	80005402 <panic>
  log.lh.block[i] = b->blockno;
    80003104:	00878693          	addi	a3,a5,8
    80003108:	068a                	slli	a3,a3,0x2
    8000310a:	00025717          	auipc	a4,0x25
    8000310e:	34670713          	addi	a4,a4,838 # 80028450 <log>
    80003112:	9736                	add	a4,a4,a3
    80003114:	44d4                	lw	a3,12(s1)
    80003116:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003118:	faf60fe3          	beq	a2,a5,800030d6 <log_write+0x74>
  }
  release(&log.lock);
    8000311c:	00025517          	auipc	a0,0x25
    80003120:	33450513          	addi	a0,a0,820 # 80028450 <log>
    80003124:	6a4020ef          	jal	800057c8 <release>
}
    80003128:	60e2                	ld	ra,24(sp)
    8000312a:	6442                	ld	s0,16(sp)
    8000312c:	64a2                	ld	s1,8(sp)
    8000312e:	6902                	ld	s2,0(sp)
    80003130:	6105                	addi	sp,sp,32
    80003132:	8082                	ret

0000000080003134 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003134:	1101                	addi	sp,sp,-32
    80003136:	ec06                	sd	ra,24(sp)
    80003138:	e822                	sd	s0,16(sp)
    8000313a:	e426                	sd	s1,8(sp)
    8000313c:	e04a                	sd	s2,0(sp)
    8000313e:	1000                	addi	s0,sp,32
    80003140:	84aa                	mv	s1,a0
    80003142:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003144:	00004597          	auipc	a1,0x4
    80003148:	40458593          	addi	a1,a1,1028 # 80007548 <etext+0x548>
    8000314c:	0521                	addi	a0,a0,8
    8000314e:	562020ef          	jal	800056b0 <initlock>
  lk->name = name;
    80003152:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003156:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000315a:	0204a423          	sw	zero,40(s1)
}
    8000315e:	60e2                	ld	ra,24(sp)
    80003160:	6442                	ld	s0,16(sp)
    80003162:	64a2                	ld	s1,8(sp)
    80003164:	6902                	ld	s2,0(sp)
    80003166:	6105                	addi	sp,sp,32
    80003168:	8082                	ret

000000008000316a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000316a:	1101                	addi	sp,sp,-32
    8000316c:	ec06                	sd	ra,24(sp)
    8000316e:	e822                	sd	s0,16(sp)
    80003170:	e426                	sd	s1,8(sp)
    80003172:	e04a                	sd	s2,0(sp)
    80003174:	1000                	addi	s0,sp,32
    80003176:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003178:	00850913          	addi	s2,a0,8
    8000317c:	854a                	mv	a0,s2
    8000317e:	5b2020ef          	jal	80005730 <acquire>
  while (lk->locked) {
    80003182:	409c                	lw	a5,0(s1)
    80003184:	c799                	beqz	a5,80003192 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003186:	85ca                	mv	a1,s2
    80003188:	8526                	mv	a0,s1
    8000318a:	9aafe0ef          	jal	80001334 <sleep>
  while (lk->locked) {
    8000318e:	409c                	lw	a5,0(s1)
    80003190:	fbfd                	bnez	a5,80003186 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003192:	4785                	li	a5,1
    80003194:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003196:	bd1fd0ef          	jal	80000d66 <myproc>
    8000319a:	591c                	lw	a5,48(a0)
    8000319c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000319e:	854a                	mv	a0,s2
    800031a0:	628020ef          	jal	800057c8 <release>
}
    800031a4:	60e2                	ld	ra,24(sp)
    800031a6:	6442                	ld	s0,16(sp)
    800031a8:	64a2                	ld	s1,8(sp)
    800031aa:	6902                	ld	s2,0(sp)
    800031ac:	6105                	addi	sp,sp,32
    800031ae:	8082                	ret

00000000800031b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800031b0:	1101                	addi	sp,sp,-32
    800031b2:	ec06                	sd	ra,24(sp)
    800031b4:	e822                	sd	s0,16(sp)
    800031b6:	e426                	sd	s1,8(sp)
    800031b8:	e04a                	sd	s2,0(sp)
    800031ba:	1000                	addi	s0,sp,32
    800031bc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800031be:	00850913          	addi	s2,a0,8
    800031c2:	854a                	mv	a0,s2
    800031c4:	56c020ef          	jal	80005730 <acquire>
  lk->locked = 0;
    800031c8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800031cc:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800031d0:	8526                	mv	a0,s1
    800031d2:	9aefe0ef          	jal	80001380 <wakeup>
  release(&lk->lk);
    800031d6:	854a                	mv	a0,s2
    800031d8:	5f0020ef          	jal	800057c8 <release>
}
    800031dc:	60e2                	ld	ra,24(sp)
    800031de:	6442                	ld	s0,16(sp)
    800031e0:	64a2                	ld	s1,8(sp)
    800031e2:	6902                	ld	s2,0(sp)
    800031e4:	6105                	addi	sp,sp,32
    800031e6:	8082                	ret

00000000800031e8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800031e8:	7179                	addi	sp,sp,-48
    800031ea:	f406                	sd	ra,40(sp)
    800031ec:	f022                	sd	s0,32(sp)
    800031ee:	ec26                	sd	s1,24(sp)
    800031f0:	e84a                	sd	s2,16(sp)
    800031f2:	1800                	addi	s0,sp,48
    800031f4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800031f6:	00850913          	addi	s2,a0,8
    800031fa:	854a                	mv	a0,s2
    800031fc:	534020ef          	jal	80005730 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003200:	409c                	lw	a5,0(s1)
    80003202:	ef81                	bnez	a5,8000321a <holdingsleep+0x32>
    80003204:	4481                	li	s1,0
  release(&lk->lk);
    80003206:	854a                	mv	a0,s2
    80003208:	5c0020ef          	jal	800057c8 <release>
  return r;
}
    8000320c:	8526                	mv	a0,s1
    8000320e:	70a2                	ld	ra,40(sp)
    80003210:	7402                	ld	s0,32(sp)
    80003212:	64e2                	ld	s1,24(sp)
    80003214:	6942                	ld	s2,16(sp)
    80003216:	6145                	addi	sp,sp,48
    80003218:	8082                	ret
    8000321a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000321c:	0284a983          	lw	s3,40(s1)
    80003220:	b47fd0ef          	jal	80000d66 <myproc>
    80003224:	5904                	lw	s1,48(a0)
    80003226:	413484b3          	sub	s1,s1,s3
    8000322a:	0014b493          	seqz	s1,s1
    8000322e:	69a2                	ld	s3,8(sp)
    80003230:	bfd9                	j	80003206 <holdingsleep+0x1e>

0000000080003232 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003232:	1141                	addi	sp,sp,-16
    80003234:	e406                	sd	ra,8(sp)
    80003236:	e022                	sd	s0,0(sp)
    80003238:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000323a:	00004597          	auipc	a1,0x4
    8000323e:	31e58593          	addi	a1,a1,798 # 80007558 <etext+0x558>
    80003242:	00025517          	auipc	a0,0x25
    80003246:	3ce50513          	addi	a0,a0,974 # 80028610 <ftable>
    8000324a:	466020ef          	jal	800056b0 <initlock>
}
    8000324e:	60a2                	ld	ra,8(sp)
    80003250:	6402                	ld	s0,0(sp)
    80003252:	0141                	addi	sp,sp,16
    80003254:	8082                	ret

0000000080003256 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003256:	1101                	addi	sp,sp,-32
    80003258:	ec06                	sd	ra,24(sp)
    8000325a:	e822                	sd	s0,16(sp)
    8000325c:	e426                	sd	s1,8(sp)
    8000325e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003260:	00025517          	auipc	a0,0x25
    80003264:	3b050513          	addi	a0,a0,944 # 80028610 <ftable>
    80003268:	4c8020ef          	jal	80005730 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000326c:	00025497          	auipc	s1,0x25
    80003270:	3bc48493          	addi	s1,s1,956 # 80028628 <ftable+0x18>
    80003274:	00026717          	auipc	a4,0x26
    80003278:	35470713          	addi	a4,a4,852 # 800295c8 <disk>
    if(f->ref == 0){
    8000327c:	40dc                	lw	a5,4(s1)
    8000327e:	cf89                	beqz	a5,80003298 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003280:	02848493          	addi	s1,s1,40
    80003284:	fee49ce3          	bne	s1,a4,8000327c <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003288:	00025517          	auipc	a0,0x25
    8000328c:	38850513          	addi	a0,a0,904 # 80028610 <ftable>
    80003290:	538020ef          	jal	800057c8 <release>
  return 0;
    80003294:	4481                	li	s1,0
    80003296:	a809                	j	800032a8 <filealloc+0x52>
      f->ref = 1;
    80003298:	4785                	li	a5,1
    8000329a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000329c:	00025517          	auipc	a0,0x25
    800032a0:	37450513          	addi	a0,a0,884 # 80028610 <ftable>
    800032a4:	524020ef          	jal	800057c8 <release>
}
    800032a8:	8526                	mv	a0,s1
    800032aa:	60e2                	ld	ra,24(sp)
    800032ac:	6442                	ld	s0,16(sp)
    800032ae:	64a2                	ld	s1,8(sp)
    800032b0:	6105                	addi	sp,sp,32
    800032b2:	8082                	ret

00000000800032b4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800032b4:	1101                	addi	sp,sp,-32
    800032b6:	ec06                	sd	ra,24(sp)
    800032b8:	e822                	sd	s0,16(sp)
    800032ba:	e426                	sd	s1,8(sp)
    800032bc:	1000                	addi	s0,sp,32
    800032be:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800032c0:	00025517          	auipc	a0,0x25
    800032c4:	35050513          	addi	a0,a0,848 # 80028610 <ftable>
    800032c8:	468020ef          	jal	80005730 <acquire>
  if(f->ref < 1)
    800032cc:	40dc                	lw	a5,4(s1)
    800032ce:	02f05063          	blez	a5,800032ee <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800032d2:	2785                	addiw	a5,a5,1
    800032d4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800032d6:	00025517          	auipc	a0,0x25
    800032da:	33a50513          	addi	a0,a0,826 # 80028610 <ftable>
    800032de:	4ea020ef          	jal	800057c8 <release>
  return f;
}
    800032e2:	8526                	mv	a0,s1
    800032e4:	60e2                	ld	ra,24(sp)
    800032e6:	6442                	ld	s0,16(sp)
    800032e8:	64a2                	ld	s1,8(sp)
    800032ea:	6105                	addi	sp,sp,32
    800032ec:	8082                	ret
    panic("filedup");
    800032ee:	00004517          	auipc	a0,0x4
    800032f2:	27250513          	addi	a0,a0,626 # 80007560 <etext+0x560>
    800032f6:	10c020ef          	jal	80005402 <panic>

00000000800032fa <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800032fa:	7139                	addi	sp,sp,-64
    800032fc:	fc06                	sd	ra,56(sp)
    800032fe:	f822                	sd	s0,48(sp)
    80003300:	f426                	sd	s1,40(sp)
    80003302:	0080                	addi	s0,sp,64
    80003304:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003306:	00025517          	auipc	a0,0x25
    8000330a:	30a50513          	addi	a0,a0,778 # 80028610 <ftable>
    8000330e:	422020ef          	jal	80005730 <acquire>
  if(f->ref < 1)
    80003312:	40dc                	lw	a5,4(s1)
    80003314:	04f05a63          	blez	a5,80003368 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003318:	37fd                	addiw	a5,a5,-1
    8000331a:	0007871b          	sext.w	a4,a5
    8000331e:	c0dc                	sw	a5,4(s1)
    80003320:	04e04e63          	bgtz	a4,8000337c <fileclose+0x82>
    80003324:	f04a                	sd	s2,32(sp)
    80003326:	ec4e                	sd	s3,24(sp)
    80003328:	e852                	sd	s4,16(sp)
    8000332a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000332c:	0004a903          	lw	s2,0(s1)
    80003330:	0094ca83          	lbu	s5,9(s1)
    80003334:	0104ba03          	ld	s4,16(s1)
    80003338:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000333c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003340:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003344:	00025517          	auipc	a0,0x25
    80003348:	2cc50513          	addi	a0,a0,716 # 80028610 <ftable>
    8000334c:	47c020ef          	jal	800057c8 <release>

  if(ff.type == FD_PIPE){
    80003350:	4785                	li	a5,1
    80003352:	04f90063          	beq	s2,a5,80003392 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003356:	3979                	addiw	s2,s2,-2
    80003358:	4785                	li	a5,1
    8000335a:	0527f563          	bgeu	a5,s2,800033a4 <fileclose+0xaa>
    8000335e:	7902                	ld	s2,32(sp)
    80003360:	69e2                	ld	s3,24(sp)
    80003362:	6a42                	ld	s4,16(sp)
    80003364:	6aa2                	ld	s5,8(sp)
    80003366:	a00d                	j	80003388 <fileclose+0x8e>
    80003368:	f04a                	sd	s2,32(sp)
    8000336a:	ec4e                	sd	s3,24(sp)
    8000336c:	e852                	sd	s4,16(sp)
    8000336e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003370:	00004517          	auipc	a0,0x4
    80003374:	1f850513          	addi	a0,a0,504 # 80007568 <etext+0x568>
    80003378:	08a020ef          	jal	80005402 <panic>
    release(&ftable.lock);
    8000337c:	00025517          	auipc	a0,0x25
    80003380:	29450513          	addi	a0,a0,660 # 80028610 <ftable>
    80003384:	444020ef          	jal	800057c8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003388:	70e2                	ld	ra,56(sp)
    8000338a:	7442                	ld	s0,48(sp)
    8000338c:	74a2                	ld	s1,40(sp)
    8000338e:	6121                	addi	sp,sp,64
    80003390:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003392:	85d6                	mv	a1,s5
    80003394:	8552                	mv	a0,s4
    80003396:	336000ef          	jal	800036cc <pipeclose>
    8000339a:	7902                	ld	s2,32(sp)
    8000339c:	69e2                	ld	s3,24(sp)
    8000339e:	6a42                	ld	s4,16(sp)
    800033a0:	6aa2                	ld	s5,8(sp)
    800033a2:	b7dd                	j	80003388 <fileclose+0x8e>
    begin_op();
    800033a4:	b39ff0ef          	jal	80002edc <begin_op>
    iput(ff.ip);
    800033a8:	854e                	mv	a0,s3
    800033aa:	c1eff0ef          	jal	800027c8 <iput>
    end_op();
    800033ae:	b9bff0ef          	jal	80002f48 <end_op>
    800033b2:	7902                	ld	s2,32(sp)
    800033b4:	69e2                	ld	s3,24(sp)
    800033b6:	6a42                	ld	s4,16(sp)
    800033b8:	6aa2                	ld	s5,8(sp)
    800033ba:	b7f9                	j	80003388 <fileclose+0x8e>

00000000800033bc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800033bc:	715d                	addi	sp,sp,-80
    800033be:	e486                	sd	ra,72(sp)
    800033c0:	e0a2                	sd	s0,64(sp)
    800033c2:	fc26                	sd	s1,56(sp)
    800033c4:	f44e                	sd	s3,40(sp)
    800033c6:	0880                	addi	s0,sp,80
    800033c8:	84aa                	mv	s1,a0
    800033ca:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800033cc:	99bfd0ef          	jal	80000d66 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800033d0:	409c                	lw	a5,0(s1)
    800033d2:	37f9                	addiw	a5,a5,-2
    800033d4:	4705                	li	a4,1
    800033d6:	04f76063          	bltu	a4,a5,80003416 <filestat+0x5a>
    800033da:	f84a                	sd	s2,48(sp)
    800033dc:	892a                	mv	s2,a0
    ilock(f->ip);
    800033de:	6c88                	ld	a0,24(s1)
    800033e0:	a66ff0ef          	jal	80002646 <ilock>
    stati(f->ip, &st);
    800033e4:	fb840593          	addi	a1,s0,-72
    800033e8:	6c88                	ld	a0,24(s1)
    800033ea:	c86ff0ef          	jal	80002870 <stati>
    iunlock(f->ip);
    800033ee:	6c88                	ld	a0,24(s1)
    800033f0:	b04ff0ef          	jal	800026f4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800033f4:	46e1                	li	a3,24
    800033f6:	fb840613          	addi	a2,s0,-72
    800033fa:	85ce                	mv	a1,s3
    800033fc:	05093503          	ld	a0,80(s2)
    80003400:	dd8fd0ef          	jal	800009d8 <copyout>
    80003404:	41f5551b          	sraiw	a0,a0,0x1f
    80003408:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000340a:	60a6                	ld	ra,72(sp)
    8000340c:	6406                	ld	s0,64(sp)
    8000340e:	74e2                	ld	s1,56(sp)
    80003410:	79a2                	ld	s3,40(sp)
    80003412:	6161                	addi	sp,sp,80
    80003414:	8082                	ret
  return -1;
    80003416:	557d                	li	a0,-1
    80003418:	bfcd                	j	8000340a <filestat+0x4e>

000000008000341a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000341a:	7179                	addi	sp,sp,-48
    8000341c:	f406                	sd	ra,40(sp)
    8000341e:	f022                	sd	s0,32(sp)
    80003420:	e84a                	sd	s2,16(sp)
    80003422:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003424:	00854783          	lbu	a5,8(a0)
    80003428:	cfd1                	beqz	a5,800034c4 <fileread+0xaa>
    8000342a:	ec26                	sd	s1,24(sp)
    8000342c:	e44e                	sd	s3,8(sp)
    8000342e:	84aa                	mv	s1,a0
    80003430:	89ae                	mv	s3,a1
    80003432:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003434:	411c                	lw	a5,0(a0)
    80003436:	4705                	li	a4,1
    80003438:	04e78363          	beq	a5,a4,8000347e <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000343c:	470d                	li	a4,3
    8000343e:	04e78763          	beq	a5,a4,8000348c <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003442:	4709                	li	a4,2
    80003444:	06e79a63          	bne	a5,a4,800034b8 <fileread+0x9e>
    ilock(f->ip);
    80003448:	6d08                	ld	a0,24(a0)
    8000344a:	9fcff0ef          	jal	80002646 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000344e:	874a                	mv	a4,s2
    80003450:	5094                	lw	a3,32(s1)
    80003452:	864e                	mv	a2,s3
    80003454:	4585                	li	a1,1
    80003456:	6c88                	ld	a0,24(s1)
    80003458:	c42ff0ef          	jal	8000289a <readi>
    8000345c:	892a                	mv	s2,a0
    8000345e:	00a05563          	blez	a0,80003468 <fileread+0x4e>
      f->off += r;
    80003462:	509c                	lw	a5,32(s1)
    80003464:	9fa9                	addw	a5,a5,a0
    80003466:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003468:	6c88                	ld	a0,24(s1)
    8000346a:	a8aff0ef          	jal	800026f4 <iunlock>
    8000346e:	64e2                	ld	s1,24(sp)
    80003470:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003472:	854a                	mv	a0,s2
    80003474:	70a2                	ld	ra,40(sp)
    80003476:	7402                	ld	s0,32(sp)
    80003478:	6942                	ld	s2,16(sp)
    8000347a:	6145                	addi	sp,sp,48
    8000347c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000347e:	6908                	ld	a0,16(a0)
    80003480:	388000ef          	jal	80003808 <piperead>
    80003484:	892a                	mv	s2,a0
    80003486:	64e2                	ld	s1,24(sp)
    80003488:	69a2                	ld	s3,8(sp)
    8000348a:	b7e5                	j	80003472 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000348c:	02451783          	lh	a5,36(a0)
    80003490:	03079693          	slli	a3,a5,0x30
    80003494:	92c1                	srli	a3,a3,0x30
    80003496:	4725                	li	a4,9
    80003498:	02d76863          	bltu	a4,a3,800034c8 <fileread+0xae>
    8000349c:	0792                	slli	a5,a5,0x4
    8000349e:	00025717          	auipc	a4,0x25
    800034a2:	0d270713          	addi	a4,a4,210 # 80028570 <devsw>
    800034a6:	97ba                	add	a5,a5,a4
    800034a8:	639c                	ld	a5,0(a5)
    800034aa:	c39d                	beqz	a5,800034d0 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800034ac:	4505                	li	a0,1
    800034ae:	9782                	jalr	a5
    800034b0:	892a                	mv	s2,a0
    800034b2:	64e2                	ld	s1,24(sp)
    800034b4:	69a2                	ld	s3,8(sp)
    800034b6:	bf75                	j	80003472 <fileread+0x58>
    panic("fileread");
    800034b8:	00004517          	auipc	a0,0x4
    800034bc:	0c050513          	addi	a0,a0,192 # 80007578 <etext+0x578>
    800034c0:	743010ef          	jal	80005402 <panic>
    return -1;
    800034c4:	597d                	li	s2,-1
    800034c6:	b775                	j	80003472 <fileread+0x58>
      return -1;
    800034c8:	597d                	li	s2,-1
    800034ca:	64e2                	ld	s1,24(sp)
    800034cc:	69a2                	ld	s3,8(sp)
    800034ce:	b755                	j	80003472 <fileread+0x58>
    800034d0:	597d                	li	s2,-1
    800034d2:	64e2                	ld	s1,24(sp)
    800034d4:	69a2                	ld	s3,8(sp)
    800034d6:	bf71                	j	80003472 <fileread+0x58>

00000000800034d8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800034d8:	00954783          	lbu	a5,9(a0)
    800034dc:	10078b63          	beqz	a5,800035f2 <filewrite+0x11a>
{
    800034e0:	715d                	addi	sp,sp,-80
    800034e2:	e486                	sd	ra,72(sp)
    800034e4:	e0a2                	sd	s0,64(sp)
    800034e6:	f84a                	sd	s2,48(sp)
    800034e8:	f052                	sd	s4,32(sp)
    800034ea:	e85a                	sd	s6,16(sp)
    800034ec:	0880                	addi	s0,sp,80
    800034ee:	892a                	mv	s2,a0
    800034f0:	8b2e                	mv	s6,a1
    800034f2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800034f4:	411c                	lw	a5,0(a0)
    800034f6:	4705                	li	a4,1
    800034f8:	02e78763          	beq	a5,a4,80003526 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800034fc:	470d                	li	a4,3
    800034fe:	02e78863          	beq	a5,a4,8000352e <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003502:	4709                	li	a4,2
    80003504:	0ce79c63          	bne	a5,a4,800035dc <filewrite+0x104>
    80003508:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000350a:	0ac05863          	blez	a2,800035ba <filewrite+0xe2>
    8000350e:	fc26                	sd	s1,56(sp)
    80003510:	ec56                	sd	s5,24(sp)
    80003512:	e45e                	sd	s7,8(sp)
    80003514:	e062                	sd	s8,0(sp)
    int i = 0;
    80003516:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003518:	6b85                	lui	s7,0x1
    8000351a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000351e:	6c05                	lui	s8,0x1
    80003520:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003524:	a8b5                	j	800035a0 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003526:	6908                	ld	a0,16(a0)
    80003528:	1fc000ef          	jal	80003724 <pipewrite>
    8000352c:	a04d                	j	800035ce <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000352e:	02451783          	lh	a5,36(a0)
    80003532:	03079693          	slli	a3,a5,0x30
    80003536:	92c1                	srli	a3,a3,0x30
    80003538:	4725                	li	a4,9
    8000353a:	0ad76e63          	bltu	a4,a3,800035f6 <filewrite+0x11e>
    8000353e:	0792                	slli	a5,a5,0x4
    80003540:	00025717          	auipc	a4,0x25
    80003544:	03070713          	addi	a4,a4,48 # 80028570 <devsw>
    80003548:	97ba                	add	a5,a5,a4
    8000354a:	679c                	ld	a5,8(a5)
    8000354c:	c7dd                	beqz	a5,800035fa <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000354e:	4505                	li	a0,1
    80003550:	9782                	jalr	a5
    80003552:	a8b5                	j	800035ce <filewrite+0xf6>
      if(n1 > max)
    80003554:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003558:	985ff0ef          	jal	80002edc <begin_op>
      ilock(f->ip);
    8000355c:	01893503          	ld	a0,24(s2)
    80003560:	8e6ff0ef          	jal	80002646 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003564:	8756                	mv	a4,s5
    80003566:	02092683          	lw	a3,32(s2)
    8000356a:	01698633          	add	a2,s3,s6
    8000356e:	4585                	li	a1,1
    80003570:	01893503          	ld	a0,24(s2)
    80003574:	c22ff0ef          	jal	80002996 <writei>
    80003578:	84aa                	mv	s1,a0
    8000357a:	00a05763          	blez	a0,80003588 <filewrite+0xb0>
        f->off += r;
    8000357e:	02092783          	lw	a5,32(s2)
    80003582:	9fa9                	addw	a5,a5,a0
    80003584:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003588:	01893503          	ld	a0,24(s2)
    8000358c:	968ff0ef          	jal	800026f4 <iunlock>
      end_op();
    80003590:	9b9ff0ef          	jal	80002f48 <end_op>

      if(r != n1){
    80003594:	029a9563          	bne	s5,s1,800035be <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003598:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000359c:	0149da63          	bge	s3,s4,800035b0 <filewrite+0xd8>
      int n1 = n - i;
    800035a0:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800035a4:	0004879b          	sext.w	a5,s1
    800035a8:	fafbd6e3          	bge	s7,a5,80003554 <filewrite+0x7c>
    800035ac:	84e2                	mv	s1,s8
    800035ae:	b75d                	j	80003554 <filewrite+0x7c>
    800035b0:	74e2                	ld	s1,56(sp)
    800035b2:	6ae2                	ld	s5,24(sp)
    800035b4:	6ba2                	ld	s7,8(sp)
    800035b6:	6c02                	ld	s8,0(sp)
    800035b8:	a039                	j	800035c6 <filewrite+0xee>
    int i = 0;
    800035ba:	4981                	li	s3,0
    800035bc:	a029                	j	800035c6 <filewrite+0xee>
    800035be:	74e2                	ld	s1,56(sp)
    800035c0:	6ae2                	ld	s5,24(sp)
    800035c2:	6ba2                	ld	s7,8(sp)
    800035c4:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800035c6:	033a1c63          	bne	s4,s3,800035fe <filewrite+0x126>
    800035ca:	8552                	mv	a0,s4
    800035cc:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800035ce:	60a6                	ld	ra,72(sp)
    800035d0:	6406                	ld	s0,64(sp)
    800035d2:	7942                	ld	s2,48(sp)
    800035d4:	7a02                	ld	s4,32(sp)
    800035d6:	6b42                	ld	s6,16(sp)
    800035d8:	6161                	addi	sp,sp,80
    800035da:	8082                	ret
    800035dc:	fc26                	sd	s1,56(sp)
    800035de:	f44e                	sd	s3,40(sp)
    800035e0:	ec56                	sd	s5,24(sp)
    800035e2:	e45e                	sd	s7,8(sp)
    800035e4:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800035e6:	00004517          	auipc	a0,0x4
    800035ea:	fa250513          	addi	a0,a0,-94 # 80007588 <etext+0x588>
    800035ee:	615010ef          	jal	80005402 <panic>
    return -1;
    800035f2:	557d                	li	a0,-1
}
    800035f4:	8082                	ret
      return -1;
    800035f6:	557d                	li	a0,-1
    800035f8:	bfd9                	j	800035ce <filewrite+0xf6>
    800035fa:	557d                	li	a0,-1
    800035fc:	bfc9                	j	800035ce <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800035fe:	557d                	li	a0,-1
    80003600:	79a2                	ld	s3,40(sp)
    80003602:	b7f1                	j	800035ce <filewrite+0xf6>

0000000080003604 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003604:	7179                	addi	sp,sp,-48
    80003606:	f406                	sd	ra,40(sp)
    80003608:	f022                	sd	s0,32(sp)
    8000360a:	ec26                	sd	s1,24(sp)
    8000360c:	e052                	sd	s4,0(sp)
    8000360e:	1800                	addi	s0,sp,48
    80003610:	84aa                	mv	s1,a0
    80003612:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003614:	0005b023          	sd	zero,0(a1)
    80003618:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000361c:	c3bff0ef          	jal	80003256 <filealloc>
    80003620:	e088                	sd	a0,0(s1)
    80003622:	c549                	beqz	a0,800036ac <pipealloc+0xa8>
    80003624:	c33ff0ef          	jal	80003256 <filealloc>
    80003628:	00aa3023          	sd	a0,0(s4)
    8000362c:	cd25                	beqz	a0,800036a4 <pipealloc+0xa0>
    8000362e:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003630:	acffc0ef          	jal	800000fe <kalloc>
    80003634:	892a                	mv	s2,a0
    80003636:	c12d                	beqz	a0,80003698 <pipealloc+0x94>
    80003638:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000363a:	4985                	li	s3,1
    8000363c:	43352023          	sw	s3,1056(a0)
  pi->writeopen = 1;
    80003640:	43352223          	sw	s3,1060(a0)
  pi->nwrite = 0;
    80003644:	40052e23          	sw	zero,1052(a0)
  pi->nread = 0;
    80003648:	40052c23          	sw	zero,1048(a0)
  initlock(&pi->lock, "pipe");
    8000364c:	00004597          	auipc	a1,0x4
    80003650:	f4c58593          	addi	a1,a1,-180 # 80007598 <etext+0x598>
    80003654:	05c020ef          	jal	800056b0 <initlock>
  (*f0)->type = FD_PIPE;
    80003658:	609c                	ld	a5,0(s1)
    8000365a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000365e:	609c                	ld	a5,0(s1)
    80003660:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003664:	609c                	ld	a5,0(s1)
    80003666:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000366a:	609c                	ld	a5,0(s1)
    8000366c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003670:	000a3783          	ld	a5,0(s4)
    80003674:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003678:	000a3783          	ld	a5,0(s4)
    8000367c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003680:	000a3783          	ld	a5,0(s4)
    80003684:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003688:	000a3783          	ld	a5,0(s4)
    8000368c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003690:	4501                	li	a0,0
    80003692:	6942                	ld	s2,16(sp)
    80003694:	69a2                	ld	s3,8(sp)
    80003696:	a01d                	j	800036bc <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003698:	6088                	ld	a0,0(s1)
    8000369a:	c119                	beqz	a0,800036a0 <pipealloc+0x9c>
    8000369c:	6942                	ld	s2,16(sp)
    8000369e:	a029                	j	800036a8 <pipealloc+0xa4>
    800036a0:	6942                	ld	s2,16(sp)
    800036a2:	a029                	j	800036ac <pipealloc+0xa8>
    800036a4:	6088                	ld	a0,0(s1)
    800036a6:	c10d                	beqz	a0,800036c8 <pipealloc+0xc4>
    fileclose(*f0);
    800036a8:	c53ff0ef          	jal	800032fa <fileclose>
  if(*f1)
    800036ac:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800036b0:	557d                	li	a0,-1
  if(*f1)
    800036b2:	c789                	beqz	a5,800036bc <pipealloc+0xb8>
    fileclose(*f1);
    800036b4:	853e                	mv	a0,a5
    800036b6:	c45ff0ef          	jal	800032fa <fileclose>
  return -1;
    800036ba:	557d                	li	a0,-1
}
    800036bc:	70a2                	ld	ra,40(sp)
    800036be:	7402                	ld	s0,32(sp)
    800036c0:	64e2                	ld	s1,24(sp)
    800036c2:	6a02                	ld	s4,0(sp)
    800036c4:	6145                	addi	sp,sp,48
    800036c6:	8082                	ret
  return -1;
    800036c8:	557d                	li	a0,-1
    800036ca:	bfcd                	j	800036bc <pipealloc+0xb8>

00000000800036cc <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800036cc:	1101                	addi	sp,sp,-32
    800036ce:	ec06                	sd	ra,24(sp)
    800036d0:	e822                	sd	s0,16(sp)
    800036d2:	e426                	sd	s1,8(sp)
    800036d4:	e04a                	sd	s2,0(sp)
    800036d6:	1000                	addi	s0,sp,32
    800036d8:	84aa                	mv	s1,a0
    800036da:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800036dc:	054020ef          	jal	80005730 <acquire>
  if(writable){
    800036e0:	02090763          	beqz	s2,8000370e <pipeclose+0x42>
    pi->writeopen = 0;
    800036e4:	4204a223          	sw	zero,1060(s1)
    wakeup(&pi->nread);
    800036e8:	41848513          	addi	a0,s1,1048
    800036ec:	c95fd0ef          	jal	80001380 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800036f0:	4204b783          	ld	a5,1056(s1)
    800036f4:	e785                	bnez	a5,8000371c <pipeclose+0x50>
    release(&pi->lock);
    800036f6:	8526                	mv	a0,s1
    800036f8:	0d0020ef          	jal	800057c8 <release>
    kfree((char*)pi);
    800036fc:	8526                	mv	a0,s1
    800036fe:	91ffc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003702:	60e2                	ld	ra,24(sp)
    80003704:	6442                	ld	s0,16(sp)
    80003706:	64a2                	ld	s1,8(sp)
    80003708:	6902                	ld	s2,0(sp)
    8000370a:	6105                	addi	sp,sp,32
    8000370c:	8082                	ret
    pi->readopen = 0;
    8000370e:	4204a023          	sw	zero,1056(s1)
    wakeup(&pi->nwrite);
    80003712:	41c48513          	addi	a0,s1,1052
    80003716:	c6bfd0ef          	jal	80001380 <wakeup>
    8000371a:	bfd9                	j	800036f0 <pipeclose+0x24>
    release(&pi->lock);
    8000371c:	8526                	mv	a0,s1
    8000371e:	0aa020ef          	jal	800057c8 <release>
}
    80003722:	b7c5                	j	80003702 <pipeclose+0x36>

0000000080003724 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003724:	711d                	addi	sp,sp,-96
    80003726:	ec86                	sd	ra,88(sp)
    80003728:	e8a2                	sd	s0,80(sp)
    8000372a:	e4a6                	sd	s1,72(sp)
    8000372c:	e0ca                	sd	s2,64(sp)
    8000372e:	fc4e                	sd	s3,56(sp)
    80003730:	f852                	sd	s4,48(sp)
    80003732:	f456                	sd	s5,40(sp)
    80003734:	1080                	addi	s0,sp,96
    80003736:	84aa                	mv	s1,a0
    80003738:	8aae                	mv	s5,a1
    8000373a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000373c:	e2afd0ef          	jal	80000d66 <myproc>
    80003740:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003742:	8526                	mv	a0,s1
    80003744:	7ed010ef          	jal	80005730 <acquire>
  while(i < n){
    80003748:	0b405a63          	blez	s4,800037fc <pipewrite+0xd8>
    8000374c:	f05a                	sd	s6,32(sp)
    8000374e:	ec5e                	sd	s7,24(sp)
    80003750:	e862                	sd	s8,16(sp)
  int i = 0;
    80003752:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003754:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003756:	41848c13          	addi	s8,s1,1048
      sleep(&pi->nwrite, &pi->lock);
    8000375a:	41c48b93          	addi	s7,s1,1052
    8000375e:	a81d                	j	80003794 <pipewrite+0x70>
      release(&pi->lock);
    80003760:	8526                	mv	a0,s1
    80003762:	066020ef          	jal	800057c8 <release>
      return -1;
    80003766:	597d                	li	s2,-1
    80003768:	7b02                	ld	s6,32(sp)
    8000376a:	6be2                	ld	s7,24(sp)
    8000376c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000376e:	854a                	mv	a0,s2
    80003770:	60e6                	ld	ra,88(sp)
    80003772:	6446                	ld	s0,80(sp)
    80003774:	64a6                	ld	s1,72(sp)
    80003776:	6906                	ld	s2,64(sp)
    80003778:	79e2                	ld	s3,56(sp)
    8000377a:	7a42                	ld	s4,48(sp)
    8000377c:	7aa2                	ld	s5,40(sp)
    8000377e:	6125                	addi	sp,sp,96
    80003780:	8082                	ret
      wakeup(&pi->nread);
    80003782:	8562                	mv	a0,s8
    80003784:	bfdfd0ef          	jal	80001380 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003788:	85a6                	mv	a1,s1
    8000378a:	855e                	mv	a0,s7
    8000378c:	ba9fd0ef          	jal	80001334 <sleep>
  while(i < n){
    80003790:	05495b63          	bge	s2,s4,800037e6 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003794:	4204a783          	lw	a5,1056(s1)
    80003798:	d7e1                	beqz	a5,80003760 <pipewrite+0x3c>
    8000379a:	854e                	mv	a0,s3
    8000379c:	dd1fd0ef          	jal	8000156c <killed>
    800037a0:	f161                	bnez	a0,80003760 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800037a2:	4184a783          	lw	a5,1048(s1)
    800037a6:	41c4a703          	lw	a4,1052(s1)
    800037aa:	4007879b          	addiw	a5,a5,1024
    800037ae:	fcf70ae3          	beq	a4,a5,80003782 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800037b2:	4685                	li	a3,1
    800037b4:	01590633          	add	a2,s2,s5
    800037b8:	faf40593          	addi	a1,s0,-81
    800037bc:	0509b503          	ld	a0,80(s3)
    800037c0:	aeefd0ef          	jal	80000aae <copyin>
    800037c4:	03650e63          	beq	a0,s6,80003800 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800037c8:	41c4a783          	lw	a5,1052(s1)
    800037cc:	0017871b          	addiw	a4,a5,1
    800037d0:	40e4ae23          	sw	a4,1052(s1)
    800037d4:	3ff7f793          	andi	a5,a5,1023
    800037d8:	97a6                	add	a5,a5,s1
    800037da:	faf44703          	lbu	a4,-81(s0)
    800037de:	00e78c23          	sb	a4,24(a5)
      i++;
    800037e2:	2905                	addiw	s2,s2,1
    800037e4:	b775                	j	80003790 <pipewrite+0x6c>
    800037e6:	7b02                	ld	s6,32(sp)
    800037e8:	6be2                	ld	s7,24(sp)
    800037ea:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800037ec:	41848513          	addi	a0,s1,1048
    800037f0:	b91fd0ef          	jal	80001380 <wakeup>
  release(&pi->lock);
    800037f4:	8526                	mv	a0,s1
    800037f6:	7d3010ef          	jal	800057c8 <release>
  return i;
    800037fa:	bf95                	j	8000376e <pipewrite+0x4a>
  int i = 0;
    800037fc:	4901                	li	s2,0
    800037fe:	b7fd                	j	800037ec <pipewrite+0xc8>
    80003800:	7b02                	ld	s6,32(sp)
    80003802:	6be2                	ld	s7,24(sp)
    80003804:	6c42                	ld	s8,16(sp)
    80003806:	b7dd                	j	800037ec <pipewrite+0xc8>

0000000080003808 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003808:	715d                	addi	sp,sp,-80
    8000380a:	e486                	sd	ra,72(sp)
    8000380c:	e0a2                	sd	s0,64(sp)
    8000380e:	fc26                	sd	s1,56(sp)
    80003810:	f84a                	sd	s2,48(sp)
    80003812:	f44e                	sd	s3,40(sp)
    80003814:	f052                	sd	s4,32(sp)
    80003816:	ec56                	sd	s5,24(sp)
    80003818:	0880                	addi	s0,sp,80
    8000381a:	84aa                	mv	s1,a0
    8000381c:	892e                	mv	s2,a1
    8000381e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003820:	d46fd0ef          	jal	80000d66 <myproc>
    80003824:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003826:	8526                	mv	a0,s1
    80003828:	709010ef          	jal	80005730 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000382c:	4184a703          	lw	a4,1048(s1)
    80003830:	41c4a783          	lw	a5,1052(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003834:	41848993          	addi	s3,s1,1048
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003838:	02f71563          	bne	a4,a5,80003862 <piperead+0x5a>
    8000383c:	4244a783          	lw	a5,1060(s1)
    80003840:	cb85                	beqz	a5,80003870 <piperead+0x68>
    if(killed(pr)){
    80003842:	8552                	mv	a0,s4
    80003844:	d29fd0ef          	jal	8000156c <killed>
    80003848:	ed19                	bnez	a0,80003866 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000384a:	85a6                	mv	a1,s1
    8000384c:	854e                	mv	a0,s3
    8000384e:	ae7fd0ef          	jal	80001334 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003852:	4184a703          	lw	a4,1048(s1)
    80003856:	41c4a783          	lw	a5,1052(s1)
    8000385a:	fef701e3          	beq	a4,a5,8000383c <piperead+0x34>
    8000385e:	e85a                	sd	s6,16(sp)
    80003860:	a809                	j	80003872 <piperead+0x6a>
    80003862:	e85a                	sd	s6,16(sp)
    80003864:	a039                	j	80003872 <piperead+0x6a>
      release(&pi->lock);
    80003866:	8526                	mv	a0,s1
    80003868:	761010ef          	jal	800057c8 <release>
      return -1;
    8000386c:	59fd                	li	s3,-1
    8000386e:	a8b1                	j	800038ca <piperead+0xc2>
    80003870:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003872:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003874:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003876:	05505263          	blez	s5,800038ba <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    8000387a:	4184a783          	lw	a5,1048(s1)
    8000387e:	41c4a703          	lw	a4,1052(s1)
    80003882:	02f70c63          	beq	a4,a5,800038ba <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003886:	0017871b          	addiw	a4,a5,1
    8000388a:	40e4ac23          	sw	a4,1048(s1)
    8000388e:	3ff7f793          	andi	a5,a5,1023
    80003892:	97a6                	add	a5,a5,s1
    80003894:	0187c783          	lbu	a5,24(a5)
    80003898:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000389c:	4685                	li	a3,1
    8000389e:	fbf40613          	addi	a2,s0,-65
    800038a2:	85ca                	mv	a1,s2
    800038a4:	050a3503          	ld	a0,80(s4)
    800038a8:	930fd0ef          	jal	800009d8 <copyout>
    800038ac:	01650763          	beq	a0,s6,800038ba <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800038b0:	2985                	addiw	s3,s3,1
    800038b2:	0905                	addi	s2,s2,1
    800038b4:	fd3a93e3          	bne	s5,s3,8000387a <piperead+0x72>
    800038b8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800038ba:	41c48513          	addi	a0,s1,1052
    800038be:	ac3fd0ef          	jal	80001380 <wakeup>
  release(&pi->lock);
    800038c2:	8526                	mv	a0,s1
    800038c4:	705010ef          	jal	800057c8 <release>
    800038c8:	6b42                	ld	s6,16(sp)
  return i;
}
    800038ca:	854e                	mv	a0,s3
    800038cc:	60a6                	ld	ra,72(sp)
    800038ce:	6406                	ld	s0,64(sp)
    800038d0:	74e2                	ld	s1,56(sp)
    800038d2:	7942                	ld	s2,48(sp)
    800038d4:	79a2                	ld	s3,40(sp)
    800038d6:	7a02                	ld	s4,32(sp)
    800038d8:	6ae2                	ld	s5,24(sp)
    800038da:	6161                	addi	sp,sp,80
    800038dc:	8082                	ret

00000000800038de <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800038de:	1141                	addi	sp,sp,-16
    800038e0:	e422                	sd	s0,8(sp)
    800038e2:	0800                	addi	s0,sp,16
    800038e4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800038e6:	8905                	andi	a0,a0,1
    800038e8:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800038ea:	8b89                	andi	a5,a5,2
    800038ec:	c399                	beqz	a5,800038f2 <flags2perm+0x14>
      perm |= PTE_W;
    800038ee:	00456513          	ori	a0,a0,4
    return perm;
}
    800038f2:	6422                	ld	s0,8(sp)
    800038f4:	0141                	addi	sp,sp,16
    800038f6:	8082                	ret

00000000800038f8 <exec>:

int
exec(char *path, char **argv)
{
    800038f8:	df010113          	addi	sp,sp,-528
    800038fc:	20113423          	sd	ra,520(sp)
    80003900:	20813023          	sd	s0,512(sp)
    80003904:	ffa6                	sd	s1,504(sp)
    80003906:	fbca                	sd	s2,496(sp)
    80003908:	0c00                	addi	s0,sp,528
    8000390a:	892a                	mv	s2,a0
    8000390c:	dea43c23          	sd	a0,-520(s0)
    80003910:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003914:	c52fd0ef          	jal	80000d66 <myproc>
    80003918:	84aa                	mv	s1,a0

  begin_op();
    8000391a:	dc2ff0ef          	jal	80002edc <begin_op>

  if((ip = namei(path)) == 0){
    8000391e:	854a                	mv	a0,s2
    80003920:	c00ff0ef          	jal	80002d20 <namei>
    80003924:	c931                	beqz	a0,80003978 <exec+0x80>
    80003926:	f3d2                	sd	s4,480(sp)
    80003928:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000392a:	d1dfe0ef          	jal	80002646 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000392e:	04000713          	li	a4,64
    80003932:	4681                	li	a3,0
    80003934:	e5040613          	addi	a2,s0,-432
    80003938:	4581                	li	a1,0
    8000393a:	8552                	mv	a0,s4
    8000393c:	f5ffe0ef          	jal	8000289a <readi>
    80003940:	04000793          	li	a5,64
    80003944:	00f51a63          	bne	a0,a5,80003958 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003948:	e5042703          	lw	a4,-432(s0)
    8000394c:	464c47b7          	lui	a5,0x464c4
    80003950:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003954:	02f70663          	beq	a4,a5,80003980 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003958:	8552                	mv	a0,s4
    8000395a:	ef7fe0ef          	jal	80002850 <iunlockput>
    end_op();
    8000395e:	deaff0ef          	jal	80002f48 <end_op>
  }
  return -1;
    80003962:	557d                	li	a0,-1
    80003964:	7a1e                	ld	s4,480(sp)
}
    80003966:	20813083          	ld	ra,520(sp)
    8000396a:	20013403          	ld	s0,512(sp)
    8000396e:	74fe                	ld	s1,504(sp)
    80003970:	795e                	ld	s2,496(sp)
    80003972:	21010113          	addi	sp,sp,528
    80003976:	8082                	ret
    end_op();
    80003978:	dd0ff0ef          	jal	80002f48 <end_op>
    return -1;
    8000397c:	557d                	li	a0,-1
    8000397e:	b7e5                	j	80003966 <exec+0x6e>
    80003980:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003982:	8526                	mv	a0,s1
    80003984:	c8afd0ef          	jal	80000e0e <proc_pagetable>
    80003988:	8b2a                	mv	s6,a0
    8000398a:	2c050b63          	beqz	a0,80003c60 <exec+0x368>
    8000398e:	f7ce                	sd	s3,488(sp)
    80003990:	efd6                	sd	s5,472(sp)
    80003992:	e7de                	sd	s7,456(sp)
    80003994:	e3e2                	sd	s8,448(sp)
    80003996:	ff66                	sd	s9,440(sp)
    80003998:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000399a:	e7042d03          	lw	s10,-400(s0)
    8000399e:	e8845783          	lhu	a5,-376(s0)
    800039a2:	12078963          	beqz	a5,80003ad4 <exec+0x1dc>
    800039a6:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800039a8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800039aa:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800039ac:	6c85                	lui	s9,0x1
    800039ae:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800039b2:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800039b6:	6a85                	lui	s5,0x1
    800039b8:	a085                	j	80003a18 <exec+0x120>
      panic("loadseg: address should exist");
    800039ba:	00004517          	auipc	a0,0x4
    800039be:	be650513          	addi	a0,a0,-1050 # 800075a0 <etext+0x5a0>
    800039c2:	241010ef          	jal	80005402 <panic>
    if(sz - i < PGSIZE)
    800039c6:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800039c8:	8726                	mv	a4,s1
    800039ca:	012c06bb          	addw	a3,s8,s2
    800039ce:	4581                	li	a1,0
    800039d0:	8552                	mv	a0,s4
    800039d2:	ec9fe0ef          	jal	8000289a <readi>
    800039d6:	2501                	sext.w	a0,a0
    800039d8:	24a49a63          	bne	s1,a0,80003c2c <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800039dc:	012a893b          	addw	s2,s5,s2
    800039e0:	03397363          	bgeu	s2,s3,80003a06 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800039e4:	02091593          	slli	a1,s2,0x20
    800039e8:	9181                	srli	a1,a1,0x20
    800039ea:	95de                	add	a1,a1,s7
    800039ec:	855a                	mv	a0,s6
    800039ee:	a6ffc0ef          	jal	8000045c <walkaddr>
    800039f2:	862a                	mv	a2,a0
    if(pa == 0)
    800039f4:	d179                	beqz	a0,800039ba <exec+0xc2>
    if(sz - i < PGSIZE)
    800039f6:	412984bb          	subw	s1,s3,s2
    800039fa:	0004879b          	sext.w	a5,s1
    800039fe:	fcfcf4e3          	bgeu	s9,a5,800039c6 <exec+0xce>
    80003a02:	84d6                	mv	s1,s5
    80003a04:	b7c9                	j	800039c6 <exec+0xce>
    sz = sz1;
    80003a06:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a0a:	2d85                	addiw	s11,s11,1
    80003a0c:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003a10:	e8845783          	lhu	a5,-376(s0)
    80003a14:	08fdd063          	bge	s11,a5,80003a94 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003a18:	2d01                	sext.w	s10,s10
    80003a1a:	03800713          	li	a4,56
    80003a1e:	86ea                	mv	a3,s10
    80003a20:	e1840613          	addi	a2,s0,-488
    80003a24:	4581                	li	a1,0
    80003a26:	8552                	mv	a0,s4
    80003a28:	e73fe0ef          	jal	8000289a <readi>
    80003a2c:	03800793          	li	a5,56
    80003a30:	1cf51663          	bne	a0,a5,80003bfc <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003a34:	e1842783          	lw	a5,-488(s0)
    80003a38:	4705                	li	a4,1
    80003a3a:	fce798e3          	bne	a5,a4,80003a0a <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003a3e:	e4043483          	ld	s1,-448(s0)
    80003a42:	e3843783          	ld	a5,-456(s0)
    80003a46:	1af4ef63          	bltu	s1,a5,80003c04 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003a4a:	e2843783          	ld	a5,-472(s0)
    80003a4e:	94be                	add	s1,s1,a5
    80003a50:	1af4ee63          	bltu	s1,a5,80003c0c <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003a54:	df043703          	ld	a4,-528(s0)
    80003a58:	8ff9                	and	a5,a5,a4
    80003a5a:	1a079d63          	bnez	a5,80003c14 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003a5e:	e1c42503          	lw	a0,-484(s0)
    80003a62:	e7dff0ef          	jal	800038de <flags2perm>
    80003a66:	86aa                	mv	a3,a0
    80003a68:	8626                	mv	a2,s1
    80003a6a:	85ca                	mv	a1,s2
    80003a6c:	855a                	mv	a0,s6
    80003a6e:	d57fc0ef          	jal	800007c4 <uvmalloc>
    80003a72:	e0a43423          	sd	a0,-504(s0)
    80003a76:	1a050363          	beqz	a0,80003c1c <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003a7a:	e2843b83          	ld	s7,-472(s0)
    80003a7e:	e2042c03          	lw	s8,-480(s0)
    80003a82:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003a86:	00098463          	beqz	s3,80003a8e <exec+0x196>
    80003a8a:	4901                	li	s2,0
    80003a8c:	bfa1                	j	800039e4 <exec+0xec>
    sz = sz1;
    80003a8e:	e0843903          	ld	s2,-504(s0)
    80003a92:	bfa5                	j	80003a0a <exec+0x112>
    80003a94:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003a96:	8552                	mv	a0,s4
    80003a98:	db9fe0ef          	jal	80002850 <iunlockput>
  end_op();
    80003a9c:	cacff0ef          	jal	80002f48 <end_op>
  p = myproc();
    80003aa0:	ac6fd0ef          	jal	80000d66 <myproc>
    80003aa4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003aa6:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003aaa:	6985                	lui	s3,0x1
    80003aac:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003aae:	99ca                	add	s3,s3,s2
    80003ab0:	77fd                	lui	a5,0xfffff
    80003ab2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003ab6:	4691                	li	a3,4
    80003ab8:	660d                	lui	a2,0x3
    80003aba:	964e                	add	a2,a2,s3
    80003abc:	85ce                	mv	a1,s3
    80003abe:	855a                	mv	a0,s6
    80003ac0:	d05fc0ef          	jal	800007c4 <uvmalloc>
    80003ac4:	892a                	mv	s2,a0
    80003ac6:	e0a43423          	sd	a0,-504(s0)
    80003aca:	e519                	bnez	a0,80003ad8 <exec+0x1e0>
  if(pagetable)
    80003acc:	e1343423          	sd	s3,-504(s0)
    80003ad0:	4a01                	li	s4,0
    80003ad2:	aab1                	j	80003c2e <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ad4:	4901                	li	s2,0
    80003ad6:	b7c1                	j	80003a96 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003ad8:	75f5                	lui	a1,0xffffd
    80003ada:	95aa                	add	a1,a1,a0
    80003adc:	855a                	mv	a0,s6
    80003ade:	ed1fc0ef          	jal	800009ae <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003ae2:	7bf9                	lui	s7,0xffffe
    80003ae4:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003ae6:	e0043783          	ld	a5,-512(s0)
    80003aea:	6388                	ld	a0,0(a5)
    80003aec:	cd39                	beqz	a0,80003b4a <exec+0x252>
    80003aee:	e9040993          	addi	s3,s0,-368
    80003af2:	f9040c13          	addi	s8,s0,-112
    80003af6:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003af8:	fc6fc0ef          	jal	800002be <strlen>
    80003afc:	0015079b          	addiw	a5,a0,1
    80003b00:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003b04:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003b08:	11796e63          	bltu	s2,s7,80003c24 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003b0c:	e0043d03          	ld	s10,-512(s0)
    80003b10:	000d3a03          	ld	s4,0(s10)
    80003b14:	8552                	mv	a0,s4
    80003b16:	fa8fc0ef          	jal	800002be <strlen>
    80003b1a:	0015069b          	addiw	a3,a0,1
    80003b1e:	8652                	mv	a2,s4
    80003b20:	85ca                	mv	a1,s2
    80003b22:	855a                	mv	a0,s6
    80003b24:	eb5fc0ef          	jal	800009d8 <copyout>
    80003b28:	10054063          	bltz	a0,80003c28 <exec+0x330>
    ustack[argc] = sp;
    80003b2c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003b30:	0485                	addi	s1,s1,1
    80003b32:	008d0793          	addi	a5,s10,8
    80003b36:	e0f43023          	sd	a5,-512(s0)
    80003b3a:	008d3503          	ld	a0,8(s10)
    80003b3e:	c909                	beqz	a0,80003b50 <exec+0x258>
    if(argc >= MAXARG)
    80003b40:	09a1                	addi	s3,s3,8
    80003b42:	fb899be3          	bne	s3,s8,80003af8 <exec+0x200>
  ip = 0;
    80003b46:	4a01                	li	s4,0
    80003b48:	a0dd                	j	80003c2e <exec+0x336>
  sp = sz;
    80003b4a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003b4e:	4481                	li	s1,0
  ustack[argc] = 0;
    80003b50:	00349793          	slli	a5,s1,0x3
    80003b54:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffcd780>
    80003b58:	97a2                	add	a5,a5,s0
    80003b5a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003b5e:	00148693          	addi	a3,s1,1
    80003b62:	068e                	slli	a3,a3,0x3
    80003b64:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003b68:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003b6c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003b70:	f5796ee3          	bltu	s2,s7,80003acc <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003b74:	e9040613          	addi	a2,s0,-368
    80003b78:	85ca                	mv	a1,s2
    80003b7a:	855a                	mv	a0,s6
    80003b7c:	e5dfc0ef          	jal	800009d8 <copyout>
    80003b80:	0e054263          	bltz	a0,80003c64 <exec+0x36c>
  p->trapframe->a1 = sp;
    80003b84:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003b88:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003b8c:	df843783          	ld	a5,-520(s0)
    80003b90:	0007c703          	lbu	a4,0(a5)
    80003b94:	cf11                	beqz	a4,80003bb0 <exec+0x2b8>
    80003b96:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003b98:	02f00693          	li	a3,47
    80003b9c:	a039                	j	80003baa <exec+0x2b2>
      last = s+1;
    80003b9e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003ba2:	0785                	addi	a5,a5,1
    80003ba4:	fff7c703          	lbu	a4,-1(a5)
    80003ba8:	c701                	beqz	a4,80003bb0 <exec+0x2b8>
    if(*s == '/')
    80003baa:	fed71ce3          	bne	a4,a3,80003ba2 <exec+0x2aa>
    80003bae:	bfc5                	j	80003b9e <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003bb0:	4641                	li	a2,16
    80003bb2:	df843583          	ld	a1,-520(s0)
    80003bb6:	2d8a8513          	addi	a0,s5,728
    80003bba:	ed2fc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003bbe:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003bc2:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003bc6:	e0843783          	ld	a5,-504(s0)
    80003bca:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003bce:	058ab783          	ld	a5,88(s5)
    80003bd2:	e6843703          	ld	a4,-408(s0)
    80003bd6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003bd8:	058ab783          	ld	a5,88(s5)
    80003bdc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003be0:	85e6                	mv	a1,s9
    80003be2:	ab0fd0ef          	jal	80000e92 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003be6:	0004851b          	sext.w	a0,s1
    80003bea:	79be                	ld	s3,488(sp)
    80003bec:	7a1e                	ld	s4,480(sp)
    80003bee:	6afe                	ld	s5,472(sp)
    80003bf0:	6b5e                	ld	s6,464(sp)
    80003bf2:	6bbe                	ld	s7,456(sp)
    80003bf4:	6c1e                	ld	s8,448(sp)
    80003bf6:	7cfa                	ld	s9,440(sp)
    80003bf8:	7d5a                	ld	s10,432(sp)
    80003bfa:	b3b5                	j	80003966 <exec+0x6e>
    80003bfc:	e1243423          	sd	s2,-504(s0)
    80003c00:	7dba                	ld	s11,424(sp)
    80003c02:	a035                	j	80003c2e <exec+0x336>
    80003c04:	e1243423          	sd	s2,-504(s0)
    80003c08:	7dba                	ld	s11,424(sp)
    80003c0a:	a015                	j	80003c2e <exec+0x336>
    80003c0c:	e1243423          	sd	s2,-504(s0)
    80003c10:	7dba                	ld	s11,424(sp)
    80003c12:	a831                	j	80003c2e <exec+0x336>
    80003c14:	e1243423          	sd	s2,-504(s0)
    80003c18:	7dba                	ld	s11,424(sp)
    80003c1a:	a811                	j	80003c2e <exec+0x336>
    80003c1c:	e1243423          	sd	s2,-504(s0)
    80003c20:	7dba                	ld	s11,424(sp)
    80003c22:	a031                	j	80003c2e <exec+0x336>
  ip = 0;
    80003c24:	4a01                	li	s4,0
    80003c26:	a021                	j	80003c2e <exec+0x336>
    80003c28:	4a01                	li	s4,0
  if(pagetable)
    80003c2a:	a011                	j	80003c2e <exec+0x336>
    80003c2c:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003c2e:	e0843583          	ld	a1,-504(s0)
    80003c32:	855a                	mv	a0,s6
    80003c34:	a5efd0ef          	jal	80000e92 <proc_freepagetable>
  return -1;
    80003c38:	557d                	li	a0,-1
  if(ip){
    80003c3a:	000a1b63          	bnez	s4,80003c50 <exec+0x358>
    80003c3e:	79be                	ld	s3,488(sp)
    80003c40:	7a1e                	ld	s4,480(sp)
    80003c42:	6afe                	ld	s5,472(sp)
    80003c44:	6b5e                	ld	s6,464(sp)
    80003c46:	6bbe                	ld	s7,456(sp)
    80003c48:	6c1e                	ld	s8,448(sp)
    80003c4a:	7cfa                	ld	s9,440(sp)
    80003c4c:	7d5a                	ld	s10,432(sp)
    80003c4e:	bb21                	j	80003966 <exec+0x6e>
    80003c50:	79be                	ld	s3,488(sp)
    80003c52:	6afe                	ld	s5,472(sp)
    80003c54:	6b5e                	ld	s6,464(sp)
    80003c56:	6bbe                	ld	s7,456(sp)
    80003c58:	6c1e                	ld	s8,448(sp)
    80003c5a:	7cfa                	ld	s9,440(sp)
    80003c5c:	7d5a                	ld	s10,432(sp)
    80003c5e:	b9ed                	j	80003958 <exec+0x60>
    80003c60:	6b5e                	ld	s6,464(sp)
    80003c62:	b9dd                	j	80003958 <exec+0x60>
  sz = sz1;
    80003c64:	e0843983          	ld	s3,-504(s0)
    80003c68:	b595                	j	80003acc <exec+0x1d4>

0000000080003c6a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003c6a:	7179                	addi	sp,sp,-48
    80003c6c:	f406                	sd	ra,40(sp)
    80003c6e:	f022                	sd	s0,32(sp)
    80003c70:	ec26                	sd	s1,24(sp)
    80003c72:	e84a                	sd	s2,16(sp)
    80003c74:	1800                	addi	s0,sp,48
    80003c76:	892e                	mv	s2,a1
    80003c78:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003c7a:	fdc40593          	addi	a1,s0,-36
    80003c7e:	f9dfd0ef          	jal	80001c1a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003c82:	fdc42703          	lw	a4,-36(s0)
    80003c86:	03f00793          	li	a5,63
    80003c8a:	02e7e963          	bltu	a5,a4,80003cbc <argfd+0x52>
    80003c8e:	8d8fd0ef          	jal	80000d66 <myproc>
    80003c92:	fdc42703          	lw	a4,-36(s0)
    80003c96:	01a70793          	addi	a5,a4,26
    80003c9a:	078e                	slli	a5,a5,0x3
    80003c9c:	953e                	add	a0,a0,a5
    80003c9e:	611c                	ld	a5,0(a0)
    80003ca0:	c385                	beqz	a5,80003cc0 <argfd+0x56>
    return -1;
  if(pfd)
    80003ca2:	00090463          	beqz	s2,80003caa <argfd+0x40>
    *pfd = fd;
    80003ca6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003caa:	4501                	li	a0,0
  if(pf)
    80003cac:	c091                	beqz	s1,80003cb0 <argfd+0x46>
    *pf = f;
    80003cae:	e09c                	sd	a5,0(s1)
}
    80003cb0:	70a2                	ld	ra,40(sp)
    80003cb2:	7402                	ld	s0,32(sp)
    80003cb4:	64e2                	ld	s1,24(sp)
    80003cb6:	6942                	ld	s2,16(sp)
    80003cb8:	6145                	addi	sp,sp,48
    80003cba:	8082                	ret
    return -1;
    80003cbc:	557d                	li	a0,-1
    80003cbe:	bfcd                	j	80003cb0 <argfd+0x46>
    80003cc0:	557d                	li	a0,-1
    80003cc2:	b7fd                	j	80003cb0 <argfd+0x46>

0000000080003cc4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003cc4:	1101                	addi	sp,sp,-32
    80003cc6:	ec06                	sd	ra,24(sp)
    80003cc8:	e822                	sd	s0,16(sp)
    80003cca:	e426                	sd	s1,8(sp)
    80003ccc:	1000                	addi	s0,sp,32
    80003cce:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003cd0:	896fd0ef          	jal	80000d66 <myproc>
    80003cd4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003cd6:	0d050793          	addi	a5,a0,208
    80003cda:	4501                	li	a0,0
    80003cdc:	04000693          	li	a3,64
    if(p->ofile[fd] == 0){
    80003ce0:	6398                	ld	a4,0(a5)
    80003ce2:	c719                	beqz	a4,80003cf0 <fdalloc+0x2c>
  for(fd = 0; fd < NOFILE; fd++){
    80003ce4:	2505                	addiw	a0,a0,1
    80003ce6:	07a1                	addi	a5,a5,8
    80003ce8:	fed51ce3          	bne	a0,a3,80003ce0 <fdalloc+0x1c>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003cec:	557d                	li	a0,-1
    80003cee:	a031                	j	80003cfa <fdalloc+0x36>
      p->ofile[fd] = f;
    80003cf0:	01a50793          	addi	a5,a0,26
    80003cf4:	078e                	slli	a5,a5,0x3
    80003cf6:	963e                	add	a2,a2,a5
    80003cf8:	e204                	sd	s1,0(a2)
}
    80003cfa:	60e2                	ld	ra,24(sp)
    80003cfc:	6442                	ld	s0,16(sp)
    80003cfe:	64a2                	ld	s1,8(sp)
    80003d00:	6105                	addi	sp,sp,32
    80003d02:	8082                	ret

0000000080003d04 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003d04:	715d                	addi	sp,sp,-80
    80003d06:	e486                	sd	ra,72(sp)
    80003d08:	e0a2                	sd	s0,64(sp)
    80003d0a:	fc26                	sd	s1,56(sp)
    80003d0c:	f84a                	sd	s2,48(sp)
    80003d0e:	f44e                	sd	s3,40(sp)
    80003d10:	ec56                	sd	s5,24(sp)
    80003d12:	e85a                	sd	s6,16(sp)
    80003d14:	0880                	addi	s0,sp,80
    80003d16:	8b2e                	mv	s6,a1
    80003d18:	89b2                	mv	s3,a2
    80003d1a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003d1c:	fb040593          	addi	a1,s0,-80
    80003d20:	81aff0ef          	jal	80002d3a <nameiparent>
    80003d24:	84aa                	mv	s1,a0
    80003d26:	10050a63          	beqz	a0,80003e3a <create+0x136>
    return 0;

  ilock(dp);
    80003d2a:	91dfe0ef          	jal	80002646 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d2e:	4601                	li	a2,0
    80003d30:	fb040593          	addi	a1,s0,-80
    80003d34:	8526                	mv	a0,s1
    80003d36:	d85fe0ef          	jal	80002aba <dirlookup>
    80003d3a:	8aaa                	mv	s5,a0
    80003d3c:	c129                	beqz	a0,80003d7e <create+0x7a>
    iunlockput(dp);
    80003d3e:	8526                	mv	a0,s1
    80003d40:	b11fe0ef          	jal	80002850 <iunlockput>
    ilock(ip);
    80003d44:	8556                	mv	a0,s5
    80003d46:	901fe0ef          	jal	80002646 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003d4a:	4789                	li	a5,2
    80003d4c:	02fb1463          	bne	s6,a5,80003d74 <create+0x70>
    80003d50:	044ad783          	lhu	a5,68(s5)
    80003d54:	37f9                	addiw	a5,a5,-2
    80003d56:	17c2                	slli	a5,a5,0x30
    80003d58:	93c1                	srli	a5,a5,0x30
    80003d5a:	4705                	li	a4,1
    80003d5c:	00f76c63          	bltu	a4,a5,80003d74 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003d60:	8556                	mv	a0,s5
    80003d62:	60a6                	ld	ra,72(sp)
    80003d64:	6406                	ld	s0,64(sp)
    80003d66:	74e2                	ld	s1,56(sp)
    80003d68:	7942                	ld	s2,48(sp)
    80003d6a:	79a2                	ld	s3,40(sp)
    80003d6c:	6ae2                	ld	s5,24(sp)
    80003d6e:	6b42                	ld	s6,16(sp)
    80003d70:	6161                	addi	sp,sp,80
    80003d72:	8082                	ret
    iunlockput(ip);
    80003d74:	8556                	mv	a0,s5
    80003d76:	adbfe0ef          	jal	80002850 <iunlockput>
    return 0;
    80003d7a:	4a81                	li	s5,0
    80003d7c:	b7d5                	j	80003d60 <create+0x5c>
    80003d7e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003d80:	85da                	mv	a1,s6
    80003d82:	4088                	lw	a0,0(s1)
    80003d84:	f52fe0ef          	jal	800024d6 <ialloc>
    80003d88:	8a2a                	mv	s4,a0
    80003d8a:	cd15                	beqz	a0,80003dc6 <create+0xc2>
  ilock(ip);
    80003d8c:	8bbfe0ef          	jal	80002646 <ilock>
  ip->major = major;
    80003d90:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003d94:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003d98:	4905                	li	s2,1
    80003d9a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003d9e:	8552                	mv	a0,s4
    80003da0:	ff2fe0ef          	jal	80002592 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003da4:	032b0763          	beq	s6,s2,80003dd2 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003da8:	004a2603          	lw	a2,4(s4)
    80003dac:	fb040593          	addi	a1,s0,-80
    80003db0:	8526                	mv	a0,s1
    80003db2:	ed5fe0ef          	jal	80002c86 <dirlink>
    80003db6:	06054563          	bltz	a0,80003e20 <create+0x11c>
  iunlockput(dp);
    80003dba:	8526                	mv	a0,s1
    80003dbc:	a95fe0ef          	jal	80002850 <iunlockput>
  return ip;
    80003dc0:	8ad2                	mv	s5,s4
    80003dc2:	7a02                	ld	s4,32(sp)
    80003dc4:	bf71                	j	80003d60 <create+0x5c>
    iunlockput(dp);
    80003dc6:	8526                	mv	a0,s1
    80003dc8:	a89fe0ef          	jal	80002850 <iunlockput>
    return 0;
    80003dcc:	8ad2                	mv	s5,s4
    80003dce:	7a02                	ld	s4,32(sp)
    80003dd0:	bf41                	j	80003d60 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003dd2:	004a2603          	lw	a2,4(s4)
    80003dd6:	00003597          	auipc	a1,0x3
    80003dda:	7ea58593          	addi	a1,a1,2026 # 800075c0 <etext+0x5c0>
    80003dde:	8552                	mv	a0,s4
    80003de0:	ea7fe0ef          	jal	80002c86 <dirlink>
    80003de4:	02054e63          	bltz	a0,80003e20 <create+0x11c>
    80003de8:	40d0                	lw	a2,4(s1)
    80003dea:	00003597          	auipc	a1,0x3
    80003dee:	7de58593          	addi	a1,a1,2014 # 800075c8 <etext+0x5c8>
    80003df2:	8552                	mv	a0,s4
    80003df4:	e93fe0ef          	jal	80002c86 <dirlink>
    80003df8:	02054463          	bltz	a0,80003e20 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003dfc:	004a2603          	lw	a2,4(s4)
    80003e00:	fb040593          	addi	a1,s0,-80
    80003e04:	8526                	mv	a0,s1
    80003e06:	e81fe0ef          	jal	80002c86 <dirlink>
    80003e0a:	00054b63          	bltz	a0,80003e20 <create+0x11c>
    dp->nlink++;  // for ".."
    80003e0e:	04a4d783          	lhu	a5,74(s1)
    80003e12:	2785                	addiw	a5,a5,1
    80003e14:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003e18:	8526                	mv	a0,s1
    80003e1a:	f78fe0ef          	jal	80002592 <iupdate>
    80003e1e:	bf71                	j	80003dba <create+0xb6>
  ip->nlink = 0;
    80003e20:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003e24:	8552                	mv	a0,s4
    80003e26:	f6cfe0ef          	jal	80002592 <iupdate>
  iunlockput(ip);
    80003e2a:	8552                	mv	a0,s4
    80003e2c:	a25fe0ef          	jal	80002850 <iunlockput>
  iunlockput(dp);
    80003e30:	8526                	mv	a0,s1
    80003e32:	a1ffe0ef          	jal	80002850 <iunlockput>
  return 0;
    80003e36:	7a02                	ld	s4,32(sp)
    80003e38:	b725                	j	80003d60 <create+0x5c>
    return 0;
    80003e3a:	8aaa                	mv	s5,a0
    80003e3c:	b715                	j	80003d60 <create+0x5c>

0000000080003e3e <sys_dup>:
{
    80003e3e:	7179                	addi	sp,sp,-48
    80003e40:	f406                	sd	ra,40(sp)
    80003e42:	f022                	sd	s0,32(sp)
    80003e44:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003e46:	fd840613          	addi	a2,s0,-40
    80003e4a:	4581                	li	a1,0
    80003e4c:	4501                	li	a0,0
    80003e4e:	e1dff0ef          	jal	80003c6a <argfd>
    return -1;
    80003e52:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003e54:	02054363          	bltz	a0,80003e7a <sys_dup+0x3c>
    80003e58:	ec26                	sd	s1,24(sp)
    80003e5a:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003e5c:	fd843903          	ld	s2,-40(s0)
    80003e60:	854a                	mv	a0,s2
    80003e62:	e63ff0ef          	jal	80003cc4 <fdalloc>
    80003e66:	84aa                	mv	s1,a0
    return -1;
    80003e68:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003e6a:	00054d63          	bltz	a0,80003e84 <sys_dup+0x46>
  filedup(f);
    80003e6e:	854a                	mv	a0,s2
    80003e70:	c44ff0ef          	jal	800032b4 <filedup>
  return fd;
    80003e74:	87a6                	mv	a5,s1
    80003e76:	64e2                	ld	s1,24(sp)
    80003e78:	6942                	ld	s2,16(sp)
}
    80003e7a:	853e                	mv	a0,a5
    80003e7c:	70a2                	ld	ra,40(sp)
    80003e7e:	7402                	ld	s0,32(sp)
    80003e80:	6145                	addi	sp,sp,48
    80003e82:	8082                	ret
    80003e84:	64e2                	ld	s1,24(sp)
    80003e86:	6942                	ld	s2,16(sp)
    80003e88:	bfcd                	j	80003e7a <sys_dup+0x3c>

0000000080003e8a <sys_read>:
{
    80003e8a:	7179                	addi	sp,sp,-48
    80003e8c:	f406                	sd	ra,40(sp)
    80003e8e:	f022                	sd	s0,32(sp)
    80003e90:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003e92:	fd840593          	addi	a1,s0,-40
    80003e96:	4505                	li	a0,1
    80003e98:	d9ffd0ef          	jal	80001c36 <argaddr>
  argint(2, &n);
    80003e9c:	fe440593          	addi	a1,s0,-28
    80003ea0:	4509                	li	a0,2
    80003ea2:	d79fd0ef          	jal	80001c1a <argint>
  if(argfd(0, 0, &f) < 0)
    80003ea6:	fe840613          	addi	a2,s0,-24
    80003eaa:	4581                	li	a1,0
    80003eac:	4501                	li	a0,0
    80003eae:	dbdff0ef          	jal	80003c6a <argfd>
    80003eb2:	87aa                	mv	a5,a0
    return -1;
    80003eb4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003eb6:	0007ca63          	bltz	a5,80003eca <sys_read+0x40>
  return fileread(f, p, n);
    80003eba:	fe442603          	lw	a2,-28(s0)
    80003ebe:	fd843583          	ld	a1,-40(s0)
    80003ec2:	fe843503          	ld	a0,-24(s0)
    80003ec6:	d54ff0ef          	jal	8000341a <fileread>
}
    80003eca:	70a2                	ld	ra,40(sp)
    80003ecc:	7402                	ld	s0,32(sp)
    80003ece:	6145                	addi	sp,sp,48
    80003ed0:	8082                	ret

0000000080003ed2 <sys_write>:
{
    80003ed2:	7179                	addi	sp,sp,-48
    80003ed4:	f406                	sd	ra,40(sp)
    80003ed6:	f022                	sd	s0,32(sp)
    80003ed8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003eda:	fd840593          	addi	a1,s0,-40
    80003ede:	4505                	li	a0,1
    80003ee0:	d57fd0ef          	jal	80001c36 <argaddr>
  argint(2, &n);
    80003ee4:	fe440593          	addi	a1,s0,-28
    80003ee8:	4509                	li	a0,2
    80003eea:	d31fd0ef          	jal	80001c1a <argint>
  if(argfd(0, 0, &f) < 0)
    80003eee:	fe840613          	addi	a2,s0,-24
    80003ef2:	4581                	li	a1,0
    80003ef4:	4501                	li	a0,0
    80003ef6:	d75ff0ef          	jal	80003c6a <argfd>
    80003efa:	87aa                	mv	a5,a0
    return -1;
    80003efc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003efe:	0007ca63          	bltz	a5,80003f12 <sys_write+0x40>
  return filewrite(f, p, n);
    80003f02:	fe442603          	lw	a2,-28(s0)
    80003f06:	fd843583          	ld	a1,-40(s0)
    80003f0a:	fe843503          	ld	a0,-24(s0)
    80003f0e:	dcaff0ef          	jal	800034d8 <filewrite>
}
    80003f12:	70a2                	ld	ra,40(sp)
    80003f14:	7402                	ld	s0,32(sp)
    80003f16:	6145                	addi	sp,sp,48
    80003f18:	8082                	ret

0000000080003f1a <sys_close>:
{
    80003f1a:	1101                	addi	sp,sp,-32
    80003f1c:	ec06                	sd	ra,24(sp)
    80003f1e:	e822                	sd	s0,16(sp)
    80003f20:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003f22:	fe040613          	addi	a2,s0,-32
    80003f26:	fec40593          	addi	a1,s0,-20
    80003f2a:	4501                	li	a0,0
    80003f2c:	d3fff0ef          	jal	80003c6a <argfd>
    return -1;
    80003f30:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003f32:	02054063          	bltz	a0,80003f52 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003f36:	e31fc0ef          	jal	80000d66 <myproc>
    80003f3a:	fec42783          	lw	a5,-20(s0)
    80003f3e:	07e9                	addi	a5,a5,26
    80003f40:	078e                	slli	a5,a5,0x3
    80003f42:	953e                	add	a0,a0,a5
    80003f44:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80003f48:	fe043503          	ld	a0,-32(s0)
    80003f4c:	baeff0ef          	jal	800032fa <fileclose>
  return 0;
    80003f50:	4781                	li	a5,0
}
    80003f52:	853e                	mv	a0,a5
    80003f54:	60e2                	ld	ra,24(sp)
    80003f56:	6442                	ld	s0,16(sp)
    80003f58:	6105                	addi	sp,sp,32
    80003f5a:	8082                	ret

0000000080003f5c <sys_fstat>:
{
    80003f5c:	1101                	addi	sp,sp,-32
    80003f5e:	ec06                	sd	ra,24(sp)
    80003f60:	e822                	sd	s0,16(sp)
    80003f62:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80003f64:	fe040593          	addi	a1,s0,-32
    80003f68:	4505                	li	a0,1
    80003f6a:	ccdfd0ef          	jal	80001c36 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80003f6e:	fe840613          	addi	a2,s0,-24
    80003f72:	4581                	li	a1,0
    80003f74:	4501                	li	a0,0
    80003f76:	cf5ff0ef          	jal	80003c6a <argfd>
    80003f7a:	87aa                	mv	a5,a0
    return -1;
    80003f7c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f7e:	0007c863          	bltz	a5,80003f8e <sys_fstat+0x32>
  return filestat(f, st);
    80003f82:	fe043583          	ld	a1,-32(s0)
    80003f86:	fe843503          	ld	a0,-24(s0)
    80003f8a:	c32ff0ef          	jal	800033bc <filestat>
}
    80003f8e:	60e2                	ld	ra,24(sp)
    80003f90:	6442                	ld	s0,16(sp)
    80003f92:	6105                	addi	sp,sp,32
    80003f94:	8082                	ret

0000000080003f96 <sys_link>:
{
    80003f96:	7169                	addi	sp,sp,-304
    80003f98:	f606                	sd	ra,296(sp)
    80003f9a:	f222                	sd	s0,288(sp)
    80003f9c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003f9e:	08000613          	li	a2,128
    80003fa2:	ed040593          	addi	a1,s0,-304
    80003fa6:	4501                	li	a0,0
    80003fa8:	cabfd0ef          	jal	80001c52 <argstr>
    return -1;
    80003fac:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003fae:	0c054e63          	bltz	a0,8000408a <sys_link+0xf4>
    80003fb2:	08000613          	li	a2,128
    80003fb6:	f5040593          	addi	a1,s0,-176
    80003fba:	4505                	li	a0,1
    80003fbc:	c97fd0ef          	jal	80001c52 <argstr>
    return -1;
    80003fc0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003fc2:	0c054463          	bltz	a0,8000408a <sys_link+0xf4>
    80003fc6:	ee26                	sd	s1,280(sp)
  begin_op();
    80003fc8:	f15fe0ef          	jal	80002edc <begin_op>
  if((ip = namei(old)) == 0){
    80003fcc:	ed040513          	addi	a0,s0,-304
    80003fd0:	d51fe0ef          	jal	80002d20 <namei>
    80003fd4:	84aa                	mv	s1,a0
    80003fd6:	c53d                	beqz	a0,80004044 <sys_link+0xae>
  ilock(ip);
    80003fd8:	e6efe0ef          	jal	80002646 <ilock>
  if(ip->type == T_DIR){
    80003fdc:	04449703          	lh	a4,68(s1)
    80003fe0:	4785                	li	a5,1
    80003fe2:	06f70663          	beq	a4,a5,8000404e <sys_link+0xb8>
    80003fe6:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80003fe8:	04a4d783          	lhu	a5,74(s1)
    80003fec:	2785                	addiw	a5,a5,1
    80003fee:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80003ff2:	8526                	mv	a0,s1
    80003ff4:	d9efe0ef          	jal	80002592 <iupdate>
  iunlock(ip);
    80003ff8:	8526                	mv	a0,s1
    80003ffa:	efafe0ef          	jal	800026f4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80003ffe:	fd040593          	addi	a1,s0,-48
    80004002:	f5040513          	addi	a0,s0,-176
    80004006:	d35fe0ef          	jal	80002d3a <nameiparent>
    8000400a:	892a                	mv	s2,a0
    8000400c:	cd21                	beqz	a0,80004064 <sys_link+0xce>
  ilock(dp);
    8000400e:	e38fe0ef          	jal	80002646 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004012:	00092703          	lw	a4,0(s2)
    80004016:	409c                	lw	a5,0(s1)
    80004018:	04f71363          	bne	a4,a5,8000405e <sys_link+0xc8>
    8000401c:	40d0                	lw	a2,4(s1)
    8000401e:	fd040593          	addi	a1,s0,-48
    80004022:	854a                	mv	a0,s2
    80004024:	c63fe0ef          	jal	80002c86 <dirlink>
    80004028:	02054b63          	bltz	a0,8000405e <sys_link+0xc8>
  iunlockput(dp);
    8000402c:	854a                	mv	a0,s2
    8000402e:	823fe0ef          	jal	80002850 <iunlockput>
  iput(ip);
    80004032:	8526                	mv	a0,s1
    80004034:	f94fe0ef          	jal	800027c8 <iput>
  end_op();
    80004038:	f11fe0ef          	jal	80002f48 <end_op>
  return 0;
    8000403c:	4781                	li	a5,0
    8000403e:	64f2                	ld	s1,280(sp)
    80004040:	6952                	ld	s2,272(sp)
    80004042:	a0a1                	j	8000408a <sys_link+0xf4>
    end_op();
    80004044:	f05fe0ef          	jal	80002f48 <end_op>
    return -1;
    80004048:	57fd                	li	a5,-1
    8000404a:	64f2                	ld	s1,280(sp)
    8000404c:	a83d                	j	8000408a <sys_link+0xf4>
    iunlockput(ip);
    8000404e:	8526                	mv	a0,s1
    80004050:	801fe0ef          	jal	80002850 <iunlockput>
    end_op();
    80004054:	ef5fe0ef          	jal	80002f48 <end_op>
    return -1;
    80004058:	57fd                	li	a5,-1
    8000405a:	64f2                	ld	s1,280(sp)
    8000405c:	a03d                	j	8000408a <sys_link+0xf4>
    iunlockput(dp);
    8000405e:	854a                	mv	a0,s2
    80004060:	ff0fe0ef          	jal	80002850 <iunlockput>
  ilock(ip);
    80004064:	8526                	mv	a0,s1
    80004066:	de0fe0ef          	jal	80002646 <ilock>
  ip->nlink--;
    8000406a:	04a4d783          	lhu	a5,74(s1)
    8000406e:	37fd                	addiw	a5,a5,-1
    80004070:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004074:	8526                	mv	a0,s1
    80004076:	d1cfe0ef          	jal	80002592 <iupdate>
  iunlockput(ip);
    8000407a:	8526                	mv	a0,s1
    8000407c:	fd4fe0ef          	jal	80002850 <iunlockput>
  end_op();
    80004080:	ec9fe0ef          	jal	80002f48 <end_op>
  return -1;
    80004084:	57fd                	li	a5,-1
    80004086:	64f2                	ld	s1,280(sp)
    80004088:	6952                	ld	s2,272(sp)
}
    8000408a:	853e                	mv	a0,a5
    8000408c:	70b2                	ld	ra,296(sp)
    8000408e:	7412                	ld	s0,288(sp)
    80004090:	6155                	addi	sp,sp,304
    80004092:	8082                	ret

0000000080004094 <sys_unlink>:
{
    80004094:	7151                	addi	sp,sp,-240
    80004096:	f586                	sd	ra,232(sp)
    80004098:	f1a2                	sd	s0,224(sp)
    8000409a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000409c:	08000613          	li	a2,128
    800040a0:	f3040593          	addi	a1,s0,-208
    800040a4:	4501                	li	a0,0
    800040a6:	badfd0ef          	jal	80001c52 <argstr>
    800040aa:	16054063          	bltz	a0,8000420a <sys_unlink+0x176>
    800040ae:	eda6                	sd	s1,216(sp)
  begin_op();
    800040b0:	e2dfe0ef          	jal	80002edc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800040b4:	fb040593          	addi	a1,s0,-80
    800040b8:	f3040513          	addi	a0,s0,-208
    800040bc:	c7ffe0ef          	jal	80002d3a <nameiparent>
    800040c0:	84aa                	mv	s1,a0
    800040c2:	c945                	beqz	a0,80004172 <sys_unlink+0xde>
  ilock(dp);
    800040c4:	d82fe0ef          	jal	80002646 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800040c8:	00003597          	auipc	a1,0x3
    800040cc:	4f858593          	addi	a1,a1,1272 # 800075c0 <etext+0x5c0>
    800040d0:	fb040513          	addi	a0,s0,-80
    800040d4:	9d1fe0ef          	jal	80002aa4 <namecmp>
    800040d8:	10050e63          	beqz	a0,800041f4 <sys_unlink+0x160>
    800040dc:	00003597          	auipc	a1,0x3
    800040e0:	4ec58593          	addi	a1,a1,1260 # 800075c8 <etext+0x5c8>
    800040e4:	fb040513          	addi	a0,s0,-80
    800040e8:	9bdfe0ef          	jal	80002aa4 <namecmp>
    800040ec:	10050463          	beqz	a0,800041f4 <sys_unlink+0x160>
    800040f0:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800040f2:	f2c40613          	addi	a2,s0,-212
    800040f6:	fb040593          	addi	a1,s0,-80
    800040fa:	8526                	mv	a0,s1
    800040fc:	9bffe0ef          	jal	80002aba <dirlookup>
    80004100:	892a                	mv	s2,a0
    80004102:	0e050863          	beqz	a0,800041f2 <sys_unlink+0x15e>
  ilock(ip);
    80004106:	d40fe0ef          	jal	80002646 <ilock>
  if(ip->nlink < 1)
    8000410a:	04a91783          	lh	a5,74(s2)
    8000410e:	06f05763          	blez	a5,8000417c <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004112:	04491703          	lh	a4,68(s2)
    80004116:	4785                	li	a5,1
    80004118:	06f70963          	beq	a4,a5,8000418a <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    8000411c:	4641                	li	a2,16
    8000411e:	4581                	li	a1,0
    80004120:	fc040513          	addi	a0,s0,-64
    80004124:	82afc0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004128:	4741                	li	a4,16
    8000412a:	f2c42683          	lw	a3,-212(s0)
    8000412e:	fc040613          	addi	a2,s0,-64
    80004132:	4581                	li	a1,0
    80004134:	8526                	mv	a0,s1
    80004136:	861fe0ef          	jal	80002996 <writei>
    8000413a:	47c1                	li	a5,16
    8000413c:	08f51b63          	bne	a0,a5,800041d2 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004140:	04491703          	lh	a4,68(s2)
    80004144:	4785                	li	a5,1
    80004146:	08f70d63          	beq	a4,a5,800041e0 <sys_unlink+0x14c>
  iunlockput(dp);
    8000414a:	8526                	mv	a0,s1
    8000414c:	f04fe0ef          	jal	80002850 <iunlockput>
  ip->nlink--;
    80004150:	04a95783          	lhu	a5,74(s2)
    80004154:	37fd                	addiw	a5,a5,-1
    80004156:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000415a:	854a                	mv	a0,s2
    8000415c:	c36fe0ef          	jal	80002592 <iupdate>
  iunlockput(ip);
    80004160:	854a                	mv	a0,s2
    80004162:	eeefe0ef          	jal	80002850 <iunlockput>
  end_op();
    80004166:	de3fe0ef          	jal	80002f48 <end_op>
  return 0;
    8000416a:	4501                	li	a0,0
    8000416c:	64ee                	ld	s1,216(sp)
    8000416e:	694e                	ld	s2,208(sp)
    80004170:	a849                	j	80004202 <sys_unlink+0x16e>
    end_op();
    80004172:	dd7fe0ef          	jal	80002f48 <end_op>
    return -1;
    80004176:	557d                	li	a0,-1
    80004178:	64ee                	ld	s1,216(sp)
    8000417a:	a061                	j	80004202 <sys_unlink+0x16e>
    8000417c:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000417e:	00003517          	auipc	a0,0x3
    80004182:	45250513          	addi	a0,a0,1106 # 800075d0 <etext+0x5d0>
    80004186:	27c010ef          	jal	80005402 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000418a:	04c92703          	lw	a4,76(s2)
    8000418e:	02000793          	li	a5,32
    80004192:	f8e7f5e3          	bgeu	a5,a4,8000411c <sys_unlink+0x88>
    80004196:	e5ce                	sd	s3,200(sp)
    80004198:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000419c:	4741                	li	a4,16
    8000419e:	86ce                	mv	a3,s3
    800041a0:	f1840613          	addi	a2,s0,-232
    800041a4:	4581                	li	a1,0
    800041a6:	854a                	mv	a0,s2
    800041a8:	ef2fe0ef          	jal	8000289a <readi>
    800041ac:	47c1                	li	a5,16
    800041ae:	00f51c63          	bne	a0,a5,800041c6 <sys_unlink+0x132>
    if(de.inum != 0)
    800041b2:	f1845783          	lhu	a5,-232(s0)
    800041b6:	efa1                	bnez	a5,8000420e <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800041b8:	29c1                	addiw	s3,s3,16
    800041ba:	04c92783          	lw	a5,76(s2)
    800041be:	fcf9efe3          	bltu	s3,a5,8000419c <sys_unlink+0x108>
    800041c2:	69ae                	ld	s3,200(sp)
    800041c4:	bfa1                	j	8000411c <sys_unlink+0x88>
      panic("isdirempty: readi");
    800041c6:	00003517          	auipc	a0,0x3
    800041ca:	42250513          	addi	a0,a0,1058 # 800075e8 <etext+0x5e8>
    800041ce:	234010ef          	jal	80005402 <panic>
    800041d2:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800041d4:	00003517          	auipc	a0,0x3
    800041d8:	42c50513          	addi	a0,a0,1068 # 80007600 <etext+0x600>
    800041dc:	226010ef          	jal	80005402 <panic>
    dp->nlink--;
    800041e0:	04a4d783          	lhu	a5,74(s1)
    800041e4:	37fd                	addiw	a5,a5,-1
    800041e6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800041ea:	8526                	mv	a0,s1
    800041ec:	ba6fe0ef          	jal	80002592 <iupdate>
    800041f0:	bfa9                	j	8000414a <sys_unlink+0xb6>
    800041f2:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800041f4:	8526                	mv	a0,s1
    800041f6:	e5afe0ef          	jal	80002850 <iunlockput>
  end_op();
    800041fa:	d4ffe0ef          	jal	80002f48 <end_op>
  return -1;
    800041fe:	557d                	li	a0,-1
    80004200:	64ee                	ld	s1,216(sp)
}
    80004202:	70ae                	ld	ra,232(sp)
    80004204:	740e                	ld	s0,224(sp)
    80004206:	616d                	addi	sp,sp,240
    80004208:	8082                	ret
    return -1;
    8000420a:	557d                	li	a0,-1
    8000420c:	bfdd                	j	80004202 <sys_unlink+0x16e>
    iunlockput(ip);
    8000420e:	854a                	mv	a0,s2
    80004210:	e40fe0ef          	jal	80002850 <iunlockput>
    goto bad;
    80004214:	694e                	ld	s2,208(sp)
    80004216:	69ae                	ld	s3,200(sp)
    80004218:	bff1                	j	800041f4 <sys_unlink+0x160>

000000008000421a <sys_open>:

uint64
sys_open(void)
{
    8000421a:	7131                	addi	sp,sp,-192
    8000421c:	fd06                	sd	ra,184(sp)
    8000421e:	f922                	sd	s0,176(sp)
    80004220:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004222:	f4c40593          	addi	a1,s0,-180
    80004226:	4505                	li	a0,1
    80004228:	9f3fd0ef          	jal	80001c1a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000422c:	08000613          	li	a2,128
    80004230:	f5040593          	addi	a1,s0,-176
    80004234:	4501                	li	a0,0
    80004236:	a1dfd0ef          	jal	80001c52 <argstr>
    8000423a:	87aa                	mv	a5,a0
    return -1;
    8000423c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000423e:	0a07c263          	bltz	a5,800042e2 <sys_open+0xc8>
    80004242:	f526                	sd	s1,168(sp)

  begin_op();
    80004244:	c99fe0ef          	jal	80002edc <begin_op>

  if(omode & O_CREATE){
    80004248:	f4c42783          	lw	a5,-180(s0)
    8000424c:	2007f793          	andi	a5,a5,512
    80004250:	c3d5                	beqz	a5,800042f4 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004252:	4681                	li	a3,0
    80004254:	4601                	li	a2,0
    80004256:	4589                	li	a1,2
    80004258:	f5040513          	addi	a0,s0,-176
    8000425c:	aa9ff0ef          	jal	80003d04 <create>
    80004260:	84aa                	mv	s1,a0
    if(ip == 0){
    80004262:	c541                	beqz	a0,800042ea <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004264:	04449703          	lh	a4,68(s1)
    80004268:	478d                	li	a5,3
    8000426a:	00f71763          	bne	a4,a5,80004278 <sys_open+0x5e>
    8000426e:	0464d703          	lhu	a4,70(s1)
    80004272:	47a5                	li	a5,9
    80004274:	0ae7ed63          	bltu	a5,a4,8000432e <sys_open+0x114>
    80004278:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000427a:	fddfe0ef          	jal	80003256 <filealloc>
    8000427e:	892a                	mv	s2,a0
    80004280:	c179                	beqz	a0,80004346 <sys_open+0x12c>
    80004282:	ed4e                	sd	s3,152(sp)
    80004284:	a41ff0ef          	jal	80003cc4 <fdalloc>
    80004288:	89aa                	mv	s3,a0
    8000428a:	0a054a63          	bltz	a0,8000433e <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000428e:	04449703          	lh	a4,68(s1)
    80004292:	478d                	li	a5,3
    80004294:	0cf70263          	beq	a4,a5,80004358 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004298:	4789                	li	a5,2
    8000429a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000429e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800042a2:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800042a6:	f4c42783          	lw	a5,-180(s0)
    800042aa:	0017c713          	xori	a4,a5,1
    800042ae:	8b05                	andi	a4,a4,1
    800042b0:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800042b4:	0037f713          	andi	a4,a5,3
    800042b8:	00e03733          	snez	a4,a4
    800042bc:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800042c0:	4007f793          	andi	a5,a5,1024
    800042c4:	c791                	beqz	a5,800042d0 <sys_open+0xb6>
    800042c6:	04449703          	lh	a4,68(s1)
    800042ca:	4789                	li	a5,2
    800042cc:	08f70d63          	beq	a4,a5,80004366 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800042d0:	8526                	mv	a0,s1
    800042d2:	c22fe0ef          	jal	800026f4 <iunlock>
  end_op();
    800042d6:	c73fe0ef          	jal	80002f48 <end_op>

  return fd;
    800042da:	854e                	mv	a0,s3
    800042dc:	74aa                	ld	s1,168(sp)
    800042de:	790a                	ld	s2,160(sp)
    800042e0:	69ea                	ld	s3,152(sp)
}
    800042e2:	70ea                	ld	ra,184(sp)
    800042e4:	744a                	ld	s0,176(sp)
    800042e6:	6129                	addi	sp,sp,192
    800042e8:	8082                	ret
      end_op();
    800042ea:	c5ffe0ef          	jal	80002f48 <end_op>
      return -1;
    800042ee:	557d                	li	a0,-1
    800042f0:	74aa                	ld	s1,168(sp)
    800042f2:	bfc5                	j	800042e2 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800042f4:	f5040513          	addi	a0,s0,-176
    800042f8:	a29fe0ef          	jal	80002d20 <namei>
    800042fc:	84aa                	mv	s1,a0
    800042fe:	c11d                	beqz	a0,80004324 <sys_open+0x10a>
    ilock(ip);
    80004300:	b46fe0ef          	jal	80002646 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004304:	04449703          	lh	a4,68(s1)
    80004308:	4785                	li	a5,1
    8000430a:	f4f71de3          	bne	a4,a5,80004264 <sys_open+0x4a>
    8000430e:	f4c42783          	lw	a5,-180(s0)
    80004312:	d3bd                	beqz	a5,80004278 <sys_open+0x5e>
      iunlockput(ip);
    80004314:	8526                	mv	a0,s1
    80004316:	d3afe0ef          	jal	80002850 <iunlockput>
      end_op();
    8000431a:	c2ffe0ef          	jal	80002f48 <end_op>
      return -1;
    8000431e:	557d                	li	a0,-1
    80004320:	74aa                	ld	s1,168(sp)
    80004322:	b7c1                	j	800042e2 <sys_open+0xc8>
      end_op();
    80004324:	c25fe0ef          	jal	80002f48 <end_op>
      return -1;
    80004328:	557d                	li	a0,-1
    8000432a:	74aa                	ld	s1,168(sp)
    8000432c:	bf5d                	j	800042e2 <sys_open+0xc8>
    iunlockput(ip);
    8000432e:	8526                	mv	a0,s1
    80004330:	d20fe0ef          	jal	80002850 <iunlockput>
    end_op();
    80004334:	c15fe0ef          	jal	80002f48 <end_op>
    return -1;
    80004338:	557d                	li	a0,-1
    8000433a:	74aa                	ld	s1,168(sp)
    8000433c:	b75d                	j	800042e2 <sys_open+0xc8>
      fileclose(f);
    8000433e:	854a                	mv	a0,s2
    80004340:	fbbfe0ef          	jal	800032fa <fileclose>
    80004344:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004346:	8526                	mv	a0,s1
    80004348:	d08fe0ef          	jal	80002850 <iunlockput>
    end_op();
    8000434c:	bfdfe0ef          	jal	80002f48 <end_op>
    return -1;
    80004350:	557d                	li	a0,-1
    80004352:	74aa                	ld	s1,168(sp)
    80004354:	790a                	ld	s2,160(sp)
    80004356:	b771                	j	800042e2 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004358:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000435c:	04649783          	lh	a5,70(s1)
    80004360:	02f91223          	sh	a5,36(s2)
    80004364:	bf3d                	j	800042a2 <sys_open+0x88>
    itrunc(ip);
    80004366:	8526                	mv	a0,s1
    80004368:	bccfe0ef          	jal	80002734 <itrunc>
    8000436c:	b795                	j	800042d0 <sys_open+0xb6>

000000008000436e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000436e:	7175                	addi	sp,sp,-144
    80004370:	e506                	sd	ra,136(sp)
    80004372:	e122                	sd	s0,128(sp)
    80004374:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004376:	b67fe0ef          	jal	80002edc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000437a:	08000613          	li	a2,128
    8000437e:	f7040593          	addi	a1,s0,-144
    80004382:	4501                	li	a0,0
    80004384:	8cffd0ef          	jal	80001c52 <argstr>
    80004388:	02054363          	bltz	a0,800043ae <sys_mkdir+0x40>
    8000438c:	4681                	li	a3,0
    8000438e:	4601                	li	a2,0
    80004390:	4585                	li	a1,1
    80004392:	f7040513          	addi	a0,s0,-144
    80004396:	96fff0ef          	jal	80003d04 <create>
    8000439a:	c911                	beqz	a0,800043ae <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000439c:	cb4fe0ef          	jal	80002850 <iunlockput>
  end_op();
    800043a0:	ba9fe0ef          	jal	80002f48 <end_op>
  return 0;
    800043a4:	4501                	li	a0,0
}
    800043a6:	60aa                	ld	ra,136(sp)
    800043a8:	640a                	ld	s0,128(sp)
    800043aa:	6149                	addi	sp,sp,144
    800043ac:	8082                	ret
    end_op();
    800043ae:	b9bfe0ef          	jal	80002f48 <end_op>
    return -1;
    800043b2:	557d                	li	a0,-1
    800043b4:	bfcd                	j	800043a6 <sys_mkdir+0x38>

00000000800043b6 <sys_mknod>:

uint64
sys_mknod(void)
{
    800043b6:	7135                	addi	sp,sp,-160
    800043b8:	ed06                	sd	ra,152(sp)
    800043ba:	e922                	sd	s0,144(sp)
    800043bc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800043be:	b1ffe0ef          	jal	80002edc <begin_op>
  argint(1, &major);
    800043c2:	f6c40593          	addi	a1,s0,-148
    800043c6:	4505                	li	a0,1
    800043c8:	853fd0ef          	jal	80001c1a <argint>
  argint(2, &minor);
    800043cc:	f6840593          	addi	a1,s0,-152
    800043d0:	4509                	li	a0,2
    800043d2:	849fd0ef          	jal	80001c1a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043d6:	08000613          	li	a2,128
    800043da:	f7040593          	addi	a1,s0,-144
    800043de:	4501                	li	a0,0
    800043e0:	873fd0ef          	jal	80001c52 <argstr>
    800043e4:	02054563          	bltz	a0,8000440e <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800043e8:	f6841683          	lh	a3,-152(s0)
    800043ec:	f6c41603          	lh	a2,-148(s0)
    800043f0:	458d                	li	a1,3
    800043f2:	f7040513          	addi	a0,s0,-144
    800043f6:	90fff0ef          	jal	80003d04 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043fa:	c911                	beqz	a0,8000440e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800043fc:	c54fe0ef          	jal	80002850 <iunlockput>
  end_op();
    80004400:	b49fe0ef          	jal	80002f48 <end_op>
  return 0;
    80004404:	4501                	li	a0,0
}
    80004406:	60ea                	ld	ra,152(sp)
    80004408:	644a                	ld	s0,144(sp)
    8000440a:	610d                	addi	sp,sp,160
    8000440c:	8082                	ret
    end_op();
    8000440e:	b3bfe0ef          	jal	80002f48 <end_op>
    return -1;
    80004412:	557d                	li	a0,-1
    80004414:	bfcd                	j	80004406 <sys_mknod+0x50>

0000000080004416 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004416:	7135                	addi	sp,sp,-160
    80004418:	ed06                	sd	ra,152(sp)
    8000441a:	e922                	sd	s0,144(sp)
    8000441c:	e14a                	sd	s2,128(sp)
    8000441e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004420:	947fc0ef          	jal	80000d66 <myproc>
    80004424:	892a                	mv	s2,a0
  
  begin_op();
    80004426:	ab7fe0ef          	jal	80002edc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000442a:	08000613          	li	a2,128
    8000442e:	f6040593          	addi	a1,s0,-160
    80004432:	4501                	li	a0,0
    80004434:	81ffd0ef          	jal	80001c52 <argstr>
    80004438:	04054363          	bltz	a0,8000447e <sys_chdir+0x68>
    8000443c:	e526                	sd	s1,136(sp)
    8000443e:	f6040513          	addi	a0,s0,-160
    80004442:	8dffe0ef          	jal	80002d20 <namei>
    80004446:	84aa                	mv	s1,a0
    80004448:	c915                	beqz	a0,8000447c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000444a:	9fcfe0ef          	jal	80002646 <ilock>
  if(ip->type != T_DIR){
    8000444e:	04449703          	lh	a4,68(s1)
    80004452:	4785                	li	a5,1
    80004454:	02f71963          	bne	a4,a5,80004486 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004458:	8526                	mv	a0,s1
    8000445a:	a9afe0ef          	jal	800026f4 <iunlock>
  iput(p->cwd);
    8000445e:	2d093503          	ld	a0,720(s2)
    80004462:	b66fe0ef          	jal	800027c8 <iput>
  end_op();
    80004466:	ae3fe0ef          	jal	80002f48 <end_op>
  p->cwd = ip;
    8000446a:	2c993823          	sd	s1,720(s2)
  return 0;
    8000446e:	4501                	li	a0,0
    80004470:	64aa                	ld	s1,136(sp)
}
    80004472:	60ea                	ld	ra,152(sp)
    80004474:	644a                	ld	s0,144(sp)
    80004476:	690a                	ld	s2,128(sp)
    80004478:	610d                	addi	sp,sp,160
    8000447a:	8082                	ret
    8000447c:	64aa                	ld	s1,136(sp)
    end_op();
    8000447e:	acbfe0ef          	jal	80002f48 <end_op>
    return -1;
    80004482:	557d                	li	a0,-1
    80004484:	b7fd                	j	80004472 <sys_chdir+0x5c>
    iunlockput(ip);
    80004486:	8526                	mv	a0,s1
    80004488:	bc8fe0ef          	jal	80002850 <iunlockput>
    end_op();
    8000448c:	abdfe0ef          	jal	80002f48 <end_op>
    return -1;
    80004490:	557d                	li	a0,-1
    80004492:	64aa                	ld	s1,136(sp)
    80004494:	bff9                	j	80004472 <sys_chdir+0x5c>

0000000080004496 <sys_exec>:

uint64
sys_exec(void)
{
    80004496:	7121                	addi	sp,sp,-448
    80004498:	ff06                	sd	ra,440(sp)
    8000449a:	fb22                	sd	s0,432(sp)
    8000449c:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000449e:	e4840593          	addi	a1,s0,-440
    800044a2:	4505                	li	a0,1
    800044a4:	f92fd0ef          	jal	80001c36 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800044a8:	08000613          	li	a2,128
    800044ac:	f5040593          	addi	a1,s0,-176
    800044b0:	4501                	li	a0,0
    800044b2:	fa0fd0ef          	jal	80001c52 <argstr>
    800044b6:	87aa                	mv	a5,a0
    return -1;
    800044b8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800044ba:	0c07c463          	bltz	a5,80004582 <sys_exec+0xec>
    800044be:	f726                	sd	s1,424(sp)
    800044c0:	f34a                	sd	s2,416(sp)
    800044c2:	ef4e                	sd	s3,408(sp)
    800044c4:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800044c6:	10000613          	li	a2,256
    800044ca:	4581                	li	a1,0
    800044cc:	e5040513          	addi	a0,s0,-432
    800044d0:	c7ffb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800044d4:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800044d8:	89a6                	mv	s3,s1
    800044da:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800044dc:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800044e0:	00391513          	slli	a0,s2,0x3
    800044e4:	e4040593          	addi	a1,s0,-448
    800044e8:	e4843783          	ld	a5,-440(s0)
    800044ec:	953e                	add	a0,a0,a5
    800044ee:	ea2fd0ef          	jal	80001b90 <fetchaddr>
    800044f2:	02054663          	bltz	a0,8000451e <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800044f6:	e4043783          	ld	a5,-448(s0)
    800044fa:	c3a9                	beqz	a5,8000453c <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800044fc:	c03fb0ef          	jal	800000fe <kalloc>
    80004500:	85aa                	mv	a1,a0
    80004502:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004506:	cd01                	beqz	a0,8000451e <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004508:	6605                	lui	a2,0x1
    8000450a:	e4043503          	ld	a0,-448(s0)
    8000450e:	eccfd0ef          	jal	80001bda <fetchstr>
    80004512:	00054663          	bltz	a0,8000451e <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004516:	0905                	addi	s2,s2,1
    80004518:	09a1                	addi	s3,s3,8
    8000451a:	fd4913e3          	bne	s2,s4,800044e0 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000451e:	f5040913          	addi	s2,s0,-176
    80004522:	6088                	ld	a0,0(s1)
    80004524:	c931                	beqz	a0,80004578 <sys_exec+0xe2>
    kfree(argv[i]);
    80004526:	af7fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000452a:	04a1                	addi	s1,s1,8
    8000452c:	ff249be3          	bne	s1,s2,80004522 <sys_exec+0x8c>
  return -1;
    80004530:	557d                	li	a0,-1
    80004532:	74ba                	ld	s1,424(sp)
    80004534:	791a                	ld	s2,416(sp)
    80004536:	69fa                	ld	s3,408(sp)
    80004538:	6a5a                	ld	s4,400(sp)
    8000453a:	a0a1                	j	80004582 <sys_exec+0xec>
      argv[i] = 0;
    8000453c:	0009079b          	sext.w	a5,s2
    80004540:	078e                	slli	a5,a5,0x3
    80004542:	fd078793          	addi	a5,a5,-48
    80004546:	97a2                	add	a5,a5,s0
    80004548:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000454c:	e5040593          	addi	a1,s0,-432
    80004550:	f5040513          	addi	a0,s0,-176
    80004554:	ba4ff0ef          	jal	800038f8 <exec>
    80004558:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000455a:	f5040993          	addi	s3,s0,-176
    8000455e:	6088                	ld	a0,0(s1)
    80004560:	c511                	beqz	a0,8000456c <sys_exec+0xd6>
    kfree(argv[i]);
    80004562:	abbfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004566:	04a1                	addi	s1,s1,8
    80004568:	ff349be3          	bne	s1,s3,8000455e <sys_exec+0xc8>
  return ret;
    8000456c:	854a                	mv	a0,s2
    8000456e:	74ba                	ld	s1,424(sp)
    80004570:	791a                	ld	s2,416(sp)
    80004572:	69fa                	ld	s3,408(sp)
    80004574:	6a5a                	ld	s4,400(sp)
    80004576:	a031                	j	80004582 <sys_exec+0xec>
  return -1;
    80004578:	557d                	li	a0,-1
    8000457a:	74ba                	ld	s1,424(sp)
    8000457c:	791a                	ld	s2,416(sp)
    8000457e:	69fa                	ld	s3,408(sp)
    80004580:	6a5a                	ld	s4,400(sp)
}
    80004582:	70fa                	ld	ra,440(sp)
    80004584:	745a                	ld	s0,432(sp)
    80004586:	6139                	addi	sp,sp,448
    80004588:	8082                	ret

000000008000458a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000458a:	7139                	addi	sp,sp,-64
    8000458c:	fc06                	sd	ra,56(sp)
    8000458e:	f822                	sd	s0,48(sp)
    80004590:	f426                	sd	s1,40(sp)
    80004592:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004594:	fd2fc0ef          	jal	80000d66 <myproc>
    80004598:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000459a:	fd840593          	addi	a1,s0,-40
    8000459e:	4501                	li	a0,0
    800045a0:	e96fd0ef          	jal	80001c36 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800045a4:	fc840593          	addi	a1,s0,-56
    800045a8:	fd040513          	addi	a0,s0,-48
    800045ac:	858ff0ef          	jal	80003604 <pipealloc>
    return -1;
    800045b0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800045b2:	0a054463          	bltz	a0,8000465a <sys_pipe+0xd0>
  fd0 = -1;
    800045b6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800045ba:	fd043503          	ld	a0,-48(s0)
    800045be:	f06ff0ef          	jal	80003cc4 <fdalloc>
    800045c2:	fca42223          	sw	a0,-60(s0)
    800045c6:	08054163          	bltz	a0,80004648 <sys_pipe+0xbe>
    800045ca:	fc843503          	ld	a0,-56(s0)
    800045ce:	ef6ff0ef          	jal	80003cc4 <fdalloc>
    800045d2:	fca42023          	sw	a0,-64(s0)
    800045d6:	06054063          	bltz	a0,80004636 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800045da:	4691                	li	a3,4
    800045dc:	fc440613          	addi	a2,s0,-60
    800045e0:	fd843583          	ld	a1,-40(s0)
    800045e4:	68a8                	ld	a0,80(s1)
    800045e6:	bf2fc0ef          	jal	800009d8 <copyout>
    800045ea:	00054e63          	bltz	a0,80004606 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800045ee:	4691                	li	a3,4
    800045f0:	fc040613          	addi	a2,s0,-64
    800045f4:	fd843583          	ld	a1,-40(s0)
    800045f8:	0591                	addi	a1,a1,4
    800045fa:	68a8                	ld	a0,80(s1)
    800045fc:	bdcfc0ef          	jal	800009d8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004600:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004602:	04055c63          	bgez	a0,8000465a <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004606:	fc442783          	lw	a5,-60(s0)
    8000460a:	07e9                	addi	a5,a5,26
    8000460c:	078e                	slli	a5,a5,0x3
    8000460e:	97a6                	add	a5,a5,s1
    80004610:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004614:	fc042783          	lw	a5,-64(s0)
    80004618:	07e9                	addi	a5,a5,26
    8000461a:	078e                	slli	a5,a5,0x3
    8000461c:	94be                	add	s1,s1,a5
    8000461e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004622:	fd043503          	ld	a0,-48(s0)
    80004626:	cd5fe0ef          	jal	800032fa <fileclose>
    fileclose(wf);
    8000462a:	fc843503          	ld	a0,-56(s0)
    8000462e:	ccdfe0ef          	jal	800032fa <fileclose>
    return -1;
    80004632:	57fd                	li	a5,-1
    80004634:	a01d                	j	8000465a <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004636:	fc442783          	lw	a5,-60(s0)
    8000463a:	0007c763          	bltz	a5,80004648 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000463e:	07e9                	addi	a5,a5,26
    80004640:	078e                	slli	a5,a5,0x3
    80004642:	97a6                	add	a5,a5,s1
    80004644:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004648:	fd043503          	ld	a0,-48(s0)
    8000464c:	caffe0ef          	jal	800032fa <fileclose>
    fileclose(wf);
    80004650:	fc843503          	ld	a0,-56(s0)
    80004654:	ca7fe0ef          	jal	800032fa <fileclose>
    return -1;
    80004658:	57fd                	li	a5,-1
}
    8000465a:	853e                	mv	a0,a5
    8000465c:	70e2                	ld	ra,56(sp)
    8000465e:	7442                	ld	s0,48(sp)
    80004660:	74a2                	ld	s1,40(sp)
    80004662:	6121                	addi	sp,sp,64
    80004664:	8082                	ret
	...

0000000080004670 <kernelvec>:
    80004670:	7111                	addi	sp,sp,-256
    80004672:	e006                	sd	ra,0(sp)
    80004674:	e40a                	sd	sp,8(sp)
    80004676:	e80e                	sd	gp,16(sp)
    80004678:	ec12                	sd	tp,24(sp)
    8000467a:	f016                	sd	t0,32(sp)
    8000467c:	f41a                	sd	t1,40(sp)
    8000467e:	f81e                	sd	t2,48(sp)
    80004680:	e4aa                	sd	a0,72(sp)
    80004682:	e8ae                	sd	a1,80(sp)
    80004684:	ecb2                	sd	a2,88(sp)
    80004686:	f0b6                	sd	a3,96(sp)
    80004688:	f4ba                	sd	a4,104(sp)
    8000468a:	f8be                	sd	a5,112(sp)
    8000468c:	fcc2                	sd	a6,120(sp)
    8000468e:	e146                	sd	a7,128(sp)
    80004690:	edf2                	sd	t3,216(sp)
    80004692:	f1f6                	sd	t4,224(sp)
    80004694:	f5fa                	sd	t5,232(sp)
    80004696:	f9fe                	sd	t6,240(sp)
    80004698:	c08fd0ef          	jal	80001aa0 <kerneltrap>
    8000469c:	6082                	ld	ra,0(sp)
    8000469e:	6122                	ld	sp,8(sp)
    800046a0:	61c2                	ld	gp,16(sp)
    800046a2:	7282                	ld	t0,32(sp)
    800046a4:	7322                	ld	t1,40(sp)
    800046a6:	73c2                	ld	t2,48(sp)
    800046a8:	6526                	ld	a0,72(sp)
    800046aa:	65c6                	ld	a1,80(sp)
    800046ac:	6666                	ld	a2,88(sp)
    800046ae:	7686                	ld	a3,96(sp)
    800046b0:	7726                	ld	a4,104(sp)
    800046b2:	77c6                	ld	a5,112(sp)
    800046b4:	7866                	ld	a6,120(sp)
    800046b6:	688a                	ld	a7,128(sp)
    800046b8:	6e6e                	ld	t3,216(sp)
    800046ba:	7e8e                	ld	t4,224(sp)
    800046bc:	7f2e                	ld	t5,232(sp)
    800046be:	7fce                	ld	t6,240(sp)
    800046c0:	6111                	addi	sp,sp,256
    800046c2:	10200073          	sret
	...

00000000800046ce <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800046ce:	1141                	addi	sp,sp,-16
    800046d0:	e422                	sd	s0,8(sp)
    800046d2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800046d4:	0c0007b7          	lui	a5,0xc000
    800046d8:	4705                	li	a4,1
    800046da:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800046dc:	0c0007b7          	lui	a5,0xc000
    800046e0:	c3d8                	sw	a4,4(a5)
}
    800046e2:	6422                	ld	s0,8(sp)
    800046e4:	0141                	addi	sp,sp,16
    800046e6:	8082                	ret

00000000800046e8 <plicinithart>:

void
plicinithart(void)
{
    800046e8:	1141                	addi	sp,sp,-16
    800046ea:	e406                	sd	ra,8(sp)
    800046ec:	e022                	sd	s0,0(sp)
    800046ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800046f0:	e4afc0ef          	jal	80000d3a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800046f4:	0085171b          	slliw	a4,a0,0x8
    800046f8:	0c0027b7          	lui	a5,0xc002
    800046fc:	97ba                	add	a5,a5,a4
    800046fe:	40200713          	li	a4,1026
    80004702:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004706:	00d5151b          	slliw	a0,a0,0xd
    8000470a:	0c2017b7          	lui	a5,0xc201
    8000470e:	97aa                	add	a5,a5,a0
    80004710:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004714:	60a2                	ld	ra,8(sp)
    80004716:	6402                	ld	s0,0(sp)
    80004718:	0141                	addi	sp,sp,16
    8000471a:	8082                	ret

000000008000471c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000471c:	1141                	addi	sp,sp,-16
    8000471e:	e406                	sd	ra,8(sp)
    80004720:	e022                	sd	s0,0(sp)
    80004722:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004724:	e16fc0ef          	jal	80000d3a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004728:	00d5151b          	slliw	a0,a0,0xd
    8000472c:	0c2017b7          	lui	a5,0xc201
    80004730:	97aa                	add	a5,a5,a0
  return irq;
}
    80004732:	43c8                	lw	a0,4(a5)
    80004734:	60a2                	ld	ra,8(sp)
    80004736:	6402                	ld	s0,0(sp)
    80004738:	0141                	addi	sp,sp,16
    8000473a:	8082                	ret

000000008000473c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000473c:	1101                	addi	sp,sp,-32
    8000473e:	ec06                	sd	ra,24(sp)
    80004740:	e822                	sd	s0,16(sp)
    80004742:	e426                	sd	s1,8(sp)
    80004744:	1000                	addi	s0,sp,32
    80004746:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004748:	df2fc0ef          	jal	80000d3a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000474c:	00d5151b          	slliw	a0,a0,0xd
    80004750:	0c2017b7          	lui	a5,0xc201
    80004754:	97aa                	add	a5,a5,a0
    80004756:	c3c4                	sw	s1,4(a5)
}
    80004758:	60e2                	ld	ra,24(sp)
    8000475a:	6442                	ld	s0,16(sp)
    8000475c:	64a2                	ld	s1,8(sp)
    8000475e:	6105                	addi	sp,sp,32
    80004760:	8082                	ret

0000000080004762 <free_desc>:
    80004762:	1141                	addi	sp,sp,-16
    80004764:	e406                	sd	ra,8(sp)
    80004766:	e022                	sd	s0,0(sp)
    80004768:	0800                	addi	s0,sp,16
    8000476a:	479d                	li	a5,7
    8000476c:	04a7ca63          	blt	a5,a0,800047c0 <free_desc+0x5e>
    80004770:	00025797          	auipc	a5,0x25
    80004774:	e5878793          	addi	a5,a5,-424 # 800295c8 <disk>
    80004778:	97aa                	add	a5,a5,a0
    8000477a:	0187c783          	lbu	a5,24(a5)
    8000477e:	e7b9                	bnez	a5,800047cc <free_desc+0x6a>
    80004780:	00451693          	slli	a3,a0,0x4
    80004784:	00025797          	auipc	a5,0x25
    80004788:	e4478793          	addi	a5,a5,-444 # 800295c8 <disk>
    8000478c:	6398                	ld	a4,0(a5)
    8000478e:	9736                	add	a4,a4,a3
    80004790:	00073023          	sd	zero,0(a4)
    80004794:	6398                	ld	a4,0(a5)
    80004796:	9736                	add	a4,a4,a3
    80004798:	00072423          	sw	zero,8(a4)
    8000479c:	00071623          	sh	zero,12(a4)
    800047a0:	00071723          	sh	zero,14(a4)
    800047a4:	97aa                	add	a5,a5,a0
    800047a6:	4705                	li	a4,1
    800047a8:	00e78c23          	sb	a4,24(a5)
    800047ac:	00025517          	auipc	a0,0x25
    800047b0:	e3450513          	addi	a0,a0,-460 # 800295e0 <disk+0x18>
    800047b4:	bcdfc0ef          	jal	80001380 <wakeup>
    800047b8:	60a2                	ld	ra,8(sp)
    800047ba:	6402                	ld	s0,0(sp)
    800047bc:	0141                	addi	sp,sp,16
    800047be:	8082                	ret
    800047c0:	00003517          	auipc	a0,0x3
    800047c4:	e5050513          	addi	a0,a0,-432 # 80007610 <etext+0x610>
    800047c8:	43b000ef          	jal	80005402 <panic>
    800047cc:	00003517          	auipc	a0,0x3
    800047d0:	e5450513          	addi	a0,a0,-428 # 80007620 <etext+0x620>
    800047d4:	42f000ef          	jal	80005402 <panic>

00000000800047d8 <virtio_disk_init>:
    800047d8:	1101                	addi	sp,sp,-32
    800047da:	ec06                	sd	ra,24(sp)
    800047dc:	e822                	sd	s0,16(sp)
    800047de:	e426                	sd	s1,8(sp)
    800047e0:	e04a                	sd	s2,0(sp)
    800047e2:	1000                	addi	s0,sp,32
    800047e4:	00003597          	auipc	a1,0x3
    800047e8:	e4c58593          	addi	a1,a1,-436 # 80007630 <etext+0x630>
    800047ec:	00025517          	auipc	a0,0x25
    800047f0:	f0450513          	addi	a0,a0,-252 # 800296f0 <disk+0x128>
    800047f4:	6bd000ef          	jal	800056b0 <initlock>
    800047f8:	100017b7          	lui	a5,0x10001
    800047fc:	4398                	lw	a4,0(a5)
    800047fe:	2701                	sext.w	a4,a4
    80004800:	747277b7          	lui	a5,0x74727
    80004804:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004808:	18f71063          	bne	a4,a5,80004988 <virtio_disk_init+0x1b0>
    8000480c:	100017b7          	lui	a5,0x10001
    80004810:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004812:	439c                	lw	a5,0(a5)
    80004814:	2781                	sext.w	a5,a5
    80004816:	4709                	li	a4,2
    80004818:	16e79863          	bne	a5,a4,80004988 <virtio_disk_init+0x1b0>
    8000481c:	100017b7          	lui	a5,0x10001
    80004820:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004822:	439c                	lw	a5,0(a5)
    80004824:	2781                	sext.w	a5,a5
    80004826:	16e79163          	bne	a5,a4,80004988 <virtio_disk_init+0x1b0>
    8000482a:	100017b7          	lui	a5,0x10001
    8000482e:	47d8                	lw	a4,12(a5)
    80004830:	2701                	sext.w	a4,a4
    80004832:	554d47b7          	lui	a5,0x554d4
    80004836:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000483a:	14f71763          	bne	a4,a5,80004988 <virtio_disk_init+0x1b0>
    8000483e:	100017b7          	lui	a5,0x10001
    80004842:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
    80004846:	4705                	li	a4,1
    80004848:	dbb8                	sw	a4,112(a5)
    8000484a:	470d                	li	a4,3
    8000484c:	dbb8                	sw	a4,112(a5)
    8000484e:	10001737          	lui	a4,0x10001
    80004852:	4b14                	lw	a3,16(a4)
    80004854:	c7ffe737          	lui	a4,0xc7ffe
    80004858:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fccf4f>
    8000485c:	8ef9                	and	a3,a3,a4
    8000485e:	10001737          	lui	a4,0x10001
    80004862:	d314                	sw	a3,32(a4)
    80004864:	472d                	li	a4,11
    80004866:	dbb8                	sw	a4,112(a5)
    80004868:	07078793          	addi	a5,a5,112
    8000486c:	439c                	lw	a5,0(a5)
    8000486e:	0007891b          	sext.w	s2,a5
    80004872:	8ba1                	andi	a5,a5,8
    80004874:	12078063          	beqz	a5,80004994 <virtio_disk_init+0x1bc>
    80004878:	100017b7          	lui	a5,0x10001
    8000487c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    80004880:	100017b7          	lui	a5,0x10001
    80004884:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004888:	439c                	lw	a5,0(a5)
    8000488a:	2781                	sext.w	a5,a5
    8000488c:	10079a63          	bnez	a5,800049a0 <virtio_disk_init+0x1c8>
    80004890:	100017b7          	lui	a5,0x10001
    80004894:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004898:	439c                	lw	a5,0(a5)
    8000489a:	2781                	sext.w	a5,a5
    8000489c:	10078863          	beqz	a5,800049ac <virtio_disk_init+0x1d4>
    800048a0:	471d                	li	a4,7
    800048a2:	10f77b63          	bgeu	a4,a5,800049b8 <virtio_disk_init+0x1e0>
    800048a6:	859fb0ef          	jal	800000fe <kalloc>
    800048aa:	00025497          	auipc	s1,0x25
    800048ae:	d1e48493          	addi	s1,s1,-738 # 800295c8 <disk>
    800048b2:	e088                	sd	a0,0(s1)
    800048b4:	84bfb0ef          	jal	800000fe <kalloc>
    800048b8:	e488                	sd	a0,8(s1)
    800048ba:	845fb0ef          	jal	800000fe <kalloc>
    800048be:	87aa                	mv	a5,a0
    800048c0:	e888                	sd	a0,16(s1)
    800048c2:	6088                	ld	a0,0(s1)
    800048c4:	10050063          	beqz	a0,800049c4 <virtio_disk_init+0x1ec>
    800048c8:	00025717          	auipc	a4,0x25
    800048cc:	d0873703          	ld	a4,-760(a4) # 800295d0 <disk+0x8>
    800048d0:	0e070a63          	beqz	a4,800049c4 <virtio_disk_init+0x1ec>
    800048d4:	0e078863          	beqz	a5,800049c4 <virtio_disk_init+0x1ec>
    800048d8:	6605                	lui	a2,0x1
    800048da:	4581                	li	a1,0
    800048dc:	873fb0ef          	jal	8000014e <memset>
    800048e0:	00025497          	auipc	s1,0x25
    800048e4:	ce848493          	addi	s1,s1,-792 # 800295c8 <disk>
    800048e8:	6605                	lui	a2,0x1
    800048ea:	4581                	li	a1,0
    800048ec:	6488                	ld	a0,8(s1)
    800048ee:	861fb0ef          	jal	8000014e <memset>
    800048f2:	6605                	lui	a2,0x1
    800048f4:	4581                	li	a1,0
    800048f6:	6888                	ld	a0,16(s1)
    800048f8:	857fb0ef          	jal	8000014e <memset>
    800048fc:	100017b7          	lui	a5,0x10001
    80004900:	4721                	li	a4,8
    80004902:	df98                	sw	a4,56(a5)
    80004904:	4098                	lw	a4,0(s1)
    80004906:	100017b7          	lui	a5,0x10001
    8000490a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
    8000490e:	40d8                	lw	a4,4(s1)
    80004910:	100017b7          	lui	a5,0x10001
    80004914:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
    80004918:	649c                	ld	a5,8(s1)
    8000491a:	0007869b          	sext.w	a3,a5
    8000491e:	10001737          	lui	a4,0x10001
    80004922:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
    80004926:	9781                	srai	a5,a5,0x20
    80004928:	10001737          	lui	a4,0x10001
    8000492c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
    80004930:	689c                	ld	a5,16(s1)
    80004932:	0007869b          	sext.w	a3,a5
    80004936:	10001737          	lui	a4,0x10001
    8000493a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
    8000493e:	9781                	srai	a5,a5,0x20
    80004940:	10001737          	lui	a4,0x10001
    80004944:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
    80004948:	10001737          	lui	a4,0x10001
    8000494c:	4785                	li	a5,1
    8000494e:	c37c                	sw	a5,68(a4)
    80004950:	00f48c23          	sb	a5,24(s1)
    80004954:	00f48ca3          	sb	a5,25(s1)
    80004958:	00f48d23          	sb	a5,26(s1)
    8000495c:	00f48da3          	sb	a5,27(s1)
    80004960:	00f48e23          	sb	a5,28(s1)
    80004964:	00f48ea3          	sb	a5,29(s1)
    80004968:	00f48f23          	sb	a5,30(s1)
    8000496c:	00f48fa3          	sb	a5,31(s1)
    80004970:	00496913          	ori	s2,s2,4
    80004974:	100017b7          	lui	a5,0x10001
    80004978:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
    8000497c:	60e2                	ld	ra,24(sp)
    8000497e:	6442                	ld	s0,16(sp)
    80004980:	64a2                	ld	s1,8(sp)
    80004982:	6902                	ld	s2,0(sp)
    80004984:	6105                	addi	sp,sp,32
    80004986:	8082                	ret
    80004988:	00003517          	auipc	a0,0x3
    8000498c:	cb850513          	addi	a0,a0,-840 # 80007640 <etext+0x640>
    80004990:	273000ef          	jal	80005402 <panic>
    80004994:	00003517          	auipc	a0,0x3
    80004998:	ccc50513          	addi	a0,a0,-820 # 80007660 <etext+0x660>
    8000499c:	267000ef          	jal	80005402 <panic>
    800049a0:	00003517          	auipc	a0,0x3
    800049a4:	ce050513          	addi	a0,a0,-800 # 80007680 <etext+0x680>
    800049a8:	25b000ef          	jal	80005402 <panic>
    800049ac:	00003517          	auipc	a0,0x3
    800049b0:	cf450513          	addi	a0,a0,-780 # 800076a0 <etext+0x6a0>
    800049b4:	24f000ef          	jal	80005402 <panic>
    800049b8:	00003517          	auipc	a0,0x3
    800049bc:	d0850513          	addi	a0,a0,-760 # 800076c0 <etext+0x6c0>
    800049c0:	243000ef          	jal	80005402 <panic>
    800049c4:	00003517          	auipc	a0,0x3
    800049c8:	d1c50513          	addi	a0,a0,-740 # 800076e0 <etext+0x6e0>
    800049cc:	237000ef          	jal	80005402 <panic>

00000000800049d0 <virtio_disk_rw>:
    800049d0:	7159                	addi	sp,sp,-112
    800049d2:	f486                	sd	ra,104(sp)
    800049d4:	f0a2                	sd	s0,96(sp)
    800049d6:	eca6                	sd	s1,88(sp)
    800049d8:	e8ca                	sd	s2,80(sp)
    800049da:	e4ce                	sd	s3,72(sp)
    800049dc:	e0d2                	sd	s4,64(sp)
    800049de:	fc56                	sd	s5,56(sp)
    800049e0:	f85a                	sd	s6,48(sp)
    800049e2:	f45e                	sd	s7,40(sp)
    800049e4:	f062                	sd	s8,32(sp)
    800049e6:	ec66                	sd	s9,24(sp)
    800049e8:	1880                	addi	s0,sp,112
    800049ea:	8a2a                	mv	s4,a0
    800049ec:	8bae                	mv	s7,a1
    800049ee:	00c52c83          	lw	s9,12(a0)
    800049f2:	001c9c9b          	slliw	s9,s9,0x1
    800049f6:	1c82                	slli	s9,s9,0x20
    800049f8:	020cdc93          	srli	s9,s9,0x20
    800049fc:	00025517          	auipc	a0,0x25
    80004a00:	cf450513          	addi	a0,a0,-780 # 800296f0 <disk+0x128>
    80004a04:	52d000ef          	jal	80005730 <acquire>
    80004a08:	4981                	li	s3,0
    80004a0a:	44a1                	li	s1,8
    80004a0c:	00025b17          	auipc	s6,0x25
    80004a10:	bbcb0b13          	addi	s6,s6,-1092 # 800295c8 <disk>
    80004a14:	4a8d                	li	s5,3
    80004a16:	00025c17          	auipc	s8,0x25
    80004a1a:	cdac0c13          	addi	s8,s8,-806 # 800296f0 <disk+0x128>
    80004a1e:	a8b9                	j	80004a7c <virtio_disk_rw+0xac>
    80004a20:	00fb0733          	add	a4,s6,a5
    80004a24:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    80004a28:	c19c                	sw	a5,0(a1)
    80004a2a:	0207c563          	bltz	a5,80004a54 <virtio_disk_rw+0x84>
    80004a2e:	2905                	addiw	s2,s2,1
    80004a30:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004a32:	05590963          	beq	s2,s5,80004a84 <virtio_disk_rw+0xb4>
    80004a36:	85b2                	mv	a1,a2
    80004a38:	00025717          	auipc	a4,0x25
    80004a3c:	b9070713          	addi	a4,a4,-1136 # 800295c8 <disk>
    80004a40:	87ce                	mv	a5,s3
    80004a42:	01874683          	lbu	a3,24(a4)
    80004a46:	fee9                	bnez	a3,80004a20 <virtio_disk_rw+0x50>
    80004a48:	2785                	addiw	a5,a5,1
    80004a4a:	0705                	addi	a4,a4,1
    80004a4c:	fe979be3          	bne	a5,s1,80004a42 <virtio_disk_rw+0x72>
    80004a50:	57fd                	li	a5,-1
    80004a52:	c19c                	sw	a5,0(a1)
    80004a54:	01205d63          	blez	s2,80004a6e <virtio_disk_rw+0x9e>
    80004a58:	f9042503          	lw	a0,-112(s0)
    80004a5c:	d07ff0ef          	jal	80004762 <free_desc>
    80004a60:	4785                	li	a5,1
    80004a62:	0127d663          	bge	a5,s2,80004a6e <virtio_disk_rw+0x9e>
    80004a66:	f9442503          	lw	a0,-108(s0)
    80004a6a:	cf9ff0ef          	jal	80004762 <free_desc>
    80004a6e:	85e2                	mv	a1,s8
    80004a70:	00025517          	auipc	a0,0x25
    80004a74:	b7050513          	addi	a0,a0,-1168 # 800295e0 <disk+0x18>
    80004a78:	8bdfc0ef          	jal	80001334 <sleep>
    80004a7c:	f9040613          	addi	a2,s0,-112
    80004a80:	894e                	mv	s2,s3
    80004a82:	bf55                	j	80004a36 <virtio_disk_rw+0x66>
    80004a84:	f9042503          	lw	a0,-112(s0)
    80004a88:	00451693          	slli	a3,a0,0x4
    80004a8c:	00025797          	auipc	a5,0x25
    80004a90:	b3c78793          	addi	a5,a5,-1220 # 800295c8 <disk>
    80004a94:	00a50713          	addi	a4,a0,10
    80004a98:	0712                	slli	a4,a4,0x4
    80004a9a:	973e                	add	a4,a4,a5
    80004a9c:	01703633          	snez	a2,s7
    80004aa0:	c710                	sw	a2,8(a4)
    80004aa2:	00072623          	sw	zero,12(a4)
    80004aa6:	01973823          	sd	s9,16(a4)
    80004aaa:	6398                	ld	a4,0(a5)
    80004aac:	9736                	add	a4,a4,a3
    80004aae:	0a868613          	addi	a2,a3,168
    80004ab2:	963e                	add	a2,a2,a5
    80004ab4:	e310                	sd	a2,0(a4)
    80004ab6:	6390                	ld	a2,0(a5)
    80004ab8:	00d605b3          	add	a1,a2,a3
    80004abc:	4741                	li	a4,16
    80004abe:	c598                	sw	a4,8(a1)
    80004ac0:	4805                	li	a6,1
    80004ac2:	01059623          	sh	a6,12(a1)
    80004ac6:	f9442703          	lw	a4,-108(s0)
    80004aca:	00e59723          	sh	a4,14(a1)
    80004ace:	0712                	slli	a4,a4,0x4
    80004ad0:	963a                	add	a2,a2,a4
    80004ad2:	058a0593          	addi	a1,s4,88
    80004ad6:	e20c                	sd	a1,0(a2)
    80004ad8:	0007b883          	ld	a7,0(a5)
    80004adc:	9746                	add	a4,a4,a7
    80004ade:	40000613          	li	a2,1024
    80004ae2:	c710                	sw	a2,8(a4)
    80004ae4:	001bb613          	seqz	a2,s7
    80004ae8:	0016161b          	slliw	a2,a2,0x1
    80004aec:	00166613          	ori	a2,a2,1
    80004af0:	00c71623          	sh	a2,12(a4)
    80004af4:	f9842583          	lw	a1,-104(s0)
    80004af8:	00b71723          	sh	a1,14(a4)
    80004afc:	00250613          	addi	a2,a0,2
    80004b00:	0612                	slli	a2,a2,0x4
    80004b02:	963e                	add	a2,a2,a5
    80004b04:	577d                	li	a4,-1
    80004b06:	00e60823          	sb	a4,16(a2)
    80004b0a:	0592                	slli	a1,a1,0x4
    80004b0c:	98ae                	add	a7,a7,a1
    80004b0e:	03068713          	addi	a4,a3,48
    80004b12:	973e                	add	a4,a4,a5
    80004b14:	00e8b023          	sd	a4,0(a7)
    80004b18:	6398                	ld	a4,0(a5)
    80004b1a:	972e                	add	a4,a4,a1
    80004b1c:	01072423          	sw	a6,8(a4)
    80004b20:	4689                	li	a3,2
    80004b22:	00d71623          	sh	a3,12(a4)
    80004b26:	00071723          	sh	zero,14(a4)
    80004b2a:	010a2223          	sw	a6,4(s4)
    80004b2e:	01463423          	sd	s4,8(a2)
    80004b32:	6794                	ld	a3,8(a5)
    80004b34:	0026d703          	lhu	a4,2(a3)
    80004b38:	8b1d                	andi	a4,a4,7
    80004b3a:	0706                	slli	a4,a4,0x1
    80004b3c:	96ba                	add	a3,a3,a4
    80004b3e:	00a69223          	sh	a0,4(a3)
    80004b42:	0330000f          	fence	rw,rw
    80004b46:	6798                	ld	a4,8(a5)
    80004b48:	00275783          	lhu	a5,2(a4)
    80004b4c:	2785                	addiw	a5,a5,1
    80004b4e:	00f71123          	sh	a5,2(a4)
    80004b52:	0330000f          	fence	rw,rw
    80004b56:	100017b7          	lui	a5,0x10001
    80004b5a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>
    80004b5e:	004a2783          	lw	a5,4(s4)
    80004b62:	00025917          	auipc	s2,0x25
    80004b66:	b8e90913          	addi	s2,s2,-1138 # 800296f0 <disk+0x128>
    80004b6a:	4485                	li	s1,1
    80004b6c:	01079a63          	bne	a5,a6,80004b80 <virtio_disk_rw+0x1b0>
    80004b70:	85ca                	mv	a1,s2
    80004b72:	8552                	mv	a0,s4
    80004b74:	fc0fc0ef          	jal	80001334 <sleep>
    80004b78:	004a2783          	lw	a5,4(s4)
    80004b7c:	fe978ae3          	beq	a5,s1,80004b70 <virtio_disk_rw+0x1a0>
    80004b80:	f9042903          	lw	s2,-112(s0)
    80004b84:	00290713          	addi	a4,s2,2
    80004b88:	0712                	slli	a4,a4,0x4
    80004b8a:	00025797          	auipc	a5,0x25
    80004b8e:	a3e78793          	addi	a5,a5,-1474 # 800295c8 <disk>
    80004b92:	97ba                	add	a5,a5,a4
    80004b94:	0007b423          	sd	zero,8(a5)
    80004b98:	00025997          	auipc	s3,0x25
    80004b9c:	a3098993          	addi	s3,s3,-1488 # 800295c8 <disk>
    80004ba0:	00491713          	slli	a4,s2,0x4
    80004ba4:	0009b783          	ld	a5,0(s3)
    80004ba8:	97ba                	add	a5,a5,a4
    80004baa:	00c7d483          	lhu	s1,12(a5)
    80004bae:	854a                	mv	a0,s2
    80004bb0:	00e7d903          	lhu	s2,14(a5)
    80004bb4:	bafff0ef          	jal	80004762 <free_desc>
    80004bb8:	8885                	andi	s1,s1,1
    80004bba:	f0fd                	bnez	s1,80004ba0 <virtio_disk_rw+0x1d0>
    80004bbc:	00025517          	auipc	a0,0x25
    80004bc0:	b3450513          	addi	a0,a0,-1228 # 800296f0 <disk+0x128>
    80004bc4:	405000ef          	jal	800057c8 <release>
    80004bc8:	70a6                	ld	ra,104(sp)
    80004bca:	7406                	ld	s0,96(sp)
    80004bcc:	64e6                	ld	s1,88(sp)
    80004bce:	6946                	ld	s2,80(sp)
    80004bd0:	69a6                	ld	s3,72(sp)
    80004bd2:	6a06                	ld	s4,64(sp)
    80004bd4:	7ae2                	ld	s5,56(sp)
    80004bd6:	7b42                	ld	s6,48(sp)
    80004bd8:	7ba2                	ld	s7,40(sp)
    80004bda:	7c02                	ld	s8,32(sp)
    80004bdc:	6ce2                	ld	s9,24(sp)
    80004bde:	6165                	addi	sp,sp,112
    80004be0:	8082                	ret

0000000080004be2 <virtio_disk_intr>:
    80004be2:	1101                	addi	sp,sp,-32
    80004be4:	ec06                	sd	ra,24(sp)
    80004be6:	e822                	sd	s0,16(sp)
    80004be8:	e426                	sd	s1,8(sp)
    80004bea:	1000                	addi	s0,sp,32
    80004bec:	00025497          	auipc	s1,0x25
    80004bf0:	9dc48493          	addi	s1,s1,-1572 # 800295c8 <disk>
    80004bf4:	00025517          	auipc	a0,0x25
    80004bf8:	afc50513          	addi	a0,a0,-1284 # 800296f0 <disk+0x128>
    80004bfc:	335000ef          	jal	80005730 <acquire>
    80004c00:	100017b7          	lui	a5,0x10001
    80004c04:	53b8                	lw	a4,96(a5)
    80004c06:	8b0d                	andi	a4,a4,3
    80004c08:	100017b7          	lui	a5,0x10001
    80004c0c:	d3f8                	sw	a4,100(a5)
    80004c0e:	0330000f          	fence	rw,rw
    80004c12:	689c                	ld	a5,16(s1)
    80004c14:	0204d703          	lhu	a4,32(s1)
    80004c18:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004c1c:	04f70663          	beq	a4,a5,80004c68 <virtio_disk_intr+0x86>
    80004c20:	0330000f          	fence	rw,rw
    80004c24:	6898                	ld	a4,16(s1)
    80004c26:	0204d783          	lhu	a5,32(s1)
    80004c2a:	8b9d                	andi	a5,a5,7
    80004c2c:	078e                	slli	a5,a5,0x3
    80004c2e:	97ba                	add	a5,a5,a4
    80004c30:	43dc                	lw	a5,4(a5)
    80004c32:	00278713          	addi	a4,a5,2
    80004c36:	0712                	slli	a4,a4,0x4
    80004c38:	9726                	add	a4,a4,s1
    80004c3a:	01074703          	lbu	a4,16(a4)
    80004c3e:	e321                	bnez	a4,80004c7e <virtio_disk_intr+0x9c>
    80004c40:	0789                	addi	a5,a5,2
    80004c42:	0792                	slli	a5,a5,0x4
    80004c44:	97a6                	add	a5,a5,s1
    80004c46:	6788                	ld	a0,8(a5)
    80004c48:	00052223          	sw	zero,4(a0)
    80004c4c:	f34fc0ef          	jal	80001380 <wakeup>
    80004c50:	0204d783          	lhu	a5,32(s1)
    80004c54:	2785                	addiw	a5,a5,1
    80004c56:	17c2                	slli	a5,a5,0x30
    80004c58:	93c1                	srli	a5,a5,0x30
    80004c5a:	02f49023          	sh	a5,32(s1)
    80004c5e:	6898                	ld	a4,16(s1)
    80004c60:	00275703          	lhu	a4,2(a4)
    80004c64:	faf71ee3          	bne	a4,a5,80004c20 <virtio_disk_intr+0x3e>
    80004c68:	00025517          	auipc	a0,0x25
    80004c6c:	a8850513          	addi	a0,a0,-1400 # 800296f0 <disk+0x128>
    80004c70:	359000ef          	jal	800057c8 <release>
    80004c74:	60e2                	ld	ra,24(sp)
    80004c76:	6442                	ld	s0,16(sp)
    80004c78:	64a2                	ld	s1,8(sp)
    80004c7a:	6105                	addi	sp,sp,32
    80004c7c:	8082                	ret
    80004c7e:	00003517          	auipc	a0,0x3
    80004c82:	a7a50513          	addi	a0,a0,-1414 # 800076f8 <etext+0x6f8>
    80004c86:	77c000ef          	jal	80005402 <panic>

0000000080004c8a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004c8a:	1141                	addi	sp,sp,-16
    80004c8c:	e422                	sd	s0,8(sp)
    80004c8e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004c90:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004c94:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004c98:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004c9c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004ca0:	577d                	li	a4,-1
    80004ca2:	177e                	slli	a4,a4,0x3f
    80004ca4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004ca6:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004caa:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004cae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004cb2:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004cb6:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004cba:	000f4737          	lui	a4,0xf4
    80004cbe:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004cc2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004cc4:	14d79073          	csrw	stimecmp,a5
}
    80004cc8:	6422                	ld	s0,8(sp)
    80004cca:	0141                	addi	sp,sp,16
    80004ccc:	8082                	ret

0000000080004cce <start>:
{
    80004cce:	1141                	addi	sp,sp,-16
    80004cd0:	e406                	sd	ra,8(sp)
    80004cd2:	e022                	sd	s0,0(sp)
    80004cd4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004cd6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004cda:	7779                	lui	a4,0xffffe
    80004cdc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffccfef>
    80004ce0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004ce2:	6705                	lui	a4,0x1
    80004ce4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004ce8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004cea:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004cee:	ffffb797          	auipc	a5,0xffffb
    80004cf2:	5fa78793          	addi	a5,a5,1530 # 800002e8 <main>
    80004cf6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004cfa:	4781                	li	a5,0
    80004cfc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004d00:	67c1                	lui	a5,0x10
    80004d02:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004d04:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004d08:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004d0c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004d10:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004d14:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004d18:	57fd                	li	a5,-1
    80004d1a:	83a9                	srli	a5,a5,0xa
    80004d1c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004d20:	47bd                	li	a5,15
    80004d22:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004d26:	f65ff0ef          	jal	80004c8a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004d2a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004d2e:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    80004d30:	823e                	mv	tp,a5
  asm volatile("mret");
    80004d32:	30200073          	mret
}
    80004d36:	60a2                	ld	ra,8(sp)
    80004d38:	6402                	ld	s0,0(sp)
    80004d3a:	0141                	addi	sp,sp,16
    80004d3c:	8082                	ret

0000000080004d3e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004d3e:	715d                	addi	sp,sp,-80
    80004d40:	e486                	sd	ra,72(sp)
    80004d42:	e0a2                	sd	s0,64(sp)
    80004d44:	f84a                	sd	s2,48(sp)
    80004d46:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004d48:	04c05263          	blez	a2,80004d8c <consolewrite+0x4e>
    80004d4c:	fc26                	sd	s1,56(sp)
    80004d4e:	f44e                	sd	s3,40(sp)
    80004d50:	f052                	sd	s4,32(sp)
    80004d52:	ec56                	sd	s5,24(sp)
    80004d54:	8a2a                	mv	s4,a0
    80004d56:	84ae                	mv	s1,a1
    80004d58:	89b2                	mv	s3,a2
    80004d5a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004d5c:	5afd                	li	s5,-1
    80004d5e:	4685                	li	a3,1
    80004d60:	8626                	mv	a2,s1
    80004d62:	85d2                	mv	a1,s4
    80004d64:	fbf40513          	addi	a0,s0,-65
    80004d68:	973fc0ef          	jal	800016da <either_copyin>
    80004d6c:	03550263          	beq	a0,s5,80004d90 <consolewrite+0x52>
      break;
    uartputc(c);
    80004d70:	fbf44503          	lbu	a0,-65(s0)
    80004d74:	035000ef          	jal	800055a8 <uartputc>
  for(i = 0; i < n; i++){
    80004d78:	2905                	addiw	s2,s2,1
    80004d7a:	0485                	addi	s1,s1,1
    80004d7c:	ff2991e3          	bne	s3,s2,80004d5e <consolewrite+0x20>
    80004d80:	894e                	mv	s2,s3
    80004d82:	74e2                	ld	s1,56(sp)
    80004d84:	79a2                	ld	s3,40(sp)
    80004d86:	7a02                	ld	s4,32(sp)
    80004d88:	6ae2                	ld	s5,24(sp)
    80004d8a:	a039                	j	80004d98 <consolewrite+0x5a>
    80004d8c:	4901                	li	s2,0
    80004d8e:	a029                	j	80004d98 <consolewrite+0x5a>
    80004d90:	74e2                	ld	s1,56(sp)
    80004d92:	79a2                	ld	s3,40(sp)
    80004d94:	7a02                	ld	s4,32(sp)
    80004d96:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004d98:	854a                	mv	a0,s2
    80004d9a:	60a6                	ld	ra,72(sp)
    80004d9c:	6406                	ld	s0,64(sp)
    80004d9e:	7942                	ld	s2,48(sp)
    80004da0:	6161                	addi	sp,sp,80
    80004da2:	8082                	ret

0000000080004da4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004da4:	711d                	addi	sp,sp,-96
    80004da6:	ec86                	sd	ra,88(sp)
    80004da8:	e8a2                	sd	s0,80(sp)
    80004daa:	e4a6                	sd	s1,72(sp)
    80004dac:	e0ca                	sd	s2,64(sp)
    80004dae:	fc4e                	sd	s3,56(sp)
    80004db0:	f852                	sd	s4,48(sp)
    80004db2:	f456                	sd	s5,40(sp)
    80004db4:	f05a                	sd	s6,32(sp)
    80004db6:	1080                	addi	s0,sp,96
    80004db8:	8aaa                	mv	s5,a0
    80004dba:	8a2e                	mv	s4,a1
    80004dbc:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004dbe:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004dc2:	0002d517          	auipc	a0,0x2d
    80004dc6:	94e50513          	addi	a0,a0,-1714 # 80031710 <cons>
    80004dca:	167000ef          	jal	80005730 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004dce:	0002d497          	auipc	s1,0x2d
    80004dd2:	94248493          	addi	s1,s1,-1726 # 80031710 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004dd6:	0002d917          	auipc	s2,0x2d
    80004dda:	9d290913          	addi	s2,s2,-1582 # 800317a8 <cons+0x98>
  while(n > 0){
    80004dde:	0b305d63          	blez	s3,80004e98 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004de2:	0984a783          	lw	a5,152(s1)
    80004de6:	09c4a703          	lw	a4,156(s1)
    80004dea:	0af71263          	bne	a4,a5,80004e8e <consoleread+0xea>
      if(killed(myproc())){
    80004dee:	f79fb0ef          	jal	80000d66 <myproc>
    80004df2:	f7afc0ef          	jal	8000156c <killed>
    80004df6:	e12d                	bnez	a0,80004e58 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004df8:	85a6                	mv	a1,s1
    80004dfa:	854a                	mv	a0,s2
    80004dfc:	d38fc0ef          	jal	80001334 <sleep>
    while(cons.r == cons.w){
    80004e00:	0984a783          	lw	a5,152(s1)
    80004e04:	09c4a703          	lw	a4,156(s1)
    80004e08:	fef703e3          	beq	a4,a5,80004dee <consoleread+0x4a>
    80004e0c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004e0e:	0002d717          	auipc	a4,0x2d
    80004e12:	90270713          	addi	a4,a4,-1790 # 80031710 <cons>
    80004e16:	0017869b          	addiw	a3,a5,1
    80004e1a:	08d72c23          	sw	a3,152(a4)
    80004e1e:	07f7f693          	andi	a3,a5,127
    80004e22:	9736                	add	a4,a4,a3
    80004e24:	01874703          	lbu	a4,24(a4)
    80004e28:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004e2c:	4691                	li	a3,4
    80004e2e:	04db8663          	beq	s7,a3,80004e7a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004e32:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004e36:	4685                	li	a3,1
    80004e38:	faf40613          	addi	a2,s0,-81
    80004e3c:	85d2                	mv	a1,s4
    80004e3e:	8556                	mv	a0,s5
    80004e40:	851fc0ef          	jal	80001690 <either_copyout>
    80004e44:	57fd                	li	a5,-1
    80004e46:	04f50863          	beq	a0,a5,80004e96 <consoleread+0xf2>
      break;

    dst++;
    80004e4a:	0a05                	addi	s4,s4,1
    --n;
    80004e4c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004e4e:	47a9                	li	a5,10
    80004e50:	04fb8d63          	beq	s7,a5,80004eaa <consoleread+0x106>
    80004e54:	6be2                	ld	s7,24(sp)
    80004e56:	b761                	j	80004dde <consoleread+0x3a>
        release(&cons.lock);
    80004e58:	0002d517          	auipc	a0,0x2d
    80004e5c:	8b850513          	addi	a0,a0,-1864 # 80031710 <cons>
    80004e60:	169000ef          	jal	800057c8 <release>
        return -1;
    80004e64:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004e66:	60e6                	ld	ra,88(sp)
    80004e68:	6446                	ld	s0,80(sp)
    80004e6a:	64a6                	ld	s1,72(sp)
    80004e6c:	6906                	ld	s2,64(sp)
    80004e6e:	79e2                	ld	s3,56(sp)
    80004e70:	7a42                	ld	s4,48(sp)
    80004e72:	7aa2                	ld	s5,40(sp)
    80004e74:	7b02                	ld	s6,32(sp)
    80004e76:	6125                	addi	sp,sp,96
    80004e78:	8082                	ret
      if(n < target){
    80004e7a:	0009871b          	sext.w	a4,s3
    80004e7e:	01677a63          	bgeu	a4,s6,80004e92 <consoleread+0xee>
        cons.r--;
    80004e82:	0002d717          	auipc	a4,0x2d
    80004e86:	92f72323          	sw	a5,-1754(a4) # 800317a8 <cons+0x98>
    80004e8a:	6be2                	ld	s7,24(sp)
    80004e8c:	a031                	j	80004e98 <consoleread+0xf4>
    80004e8e:	ec5e                	sd	s7,24(sp)
    80004e90:	bfbd                	j	80004e0e <consoleread+0x6a>
    80004e92:	6be2                	ld	s7,24(sp)
    80004e94:	a011                	j	80004e98 <consoleread+0xf4>
    80004e96:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004e98:	0002d517          	auipc	a0,0x2d
    80004e9c:	87850513          	addi	a0,a0,-1928 # 80031710 <cons>
    80004ea0:	129000ef          	jal	800057c8 <release>
  return target - n;
    80004ea4:	413b053b          	subw	a0,s6,s3
    80004ea8:	bf7d                	j	80004e66 <consoleread+0xc2>
    80004eaa:	6be2                	ld	s7,24(sp)
    80004eac:	b7f5                	j	80004e98 <consoleread+0xf4>

0000000080004eae <consputc>:
{
    80004eae:	1141                	addi	sp,sp,-16
    80004eb0:	e406                	sd	ra,8(sp)
    80004eb2:	e022                	sd	s0,0(sp)
    80004eb4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004eb6:	10000793          	li	a5,256
    80004eba:	00f50863          	beq	a0,a5,80004eca <consputc+0x1c>
    uartputc_sync(c);
    80004ebe:	604000ef          	jal	800054c2 <uartputc_sync>
}
    80004ec2:	60a2                	ld	ra,8(sp)
    80004ec4:	6402                	ld	s0,0(sp)
    80004ec6:	0141                	addi	sp,sp,16
    80004ec8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004eca:	4521                	li	a0,8
    80004ecc:	5f6000ef          	jal	800054c2 <uartputc_sync>
    80004ed0:	02000513          	li	a0,32
    80004ed4:	5ee000ef          	jal	800054c2 <uartputc_sync>
    80004ed8:	4521                	li	a0,8
    80004eda:	5e8000ef          	jal	800054c2 <uartputc_sync>
    80004ede:	b7d5                	j	80004ec2 <consputc+0x14>

0000000080004ee0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004ee0:	1101                	addi	sp,sp,-32
    80004ee2:	ec06                	sd	ra,24(sp)
    80004ee4:	e822                	sd	s0,16(sp)
    80004ee6:	e426                	sd	s1,8(sp)
    80004ee8:	1000                	addi	s0,sp,32
    80004eea:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004eec:	0002d517          	auipc	a0,0x2d
    80004ef0:	82450513          	addi	a0,a0,-2012 # 80031710 <cons>
    80004ef4:	03d000ef          	jal	80005730 <acquire>

  switch(c){
    80004ef8:	47d5                	li	a5,21
    80004efa:	08f48f63          	beq	s1,a5,80004f98 <consoleintr+0xb8>
    80004efe:	0297c563          	blt	a5,s1,80004f28 <consoleintr+0x48>
    80004f02:	47a1                	li	a5,8
    80004f04:	0ef48463          	beq	s1,a5,80004fec <consoleintr+0x10c>
    80004f08:	47c1                	li	a5,16
    80004f0a:	10f49563          	bne	s1,a5,80005014 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    80004f0e:	817fc0ef          	jal	80001724 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004f12:	0002c517          	auipc	a0,0x2c
    80004f16:	7fe50513          	addi	a0,a0,2046 # 80031710 <cons>
    80004f1a:	0af000ef          	jal	800057c8 <release>
}
    80004f1e:	60e2                	ld	ra,24(sp)
    80004f20:	6442                	ld	s0,16(sp)
    80004f22:	64a2                	ld	s1,8(sp)
    80004f24:	6105                	addi	sp,sp,32
    80004f26:	8082                	ret
  switch(c){
    80004f28:	07f00793          	li	a5,127
    80004f2c:	0cf48063          	beq	s1,a5,80004fec <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004f30:	0002c717          	auipc	a4,0x2c
    80004f34:	7e070713          	addi	a4,a4,2016 # 80031710 <cons>
    80004f38:	0a072783          	lw	a5,160(a4)
    80004f3c:	09872703          	lw	a4,152(a4)
    80004f40:	9f99                	subw	a5,a5,a4
    80004f42:	07f00713          	li	a4,127
    80004f46:	fcf766e3          	bltu	a4,a5,80004f12 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80004f4a:	47b5                	li	a5,13
    80004f4c:	0cf48763          	beq	s1,a5,8000501a <consoleintr+0x13a>
      consputc(c);
    80004f50:	8526                	mv	a0,s1
    80004f52:	f5dff0ef          	jal	80004eae <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004f56:	0002c797          	auipc	a5,0x2c
    80004f5a:	7ba78793          	addi	a5,a5,1978 # 80031710 <cons>
    80004f5e:	0a07a683          	lw	a3,160(a5)
    80004f62:	0016871b          	addiw	a4,a3,1
    80004f66:	0007061b          	sext.w	a2,a4
    80004f6a:	0ae7a023          	sw	a4,160(a5)
    80004f6e:	07f6f693          	andi	a3,a3,127
    80004f72:	97b6                	add	a5,a5,a3
    80004f74:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80004f78:	47a9                	li	a5,10
    80004f7a:	0cf48563          	beq	s1,a5,80005044 <consoleintr+0x164>
    80004f7e:	4791                	li	a5,4
    80004f80:	0cf48263          	beq	s1,a5,80005044 <consoleintr+0x164>
    80004f84:	0002d797          	auipc	a5,0x2d
    80004f88:	8247a783          	lw	a5,-2012(a5) # 800317a8 <cons+0x98>
    80004f8c:	9f1d                	subw	a4,a4,a5
    80004f8e:	08000793          	li	a5,128
    80004f92:	f8f710e3          	bne	a4,a5,80004f12 <consoleintr+0x32>
    80004f96:	a07d                	j	80005044 <consoleintr+0x164>
    80004f98:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80004f9a:	0002c717          	auipc	a4,0x2c
    80004f9e:	77670713          	addi	a4,a4,1910 # 80031710 <cons>
    80004fa2:	0a072783          	lw	a5,160(a4)
    80004fa6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004faa:	0002c497          	auipc	s1,0x2c
    80004fae:	76648493          	addi	s1,s1,1894 # 80031710 <cons>
    while(cons.e != cons.w &&
    80004fb2:	4929                	li	s2,10
    80004fb4:	02f70863          	beq	a4,a5,80004fe4 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004fb8:	37fd                	addiw	a5,a5,-1
    80004fba:	07f7f713          	andi	a4,a5,127
    80004fbe:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80004fc0:	01874703          	lbu	a4,24(a4)
    80004fc4:	03270263          	beq	a4,s2,80004fe8 <consoleintr+0x108>
      cons.e--;
    80004fc8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80004fcc:	10000513          	li	a0,256
    80004fd0:	edfff0ef          	jal	80004eae <consputc>
    while(cons.e != cons.w &&
    80004fd4:	0a04a783          	lw	a5,160(s1)
    80004fd8:	09c4a703          	lw	a4,156(s1)
    80004fdc:	fcf71ee3          	bne	a4,a5,80004fb8 <consoleintr+0xd8>
    80004fe0:	6902                	ld	s2,0(sp)
    80004fe2:	bf05                	j	80004f12 <consoleintr+0x32>
    80004fe4:	6902                	ld	s2,0(sp)
    80004fe6:	b735                	j	80004f12 <consoleintr+0x32>
    80004fe8:	6902                	ld	s2,0(sp)
    80004fea:	b725                	j	80004f12 <consoleintr+0x32>
    if(cons.e != cons.w){
    80004fec:	0002c717          	auipc	a4,0x2c
    80004ff0:	72470713          	addi	a4,a4,1828 # 80031710 <cons>
    80004ff4:	0a072783          	lw	a5,160(a4)
    80004ff8:	09c72703          	lw	a4,156(a4)
    80004ffc:	f0f70be3          	beq	a4,a5,80004f12 <consoleintr+0x32>
      cons.e--;
    80005000:	37fd                	addiw	a5,a5,-1
    80005002:	0002c717          	auipc	a4,0x2c
    80005006:	7af72723          	sw	a5,1966(a4) # 800317b0 <cons+0xa0>
      consputc(BACKSPACE);
    8000500a:	10000513          	li	a0,256
    8000500e:	ea1ff0ef          	jal	80004eae <consputc>
    80005012:	b701                	j	80004f12 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005014:	ee048fe3          	beqz	s1,80004f12 <consoleintr+0x32>
    80005018:	bf21                	j	80004f30 <consoleintr+0x50>
      consputc(c);
    8000501a:	4529                	li	a0,10
    8000501c:	e93ff0ef          	jal	80004eae <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005020:	0002c797          	auipc	a5,0x2c
    80005024:	6f078793          	addi	a5,a5,1776 # 80031710 <cons>
    80005028:	0a07a703          	lw	a4,160(a5)
    8000502c:	0017069b          	addiw	a3,a4,1
    80005030:	0006861b          	sext.w	a2,a3
    80005034:	0ad7a023          	sw	a3,160(a5)
    80005038:	07f77713          	andi	a4,a4,127
    8000503c:	97ba                	add	a5,a5,a4
    8000503e:	4729                	li	a4,10
    80005040:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005044:	0002c797          	auipc	a5,0x2c
    80005048:	76c7a423          	sw	a2,1896(a5) # 800317ac <cons+0x9c>
        wakeup(&cons.r);
    8000504c:	0002c517          	auipc	a0,0x2c
    80005050:	75c50513          	addi	a0,a0,1884 # 800317a8 <cons+0x98>
    80005054:	b2cfc0ef          	jal	80001380 <wakeup>
    80005058:	bd6d                	j	80004f12 <consoleintr+0x32>

000000008000505a <consoleinit>:

void
consoleinit(void)
{
    8000505a:	1141                	addi	sp,sp,-16
    8000505c:	e406                	sd	ra,8(sp)
    8000505e:	e022                	sd	s0,0(sp)
    80005060:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005062:	00002597          	auipc	a1,0x2
    80005066:	6ae58593          	addi	a1,a1,1710 # 80007710 <etext+0x710>
    8000506a:	0002c517          	auipc	a0,0x2c
    8000506e:	6a650513          	addi	a0,a0,1702 # 80031710 <cons>
    80005072:	63e000ef          	jal	800056b0 <initlock>

  uartinit();
    80005076:	3f4000ef          	jal	8000546a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000507a:	00023797          	auipc	a5,0x23
    8000507e:	4f678793          	addi	a5,a5,1270 # 80028570 <devsw>
    80005082:	00000717          	auipc	a4,0x0
    80005086:	d2270713          	addi	a4,a4,-734 # 80004da4 <consoleread>
    8000508a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000508c:	00000717          	auipc	a4,0x0
    80005090:	cb270713          	addi	a4,a4,-846 # 80004d3e <consolewrite>
    80005094:	ef98                	sd	a4,24(a5)
}
    80005096:	60a2                	ld	ra,8(sp)
    80005098:	6402                	ld	s0,0(sp)
    8000509a:	0141                	addi	sp,sp,16
    8000509c:	8082                	ret

000000008000509e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000509e:	7179                	addi	sp,sp,-48
    800050a0:	f406                	sd	ra,40(sp)
    800050a2:	f022                	sd	s0,32(sp)
    800050a4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800050a6:	c219                	beqz	a2,800050ac <printint+0xe>
    800050a8:	08054063          	bltz	a0,80005128 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800050ac:	4881                	li	a7,0
    800050ae:	fd040693          	addi	a3,s0,-48

  i = 0;
    800050b2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800050b4:	00002617          	auipc	a2,0x2
    800050b8:	7b460613          	addi	a2,a2,1972 # 80007868 <digits>
    800050bc:	883e                	mv	a6,a5
    800050be:	2785                	addiw	a5,a5,1
    800050c0:	02b57733          	remu	a4,a0,a1
    800050c4:	9732                	add	a4,a4,a2
    800050c6:	00074703          	lbu	a4,0(a4)
    800050ca:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800050ce:	872a                	mv	a4,a0
    800050d0:	02b55533          	divu	a0,a0,a1
    800050d4:	0685                	addi	a3,a3,1
    800050d6:	feb773e3          	bgeu	a4,a1,800050bc <printint+0x1e>

  if(sign)
    800050da:	00088a63          	beqz	a7,800050ee <printint+0x50>
    buf[i++] = '-';
    800050de:	1781                	addi	a5,a5,-32
    800050e0:	97a2                	add	a5,a5,s0
    800050e2:	02d00713          	li	a4,45
    800050e6:	fee78823          	sb	a4,-16(a5)
    800050ea:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800050ee:	02f05963          	blez	a5,80005120 <printint+0x82>
    800050f2:	ec26                	sd	s1,24(sp)
    800050f4:	e84a                	sd	s2,16(sp)
    800050f6:	fd040713          	addi	a4,s0,-48
    800050fa:	00f704b3          	add	s1,a4,a5
    800050fe:	fff70913          	addi	s2,a4,-1
    80005102:	993e                	add	s2,s2,a5
    80005104:	37fd                	addiw	a5,a5,-1
    80005106:	1782                	slli	a5,a5,0x20
    80005108:	9381                	srli	a5,a5,0x20
    8000510a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000510e:	fff4c503          	lbu	a0,-1(s1)
    80005112:	d9dff0ef          	jal	80004eae <consputc>
  while(--i >= 0)
    80005116:	14fd                	addi	s1,s1,-1
    80005118:	ff249be3          	bne	s1,s2,8000510e <printint+0x70>
    8000511c:	64e2                	ld	s1,24(sp)
    8000511e:	6942                	ld	s2,16(sp)
}
    80005120:	70a2                	ld	ra,40(sp)
    80005122:	7402                	ld	s0,32(sp)
    80005124:	6145                	addi	sp,sp,48
    80005126:	8082                	ret
    x = -xx;
    80005128:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000512c:	4885                	li	a7,1
    x = -xx;
    8000512e:	b741                	j	800050ae <printint+0x10>

0000000080005130 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005130:	7155                	addi	sp,sp,-208
    80005132:	e506                	sd	ra,136(sp)
    80005134:	e122                	sd	s0,128(sp)
    80005136:	f0d2                	sd	s4,96(sp)
    80005138:	0900                	addi	s0,sp,144
    8000513a:	8a2a                	mv	s4,a0
    8000513c:	e40c                	sd	a1,8(s0)
    8000513e:	e810                	sd	a2,16(s0)
    80005140:	ec14                	sd	a3,24(s0)
    80005142:	f018                	sd	a4,32(s0)
    80005144:	f41c                	sd	a5,40(s0)
    80005146:	03043823          	sd	a6,48(s0)
    8000514a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000514e:	0002c797          	auipc	a5,0x2c
    80005152:	6827a783          	lw	a5,1666(a5) # 800317d0 <pr+0x18>
    80005156:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000515a:	e3a1                	bnez	a5,8000519a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000515c:	00840793          	addi	a5,s0,8
    80005160:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005164:	00054503          	lbu	a0,0(a0)
    80005168:	26050763          	beqz	a0,800053d6 <printf+0x2a6>
    8000516c:	fca6                	sd	s1,120(sp)
    8000516e:	f8ca                	sd	s2,112(sp)
    80005170:	f4ce                	sd	s3,104(sp)
    80005172:	ecd6                	sd	s5,88(sp)
    80005174:	e8da                	sd	s6,80(sp)
    80005176:	e0e2                	sd	s8,64(sp)
    80005178:	fc66                	sd	s9,56(sp)
    8000517a:	f86a                	sd	s10,48(sp)
    8000517c:	f46e                	sd	s11,40(sp)
    8000517e:	4981                	li	s3,0
    if(cx != '%'){
    80005180:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005184:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005188:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000518c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005190:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005194:	07000d93          	li	s11,112
    80005198:	a815                	j	800051cc <printf+0x9c>
    acquire(&pr.lock);
    8000519a:	0002c517          	auipc	a0,0x2c
    8000519e:	61e50513          	addi	a0,a0,1566 # 800317b8 <pr>
    800051a2:	58e000ef          	jal	80005730 <acquire>
  va_start(ap, fmt);
    800051a6:	00840793          	addi	a5,s0,8
    800051aa:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051ae:	000a4503          	lbu	a0,0(s4)
    800051b2:	fd4d                	bnez	a0,8000516c <printf+0x3c>
    800051b4:	a481                	j	800053f4 <printf+0x2c4>
      consputc(cx);
    800051b6:	cf9ff0ef          	jal	80004eae <consputc>
      continue;
    800051ba:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051bc:	0014899b          	addiw	s3,s1,1
    800051c0:	013a07b3          	add	a5,s4,s3
    800051c4:	0007c503          	lbu	a0,0(a5)
    800051c8:	1e050b63          	beqz	a0,800053be <printf+0x28e>
    if(cx != '%'){
    800051cc:	ff5515e3          	bne	a0,s5,800051b6 <printf+0x86>
    i++;
    800051d0:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800051d4:	009a07b3          	add	a5,s4,s1
    800051d8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800051dc:	1e090163          	beqz	s2,800053be <printf+0x28e>
    800051e0:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800051e4:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800051e6:	c789                	beqz	a5,800051f0 <printf+0xc0>
    800051e8:	009a0733          	add	a4,s4,s1
    800051ec:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800051f0:	03690763          	beq	s2,s6,8000521e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    800051f4:	05890163          	beq	s2,s8,80005236 <printf+0x106>
    } else if(c0 == 'u'){
    800051f8:	0d990b63          	beq	s2,s9,800052ce <printf+0x19e>
    } else if(c0 == 'x'){
    800051fc:	13a90163          	beq	s2,s10,8000531e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005200:	13b90b63          	beq	s2,s11,80005336 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005204:	07300793          	li	a5,115
    80005208:	16f90a63          	beq	s2,a5,8000537c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000520c:	1b590463          	beq	s2,s5,800053b4 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005210:	8556                	mv	a0,s5
    80005212:	c9dff0ef          	jal	80004eae <consputc>
      consputc(c0);
    80005216:	854a                	mv	a0,s2
    80005218:	c97ff0ef          	jal	80004eae <consputc>
    8000521c:	b745                	j	800051bc <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000521e:	f8843783          	ld	a5,-120(s0)
    80005222:	00878713          	addi	a4,a5,8
    80005226:	f8e43423          	sd	a4,-120(s0)
    8000522a:	4605                	li	a2,1
    8000522c:	45a9                	li	a1,10
    8000522e:	4388                	lw	a0,0(a5)
    80005230:	e6fff0ef          	jal	8000509e <printint>
    80005234:	b761                	j	800051bc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005236:	03678663          	beq	a5,s6,80005262 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000523a:	05878263          	beq	a5,s8,8000527e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000523e:	0b978463          	beq	a5,s9,800052e6 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005242:	fda797e3          	bne	a5,s10,80005210 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005246:	f8843783          	ld	a5,-120(s0)
    8000524a:	00878713          	addi	a4,a5,8
    8000524e:	f8e43423          	sd	a4,-120(s0)
    80005252:	4601                	li	a2,0
    80005254:	45c1                	li	a1,16
    80005256:	6388                	ld	a0,0(a5)
    80005258:	e47ff0ef          	jal	8000509e <printint>
      i += 1;
    8000525c:	0029849b          	addiw	s1,s3,2
    80005260:	bfb1                	j	800051bc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005262:	f8843783          	ld	a5,-120(s0)
    80005266:	00878713          	addi	a4,a5,8
    8000526a:	f8e43423          	sd	a4,-120(s0)
    8000526e:	4605                	li	a2,1
    80005270:	45a9                	li	a1,10
    80005272:	6388                	ld	a0,0(a5)
    80005274:	e2bff0ef          	jal	8000509e <printint>
      i += 1;
    80005278:	0029849b          	addiw	s1,s3,2
    8000527c:	b781                	j	800051bc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000527e:	06400793          	li	a5,100
    80005282:	02f68863          	beq	a3,a5,800052b2 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005286:	07500793          	li	a5,117
    8000528a:	06f68c63          	beq	a3,a5,80005302 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000528e:	07800793          	li	a5,120
    80005292:	f6f69fe3          	bne	a3,a5,80005210 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005296:	f8843783          	ld	a5,-120(s0)
    8000529a:	00878713          	addi	a4,a5,8
    8000529e:	f8e43423          	sd	a4,-120(s0)
    800052a2:	4601                	li	a2,0
    800052a4:	45c1                	li	a1,16
    800052a6:	6388                	ld	a0,0(a5)
    800052a8:	df7ff0ef          	jal	8000509e <printint>
      i += 2;
    800052ac:	0039849b          	addiw	s1,s3,3
    800052b0:	b731                	j	800051bc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800052b2:	f8843783          	ld	a5,-120(s0)
    800052b6:	00878713          	addi	a4,a5,8
    800052ba:	f8e43423          	sd	a4,-120(s0)
    800052be:	4605                	li	a2,1
    800052c0:	45a9                	li	a1,10
    800052c2:	6388                	ld	a0,0(a5)
    800052c4:	ddbff0ef          	jal	8000509e <printint>
      i += 2;
    800052c8:	0039849b          	addiw	s1,s3,3
    800052cc:	bdc5                	j	800051bc <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800052ce:	f8843783          	ld	a5,-120(s0)
    800052d2:	00878713          	addi	a4,a5,8
    800052d6:	f8e43423          	sd	a4,-120(s0)
    800052da:	4601                	li	a2,0
    800052dc:	45a9                	li	a1,10
    800052de:	4388                	lw	a0,0(a5)
    800052e0:	dbfff0ef          	jal	8000509e <printint>
    800052e4:	bde1                	j	800051bc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800052e6:	f8843783          	ld	a5,-120(s0)
    800052ea:	00878713          	addi	a4,a5,8
    800052ee:	f8e43423          	sd	a4,-120(s0)
    800052f2:	4601                	li	a2,0
    800052f4:	45a9                	li	a1,10
    800052f6:	6388                	ld	a0,0(a5)
    800052f8:	da7ff0ef          	jal	8000509e <printint>
      i += 1;
    800052fc:	0029849b          	addiw	s1,s3,2
    80005300:	bd75                	j	800051bc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005302:	f8843783          	ld	a5,-120(s0)
    80005306:	00878713          	addi	a4,a5,8
    8000530a:	f8e43423          	sd	a4,-120(s0)
    8000530e:	4601                	li	a2,0
    80005310:	45a9                	li	a1,10
    80005312:	6388                	ld	a0,0(a5)
    80005314:	d8bff0ef          	jal	8000509e <printint>
      i += 2;
    80005318:	0039849b          	addiw	s1,s3,3
    8000531c:	b545                	j	800051bc <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000531e:	f8843783          	ld	a5,-120(s0)
    80005322:	00878713          	addi	a4,a5,8
    80005326:	f8e43423          	sd	a4,-120(s0)
    8000532a:	4601                	li	a2,0
    8000532c:	45c1                	li	a1,16
    8000532e:	4388                	lw	a0,0(a5)
    80005330:	d6fff0ef          	jal	8000509e <printint>
    80005334:	b561                	j	800051bc <printf+0x8c>
    80005336:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005338:	f8843783          	ld	a5,-120(s0)
    8000533c:	00878713          	addi	a4,a5,8
    80005340:	f8e43423          	sd	a4,-120(s0)
    80005344:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005348:	03000513          	li	a0,48
    8000534c:	b63ff0ef          	jal	80004eae <consputc>
  consputc('x');
    80005350:	07800513          	li	a0,120
    80005354:	b5bff0ef          	jal	80004eae <consputc>
    80005358:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000535a:	00002b97          	auipc	s7,0x2
    8000535e:	50eb8b93          	addi	s7,s7,1294 # 80007868 <digits>
    80005362:	03c9d793          	srli	a5,s3,0x3c
    80005366:	97de                	add	a5,a5,s7
    80005368:	0007c503          	lbu	a0,0(a5)
    8000536c:	b43ff0ef          	jal	80004eae <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005370:	0992                	slli	s3,s3,0x4
    80005372:	397d                	addiw	s2,s2,-1
    80005374:	fe0917e3          	bnez	s2,80005362 <printf+0x232>
    80005378:	6ba6                	ld	s7,72(sp)
    8000537a:	b589                	j	800051bc <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000537c:	f8843783          	ld	a5,-120(s0)
    80005380:	00878713          	addi	a4,a5,8
    80005384:	f8e43423          	sd	a4,-120(s0)
    80005388:	0007b903          	ld	s2,0(a5)
    8000538c:	00090d63          	beqz	s2,800053a6 <printf+0x276>
      for(; *s; s++)
    80005390:	00094503          	lbu	a0,0(s2)
    80005394:	e20504e3          	beqz	a0,800051bc <printf+0x8c>
        consputc(*s);
    80005398:	b17ff0ef          	jal	80004eae <consputc>
      for(; *s; s++)
    8000539c:	0905                	addi	s2,s2,1
    8000539e:	00094503          	lbu	a0,0(s2)
    800053a2:	f97d                	bnez	a0,80005398 <printf+0x268>
    800053a4:	bd21                	j	800051bc <printf+0x8c>
        s = "(null)";
    800053a6:	00002917          	auipc	s2,0x2
    800053aa:	37290913          	addi	s2,s2,882 # 80007718 <etext+0x718>
      for(; *s; s++)
    800053ae:	02800513          	li	a0,40
    800053b2:	b7dd                	j	80005398 <printf+0x268>
      consputc('%');
    800053b4:	02500513          	li	a0,37
    800053b8:	af7ff0ef          	jal	80004eae <consputc>
    800053bc:	b501                	j	800051bc <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800053be:	f7843783          	ld	a5,-136(s0)
    800053c2:	e385                	bnez	a5,800053e2 <printf+0x2b2>
    800053c4:	74e6                	ld	s1,120(sp)
    800053c6:	7946                	ld	s2,112(sp)
    800053c8:	79a6                	ld	s3,104(sp)
    800053ca:	6ae6                	ld	s5,88(sp)
    800053cc:	6b46                	ld	s6,80(sp)
    800053ce:	6c06                	ld	s8,64(sp)
    800053d0:	7ce2                	ld	s9,56(sp)
    800053d2:	7d42                	ld	s10,48(sp)
    800053d4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800053d6:	4501                	li	a0,0
    800053d8:	60aa                	ld	ra,136(sp)
    800053da:	640a                	ld	s0,128(sp)
    800053dc:	7a06                	ld	s4,96(sp)
    800053de:	6169                	addi	sp,sp,208
    800053e0:	8082                	ret
    800053e2:	74e6                	ld	s1,120(sp)
    800053e4:	7946                	ld	s2,112(sp)
    800053e6:	79a6                	ld	s3,104(sp)
    800053e8:	6ae6                	ld	s5,88(sp)
    800053ea:	6b46                	ld	s6,80(sp)
    800053ec:	6c06                	ld	s8,64(sp)
    800053ee:	7ce2                	ld	s9,56(sp)
    800053f0:	7d42                	ld	s10,48(sp)
    800053f2:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800053f4:	0002c517          	auipc	a0,0x2c
    800053f8:	3c450513          	addi	a0,a0,964 # 800317b8 <pr>
    800053fc:	3cc000ef          	jal	800057c8 <release>
    80005400:	bfd9                	j	800053d6 <printf+0x2a6>

0000000080005402 <panic>:

void
panic(char *s)
{
    80005402:	1101                	addi	sp,sp,-32
    80005404:	ec06                	sd	ra,24(sp)
    80005406:	e822                	sd	s0,16(sp)
    80005408:	e426                	sd	s1,8(sp)
    8000540a:	1000                	addi	s0,sp,32
    8000540c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000540e:	0002c797          	auipc	a5,0x2c
    80005412:	3c07a123          	sw	zero,962(a5) # 800317d0 <pr+0x18>
  printf("panic: ");
    80005416:	00002517          	auipc	a0,0x2
    8000541a:	30a50513          	addi	a0,a0,778 # 80007720 <etext+0x720>
    8000541e:	d13ff0ef          	jal	80005130 <printf>
  printf("%s\n", s);
    80005422:	85a6                	mv	a1,s1
    80005424:	00002517          	auipc	a0,0x2
    80005428:	30450513          	addi	a0,a0,772 # 80007728 <etext+0x728>
    8000542c:	d05ff0ef          	jal	80005130 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005430:	4785                	li	a5,1
    80005432:	00005717          	auipc	a4,0x5
    80005436:	dcf72523          	sw	a5,-566(a4) # 8000a1fc <panicked>
  for(;;)
    8000543a:	a001                	j	8000543a <panic+0x38>

000000008000543c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000543c:	1101                	addi	sp,sp,-32
    8000543e:	ec06                	sd	ra,24(sp)
    80005440:	e822                	sd	s0,16(sp)
    80005442:	e426                	sd	s1,8(sp)
    80005444:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005446:	0002c497          	auipc	s1,0x2c
    8000544a:	37248493          	addi	s1,s1,882 # 800317b8 <pr>
    8000544e:	00002597          	auipc	a1,0x2
    80005452:	2e258593          	addi	a1,a1,738 # 80007730 <etext+0x730>
    80005456:	8526                	mv	a0,s1
    80005458:	258000ef          	jal	800056b0 <initlock>
  pr.locking = 1;
    8000545c:	4785                	li	a5,1
    8000545e:	cc9c                	sw	a5,24(s1)
}
    80005460:	60e2                	ld	ra,24(sp)
    80005462:	6442                	ld	s0,16(sp)
    80005464:	64a2                	ld	s1,8(sp)
    80005466:	6105                	addi	sp,sp,32
    80005468:	8082                	ret

000000008000546a <uartinit>:
    8000546a:	1141                	addi	sp,sp,-16
    8000546c:	e406                	sd	ra,8(sp)
    8000546e:	e022                	sd	s0,0(sp)
    80005470:	0800                	addi	s0,sp,16
    80005472:	100007b7          	lui	a5,0x10000
    80005476:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    8000547a:	10000737          	lui	a4,0x10000
    8000547e:	f8000693          	li	a3,-128
    80005482:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>
    80005486:	468d                	li	a3,3
    80005488:	10000637          	lui	a2,0x10000
    8000548c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>
    80005490:	000780a3          	sb	zero,1(a5)
    80005494:	00d701a3          	sb	a3,3(a4)
    80005498:	10000737          	lui	a4,0x10000
    8000549c:	461d                	li	a2,7
    8000549e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>
    800054a2:	00d780a3          	sb	a3,1(a5)
    800054a6:	00002597          	auipc	a1,0x2
    800054aa:	29258593          	addi	a1,a1,658 # 80007738 <etext+0x738>
    800054ae:	0002c517          	auipc	a0,0x2c
    800054b2:	32a50513          	addi	a0,a0,810 # 800317d8 <uart_tx_lock>
    800054b6:	1fa000ef          	jal	800056b0 <initlock>
    800054ba:	60a2                	ld	ra,8(sp)
    800054bc:	6402                	ld	s0,0(sp)
    800054be:	0141                	addi	sp,sp,16
    800054c0:	8082                	ret

00000000800054c2 <uartputc_sync>:
    800054c2:	1101                	addi	sp,sp,-32
    800054c4:	ec06                	sd	ra,24(sp)
    800054c6:	e822                	sd	s0,16(sp)
    800054c8:	e426                	sd	s1,8(sp)
    800054ca:	1000                	addi	s0,sp,32
    800054cc:	84aa                	mv	s1,a0
    800054ce:	222000ef          	jal	800056f0 <push_off>
    800054d2:	00005797          	auipc	a5,0x5
    800054d6:	d2a7a783          	lw	a5,-726(a5) # 8000a1fc <panicked>
    800054da:	e795                	bnez	a5,80005506 <uartputc_sync+0x44>
    800054dc:	10000737          	lui	a4,0x10000
    800054e0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800054e2:	00074783          	lbu	a5,0(a4)
    800054e6:	0207f793          	andi	a5,a5,32
    800054ea:	dfe5                	beqz	a5,800054e2 <uartputc_sync+0x20>
    800054ec:	0ff4f513          	zext.b	a0,s1
    800054f0:	100007b7          	lui	a5,0x10000
    800054f4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
    800054f8:	27c000ef          	jal	80005774 <pop_off>
    800054fc:	60e2                	ld	ra,24(sp)
    800054fe:	6442                	ld	s0,16(sp)
    80005500:	64a2                	ld	s1,8(sp)
    80005502:	6105                	addi	sp,sp,32
    80005504:	8082                	ret
    80005506:	a001                	j	80005506 <uartputc_sync+0x44>

0000000080005508 <uartstart>:
    80005508:	00005797          	auipc	a5,0x5
    8000550c:	cf87b783          	ld	a5,-776(a5) # 8000a200 <uart_tx_r>
    80005510:	00005717          	auipc	a4,0x5
    80005514:	cf873703          	ld	a4,-776(a4) # 8000a208 <uart_tx_w>
    80005518:	08f70263          	beq	a4,a5,8000559c <uartstart+0x94>
    8000551c:	7139                	addi	sp,sp,-64
    8000551e:	fc06                	sd	ra,56(sp)
    80005520:	f822                	sd	s0,48(sp)
    80005522:	f426                	sd	s1,40(sp)
    80005524:	f04a                	sd	s2,32(sp)
    80005526:	ec4e                	sd	s3,24(sp)
    80005528:	e852                	sd	s4,16(sp)
    8000552a:	e456                	sd	s5,8(sp)
    8000552c:	e05a                	sd	s6,0(sp)
    8000552e:	0080                	addi	s0,sp,64
    80005530:	10000937          	lui	s2,0x10000
    80005534:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
    80005536:	0002ca97          	auipc	s5,0x2c
    8000553a:	2a2a8a93          	addi	s5,s5,674 # 800317d8 <uart_tx_lock>
    8000553e:	00005497          	auipc	s1,0x5
    80005542:	cc248493          	addi	s1,s1,-830 # 8000a200 <uart_tx_r>
    80005546:	10000a37          	lui	s4,0x10000
    8000554a:	00005997          	auipc	s3,0x5
    8000554e:	cbe98993          	addi	s3,s3,-834 # 8000a208 <uart_tx_w>
    80005552:	00094703          	lbu	a4,0(s2)
    80005556:	02077713          	andi	a4,a4,32
    8000555a:	c71d                	beqz	a4,80005588 <uartstart+0x80>
    8000555c:	01f7f713          	andi	a4,a5,31
    80005560:	9756                	add	a4,a4,s5
    80005562:	01874b03          	lbu	s6,24(a4)
    80005566:	0785                	addi	a5,a5,1
    80005568:	e09c                	sd	a5,0(s1)
    8000556a:	8526                	mv	a0,s1
    8000556c:	e15fb0ef          	jal	80001380 <wakeup>
    80005570:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    80005574:	609c                	ld	a5,0(s1)
    80005576:	0009b703          	ld	a4,0(s3)
    8000557a:	fcf71ce3          	bne	a4,a5,80005552 <uartstart+0x4a>
    8000557e:	100007b7          	lui	a5,0x10000
    80005582:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005584:	0007c783          	lbu	a5,0(a5)
    80005588:	70e2                	ld	ra,56(sp)
    8000558a:	7442                	ld	s0,48(sp)
    8000558c:	74a2                	ld	s1,40(sp)
    8000558e:	7902                	ld	s2,32(sp)
    80005590:	69e2                	ld	s3,24(sp)
    80005592:	6a42                	ld	s4,16(sp)
    80005594:	6aa2                	ld	s5,8(sp)
    80005596:	6b02                	ld	s6,0(sp)
    80005598:	6121                	addi	sp,sp,64
    8000559a:	8082                	ret
    8000559c:	100007b7          	lui	a5,0x10000
    800055a0:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800055a2:	0007c783          	lbu	a5,0(a5)
    800055a6:	8082                	ret

00000000800055a8 <uartputc>:
    800055a8:	7179                	addi	sp,sp,-48
    800055aa:	f406                	sd	ra,40(sp)
    800055ac:	f022                	sd	s0,32(sp)
    800055ae:	ec26                	sd	s1,24(sp)
    800055b0:	e84a                	sd	s2,16(sp)
    800055b2:	e44e                	sd	s3,8(sp)
    800055b4:	e052                	sd	s4,0(sp)
    800055b6:	1800                	addi	s0,sp,48
    800055b8:	8a2a                	mv	s4,a0
    800055ba:	0002c517          	auipc	a0,0x2c
    800055be:	21e50513          	addi	a0,a0,542 # 800317d8 <uart_tx_lock>
    800055c2:	16e000ef          	jal	80005730 <acquire>
    800055c6:	00005797          	auipc	a5,0x5
    800055ca:	c367a783          	lw	a5,-970(a5) # 8000a1fc <panicked>
    800055ce:	efbd                	bnez	a5,8000564c <uartputc+0xa4>
    800055d0:	00005717          	auipc	a4,0x5
    800055d4:	c3873703          	ld	a4,-968(a4) # 8000a208 <uart_tx_w>
    800055d8:	00005797          	auipc	a5,0x5
    800055dc:	c287b783          	ld	a5,-984(a5) # 8000a200 <uart_tx_r>
    800055e0:	02078793          	addi	a5,a5,32
    800055e4:	0002c997          	auipc	s3,0x2c
    800055e8:	1f498993          	addi	s3,s3,500 # 800317d8 <uart_tx_lock>
    800055ec:	00005497          	auipc	s1,0x5
    800055f0:	c1448493          	addi	s1,s1,-1004 # 8000a200 <uart_tx_r>
    800055f4:	00005917          	auipc	s2,0x5
    800055f8:	c1490913          	addi	s2,s2,-1004 # 8000a208 <uart_tx_w>
    800055fc:	00e79d63          	bne	a5,a4,80005616 <uartputc+0x6e>
    80005600:	85ce                	mv	a1,s3
    80005602:	8526                	mv	a0,s1
    80005604:	d31fb0ef          	jal	80001334 <sleep>
    80005608:	00093703          	ld	a4,0(s2)
    8000560c:	609c                	ld	a5,0(s1)
    8000560e:	02078793          	addi	a5,a5,32
    80005612:	fee787e3          	beq	a5,a4,80005600 <uartputc+0x58>
    80005616:	0002c497          	auipc	s1,0x2c
    8000561a:	1c248493          	addi	s1,s1,450 # 800317d8 <uart_tx_lock>
    8000561e:	01f77793          	andi	a5,a4,31
    80005622:	97a6                	add	a5,a5,s1
    80005624:	01478c23          	sb	s4,24(a5)
    80005628:	0705                	addi	a4,a4,1
    8000562a:	00005797          	auipc	a5,0x5
    8000562e:	bce7bf23          	sd	a4,-1058(a5) # 8000a208 <uart_tx_w>
    80005632:	ed7ff0ef          	jal	80005508 <uartstart>
    80005636:	8526                	mv	a0,s1
    80005638:	190000ef          	jal	800057c8 <release>
    8000563c:	70a2                	ld	ra,40(sp)
    8000563e:	7402                	ld	s0,32(sp)
    80005640:	64e2                	ld	s1,24(sp)
    80005642:	6942                	ld	s2,16(sp)
    80005644:	69a2                	ld	s3,8(sp)
    80005646:	6a02                	ld	s4,0(sp)
    80005648:	6145                	addi	sp,sp,48
    8000564a:	8082                	ret
    8000564c:	a001                	j	8000564c <uartputc+0xa4>

000000008000564e <uartgetc>:
    8000564e:	1141                	addi	sp,sp,-16
    80005650:	e422                	sd	s0,8(sp)
    80005652:	0800                	addi	s0,sp,16
    80005654:	100007b7          	lui	a5,0x10000
    80005658:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000565a:	0007c783          	lbu	a5,0(a5)
    8000565e:	8b85                	andi	a5,a5,1
    80005660:	cb81                	beqz	a5,80005670 <uartgetc+0x22>
    80005662:	100007b7          	lui	a5,0x10000
    80005666:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000566a:	6422                	ld	s0,8(sp)
    8000566c:	0141                	addi	sp,sp,16
    8000566e:	8082                	ret
    80005670:	557d                	li	a0,-1
    80005672:	bfe5                	j	8000566a <uartgetc+0x1c>

0000000080005674 <uartintr>:
    80005674:	1101                	addi	sp,sp,-32
    80005676:	ec06                	sd	ra,24(sp)
    80005678:	e822                	sd	s0,16(sp)
    8000567a:	e426                	sd	s1,8(sp)
    8000567c:	1000                	addi	s0,sp,32
    8000567e:	54fd                	li	s1,-1
    80005680:	a019                	j	80005686 <uartintr+0x12>
    80005682:	85fff0ef          	jal	80004ee0 <consoleintr>
    80005686:	fc9ff0ef          	jal	8000564e <uartgetc>
    8000568a:	fe951ce3          	bne	a0,s1,80005682 <uartintr+0xe>
    8000568e:	0002c497          	auipc	s1,0x2c
    80005692:	14a48493          	addi	s1,s1,330 # 800317d8 <uart_tx_lock>
    80005696:	8526                	mv	a0,s1
    80005698:	098000ef          	jal	80005730 <acquire>
    8000569c:	e6dff0ef          	jal	80005508 <uartstart>
    800056a0:	8526                	mv	a0,s1
    800056a2:	126000ef          	jal	800057c8 <release>
    800056a6:	60e2                	ld	ra,24(sp)
    800056a8:	6442                	ld	s0,16(sp)
    800056aa:	64a2                	ld	s1,8(sp)
    800056ac:	6105                	addi	sp,sp,32
    800056ae:	8082                	ret

00000000800056b0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800056b0:	1141                	addi	sp,sp,-16
    800056b2:	e422                	sd	s0,8(sp)
    800056b4:	0800                	addi	s0,sp,16
  lk->name = name;
    800056b6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800056b8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800056bc:	00053823          	sd	zero,16(a0)
}
    800056c0:	6422                	ld	s0,8(sp)
    800056c2:	0141                	addi	sp,sp,16
    800056c4:	8082                	ret

00000000800056c6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800056c6:	411c                	lw	a5,0(a0)
    800056c8:	e399                	bnez	a5,800056ce <holding+0x8>
    800056ca:	4501                	li	a0,0
  return r;
}
    800056cc:	8082                	ret
{
    800056ce:	1101                	addi	sp,sp,-32
    800056d0:	ec06                	sd	ra,24(sp)
    800056d2:	e822                	sd	s0,16(sp)
    800056d4:	e426                	sd	s1,8(sp)
    800056d6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800056d8:	6904                	ld	s1,16(a0)
    800056da:	e70fb0ef          	jal	80000d4a <mycpu>
    800056de:	40a48533          	sub	a0,s1,a0
    800056e2:	00153513          	seqz	a0,a0
}
    800056e6:	60e2                	ld	ra,24(sp)
    800056e8:	6442                	ld	s0,16(sp)
    800056ea:	64a2                	ld	s1,8(sp)
    800056ec:	6105                	addi	sp,sp,32
    800056ee:	8082                	ret

00000000800056f0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800056f0:	1101                	addi	sp,sp,-32
    800056f2:	ec06                	sd	ra,24(sp)
    800056f4:	e822                	sd	s0,16(sp)
    800056f6:	e426                	sd	s1,8(sp)
    800056f8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800056fa:	100024f3          	csrr	s1,sstatus
    800056fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005702:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005704:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005708:	e42fb0ef          	jal	80000d4a <mycpu>
    8000570c:	5d3c                	lw	a5,120(a0)
    8000570e:	cb99                	beqz	a5,80005724 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005710:	e3afb0ef          	jal	80000d4a <mycpu>
    80005714:	5d3c                	lw	a5,120(a0)
    80005716:	2785                	addiw	a5,a5,1
    80005718:	dd3c                	sw	a5,120(a0)
}
    8000571a:	60e2                	ld	ra,24(sp)
    8000571c:	6442                	ld	s0,16(sp)
    8000571e:	64a2                	ld	s1,8(sp)
    80005720:	6105                	addi	sp,sp,32
    80005722:	8082                	ret
    mycpu()->intena = old;
    80005724:	e26fb0ef          	jal	80000d4a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005728:	8085                	srli	s1,s1,0x1
    8000572a:	8885                	andi	s1,s1,1
    8000572c:	dd64                	sw	s1,124(a0)
    8000572e:	b7cd                	j	80005710 <push_off+0x20>

0000000080005730 <acquire>:
{
    80005730:	1101                	addi	sp,sp,-32
    80005732:	ec06                	sd	ra,24(sp)
    80005734:	e822                	sd	s0,16(sp)
    80005736:	e426                	sd	s1,8(sp)
    80005738:	1000                	addi	s0,sp,32
    8000573a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000573c:	fb5ff0ef          	jal	800056f0 <push_off>
  if(holding(lk))
    80005740:	8526                	mv	a0,s1
    80005742:	f85ff0ef          	jal	800056c6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005746:	4705                	li	a4,1
  if(holding(lk))
    80005748:	e105                	bnez	a0,80005768 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000574a:	87ba                	mv	a5,a4
    8000574c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005750:	2781                	sext.w	a5,a5
    80005752:	ffe5                	bnez	a5,8000574a <acquire+0x1a>
  __sync_synchronize();
    80005754:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005758:	df2fb0ef          	jal	80000d4a <mycpu>
    8000575c:	e888                	sd	a0,16(s1)
}
    8000575e:	60e2                	ld	ra,24(sp)
    80005760:	6442                	ld	s0,16(sp)
    80005762:	64a2                	ld	s1,8(sp)
    80005764:	6105                	addi	sp,sp,32
    80005766:	8082                	ret
    panic("acquire");
    80005768:	00002517          	auipc	a0,0x2
    8000576c:	fd850513          	addi	a0,a0,-40 # 80007740 <etext+0x740>
    80005770:	c93ff0ef          	jal	80005402 <panic>

0000000080005774 <pop_off>:

void
pop_off(void)
{
    80005774:	1141                	addi	sp,sp,-16
    80005776:	e406                	sd	ra,8(sp)
    80005778:	e022                	sd	s0,0(sp)
    8000577a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000577c:	dcefb0ef          	jal	80000d4a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005780:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005784:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005786:	e78d                	bnez	a5,800057b0 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005788:	5d3c                	lw	a5,120(a0)
    8000578a:	02f05963          	blez	a5,800057bc <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000578e:	37fd                	addiw	a5,a5,-1
    80005790:	0007871b          	sext.w	a4,a5
    80005794:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005796:	eb09                	bnez	a4,800057a8 <pop_off+0x34>
    80005798:	5d7c                	lw	a5,124(a0)
    8000579a:	c799                	beqz	a5,800057a8 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000579c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800057a0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800057a4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800057a8:	60a2                	ld	ra,8(sp)
    800057aa:	6402                	ld	s0,0(sp)
    800057ac:	0141                	addi	sp,sp,16
    800057ae:	8082                	ret
    panic("pop_off - interruptible");
    800057b0:	00002517          	auipc	a0,0x2
    800057b4:	f9850513          	addi	a0,a0,-104 # 80007748 <etext+0x748>
    800057b8:	c4bff0ef          	jal	80005402 <panic>
    panic("pop_off");
    800057bc:	00002517          	auipc	a0,0x2
    800057c0:	fa450513          	addi	a0,a0,-92 # 80007760 <etext+0x760>
    800057c4:	c3fff0ef          	jal	80005402 <panic>

00000000800057c8 <release>:
{
    800057c8:	1101                	addi	sp,sp,-32
    800057ca:	ec06                	sd	ra,24(sp)
    800057cc:	e822                	sd	s0,16(sp)
    800057ce:	e426                	sd	s1,8(sp)
    800057d0:	1000                	addi	s0,sp,32
    800057d2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800057d4:	ef3ff0ef          	jal	800056c6 <holding>
    800057d8:	c105                	beqz	a0,800057f8 <release+0x30>
  lk->cpu = 0;
    800057da:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800057de:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800057e2:	0310000f          	fence	rw,w
    800057e6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800057ea:	f8bff0ef          	jal	80005774 <pop_off>
}
    800057ee:	60e2                	ld	ra,24(sp)
    800057f0:	6442                	ld	s0,16(sp)
    800057f2:	64a2                	ld	s1,8(sp)
    800057f4:	6105                	addi	sp,sp,32
    800057f6:	8082                	ret
    panic("release");
    800057f8:	00002517          	auipc	a0,0x2
    800057fc:	f7050513          	addi	a0,a0,-144 # 80007768 <etext+0x768>
    80005800:	c03ff0ef          	jal	80005402 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
