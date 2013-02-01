// Scoreboard Icons
if kDAKConfig and kDAKConfig.ScoreboardIcons then
	Script.Load("lua/TGNSCommon.lua")

	local function prependPlayerName(playerName, text)
		if text and string.len(text) then
			return string.sub(text .. " " .. playerName, 0, kMaxNameLength)
		end
		return playerName
	end

	local originalBuildScoresMessage = BuildScoresMessage

	function BuildScoresMessage(scorePlayer, sendToPlayer)
		local t = originalBuildScoresMessage(scorePlayer, sendToPlayer)

		local match = false
		local client = Server.GetOwner(scorePlayer)
		if client and t and t.playerName then
			if DAKIsPlayerAFK(scorePlayer) then
				t.playerName = prependPlayerName(t.playerName, kDAKConfig.ScoreboardIcons.AFK)
			else
				local groupIcons = kDAKConfig.ScoreboardIcons.GroupIcons
				table.sort(groupIcons, function(t1, t2) return t1.sort < t2.sort end)
				for _, groupicon in ipairs(groupIcons) do
					if DAKGetClientIsInGroup(client, groupicon.group) then
						t.playerName = prependPlayerName(t.playerName, groupicon.icon)
						match = true
						break
					end
				end
				if not match then
					t.playerName = prependPlayerName(t.playerName, kDAKConfig.ScoreboardIcons.CatchAll)
				end
			end
		end
		
		return t
	end

end

Shared.Message("Scoreboard Icons Loading Complete")
