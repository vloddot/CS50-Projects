--[[
    This is where the program loads all of the libraries, game states, and constants
]]

-- Push library
push = require 'lib/push'

-- Class library
Class = require 'lib/class'

-- Constants file in ~/src/
require 'src/constants'

-- Ball class file in ~/src/
require 'src/Ball'

-- Paddle class file in  ~/src/
require 'src/Paddle'

-- State machine user-created library in ~/src/
require 'src/StateMachine'

-- All of the game states used
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/ServeState'
require 'src/states/PlayState'
require 'src/states/DoneState'