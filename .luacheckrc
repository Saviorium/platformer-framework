ignore = {
   "212",  -- unused argument 'self'
}

globals = {
  -- lua
  "unpack",

  -- love and libs
  "love",
  "Class",
  "Vector",
  "serpent", -- todo: include by demand only

  -- engine
  "StateManager",
  "AssetManager",
  "MusicPlayer",
  "SoundManager",
  "UserInputManager"
  "states",
  "config",
  "Debug",
  "vardump",
  -- utils
  math = {
    fields = {
      "clamp"
    }
  },
  "isIn",
  "getIndex",

  -- game
}
