local new_fact = function()
  local curl = require("plenary.curl")
  local api_key = os.getenv("OPENAI_API_KEY")
  if api_key == nil then
    return "no api key"
  end
  local body = {
    model = "gpt-4o",
    messages = {
      {
        role = "system",
        content = os.getenv("SECRET_ROLE") or "comedian",
      },

      {
        role = "user",
        content = os.getenv("SECRET_PROMPT") or "tell a short joke",
      },
    },
  }
  local response = curl.post({
    url = "https://api.openai.com/v1/chat/completions",
    headers = { content_type = "application/json", authorization = string.format("Bearer %s", api_key) },
    body = vim.fn.json_encode(body),
  })

  if response.status == 200 then
    local ok, result = pcall(function()
      local res = vim.fn.json_decode(response.body)
      if res ~= nil then
        return res.choices[1].message.content
      else
      end
    end)

    if ok then
      result = string.gsub(result, "\n", "")
      return result
    else
      error(result)
    end
  else
    print("Request failed with status:", response.status)
    return string.format("Failed with status %s", response.status)
  end
end

return new_fact
