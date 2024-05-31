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

set CLASS=org.apache.hive.common.util.HiveVersionInfo
set HIVE_OPTS=

if [%1]==[version_help] goto :version_help

shift
shift

set JAR=%1
pushd %HIVE_LIB%
for /f %%a IN ('dir /b hive-exec-*.jar') do (
	if not defined JAR (
		set JAR=%HIVE_LIB%\%%a
	) else (
		if exist %HIVE_LIB%\%1 (
			set JAR=%HIVE_LIB%\%1
		) else (
			echo %1 doesnot exist in Hive libarary path
			goto :EOF
		)
	)
)
popd


:version
	call %HIVE_BIN_PATH%\ext\util\execHiveCmd.cmd %JAR% %CLASS%
goto :EOF

:version_help
	echo Shows version information of hive jars
	echo ./hive --version [hiveJar]
goto :EOF