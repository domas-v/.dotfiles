local vault = vim.env.NOTES_VAULT
if not vault or vault == "" then
    vault = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/in obs"
end
vault = vim.fs.normalize(vim.fn.expand(vault))

return {
    vault = vault,
    daily_folder = "daily",
    templates = vim.fs.joinpath(vault, "templates"),
    template = vim.fs.joinpath(vault, "templates", "daily-note-nvim.md"),
    inbox = vim.fs.joinpath(vault, "inbox.md"),
    index = vim.fs.joinpath(vault, "index.md"),
}
