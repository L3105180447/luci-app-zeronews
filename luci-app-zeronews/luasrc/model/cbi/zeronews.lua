local sys = require "luci.sys"
local http = require "luci.http"

if http.formvalue("do_zeronews_reset") then
	sys.call("rm -rf /etc/zeronews >/dev/null 2>&1")
end

if http.formvalue("do_zeronews_clear_log") then
	sys.call("rm -f /etc/zeronews/zeronews.txt >/dev/null 2>&1")
end

m = Map("zeronews", "ZeroNews 零讯",
	"ZeroNews 是一个创新的边缘云内网穿透平台，旨在帮助用户快速解决内网与外网之间的安全、快速访问需求，官网：<a href=\"https://zeronews.cc\" target=\"_blank\">https://zeronews.cc</a>。")

s1 = m:section(TypedSection, "zeronews", "状态")
s1.anonymous = true
s1.addremove = false

local running = (sys.call("pidof zeronews >/dev/null") == 0)
st = s1:option(DummyValue, "_status", "状态")
st.rawhtml = true
if running then
	st.value = "<span style='color:green;font-weight:bold;'>运行中</span>"
else
	st.value = "<span style='color:red;font-weight:bold;'>未运行</span>"
end

panel = s1:option(DummyValue, "_panel", "管理后台")
panel.rawhtml = true
panel.value = [[
<a href="https://user.zeronews.cc" target="_blank" rel="noreferrer noopener">
	<input type="button" class="cbi-button cbi-button-apply" value="打开 Web 界面" />
</a>
]]

s2 = m:section(TypedSection, "zeronews", "设置")
s2.anonymous = true
s2.addremove = false

enable = s2:option(Flag, "enabled", "启用")
enable.rmempty = false
enable.default = 0

token = s2:option(Value, "token", "Token")
token.password = true
token.rmempty = false
token.placeholder = "请输入您的 Token"
token.datatype = "string"

reset_btn = s2:option(DummyValue, "_reset", "复位", "说明：ZeroNews Agent 如出现异常或需重置配置，可执行重置一键删除已有配置文件。")
reset_btn.rawhtml = true
reset_btn.value = '<input type="submit" class="cbi-button cbi-button-remove" name="do_zeronews_reset" value="重置ZeroNews" />'

s3 = m:section(TypedSection, "zeronews", "日志")
s3.anonymous = true
s3.addremove = false

clear_log = s3:option(DummyValue, "_clear", "日志操作")
clear_log.rawhtml = true
clear_log.value = '<input type="submit" class="cbi-button cbi-button-remove" name="do_zeronews_clear_log" value="清除日志" />'

local log_content = sys.exec("cat /etc/zeronews/zeronews.txt 2>/dev/null")
if log_content == nil or log_content == "" then
	log_content = "暂无日志，或日志文件尚未生成。"
end

log_view = s3:option(DummyValue, "_log_view", "日志内容")
log_view.rawhtml = true
log_view.value = string.format(
	"<textarea readonly='readonly' wrap='off' style='width: 100%%; height: 300px; background-color: #f8f9fa; border: 1px solid #ccc; padding: 8px; font-family: monospace; resize: vertical;'>%s</textarea>", 
	log_content:gsub("<", "&lt;"):gsub(">", "&gt;")
)

function m.on_after_commit(self)
	local enabled = sys.exec("uci -q get zeronews.@zeronews[0].enabled 2>/dev/null"):gsub("\n", "")
	if enabled == "1" then
		sys.call("/etc/init.d/zeronews enable >/dev/null 2>&1")
		sys.call("/etc/init.d/zeronews restart >/dev/null 2>&1")
	else
		sys.call("/etc/init.d/zeronews stop >/dev/null 2>&1")
		sys.call("/etc/init.d/zeronews disable >/dev/null 2>&1")
	end
end

return m