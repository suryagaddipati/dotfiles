return {
  'numToStr/Comment.nvim',
  keys = {
    { 'gcc', mode = 'n' },
    { 'gc', mode = 'v' },
  },
  config = function()
    require('Comment').setup()
  end,
}