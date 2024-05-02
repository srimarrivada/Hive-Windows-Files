@echo off
@rem Licensed to the Apache Software Foundation (ASF) under one or more
@rem contributor license agreements.  See the NOTICE file distributed with
@rem this work for additional information regarding copyright ownership.
@rem The ASF licenses this file to You under the Apache License, Version 2.0
@rem (the License); you may not use this file except in compliance with
@rem the License.  You may obtain a copy of the License at
@rem
@rem     http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an AS IS BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.

set CLASS=org.apache.orc.tools.FileDump
set HIVE_OPTS=
set HADOOP_CLASSPATH=

pushd %HIVE_LIB%
for /f %%a IN ('dir /b hive-exec-*.jar') do (
	set JAR=%HIVE_LIB%\%%a
)
popd

if [%1]==[orcfiledump_help] goto :orcfiledump_help

:orcfiledump
	call %HIVE_BIN_PATH%\ext\util\execHiveCmd.cmd %JAR% %CLASS%
goto :EOF

:orcfiledump_help
	echo usage ./hive orcfiledump [-h] [-j] [-p] [-t] [-d] [-r ^<col_ids^>] [--recover] [--skip-dump] [--backup-path ^<new-path^>] ^<path_to_orc_file_or_directory^>
	echo. 
	echo   --json (-j)                 Print metadata in JSON format
	echo   --pretty (-p)               Pretty print json metadata output
	echo   --timezone (-t)             Print writer's time zone
	echo   --data (-d)                 Should the data be printed
	echo   --rowindex (-r) ^<col_ids^> Comma separated list of column ids for which row index should be printed
	echo   --recover                   Recover corrupted orc files generated by streaming
	echo   --skip-dump                 Used along with --recover to directly recover files without dumping
	echo   --backup-path ^<new_path^>  Specify a backup path to store the corrupted files (default: /tmp)
	echo   --help (-h)                 Print help message
goto :EOF