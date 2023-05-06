# 動作確認済み

# 単一行のコメント
<#
複数行にわたってのコメントはこう書く
以下 入門ガイド_レッスン4くらいまでの内容
https://dev.epicgames.com/documentation/ja-jp/uefn/learn-code-basics-4-practice-time-in-verse
#>

#実行中のゲームで仕掛けが開始した時に実行
OnBegin<override>()<suspends>:void=


#定数
number_student : int = 330

#変数
var number_teacher : int = 15

#変数の値を変更する
set number_teacher = 20

#Logic型
onTestDay : logic = true

#文字列型
Student1stName : string = "田中ハーレイ"

#文字列補間 {}
announceTestResult : string = "学年1位は...{Student1stName}君です！" 

#配列の作成
testScore : []int = array{90, 80, 88, 87, 93}

#初期値の指定は必須ではないはず → 初期化しないとダメでした
var testSum : int = 0
var testAve : int = 0

if (onTestDay?):
    Print(announceTestResult)
    for (Index -> Score : testScore):
        set testSum += Score

    if (localTestAve : int = Floor(testSum / testScore.Length)):
        set testAve = localTestAve
        Print("{Student1stName}君の平均点は、{ToString(testAve)}だ!!")

else:
    Print("テストの日ではない...")
