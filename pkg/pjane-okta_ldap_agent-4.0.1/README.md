# README #
--
This module contains everything needed to install, configure & start Okta LDAP Agent 05.03.10 service in Linux

### Files ###
```
├── README.md
├── files
├── manifests
│   └── init.pp
└── templates
    ├── InstallOktaLDAPAgent.erb
        └── OktaLDAPAgent.erb
```

### What's is OktaLDAPAgent? ###
Okta connects any person with any application on any device.
It's an enterprise-grade, identity management service, built for the cloud, but compatible with many on-premises applications. With Okta, IT can manage any employee's access to any application or device. Okta runs in the cloud, on a secure, reliable, extensively audited platform, which integrates deeply with on-premises applications, directories, and identity management systems.

More info: 

* [https://support.okta.com/help/Documentation/Knowledge_Article/What-is-Okta] 
* [https://support.okta.com/help/Documentation/Knowledge_Article/87604166-LDAP-Agent-Deployment-Guide#InstallationSummary] 

## But, how it works? ###
![screenshot](https://support.okta.com/help/servlet/rtaImage?eid=ka02A000000XdJX&feoid=00NF000000Cl6R6&refid=0EMF0000000Tb99)

## Using the module ##
        1. Just add this moodule to any role your desired machines sould match. 
        2. Edit manifests/init.pp in order to put the correct values into the variables.


### Dependencies ###
```
/bin/bash
/bin/sh
ld-linux-x86-64.so.2()(64bit)
ld-linux-x86-64.so.2(GLIBC_2.3)(64bit)
libGL.so.1()(64bit)
libX11.so.6()(64bit)
libXext.so.6()(64bit)
libXi.so.6()(64bit)
libXrender.so.1()(64bit)
libXtst.so.6()(64bit)
libXxf86vm.so.1()(64bit)
libasound.so.2()(64bit)
libasound.so.2(ALSA_0.9)(64bit)
libasound.so.2(ALSA_0.9.0rc4)(64bit)
libatk-1.0.so.0()(64bit) *
libc.so.6(GLIBC_2.11)(64bit)
libcairo.so.2()(64bit)
libdl.so.2()(64bit)
libdl.so.2(GLIBC_2.2.5)(64bit)
libfontconfig.so.1()(64bit)
libfreetype.so.6()(64bit)
libgcc_s.so.1()(64bit)
libgcc_s.so.1(GCC_3.0)(64bit)
libgcc_s.so.1(GCC_3.3)(64bit)
libgcc_s.so.1(GCC_4.2.0)(64bit)
libgdk-x11-2.0.so.0()(64bit) * 
libgdk_pixbuf-2.0.so.0()(64bit) * 
libgio-2.0.so.0()(64bit)
libglib-2.0.so.0()(64bit)
libgmodule-2.0.so.0()(64bit)
libgobject-2.0.so.0()(64bit)
libgthread-2.0.so.0()(64bit)
libgtk-x11-2.0.so.0()(64bit)
libm.so.6()(64bit)
libm.so.6(GLIBC_2.2.5)(64bit)
libnsl.so.1()(64bit)
libpango-1.0.so.0()(64bit)
libpangocairo-1.0.so.0()(64bit)
libpangoft2-1.0.so.0()(64bit)
libpthread.so.0()(64bit)
libpthread.so.0(GLIBC_2.2.5)(64bit)
libpthread.so.0(GLIBC_2.3.2)(64bit)
libpthread.so.0(GLIBC_2.3.3)(64bit)
librt.so.1()(64bit)
libstdc++.so.6()(64bit)
libstdc++.so.6(CXXABI_1.3)(64bit)
libstdc++.so.6(GLIBCXX_3.4)(64bit)
libstdc++.so.6(GLIBCXX_3.4.11)(64bit)
libstdc++.so.6(GLIBCXX_3.4.9)(64bit)
libxml2.so.2()(64bit)
libxml2.so.2(LIBXML2_2.4.30)(64bit)
libxml2.so.2(LIBXML2_2.6.0)(64bit)
libxml2.so.2(LIBXML2_2.6.6)(64bit)
libxslt.so.1()(64bit)
libxslt.so.1(LIBXML2_1.0.11)(64bit)
libxslt.so.1(LIBXML2_1.0.22)(64bit)
libxslt.so.1(LIBXML2_1.0.24)(64bit)
libxslt.so.1(LIBXML2_1.1.9)(64bit)
```

All this dependences of course have more dependences like libpng14, and so on but dependences marked with "*" are the problematic ones with Amazon Linux. (At the bottom of this documentation you will find more info about tested & supported Linux distributions)


### Install & configure information ###

The puppet profile will install & configure an already previously registered node agent in Okta. For the moment there's no way to automate this process, so with a node agent registered we just install & configure with puppet the RPM and put the necessary cfg files with it's proper registration keys and tokens. 
Just keep reading to understand how the registration process works.

* Post-Configuration or node registration after install the agent it's a little bit tricky: 

	1. Install package & configure ( puppet should do it ) 
	2. To register **a new** node in Okta: 
		
		2.1. After the pkg has been installed you must execute: 

		```
		/opt/Okta/OktaLDAPAgent/scripts/configure_agent.sh
		```
		
		Which is going to ask you for LDAP server configuration like, hostname/IP, admin access credentials, port, SSL, and so on.
		
		2.2. After that the script launches the agent and prompt you to visit an URL like this: 

		```
		https://whatever.okta.com/oauth2/auth?code=7hypd8ow
		```	  
		Although the official documentation says that you must visit this link from the computer where you are installing the agent it's not true. You can do it from everywhere. Just copy and paste the link in a browser tab and login to Okta with your **admin account.** and follow the instructions on the screen.
		
		NOTE: This access URL/Token is only valid during a certain period of time ( minutes/hours I think ) 
	
	3. After that your node agent is configured and registered in Okta and ready to query our LDAP server(s).



	And this is what we do with puppet: 
	
	1. Install & configure the package
	2. Put the previously generated config files into: 

	```
	/opt/Okta/OktaLDAPAgent/conf
	``` 
        3. Start the service
	
## Additional notes ##

Tested on: 

* Debian: OK
* Ubuntu: OK
* Centos 7: OK
* RH: OK
* Amazon Linux: KO (Reason: Dependency Hell)

-
* Launch time avg: 8,7 min. (after instance launch)


## Troubleshooting ##

If you have some problems or misconfiguration issues, take a look to the log files at: 

```
tail -f /opt/Okta/OktaLDAPAgent/conf/*.log
```
