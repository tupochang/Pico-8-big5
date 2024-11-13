pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include ../data/password.lua
grid_size = 5
cell_size = 18
start_x = 4
start_y = 4
password1 = nil  
loaded_data = nil

grid = {}
for i = 1, grid_size * grid_size do
    grid[i] = 0
end

cursor_x, cursor_y = 1, 1
blink_timer = 0
blink_on = true

function _update()
    blink_timer += 1
    if blink_timer % 15 == 0 then
        blink_on = not blink_on
    end

    if btnp(2) then cursor_y = max(1, cursor_y - 1) end
    if btnp(3) then cursor_y = min(grid_size, cursor_y + 1) end
    if btnp(0) then cursor_x = max(1, cursor_x - 1) end
    if btnp(1) then cursor_x = min(grid_size, cursor_x + 1) end

    if btnp(4) then
        local index = (cursor_y - 1) * grid_size + cursor_x
        grid[index] = (grid[index] + 1) % 4  -- ヒいひヒ∧ぬヒとさヘ▥ˇヒ⬆️にヒ😐▒4フそなフ⬅️█ヒ✽⬅️ヤも😐ハ😐✽ヒ⬅️て spr(3)
    end

    if btnp(5) then
        local password = grid_to_password(grid)
        password1 = password
        loaded_data = load_from_password(password)
        binary_data = binary_string
    end
end

function _draw()
    cls(1)

    for y = 1, grid_size do
        for x = 1, grid_size do
            local index = (y - 1) * grid_size + x
            local gx = start_x + (x - 1) * cell_size
            local gy = start_y + (y - 1) * cell_size
            rect(gx, gy, gx + cell_size - 1, gy + cell_size - 1, 6)

            if grid[index] == 1 then
                spr(1, gx + 5, gy + 5)
            elseif grid[index] == 2 then
                spr(2, gx + 5, gy + 5)
            elseif grid[index] == 3 then
                spr(3, gx + 5, gy + 5)
            end
        end
    end

    rect(97,4,123,93)
    rect(4,98,123,123)
    print("level:",99,8)
    print((loaded_data and loaded_data.level) or "", 99, 18)
    print("hp:",99,28)
    print((loaded_data and loaded_data.hp) or "", 99, 38)
    print("money:",99,48)
    print((loaded_data and loaded_data.money) or "", 99, 58)
    print("x:",99,68)
    print((loaded_data and loaded_data.x) or "", 108, 68)
    print("y:",99,78)
    print((loaded_data and loaded_data.y) or "", 108, 78)
    print("password:",8,102)
    print(password1 or "no password", 8, 110)

    if blink_on then
        local cx = start_x + (cursor_x - 1) * cell_size
        local cy = start_y + (cursor_y - 1) * cell_size
        rect(cx, cy, cx + cell_size - 1, cy + cell_size - 1, 8)
    end
end

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
    
    
    if #binary_string < 48 then
        binary_string = binary_string .. string.rep("0", 48 - #binary_string)
    elseif #binary_string > 48 then
        binary_string = sub(binary_string, 1, 48)
    end

    local password = ""
    for i = 1, #binary_string, 4 do
        local four_bits = sub(binary_string, i, i + 3)
        local hex_value = binary_to_decimal(four_bits)
        password = password .. sub("0123456789abcdef", hex_value + 1, hex_value + 1)
    end

    return password
end

__gfx__
000000000088880000cccc0000333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000008e888800c6cccc003b33330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007008e7e8888c676cccc3b7b3333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700088e88888cc6ccccc33b33333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700088888888cccccccc33333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070088888888cccccccc33333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888800cccccc003333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000088880000cccc0000333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
