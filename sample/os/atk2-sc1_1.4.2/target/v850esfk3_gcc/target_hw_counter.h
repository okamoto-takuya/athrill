/*
 *  TOPPERS ATK2
 *      Toyohashi Open Platform for Embedded Real-Time Systems
 *      Automotive Kernel Version 2
 *
 *  Copyright (C) 2014 by Center for Embedded Computing Systems
 *              Graduate School of Information Science, Nagoya Univ., JAPAN
 *  Copyright (C) 2014 by FUJI SOFT INCORPORATED, JAPAN
 *  Copyright (C) 2014 by Spansion LLC, USA
 *  Copyright (C) 2014 by NEC Communication Systems, Ltd., JAPAN
 *  Copyright (C) 2014 by Panasonic Advanced Technology Development Co., Ltd., JAPAN
 *  Copyright (C) 2014 by Renesas Electronics Corporation, JAPAN
 *  Copyright (C) 2014 by Sunny Giken Inc., JAPAN
 *  Copyright (C) 2014 by TOSHIBA CORPORATION, JAPAN
 *  Copyright (C) 2014 by Witz Corporation, JAPAN
 *
 *  上記著作権者は，以下の(1)～(4)の条件を満たす場合に限り，本ソフトウェ
 *  ア（本ソフトウェアを改変したものを含む．以下同じ）を使用・複製・改
 *  変・再配布（以下，利用と呼ぶ）することを無償で許諾する．
 *  (1) 本ソフトウェアをソースコードの形で利用する場合には，上記の著作
 *      権表示，この利用条件および下記の無保証規定が，そのままの形でソー
 *      スコード中に含まれていること．
 *  (2) 本ソフトウェアを，ライブラリ形式など，他のソフトウェア開発に使
 *      用できる形で再配布する場合には，再配布に伴うドキュメント（利用
 *      者マニュアルなど）に，上記の著作権表示，この利用条件および下記
 *      の無保証規定を掲載すること．
 *  (3) 本ソフトウェアを，機器に組み込むなど，他のソフトウェア開発に使
 *      用できない形で再配布する場合には，次のいずれかの条件を満たすこ
 *      と．
 *    (a) 再配布に伴うドキュメント（利用者マニュアルなど）に，上記の著
 *        作権表示，この利用条件および下記の無保証規定を掲載すること．
 *    (b) 再配布の形態を，別に定める方法によって，TOPPERSプロジェクトに
 *        報告すること．
 *  (4) 本ソフトウェアの利用により直接的または間接的に生じるいかなる損
 *      害からも，上記著作権者およびTOPPERSプロジェクトを免責すること．
 *      また，本ソフトウェアのユーザまたはエンドユーザからのいかなる理
 *      由に基づく請求からも，上記著作権者およびTOPPERSプロジェクトを
 *      免責すること．
 *
 *  本ソフトウェアは，AUTOSAR（AUTomotive Open System ARchitecture）仕
 *  様に基づいている．上記の許諾は，AUTOSARの知的財産権を許諾するもので
 *  はない．AUTOSARは，AUTOSAR仕様に基づいたソフトウェアを商用目的で利
 *  用する者に対して，AUTOSARパートナーになることを求めている．
 *
 *  本ソフトウェアは，無保証で提供されているものである．上記著作権者お
 *  よびTOPPERSプロジェクトは，本ソフトウェアに関して，特定の使用目的
 *  に対する適合性も含めて，いかなる保証も行わない．また，本ソフトウェ
 *  アの利用により直接的または間接的に生じたいかなる損害に関しても，そ
 *  の責任を負わない．
 *
 *  $Id: target_hw_counter.h 110 2014-11-05 07:48:03Z ertl-honda $
 */

/*
 *		ハードウェアカウンタのターゲット依存定義（v850esfk3用）
 */

#ifndef TOPPERS_TARGET_HW_COUNTER_H
#define TOPPERS_TARGET_HW_COUNTER_H

#include "v850esfk3.h"
#include "kernel/kernel_impl.h"

/*
 *  使用する差分タイマと現在値タイマのチャネル
 */
#define HWC_DTIM_ID    TAAnCH2	/* 差分タイマ */
#define HWC_CTIM_ID    TAAnCH3	/* 現在値タイマ */

/*
 *  割込み番号(INTTAA2CC0)
 */
#define HWC_DTIM_INTNO  (22)

/*
 *  割込み番号(INTTAA3CC0)
 */
#define HWC_CTIM_INTNO  (25)



/***************************************************
 * 16ビットタイマ／イベントカウンタAA(TAA)操作関数
 ***************************************************/
/*
 *  割込み要求のクリア
 */
LOCAL_INLINE void
HwcounterClearInterrupt(uint32 intno)
{
	//(void)x_clear_int(intno);
}

/*
 *  割込み禁止／許可設定
 */
LOCAL_INLINE void
HwcounterDisableInterrupt(uint32 intno)
{
	(void)x_disable_int(intno);
}

LOCAL_INLINE void
HwcounterEnableInterrupt(uint32 intno)
{
	(void)x_enable_int(intno);
}


 /*
 *  TAA タイマの動作開始／停止処理
 */
LOCAL_INLINE void
SetTimerStartTAA(uint8 ch)
{
	/* タイマ開始処理 */
	sil_wrb_mem((void *) TAAnCTL0(ch), 
		( sil_reb_mem((void *) TAAnCTL0(ch)) | (1U << 7U) )	//TAAnCEビットセット
	);
}

LOCAL_INLINE void
SetTimerStopTAA(uint8 ch)
{
	/* タイマ停止処理 */
	sil_wrb_mem((void *) TAAnCTL0(ch), 
		( sil_reb_mem((void *) TAAnCTL0(ch)) & ~(1U << 7U) )	//TAAnCEビットクリア
	);
}

/*
 *  TAAハードウェアカウンタ現在ティック値取得
 */
LOCAL_INLINE TickType
GetCurrentTimeTAA(uint8 ch, TickType maxval)
{
	TickType	count;
	TickType	curr_time = 0U;

	count = sil_reh_mem((void *) (TAAnCNT(ch)));

	curr_time = (count % maxval);

	return(curr_time);
}



/*
 * CPU 100MHz
 * hw_counter:0.1ms/tick
 */

#define TICK_FOR_10MS        100U


#endif /* TOPPERS_TARGET_HW_COUNTER_H */
