-- === INFO / start ===
-- to make all that work well on Windows, I had to fiddle around with:
-- - install llvm (choco install llvm) for compiling treesitter parsers for html and yaml
--   (ref: https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#troubleshooting)
-- === INFO / end ===

-- force language into english
vim.cmd.lang("en_US.UTF-8")

require("ut4k.options")
require("ut4k.remap")
require("ut4k.packer")
require("ut4k.auto")
require("ut4k.colors")

-- some abbreviations
vim.cmd("iabbrev ve echo \"<pre>\"; print_r(); echo \"</pre>\"; // DBG<esc>F(a")
vim.cmd("iabbrev .> ->")
vim.cmd("iabbrev >> =>")
vim.cmd("iabbrev !! !=")


-- go debugging
function GoPrintLnAbbrev()
	return "fmt.Println(\"------------------------------------------\") //DBG<CR>"
end
function GoLogAbbrev()
	return "t.Logf(\"------------------------------------------\") //DBG<CR>"
end

vim.cmd("iabbrev gpl@ " .. GoPrintLnAbbrev() .. "fmt.Printf(\"XXXXXX: %#v \\n\", XXXXXX) //DBG<CR>" .. GoPrintLnAbbrev())
vim.cmd("iabbrev gl@ " .. GoLogAbbrev() .. "t.Logf(\"XXXXXX: %#v \\n\", XXXXXX) //DBG<CR>" .. GoLogAbbrev())

-- gui繝輔か繝ｳ繝医ｒ諡｡邵ｮ縺吶ｋ
vim.keymap.set("n", "<C-9>", [[:lua guifontscale(1)<CR>]], { noremap = true })
vim.keymap.set("n", "<C-8>", [[:lua guifontscale(-1)<CR>]], { noremap = true })
function guifontscale(n)
    if type(n) ~= "number" then
	return
    end

    local gfa = {}
    for c in vim.gsplit(vim.o.guifont, ":") do
        table.insert(gfa, c)
    end
    local buildnewgf = ""
    for k, v in ipairs(gfa) do
	if v:find("h", 1, true) == 1 then
	    fweight = ""
	    for w in vim.gsplit(v, "h") do
		if tonumber(w) == nil then
		    goto continue
		end
		wn = tonumber(w)
		wn = wn + n
		fweight = fweight .. tostring(wn)
		::continue::
	    end

	    buildnewgf = buildnewgf .. "h" .. fweight .. ":"
	else
	    -- v = string.gsub(v, " ", "_")
	    buildnewgf = buildnewgf ..  v .. ":"

	end
    end

    -- local setcmd = "set guifont=" .. buildnewgf
	local setcmd = "Guifont! " .. buildnewgf
    vim.cmd(setcmd)
end

-- copy file name to clipboard
vim.keymap.set('n', '<leader>z', ':call v:lua.FileNameToReg()<cr>', { noremap = true })
function FileNameToReg()
 local fpath = vim.fn.expand("%:."):gsub("\\","/")
 ToClipboard(fpath);
 -- vim.fn.system('clip.exe', fpath) -- for win
 -- vim.fn.system('pbcopy', fpath) -- for mac
end

-- copy file name to clipboard
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function GetNamespaceFromLspSymbol()
    local result = vim.lsp.buf_request_sync(0, 'textDocument/documentSymbol', {
        textDocument = vim.lsp.util.make_text_document_params()
    }, 1000)
    if not result or not result[1] or not result[1].result then
        -- print("No symbols found")
        return ''
    end
    local symbols = result[1].result
    -- print(vim.inspect(symbols))
    local namespace = ''
    for _, symbol in ipairs(symbols) do
        if symbol.kind == 3 then  -- Namespace
            namespace = symbol.name
            break
        end
    end
    return namespace
end

function SymbolNameToReg()
    local a = require('aerial')
    local symbols = a.get_location(true)
    local name = ''
    for k,v in pairs(symbols) do
        if v.kind == 'Class' then
            name = v.name 
        end
        if v.kind == 'Method' then
            name = name .. '::' .. v.name
        end
        if v.kind == 'Function' then
            name = v.name
        end
    end
    local namespace = GetNamespaceFromLspSymbol()
    if namespace ~= '' then
        name = namespace .. '\\' .. name
    end
    print(name)
    ToClipboard(name);
    return name
end

-- [a]erial [r]egister
vim.keymap.set('n', '<leader>ar', ':lua SymbolNameToReg()<CR>', { noremap = true })

-- ---------------------------------------
-- autocmd
-- ---------------------------------------
-- function WinPath(path)
--  local path = vim.fn.system('wslpath -w ' .. path)
--  return vim.fn.strcharpart(path, 0, vim.fn.strlen(path)-1)
-- end
function GetParentFolder()
    local cwd = vim.fn.getcwd()
    local parentFolder = vim.fn.fnamemodify(cwd, ":h")
    return parentFolder
end

function WslSync()
  local fp = vim.fn.expand("%:p")
  local dp = vim.fn.getcwd()
	fp = fp:gsub("^C:", "c:")
	dp = dp:gsub("^C:", "c:")

  local cmd = 'php.exe "C:\\Users\\kimura.AZET\\scripts\\wsl_tools\\win\\wsl_sync.php" "'..fp..'" "'..dp..'"'

  print("-----------")
  print("[WSL SYNC]")
  res = vim.fn.system(cmd)
	print("  [CMD]\n  "..cmd)
  -- vim.fn.system('clip.exe', cmd)
  -- print("-----------")

  print(res)
end

function ConvertDateFormat()
    local line = vim.api.nvim_get_current_line()

    -- Search for the pattern "yyyy-mm-dd hh:mm:ss"
    local start_pos, end_pos, year, month, day, hour, min, sec = string.find(line, '(%d%d%d%d)-(%d%d)-(%d%d) (%d%d):(%d%d):(%d%d)')

    if not start_pos then
        print("Date pattern not found.")
        return
    end

    -- Construct the new date format: "yyyy-mm-ddThh:mm:ssZ"
    local new_date_format = year .. '-' .. month .. '-' .. day .. 'T' .. hour .. ':' .. min .. ':' .. sec .. 'Z'

    -- Replace the old date format with the new one
    local new_line = string.sub(line, 1, start_pos - 1) .. new_date_format .. string.sub(line, end_pos + 1)

    -- Update the line with the new date format
    vim.api.nvim_set_current_line(new_line)
end
vim.keymap.set('n', '<leader>dt', ':call v:lua.ConvertDateFormat()<cr>', { noremap = true })



vim.cmd[[
autocmd VimEnter,SourcePost * :highlight! ALEError guifg=red guibg=#151515
autocmd VimEnter,SourcePost * :highlight! ALEWarning  guifg=red guibg=#333333
autocmd VimEnter,SourcePost * :highlight! ALEVirtualTextError guifg=red guibg=#151515
autocmd VimEnter,SourcePost * :highlight! ALEVirtualTextStyleError guifg=red guibg=#151515
autocmd VimEnter,SourcePost * :highlight! ALEVirtualTextWarning guifg=red guibg=#151515
autocmd VimEnter,SourcePost * :highlight! ALEVirtualTextStyleWarning guifg=red guibg=#151515
autocmd VimEnter,SourcePost * :highlight! ALEVirtualTextInfo guifg=red guibg=#151515
]]

function ToClipboard(whatToCopy)
    local is_windows = vim.fn.has('win32') == 1
    local is_mac = vim.fn.has('mac') == 1

    if is_windows then
        -- Windowsの場合
        vim.fn.system('clip.exe', whatToCopy)
    elseif is_mac then
        -- Macの場合
        vim.fn.system('pbcopy', whatToCopy)
    else
        -- サポートされていないプラットフォームの場合
        print('Unsupported platform')
    end
end


