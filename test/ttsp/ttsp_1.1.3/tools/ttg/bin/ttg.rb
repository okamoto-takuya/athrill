#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
#
#  上記著作権者は，以下の(1)〜(4)の条件を満たす場合に限り，本ソフトウェ
#  ア（本ソフトウェアを改変したものを含む．以下同じ）を使用・複製・改
#  変・再配布（以下，利用と呼ぶ）することを無償で許諾する．
#  (1) 本ソフトウェアをソースコードの形で利用する場合には，上記の著作
#      権表示，この利用条件および下記の無保証規定が，そのままの形でソー
#      スコード中に含まれていること．
#  (2) 本ソフトウェアを，ライブラリ形式など，他のソフトウェア開発に使
#      用できる形で再配布する場合には，再配布に伴うドキュメント（利用
#      者マニュアルなど）に，上記の著作権表示，この利用条件および下記
#      の無保証規定を掲載すること．
#  (3) 本ソフトウェアを，機器に組み込むなど，他のソフトウェア開発に使
#      用できない形で再配布する場合には，次のいずれかの条件を満たすこ
#      と．
#    (a) 再配布に伴うドキュメント（利用者マニュアルなど）に，上記の著
#        作権表示，この利用条件および下記の無保証規定を掲載すること．
#    (b) 再配布の形態を，別に定める方法によって，TOPPERSプロジェクトに
#        報告すること．
#  (4) 本ソフトウェアの利用により直接的または間接的に生じるいかなる損
#      害からも，上記著作権者およびTOPPERSプロジェクトを免責すること．
#      また，本ソフトウェアのユーザまたはエンドユーザからのいかなる理
#      由に基づく請求からも，上記著作権者およびTOPPERSプロジェクトを
#      免責すること．
#
#  本ソフトウェアは，無保証で提供されているものである．上記著作権者お
#  よびTOPPERSプロジェクトは，本ソフトウェアに関して，特定の使用目的
#  に対する適合性も含めて，いかなる保証も行わない．また，本ソフトウェ
#  アの利用により直接的または間接的に生じたいかなる損害に関しても，そ
#  の責任を負わない．
#
#  $Id: ttg.rb 10 2012-09-11 01:58:07Z nces-shigihara $
#
if ($0 == __FILE__)
  TOOL_ROOT = File.expand_path(File.dirname(__FILE__) + "/../")
  $LOAD_PATH.unshift(TOOL_ROOT)
end
require "common/bin/Config.rb"
require "bin/builder/ASPBuilder.rb"
require "bin/builder/FMPBuilder.rb"
require "bin/builder/CBuilder.rb"
require "bin/builder/HTMLBuilder.rb"
require "bin/director/ProfileDirector.rb"
require "bin/director/CodeDirector.rb"
require "ttc/bin/ttc.rb"
require "ttj/bin/ttj.rb"
require 'pp'

module TTG
  # TTGのバージョン
  $Version   = "3.0.7"
  VERSION = "/* Generated by TTG ver #{$Version} ($Rev: 10 $) */"

  class TTGMain
    include TTCModule
    include TTJModule
    include CommonModule

    #=================================================================
    # 概　要: TTGメインルーチン
    #=================================================================
    def main(aArgs)
      check_class(Array, aArgs)      # 実行時引数

      # コンソールの横幅チェック
      if (check_console_width() == false)
        $stderr.puts(ERR_CONSOLE_WIDTH)
        exit(1)
      end

      #
      # TESRYデータから，中間コードを生成する
      #

      # TTCにyamlリストを渡し，クラス化して返す
      cTTC = TTC.new()
      aTestScenarios = cTTC.pre_process(aArgs)

      # コンフィグの取得
      cConf = Config.new()

      # ProfileBuilderを生成し，ProfileDirectorの引数として渡す
      if (cConf.is_asp?())
        cProfileBuilder = ASPBuilder.new()
      elsif (cConf.is_fmp?())
        cProfileBuilder = FMPBuilder.new()
      else
        abort(ERR_MSG % [__FILE__, __LINE__])
      end
      cProfileDirector = ProfileDirector.new(cProfileBuilder)

      # aTestScenariosを引数として，ProfileDirectorのbuildを実行
      cProfileDirector.build(aTestScenarios)
      cIntermediateCode = cProfileBuilder.get_result()
      # 中間コードを出力する場合は以下をアンコメント
      #cIntermediateCode.p_code(:all)

      #
      # 生成された中間コードから，実行コードを生成する
      #

      # CodeBuilderを生成し，CodeDirectorの引数として渡す
      aBuilder = []
      aBuilder.push(CBuilder.new())
      if (cConf.is_testflow_mode?())
        aBuilder.push(HTMLBuilder.new())
      end

      aBuilder.each{ |cBuilder|
        cCodeDirector = CodeDirector.new(cBuilder)

        # cIntermediateCodeを引数として，cCodeDirectorのbuildを実行
        cCodeDirector.build(cIntermediateCode)
        cCode = cBuilder.get_result()
        # 生成されたコードをファイル化する
        cBuilder.output_code_file(cCode, cConf.get_out_file())
      }

      #
      # TTJ出力
      #

      # TTJにTestScenarioを渡して日本語化する
      if (cConf.is_enable_ttj_mode?())
        cTTJ = TTJ.new()
        cTTJ.japanize_test_scenario(aTestScenarios)
        cTTJ.print_file()     # ファイル出力
      end


      # バリエーションで除外されたファイル情報を表示
      cTTC.print_exclude()
    end
  end
end


#====================================================================
# テストコード
#====================================================================
if (__FILE__ == $0)
  require 'pp'
  include TTG

  cTTG = TTGMain.new()
  cTTG.main(ARGV)
end
