include "stdint.h"



#ifdef __cplusplus
  #define   __I     volatile             /*!< Defines 'read only' permissions */
#else
  #define   __I     volatile const       /*!< Defines 'read only' permissions */
#endif

#define     __O     volatile             /*!< Defines 'write only' permissions */
#define     __IO    volatile             /*!< Defines 'read / write' permissions */

/* following defines should be used for structure members */
#define     __IM     volatile const      /*! Defines 'read only' structure member permissions */
#define     __OM     volatile            /*! Defines 'write only' structure member permissions */
#define     __IOM    volatile            /*! Defines 'read / write' structure member permissions */



#define __NVIC_PRIO_BITS 2
#define __MPU_PRESENT    0
#define __Vendor_SysTickConfig 1


#define GPCFG_BASE  0x40020000
#define GPIO_BASE   0x40030000


#define GPCFG_UARTMTXPADCTL  (*(unit32_t *) (GPCFG_BASE + 0x0000))
#define GPCFG_UARTMRXPADCTL  (*(unit32_t *) (GPCFG_BASE + 0x0004))
#define GPCFG_UARTSTXPADCTL  (*(unit32_t *) (GPCFG_BASE + 0x0008))
#define GPCFG_UARTSRXPADCTL  (*(unit32_t *) (GPCFG_BASE + 0x000C))
#define GPCFG_GPIO0PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x0010))
#define GPCFG_GPIO1PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x0014))
#define GPCFG_GPIO2PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x0018))
#define GPCFG_GPIO3PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x001C))
#define GPCFG_PAD11PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x0020))
#define GPCFG_PAD12PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x0024))
#define GPCFG_PAD13PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x0028))
#define GPCFG_PAD14PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x002c))
#define GPCFG_PAD15PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x0030))
#define GPCFG_PAD16PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x0034))
#define GPCFG_PAD17PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x0038))
#define GPCFG_PAD18PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x003c))
#define GPCFG_PAD19PADCTL    (*(unit32_t *) (GPCFG_BASE + 0x0040))

//Bits in GPCG_*PADCTL
#define  PADOEN      (1U << 0)      //0 = > Output enabled, 1 => HiZ,pull up or pull down depends on pull setting
#define  PADRXEN     (1U << 1)      //0 = > Input disabled, 1 => Input Enabled
#define  PADPULL0    (1U << 2)      //00 => HiZ, 01 => Pull Up, 10 => Pull down, 11 => Repeater
#define  PADPULL1    (1U << 3)      //00 => HiZ, 01 => Pull Up, 10 => Pull down, 11 => Repeater
#define  PADPULL2    (1U << 2)      //00 => HiZ, 01 => Pull Up, 10 => Pull down, 11 => Repeater
#define  PADDRIVE0   (1U << 4)      //00 => 2mA, 01 => 4mA,     10 => 8mA,       11 => 12mA
#define  PADDRIVE1   (1U << 4)      //00 => 2mA, 01 => 4mA,     10 => 8mA,       11 => 12mA
#define  PADSCHMITT  (1U << 6)      //0  => Scmitt Disabled.       1 => Enabled
#define  PADSLEW     (1U << 7)      //0  => Slow (half frequency). 1 => Fast
#define  PADPOSCTL   (1U << 8)      //0  => PAD is in hig-Z due to loss of core power. 
                                   //1  => PAD is pulled down. This happens when core supply is not there.
#define  ALTFUNCSEL0  (1U << 16)   //
#define  ALTFUNCSEL1  (1U << 17)   //
#define  ALTFUNCGPIO  (1U << 24)   //

#define GPCFG_UARTMBAUDCTL   (*(unit32_t *) (GPCFG_BASE + 0x0044))  //Value with which HCLK (24 Mhz) should be divided to get UARTM BAUD 
#define GPCFG_UARTSBAUDCTL   (*(unit32_t *) (GPCFG_BASE + 0x0088))

#define  GPCFG_UARTMCTL     (*(unit32_t *) (GPCFG_BASE + 0x0048))
#define  GPCFG_UARTSCTL     (*(unit32_t *) (GPCFG_BASE + 0x008c))
#define  UARTMDWIDTH0       (1U << 0)     //00 => 1 byte, 01 => 2 byte, 10 => 4 byte, 11 => 1 byte
#define  UARTMDWIDTH1       (1U << 1)     //00 => 1 byte, 01 => 2 byte, 10 => 4 byte, 11 => 1 byte
#define  UARTMPARTEN        (1U << 2)     //0  => No Parity,  1 => Parity Enabled
#define  UARTMPARTYP        (1U << 3)     //0  => Odd parity, 1 => Even Parity 


#define GPCFG_UARTSTXDATA    (*(unit32_t *) (GPCFG_BASE + 0x0090))
#define GPCFG_UARTSRXDATA    (*(unit32_t *) (GPCFG_BASE + 0x0094))
#define GPCFG_UARTSTXSEND    (*(unit32_t *) (GPCFG_BASE + 0x0098))

#define GPCFG_SPADDR         (*(unit32_t *) (GPCFG_BASE + 0x004c))   //Stack Pointer address for Cortex M0
#define GPCFG_RESETADDR      (*(unit32_t *) (GPCFG_BASE + 0x0050))   //Reset address for Cortex M0
#define GPCFG_NMIADDR        (*(unit32_t *) (GPCFG_BASE + 0x0054))   //Address where the NMI handler is stored
#define GPCFG_FAULTADDR      (*(unit32_t *) (GPCFG_BASE + 0x0058))   //Address where Exception handler is stored
#define GPCFG_IRQ0ADDR       (*(unit32_t *) (GPCFG_BASE + 0x005c))   //Address where IRQ0 handler is stored
#define GPCFG_IRQ1ADDR       (*(unit32_t *) (GPCFG_BASE + 0x0060))   //Address where IRQ1 handler is stored
#define GPCFG_IRQ2ADDR       (*(unit32_t *) (GPCFG_BASE + 0x0064))   //Address where IRQ2 handler is stored
#define GPCFG_IRQ3ADDR       (*(unit32_t *) (GPCFG_BASE + 0x0068))   //Address where IRQ3 handler is stored

#define GPCFG_GPTEN    (*(unit32_t *) (GPCFG_BASE + 0x006c))
#define GPTIMAEN         (1U << 0)
#define GPTIMARST        (1U << 1)
#define GPTIMBEN         (1U << 8)
#define GPTIMBRST        (1U << 9)
#define GPTIMCEN         (1U << 16)
#define GPTIMCRST        (1U << 17)

#define GPCFG_GPTACFG        (*(unit32_t *) (GPCFG_BASE + 0x0070))
#define GPCFG_GPTBCFG        (*(unit32_t *) (GPCFG_BASE + 0x0074))
#define GPCFG_GPTCCFG        (*(unit32_t *) (GPCFG_BASE + 0x0078))
#define GPCFG_WDTCFG         (*(unit32_t *) (GPCFG_BASE + 0x0080))
#define GPCFG_WDTNMICFG      (*(unit32_t *) (GPCFG_BASE + 0x0084)) //No PREDIV for NMI CFG
#define GPTCOUNT             (0xFFFFU << 0)
#define GPTPREDIV            (0XFFFFU << 16)   

#define GPCFG_WDTEN   (*(unit32_t *) (GPCFG_BASE + 0x007c))
#define WDEN          (1U << 0)
#define WDRST         (1U << 1)

#define GPCFG_SPARE0          (*(unit32_t *) (GPCFG_BASE + 0x009c))
#define GPCFG_PWMVAL0         (*(unit32_t *) (GPCFG_BASE + 0x00a0))
#define GPCFG_PWMVAL1         (*(unit32_t *) (GPCFG_BASE + 0x00a4))
#define GPCFG_SPARE1          (*(unit32_t *) (GPCFG_BASE + 0x00a8))
#define GPCFG_KEYREG0         (*(unit32_t *) (GPCFG_BASE + 0x00ac))
#define GPCFG_KEYREG1         (*(unit32_t *) (GPCFG_BASE + 0x00b0))
#define GPCFG_KEYREG2         (*(unit32_t *) (GPCFG_BASE + 0x00b4))
#define GPCFG_KEYREG3         (*(unit32_t *) (GPCFG_BASE + 0x00b8))
#define GPCFG_KEYREG4         (*(unit32_t *) (GPCFG_BASE + 0x00bc))
#define GPCFG_KEYREG5         (*(unit32_t *) (GPCFG_BASE + 0x00c0))
#define GPCFG_KEYREG6         (*(unit32_t *) (GPCFG_BASE + 0x00c4))
#define GPCFG_KEYREG7         (*(unit32_t *) (GPCFG_BASE + 0x00c8))
#define GPCFG_SIGNATURE       (*(unit32_t *) (GPCFG_BASE + 0x00cc))

#define GPCFG_IRQ4ADDR       (*(unit32_t *) (GPCFG_BASE + 0x00d0))   //Address where IRQ4 handler is stored
#define GPCFG_IRQ5ADDR       (*(unit32_t *) (GPCFG_BASE + 0x00d4))   //Address where IRQ5 handler is stored
#define GPCFG_IRQ6ADDR       (*(unit32_t *) (GPCFG_BASE + 0x00d8))   //Address where IRQ6 handler is stored
#define GPCFG_IRQ7ADDR       (*(unit32_t *) (GPCFG_BASE + 0x00dc))   //Address where IRQ7 handler is stored
#define GPCFG_IRQ8ADDR       (*(unit32_t *) (GPCFG_BASE + 0x00e0))   //Address where IRQ8 handler is stored
#define GPCFG_IRQ9ADDR       (*(unit32_t *) (GPCFG_BASE + 0x00e4))   //Address where IRQ9 handler is stored
#define GPCFG_IRQ10ADDR      (*(unit32_t *) (GPCFG_BASE + 0x00e8))   //Address where IRQ10 handler is stored
#define GPCFG_IRQ11ADDR      (*(unit32_t *) (GPCFG_BASE + 0x00ec))   //Address where IRQ11 handler is stored
#define GPCFG_IRQ12ADDR      (*(unit32_t *) (GPCFG_BASE + 0x00f0))   //Address where IRQ12 handler is stored
#define GPCFG_IRQ13ADDR      (*(unit32_t *) (GPCFG_BASE + 0x00f4))   //Address where IRQ13 handler is stored
#define GPCFG_IRQ14ADDR      (*(unit32_t *) (GPCFG_BASE + 0x00f8))   //Address where IRQ14 handler is stored
#define GPCFG_IRQ15ADDR      (*(unit32_t *) (GPCFG_BASE + 0x00fc))   //Address where IRQ15 handler is stored


#define GPIO_GPIO0CTL         (*(unit32_t *) (GPIO_BASE  + 0x0000))
#define GPIO_GPIO1CTL         (*(unit32_t *) (GPIO_BASE  + 0x000c))
#define GPIO_GPIO2CTL         (*(unit32_t *) (GPIO_BASE  + 0x0018))
#define GPIO_GPIO3CTL         (*(unit32_t *) (GPIO_BASE  + 0x0024))
#define GPIOIRQEN             (1U << 0)  //0 => No interrupt on any corresponding gpio toggle. 1 => Interrupt on corresponding GPIO toggle. Toggle bit detemined by IRQEDGE
#define GPIOIRQEDGE           (1U << 1)  //0 => Interrupt when GPIO toggles from 0 to 1. 1 => Interrupt when GPIO toggles from 1 to 0

#define GPIO_GPIO0OUT         (*(unit32_t *) (GPIO_BASE  + 0x0004))
#define GPIO_GPIO1OUT         (*(unit32_t *) (GPIO_BASE  + 0x0010))
#define GPIO_GPIO2OUT         (*(unit32_t *) (GPIO_BASE  + 0x001c))
#define GPIO_GPIO3OUT         (*(unit32_t *) (GPIO_BASE  + 0x0028))
#define GPIOOUT               (1U << 0)

#define GPIO_GPIO0IN          (*(unit32_t *) (GPIO_BASE  + 0x0008))
#define GPIO_GPIO1IN          (*(unit32_t *) (GPIO_BASE  + 0x0014))
#define GPIO_GPIO2IN          (*(unit32_t *) (GPIO_BASE  + 0x0020))
#define GPIO_GPIO3IN          (*(unit32_t *) (GPIO_BASE  + 0x002c))





//------------------------------
/*Struct for each peripherals */
//-----------------------------
typedef struct {
 __IO uint32_t UARTMTXPADCTL;
 __IO uint32_t UARTMRXPADCTL;
 __IO uint32_t UARTSTXPADCTL;
 __IO uint32_t UARTSRXPADCTL;
 __IO uint32_t GPIO0PADCTL;
 __IO uint32_t GPIO1PADCTL;
 __IO uint32_t GPIO2PADCTL;
 __IO uint32_t GPIO3PADCTL;
 __IO uint32_t PAD11PADCTL;
 __IO uint32_t PAD12PADCTL;
 __IO uint32_t PAD13PADCTL;
 __IO uint32_t PAD14PADCTL;
 __IO uint32_t PAD15PADCTL;
 __IO uint32_t PAD16PADCTL;
 __IO uint32_t PAD17PADCTL;
 __IO uint32_t PAD18PADCTL;
 __IO uint32_t PAD19PADCTL;
 __IO uint32_t UARTMBAUDCTL;
 __IO uint32_t UARTMCTL;
 __IO uint32_t SPADDR;
 __IO uint32_t RESETADDR;
 __IO uint32_t NMIADDR;
 __IO uint32_t FAULTADDR;
 __IO uint32_t IRQ0ADDR;
 __IO uint32_t IRQ1ADDR;
 __IO uint32_t IRQ2ADDR;
 __IO uint32_t IRQ3ADDR;
 __IO uint32_t GPTEN;
 __IO uint32_t GPTACFG;
 __IO uint32_t GPTBCFG;
 __IO uint32_t GPTCCFG;
 __IO uint32_t WDTEN;
 __IO uint32_t WDTCFG;
 __IO uint32_t WDTNMICFG;
 __IO uint32_t UARTSBAUDCTL;
 __IO uint32_t UARTSCTL;
 __IO uint32_t UARTSTXDATA;
 __IO uint32_t UARTSRXDATA;
 __IO uint32_t UARTSTXSEND;
 __IO uint32_t SPARE0;
 __IO uint32_t PWMVAL0;
 __IO uint32_t PWMVAL1;
 __IO uint32_t SPARE1;
 __O  uint32_t KEYREG0;
 __O  uint32_t KEYREG1;
 __O  uint32_t KEYREG2;
 __O  uint32_t KEYREG3;
 __O  uint32_t KEYREG4;
 __O  uint32_t KEYREG5;
 __O  uint32_t KEYREG6;
 __O  uint32_t KEYREG7;
 __O  uint32_t SIGNATURE;
 __IO uint32_t IRQ4ADDR;
 __IO uint32_t IRQ5ADDR;
 __IO uint32_t IRQ6ADDR;
 __IO uint32_t IRQ7ADDR;
 __IO uint32_t IRQ8ADDR;
 __IO uint32_t IRQ9ADDR;
 __IO uint32_t IRQ10ADDR;
 __IO uint32_t IRQ11ADDR;
 __IO uint32_t IRQ12ADDR;
 __IO uint32_t IRQ13ADDR;
 __IO uint32_t IRQ14ADDR;
 __IO uint32_t IRQ15ADDR;
} GPCFG_TYPE;

typedef struct {
  __IO uint32_t GPIO0CTL;
  __IO uint32_t GPIO0OUT;
  __I  uint32_t GPIO0IN;
  __IO uint32_t GPIO1CTL;
  __IO uint32_t GPIO1OUT;
  __I  uint32_t GPIO1IN;
  __IO uint32_t GPIO2CTL;
  __IO uint32_t GPIO2OUT;
  __I  uint32_t GPIO2IN;
  __IO uint32_t GPIO3CTL;
  __IO uint32_t GPIO3OUT;
  __I  uint32_t GPIO3IN;
} GPIO_TYPE;

typedef struct {
   __I  uint32_t SYSROM[2048];
   __IO uint32_t SYSRAM[14336];
} SYSRAM_TYPE;


//---------------------------
/* Peripheral Declaration */
//---------------------------
#define GPCFG   ((GPCFG_TYPE  *)  GPCFG_BASE)
#define GPIO    ((GPIO_TYPE   *)  GPIO_BASE)
#define SYSRAM  ((SYSRAM_TYPE *)  SYSRAM_BASE)



