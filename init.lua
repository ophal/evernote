local version = [[Evernote/0.1-alpha1]]

local require, io, assert, table = require, io, assert, table
local theme, date, seawolf, arg, url = theme, os.date, seawolf, arg, url
local settings, tonumber, print = settings, tonumber, print
require [[seawolf.contrib]]
local table_concat = seawolf.contrib.table_concat
local path_register_alias, page_set_title = path_register_alias, page_set_title

module [[ophal.modules.evernote]]

--[[
  Implementation of hook_menu().
]]
function menu()
  local items = {}
  items.evernote = {
    title = [[Evernote]],
    page_callback = [[page]],
  }
  return items
end

function page()
  local file = settings.evernote.file
  local note, r, s
  local ID = tonumber(arg(1) or [[]])
  local result = {}

  -- Parse .nnex file
  local xmlreader = require [[xmlreader]]
  r = assert(xmlreader.from_file(file))
  while r:read() do
    if r:node_type() == [[element]] then
      if r:name() == [[Note]] then
        note = {src = r:read_outer_xml()}
        -- Parse NNEX
        if note.src then
          s = xmlreader.from_string(note.src)
          s:read() -- skip container
          while s:read() do
            if s:name() == [[UpdateSequenceNumber]] and note.id == nil then
              note.id = tonumber(s:read_string())
            elseif s:name() == [[Title]] and note.Title == nil then
              note.Title = s:read_string()
            elseif s:name() == [[Created]] and note.Created == nil  then
              note.Created = s:read_string()
            elseif s:name() == [[Updated]] and note.Updated == nil  then
              note.Updated = s:read_string()
            elseif s:name() == [[NoteAttributes]] then
              while s:read() do
                if s:name() == [[Author]] and note.Author == nil then
                  note.Author = s:read_string()
                end
                if s:name() == [[NoteAttributes]] then break end
              end
            elseif s:name() == [[Content]] and note.Content == nil then
              note.Content = s:read_string()
            end
          end
        end
        -- Note page view
        if ID == tonumber(note.id) then
          ID = tonumber(ID)
          page_set_title(note.Title)
          return theme{[[evernote]], note, true}
        -- Notes list view
        else
          table.insert(result, tonumber(note.id), theme{[[evernote]], note})
          r:next_node()
        end
      end
    end
  end

  page_set_title(settings.evernote.title)
  return table_concat(result)
end

function theme.evernote(note, page)
  local title, path = [[]]

  if not page then
    path = url(([[evernote/%d]]):format(note.id), true)
    title = ([[<h2 class="title">%s</h2>]]):format(theme{[[a]], path, note.Title})
  end

  return ([[
  %s
  <div class="submitted">Submitted by %s on %s</div>
  <div class="content">%s</div>]]):format(title, note.Author, date([[!%a, %Y-%m-%d %H:%M:%S]], note.Created/1000), note.Content)
end
