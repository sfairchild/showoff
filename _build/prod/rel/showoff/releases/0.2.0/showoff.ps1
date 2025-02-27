# Set DEBUG_BOOT to output verbose debugging info during execution
if ($Env:DEBUG_BOOT -ne $null) {
    set-psdebug -Trace 1
}

# Given a string, ensures the string is quoted
function Ensure-Quoted {
    param($String = $(throw "You must provide -String to EnsureQuoted"))
    
    if ($String -match "^`".*`"$") {
        # Already quoted
        $String
    } else {
        # Escape quotes, except when already escaped
        $escaped = $String -replace '(?<![\\])"','\"' 
        # Then quote the entire argument
        "`"{0}`"" -f $escaped
    }
}

# Given a string representing arguments for an executable
# Convert that string into an argument vector similar to how bash would
function String-To-Argv {
    param($String = $(throw "You must provide -String to String-To-Argv"))
    
    $quote = $false
    $last = $null
    $String -split {
        $q = get-variable -Name "quote" -Scope 1 | select -Expand "Value"
        $l = get-variable -Name "last" -Scope 1 | select -Expand "Value"
        $split = $false
        switch ($_) {
            "`"" {  
                if ($q -and ($l -ne "\")) {
                    $q = false
                    set-variable -Name "quote" -Value $false -Scope 1
                }
                if (-not $q) {
                    $q = true
                    set-variable -Name "quote" -Value $true -Scope 1
                }
            }
            " " {
                if (-not $q) {
                    $split = $true
                }
            }
        }
        set-variable -Name "last" -Value $_ -Scope 1
        $split
    }
}

$rel_name = "showoff"
$rel_vsn = "0.2.0"
$script_dir = split-path -parent $PSCommandPath
$rel_dir = $script_dir
$releases_dir = split-path -parent $rel_dir
$release_root_dir = split-path -parent $releases_dir

# Name of the release
$Env:REL_NAME = $rel_name
# Current version of the release
$Env:REL_VSN = $rel_vsn
# Options passed to erl
$Env:ERL_OPTS = ""
# Current version of ERTS being used
# If this is not present/unset, it will be detected
$Env:ERTS_VSN = "10.5"
$Env:DISTILLERY_VSN = "2.1.1"
$Env:ESCRIPT_NAME = $PSCommandPath
# Parent directory of this script
$Env:SCRIPT_DIR = $script_dir
# Root directory of all releases
$Env:RELEASE_ROOT_DIR = $release_root_dir
# Directory containing the current version of this release
$Env:REL_DIR = $rel_dir
# The lib directory for this release
$Env:REL_LIB_DIR = (join-path $release_root_dir "lib")
# The location of consolidated protocols
$Env:CONSOLIDATED_DIR = (join-path $Env:REL_LIB_DIR (join-path ("{0}-{1}" -f $rel_name,$rel_vsn) "consolidated"))
# The location of generated files and other mutable state
if ($Env:RELEASE_MUTABLE_DIR -eq $null) {
    $Env:RELEASE_MUTABLE_DIR = (join-path $release_root_dir "var")
}
# When stdout is piped to a file, this is the directory those files will
# be stored in. defaults to /log in the release root directory
$Env:RUNNER_LOG_DIR = (join-path $Env:RELEASE_MUTABLE_DIR "log")
# Path to start_erl.data
$Env:START_ERL_DATA = (join-path $Env:RELEASE_MUTABLE_DIR "start_erl.data")
if (-not (test-path $Env:START_ERL_DATA)) {
    copy-item -Path (join-path $releases_dir "start_erl.data") -Destination $Env:START_ERL_DATA -Force
}
# Directory containing lifecycle hook scripts
$Env:HOOKS_DIR = (join-path $Env:REL_DIR "hooks")
# Allow override of where to read configuration from
# By default it's RELEASE_ROOT_DIR
if ($Env:RELEASE_CONFIG_DIR -eq $null) {
    $Env:RELEASE_CONFIG_DIR = $Env:RELEASE_ROOT_DIR
}

# Make sure important directories exist
if (($Env:RELEASE_READ_ONLY -eq $null) -and (-not (test-path $Env:RELEASE_MUTABLE_DIR -PathType Container))) {
    new-item $Env:RELEASE_MUTABLE_DIR -ItemType Directory -ErrorAction SilentlyContinue
    $warning_msg = "Files in this directory are regenerated frequently, edits will be lost"
    set-content -Path (join-path $Env:RELEASE_MUTABLE_DIR "WARNING_README") -Value $warning_msg
}
if (($Env:RELEASE_READ_ONLY -eq $null) -and (-not (test-path $Env:RUNNER_LOG_DIR -PathType Container))) {
    new-item $Env:RUNNER_LOG_DIR -ItemType Directory -ErrorAction SilentlyContinue
}

# The location of builtin command scripts
$libexec_dir = (join-path $script_dir (join-path libexec win))

. (join-path $libexec_dir "logger.ps1")
. (join-path $libexec_dir "erts.ps1")
. (join-path $libexec_dir "helpers.ps1")
. (join-path $libexec_dir "config.ps1")

# Make the release root our working directory
cd $release_root_dir

$command_name = $null
if ($args.Length -gt 0) {
    $command_name = $args[0]
    if ($args.Length -gt 1) {
        $args = $args[1..($args.Length-1)]
    }
}

# We export this so that custom tasks in Elixir
# which need to know how they were invoked can
# check this environment variable.
$Env:DISTILLERY_TASK = $command_name

# All commands are loaded from the currently active release
$command_dir = (join-path $script_dir (join-path libexec (join-path commands win)))
$user_command_dir = (join-path $script_dir (join-path commands win))
if ($command_name -eq $null) {
    $command_name = "help"
}
$command_path = (join-path $command_dir ("{0}.ps1" -f $command_name))
$user_command_path = (join-path $user_command_dir ("{0}.ps1" -f $command_name))

# Handle aliases
switch ($command_name) {
    # upgrade/downgrade are aliases for install
    "upgrade"   { . (join-path $command_dir "install.ps1") }
    "downgrade" { . (join-path $command_dir "install.ps1") }
    # All other commands are built dynamically
    default {
        if (test-path $command_path -PathType Leaf) {
            configure-release
            . $command_path @args
        } elseif (test-path $user_command_path -PathType Leaf) {
            require-cookie
            . $user_command_path @args
        } else {
            log-warning ("The command '{0}' was not found" -f $command_name)
            . (join-path $command_dir "help.ps1") @args
        }
    }
}
