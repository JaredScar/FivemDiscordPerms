# FivemDiscordPerms
## About
This project was started by Badger in March of 2020 in response to Discord disabling 
Fivem's API requests utilizing the RPC method they used without Discord's permission.
Many fivem servers used the discord features in script and it made life so much 
easier... FivemDiscordPerms aims to bring back that ease again, however has
a workaround to getting users' discords.

## Not interested in setting all this up?
No worries! Take a look down at `Publicy Available FivemDiscordPerms Website`! All
you have to do is download the `BadgerDiscordAPI` directory, put that in your
`/resources` of your fivem server, then you change the port within the config section
of the `server.lua` file. Wa-la! Enjoy!

## How it works?
Essentially, FivemDiscordPerms has a database in which holds the information of players
who join your server. You run this website along with the database and fivem script.
When a player joins and does not have a database account, they will be instructed
to create one as soon as they spawn in the server. We also have the option of running
this website publicly for all to use, but this may cause rate-limiting, so it may be
a better idea for you to run it individually for your servers only. However, in case
you want the publicly available version (no setup required besides the Fivem script),
you can find that further below including more information.

## Publicly Available FivemDiscordPerms Website
Alternatively, if you aren't too experienced with development things, you can try
relying on the website I provided that I use for my server. I am not sure how this
will handle multiple servers using it, so I consider this more as an experiment
than anything else. If you want this as a real valid solution, then set it up only
for your servers to use (your own discord application and database). The publicly
available FivemDiscordPerms website is already provided within the config. All you
need to change within the server.lua of the script is the port to match the server's
port it is running from.


## How do I as a developer use the Fivem script?
So clearly, I couldn't take over Fivem's identifiers function. I however made the
function exported named `GetDiscordIdentifier(src)` in which you pass `src` as the
player source within the server-side of your script. To fully utilize this 
(within a lua script, not sure about C#, so please make a pull request if you do):
`exports.BadgerDiscordAPI:GetDiscordIdentifier(src)`

## Further Documentation
The further documentation for this project can be found over at 
https://docs.badger.store/badger-software/fivemdiscordperms