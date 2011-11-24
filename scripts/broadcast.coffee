# broadcast a message to every room the bot is in
#
# allhands [msg]

module.exports = (robot) ->
  robot.respond /(?:(allhands|broadcast)) (.+)/i, (msg) ->
    currentRoom = msg.message.user.room
    msg.send 'oh yeah, we have a bot' if msg.robot.adapter.bot?
    for roomId in process.env.HUBOT_CAMPFIRE_ROOMS.split(",")
      do (roomId) ->
        msg.message.user.room = roomId
        msg.send msg.match[2]