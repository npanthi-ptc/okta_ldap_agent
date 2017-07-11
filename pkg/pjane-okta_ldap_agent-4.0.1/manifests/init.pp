# Class:: profile_okta
#
#
class profile_okta (

  # var def for /opt/Okta/OktaLDAPAgent/conf/InstallOktaLDAPAgent.conf
  ####################################################################

  String            $orgUrl       = 'https://yourcompany.okta.com',
  String            $ldapHost     = '1.2.3.4',

  String            $ldapAdminDN  = 'cn=ldapadm,dc=yourcompany,dc=com',
  String            $ldapPort     = '389',
  String            $baseDN       = 'dc=yourcompany,dc=com',

  Boolean           $proxyEnabled = false,
  Optional[String]  $proxyHost    = '',
  Optional[String]  $proxyPort    = '',
  Optional[String]  $proxyUser    = '',
  String            $sslPinningEnabled  = 'true',

  # var def for /opt/Okta/OktaLDAPAgent/conf/OktaLDAPAgent.conf
  #############################################################

  String						$agentId      = 'xxxxXXxXxxXXxxXXxxXXx',
  Optional[String]	$instanceId   = '',
  String						$token        = 'xxxXXxXXxXxXxXXxXxxXXxxxXxXxxXxxxxxXxxxx',
  String						$ldapAdminPassword = '**************',
  String						$ldapDomainId = 'xxXxXxXxXxXxXxxXxxXxxX',
  String						$ldapUseSSL   = 'false',          # maybe this should be 'false'
  String						$ldapSSLPort  = '0',
  String						$propertyKey  = 'xxXxXXxXxxxxXxxxxxXxxXXXXXXXXXXXXXXXXxxxxxxxxxXXxxxxxxxx',
  String						$connectionHealthCheckFrequencyInMinutes  = '0',
  String						$memoryTrackFrequencyInMinutes            = '0',
  String						$threadDumpFrequencyInMinutes             = '0',
  String						$ldapSearchPageSize                       = '500',

){

	 package{'OktaLDAPAgent-05.03.10':
		ensure => 'installed',
	 }

	 file { '/opt/Okta/OktaLDAPAgent/conf/InstallOktaLDAPAgent.conf':
	 	ensure  => file,
	 	mode    => '0644',
		owner   => 'OktaLDAPService',
    #source => 'puppet:///modules/profile_okta/InstallOktaLDAPAgent.conf',
    content => template("${module_name}/InstallOktaLDAPAgent.erb")
	 }


	 file { '/opt/Okta/OktaLDAPAgent/conf/OktaLDAPAgent.conf':
	 	ensure  => file,
	 	mode    => '0644',
		owner   => 'OktaLDAPService',
    #source => 'puppet:///modules/profile_okta/OktaLDAPAgent.conf',
    content => template("${module_name}/OktaLDAPAgent.erb")
	 }


	 service { 'OktaLDAPAgent':
	 	ensure => running,
	 	enable => true,
	 	hasrestart => true,
	 	hasstatus  => true,
		require	=> Package['OktaLDAPAgent-05.03.10'],
	 }

} # Class:: profile_okta
