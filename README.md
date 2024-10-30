# Pico-8-big5
Pico-8中文顯示方案  
![image](https://github.com/tupochang/Pico-8-big5/blob/main/Image/PICO-8.png?raw=true)        
因為Pico-8本身無法輸入以及使用中文字，因此本方案目的是在讓Pico-8顯示中文文字（理論上其他語言也行）．　　
# 邏輯
使用Python分析文本並且過濾到重覆文字 
![image](https://github.com/tupochang/Pico-8-big5/blob/main/Image/MES.png?raw=true)       
讀取點陣文字並將將文字的圖像轉成16進位  
![image](https://github.com/tupochang/Pico-8-big5/blob/main/Image/Python.png?raw=true)       
文字字型使用 上古神器 III : 7x7像素点阵中文字体
https://github.com/Angelic47/FontChinese7x7/tree/main  
並以陣列排列點陣圖  
最後依文本順序排列文字陣列陣  

