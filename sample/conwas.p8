pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- ヘそとハなあハままヒˇま
field_width = 128
field_height = 128
update_interval = 3 -- ヒに◆ 3 ハみ█ヒいひヒ∧ぬノま█ヒてくヒそくヒ⧗て

-- ハ☉えハせ⬅️ハ😐∧ field ハ★😐 next_field
field = {}
next_field = {}

for y = 1, field_height do
    field[y] = {}
    next_field[y] = {}
    for x = 1, field_width do
        field[y][x] = 0
        next_field[y][x] = 0
    end
end

-- ハ☉えハせ⬅️ハ😐∧ハ♥やヒˇま
function init_pattern()
    local pattern = {
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,1,0,0},
        {0,0,0,0,0,1,0,1,1,0},
        {0,0,0,0,0,1,0,1,0,0},
        {0,0,0,0,0,1,0,0,0,0},
        {0,0,0,1,0,0,0,0,0,0},
        {0,1,0,1,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0}
    }

    local offset_x = flr(field_width / 2 - #pattern[1] / 2)
    local offset_y = flr(field_height / 2 - #pattern / 2)

    for y = 1, #pattern do
        for x = 1, #pattern[1] do
            field[offset_y + y][offset_x + x] = pattern[y][x]
        end
    end
end

-- フみちヘこや field
function draw_field()
    cls()
    for y = 1, field_height do
        for x = 1, field_width do
            if field[y][x] == 1 then
                pset(x - 1, y - 1, 7) -- フみちヘこやハ∧なハ█⬅️ハ⬇️◆フひきノやうフ🐱むハ∧なノや♪ヒきも
            end
        end
    end
end

-- ヘそ☉フな❎ハ➡️そハう♪ヒひめフひぬヘ⬇️おヒˇまホ♥◆
function get_living_cells_count(x, y)
    local count = 0
    for dy = -1, 1 do
        for dx = -1, 1 do
            if not (dx == 0 and dy == 0) then
                local nx = (x + dx - 1 + field_width) % field_width + 1
                local ny = (y + dy - 1 + field_height) % field_height + 1
                count += field[ny][nx]
            end
        end
    end
    return count
end

-- ヒいひヒ∧ぬ field フ⬅️█ヒ✽⬅️
function step_simulation()
    for y = 1, field_height do
        for x = 1, field_width do
            local living_neighbors = get_living_cells_count(x, y)
            if living_neighbors < 2 or living_neighbors > 3 then
                next_field[y][x] = 0
            elseif living_neighbors == 3 then
                next_field[y][x] = 1
            else
                next_field[y][x] = field[y][x]
            end
        end
    end

    -- ヘさ♥ヘこや next_field ハ☉ぬ field
    for y = 1, field_height do
        for x = 1, field_width do
            field[y][x] = next_field[y][x]
        end
    end
end

-- pico-8 フあ░ update ハ★😐 draw ノまめハゆちフ★ぬ
update_counter = 0

function _update()
    update_counter += 1
    if update_counter % update_interval == 0 then
        step_simulation()
    end
end

function _draw()
    draw_field()
end

-- ハ☉えハせ⬅️ハ😐∧
init_pattern()

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
