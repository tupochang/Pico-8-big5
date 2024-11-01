pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

-- 匯入
#include ../data/font_data.lua
#include ../data/messages.lua

-- 每行字高
lineh=8

-- 文字逐字出現用變數
local current_index = 1    -- 當前顯示的字符索引
local timer = 0            -- 計時器
local delay = 5            -- 每個字符的顯示間隔

-- 逐字打印的函式
function typewriter_text(message_id, x, y, color)
    local message = messages[message_id]
    if not message then
        print("not message: " .. message_id)
        return
    end

    -- 根據 current_index 顯示部分訊息
    for i = 1, current_index do
        local char = message[i]
        draw_char(char, x + (i - 1) * 8, y, color)
    end

    -- 更新計時器和字符索引
    timer = timer + 1
    if timer >= delay then
        timer = 0
        if current_index < #message then
            current_index = current_index + 1
        end
    end
end

-- 顯示單個字符的函式
function draw_char(char, x, y, color)
    local data = font_data[char]
    if not data then return end

    for row = 1, #data do
        local byte = data[row]
        for col = 0, 7 do
            if (byte & (0x80 >> col)) ~= 0 then
                pset(x + col, y + row - 1, color)
            end
        end
    end
end

function draw_text(message_id, x, y, color)
    local message = messages[message_id]
    if not message then
        print("not message: " .. message_id)
        return
    end

    for i, char in ipairs(message) do
        draw_char(char, x + (i - 1) * 8, y, color)
    end
end

function _draw()
    cls(1)
    draw_text("m1", 0, lineh*1, 9)
    draw_text("m2", 0, lineh*2, 2)
    draw_text("m3", 0, lineh*3, 3)
    draw_text("m4", 0, lineh*4, 4)
    draw_text("m5", 0, lineh*5, 5)
    draw_text("m6", 0, lineh*6, 10)
    draw_text("m7", 0, lineh*7, 7)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
