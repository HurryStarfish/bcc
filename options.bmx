SuperStrict

Const version:String = "0.10"

Const BUILDTYPE_APP:Int = 0
Const BUILDTYPE_MODULE:Int = 1

Const APPTYPE_NONE:Int = 0
Const APPTYPE_CONSOLE:Int = 1
Const APPTYPE_GUI:Int = 2

' buildtype
'    module
'    app
Global opt_buildtype:Int = BUILDTYPE_APP
' modulename
'    name of the module to build
Global opt_modulename:String
' arch
'    x86
'    ppc
'    x64
'    arm
Global opt_arch:String
' platform
'    win32
'    macos
'    linux
Global opt_platform:String
' framework
Global opt_framework:String
' filename
'    the base filename for app/module to compile against
Global opt_filename:String
' outfile
'    full path to the outputfile (excluding final extension - there will be a .h, .c and .i generated)
Global opt_outfile:String
' apptype
'    console
'    gui
Global opt_apptype:Int = APPTYPE_NONE
' debug
Global opt_debug:Int = True
' threaded
Global opt_threaded:Int = False
' release
Global opt_release:Int = False
' quiet
Global opt_quiet:Int = False
' verbose
Global opt_verbose:Int = False
' ismain
'    this is the main file for either the module, or the application.
Global opt_ismain:Int = False
' issuperstrict
'
Global opt_issuperstrict:Int = False

Global opt_filepath:String

Function CmdError(details:String = Null, fullUsage:Int = False)
	Local s:String = "Compile Error"
	If details Then
		s:+ ": " + details
	End If
	s:+ "~n"
	
	's:+ Usage(fullUsage)
	
	Throw s
End Function

Function ParseArgs:String[](args:String[])

	DefaultOptions()
	
	Local count:Int

	While count < args.length
	
		Local arg:String = args[count]
		
		If arg[..1] <> "-" Then
			Exit
		End If
		
		Select arg[1..]
			Case "q"
				opt_quiet=True
			Case "v"
				opt_verbose=True
			Case "r"
				opt_debug=False
				opt_release=True
			Case "h"
				opt_threaded=True
			Case "g"
				count:+1
				If count = args.length Then
					CmdError "Command line error - Missing arg for '-g'"
				End If
				opt_arch = args[count].ToLower()
			Case "m"
				count:+1
				If count = args.length Then
					CmdError "Command line error - Missing arg for '-m'"
				End If
				opt_buildtype = BUILDTYPE_MODULE
				opt_modulename = args[count].ToLower()
			Case "o"
				count:+1
				If count = args.length Then
					CmdError "Command line error - Missing arg for '-o'"
				End If
				opt_outfile = args[count]
			Case "t"
				count:+1
				If count = args.length Then
					CmdError "Command line error - Missing arg for '-t'"
				End If
				Local apptype:String = args[count].ToLower()
				Select apptype
					Case "console"
						opt_apptype = APPTYPE_CONSOLE
					Case "gui"
						opt_apptype = APPTYPE_GUI
					Default
						CmdError "Command line error - Invalid app type '" + opt_apptype + "'"
				End Select
			Case "f"
				count:+1
				If count = args.length Then
					CmdError "Command line error - Missing arg for '-f'"
				End If
				opt_framework = args[count]
		End Select
	
		count:+ 1
	Wend
	
	If opt_buildtype = BUILDTYPE_MODULE Then
		opt_apptype = APPTYPE_NONE
	End If

	Return args[count..]

End Function

Function DefaultOptions()
?x86
	opt_arch = "x86"
?ppc
	opt_arch = "ppc"
?x64
	opt_arch = "x64"
?arm
	opt_arch = "arm"
?

?win32
	opt_platform = "win32"
?macos
	opt_platform = "macos"
?linux
	opt_platform = "linux"
?
End Function

