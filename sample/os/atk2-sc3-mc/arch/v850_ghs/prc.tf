$
$  TOPPERS ATK2
$      Toyohashi Open Platform for Embedded Real-Time Systems
$      Automotive Kernel Version 2
$
$  Copyright (C) 2012-2014 by Center for Embedded Computing Systems
$              Graduate School of Information Science, Nagoya Univ., JAPAN
$  Copyright (C) 2012-2013 by FUJISOFT INCORPORATED, JAPAN
$  Copyright (C) 2012-2013 by FUJITSU VLSI LIMITED, JAPAN
$  Copyright (C) 2012-2013 by NEC Communication Systems, Ltd., JAPAN
$  Copyright (C) 2012-2013 by Panasonic Advanced Technology Development Co., Ltd., JAPAN
$  Copyright (C) 2012-2013 by Renesas Electronics Corporation, JAPAN
$  Copyright (C) 2012-2013 by Sunny Giken Inc., JAPAN
$  Copyright (C) 2012-2013 by TOSHIBA CORPORATION, JAPAN
$  Copyright (C) 2012-2013 by Witz Corporation, JAPAN
$  Copyright (C) 2013 by Embedded and Real-Time Systems Laboratory
$              Graduate School of Information Science, Nagoya Univ., JAPAN
$
$  上記著作権者は，以下の(1)〜(4)の条件を満たす場合に限り，本ソフトウェ
$  ア（本ソフトウェアを改変したものを含む．以下同じ）を使用・複製・改
$  変・再配布（以下，利用と呼ぶ）することを無償で許諾する．
$  (1) 本ソフトウェアをソースコードの形で利用する場合には，上記の著作
$      権表示，この利用条件および下記の無保証規定が，そのままの形でソー
$      スコード中に含まれていること．
$  (2) 本ソフトウェアを，ライブラリ形式など，他のソフトウェア開発に使
$      用できる形で再配布する場合には，再配布に伴うドキュメント（利用
$      者マニュアルなど）に，上記の著作権表示，この利用条件および下記
$      の無保証規定を掲載すること．
$  (3) 本ソフトウェアを，機器に組み込むなど，他のソフトウェア開発に使
$      用できない形で再配布する場合には，次のいずれかの条件を満たすこ
$      と．
$    (a) 再配布に伴うドキュメント（利用者マニュアルなど）に，上記の著
$        作権表示，この利用条件および下記の無保証規定を掲載すること．
$    (b) 再配布の形態を，別に定める方法によって，TOPPERSプロジェクトに
$        報告すること．
$  (4) 本ソフトウェアの利用により直接的または間接的に生じるいかなる損
$      害からも，上記著作権者およびTOPPERSプロジェクトを免責すること．
$      また，本ソフトウェアのユーザまたはエンドユーザからのいかなる理
$      由に基づく請求からも，上記著作権者およびTOPPERSプロジェクトを
$      免責すること．
$
$  本ソフトウェアは，AUTOSAR（AUTomotive Open System ARchitecture）仕
$  様に基づいている．上記の許諾は，AUTOSARの知的財産権を許諾するもので
$  はない．AUTOSARは，AUTOSAR仕様に基づいたソフトウェアを商用目的で利
$  用する者に対して，AUTOSARパートナーになることを求めている．
$
$  本ソフトウェアは，無保証で提供されているものである．上記著作権者お
$  よびTOPPERSプロジェクトは，本ソフトウェアに関して，特定の使用目的
$  に対する適合性も含めて，いかなる保証も行わない．また，本ソフトウェ
$  アの利用により直接的または間接的に生じたいかなる損害に関しても，そ
$  の責任を負わない．
$
$  $Id: prc.tf 189 2015-06-26 01:54:57Z t_ishikawa $
$

$
$     パス2のアーキテクチャ依存テンプレート（V850用）
$

$ 
$  kernel/kernel.tf のターゲット依存部
$ 

$ 
$  標準のセクションに関する定義
$  DSEC.ORDER_LIST：IDのリスト
$ 
$DSEC.ORDER_LIST = RANGE(0,7)$

$ 
$  ユーザスタック領域を確保するコードを出力する
$  ARGV[1]：タスクID
$  ARGV[2]：スタックサイズ
$ 
$FUNCTION ALLOC_USTACK$
    StackType _kernel_ustack_$ARGV[1]$[COUNT_STK_T($ARGV[2]$)]
    $SPC$__attribute__((section($FORMAT("\".user_stack.%s\"", ARGV[1])$)));$NL$

    $TSK.TINIB_USTKSZ[ARGV[1]] = VALUE(FORMAT("ROUND_STK_T(%s)", ARGV[2]), +ARGV[2])$
    $TSK.TINIB_USTK[ARGV[1]] = FORMAT("_kernel_ustack_%s", ARGV[1])$
$END$

$ 
$  ユーザスタック領域のセクション名を返す
$  ARGV[1]：タスクID
$ 
$FUNCTION SECTION_USTACK$
    $RESULT = FORMAT(".user_stack.%s", ARGV[1])$
$END$

$
$  ユーザスタックのアライメント制約に合わせたサイズを返す
$  ARGV[1]：スタックサイズ（アライン前）
$  kernel.tfから呼ばれる
$
$FUNCTION USTACK_ALIGN_SIZE$
	$RESULT = (ARGV[1] + CHECK_USTKSZ_ALIGN - 1) & ~(CHECK_USTKSZ_ALIGN - 1)$
$END$

$
$  基本タスクの共有スタックの確保
$  ARGV[1]：共有スタック名
$  ARGV[2]：共有スタックID(タスク優先度)
$  ARGV[3]：スタックサイズ(アライメント調整済み)
$  kernel.tfから呼ばれる
$
$FUNCTION ALLOC_SHARED_USTACK$
	StackType $ARGV[1]$[COUNT_STK_T(ROUND_STK_T($ARGV[3]$))]
	$SPC$__attribute__((section($FORMAT("\".shared_user_stack.%s\"", ARGV[2])$)));$NL$
$END$

$
$  基本タスクの共有スタックのセクション名
$  ARGV[1]：共有スタックID(タスク優先度)
$  kernel.tfから呼ばれる
$
$FUNCTION SECTION_SHARED_USTACK$
	$RESULT = FORMAT(".shared_user_stack.%s", ARGV[1])$
$END$

$ 
$  定数領域をROMに置くための定数宣言
$  データセクションの初期化をする前に参照される定数は
$  すべてROMに配置する必要がある
$  ARGV[1]：定数の型
$  ARGV[2]：定数のラベル名
$  kernel.tfから呼ばれる
$ 
$FUNCTION DEFINE_CONST_VAR$
    $ARGV[1]$$SPC$__attribute__((section(".rodata_kernel"), aligned(4)))$SPC$$ARGV[2]$$SPC$
$END$

$
$  コア標準メモリリージョンに配置するbssセクション名
$  OS内データをローカルメモリに配置する際に使用される
$  ARGV[1] : CORE ID
$  kernel.tfから呼ばれる
$
$FUNCTION CORE_LOCAL_MEM_SECTION$
	$IF LENGTH(ARGV[1])$
		$RESULT = FORMAT("._kernel_core%1%_obj", +ARGV[1])$
	$ELSE$
		$RESULT = ""$
	$END$
$END$

$
$  コア標準メモリリージョンに配置するシステムスタック用セクション名
$  OS内データをローカルメモリに配置する際に使用される
$  ARGV[1] : CORE ID
$  kernel.tfから呼ばれる
$
$FUNCTION CORE_LOCAL_MEM_SSTACK_SECTION$
	$IF LENGTH(ARGV[1])$
		$RESULT = FORMAT("._kernel_core%1%_prsv_kernel", +ARGV[1])$
	$ELSE$
		$RESULT = FORMAT(".prsv_kernel")$
	$END$
$END$



$ 
$  OSAP初期化コンテキストブロックのための宣言
$ 
$FUNCTION PREPARE_OSAPINICTXB$
$   データセクション初期化テーブルをROMに配置する
$   rosdata領域はRAMに配置されるため，データセクション初期化テーブルをsdata化すると
$   データセクションの初期化に失敗する
    extern const uint32 __attribute__((section(".rodata_kernel"), aligned(4))) tnum_datasec;$NL$
    extern const DATASECINIB __attribute__((section(".rodata_kernel"), aligned(4))) datasecinib_table[];$NL$
    extern const uint32 __attribute__((section(".rodata_kernel"), aligned(4))) tnum_bsssec;$NL$
    extern const BSSSECINIB __attribute__((section(".rodata_kernel"), aligned(4))) bsssecinib_table[];$NL$
$END$

$FUNCTION ASM_MACRO$
	.macro $ARGV[1]$ $ARGV[2]$
$END$

$INCLUDE "arch/v850_gcc/prc_common.tf"$

$IF __v850e2v3__$

$
$ 割込みベクタと各割込み入口処理
$

$FILE "Os_Lcfg.c"$

$
$ ベクタテーブル(例外要因全てを作成）)
$
$E_OS_PROTECTION_MEMORY = 14$
$E_OS_PROTECTION_EXCEPTION = 22$

extern void _reset(void) __attribute__((section (".vector")));$NL$
void$NL$
_reset(void)$NL$
{$NL$
$
$ ベクタテーブル(リセット)
$
	$TAB$Asm(".extern ___start");$NL$
	$TAB$Asm("jr __start");
	$FORMAT(" /* Exception 0x%x */", 0)$$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
$
$ ベクタテーブル(例外 No1-7)
$
$ 例外 No1
    $TAB$Asm("ldsr  r2, eiwr        /* 0x00: eiwr */");$NL$
	$TAB$Asm("movea $E_OS_PROTECTION_EXCEPTION$, r0, r2");$NL$
	$TAB$Asm("jr _fe_exception_entry");
	$FORMAT(" /* Exception 0x%x */", 1)$$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
$ 例外 No2
    $TAB$Asm("ldsr  r2, eiwr        /* 0x00: eiwr */");$NL$
	$TAB$Asm("movea $E_OS_PROTECTION_EXCEPTION$, r0, r2");$NL$
	$TAB$Asm("jr _fe_exception_entry");
	$FORMAT(" /* Exception 0x%x */", 2)$$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
$ 例外 No3
    $TAB$Asm("ldsr  r2, eiwr        /* 0x00: eiwr */");$NL$
	$TAB$Asm("movea $E_OS_PROTECTION_MEMORY$, r0, r2");$NL$
	$TAB$Asm("jr _fe_exception_entry");
	$FORMAT(" /* Exception 0x%x */", 3)$$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
$ 例外 No4
    $TAB$Asm("ldsr  r2, eiwr        /* 0x00: eiwr */");$NL$
	$TAB$Asm("movea $E_OS_PROTECTION_EXCEPTION$, r0, r2");$NL$
	$TAB$Asm("jr _ei_exception_entry");
	$FORMAT(" /* Exception 0x%x */", 4)$$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
$ 例外 No5
    $TAB$Asm("ldsr  r2, eiwr        /* 0x00: eiwr */");$NL$
	$TAB$Asm("movea $E_OS_PROTECTION_EXCEPTION$, r0, r2");$NL$
	$TAB$Asm("jr _fe_exception_entry");
	$FORMAT(" /* Exception 0x%x */", 5)$$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
$ 例外 No6
	$TAB$Asm("nop");
	$FORMAT(" /* Exception 0x%x */", 6)$$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$
$ 例外 No7
    $TAB$Asm("ldsr  r2, eiwr        /* 0x00: eiwr */");$NL$
	$TAB$Asm("movea $E_OS_PROTECTION_EXCEPTION$, r0, r2");$NL$
	$TAB$Asm("jr _fe_exception_entry");
	$FORMAT(" /* Exception 0x%x */", 7)$$NL$
	$TAB$Asm("nop");$NL$
	$TAB$Asm("nop");$NL$



$
$ ベクタテーブル(EIレベル マスカブル割込み用(8-255)
$
$FOREACH intno INTNO_VALID$
$TAB$/* $FORMAT("0x%x",intno*16 + 0x80)$ */ $NL$
	$isrid = INT.ISRID[intno]$
	$IF LENGTH(isrid)$
		$IF EQ(ISR.CATEGORY[isrid], "CATEGORY_2")$
            $TAB$Asm("ldsr  r2, eiwr        /* 0x00: eiwr */");$NL$
            $TAB$Asm("movea $intno$, r0, r2 /* 0x06: r2 = intno */");$NL$ 
            $TAB$Asm("jr    _interrupt      /* 0x0A */");$NL$
            $TAB$Asm("nop                   /* 0x0E */");$NL$
            $TAB$Asm("nop                   /* 0x0E */");$NL$
		$ELSE$
			$TAB$Asm("jr _$ISR.INT_ENTRY[isrid]$");$NL$
			$TAB$Asm("nop");$NL$
			$TAB$Asm("nop");$NL$
			$TAB$Asm("nop");$NL$
			$TAB$Asm("nop");$NL$
			$TAB$Asm("nop");$NL$
			$TAB$Asm("nop");$NL$
		$END$
	$ELSE$
$		// 割込みハンドラの登録がない場合
		$TAB$Asm("jr _default_int_handler");$NL$
 		$TAB$Asm("nop");$NL$
 		$TAB$Asm("nop");$NL$
		$TAB$Asm("nop");$NL$
		$TAB$Asm("nop");$NL$
		$TAB$Asm("nop");$NL$
		$TAB$Asm("nop");$NL$
	$END$
$END$
}$NL$
$END$
$ =end IF __v850e2v3__

$IF __v850e3v5__$

$
$ テーブル参照方式用ベクタテーブル(v850e3v5)
$

$FOREACH coreid RANGE(0, TMAX_COREID)$

$	// ハードウェア上の割込み番号毎にC1ISRの関数名を取得する

$	// "interrupt"で初期化
$int_init = {}$
$FOREACH intno INTNO_VALID$
	$IF ((intno & 0xffff0000) == ((coreid+1) << 16))$
		$int_init = APPEND(int_init, VALUE("interrupt", intno))$

	$END$
$END$
$FOREACH intno INTNO_VALID$
	$IF ((intno & 0xffff0000) == 0xffff0000)$
		$int_init = APPEND(int_init, VALUE("interrupt", intno))$
	$END$
$END$

$int_handler = {}$
$FOREACH inthdr int_init$
	$c1isr_cnt = 0$
	$intno = inthdr$
	$isrid = INT.ISRID[intno]$
	$IF LENGTH(isrid) && EQ(ISR.CATEGORY[isrid], "CATEGORY_1") && (OSAP.CORE[ISR.OSAPID[isrid]] == coreid)$
		$c1isr_cnt = c1isr_cnt + 1$
		$c1isr_info = VALUE(ISR.INT_ENTRY[isrid], +inthdr)$
	$END$

	$IF c1isr_cnt == 0$
		$int_handler = APPEND(int_handler, VALUE("interrupt", +inthdr))$
	$ELIF c1isr_cnt == 1$
		$int_handler = APPEND(int_handler, c1isr_info)$
	$ELSE$
		$ERROR$$FORMAT(_("intno:%1% is conflicted"), +inthdr)$$END$
	$END$
$END$

extern void interrupt(void);$NL$
const uint32 __attribute__((aligned(512))) core$coreid$_intbp_tbl[TNUM_INT] = {$NL$
$JOINEACH inthdr int_handler "\n"$
	$TAB$(uint32)&$inthdr$
$	//カンマの出力（最後の要素の後ろに出力しない）
		$IF (inthdr & 0xffff) < TMAX_INTNO$
			,
		$END$
	$TAB$$FORMAT("/* 0x%x */", +inthdr)$
$END$
$NL$};$NL$

$END$

$NL$
const uint32 intbp_table[TotalNumberOfCores] = {$NL$
$JOINEACH coreid RANGE(0, TMAX_COREID) ",\n"$
	$TAB$(const uint32) core$coreid$_intbp_tbl
$END$
$NL$};
$NL$

$END$

$ 
$  arch/gcc/ldscript.tfのターゲット依存部
$ 

$FUNCTION GENERATE_MEMORY$
    $NOOP()$
$END$

$FUNCTION GENERATE_OUTPUT$
    $NL$
$END$

$FUNCTION GENERATE_PROVIDE$
    provide(_hardware_init_hook = 0);$NL$
    provide(_software_init_hook = 0);$NL$
    provide(software_term_hook = 0);$NL$
    provide(_bsssecinib_table = 0);$NL$
    provide(_tnum_bsssec = 0);$NL$
    provide(_datasecinib_table = 0);$NL$
    provide(_tnum_datasec = 0);$NL$
    $NL$

    $IF LENGTH(OSAP.ID_LIST)$
        $FOREACH domid OSAP.ID_LIST$
            $IF !OSAP.TRUSTED[domid]$
$   RX領域（専用）
                provide(___start_text_$OSAP.LABEL[domid]$ = $MPU_PAGE_MASK$);$NL$
                provide(___limit_text_$OSAP.LABEL[domid]$ = $MPU_PAGE_MASK$);$NL$
$   R領域（専用）
                provide(___start_sram_$OSAP.LABEL[domid]$_$FORMAT("%x", MEMATR_ROSDATA & ~TA_MEMINI)$ = $MPU_PAGE_MASK$);$NL$
                provide(___limit_sram_$OSAP.LABEL[domid]$_$FORMAT("%x", MEMATR_ROSDATA & ~TA_MEMINI)$ = $MPU_PAGE_MASK$);$NL$
$   RWX領域（専用）
                provide(___start_ram_$OSAP.LABEL[domid]$ = $MPU_PAGE_MASK$);$NL$
                provide(___limit_ram_$OSAP.LABEL[domid]$ = $MPU_PAGE_MASK$);$NL$
                provide(___start_sram_$OSAP.LABEL[domid]$ = $MPU_PAGE_MASK$);$NL$
                provide(___limit_sram_$OSAP.LABEL[domid]$ = $MPU_PAGE_MASK$);$NL$
$   共有リード専用ライト
                provide($FORMAT("___start_ram_%s_%x_%x", OSAP.LABEL[domid], +DEFAULT_ACPTN[domid], +TACP_SHARED)$ = $MPU_PAGE_MASK$);$NL$
                provide($FORMAT("___limit_ram_%s_%x_%x", OSAP.LABEL[domid], +DEFAULT_ACPTN[domid], +TACP_SHARED)$ = $MPU_PAGE_MASK$);$NL$
                provide($FORMAT("___start_sram_%s_%x_%x", OSAP.LABEL[domid], +DEFAULT_ACPTN[domid], +TACP_SHARED)$ = $MPU_PAGE_MASK$);$NL$
                provide($FORMAT("___limit_sram_%s_%x_%x", OSAP.LABEL[domid], +DEFAULT_ACPTN[domid], +TACP_SHARED)$ = $MPU_PAGE_MASK$);$NL$
                provide($FORMAT("___start_sram_%s_%x_%x_%x", OSAP.LABEL[domid], +DEFAULT_ACPTN[domid], +DEFAULT_ACPTN[domid], +MEMATR_ROSDATA)$ = $MPU_PAGE_MASK$);$NL$
                provide($FORMAT("___limit_sram_%s_%x_%x_%x", OSAP.LABEL[domid], +DEFAULT_ACPTN[domid], +DEFAULT_ACPTN[domid], +MEMATR_ROSDATA)$ = $MPU_PAGE_MASK$);$NL$
            $END$
        $END$
        $NL$
    $END$$NL$

$  共有領域
    provide(___start_text_$OSAP.LABEL[TDOM_NONE]$ = $MPU_PAGE_MASK$);$NL$
    provide(___limit_text_$OSAP.LABEL[TDOM_NONE]$ = $MPU_PAGE_MASK$);$NL$
    provide(___start_sram_$OSAP.LABEL[TDOM_NONE]$_$FORMAT("%x", MEMATR_ROSDATA & ~TA_MEMINI)$ = $MPU_PAGE_MASK$);$NL$
    provide(___limit_sram_$OSAP.LABEL[TDOM_NONE]$_$FORMAT("%x", MEMATR_ROSDATA & ~TA_MEMINI)$ = $MPU_PAGE_MASK$);$NL$
    provide(___start_ram_$OSAP.LABEL[TDOM_NONE]$ = $MPU_PAGE_MASK$);$NL$
    provide(___limit_ram_$OSAP.LABEL[TDOM_NONE]$ = $MPU_PAGE_MASK$);$NL$
    provide(___start_sram_$OSAP.LABEL[TDOM_NONE]$ = $MPU_PAGE_MASK$);$NL$
    provide(___limit_sram_$OSAP.LABEL[TDOM_NONE]$ = $MPU_PAGE_MASK$);$NL$
$   共有リード専用ライト領域全体
    provide(___start_srpw_all = $MPU_PAGE_MASK$);$NL$
    provide(___limit_srpw_all = $MPU_PAGE_MASK$);$NL$
    provide(___start_ssrpw_all = $MPU_PAGE_MASK$);$NL$
    provide(___limit_ssrpw_all = $MPU_PAGE_MASK$);$NL$
    $NL$
$END$

$FUNCTION GENERATE_GP_LABEL$
    $TAB$$TAB$__gp = . + 32K;$NL$
$END$

$FILE "kernel_mem2.c"$

$IF TNUM_MPU_SHARED > 0$
uint8 * const shared_meminib_table[$TNUM_MPU_SHARED * 3$] = {$NL$
$FOREACH memid RANGE(0, TNUM_MPU_SHARED - 1)$
    $TAB$((uint8 *)NULL),$TAB$/* MPUL $TNUM_MPU_REG - memid$ */$NL$
    $TAB$((uint8 *)NULL),$TAB$/* MPUA $TNUM_MPU_REG - memid$ */$NL$
    $TAB$((uint8 *)NULL),$TAB$/* MPAT $TNUM_MPU_REG - memid$ */$NL$
$END$
};$NL$
$NL$
$END$

$ 
$  GHS依存部のldscript.tfのインクルード
$ 
$INCLUDE "ghs/ldscript.tf"$ 

$FILE "cfg2_out.tf"$
$ LNKSEC.*の出力
$$numls = $numls$$$$NL$
$NL$
$FOREACH lsid RANGE(1, numls)$
	$$LNKSEC.MEMREG[$lsid$] = $LNKSEC.MEMREG[lsid]$$$$NL$
	$$LNKSEC.SECTION[$lsid$] = $ESCSTR(LNKSEC.SECTION[lsid])$$$$NL$
	$NL$
$END$

$JOINEACH tskid TSK.ID_LIST "\n"$
	$$TSK.ID[$+tskid$] = $TSK.ID[tskid]$$$
$END$
$NL$

$lma = 0$
$FOREACH moid MO_ORDER$
	$IF MO.LINKER[moid] && ((MO.SEFLAG[moid] & 0x01) != 0)$
		$IF !OMIT_IDATA && !EQ(MO.ILABEL[moid], "")$
            $$LMA.START_IDATA[$lma$] = "$PREFIX_START$$MO.ILABEL[moid]$"$$$NL$
			$$LMA.START_DATA[$lma$] = "$PREFIX_START$$MO.SLABEL[moid]$"$$$NL$
			$$LMA.END_DATA[$lma$] = "$PREFIX_END$$MO.SLABEL[moid]$"$$$NL$
            $lma = lma + 1$
		$END$
    $END$
$END$
$$LMA.ORDER_LIST = RANGE(0, $lma - 1$)$$$NL$
$NL$
