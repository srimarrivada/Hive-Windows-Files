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

SET CLASS=org.apache.hive.hplsql.Hplsql

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
for /f %%a IN ('dir /b hive-hplsql-*.jar') do (
  set CLASSPATH=%CLASSPATH%;%HIVE_HOME%\lib\%%a
)
for /f %%a IN ('dir /b antlr4-runtime-*.jar') do (
  set CLASSPATH=%CLASSPATH%;%HIVE_HOME%\lib\%%a
)

popd

if [%1]==[hplsql_help] goto :hplsql_help

:hplsql
	shift
	shift
	shift

	set PARAMS=
	
	:ReadParams
		if "%1" == "" goto end
		set PARAMS=%PARAMS% %1
		shift
		goto ReadParams

	:end

	CALL %JAVA_HOME%\bin\java %JAVA_HEAP_MAX% %HADOOP_OPTS% -classpath %CLASSPATH% %CLASS% %PARAMS%
goto :EOF

:hplsql_help
	goto :hplsql --help
goto :EOF

endlocal
