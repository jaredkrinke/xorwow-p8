-- xorwow core implementation
xorwow = {
    new = function ()
        local function random_uint32()
            return bor(flr(rnd(256)),
                bor(shl(flr(rnd(256)), 8),
                bor(lshr(flr(rnd(256)), 8),
                bor(lshr(flr(rnd(256)), 16)))))
        end
        
        return xorwow.new_with_seed(random_uint32(), random_uint32(), random_uint32(), random_uint32())
    end,

    new_with_seed = function (a, b, c, d)
        local counter = 0

        return {
            a = a,
            b = b,
            c = c,
            d = d,

            next = function()
                local t = d

                d = c
                c = b
                b = a

                t = bxor(t, lshr(t, 2))
                t = bxor(t, shl(t, 1))
                t = bxor(t, bxor(a, shl(a, 4)))
                a = t

                counter = counter + 0x0005.87c5
                return t + counter
            end,

            random_byte = function(self, max_exclusive)
                -- Throw out values that wrap around to avoid bias
                while true do
                    local number = self:next()
                    local byte = band(0xff, flr(bxor(number, bxor(lshr(number, 8), bxor(shl(number, 8), bxor(shl(number, 16)))))))
                    if byte + (256 % max_exclusive) < 256 then
                        return byte % max_exclusive
                    end
                end
            end,
        }
    end,
}
