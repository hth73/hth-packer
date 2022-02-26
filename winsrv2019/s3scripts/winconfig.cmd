@ECHO OFF
CLS

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Name:    IIS Configuration
:: Author:  Helmut Thurnhofer
:: Create:  16 November 2021
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@ECHO :: import Server Configuration Basics with a RegFile :::::::::::::::::::::
@ECHO OFF
:: Disable Auto Reboot and set PATH variable
::
reg import C:\tools\winconfig\winconfig.reg


@ECHO :: Unlocking Sections and set File Extensions in IIS  ::::::::::::::::::::
@ECHO OFF
::
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/rewrite/allowedServerVariables
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/rewrite/globalRules
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/rewrite/outboundRules
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/rewrite/providers
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/rewrite/rewriteMaps
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/rewrite/rules
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/authentication/anonymousAuthentication
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/authentication/basicAuthentication
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/authentication/clientCertificateMappingAuthentication
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/authentication/digestAuthentication
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/authentication/iisClientCertificateMappingAuthentication
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/authentication/windowsAuthentication
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/access
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/applicationDependencies
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/authorization
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/dynamicIpSecurity
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/ipSecurity
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/isapiCgiRestriction
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/requestFiltering
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/tracing/traceFailedRequests
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/tracing/traceProviderDefinitions
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/webdav/authoring
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/webdav/authoringRules
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/webdav/globalSettings
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/applicationInitialization
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/asp
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/aspNetCore
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/caching
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/cgi
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/defaultDocument
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/directoryBrowse
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/fastCgi
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/globalModules
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/handlers
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/httpCompression
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/httpErrors
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/httpLogging
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/httpProtocol
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/httpRedirect
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/httpTracing
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/isapiFilters
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/modules
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/odbcLogging
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/serverRuntime
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/serverSideInclude
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/staticContent
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/urlCompression
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/validation
"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/webSocket

"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.nupkg',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.json',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.csv',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.png',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.svg',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.txt',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.ttf',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.eot',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.otf',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.woff',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.woff2',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.html',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.js',allowed='true']
"%windir%\system32\inetsrv\appcmd.exe" set config /section:system.webServer/security/requestfiltering /+fileExtensions.[fileextension='.css',allowed='true']
