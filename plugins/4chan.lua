local max_characters = 1000
local display_thread_subject = true -- Doesn't count for max_characters
local send_image = true


local function html2text(data)
   data = string.gsub(data, "<br><br>", "\n")
   data = string.gsub(data, "<br>", "\n")
   data = string.gsub(data, "<a.->", " ")
   data = string.gsub(data, "</a>", " ")
   data = string.gsub(data, "<p.->(.-)</p>", "%1\n")
   data = string.gsub(data, "<b.->", "")
   data = string.gsub(data, "</b>", "")
   data = string.gsub(data, "<i.->", "")
   data = string.gsub(data, "</i>", "")
   data = string.gsub(data, "<sup.->", "")
   data = string.gsub(data, "</sup>", "")
   data = string.gsub(data, "<span.->", "\n")
   data = string.gsub(data, "</span>", "\n")
   data = string.gsub(data, "<div.->(.-)</div>", "%1\n")
   --data = string.gsub(data, "[.-]", "")
   data = string.gsub(data, "<table.->.-</table>", "")
   data = string.gsub(data, "<li.->(.-)</li>", " - %1\n")
   data = string.gsub(data, "<.->", "")
   data = string.gsub(data, "&gt;", ">")
   data = string.gsub(data, "&amp;", "&")
   data = string.gsub(data, "&..;", "")
   data = string.gsub(data, "&...;", "")
   data = string.gsub(data, "&....;", "")
   return data
end


local function get4chanRandomThread()
  local api = "http://a.4cdn.org/vg/catalog.json"
  local res, code = http.request(api)
  if code ~= 200 then return nil end
  local jsonCatalog = json:decode(res)

  local data = jsonCatalog
  if not data then
     return nil
  end

  if #data == 0 then
     return nil
  end

  -- Random page from catalog
  local i = math.random(#data)
  local page =  data[i]
  if not page then
     print("page = nil")
     return nil
  end
  if #page.threads == 0 then
     print("#page.threads = 0")
     return nil
  end
  --Random thread from page
  local j = math.random(#page.threads)
  local thread =  page.threads[j]
  return thread
end


local function run(msg, matches)
   local receiver = get_receiver(msg)
   local thread = get4chanRandomThread()
   if thread == nil then return "ERROR!" end
   if thread.com == nil then return "ERROR!" end
   local text = thread.com
   text = string.gsub(text, "<a href=\"/.-\" class=\"quotelink\">.-</a>", "")
   text = string.gsub(text, "%s.-%sThread", "")
   text = html2text(text)
   if string.len(text) >= max_characters then
      text = string.sub(text, 1, max_characters).."\n[...]"
   end
   
   if thread.tim ~= nill and thread.ext ~= nil and send_image then
     send_photo_from_url(get_receiver(msg), "http://i.4cdn.org/vg/"..thread.tim..thread.ext)
   end
   if thread.sub ~= nill and display_thread_subject then
     text = thread.sub..":\n"..text
   end
   return text
end

return {
   description = "Get a random thread.",
   usage = "!4chan: get a random thread",
   patterns = {"^!4chan$"},
   run = run
}
