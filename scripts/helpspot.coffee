# interact with helpspot
#
# "blah blah hs 58985"
# "# - customer - link"

class HelpspotHandler
	constructor: (@msg) ->
		@username = process.env.HUBOT_HELPSPOT_USER
		@password = process.env.HUBOT_HELPSPOT_PASSWORD
		@auth = "Basic " + new Buffer(@username + ":" + @password).toString('base64')
		console.log "creating HelpspotHandler"
		
	getIssueJson: (id, callback) ->
		console.log " calling getIssueJson "
		@msg.http("http://app.zsservices.com/helpspot/api/index.php")
			.header('Authorization', @auth)
			.query("method", "private.request.get")
			.query("output", "json")
			.query("xRequest", id)
			.get() (err, res, body) ->
				callback(err, JSON.parse(body))
				
	getCaseDetails: (id) ->
		@getIssueJson id, (err, hsCase) ->
			console.log " got to the callback "
			@msg.send "assigned to: #{hsCase.xPersonAssignedTo}, status: #{hsCase.xStatus}"
				
module.exports = (robot) ->
	robot.hear /\b(?:hs|HS|Hs|Hs)[ ]?[-#]?[ ]?([\d]+)/i, (msg) ->
		console.log " I heard a helpspot case "
		handler = new HelpspotHandler msg
		handler.getCaseDetails msg.match[1]