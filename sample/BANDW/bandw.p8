pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- ハままヒˇまハなあフゆた
board_width = 6
board_height = 6
cell_size = 16
board_x_offset = 8  -- ハほすホ🐱⌂フˇ▥フたむホ∧⧗ノやよヒこ⬅️フいさハね✽ノまと
board_y_offset = 8

-- ハいおハ…☉ハなあフゆた
turn_black = 1
turn_white = 2
turn_none = 3

-- ハ☉えハせ⬅️ヘな⌂ヒˇまハなあフゆた
turn = turn_black
cursor_x = 3
cursor_y = 3
board = {}
is_player = {true, false}  -- ホめ➡️ヘ웃のヒ▤にフ🅾️たハなへヤも😐フ▥やヘ웃のヒ▤に ai

-- ハなあフゆたヒ∧みハ…➡️ハ…➡️ホ♥◆
directions = {
    {x = 0, y = -1},   -- up
    {x = -1, y = -1},  -- up_left
    {x = -1, y = 0},   -- left
    {x = -1, y = 1},   -- down_left
    {x = 0, y = 1},    -- down
    {x = 1, y = 1},    -- down_right
    {x = 1, y = 0},    -- right
    {x = 1, y = -1}    -- up_right
}

-- ハ☉えハせ⬅️ハ😐∧ヒこ⬅️フいさ
function init_board()
    for y = 1, board_height do
        board[y] = {}
        for x = 1, board_width do
            board[y][x] = turn_none
        end
    end
    -- ヘそとフやなハ☉えハせ⬅️ヒこ⬅️ハと…ノや♪フやな
    board[3][3], board[4][4] = turn_white, turn_white
    board[3][4], board[4][3] = turn_black, turn_black
end

-- フみちヘこやヒこ⬅️フいさ
function draw_board()
    cls()

    -- フみちヘこやヒこ⬅️フいさヒきもヤも😐ハ◆はホ🐱⌂ハ★😐ノま⬅️ホ🐱⌂フほあハうそフに░ハう♪ハ✽せ
    for y = 0, board_height do
        line(board_x_offset, board_y_offset + y * cell_size, board_x_offset + board_width * cell_size - 1, board_y_offset + y * cell_size, 5)
    end
    for x = 0, board_width do
        line(board_x_offset + x * cell_size, board_y_offset, board_x_offset + x * cell_size, board_y_offset + board_height * cell_size - 1, 5)
    end

    -- フみちヘこやヒこ⬅️ハと…
    for y = 1, board_height do
        for x = 1, board_width do
            local cell = board[y][x]
            if cell == turn_black then
                spr(1, board_x_offset + (x - 1) * cell_size + 4, board_y_offset + (y - 1) * cell_size + 4)  -- ハぬ♥ヒこ⬅️ハと…ヒ⬆️ゆハうそヒきもハと…ノまとハさな
            elseif cell == turn_white then
                spr(2, board_x_offset + (x - 1) * cell_size + 4, board_y_offset + (y - 1) * cell_size + 4)  -- ハぬ♥ヒこ⬅️ハと…ヒ⬆️ゆハうそヒきもハと…ノまとハさな
            end
        end
    end

    -- フˇつハ✽웃ヒそ▥
    rect(board_x_offset + (cursor_x - 1) * cell_size, board_y_offset + (cursor_y - 1) * cell_size,
         board_x_offset + cursor_x * cell_size - 1, board_y_offset + cursor_y * cell_size - 1, 8)
end

-- ヘそ☉フな❎ヒ∧みハ…➡️ノや♪フやな
function vec_add(v0, v1)
    return {x = v0.x + v1.x, y = v0.y + v1.y}
end

-- ハ☉さヒ∧ほヘ⬇️やハ…すヒ⬆️ゆフやなヒこ⬅️ハと…
function can_place(color, pos, turn_over)
    local opponent = color == turn_black and turn_white or turn_black
    local can_place = false
    if board[pos.y][pos.x] ~= turn_none then return false end

    for i, dir in pairs(directions) do
        local cur = vec_add(pos, dir)
        if board[cur.y] and board[cur.y][cur.x] == opponent then
            while true do
                cur = vec_add(cur, dir)
                if not board[cur.y] or not board[cur.y][cur.x] then break end
                if board[cur.y][cur.x] == turn_none then break end
                if board[cur.y][cur.x] == color then
                    can_place = true
                    if turn_over then
                        local rev = vec_add(pos, dir)
                        while board[rev.y][rev.x] == opponent do
                            board[rev.y][rev.x] = color
                            rev = vec_add(rev, dir)
                        end
                    end
                    break
                end
            end
        end
    end
    return can_place
end

-- ヒちけヒかしヒこ⬅️フいさヒ▤にハ…すヒう웃ハ◆にヒ⬆️ゆフやなノや♪フやな
function can_place_all(color)
    for y = 1, board_height do
        for x = 1, board_width do
            if can_place(color, {x = x, y = y}) then
                return true
            end
        end
    end
    return false
end

-- ヘそ☉フな❎ヒこ⬅️ハと…ヒˇまホ♥◆
function count_disks(color)
    local count = 0
    for y = 1, board_height do
        for x = 1, board_width do
            if board[y][x] == color then
                count += 1
            end
        end
    end
    return count
end

-- ハ☉♥ヒ◆いハいおハ…☉
function switch_turn()
    turn = turn == turn_black and turn_white or turn_black
end

-- ホくにフさむヒこ⬅️ハと…ヒˇまホ♥◆ヘ☉♥ハ⬅️えハ☉たヘ█✽
function display_info()
    local black_count = count_disks(turn_black)
    local white_count = count_disks(turn_white)

    -- ハうそハ◆はハ▒ひホくにフさむヒこ⬅️ハと…ヒˇまホ♥◆
    print("black: " .. black_count, 10,110, 7)
    print("white: " .. white_count,	65, 110, 7)

    -- ハ☉さヒ∧ほホ▒⌂ヒ☉のフふ…ヒえかノますホくにフさむフ♪のハ⬅️えヘ█✽
    if turn == turn_none then
        local winner_text
        if black_count > white_count then
            winner_text = "player wins!"
        elseif white_count > black_count then
            winner_text = "ai wins!"
        else
            winner_text = "it's a draw!"
        end
        print(winner_text, 44, 55, 8)  -- ハうそハ◆はハ▒ひホくにフさむフ♪のハ⬅️えフふ…ヒおう
    end
end

-- フ🅾️たハなへヒ☉∧ ai フあ░ヘもまハ✽しヘ▥ˇフ…●
function player_move()
    if btnp(2) then cursor_y = (cursor_y - 2) % board_height + 1 end
    if btnp(3) then cursor_y = cursor_y % board_height + 1 end
    if btnp(0) then cursor_x = (cursor_x - 2) % board_width + 1 end
    if btnp(1) then cursor_x = cursor_x % board_width + 1 end

    if btnp(4) and can_place(turn, {x = cursor_x, y = cursor_y}, true) then
        board[cursor_y][cursor_x] = turn
        switch_turn()
    end
end

function ai_move()
    local possible_moves = {}
    for y = 1, board_height do
        for x = 1, board_width do
            if can_place(turn, {x = x, y = y}) then
                add(possible_moves, {x = x, y = y})
            end
        end
    end
    if #possible_moves > 0 then
        local move = possible_moves[flr(rnd(#possible_moves)) + 1]
        can_place(turn, move, true)
        board[move.y][move.x] = turn
        switch_turn()
    end
end

function _update()
    if turn == turn_none then return end

    if not can_place_all(turn) then
        switch_turn()
        if not can_place_all(turn) then
            turn = turn_none -- フふ🐱ハね█ハ☉さハなあ
        end
    else
        if is_player[turn] then
            player_move()
        else
            ai_move()
        end
    end
end

function _draw()
    draw_board()
    display_info()
    rect(8,107,104,117,7)
    rect(107,8,127,117,7)
end

init_board()

__gfx__
00000000005555000077770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055555500777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700555555557777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000555555557777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000555555557777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700555555557777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055555500777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005555000077770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
