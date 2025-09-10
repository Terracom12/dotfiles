-- Not much of a web dev, and this is annoyingly asking me to install pnpm
if true then return {} end

return {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
}
