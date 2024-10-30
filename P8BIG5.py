from PIL import Image, ImageFont, ImageDraw

def get_font_data(char, font_path="C:\\Users\\rjoe_tu\\AppData\\Local\\Microsoft\\Windows\\Fonts\\观致 8×8 像素字体.ttf", font_size=8):
    # 加載字型，設置字型大小
    font = ImageFont.truetype(font_path, font_size)
    
    # 創建單字符圖像
    image = Image.new("1", (font_size, font_size), 1)  # 白色背景，黑色字符
    draw = ImageDraw.Draw(image)
    draw.text((0, 0), char, font=font, fill=0)  # 黑色填充字符

    # 轉為二進制數據
    binary_data = []
    for y in range(font_size):
        row = ""
        for x in range(font_size):
            pixel = image.getpixel((x, y))
            row += "1" if pixel == 0 else "0"
        binary_data.append(row)
    
    return binary_data

def binary_to_hex(binary_data):
    # 將二進制數據轉換為十六進制
    hex_data = []
    for line in binary_data:
        hex_value = f"0x{int(line, 2):02X}"
        hex_data.append(hex_value)
    return hex_data

# 讀取文字檔，取得所有句子
with open("messages.txt", "r", encoding="utf-8") as f:
    lines = [line.strip() for line in f if line.strip()]

# 提取所有獨特的字，並為每個字分配唯一標識符
unique_chars = {}
for line in lines:
    for char in line:
        if char not in unique_chars:
            unique_chars[char] = None  # 初始化為 None，稍後生成點陣數據

# 生成字型數據表
font_data_output = []
for idx, char in enumerate(unique_chars):
    binary_data = get_font_data(char)
    hex_data = binary_to_hex(binary_data)
    hex_data_str = ", ".join(hex_data)
    unique_chars[char] = f"C{idx+1}"  # 為每個字分配唯一標識符
    font_data_output.append(f'["{unique_chars[char]}"] = {{{hex_data_str}}}')

# 生成訊息表
message_output = []
for idx, line in enumerate(lines):
    message_id = f"M{idx+1}"
    message_chars = [unique_chars[char] for char in line]
    message_output.append(f'["{message_id}"] = {{"' + '", "'.join(message_chars) + '"}')

# 輸出 PICO-8 格式的程式碼
print("-- 定義字符的點陣數據")
print("local font_data = {")
print(",\n".join(font_data_output))
print("}\n")

print("-- 訊息表格，使用標識符組合訊息")
print("local messages = {")
print(",\n".join(message_output))
print("}")
