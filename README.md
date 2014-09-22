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


