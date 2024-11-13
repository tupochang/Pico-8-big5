def to_hex(value, length):
    """將數值轉換為指定長度的16進位字符串"""
    hex_str = hex(value)[2:].upper()
    return hex_str.zfill(length)

def generate_password(data):
    """生成密碼，將每個數據轉為16進位並組裝成字符串"""
    level_hex = to_hex(data['level'], 2)
    health_hex = to_hex(data['hp'], 2)
    money_hex = to_hex(data['money'], 4)
    x_hex = to_hex(data['x'], 2)
    y_hex = to_hex(data['y'], 2)
    
    password = level_hex + health_hex + money_hex + x_hex + y_hex
    return password

def hex_to_binary(hex_str):
    """將16進位字符串轉換為二進位字符串"""
    binary_str = ""
    for char in hex_str:
        binary_str += bin(int(char, 16))[2:].zfill(4)
    return binary_str

def binary_to_grid(binary_str):
    """將二進位字符串轉為5x5的盤面格子（0, 1, 2, 3）"""
    grid = []
    for i in range(25):  # 25個格子
        bits = binary_str[i * 2: (i + 1) * 2]  # 每個格子用2位來表示
        if bits == "00":
            grid.append(0)  # 空白格子
        elif bits == "01":
            grid.append(1)  # spr(1)
        elif bits == "10":
            grid.append(2)  # spr(2)
        elif bits == "11":
            grid.append(3)  # spr(3)
        else:
            grid.append(0)  # 任何其他情況都當空白處理
    return [grid[i:i+5] for i in range(0, 25, 5)]  # 轉為5x5的列表

# 用戶輸入數據
data = {
    'level': int(input("輸入level: ")),
    'hp': int(input("輸入hp: ")),
    'money': int(input("輸入money: ")),
    'x': int(input("輸入x: ")),
    'y': int(input("輸入y: "))
}

# 生成密碼
password = generate_password(data)
print("生成的密碼:", password)

# 將密碼轉為二進位再轉為5x5格子
binary_str = hex_to_binary(password)
print("轉換為二進位:", binary_str)
grid = binary_to_grid(binary_str)

# 輸出格子配置
print("5x5盤面密碼圖形:")
for row in grid:
    print(row)
