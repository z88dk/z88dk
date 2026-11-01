-- Shared active-low keyboard matrix storage for ticks machine models.
-- Rows are zero-based; a set bit in a row value means that key is released.
local Matrix = {}

function Matrix.new(row_count, column_count)
    assert(row_count > 0 and row_count <= 256, "keyboard matrix must have 1..256 rows")
    assert(column_count > 0 and column_count <= 8, "keyboard matrix must have 1..8 columns")
    local idle = (1 << column_count) - 1
    local rows = {}
    for row = 1, row_count do rows[row] = idle end

    local matrix = {}

    function matrix:read(row)
        if row < 0 or row >= row_count then return idle end
        return rows[row + 1]
    end

    -- `select` is active-low: each zero bit selects the corresponding row.
    -- Multiple selected rows are electrically combined by ANDing their lines.
    function matrix:read_selected(select)
        local value = idle
        for row = 0, math.min(row_count, 8) - 1 do
            if (select & (1 << row)) == 0 then
                value = value & rows[row + 1]
            end
        end
        return value
    end

    -- Internal state API for later debugger/test input injection.
    function matrix:set_key(row, column, pressed)
        assert(row >= 0 and row < row_count, "keyboard row out of range")
        assert(column >= 0 and column < column_count, "keyboard column out of range")
        local bit = 1 << column
        if pressed then rows[row + 1] = rows[row + 1] & (~bit & idle)
        else rows[row + 1] = rows[row + 1] | bit end
    end

    function matrix:set_row(row, value)
        assert(row >= 0 and row < row_count, "keyboard row out of range")
        rows[row + 1] = value & idle
    end

    return matrix
end

return Matrix
