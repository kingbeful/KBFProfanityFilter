local log = require 'log'
local json = require 'dkjson'

local function trim(s) 
    return string.gsub(s, "^%s*(.-)%s*$", "%1")
end 

-- Calc the utf8 letter's length of byte
-- 0xxxxxxx - 1 byte
-- 110yxxxx - 192, 2 byte
-- 1110yyyy - 225, 3 byte
-- 11110zzz - 240, 4 byte
local function chsize(char)
    if not char then
        print("not char")
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end

-- Calc the utf8 letter length
-- e.g. utf8len("1你好") => 3
local function utf8len(str)
    local len = 0
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + chsize(char)
        len = len +1
    end
    return len
end

-- substring of a utf8 string
-- str:         the input string
-- startChar:   start location in the input string
-- numChars:    number of the letters
local function utf8sub(str, startChar, numChars)
    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + chsize(char)
        startChar = startChar - 1
    end

    local currentIndex = startIndex

    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + chsize(char)
        numChars = numChars -1
    end
    return str:sub(startIndex, currentIndex - 1)
end

local function genSensitiveWordList(file)
    local file = io.open(file ,"r")

    local word_map = {};
    for line in file:lines() do
        line = trim(line);
        local len = utf8len(line)
        
        log.n('Processing ', line, len)

        local now_map = word_map;
        for i = 1, len do
            local letter = utf8sub(line, i, 1)

            if len == i then -- last one
                if not now_map[letter] then -- empty
                    now_map[letter] = {isEnd=true}
                else
                    now_map[letter]['isEnd'] = true
                end
            else -- not last one
                local tmp_map = now_map[letter]
                if not tmp_map then -- empty
                    local new_map = {}
                    now_map[letter] = new_map
                    now_map = new_map
                else
                    now_map = tmp_map
                end
            end
        end
    end

    return word_map;
end

local function getopt( arg, options )
  local tab = {}
  for k, v in ipairs(arg) do
    if string.sub( v, 1, 2) == "--" then
      local x = string.find( v, "=", 1, true )
      if x then tab[ string.sub( v, 3, x-1 ) ] = string.sub( v, x+1 )
      else      tab[ string.sub( v, 3 ) ] = true
      end
    elseif string.sub( v, 1, 1 ) == "-" then
      local y = 2
      local l = string.len(v)
      local jopt
      while ( y <= l ) do
        jopt = string.sub( v, y, y )
        if string.find( options, jopt, 1, true ) then
          if y < l then
            tab[ jopt ] = string.sub( v, y+1 )
            y = l
          else
            tab[ jopt ] = arg[ k + 1 ]
          end
        else
          tab[ jopt ] = true
        end
        y = y + 1
      end
    end
  end
  return tab
end

local function usage()
  log.i('Usage:')
  log.i('$> lua profanity.lua -f path_to_sensitive_word.txt')
end

local function main( arg )
  local opts = getopt( arg, "f" )
  local function exit() usage(); os.exit(1) end
  if type(opts.f) ~= 'string' then log.e('use -f to specify a sensitive word list'); exit() end
  local wordList = genSensitiveWordList(opts.f)
  -- just print out
  log.n(json.encode(wordList))

  -- it's good to use
  -- > plutil -convert xml1 in.json -o out.plist
  -- to convert json to plist, if you want to use it in iOS/OSX
end

main(arg)