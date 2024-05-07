@echo off
@rem Licensed to the Apache Software Foundation (ASF) under one or more
@rem contributor license agreements.  See the NOTICE file distributed with
@rem this work for additional information regarding copyright ownership.
@rem The ASF licenses this file to You under the Apache License, Version 2.0
@rem (the "License"); you may not use this file except in compliance with
@rem the License.  You may obtain a copy of the License at
@rem
@rem     http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
SetLocal EnableDelayedExpansion

pushd %CD%\..
if not defined HIVE_HOME (
  set HIVE_HOME=%CD%
)
popd

if "%HADOOP_BIN_PATH:~-1%" == "\" (
  set HADOOP_BIN_PATH=%HADOOP_BIN_PATH:~0,-1%
)

if not defined JAVA_HOME (
  echo Error: JAVA_HOME is not set.
  goto :eof
)

@rem get the hadoop envrionment
if not exist %HADOOP_HOME%\libexec\hadoop-config.cmd (
  @echo +================================================================+
  @echo ^|      Error: HADOOP_HOME is not set correctly                 ^|
  @echo +----------------------------------------------------------------+
  @echo ^| Please set your HADOOP_HOME variable to the absolute path of ^|
  @echo ^| the directory that contains \libexec\hadoop-config.cmd           ^|
  @echo +================================================================+
  exit /b 1
)
@rem supress the HADOOP_HOME warnings in 1.x.x
set HADOOP_HOME_WARN_SUPPRESS=true
call %HADOOP_HOME%\libexec\hadoop-config.cmd


@rem include only the beeline client jar and its dependencies
pushd %HIVE_HOME%\lib
for /f %%a IN ('dir /b hive-beeline-**.jar') do (
  set BeelineJarPath=%HIVE_HOME%\lib\%%a
)
for /f %%a IN ('dir /b super-csv-**.jar') do (
  set SuperCsvJarPath=%HIVE_HOME%\lib\%%a
)
for /f %%a IN ('dir /b jline-**.jar') do (
  set JlineJarPath=%HIVE_HOME%\lib\%%a
)

popd

set HADOOP_CLASSPATH=%HADOOP_CLASSPATH%;%HIVE_CONF_DIR%;%BeelineJarPath%;%SuperCsvJarPath%;%JlineJarPath%
set HADOOP_CLIENT_OPTS=%HADOOP_CLIENT_OPTS% -Dlog4j.configurationFile=beeline-log4j2.properties

if [%1]==[beeline_help] goto :beeline_help

:beeline
	set CLASS=org.apache.hive.beeline.BeeLine
	call %HIVE_BIN_PATH%\ext\util\execHiveCmd.cmd %BeelineJarPath% %CLASS%
goto :EOF

:beeline_help
	goto :beeline --help
goto :EOF

endlocal
