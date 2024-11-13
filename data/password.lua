
-- charset 要指定小寫才會顯示正確的大寫
charset = "0123456789abcdef"

-- 將二進位字串轉換為十進位數值
function binary_to_decimal(bin)
    local decimal = 0
    local len = #bin
    for i = 1, len do
        local bit = sub(bin, i, i)
        decimal = decimal + (bit == "1" and 1 or 0) * 2 ^ (len - i)
    end
    return decimal
end

-- 將十進位數轉換為指定長度的16進位字符串
function to_hex(value, length)
    local hex_str = ""
    while value > 0 do
        local remainder = value % 16
        hex_str = sub(charset, remainder + 1, remainder + 1) .. hex_str
        value = flr(value / 16)
    end
    -- 補足到指定的長度
    while #hex_str < length do
        hex_str = "0" .. hex_str
    end
    return hex_str
end

-- 自定義函數，將16進位字符串轉換為十進位
function hex_to_decimal(hex_str)
    local decimal = 0
    for i = 1, #hex_str do
        local char = sub(hex_str, i, i)
        local value = 0
        if char >= "0" and char <= "9" then
            value = ord(char) - ord("0")
        elseif char >= "a" and char <= "f" then
            value = ord(char) - ord("a") + 10
        end
        decimal = decimal * 16 + value
    end
    return decimal
end


-- 生成密碼函數
function generate_password(data)
    -- 將數據轉換為16進位的指定長度字符串
    local level_hex = to_hex(data.level, 2)
    local health_hex = to_hex(data.hp, 2)
    local money_hex = to_hex(data.money, 4)
    local x_hex = to_hex(data.x, 2)
    local y_hex = to_hex(data.y, 2)

    -- 組裝成密碼
    local password = ""
    password = password .. level_hex
    password = password .. health_hex
    password = password .. money_hex
    password = password .. x_hex
    password = password .. y_hex

    return password
end

-- 解析密碼函數
function load_from_password(password)
    -- 提取密碼中的每段，並轉換為十進位
    local level_hex = sub(password, 1, 2)          -- `AA`
    local money_hex = sub(password, 5, 8)          -- `BBBB`
    local health_hex = sub(password, 3, 4)         -- `CC`
    local x_hex = sub(password, 9, 10)             -- `XX`
    local y_hex = sub(password, 11, 12)            -- `YY`

    -- 使用 `hex_to_decimal` 將每段16進位轉換為十進位
    local level = hex_to_decimal(level_hex)
    local money = hex_to_decimal(money_hex)
    local health = hex_to_decimal(health_hex)
    local x = hex_to_decimal(x_hex)
    local y = hex_to_decimal(y_hex)

    -- 返回解碼的數據
    return {
        level = level,
        money = money,
        hp = health,
        x = x,
        y = y
    }
end
--[[
pico-中的測試數值範例
#include ../data/password.lua

data={level=20,money=999,hp=30,x=64,y=64}
a=to_hex(1324,2)
print("h16:"..a)
b=hex_to_decimal(a)
print("ten:"..b)
c=generate_password(data)
print("password:"..c)
d=load_from_password("1403e71e4040")
print(d.money)

01100
00002
10010
21000
10000

]]
