![](https://github.com/tupochang/Pico-8-big5/blob/main/Image/rockmanpassword.png)


這是一個PICO-8用基於洛克人風格的密碼生成器。


程式碼允許使用者在5x5棋盤上輸入值，然後將棋盤狀態轉換為密碼，並將密碼中的每段數據（如等級、生命值、金錢、坐標等）解碼顯示。


棋盤中的值可循環設定為SPR(0)、SPR(1)、SPR(2)和SPR(3)，用於表示不同的密碼位元。

## 製作思路
### 產生
將變數轉為一串16進位的字串，如果需要加密可以更改字串位置再轉為2進位呈現在畫面上
### 讀取
就是將盤面上的2進位轉16進位再回填到變數裡

## 學習筆記
在這個製作中遇到一個坑，就是我將轉換函式寫在外部．其中在16進位轉10進位時發現數值怎麼都不對．
後來答案是A-F都必須使用小寫
