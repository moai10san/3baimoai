# コードの動作未確認

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
1stStudentName : string = "田中ハーレイ"

#文字列補間 {}
announceTestResult : string = "学年1位は...{1stStudentName}君です！" 

#配列の作成
testScore : []int = array{90, 80, 88, 87, 93}

#初期値の指定は必須ではないはず
var testSum : int
var testAve : float

if (onTestDay?):
    Print(announceTestResult)
    for (Index -> Score : testScore):
        set testSum += Score

    set testAve = testSum / testScore.Length
    Print("{1stStudentName}君の平均点は、{ToString(testAve)}だ!!")

else:
    Print("テストの日ではない...")