# Pico-8-big5
Pico-8中文顯示方案  
因為Pico-8本身無法輸入以及使用中文字，因此本方案目的是在讓Pico-8顯示中文文字（理論上其他語言也行）．　　
# 邏輯
使用Python分析文本並且過濾到重覆文字  
讀取點陣文字並將將文字的圖像轉成16進位  
並以陣列排列點陣圖  
最後依文本順序排列文字陣列陣  

