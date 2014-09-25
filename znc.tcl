###############################################################################
### Preconfiguration please don't change...
### Script Logic ## Handle with care!
###############################################################################
set scriptname "Shivering-Isles ZNC managment script"
set scriptOwner "Christoph Kern"
set scriptOwnerMail "Sheogorath@shivering-isles.de" 
set scriptchannel "#ZNC"
set scriptOwnerNetwork "irc.shivering-isles.de"
set scriptversion "0.7.0.1"
set scriptdebug 0

putlog "$scriptname loading configuration..."

###############################################################################
### End of Preconfig
###############################################################################


###############################################################################
### Start of config
###############################################################################


### Script --------------------------------------------------------------------
# Script specific settings
# 
# 
###----------------------------------------------------------------------------

## set to 0 to minimize script putlog part
set scriptUseBigHeader 1

## Advertice ScriptOwner
set adverticeScriptOwner 0

## Prefix for triggering Bot Commands things like !request or .request
set scriptCommandPrefix "!"

## Sendmailpath !!!!! YOU REALLY NEED TO CHECK THE PATH !!!!!
set sendmailPath "/usr/sbin/sendmail"

### ZNC -----------------------------------------------------------------------
# Here you can configure your whole ZNC settings
#
# 
###----------------------------------------------------------------------------

## ZNC Network name
set zncnetworkname "Shivering-Isles ZNC"

## The prefix set for Modules for Bot's ZNC-User
set zncprefix "*"

## The DNS-Host of your ZNC Server
set znchost "znc.shivering-isles.de"

## The ZNC NON-SSL Port, if not exists set ""
set zncNonSSLPort "65534"

## The ZNC SSL Port, if not exists set ""
set zncSSLPort "65535"

## The ZNC-Webinterface NON-SSL Port, if not exists set ""
set zncWebNonSSLPort "65534"

## The ZNC-Webinterface SSL Port, if not exists set ""
set zncWebSSLPort "65535"

## The Name of server support/admin
set zncAdminName "Sheogorath"

## The E-Mail address of server support/admin
set zncAdminMail "znc@shivering-isles.de"

## The Level of Security for the random generated password for new ZNC-users (recommanded is 3 means [a-zA-Z0-9])
set zncPasswordSecurityLevel 3

## The Length of the automatic generated password)
set zncPasswordLength 16

### Optional - Preconfiguration -----------------------------------------------
# Default Modules and Networks
# !!!!!!! DISABLED !!!!!!!! FEATURE COMMING SOON !!!!!!!!
# 
###----------------------------------------------------------------------------

## Default User Modules loaded, if not exists set { } if you use arguments do it like that: "autoreply \"I'll be back soon\""
#set defaultUserModules { "chansaver" "controlpanel" "buffextras" "autoreply \"I'll be back soon\""}
set zncDefaultUserModules {  }

## Default User Modules loaded, if not exists set { } if you use arguments do it like that: "autoreply \"I'll be back soon\""
#set defaultUserModules { "chansaver" "controlpanel" "buffextras" "autoreply \"I'll be back soon\""}
set zncDefaultNetworkModules {  }

### Preconfigured Networks
## Enable Preconfigured Networks
set usePreconfiguredNetworks 1

## Array of Preconfigured Networks (only works if usePreconfiguredNetworks is set to 1 )
array set knownNetworks {
	shivering-isles "irc.shivering-isles.de +6697"
	freenode 		"irc.freenode.net +7000"
	euircnet		"irc.euirc.net +6697"
}

## Forces to 1 Network  !!!!!!! DISABLED !!!!!!!! FEATURE COMMING SOON !!!!!!!!
#set zncEnforcedNetwork "irc.shivering-isles.de +6697"
set zncEnforcedNetwork ""


### Optional - Topic Settings -------------------------------------------------
# Topic Settings
# !!!!!!! DISABLED !!!!!!!! FEATURE COMMING SOON !!!!!!!!
# 
###----------------------------------------------------------------------------

## Change Topic 1 means on 0 means off
set zncTopic 0

## Show Number of ZNC users in Topic
set zncTopicUsercount 1

## Show Serverdata in Topic
set zncTopicServerdata 1

## Show Name of server support/admin
set zncTopicShowAdmin 1

## Topicprefix
set zncTopicPrefix ""

## GreetSuffix
set zncTopicSuffix ""


### Optional - Greeting Settings ----------------------------------------------
# Settings for Greeting 
# !!!!!!! DISABLED !!!!!!!! FEATURE COMMING SOON !!!!!!!!
# 
###----------------------------------------------------------------------------

## Show Greeting 1 means on 0 means off
set zncGreeting 0

## Greet prefix (possible values for replace: %nick% %channel%)
set zncGreetPrefix "\00300,01"

## Greet suffix (possible values for replace: %nick% %channel%)
set zncGreetSuffix "\003"

## Greet Messages (possible values for replace: %nick% %channel% %zncAdminName% %zncAdminMail% %zncNonSSLPort% %zncSSLPort% %zncWebSSLPort% %zncWebNonSSLPort% %znchost%)
set zncGreetings {
	"Hello %nick%, stay here or manage you ZNC Account via https://%znchost%:%zncWebSSLPort%!"
	"Hello %nick%, welcome to %channel%!"
	"Welcome %nick%, %channel% is for ZNC management. To request a ZNC-Account use !help request"
	}


### Optional - Advertice ------------------------------------------------------
# Settings for advertice your network
# !!!!!!! DISABLED !!!!!!!! FEATURE COMMING SOON !!!!!!!!
# 
###----------------------------------------------------------------------------

## Do Advertice 1 means on 0 means off (if 0 scriptAdvertice is off, too)
set zncAdvertice 0

## Show Number of ZNC users in Advertice
set zncAdverticeUsercount 1

## Show Serverdata in Topic
set zncAdverticeServerdata 1

## Show Name of server support/admin
set zncAdverticeShowAdmin 1

## Sentences for Advertice
#set zncAdverticeSenteces { } #disabled
set zncAdverticeSenteces { 
	"Get your Free ZNC now!" 
	""}


###############################################################################
### End of Config
###############################################################################

###############################################################################
### Script Logic ## Handle with care! (If you change 1 character my support ends)
###############################################################################
putlog "$scriptname configuration loaded"
putlog "$scriptname loading script..."

if { $scriptUseBigHeader } {
	putlog "$scriptname is wirtten by $scriptOwner"
	putlog "If you need help join irc://$scriptOwnerNetwork/$scriptchannel"
	putlog "If you can't join or want to contact me inanother way, you can E-Mail to $scriptOwnerMail"
	putlog "Enjoin your work with $scriptname"
}

if { $scriptdebug } {
	putlog "!!!!!!!!!!!!WARNING!!!!!!!!!!!!!!"
	putlog "RUNNING SCRIPT IN DEBUG MODE! DO NOT RUN PRODUCTIVE!"
}

### Bot Commands --------------------------------------------------------------

proc znc:request { nick host handle chan text } {
	global scriptCommandPrefix zncPasswordSecurityLevel zncPasswordLength zncnetworkname zncDefaultUserModules zncDefaultNetworkModules
	set username [lindex $text 0]
	set email [lindex $text 1]
	set networkname [lindex $text 2]
	set server [lindex $text 3]
	set port [lindex $text 4]
	if { $email == ""} { 
		puthelp "NOTICE $nick :${scriptCommandPrefix}request syntax is \"${scriptCommandPrefix}request <zncusername> <e-mail-address> \[<networkname> \[<serveraddress> <\[+\]port>\]\]\" for more please use \"${scriptCommandPrefix}help reqest\""
		return
	} else {
		set password [znc:helpfunction:generatePassword  $zncPasswordSecurityLevel $zncPasswordLength ]
		if [ adduser $username ] {
			setuser $username COMMENT $email
			chattr $username +ZC
			znc:controlpanel:AddUser $username $password 
			znc:blockuser:block $username 
			znc:helpfunction:loadModuleList $username $zncDefaultUserModules
			if { $networkname != ""} {
				set preServer ""
				if { $usePreconfiguredNetworks } {
					set preServer [array names knownNetworks -exact [string tolower $networkname]]
				}
				znc:controlpanel:AddNetwork $username $networkname
				znc:helpfunction:loadNetModuleList $username $networkname $zncDefaultNetworkModules
				if { $preServer != "" } {
					foreach {networkname networkserver} [array get knownNetworks [string tolower $networkname]] {
						znc:controlpanel:AddServer $username $networkname $networkserver 
					}
				} else {
					if { $port != "" } {
						znc:controlpanel:AddServer $username $networkname "$server $port"
					}
				}
			}
			puthelp "NOTICE $nick :Hey $nick, your request for $username is noticed and after confirm by an administrator you'll get an email with all needed data."
		} else {
			puthelp "NOTICE $nick :Sry, but your wanted username is already in use..."
		}
	}
}

proc znc:confirm {nick host handle chan text} {
	global scriptCommandPrefix zncPasswordSecurityLevel zncPasswordLength
	set username [lindex $text 0]
	if {$username == "" } {
		puthelp "NOTICE $nick :${scriptCommandPrefix}Confirm syntax is \"${scriptCommandPrefix}Confirm <zncusername>\" for more please use \"${scriptCommandPrefix}help Confirm"
	}
	if [ matchattr $username C] {
		set password [znc:helpfunction:generatePassword $zncPasswordSecurityLevel $zncPasswordLength ]
		znc:controlpanel:Set "password" $username $password 
		mail:simply:sendUserRequest $username $password 
		znc:blockuser:unblock $username 
		chattr $username -C
		puthelp "NOTICE $nick :$username is now confirmed."
	} elseif { validuser $username } {
		puthelp "NOTICE $nick :$username is already confirmed."
	} else {
		puthelp "NOTICE $nick :$username does not exist"
	}
}

proc znc:deny {nick host handle chan text} {
	global scriptCommandPrefix
	set username [lindex $text 0]
	if {$username == "" } {
		puthelp "NOTICE $nick :${scriptCommandPrefix}Deny syntax is \"${scriptCommandPrefix}Deny <zncusername>\" for more please use \"${scriptCommandPrefix}help Deny"
	}
	if [ matchattr $username C ] {
		znc:controlpanel:DelUser $username 
		deluser $username
		puthelp "NOTICE $nick :$username is now denied."
	} elseif { validuser $username } {
		puthelp "NOTICE $nick :$username is already confirmed. Use \"${scriptCommandPrefix}DelUser <username>\" to remove"
	} else {
		puthelp "NOTICE $nick :$username does not exist"
	}
}

proc znc:delUser {nick host handle chan text} {
	global scriptCommandPrefix
	set username [lindex $text 0]
	if {$username == "" } {
		puthelp "NOTICE $nick :${scriptCommandPrefix}DelUser syntax is \"${scriptCommandPrefix}DelUser <zncusername>\" for more please use \"${scriptCommandPrefix}help DelUser"
	}
	if [ validuser $username ] {
		znc:controlpanel:DelUser $username 
		deluser $username
		puthelp "NOTICE $nick :$username is now deleted."
	} else {
		puthelp "NOTICE $nick :$username does not exist"
	}
}

proc znc:listUnconfirmed {nick host handle chan text} {
	global scriptCommandPrefix
	set UnConfirmedList [join [ userlist C ] ,]
	if { $UnConfirmedList != "" } {
		puthelp "NOTICE $nick :Unconfirmed users: $UnConfirmedList"
	} else {
		puthelp "NOTICE $nick :no unconfirmed users"
	}
}

proc znc:help {nick host handle chan text} {
	global scriptCommandPrefix zncAdminName scriptname botnick
	set helpcontext [lindex $text 0]
	if { $helpcontext != "" } {
		switch [string tolower $helpcontext] {
			request {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}Request"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}Request you can request an ZNC-Account that Account"
				puthelp "NOTICE $nick :#is just waiting for a confirm or deny by $zncAdminName. If it is confirmed you'll"
				puthelp "NOTICE $nick :#get an e-mail with address and password for your Account."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#You can instantly add a network or own network with optional parameters."
				puthelp "NOTICE $nick :#If you want to connect to IRC using SSL you have to add a + in front of port number."
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}request <zncusername> <e-mail-address> \[<networkname> \[<serveraddress> <\[+\]port>\]\]"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}request Foo foo@bar.com foonet irc.foo.net +6697"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick request <zncusername> <e-mail-address> \[<networkname> \[<serveraddress> <\[+\]port>\]\]"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   /msg $botnick request Foo foo@bar.com foonet irc.foo.net +6697"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			listunconfirmedusers {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}ListUnconfirmedUsers"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}ListUnconfirmedUsers $zncAdminName gets a list of unconfirmed"
				puthelp "NOTICE $nick :#users."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}ListUnconfirmedUsers"
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}ListUnconfirmedUsers"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick ListUnconfirmedUsers"
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick ListUnconfirmedUsers"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			confirm {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}Confirm"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}Confirm $zncAdminName can confirm ZNC Account requests."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}Confirm <zncusername>"
					puthelp "NOTICE $nick :#Example:"
				puthelp "NOTICE $nick :#   ${scriptCommandPrefix}Confirm Foo"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#  /msg $botnick Confirm <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   /msg $botnick Confirm Foo"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			deny {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}Deny"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}Deny $zncAdminName can deny ZNC Account requests."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}Deny <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}Deny Foo"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick Deny <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   /msg $botnick Deny Foo"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			deluser {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}DelUser"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}DelUser $zncAdminName can delete ZNC Accounts if they are"
				puthelp "NOTICE $nick :#already confirmed."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}DelUser <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}DelUser Foo"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick DelUser <zncusername>"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   /msg $botnick DelUser Foo"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			help {
				puthelp "NOTICE $nick :#Help for ${scriptCommandPrefix}help"
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#With ${scriptCommandPrefix}help you'll get messages like this one..."
				puthelp "NOTICE $nick :# "
				puthelp "NOTICE $nick :#-----------------"
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}help \[<command>\]"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   ${scriptCommandPrefix}help request"
				} else {
					puthelp "NOTICE $nick :#Syntax:"
					puthelp "NOTICE $nick :#   /msg $botnick help \[<command>\]"
					puthelp "NOTICE $nick :#Example:"
					puthelp "NOTICE $nick :#   /msg $botnick help request"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
			default {
				if { $chan != $nick } {
					puthelp "NOTICE $nick :#please use ${scriptCommandPrefix}help without parameters for full command list"
				} else {
					puthelp "NOTICE $nick :#please use /msg $botnick help without parameters for full command list"
				}
				puthelp "NOTICE $nick :### End of Help ###"
			}
		}
	} else {
		puthelp "NOTICE $nick :#$scriptname Command list:"
		puthelp "NOTICE $nick :#request    	           |Requests an ZNC Account"
		puthelp "NOTICE $nick :#ListUnconfirmedUsers    |Lists unconfirmed ZNC Account"
		puthelp "NOTICE $nick :#Confirm                 |Confirms ZNC Account request"
		puthelp "NOTICE $nick :#Deny                    |Denies a ZNC Account request"
		puthelp "NOTICE $nick :#DelUser                 |Deletes a confirmed ZNC Account"
		puthelp "NOTICE $nick :#help                    |Shows help for commands"
		puthelp "NOTICE $nick :# "
		puthelp "NOTICE $nick :#Use \"${scriptCommandPrefix}help <command>\" for full helpcontext."
		puthelp "NOTICE $nick :# "
		puthelp "NOTICE $nick :#-----------------"
		if { $chan != $nick } {
			puthelp "NOTICE $nick :#Syntax:"
			puthelp "NOTICE $nick :#   ${scriptCommandPrefix}help \[<command>\]"
			puthelp "NOTICE $nick :#Example:"
			puthelp "NOTICE $nick :#   ${scriptCommandPrefix}help request"
		} else {
			puthelp "NOTICE $nick :#Syntax:"
			puthelp "NOTICE $nick :#   /msg $botnick help \[<command>\]"
			puthelp "NOTICE $nick :#Example:"
			puthelp "NOTICE $nick :#   /msg $botnick help request"
		}
		puthelp "NOTICE $nick :### End of Help ###"
	}
}


### ZNC - Functions -----------------------------------------------------------

proc znc:controlpanel:AddNetwork { username network } {
	znc:sendTo:Controlpanel "AddNetwork $username $network"
}

proc znc:controlpanel:AddServer { username network server } {
	znc:sendTo:Controlpanel "AddServer $username $network $server "
}

proc znc:controlpanel:AddUser { username password } {
	znc:sendTo:Controlpanel "AddUser $username $password"
}

proc znc:controlpanel:DelNetwork { username network } {
	znc:sendTo:Controlpanel "DelNetwork $username $network"
}

proc znc:controlpanel:DelUser { username } {
	znc:sendTo:Controlpanel "DelUser $username"
}

proc znc:controlpanel:Disconnect { username network } {
	znc:sendTo:Controlpanel "Disconnect $username $network"
}

proc znc:controlpanel:LoadModule { username modulename {args ""} } {
	if { $args == ""} {
		znc:sendTo:Controlpanel "LoadModule $username $modulename"
	} else {
		znc:sendTo:Controlpanel "LoadModule $username $modulename $args"
	}
}

proc znc:controlpanel:LoadNetModule { username network modulename {args ""} } {
	if { $args == ""} {
		znc:sendTo:Controlpanel "LoadNetModule $username $network $modulename"
	} else {
		znc:sendTo:Controlpanel "LoadNetModule $username $network $modulename $args"
	}
}

proc znc:controlpanel:Reconnect { username network } {
		znc:sendTo:Controlpanel "Reconnect $username $network"
}

proc znc:controlpanel:Set { variable username value } {
	znc:sendTo:Controlpanel "Set $variable $username $value"
}

proc znc:controlpanel:SetChan { variable username network chan value } {
	znc:sendTo:Controlpanel "SetChan $variable $username $network $chan $value"
}

proc znc:controlpanel:SetNetwork { variable username network value } {
	znc:sendTo:Controlpanel "SetNetwork $variable $username $network $value"
}

proc znc:blockuser:block { username } {
	znc:sendTo:blockuser "block $username"
}

proc znc:blockuser:unblock { username } {
	znc:sendTo:blockuser "unblock $username"
}


### Help functions ------------------------------------------------------------
proc znc:helpfunction:generatePassword { secureityLevel passwordLength } {
	set return "" 
	if { $secureityLevel >0 } {
	set pool {"1" "2" "3" "4" "5" "6" "7" "8" "9"}
	}
	if { $secureityLevel >1 } {
	lappend pool "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"	
	}
	if { $secureityLevel >2 } {
	lappend pool "A" "B" "C" "D" "E" "F" "G" "H" "T" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
	}
	if { $secureityLevel > 3 } {
	lappend pool "%" "&" "@" "_" "-" "!" "\$" "/" "\\" "." "," ";" "#" "+" "*" "~" "?" "="
	}
	if { $secureityLevel > 4 } {
	lappend pool "ä" "ö" "ü" "Ä" "Ü" "Ö" "ß" "<" ">" "|" "á" "ú" "ó" "é" "à" "ò" "ù" "è" "€" "â" "ô" "ê" "û"
	}
	if { $pool == "" } { return }
	for { set i 1 } { $i < $passwordLength } { incr i } {
		set return [string append $return [znc:helpfunction:randelem $pool]]
	}
	return $return
}


### Helpfunction for znc:helpfunction:generatePassword
if {[catch {string append}]} then {
    rename string STRING_ORIGINAL
    proc string {cmd args} {
        switch -regexp -- $cmd {
            ^a(p(p(e(n(d)?)?)?)?)?$ {
                uplevel [list join $args {}]
            }
            default {
                if {[catch {
                    set result [uplevel [list STRING_ORIGINAL $cmd] $args]
                } err]} then {
                    return -code error\
                        [STRING_ORIGINAL map\
                             [list\
                                  STRING_ORIGINAL string\
                                  ": must be bytelength,"\
                                  ": must be append, bytelength,"]\
                             $err]
                } else {
                    set result
                }
            }
        }
    }
 }
###----------------------------------------------------------------------------
proc znc:helpfunction:randelem {list} {
    lindex $list [expr {int(rand()*[llength $list])}]
}

proc znc:helpfunction:loadModuleList { username list } {
    foreach module $list {
		znc:controlpanel:LoadModule $username $module
	}
}

proc znc:helpfunction:loadNetModuleList { username network list} {
    foreach module $list {
		znc:controlpanel:LoadNetModule $username $network $module
	}
}

proc mail:simply:send { usermail subject content } {
	global zncAdminMail
	mail:sendTo:user $zncAdminMail $usermail $subject $content 
}

proc mail:simply:sendUserRequest { username password } {
	global zncnetworkname znchost zncNonSSLPort zncSSLPort zncWebNonSSLPort zncWebSSLPort zncAdminName zncAdminMail 
	set email [getuser $username COMMENT]
	set content "Hey $username,\n\n You've requested a ZNC-Account hosted by $zncnetworkname\n\nYou have to wait for the confirm by an Admin of our ZNC. If it's done use the following data to login:\n\n"
	append content \n\n "Our ZNChost is: $znchost"
	if { $zncNonSSLPort != "" } {
	append content \n "To connect your IRC Client via NON-SSL connect to: ${znchost}:${zncNonSSLPort}"
	}
	if { $zncSSLPort != "" } {
	append content \n "To connect your IRC Client via SSL connect to: ${znchost}:${zncSSLPort}"
	}
	append content \n "Your ZNC Username is: $username"
	append content \n "Your ZNC Password is: $password"
	append content \n "To Connect to ZNC-Server use \"${username}:${password}\" as server-password"
	if { $zncWebNonSSLPort != "" } {
	append content \n "To login via NON-SSL-Webinterface goto: http://${znchost}:${zncWebNonSSLPort}"
	}
	if { $zncWebSSLPort != "" } {
	append content \n "To login via SSL-Webinterface goto: https://${znchost}:${zncWebSSLPort}"
	}
	if { $zncAdminMail != "" } {
	append content \n\n\n\n "If this e-mail is spam please instantly contact $zncAdminMail"
	}
	mail:simply:send $email "Requested ZNC-Account at $zncnetworkname" $content 
}

proc eggdrop:helpfunction:isNotZNCChannel { chan } {
	return [expr ! [channel get $chan znc]]
}

proc debug:helpfunction:test { nick host handle text } {
	puthelp "PRIVMSG $nick :Channels: [join [channels] ,]"
	puthelp "PRIVMSG $nick :[eggdrop:helpfunction:isNotZNCChannel "#ZNC" ]"
}

proc debug:helpfunction:testchan { nick host handle chan text } {
	global zncPasswordSecurityLevel zncPasswordLength
	puthelp "PRIVMSG $nick :$chan"
	puthelp "PRIVMSG $nick :[znc:helpfunction:generatePassword  $zncPasswordSecurityLevel $zncPasswordLength ]"
}

### sendTo - Functions --------------------------------------------------------
proc znc:sendTo:Controlpanel { command } {
	global zncprefix
	putquick "PRIVMSG ${zncprefix}controlpanel :$command"
}

proc znc:sendTo:blockuser { command } {
	global zncprefix
	putquick "PRIVMSG ${zncprefix}blockuser :$command"
}

proc mail:sendTo:user { from to subject content {cc "" } } {
	global sendmailPath
	set msg {From: $from}
	append msg \n "To: " [join $to , ]
	append msg \n "Cc: " [join $cc , ]
	append msg \n "Subject: $subject"
	append msg \n\n $content

	exec $sendmailPath -oi -t << $msg
}


### Commands - Functions ------------------------------------------------------

## Request Commands
proc znc:PUB:request {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:request $nick $host $handle $chan $text
}

proc znc:MSG:request {nick host handle text} {
	znc:request $nick $host $handle $nick $text
}

## Confirm Commands
proc znc:PUB:confirm {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:confirm $nick $host $handle $chan $text
}

proc znc:MSG:confirm {nick host handle text} {
	znc:confirm $nick $host $handle $nick $text
}

## Deny Commands
proc znc:PUB:deny {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:deny $nick $host $handle $chan $text
}

proc znc:MSG:deny {nick host handle text} {
	znc:deny $nick $host $handle $nick $text
}

## DelUser Commands
proc znc:PUB:delUser {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:delUser $nick $host $handle $chan $text
}

proc znc:MSG:delUser {nick host handle text} {
	znc:delUser $nick $host $handle $nick $text
}

## ListUnconfirmedUsers Commands
proc znc:PUB:listUnconfirmed {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:listUnconfirmed $nick $host $handle $chan $text
}

proc znc:MSG:listUnconfirmed {nick host handle text} {
	znc:listUnconfirmed $nick $host $handle $nick $text
}

## Help Commands
proc znc:PUB:help {nick host handle chan text} {
	if [eggdrop:helpfunction:isNotZNCChannel $chan ] { return }
	znc:help $nick $host $handle $chan $text
}

proc znc:MSG:help {nick host handle text} {
	znc:help $nick $host $handle $nick $text
}


### custom flags --------------------------------------------------------------

## ZNC Channel flag
setudef flag znc


### binds ---------------------------------------------------------------------

## public binds ---------------------------------------------------------------
bind PUB - "${scriptCommandPrefix}Request" znc:PUB:request
bind PUB Y "${scriptCommandPrefix}Confirm" znc:PUB:confirm
bind PUB Y "${scriptCommandPrefix}Deny" znc:PUB:deny
bind PUB Y "${scriptCommandPrefix}DelUser" znc:PUB:delUser
bind PUB Y "${scriptCommandPrefix}ListUnconfirmedUsers" znc:PUB:listUnconfirmed
bind PUB Y "${scriptCommandPrefix}LUU" znc:PUB:listUnconfirmed
bind PUB - "${scriptCommandPrefix}help" znc:PUB:help

## private binds --------------------------------------------------------------
bind MSG - "Request" znc:MSG:request
bind MSG Y "Confirm" znc:MSG:confirm
bind MSG Y "Deny" znc:MSG:deny
bind MSG Y "DelUser" znc:MSG:delUser
bind MSG Y "ListUnconfirmedUsers" znc:MSG:listUnconfirmed
bind MSG Y "LUU" znc:MSG:listUnconfirmed
bind MSG - "help" znc:MSG:help

## debug binds ----------------------------------------------------------------
if {$scriptdebug} {
	bind PUB n "!test" debug:helpfunction:testchan
	bind MSG n "test" debug:helpfunction:test
}


### End of Script -------------------------------------------------------------
putlog "$scriptname version $scriptversion loaded"
