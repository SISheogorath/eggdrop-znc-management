eggdrop-znc-management
======================

management script for znc using an eggdrop

<b>1. Preperation of Eggdrop</b>

Change in $eggdropdir/src/eggdrop.h the line with "#define HANDLEN 9" to your Network Nicklength or higher
than (re)compile your bot sources

<b>2. Requirements</b>

A eggdrop bot which is connected to your irc network via ZNC
On ZNC the modules controlpanel and blockuser must be loaded
installed and working sendmail on bothost


Your Eggdrop should not share his userlist with another eggdrop which is not administrating your (same) ZNC Server.


<b>3. Installation</b>
 
copy the script to your eggdrops scriptdir. 
create every existing ZNC user using .+user zncusername
(to stop overwriting an ZNC account)

change the settings inside script (please don't modify to much sources. If you have feature requests, no problem, tell it to me)

load the script inside your eggdrop conf using source scripts/znc.tcl

To administrate your ZNC you have to set userflag +Y for all you ZNC users please set +Z. (so maybe you could share but not recommented)

finally add the channelflag +znc to your ZNC Management channel or run your Bot as /msg only bot. (like some services bots)

<b>4. Discription and Commands</b>
the znc.tcl adds an request and administration panel to your ZNC for an eggdrop. So your Users can request a ZNC Account and after a confirm by the ZNC Admins (marked with +Y) the bot will send an e-mail to the User with Login, password and serverurl. 

Commands:
(!)help                 - gerneates Help output
(!)request              - requests an ZNC account
Admins:
(!)confirm              - confirms an account request
(!)deny                 - denies an account request 
(!)delUser              - dels an user from ZNC and removes is entry inside eggdrop (to stop name reservation)
(!)ListUnconfirmedUsers - lists unconfirmed user
(!)LUU                  - same as (!)ListUnconfirmedUsers

All commands works via privatemsg without prefix (!). prefix is customizeable in script's config part. 

