#pragma once

// https://docs.amd.com/v/u/en-US/40332-PUB_4.08
// Volume 2 Chapter 3.1 - System-Control Registers
// 2026-02-01: Found at page 495

/*
 * CR0:
 * Used to control operating mode and states of the processor.
 * Unconditional:
 *
 * 63-32 Reserved
 * 31: Paging enable R/W
 * 30: Cache disable R/W
 * 29: Not write-through R/W
 * 28-19 Reserved
 * 18: Alignment mask R/W
 * 17: Reserved
 * 16: Write protect R/W
 * 15-6 Reserved
 * Conditional:
 *
 * 5: Numeric Error R/W
 * 4: Extension Ttype R
 * 3: Task Switched R/W
 * 2: Emulate Coprocessor R/W
 * 1: Monitor Coprocessor R/W
 * 0: Protection Enable R/W
 */

#define CR_BIT(bit) (1UL << (bit))
#define CR0_PE CR_BIT(0)
#define CR0_MP CR_BIT(1)
#define CR0_EM CR_BIT(2)
#define CR0_TS CR_BIT(3)
#define CR0_NE CR_BIT(5)
#define CR0_WP CR_BIT(16)
#define CR0_AM CR_BIT(18)
#define CR0_NW CR_BIT(29)
#define CR0_CD CR_BIT(30)
#define CR0_PG CR_BIT(31)

/*
 * CR2:
 * Used to represent the address that caused a page fault.
 * 63-0: Page-fault linear address
 */

/*
 * CR3 Legacy-Mode PAE:
 * Holds the physical address of the base of the PAE page directory pointer table.
 * 31-5: Page Directory Pointer Table Base Address
 * 4: Page Cache Disable R/W
 * 3: Page Write-Through R/W
 * 2-0: Reserved

 * CR3 Long-Mode:
 * Holds the physical address of the base of the PML4 table.
 * 63-12: PML4 Table Base Address R/W
 * 11-5: Reserved
 * 4: Page Cache Disable R/W
 * 3: Page Write-Through R/W
 * 2-0: Reserved
*/

#define CR3_PWT CR_BIT(3)
#define CR3_PCD CR_BIT(4)

/*
 * CR4:
 * Used to enable several architectural extensions.
 * 63-32: Reserved
 * 31-24: Reserved
 * 23: Control Flow Enforcement Enable R/W
 * 22: Protection Key enable R/W
 * 21: Supervisor Mode Access Protection R/W
 * 20: Supervisor Mode Execution Protection R/W
 * 19: Reserved
 * 18: XSave and Processor Extended States Enable R/W
 * 17: Process Context Identifier Enable R/W
 * 16: Enable RDFSBASE, RDGSBASE, WRFSBASE, and WRGSBASE instructions R/W
 * 15-13: Reserved
 * 12: Enable 5-Layer Paging R/W
 * 11: User Mode Instruction Prevention R/W
 * 10: Operating System Unmasked Exception Support R/W
 * 9: Operating System FXSAVE/FXRSTOR Support R/W
 * 8: Performance-Monitoring Counter Enable R/W
 * 7: Page-Global Enable R/W
 * 6: Machine-Check Enable R/W
 * 5: Physical Address Extension R/W
 * 4: Page Size Extension R/W
 * 3: Debugging Extensions R/W
 * 2: Time Stamp Disable R/W
 * 1: Protected Mode Virtual Interrupts R/W
 * 0: Virtual-8086 Mode Extensions R/W
 */

#define CR4_VME CR_BIT(0)
#define CR4_PVI CR_BIT(1)
#define CR4_TSD CR_BIT(2)
#define CR4_DE CR_BIT(3)
#define CR4_PSE CR_BIT(4)
#define CR4_PAE CR_BIT(5)
#define CR4_MCE CR_BIT(6)
#define CR4_PGE CR_BIT(7)
#define CR4_PCE CR_BIT(8)
#define CR4_OSFXSR CR_BIT(9)
#define CR4_OSXMMEXCPT CR_BIT(10)
#define CR4_VMXE CR_BIT(13)
#define CR4_SMXE CR_BIT(14)
#define CR4_PCIDE CR_BIT(17)
#define CR4_OSXSAVE CR_BIT(18)
#define CR4_SMEP CR_BIT(20)
#define CR4_SMAP CR_BIT(21)
#define CR4_PKE CR_BIT(22)
#define CR4_CET CR_BIT(23)

/*
 * EFER:
 * Extended Feature Enable Register
 * 63-32: Reserved
 * 31-22: Reserved
 * 21: Automatic IBRS Enable R/W
 * 20: Upper Address Ignore Enable R/W
 * 19: Reserved
 * 18: Interrupt WBINVD/WBNOINVD enable R/W
 * 17: Enable MCOMMIT Instructions R/W
 * 16: Reserved
 * 15: Translaction Cache Extension R/W
 * 14: Fast FXSAVE/FXRSTOR R/W
 * 13: Long Mode Segment Limit Enable R/W
 * 12: Secure Virtual Machine Enable R/W
 * 11: No-Execute Enable R/W
 * 10: Long Mode Active R/W
 * 9: Reserved
 * 8: Long Mode Enable R/W
 * 7-1: Reserved
 * 0: System Call Extensions Enable R/W
 */

#define EFER_SCE CR_BIT(0)
#define EFER_LME CR_BIT(8)
#define EFER_LMA CR_BIT(10)
#define EFER_NXE CR_BIT(11)
#define EFER_SVM CR_BIT(12)
#define EFER_LMSLE CR_BIT(13)
#define EFER_FFXSR CR_BIT(14)
#define EFER_TCE CR_BIT(15)
#define EFER_MCOMMIT CR_BIT(17)
#define EFER_WBINVD CR_BIT(18)
#define EFER_UAI CR_BIT(20)
#define EFER_AIBRS CR_BIT(21)

/*
 * MSR's
 * Model-Specific Registers selectors
 * https://en.wikipedia.org/wiki/Control_register
 * 0xC0000080: EFER
 */

#define MSR_EFER 0xC0000080

/*
 * CPUID
 * https://docs.amd.com/v/u/en-US/40332-PUB_4.08
 * 2026-02-02: Appendix D.2 page 1874
 *
 * Standard: 0000_0001h,
 * Extended: 8000_0001h
 * Structured Extended: 8000_0007h
 */

#define CPUID_FUNCTION_STANDARD 0x00000001
#define CPUID_FUNCTION_EXTENDED 0x80000001
#define CPUID_FUNCTION_STRUCTURED_EXTENDED 0x80000007

/*
 * CPUID Extended EDX
 * Bit 29: Long Mode
 */

#define CPUID_FUNCTION_EXTENDED_LM 29