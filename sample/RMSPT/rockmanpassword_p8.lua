#include ../data/password.lua  -- 引入密碼資料
grid_size = 5  -- 設定棋盤大小為5x5
cell_size = 18  -- 每個格子的大小為18像素
start_x = 4  -- 棋盤的起始X位置
start_y = 4  -- 棋盤的起始Y位置
password1 = nil  -- 保存生成的密碼
loaded_data = nil  -- 保存從密碼解析出的數據

-- 初始化棋盤格子，預設所有格子為0
grid = {}
for i = 1, grid_size * grid_size do
    grid[i] = 0
end

cursor_x, cursor_y = 1, 1  -- 游標初始位置
blink_timer = 0  -- 用於控制游標閃爍的計時器
blink_on = true  -- 游標閃爍開關

function _update()
    -- 控制游標閃爍
    blink_timer += 1
    if blink_timer % 15 == 0 then
        blink_on = not blink_on
    end

    -- 控制游標上下左右移動
    if btnp(2) then cursor_y = max(1, cursor_y - 1) end  -- 向上移動
    if btnp(3) then cursor_y = min(grid_size, cursor_y + 1) end  -- 向下移動
    if btnp(0) then cursor_x = max(1, cursor_x - 1) end  -- 向左移動
    if btnp(1) then cursor_x = min(grid_size, cursor_x + 1) end  -- 向右移動

    -- 按下按鈕4時，當前格子循環切換值為0, 1, 2, 3（代表不同的SPR）
    if btnp(4) then
        local index = (cursor_y - 1) * grid_size + cursor_x
        grid[index] = (grid[index] + 1) % 4
    end

    -- 按下按鈕5時，生成並保存密碼，並從密碼中解析數據
    if btnp(5) then
        local password = grid_to_password(grid)
        password1 = password
        loaded_data = load_from_password(password)  -- 從密碼載入數據
        binary_data = binary_string
    end
end

function _draw()
    cls(1)  -- 清空畫面

    -- 繪製棋盤格子和當前格子的圖示
    for y = 1, grid_size do
        for x = 1, grid_size do
            local index = (y - 1) * grid_size + x
            local gx = start_x + (x - 1) * cell_size
            local gy = start_y + (y - 1) * cell_size
            rect(gx, gy, gx + cell_size - 1, gy + cell_size - 1, 6)  -- 畫格子框

            -- 根據格子的值繪製相應的SPR
            if grid[index] == 1 then
                spr(1, gx + 5, gy + 5)
            elseif grid[index] == 2 then
                spr(2, gx + 5, gy + 5)
            elseif grid[index] == 3 then
                spr(3, gx + 5, gy + 5)
            end
        end
    end

    -- 顯示數據框架
    rect(97, 4, 123, 93)
    rect(4, 98, 123, 123)
    print("level:", 99, 8)
    print((loaded_data and loaded_data.level) or "", 99, 18)
    print("hp:", 99, 28)
    print((loaded_data and loaded_data.hp) or "", 99, 38)
    print("money:", 99, 48)
    print((loaded_data and loaded_data.money) or "", 99, 58)
    print("x:", 99, 68)
    print((loaded_data and loaded_data.x) or "", 108, 68)
    print("y:", 99, 78)
    print((loaded_data and loaded_data.y) or "", 108, 78)
    print("password:", 8, 102)
    print(password1 or "no password", 8, 110)

    -- 繪製閃爍游標
    if blink_on then
        local cx = start_x + (cursor_x - 1) * cell_size
        local cy = start_y + (cursor_y - 1) * cell_size
        rect(cx, cy, cx + cell_size - 1, cy + cell_size - 1, 8)
    end
end

-- 將棋盤格子的值轉換為二進位並組成密碼
function grid_to_password(grid)
    local binary_string = ""
    for i = 1, #grid do
        local value = grid[i]
        if value == 0 then
            binary_string = binary_string .. "00"
        elseif value == 1 then
            binary_string = binary_string .. "01"
        elseif value == 2 then
            binary_string = binary_string .. "10"
        elseif value == 3 then
            binary_string = binary_string .. "11"
        end
    end
    
    -- 確保二進位字符串長度為48位（不足補0，過多截斷）
    if #binary_string < 48 then
        binary_string = binary_string .. string.rep("0", 48 - #binary_string)
    elseif #binary_string > 48 then
        binary_string = sub(binary_string, 1, 48)
    end

    -- 將二進位轉為16進位密碼
    local password = ""
    for i = 1, #binary_string, 4 do
        local four_bits = sub(binary_string, i, i + 3)
        local hex_value = binary_to_decimal(four_bits)
        password = password .. sub("0123456789abcdef", hex_value + 1, hex_value + 1)
    end

    return password
end

-- 將二進位字符串轉換為十進位
function binary_to_decimal(bin)
    local decimal = 0
    local len = #bin
    for i = 1, len do
        local bit = sub(bin, i, i)
        decimal += (bit == "1" and 1 or 0) * 2 ^ (len - i)
    end
    return decimal
end
