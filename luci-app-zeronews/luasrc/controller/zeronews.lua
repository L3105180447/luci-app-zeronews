module("luci.controller.zeronews", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/zeronews") then
		return
	end

	entry({"admin", "services", "zeronews"}, cbi("zeronews"), _("ZeroNews"), 60).dependent = true
end
