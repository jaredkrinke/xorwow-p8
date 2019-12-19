pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- xorwow test cartridge

#include "xorwow.lua"

-- Known seed, value test
local prng = xorwow.new_with_seed(0x0000.007b, 0x0000.01c8, 0x0000.1a7c, 0x0000.238d)
for i = 1, 49, 1 do
    prng.next()
end
local next = prng:next()
printh("This value should be d4d7.0d6d: " .. tostr(next, true))

-- Initialize with seed from rnd
local function random_uint32()
    return bor(flr(rnd(256)),
        bor(shl(flr(rnd(256)), 8),
        bor(lshr(flr(rnd(256)), 8),
        bor(lshr(flr(rnd(256)), 16)))))
end

prng = xorwow.new()

-- Spectral test
for x = 0, 256, 1 do
    for y = 0, 256, 1 do
        pset(x, y, prng:random_byte(16))
    end
end

-- Histogram test
local histogram = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
for i = 1, 10000, 1 do
    local index = prng:random_byte(10) + 1
    histogram[index] = histogram[index] + 1
end
for i = 1, #histogram, 1 do
    printh(histogram[i])
end
