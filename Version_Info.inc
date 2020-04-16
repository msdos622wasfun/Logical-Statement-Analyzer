#RESOURCE VERSIONINFO

#IF %DEF(%BETAVERSION)
    #RESOURCE FILEFLAGS %VS_FF_PRERELEASE
#ELSE
    #RESOURCE FILEFLAGS 0
#ENDIF

#RESOURCE FILEVERSION 2, 0, 0, 0
#RESOURCE PRODUCTVERSION 2, 0, 0, 0

#RESOURCE STRINGINFO "0409", "04B0"

#RESOURCE VERSION$ "CompanyName",      "Erich Kohl"
#RESOURCE VERSION$ "FileDescription",  "Logical Statement Analyzer"
#RESOURCE VERSION$ "FileVersion",      "02.00.0000"
#RESOURCE VERSION$ "InternalName",     "Logical Statement Analyzer"
#RESOURCE VERSION$ "OriginalFilename", "LSA.EXE"
#RESOURCE VERSION$ "LegalCopyright",   "Copyleft 2020 by Erich Kohl"
#RESOURCE VERSION$ "ProductName",      "Logical Statement Analyzer"
#RESOURCE VERSION$ "ProductVersion",   "02.00.0000"
#RESOURCE VERSION$ "Comments",         "Hope you enjoy this program."
