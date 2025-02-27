{application,mix,
             [{applications,[kernel,stdlib,elixir]},
              {description,"mix"},
              {modules,['Elixir.Mix','Elixir.Mix.CLI',
                        'Elixir.Mix.Compilers.Elixir',
                        'Elixir.Mix.Compilers.Erlang',
                        'Elixir.Mix.Compilers.Test','Elixir.Mix.Config',
                        'Elixir.Mix.Dep','Elixir.Mix.Dep.Converger',
                        'Elixir.Mix.Dep.ElixirSCM','Elixir.Mix.Dep.Fetcher',
                        'Elixir.Mix.Dep.Loader','Elixir.Mix.Dep.Lock',
                        'Elixir.Mix.Dep.Umbrella',
                        'Elixir.Mix.ElixirVersionError','Elixir.Mix.Error',
                        'Elixir.Mix.Generator','Elixir.Mix.Hex',
                        'Elixir.Mix.InvalidTaskError','Elixir.Mix.Local',
                        'Elixir.Mix.Local.Installer',
                        'Elixir.Mix.NoProjectError','Elixir.Mix.NoTaskError',
                        'Elixir.Mix.Project','Elixir.Mix.ProjectStack',
                        'Elixir.Mix.PublicKey','Elixir.Mix.Rebar',
                        'Elixir.Mix.Release','Elixir.Mix.RemoteConverger',
                        'Elixir.Mix.SCM','Elixir.Mix.SCM.Git',
                        'Elixir.Mix.SCM.Path','Elixir.Mix.Shell',
                        'Elixir.Mix.Shell.IO','Elixir.Mix.Shell.Process',
                        'Elixir.Mix.Shell.Quiet','Elixir.Mix.State',
                        'Elixir.Mix.Task','Elixir.Mix.Task.Compiler',
                        'Elixir.Mix.Task.Compiler.Diagnostic',
                        'Elixir.Mix.Tasks.App.Start',
                        'Elixir.Mix.Tasks.App.Tree',
                        'Elixir.Mix.Tasks.Archive',
                        'Elixir.Mix.Tasks.Archive.Build',
                        'Elixir.Mix.Tasks.Archive.Check',
                        'Elixir.Mix.Tasks.Archive.Install',
                        'Elixir.Mix.Tasks.Archive.Uninstall',
                        'Elixir.Mix.Tasks.Clean','Elixir.Mix.Tasks.Cmd',
                        'Elixir.Mix.Tasks.Compile',
                        'Elixir.Mix.Tasks.Compile.All',
                        'Elixir.Mix.Tasks.Compile.App',
                        'Elixir.Mix.Tasks.Compile.Elixir',
                        'Elixir.Mix.Tasks.Compile.Erlang',
                        'Elixir.Mix.Tasks.Compile.Leex',
                        'Elixir.Mix.Tasks.Compile.Protocols',
                        'Elixir.Mix.Tasks.Compile.Xref',
                        'Elixir.Mix.Tasks.Compile.Yecc',
                        'Elixir.Mix.Tasks.Deps','Elixir.Mix.Tasks.Deps.Clean',
                        'Elixir.Mix.Tasks.Deps.Compile',
                        'Elixir.Mix.Tasks.Deps.Get',
                        'Elixir.Mix.Tasks.Deps.Loadpaths',
                        'Elixir.Mix.Tasks.Deps.Precompile',
                        'Elixir.Mix.Tasks.Deps.Tree',
                        'Elixir.Mix.Tasks.Deps.Unlock',
                        'Elixir.Mix.Tasks.Deps.Update','Elixir.Mix.Tasks.Do',
                        'Elixir.Mix.Tasks.Escript',
                        'Elixir.Mix.Tasks.Escript.Build',
                        'Elixir.Mix.Tasks.Escript.Install',
                        'Elixir.Mix.Tasks.Escript.Uninstall',
                        'Elixir.Mix.Tasks.Format','Elixir.Mix.Tasks.Help',
                        'Elixir.Mix.Tasks.Iex','Elixir.Mix.Tasks.Loadconfig',
                        'Elixir.Mix.Tasks.Loadpaths','Elixir.Mix.Tasks.Local',
                        'Elixir.Mix.Tasks.Local.Hex',
                        'Elixir.Mix.Tasks.Local.PublicKeys',
                        'Elixir.Mix.Tasks.Local.Rebar','Elixir.Mix.Tasks.New',
                        'Elixir.Mix.Tasks.Profile.Cprof',
                        'Elixir.Mix.Tasks.Profile.Eprof',
                        'Elixir.Mix.Tasks.Profile.Fprof',
                        'Elixir.Mix.Tasks.Release',
                        'Elixir.Mix.Tasks.Release.Init',
                        'Elixir.Mix.Tasks.Run','Elixir.Mix.Tasks.Test',
                        'Elixir.Mix.Tasks.Test.Cover',
                        'Elixir.Mix.Tasks.WillRecompile',
                        'Elixir.Mix.Tasks.Xref','Elixir.Mix.TasksServer',
                        'Elixir.Mix.Utils']},
              {vsn,"1.9.1"},
              {registered,['Elixir.Mix.State','Elixir.Mix.TasksServer',
                           'Elixir.Mix.ProjectStack']},
              {mod,{'Elixir.Mix',[]}},
              {env,[{colors,[]}]}]}.
